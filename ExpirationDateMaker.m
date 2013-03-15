//
//  ExpirationDateMaker.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/26/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ExpirationDateMaker.h"


@implementation ExpirationDateMaker

+ (ExpirationDateMaker *)sharedInstance {
  //NSLog(@"in sharedInstance ExpirationDateMaker");
  static ExpirationDateMaker *s_MySingleton = nil;
  
  @synchronized([ExpirationDateMaker class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
    }
  }
  
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  //NSLog(@"in initSingleton ExpirationDateMaker");
  if (self = [super initSingleton]) {
    
    [self setDaysInMonthArray:[self makeDaysInMonthArray]];
    
  }
  return self;
}


- (void) dealloc {
  [daysInMonthArray release];
  [super dealloc];
}


- (NSArray *)daysInMonthArray {
  return daysInMonthArray;
}

- (void)setDaysInMonthArray:(NSArray *)array {
  if (array != daysInMonthArray) {
    [daysInMonthArray release];
    daysInMonthArray = [array mutableCopy];
  }
  
}

- (NSArray *)makeDaysInMonthArray {
  NSMutableArray *tmp = [[NSMutableArray alloc] init];
  [tmp insertObject:[NSNumber numberWithInt:31] atIndex:0]; // jan
  [tmp insertObject:[NSNumber numberWithInt:28] atIndex:1]; // feb
  [tmp insertObject:[NSNumber numberWithInt:31] atIndex:2]; // mar
  [tmp insertObject:[NSNumber numberWithInt:30] atIndex:3]; // apr
  [tmp insertObject:[NSNumber numberWithInt:31] atIndex:4]; // may
  [tmp insertObject:[NSNumber numberWithInt:30] atIndex:5]; // jun
  [tmp insertObject:[NSNumber numberWithInt:31] atIndex:6]; // jul
  [tmp insertObject:[NSNumber numberWithInt:31] atIndex:7]; // aug
  [tmp insertObject:[NSNumber numberWithInt:30] atIndex:8]; // sep
  [tmp insertObject:[NSNumber numberWithInt:31] atIndex:9]; // oct
  [tmp insertObject:[NSNumber numberWithInt:30] atIndex:10]; // nov
  [tmp insertObject:[NSNumber numberWithInt:31] atIndex:11]; // dec
  NSArray *returnVal = [NSArray arrayWithArray:tmp];
  [tmp release];
  return returnVal;
}

- (int)daysInMonth:(int)monthInteger year:(int)yearInteger {
	int preliminaryDaysInMonth = [[daysInMonthArray objectAtIndex:(monthInteger - 1)] intValue];
	int daysInMonth = preliminaryDaysInMonth;
	bool isLeapYear = NO;
	if (monthInteger == 2) {
		if ((yearInteger%4) == 0) isLeapYear = YES;
		if ((yearInteger%100) == 0) isLeapYear = NO;
		if ((yearInteger%400) == 0) isLeapYear = YES;
		if (isLeapYear) daysInMonth = ++preliminaryDaysInMonth;
	}
	
	////NSLog(@"month: %d, year: %d, daysInMonth: %d",monthInteger,yearInteger,daysInMonth);
	return daysInMonth;
}

- (NSCalendarDate *)expirationDate {
  NSCalendarDate *today = [NSCalendarDate calendarDate];
  int daysInMonth = [self daysInMonth:[today monthOfYear] year:[today yearOfCommonEra]];
  int dayOfMonth = [today dayOfMonth];
  int daysUntilEnd = daysInMonth - dayOfMonth;
  return [today dateByAddingYears:0 months:0 days:daysUntilEnd
                            hours:0 minutes:0 seconds:0];
}

@end
