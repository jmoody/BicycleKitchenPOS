//
//  UidGenerator.m
//  UidGeneratorTest
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "UidGenerator.h"

@implementation UidGenerator

UidGenerator* singleton = nil;

- (id)init {
  if (self = [super init]) {
    if (singleton == nil) {
      singleton = [self retain]; //an extra retain
      [singleton setUidCount:0];
    } else
      [self release];
  }
  return singleton;
}

+ (id)sharedInstance {
  if (singleton == nil)
    return [[[UidGenerator alloc] init] autorelease];
  else
    return singleton;
}

-(int) uidCount {
  return uidCount;
}

-(void) setUidCount:(int)newCount {
  uidCount = newCount;
}

- (NSString *)ensureLeadingZero:(int)value {
  if (value < 10) {
    return [NSString stringWithFormat:@"0%d", value];
  } else {
    return [NSString stringWithFormat:@"%d", value];
  }
}

-(NSString *) generateUid {
  NSCalendarDate *today = [NSCalendarDate calendarDate];
  int year = [today yearOfCommonEra];
  NSString *month = [self ensureLeadingZero:[today monthOfYear]];
  NSString *day = [self ensureLeadingZero:[today dayOfMonth]];
  NSString *hour = [self ensureLeadingZero:[today hourOfDay]];
  NSString *minute = [self ensureLeadingZero:[today minuteOfHour]];
  NSString *second = [self ensureLeadingZero:[today secondOfMinute]];
  uidCount++;
  NSString *count = [self ensureLeadingZero:uidCount];
      
    
  NSString *uidString = [NSString stringWithFormat:@"%d%@%@%@%@%@%@",
    year, month, day, hour, minute, second, count];
  
  ////NSLog(@"today = %@", uidString);
  return uidString;
}


@end
