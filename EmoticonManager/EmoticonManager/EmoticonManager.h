//
//  EmoticonManager.h
//  IQEQOnline
//
//  Created by 阮巧华 on 2017/5/27.
//  Copyright © 2017年 iqeq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EmoticonManager : NSObject

+ (instancetype)manager;

@property (nonatomic, copy) NSString *gifListPlistPath;

@end
