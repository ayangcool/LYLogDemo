//
//  ITLogFormatter.m
//  ITLogDemo
//
//  Created by leo on 17/1/3.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ITLogFormatter.h"

@implementation ITLogFormatter {
    NSDateFormatter *_dateFormatter;
}

+ (instancetype)create {
    return [[[self class] alloc] init];
}

- (instancetype)init {
    return [self initWithDateFormatter:nil];
}

- (instancetype)initWithDateFormatter:(NSDateFormatter *)aDateFormatter {
    if ((self = [super init])) {
        if (aDateFormatter) {
            _dateFormatter = aDateFormatter;
        } else {
            _dateFormatter = [[NSDateFormatter alloc] init];
            [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; // 10.4+ style
            [_dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss:SSS"];
        }
    }
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *dateAndTime = [_dateFormatter stringFromDate:(logMessage->_timestamp)];
    return [NSString stringWithFormat:@"%@  %@  _LINE_:%@  %@", dateAndTime, logMessage->_function, @(logMessage->_line), logMessage->_message];
}

@end
