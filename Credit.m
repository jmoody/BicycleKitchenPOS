//
//  Credit.m
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "Credit.h"
#import "Credits.h"
#import "People.h"
#import "Person.h"

@implementation Credit

- (id) init {
  self = [super init];
  if (self != nil) {
    creditAmount = 0.0;
    remainingAmount = 0.0;
    usedAmount = 0.0;
    hasBeenUsed = NO;
    [self setInvoiceUids:[[NSMutableArray alloc] init]];
    [self setOwnerUid:@""];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [ownerUid release];
  [self deallocAnArray:invoiceUids];
  [super dealloc];
}

- (NSString *)personName {
  Person *p = [[People sharedInstance] personForUid:[self ownerUid]];
  return [p personName];
}

- (NSString *)hasBeenUsedYesOrNo {
  if (hasBeenUsed) {
    return @"yes";
  } else {
    return @"no";
  }
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<Credit: %@ %@ %@ $%1.2f>",
    [self date], [self commentAuthorName], [self commentText], creditAmount];
   
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeDouble:creditAmount forKey:@"creditAmount"];
  [coder encodeObject:ownerUid forKey:@"ownerUid"];
  [coder encodeBool:hasBeenUsed forKey:@"hasBeenUsed"];
  [coder encodeObject:invoiceUids forKey:@"invoiceUids"];
  [coder encodeDouble:remainingAmount forKey:@"remainingAmount"];
  [coder encodeDouble:usedAmount forKey:@"usedAmount"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setCreditAmount:[coder decodeDoubleForKey:@"creditAmount"]];
  [self setOwnerUid:[coder decodeObjectForKey:@"ownerUid"]];
  [self setHasBeenUsed:[coder decodeBoolForKey:@"hasBeenUsed"]];
  [self setInvoiceUids:[coder decodeObjectForKey:@"invoiceUids"]];
  [self setRemainingAmount:[coder decodeDoubleForKey:@"remainingAmount"]];
  [self setUsedAmount:[coder decodeDoubleForKey:@"usedAmount"]];
  return self;
}

//- (double)decfCredit:(double)amount withInvoiceUid:(NSString *)aUid {
//  NSString *commentStr = [self commentText];
//  NSString *dateStr = [[NSCalendarDate calendarDate] descriptionWithCalendarFormat:@"%m/%d/%Y %H:%M:%S"];
//  [[self invoiceUids] addObject:aUid];
//  double newCreditAmount, currentCreditAmount;
//  currentCreditAmount = [self remainingAmount];
//  if (amount >= currentCreditAmount) {
//    newCreditAmount = amount - currentCreditAmount;
//    [self setRemainingAmount:0.0];
//    [self setUsedAmount:[self creditAmount]];
//    [self setHasBeenUsed:YES];
//    dateStr = [NSString stringWithFormat:@"\n* $%1.2f used on %@", currentCreditAmount, dateStr];
//    dateStr = [NSString stringWithFormat:@"%@%@", commentText, dateStr];
//    [self setCommentText:dateStr];
//    [[Credits sharedInstance] saveToDisk];
//    return newCreditAmount;
//  } else {
//    newCreditAmount = currentCreditAmount - amount;
//    [self setRemainingAmount:newCreditAmount];
//    [self setUsedAmount:([self creditAmount] - [self remainingAmount]);
//    [self setHasBeenUsed:NO];
//    dateStr = [NSString stringWithFormat:@"\n* $%1.2f used on %@", amount, dateStr];
//    dateStr = [NSString stringWithFormat:@"%@%@", commentText, dateStr];
//    [self setCommentText:dateStr];
//    [[Credits sharedInstance] saveToDisk];
//    return 0.0;
//  }
//  return 0.0;
//}


- (NSMutableArray *)invoiceUids {
  return invoiceUids;
}

- (void)setInvoiceUids:(NSArray *)array {
  if (array != invoiceUids) {
    [self deallocAnArray:invoiceUids];
    invoiceUids = [[NSMutableArray alloc] initWithArray:array];
  }
}


//******************************************************************************
// accessor
//******************************************************************************

- (double) creditAmount {
  return creditAmount;
}

- (NSString *)ownerUid {
  return ownerUid;
}

- (bool) hasBeenUsed {
  return hasBeenUsed;
}


//******************************************************************************
// setter
//******************************************************************************

- (void) setCreditAmount:(double) credit {
  creditAmount = credit;
}

- (void)setOwnerUid:(NSString *)owner {
  [owner copy];
  [ownerUid release];
  ownerUid = owner;
}


- (void)setHasBeenUsed:(bool)used {
  hasBeenUsed = used;
}

- (double)remainingAmount {
  return remainingAmount;
}
- (void) setRemainingAmount:(double)arg {
  remainingAmount = arg;
}

- (double)usedAmount {
  return usedAmount;
}
- (void) setUsedAmount:(double)arg {
  usedAmount = arg;
}



@end
