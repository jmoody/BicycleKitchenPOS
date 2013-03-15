//
//  Debit.m
//  AnotherApp
//
//  Created by moody on 6/10/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "Debit.h"
NSString *TljBkPosDebitString = @"debit";
NSString *TljBkPosCreditString = @"credit";
NSString *TljBkPosDefaultLastFourDigits = @"9999";

@implementation Debit

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setNameOnDebit:@""];
    [self setDebitAmount:0.0];
    [self setLastFourDigits:TljBkPosDefaultLastFourDigits];
    [self setExpirationDate:[NSCalendarDate calendarDate]];
    [self setInvoiceUid:@""];
    [self setDebitOrCredit:TljBkPosDebitString];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [nameOnDebit release];
  [expirationDate release];
  [invoiceUid release];
  [debitOrCredit release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<Debit: %@ %@ %d %d %@>",
    [self date], nameOnDebit, debitAmount, lastFourDigits, expirationDate];
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:nameOnDebit forKey:@"nameOnDebit"];
  [coder encodeDouble:debitAmount forKey:@"debitAmount"];
  [coder encodeObject:lastFourDigits forKey:@"lastFourDigits"];
  [coder encodeObject:expirationDate forKey:@"expirationDate"];
  [coder encodeObject:invoiceUid forKey:@"invoiceUid"];
  [coder encodeObject:debitOrCredit forKey:@"debitOrCredit"];
 }

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setNameOnDebit:[coder decodeObjectForKey:@"nameOnDebit"]];
  [self setDebitAmount:[coder decodeDoubleForKey:@"debitAmount"]];
  [self setLastFourDigits:[coder decodeObjectForKey:@"lastFourDigits"]];
  [self setExpirationDate:[coder decodeObjectForKey:@"expirationDate"]];
  [self setInvoiceUid:[coder decodeObjectForKey:@"invoiceUid"]];
  [self setDebitOrCredit:[coder decodeObjectForKey:@"debitOrCredit"]];
  return self;
}


- (NSString *)debitOrCredit {
  return debitOrCredit;
}

- (void)setDebitOrCredit:(NSString *)dorc {
  [dorc copy];
  [debitOrCredit release];
  debitOrCredit = dorc;
}


//******************************************************************************
// accessor
//******************************************************************************

- (NSString *)nameOnDebit {
  return nameOnDebit;
}

- (double) debitAmount {
  return debitAmount;
}

- (NSString *) lastFourDigits {
  return lastFourDigits;
}

- (NSCalendarDate *)expirationDate {
  return expirationDate;
}

- (NSString *)invoiceUid {
  return invoiceUid;
}


//******************************************************************************
// setter
//******************************************************************************

- (void) setNameOnDebit:(NSString *)name {
  [name retain];
  [nameOnDebit release];
  nameOnDebit = name;
}

- (void) setDebitAmount:(double) amount {
  debitAmount = amount;
}

- (void) setLastFourDigits:(NSString *) number {
  [number copy];
  [lastFourDigits release];
  lastFourDigits = number;
}

- (void) setExpirationDate:(NSCalendarDate *)newDate {
  [newDate retain];
  [expirationDate release];
  expirationDate = newDate;
}

- (void) setInvoiceUid:(NSString *)invoice {
  [invoice retain];
  [invoiceUid release];
  invoiceUid = invoice;
}


@end
