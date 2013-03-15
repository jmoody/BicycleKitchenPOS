//
//  Check.h
//  AnotherApp
//
//  Created by moody on 6/10/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithDate.h"
extern NSString *TljBkPosDefaultNameOnCheck;

@interface Check : ObjectWithDate {
  
  // we'll use the date field for date received
  NSCalendarDate *dateOnCheck;
  NSString *nameOnCheck;
  int checkNumber;
  double checkAmount;
  NSString *checkPhoneNumber;
  NSString *checkAddress;
  NSString *invoiceUid;
  bool checkCleared;
}


- (NSCalendarDate *)dateOnCheck;
- (NSString *)nameOnCheck;
- (int) checkNumber;
- (double) checkAmount;
- (NSString *)checkPhoneNumber;
- (NSString *)checkAddress;
- (NSString *)invoiceUid;
- (bool) checkCleared;

- (void) setDateOnCheck:(NSCalendarDate *)date;
- (void) setNameOnCheck:(NSString *)name;
- (void) setCheckNumber:(int) number;
- (void) setCheckAmount:(double) amount;
- (void) setCheckPhoneNumber:(NSString *)phoneNumber;
- (void) setCheckAddress:(NSString *)address;
- (void) setInvoiceUid:(NSString *)invoice;
- (void) setCheckCleared:(bool)cleared;

@end
