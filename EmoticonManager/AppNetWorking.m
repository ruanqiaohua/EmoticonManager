//
//  AppNetWorking.m
//  IQEQCourseware
//
//  Created by 阮巧华 on 2017/3/19.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "AppNetWorking.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"

#define ReturnCode @"Code"
#define ReturnData @"Data"
#define ReturnMessage @"Msg"
#define SuccessCb(data) if (successCb) {successCb(data);}
#define FailureCb(data) if (failureCb) {failureCb(data);}

@interface AppNetWorking ()
@property (nonatomic, strong) AFHTTPSessionManager *session;
@end
@implementation AppNetWorking
{
    UIView *_view;
}

NSString * const USERNAME_PSW_ERROR = @"帐号和密码不符，请重新输入。";
NSString * const NETWORK_ERROR = @"网络又调皮了，请重试！";
NSString * const IS_LOGINING = @"正在登录，请稍后！";

+ (instancetype)shareInstance {
    
    static AppNetWorking *appNetWorking;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appNetWorking = [[AppNetWorking alloc] init];
    });
    return appNetWorking;
}

- (instancetype)init {
    
    if (self = [super init]) {
        _session = [[AFHTTPSessionManager manager]initWithBaseURL:[NSURL URLWithString:HostIp]];
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        _session.requestSerializer.timeoutInterval = 10;
        _view = [UIApplication sharedApplication].keyWindow;
    }
    return self;
}

- (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters successCb:(SuccessCb)successCb failureCb:(FailureCb)failureCb {
    
    [_session GET:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = [self responseDictionary:responseObject];
        id code = [response objectForKey:ReturnCode];
        if (code && [code integerValue] == 0) {
            SuccessCb(response[ReturnData])
        } else {
            id message = [response objectForKey:ReturnMessage];
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey:message}];
            FailureCb(error)
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FailureCb(error)
    }];
}

- (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters successCb:(SuccessCb)successCb failureCb:(FailureCb)failureCb {
    
    [_session POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *response = [self responseDictionary:responseObject];
        id code = [response objectForKey:ReturnCode];
        if (code && [code integerValue] == 0) {
            SuccessCb(response[ReturnData])
        } else {
            id message = [response objectForKey:ReturnMessage];
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:[code integerValue] userInfo:@{NSLocalizedDescriptionKey:message}];
            FailureCb(error)
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        FailureCb(error)
    }];
}

- (NSDictionary *)responseDictionary:(id)responseObject {
    
    NSError *error;
    NSDictionary * responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
    if (!responseDictionary) {
        NSString *jsonString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",error);
        NSLog(@"%@",jsonString);
    }
    return responseDictionary;
}

- (void)setNetworkActivity:(BOOL)show userInteractionEnabled:(BOOL)userInteractionEnabled {
    
    if (show) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    } else {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setUserInteractionEnabled:YES];
    }
    if (userInteractionEnabled) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setUserInteractionEnabled:YES];
    } else {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view setUserInteractionEnabled:NO];
    }
}

@end
