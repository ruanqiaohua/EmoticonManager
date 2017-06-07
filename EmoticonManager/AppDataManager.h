//
//  AppDataManager.h
//  IQEQCourseware
//
//  Created by 阮巧华 on 2017/3/19.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppNetWorking.h"

@interface AppDataManager : NSObject

+ (instancetype)shareInstance;

/** 获取公共资源 */
- (void)getPublicResource:(SuccessCb)successCb failureCb:(FailureCb)failureCb;

@end
