//
//  TestRequest.m
//  test
//
//  Created by steven on 2017/7/27.
//  Copyright © 2017年 ist. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest

//处理resultStr
-(void)setResultStr:(NSString *)resultStr
{
    if (self.requestType == LoginType) {
        self.resultObject = @"fdsafd";
    }
    self.responseSerializerType = STResponseSerializerTypeJSON;
    [super setResultStr:resultStr];
}
@end
