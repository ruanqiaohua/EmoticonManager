//
//  AppDataManager.m
//  IQEQCourseware
//
//  Created by 阮巧华 on 2017/3/19.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import "AppDataManager.h"
#import "AFNetworking.h"

@implementation AppDataManager
{
    long long _resourceLength;
}

+ (instancetype)shareInstance {
    
    static AppDataManager *appDataManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appDataManager = [[AppDataManager alloc] init];
    });
    return appDataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
/** 获取公共资源 */
- (void)getPublicResource:(SuccessCb)successCb failureCb:(FailureCb)failureCb {
    
    [[AppNetWorking shareInstance] GET:@"/api/v2/common/live/getPublicResource?sn=1001&timestamp=1496651067&authkey=1f1b8f12d55ab29fdee5d28c2d23329d&token=0aa8a1d1206f48808279d9e727df2256" parameters:nil successCb:^(id object) {
        if (successCb) {
            successCb(object);
        }
    } failureCb:^(NSError *error) {
        if (failureCb) {
            failureCb(error);
        }
    }];
}

@end
