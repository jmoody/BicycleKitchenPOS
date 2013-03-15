//
//  Project.h
//  AnotherApp
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithUid.h"
#import "Person.h"
#import "Bicycle.h"
#import "Invoice.h"
#import "Product.h"

@interface Project : ObjectWithUid {
  NSString *ownerUid;
  Bicycle *bicycle;
  NSCalendarDate *startDate;
  NSCalendarDate *dateLastWorked;
  NSCalendarDate *finishedDate;
  bool isFinished;
  double quote;
  double standTime;
  NSString *invoiceUid;
  NSMutableArray *contactUids;
  NSString *note;
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSString *)ownerUid;
- (void)setOwnerUid:(NSString *)arg;
- (Bicycle *)bicycle;
- (void)setBicycle:(Bicycle *)arg;
- (NSCalendarDate *)startDate;
- (void)setStartDate:(NSCalendarDate *)arg;
- (NSCalendarDate *)dateLastWorked;
- (void)setDateLastWorked:(NSCalendarDate *)arg;
- (NSCalendarDate *)finishedDate;
- (void)setFinishedDate:(NSCalendarDate *)arg;
- (bool)isFinished;
- (void)setIsFinished:(bool)arg;
- (double)quote;
- (void)setQuote:(double)arg;
- (double)standTime;
- (void)setStandTime:(double)arg;
- (NSString *)invoiceUid;
- (void)setInvoiceUid:(NSString *)arg;
- (NSMutableArray *)contactUids;
- (void)setContactUids:(NSArray *)arg;
- (NSString *)note;
- (void)setNote:(NSString *)arg;

  //******************************************************************************
  // misc
  //******************************************************************************
- (bool)isOverdue;
- (NSString *)isOverdueYesOrNo;
- (NSString *)finishedYesOrNo;
- (NSString *)ownerName;
- (NSString *)ownerEmail;
- (NSString *)ownerPhone;
- (NSString *)bicycleDescription;
- (Invoice *)invoice;
- (NSMutableArray *)productsInInvoice;
- (double)totalFromProducts;
- (double)balance;
- (NSMutableArray *)taxableItemsInInvoice;
- (Product *)projectProduct;

@end