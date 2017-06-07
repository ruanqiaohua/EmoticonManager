//
//  EmoticonManager.m
//  IQEQOnline
//
//  Created by 阮巧华 on 2017/5/27.
//  Copyright © 2017年 iqeq. All rights reserved.
//

#import "EmoticonManager.h"
#import "AppDataManager.h"
#import "SRDownloadManager.h"
#import "ZipArchive.h"

@implementation EmoticonManager

+ (instancetype)manager {
    static EmoticonManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EmoticonManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self getResource];
    }
    return self;
}

- (void)getResource {
    
    [[AppDataManager shareInstance] getPublicResource:^(id object) {
        NSDictionary *dic = object;
        NSString *EmoticonUrl = [dic objectForKey:@"EmoticonUrl"];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *oldEmoticonUrl = [user objectForKey:@"EmoticonUrl"];
        // 本地资源和服务端资源不一致
        if (![oldEmoticonUrl isEqualToString:EmoticonUrl]) {
            // 下载资源
            [self downloadResource:EmoticonUrl];
            [user setObject:EmoticonUrl forKey:@"EmoticonUrl"];
        } else {
            NSString *gifPath = [self getFacePath];
            BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:gifPath];
            if (isExists) {
                [self dealWithFolder];
                _gifListPlistPath = [self getGifListPlistPath];
            } else {
                [self downloadResource:EmoticonUrl];
            }
        }
    } failureCb:^(NSError *error) {
        
    }];
}

- (void)downloadResource:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    [[SRDownloadManager sharedManager] downloadURL:url state:^(SRDownloadState state) {
        
    } progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        NSLog(@"当前下载进度为:%lf", 1.0 * progress);
    } completion:^(BOOL isSuccess, NSString *filePath, NSError *error) {
        NSLog(@"下载完成 filePath == %@", filePath);
        [self delectOldFile];
        [self unzipFile:filePath];
    }];
}

- (void)delectOldFile {
    
    NSString *gifPath = [self getFacePath];
    NSString *gifListPlistPath = [self getGifListPlistPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:gifPath error:nil];
    [fileManager removeItemAtPath:gifListPlistPath error:nil];
}

- (void)unzipFile:(NSString *)filePath {
    
    NSString *path = [self getFacePath];
    
    ZipArchive *zip = [[ZipArchive alloc] init];
    
    BOOL result;
    if ([zip UnzipOpenFile:filePath]) {
        
        result = [zip UnzipFileTo:path overWrite:YES];
        if (!result) {
            NSLog(@"解压失败");
        } else {
            NSLog(@"解压成功");
            [self dealWithFolder];
        }
        [zip UnzipCloseFile];
    }
}

- (void)dealWithFolder {
    
    NSString *gifPath = [self getFacePath];
    NSArray *array = [[NSFileManager defaultManager] subpathsAtPath:gifPath];
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *string in array) {
        NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
        NSString *name = [[string stringByDeletingPathExtension] lastPathComponent];
        NSString *extension = [string pathExtension];
        NSString *path = [[NSString stringWithFormat:@"%@/%@",gifPath,string] stringByDeletingPathExtension];
        if ([extension isEqualToString:@"gif"]) {
            [mDic setValue:name forKey:@"gifName"];
            [mDic setValue:[NSString stringWithFormat:@"%@.gif",path] forKey:@"gifPath"];
            [mDic setValue:[NSString stringWithFormat:@"%@.png",path] forKey:@"pngPath"];
            [mArr addObject:mDic];
        }
    }
    _gifListPlistPath = [self getGifListPlistPath];
    [mArr writeToFile:_gifListPlistPath atomically:YES];
}

- (NSString *)getDocumentPath {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    return path;
}

- (NSString *)getGifListPlistPath {
    
    NSString *path = [self getFacePath];
    return [path stringByAppendingString:@"/gifList.plist"];
}

- (NSString *)getFacePath {
    
    NSString *documentPath = [self getDocumentPath];
    NSString *facePath = [documentPath stringByAppendingString:@"/Face"];
    return facePath;
}

@end
