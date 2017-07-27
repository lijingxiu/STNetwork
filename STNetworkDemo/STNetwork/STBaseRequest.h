//
//  STBaseRequest.h
//  test
//
//  Created by steven on 2017/7/26.
//  Copyright © 2017年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class STBaseRequest;
///  HTTP Request method.
typedef NS_ENUM(NSInteger, STRequestMethod) {
    STRequestMethodGET = 0,
    STRequestMethodPOST
};

///  Request serializer type.
typedef NS_ENUM(NSInteger, STRequestSerializerType) {
    STRequestSerializerTypeHTTP = 0,
    STRequestSerializerTypeJSON,
};

///  Response serializer type, which determines response serialization process and
///  the type of `responseObject`.
typedef NS_ENUM(NSInteger, STResponseSerializerType) {
    /// NSData type
    STResponseSerializerTypeHTTP,
    /// JSON object type
    STResponseSerializerTypeJSON,
    /// NSXMLParser type
    STResponseSerializerTypeXMLParser,
};



@protocol AFMultipartFormData;

typedef void (^AFConstructingBlock)( id  <AFMultipartFormData> _Nullable formData);
typedef void (^AFURLSessionTaskProgressBlock)(NSProgress * _Nullable progress);
typedef void(^STRequestCompletionBlock)(__kindof STBaseRequest * _Nullable request);

@protocol STRequestDelegate <NSObject>

@optional
- (void)requestFinished:(__kindof STBaseRequest * _Nullable)request;

- (void)requestFailed:(__kindof STBaseRequest * _Nullable)request;
@end



NS_ASSUME_NONNULL_BEGIN
@interface STBaseRequest : NSObject
//请求的url
@property (nonatomic,strong,nonnull)NSString *requestUrl;
//请求方法
@property (nonatomic,assign)STRequestMethod requestMethod;

///请求参数
@property (nonatomic,strong) id requestArgument;
//需要发起请求的目标
@property (nonatomic,weak) id target;

//请求序列化类型
@property (nonatomic,assign)STRequestSerializerType requestSerializerType;
//请求结果序列化类型
@property (nonatomic,assign)STResponseSerializerType responseSerializerType;

//上传数据的block af上传的时候用
@property (nonatomic,copy,nullable)AFConstructingBlock constructingBlock;

//结果集
@property (nonatomic, strong, readwrite, nullable) id resultObject;
//返回结果字符串
@property (nonatomic, strong, readwrite, nullable) NSString *resultStr;


//超时时间
@property(nonatomic,assign) NSTimeInterval requestTimeoutInterval;

//代理
@property (nonatomic, weak, nullable) id<STRequestDelegate> delegate;
//请求成功回调
@property (nonatomic, copy, nullable) STRequestCompletionBlock successCompletionBlock;
//请求失败回调
@property (nonatomic, copy, nullable) STRequestCompletionBlock failureCompletionBlock;

//请求任务
@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;
//请求头添加
@property (nonatomic, strong, readwrite) NSDictionary *requestHeaderDic;



#pragma mark -methods
//开始请求
- (void)start;
//停止请求
- (void)stop;
//清空回调block
- (void)clearCompletionBlock;
//设置成功和失败回调
- (void)startWithCompletionBlockWithSuccess:(nullable STRequestCompletionBlock)success
                                    failure:(nullable STRequestCompletionBlock)failure;
//拼接上传数据的block
- (void)setConstructingBlockWithFileData:(NSData *)fileData withFormKey:(NSString *)formKey withFileName:(NSString *)fileName withFileType:(NSString *)fileType;


@end



NS_ASSUME_NONNULL_END
