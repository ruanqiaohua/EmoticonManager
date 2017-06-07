//
//  AppNetWorking.h
//  IQEQCourseware
//
//  Created by 阮巧华 on 2017/3/19.
//  Copyright © 2017年 阮巧华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HostIp @"http://live.iqeq01.com/"
//#define HostIp @"http://test.live.iqeq01.com/"
#define TeacherLogin @"/api/v2/app/live/teacherLogin"
#define GetResource @"/api/v2/app/live/getResource"
#define GetWeekCoursePlan @"/api/v2/app/live/getWeekCoursePlan"
#define AddProblem @"/api/v2/app/live/addProblem"

FOUNDATION_EXPORT NSString * const USERNAME_PSW_ERROR;
FOUNDATION_EXPORT NSString * const NETWORK_ERROR;
FOUNDATION_EXPORT NSString * const IS_LOGINING;

@interface AppNetWorking : NSObject

typedef void(^SuccessCb)(id object);
typedef void(^FailureCb)(NSError *error);

/** 初始化单例 */
+ (instancetype)shareInstance;
/** 设置网络状态和用户交互 */
- (void)setNetworkActivity:(BOOL)show userInteractionEnabled:(BOOL)userInteractionEnabled;
/** GET请求 */
- (void)GET:(NSString *)urlString parameters:(NSDictionary *)parameters successCb:(SuccessCb)successCb failureCb:(FailureCb)failureCb;
/** POST请求 */
- (void)POST:(NSString *)urlString parameters:(NSDictionary *)parameters successCb:(SuccessCb)successCb failureCb:(FailureCb)failureCb;

@end
