//
//  STNetworkConfig.m
//  test
//
//  Created by steven on 2017/7/26.
//  Copyright © 2017年 ist. All rights reserved.
//

#import "STNetworkConfig.h"
#import "STBaseRequest.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@implementation STNetworkConfig
+ (STNetworkConfig *)sharedConfig
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
         _securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    return self;
}

@end
