//
//  STNetworkAgent.h
//  test
//
//  Created by steven on 2017/7/26.
//  Copyright © 2017年 ist. All rights reserved.
//

#import <Foundation/Foundation.h>

@class STBaseRequest;

@interface STNetworkAgent : NSObject

//这些方法不可用 只能用单例
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Get the shared agent.
+ (STNetworkAgent *)sharedAgent;

///  Add request to session and start it.
- (void)addRequest:(__kindof STBaseRequest *)request;

///  Cancel a request that was previously added.
- (void)cancelRequest:(__kindof STBaseRequest *)request;

/// Cancel target's requests
- (void)cancelRequestsWithTarget:(id)target;

///  Cancel all requests that were previously added.
- (void)cancelAllRequests;


@end
