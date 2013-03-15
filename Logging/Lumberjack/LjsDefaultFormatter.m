//
//  LjsDefaultFormatter.m
//  Lumberjack
//
//  Created by Joshua Moody on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LjsDefaultFormatter.h"

@implementation LjsDefaultFormatter

static NSString * const ERROR_LOG = @"ERROR";
static NSString * const WARN_LOG  = @" WARN";
static NSString * const INFO_LOG  = @" INFO";
static NSString * const DEBUG_LOG = @"DEBUG";
static NSString * const SOME_LOG  = @"  LOG";
static NSString * const DATE_FORMAT = @"yyyy-MM-dd HH:mm:ss.SSS";

@synthesize calendar, locale, formatter;

- (id) init {
	self = [super init];
	if (self != nil) {
		NSCalendar *tmpCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		self.calendar = tmpCalendar;
		[tmpCalendar release];
		
		self.locale = [NSLocale currentLocale];
		NSDateFormatter *tmpFormatter = [[NSDateFormatter alloc] init];
		[tmpFormatter setDateFormat:DATE_FORMAT];
		[tmpFormatter setCalendar:self.calendar];
		[tmpFormatter setLocale:self.locale];
		self.formatter = tmpFormatter;
		[tmpFormatter release];
	}
	return self;
}

- (void) dealloc
{
	[calendar release];
	[locale release];
	[formatter release];
	[super dealloc];
}

- (NSString *)stringFromLogLevel:(int)logLevel {
	NSString *level;
	switch (logLevel) {
		case LOG_LEVEL_ERROR:
			level = ERROR_LOG;
			break;
		case LOG_LEVEL_WARN:
			level = WARN_LOG;
			break;
		case LOG_LEVEL_INFO:
			level = INFO_LOG;
			break;
		case LOG_LEVEL_VERBOSE:
			level = DEBUG_LOG;
			break;
		default:
			level = SOME_LOG;
			break;
	}
	return level;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	
	NSDate *date = logMessage->timestamp;
	NSString *dateString = [self.formatter stringFromDate:date];
	int logLevel = logMessage->logLevel;
	NSString *level = [self stringFromLogLevel:logLevel];
	
	NSString *result =  [NSString stringWithFormat:@"%@ %@ %@: %s %i - %@",
											 dateString, level, [logMessage fileName], logMessage->function, logMessage->lineNumber, logMessage->logMsg];

	return result;
}


@end
