//
//  ITLogFileManager.h
//  ITLogDemo
//
//  Created by leo on 17/1/3.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDFileLogger.h"

extern int ddLogLevel;
@interface ITLogFileManager : NSObject <DDLogFileManager>

+ (instancetype)create;

@property (readwrite, assign, atomic) NSUInteger maximumNumberOfLogFiles; // 文件数量限制
@property (readwrite, assign, atomic) unsigned long long logFilesDiskQuota; // 文件磁盘占用限制

@end
