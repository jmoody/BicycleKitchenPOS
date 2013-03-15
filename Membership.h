//
//  Membership.h
//  AnotherApp
//
//  Created by moody on 6/10/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Product.h"

@interface Membership : Product {
  
  NSCalendarDate *creationDate;
  NSCalendarDate *startDate;
  NSCalendarDate *endDate;
  
  NSString *membershipType;
  NSString *invoiceUid;
  NSString *personUid;

}

- (NSString *)invoiceUid;
- (void)setInvoiceUid:(NSString *)aUid;

- (NSString *)personUid;
- (void)setPersonUid:(NSString *)aUid;

- (NSString *)personName;

- (NSCalendarDate *)creationDate;
- (NSCalendarDate *)startDate;
- (NSCalendarDate *)endDate;
- (NSString *)membershipType;

- (void)setCreationDate:(NSCalendarDate *)date;
- (void)setStartDate:(NSCalendarDate *)date;
- (void)setEndDate:(NSCalendarDate *)date;
- (void)setMembershipType:(NSString *)type;

@end
