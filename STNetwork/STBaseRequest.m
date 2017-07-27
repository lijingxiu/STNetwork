//
//  STBaseRequest.m
//  test
//
//  Created by steven on 2017/7/26.
//  Copyright © 2017年 ist. All rights reserved.
//

#import "STBaseRequest.h"
#import "STNetworkAgent.h"
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation STBaseRequest

-(instancetype)init{
    self = [super init];
    if (self) {
        self.requestUrl = @"";
        self.requestMethod = STRequestMethodGET;
        self.requestSerializerType = STRequestSerializerTypeHTTP;
        self.requestTimeoutInterval = 30;
        self.responseSerializerType = STResponseSerializerTypeXMLParser;
        
    }
    return self;
}


- (void)setConstructingBlockWithFileData:(NSData *)fileData withFormKey:(NSString *)formKey withFileName:(NSString *)fileName withFileType:(NSString *)fileType
{
    self.constructingBlock = ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData name:formKey fileName:fileName mimeType:fileType];
    };

}



- (void)start
{
    [[STNetworkAgent sharedAgent] addRequest:self];
}
//停止请求
- (void)stop
{
    self.delegate = nil;
    [[STNetworkAgent sharedAgent] cancelRequest:self];
}
//清空回调block
- (void)clearCompletionBlock
{
    // nil out to break the retain cycle.
    self.successCompletionBlock = nil;
    self.failureCompletionBlock = nil;
}
//设置成功和失败回调
- (void)startWithCompletionBlockWithSuccess:(nullable STRequestCompletionBlock)success
                                    failure:(nullable STRequestCompletionBlock)failure
{
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
    [self start];
}

@end
