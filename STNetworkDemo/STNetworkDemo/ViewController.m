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
    [testBtn addTarget:self action:@selector(request1) forControlEvents:UIControlEventTouchUpInside];
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@{@"cmd": @"REGISTER",@"username":@"test03",@"password": @"a489c78d4325be20c152f2139dfa3a33e486ab8ceef80947"},@"values", nil];
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
- (void)request1
{
    TestRequest *request =[[TestRequest alloc] init];
    request.requestUrl = @"http://11.11.179.20:8080/api.php";
    //    AppId = "yd.s20161219112227751";
    //    DeviceID = "BF795C3A-E0C6-4B0E-88BC-8C4F273B10B4";
    //    Equiptype = iPhone;
    //    IsApp = 1;
    //    IsDev = 0;
    //    IsEncrypted = false;
    //    Password = 123qweasd;
    //    Tel = "";
    //    UserName = wlz;
    NSDictionary *dic1 = @{@"cmd": @"REGISTER",@"username":@"test111",@"password": @"a489c78d4325be20c152f2139dfa3a33e486ab8ceef80947"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic1 options:NSJSONWritingPrettyPrinted error:nil];
//   NSString  *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    


//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:jsonString,@"values", nil];
//    NSMutableDictionary *dic = @{@"cmd": @"REGISTER",@"username":@"test03",@"password": @"a489c78d4325be20c152f2139dfa3a33e486ab8ceef80947"};

    request.requestArgument = jsonData;
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
