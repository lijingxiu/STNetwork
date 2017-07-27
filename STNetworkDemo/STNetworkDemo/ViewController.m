//
//  ViewController.m
//  test
//
//  Created by steven on 2017/7/26.
//  Copyright © 2017年 ist. All rights reserved.
//

#import "ViewController.h"
#import "TestRequest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    UIButton *testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    testBtn.frame = CGRectMake(100, 100, 100, 100);
    testBtn.backgroundColor = [UIColor blueColor];
    [testBtn addTarget:self action:@selector(request) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testBtn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)request
{
    TestRequest *request =[[TestRequest alloc] init];
    request.requestUrl = @"http://210.12.209.168/dmcwebapi/API/DMC/Login";
//    AppId = "yd.s20161219112227751";
//    DeviceID = "BF795C3A-E0C6-4B0E-88BC-8C4F273B10B4";
//    Equiptype = iPhone;
//    IsApp = 1;
//    IsDev = 0;
//    IsEncrypted = false;
//    Password = 123qweasd;
//    Tel = "";
//    UserName = wlz;
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"IsDev",@"wlz", @"UserName", @"123qweasd", @"Password", @"iPhone", @"Equiptype", @"yd.s20161219112227751", @"AppId",@"BF795C3A-E0C6-4B0E-88BC-8C4F273B10B4",@"DeviceID",@"",@"Tel",@"false",@"IsEncrypted",@"1",@"IsApp", nil];
    request.requestArgument = dic;
    request.requestMethod = STRequestMethodPOST;
    request.target = self;
    request.requestType = LoginType;
    [request startWithCompletionBlockWithSuccess:^(__kindof STBaseRequest * _Nullable request) {
        TestRequest *request1 = request;
        NSLog(@"%d",request1.requestType);
    } failure:^(__kindof STBaseRequest * _Nullable request) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
