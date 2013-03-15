//
//  LjsDefaultFormatter.h
//  Lumberjack
//
//  Created by Joshua Moody on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDLog.h"

@interface LjsDefaultFormatter : NSObject <DDLogFormatter> {
	NSCalendar *calendar;
	NSLocale *locale;
	NSDateFormatter *formatter;
} 

@property (nonatomic, retain) NSCalendar *calendar;
@property (nonatomic, retain) NSLocale *locale;
@property (nonatomic, retain) NSDateFormatter *formatter;

- (NSString *)stringFromLogLevel:(int)logLevel;
- (NSString *)stringFromLogLevel:(int)logLevel;

@end
