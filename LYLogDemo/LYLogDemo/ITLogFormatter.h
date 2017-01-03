//
//  ITLogFormatter.h
//  ITLogDemo
//
//  Created by leo on 17/1/3.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface ITLogFormatter : NSObject <DDLogFormatter>

+ (instancetype)create;

@end
