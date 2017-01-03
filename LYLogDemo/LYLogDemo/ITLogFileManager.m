//
//  ITLogFileManager.m
//  ITLogDemo
//
//  Created by leo on 17/1/3.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ITLogFileManager.h"

// 日志级别
int ddLogLevel = DDLogLevelVerbose;

//app是否处在后台
static BOOL _doesAppRunInBackground() {
    BOOL answer = NO;
    NSArray *backgroundModes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIBackgroundModes"];
    for (NSString *mode in backgroundModes) {
        if (mode.length > 0) {
            answer = YES;
            break;
        }
    }
    return answer;
}

@implementation ITLogFileManager

+ (instancetype)create {
    ITLogFileManager *fileManager = [[ITLogFileManager alloc] init];
    fileManager.maximumNumberOfLogFiles = 2;
    fileManager.logFilesDiskQuota = 1024 * 1024 * 5;
    return fileManager;
}

#pragma mark - protocol -
- (NSArray *)unsortedLogFilePaths {
    // 始终只返回itlog.log，如果没有则返回空数组
    NSString *logPath = [self mainLogFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
        return @[logPath];
    }
    return @[];
}

- (NSArray *)unsortedLogFileNames {
    NSArray *unsortedLogFilePath = [self unsortedLogFilePaths];
    NSMutableArray *unsortedLogFileNames = [NSMutableArray arrayWithCapacity:unsortedLogFilePath.count];
    for (NSString *filePath in unsortedLogFilePath) {
        [unsortedLogFileNames addObject:[filePath lastPathComponent]];
    }
    return unsortedLogFileNames;
}

- (NSArray *)unsortedLogFileInfos {
    NSArray *unsortedLogFilePaths = [self unsortedLogFilePaths];
    NSMutableArray *unsortedLogFileInfos = [NSMutableArray arrayWithCapacity:unsortedLogFilePaths.count];
    for (NSString *filePath in unsortedLogFilePaths) {
        DDLogFileInfo *logFileInfo = [[DDLogFileInfo alloc] initWithFilePath:filePath];
        [unsortedLogFileInfos addObject:logFileInfo];
    }
    return unsortedLogFileInfos;
}

- (NSArray *)sortedLogFilePaths {
    return [self unsortedLogFilePaths];
}

- (NSArray *)sortedLogFileNames {
    return [self unsortedLogFileNames];
}

- (NSArray *)sortedLogFileInfos {
    return [self unsortedLogFileInfos];
}

- (NSString *)createNewLogFile {
    NSString *filePath = [self mainLogFilePath];
    //设置文件保护
    /* NSFileProtectionNone  文件未受保护，随时可以访问 （Default）
     * NSFileProtectionComplete 文件受到保护，而且只有在设备未被锁定时才可访问
     * NSFileProtectionCompleteUntilFirstUserAuthentication 文件受到保护，直到设备启动且用户第一次输入密码
     * NSFileProtectionCompleteUnlessOpen 文件受到保护，而且只有在设备未被锁定时才可打开，不过即便在设备被锁定时，已经打开的文件还是可以继续使用和写入
     */
    NSString *key = _doesAppRunInBackground() ? NSFileProtectionCompleteUntilFirstUserAuthentication : NSFileProtectionCompleteUnlessOpen;
    NSDictionary *attributes= @{NSFileProtectionKey:key};
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:attributes];
    return filePath;
}

- (NSString *)logsDirectory {
    return NSTemporaryDirectory();
}

// 被回调的协议方法，压缩目标log文件
- (void)didArchiveLogFile:(NSString *)logFilePath {
    // nothing to do
}

// 被回调的协议方法，当目标log文件写满的时候，文件句柄会关闭并且回调这个方法
- (void)didRollAndArchiveLogFile:(NSString *)logFilePath {
    NSString *filePath = logFilePath;
    NSString *backFilePath = [self backLogFilePath];
    [[NSFileManager defaultManager] removeItemAtPath:backFilePath error:nil];// 移除back日志文件
    [[NSFileManager defaultManager] moveItemAtPath:filePath toPath:backFilePath error:nil]; //重新添加back日志
}

#pragma mark - custom -
- (NSString *)mainLogFilePath {
    NSString *path = [self logsDirectory];
    NSString *logPath = [path stringByAppendingPathComponent:@"itlog.log"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:logPath]) {
        [[NSFileManager defaultManager] createFileAtPath:logPath contents:nil attributes:nil];
    }
    return logPath;
}

- (NSString *)backLogFilePath {
    NSString *path = [self logsDirectory];
    NSString *backLogPath = [path stringByAppendingPathComponent:@"itlog_back.log"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:backLogPath]) {
        [[NSFileManager defaultManager] createFileAtPath:backLogPath contents:nil attributes:nil];
    }
    return backLogPath;
}

@end
