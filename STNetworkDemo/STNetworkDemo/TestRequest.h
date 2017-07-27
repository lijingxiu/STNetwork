//
//  TestRequest.h
//  test
//
//  Created by steven on 2017/7/27.
//  Copyright © 2017年 ist. All rights reserved.
//

#import "STBaseRequest.h"

///  Request serializer type.
typedef NS_ENUM(NSInteger, TestRequestType) {
    LoginType = 100,
    
};

@interface TestRequest : STBaseRequest
@property (nonatomic,assign) TestRequestType requestType;
@end
