//
//  Debit.h
//  AnotherApp
//
//  Created by moody on 6/10/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithDate.h"
extern NSString *TljBkPosDebitString;
extern NSString *TljBkPosCreditString;
extern NSString *TljBkPosDefaultLastFourDigits;

@interface Debit : ObjectWithDate {

  // we'll use the date field for date received
  NSString *nameOnDebit;
  double debitAmount;
  NSString *lastFourDigits;
  NSCalendarDate *expirationDate;
  NSString *invoiceUid;
  NSString *debitOrCredit;
  
}

- (NSString *)debitOrCredit;
- (void)setDebitOrCredit:(NSString *)dorc;

- (NSString *)nameOnDebit;
- (double) debitAmount;
- (NSString *) lastFourDigits;
- (NSCalendarDate *)expirationDate;
- (NSString *)invoiceUid;

- (void) setNameOnDebit:(NSString *)name;
- (void) setDebitAmount:(double) amount;
- (void) setLastFourDigits:(NSString *) number;
- (void) setExpirationDate:(NSCalendarDate *)date;
- (void) setInvoiceUid:(NSString *)invoice;



@end
