//
//  STNetworkConfig.h
//  test
//
//  Created by steven on 2017/7/26.
//  Copyright © 2017年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFSecurityPolicy;

@interface STNetworkConfig : NSObject

@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
///  SessionConfiguration will be used to initialize AFHTTPSessionManager. Default is nil.
@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Return a shared config object.
+ (STNetworkConfig *)sharedConfig;

@end
