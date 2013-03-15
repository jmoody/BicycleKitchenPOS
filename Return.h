//
//  Return.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/6/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithComment.h"

@interface Return : ObjectWithComment {
  NSString *ownerUid;
  NSString *invoiceUid;
  NSString *creditUid;
  double quantity;
  NSMutableArray *products;
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSString *)ownerUid;
- (void)setOwnerUid:(NSString *)arg;
- (NSString *)invoiceUid;
- (void)setInvoiceUid:(NSString *)arg;
- (NSString *)creditUid;
- (void)setCreditUid:(NSString *)arg;
- (double)quantity;
- (void)setQuantity:(double)arg;
- (NSMutableArray *)products;
- (void)setProducts:(NSArray *)arg;

  //******************************************************************************
  // misc
  //******************************************************************************
- (NSString *)personName;

@end