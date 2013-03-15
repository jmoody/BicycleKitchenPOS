//
//  Credit.h
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithComment.h"

@interface Credit : ObjectWithComment {
  double creditAmount;
  double remainingAmount;
  double usedAmount;
  NSString *ownerUid;
  bool hasBeenUsed;
  NSMutableArray *invoiceUids;
 }

- (double)remainingAmount;
- (void)setRemainingAmount:(double)arg;
- (double)usedAmount;
- (void)setUsedAmount:(double)arg;

- (NSString *)hasBeenUsedYesOrNo;
- (NSString *)personName;
- (double) creditAmount;
- (NSString *)ownerUid;
- (bool) hasBeenUsed;
- (void)setHasBeenUsed:(bool)used;
- (NSMutableArray *)invoiceUids;
- (void)setInvoiceUids:(NSArray *)array;

- (void) setCreditAmount:(double) credit;
- (void)setOwnerUid:(NSString *)owner;

//- (double)decfCredit:(double)amount withInvoiceUid:(NSString *)aUid;


@end
