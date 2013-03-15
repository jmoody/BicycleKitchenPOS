//
//  LjsTailingFileManager.m
//  Lumberjack
//
//  Created by Joshua Moody on 10/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LjsTailingFileManager.h"
#import "DDLog.h"

const static int ddLogLevel = LOG_LEVEL_VERBOSE;
static NSString *path = @"/tmp/tail.log";

@implementation LjsTailingFileManager


- (id) init
{
	self = [super init];
	if (self != nil) {
		DDLogVerbose(@"look for the logs at: %@", path);
		self.maximumNumberOfLogFiles = 1;
	}
	return self;
}

- (NSString *)createNewLogFile {
	
	[[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
	return path;
}

@end
