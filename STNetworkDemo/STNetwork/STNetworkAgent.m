//
//  STNetworkAgent.m
//  test
//
//  Created by steven on 2017/7/26.
//  Copyright © 2017年 ist. All rights reserved.
//

#import "STNetworkAgent.h"
#import "STNetworkConfig.h"
#import "STBaseRequest.h"
#import <pthread/pthread.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface STNetworkAgent()
{
    AFHTTPSessionManager *_manager;
    STNetworkConfig *_config;
    AFJSONResponseSerializer *_jsonResponseSerializer;
    AFXMLParserResponseSerializer *_xmlParserResponseSerialzier;
    //这里是泛型表示直接声明存储的数据类型
    NSMutableDictionary<NSNumber *,__kindof STBaseRequest *> *_requestsRecord;
    dispatch_queue_t _processingQueue;
    pthread_mutex_t _lock;
    NSIndexSet *_allStatusCodes;
}

@end
@implementation STNetworkAgent
+(STNetworkAgent *)sharedAgent
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _config = [STNetworkConfig sharedConfig];
        _requestsRecord = [NSMutableDictionary dictionary];
        _processingQueue = dispatch_queue_create("com.ist.networkagent.processing", DISPATCH_QUEUE_CONCURRENT);
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        pthread_mutex_init(&_lock, NULL);
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:_config.sessionConfiguration];
        _manager.securityPolicy = _config.securityPolicy;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableStatusCodes = _allStatusCodes;
        _manager.completionQueue = _processingQueue;
    }
    return self;
}

- (AFJSONResponseSerializer *)jsonResponseSerializer
{
    if (_jsonResponseSerializer) {
        _jsonResponseSerializer = [AFJSONResponseSerializer serializer];
        _jsonResponseSerializer.acceptableStatusCodes = _allStatusCodes;
    }
    return _jsonResponseSerializer;
}

- (AFXMLParserResponseSerializer *)xmlParserResponseSerialzier
{
    if (_xmlParserResponseSerialzier) {
        _xmlParserResponseSerialzier = [AFXMLParserResponseSerializer serializer];
        _xmlParserResponseSerialzier.acceptableStatusCodes = _allStatusCodes;
    }
    return _xmlParserResponseSerialzier;
}
#pragma mark - requests
- (void)addRequest:(STBaseRequest *)request
{
    if(!request)
        return;
    NSError * __autoreleasing requestSerializationError = nil;
    request.requestTask = [self sessionTaskForRequest:request error:&requestSerializationError];
    if (requestSerializationError || !request.requestTask) {
        [self requestDidFailWithRequest:request error:requestSerializationError];
        return;
    }
    
    // Set request task priority
    // !!Available on iOS 8 +
//    if ([request.requestTask respondsToSelector:@selector(priority)]) {
//        switch (request.requestPriority) {
//            case YTKRequestPriorityHigh:
//                request.requestTask.priority = NSURLSessionTaskPriorityHigh;
//                break;
//            case YTKRequestPriorityLow:
//                request.requestTask.priority = NSURLSessionTaskPriorityLow;
//                break;
//            case YTKRequestPriorityDefault:
//                /*!!fall through*/
//            default:
//                request.requestTask.priority = NSURLSessionTaskPriorityDefault;
//                break;
//        }
//    }
    
    [self addRequestToRecord:request];
    [request.requestTask resume];
}

- (void)addRequestToRecord:(__kindof STBaseRequest *)request {
    pthread_mutex_lock(&_lock);
    _requestsRecord[@(request.requestTask.taskIdentifier)] = request;
    pthread_mutex_unlock(&_lock);
}

- (void)removeRequestFromRecord:(__kindof STBaseRequest *)request {
    pthread_mutex_lock(&_lock);
    [_requestsRecord removeObjectForKey:@(request.requestTask.taskIdentifier)];
    NSLog(@"Request queue size = %zd", [_requestsRecord count]);
    pthread_mutex_unlock(&_lock);
}



- (NSURLSessionTask *)sessionTaskForRequest:(STBaseRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    STRequestMethod method = request.requestMethod;
    NSString *url = request.requestUrl;
    
    id param = request.requestArgument;
    AFConstructingBlock constructingBlock = request.constructingBlock;
    
    AFHTTPRequestSerializer *requestSerializer = [self requestSerializerForRequest:request];


    switch (method) {
        case STRequestMethodGET:
//            if (request.resumableDownloadPath) {
//                return [self downloadTaskWithDownloadPath:request.resumableDownloadPath requestSerializer:requestSerializer URLString:url parameters:param progress:request.resumableDownloadProgressBlock error:error];
//            } else {
                return [self dataTaskWithHTTPMethod:@"GET" requestSerializer:requestSerializer URLString:url parameters:param error:error];
//            }
            break;
        case STRequestMethodPOST:
            return [self dataTaskWithHTTPMethod:@"POST" requestSerializer:requestSerializer URLString:url parameters:param constructingBodyWithBlock:constructingBlock error:error];
            break;
     
    }
    return nil;
}

- (AFHTTPRequestSerializer *)requestSerializerForRequest:(STBaseRequest *)request {
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (request.requestSerializerType == STRequestSerializerTypeHTTP) {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    } else if (request.requestSerializerType == STRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = request.requestTimeoutInterval;
    
    // If api needs server username and password
//    NSArray<NSString *> *authorizationHeaderFieldArray = [request requestAuthorizationHeaderFieldArray];
//    if (authorizationHeaderFieldArray != nil) {
//        [requestSerializer setAuthorizationHeaderFieldWithUsername:authorizationHeaderFieldArray.firstObject
//                                                          password:authorizationHeaderFieldArray.lastObject];
//    }
    
    // If api needs to add custom value to HTTPHeaderField
    if (request.requestHeaderDic != nil) {
        for (NSString *httpHeaderField in request.requestHeaderDic) {
            NSString *value = request.requestHeaderDic[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    return requestSerializer;
}


- (void)requestDidFailWithRequest:(__kindof STBaseRequest *)request error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
                if (request.delegate != nil) {
            [request.delegate requestFailed:request];
        }
        if (request.failureCompletionBlock) {
            request.failureCompletionBlock(request);
        }
    });
}


#pragma mark -模拟af 为了获取NSURLSessionDataTask

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                           error:(NSError * _Nullable __autoreleasing *)error {
    return [self dataTaskWithHTTPMethod:method requestSerializer:requestSerializer URLString:URLString parameters:parameters constructingBodyWithBlock:nil error:error];
}

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                               requestSerializer:(AFHTTPRequestSerializer *)requestSerializer
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                       constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                           error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableURLRequest *request = nil;
    
    if (block) {
        request = [requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:error];
    } else {
        request = [requestSerializer requestWithMethod:method URLString:URLString parameters:parameters error:error];
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_manager dataTaskWithRequest:request
                           completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *_error) {
                               [self handleRequestResult:dataTask responseObject:responseObject error:_error];
                           }];
    
    return dataTask;
}

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    pthread_mutex_lock(&_lock);
    STBaseRequest *request = _requestsRecord[@(task.taskIdentifier)];
    pthread_mutex_unlock(&_lock);
    
    // When the request is cancelled and removed from records, the underlying
    // AFNetworking failure callback will still kicks in, resulting in a nil `request`.
    //
    // Here we choose to completely ignore cancelled tasks. Neither success or failure
    // callback will be called.
    if (!request) {
        return;
    }
    
    NSError * __autoreleasing serializationError = nil;
    
    NSError *requestError = nil;
    BOOL succeed = YES;
    request.resultObject  = responseObject;

    if ([responseObject isKindOfClass:[NSData class]]) {
        
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        request.resultStr = responseString;
        switch (request.responseSerializerType) {
            case STResponseSerializerTypeHTTP:
                // Default serializer. Do nothing.
                break;
            case STResponseSerializerTypeJSON:
                request.resultObject = [self.jsonResponseSerializer responseObjectForResponse:task.response data:responseObject error:&serializationError];
                break;
            case STResponseSerializerTypeXMLParser:
                break;
        }
    }
    if (error) {
        succeed = NO;
        requestError = error;
    } else if (serializationError) {
        succeed = NO;
        requestError = serializationError;
    }
    
    if (succeed) {
        [self requestDidSucceedWithRequest:request];
    } else {
        [self requestDidFailWithRequest:request error:requestError];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self removeRequestFromRecord:request];
        [request clearCompletionBlock];
    });
}

- (void)requestDidSucceedWithRequest:(__kindof STBaseRequest *)request {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (request.delegate != nil) {
            [request.delegate requestFinished:request];
        }
        if (request.successCompletionBlock) {
            request.successCompletionBlock(request);
        }
    });
}

#pragma mark -cancel 操作

///  Cancel a request that was previously added.
- (void)cancelRequest:(__kindof STBaseRequest *)request;
{
    [request.requestTask cancel];
    [self removeRequestFromRecord:request];
    [request clearCompletionBlock];
}

/// Cancel target's requests
- (void)cancelRequestsWithTarget:(id)target;
{
    pthread_mutex_lock(&_lock);
    NSArray *allKeys = [_requestsRecord allKeys];
    pthread_mutex_unlock(&_lock);
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            pthread_mutex_lock(&_lock);
            STBaseRequest *request = _requestsRecord[key];
            pthread_mutex_unlock(&_lock);
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            if ([request.target isEqual:target]) {
                [request stop];
            }
        }
    }

}

///  Cancel all requests that were previously added.
- (void)cancelAllRequests
{
    pthread_mutex_lock(&_lock);
    NSArray *allKeys = [_requestsRecord allKeys];
    pthread_mutex_unlock(&_lock);
    if (allKeys && allKeys.count > 0) {
        NSArray *copiedKeys = [allKeys copy];
        for (NSNumber *key in copiedKeys) {
            pthread_mutex_lock(&_lock);
            STBaseRequest *request = _requestsRecord[key];
            pthread_mutex_unlock(&_lock);
            // We are using non-recursive lock.
            // Do not lock `stop`, otherwise deadlock may occur.
            [request stop];
        }
    }
}



@end
