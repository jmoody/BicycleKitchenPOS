//
//  ExpirationDateMaker.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/26/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"

@interface ExpirationDateMaker : FTSWAbstractSingleton {
  
  NSArray *daysInMonthArray;

}

+ (ExpirationDateMaker *)sharedInstance;

- (NSArray *)daysInMonthArray;
- (void)setDaysInMonthArray:(NSArray *)array;
- (NSArray *)makeDaysInMonthArray;
- (int)daysInMonth:(int)monthInteger year:(int)yearInteger;
- (NSCalendarDate *)expirationDate;

@end
