//
//  Check.m
//  AnotherApp
//
//  Created by moody on 6/10/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "Check.h"
#import "CheckClassDescription.h"

NSString *TljBkPosDefaultNameOnCheck = @"nobody";

@implementation Check

+ (void) initialize {
  if ( self == [Check class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    CheckClassDescription *cd = [[CheckClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"dateOnCheck",@"nameOnCheck",@"checkNumber",@"checkAmount",@"checkPhoneNumber",@"checkAddress",@"invoiceUid",@"checkCleared",nil]];
    [superTypes setObject:LjCalendarDateType forKey:@"dateOnCheck"];
    [superTypes setObject:LjStringType forKey:@"nameOnCheck"];
    [superTypes setObject:LjIntType forKey:@"checkNumber"];
    [superTypes setObject:LjDoubleType forKey:@"checkAmount"];
    [superTypes setObject:LjStringType forKey:@"checkPhoneNumber"];
    [superTypes setObject:LjStringType forKey:@"checkAddress"];
    [superTypes setObject:LjStringType forKey:@"invoiceUid"];
    [superTypes setObject:LjBooleanType forKey:@"checkCleared"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}


- (id) init {
  self = [super init];
  if (self != nil) {
    [self setDateOnCheck:[NSCalendarDate calendarDate]];
    [self setNameOnCheck:TljBkPosDefaultNameOnCheck];
    [self setCheckNumber:-1];
    [self setCheckAmount:0.0];
    [self setCheckPhoneNumber:@""];
    [self setCheckAddress:@""];
    [self setInvoiceUid:@""];
    [self setCheckCleared:NO];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [dateOnCheck release];
  [nameOnCheck release];
  [checkPhoneNumber release];
  [checkAddress release];
  [invoiceUid release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<Check: %@ %@ %@ %d %1.2f>",
    [self date], dateOnCheck, nameOnCheck, checkNumber, 
		checkAmount];
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:dateOnCheck forKey:@"dateOnCheck"];
  [coder encodeObject:nameOnCheck forKey:@"nameOnCheck"];
  [coder encodeInt:checkNumber forKey:@"checkNumber"];
  [coder encodeDouble:checkAmount forKey:@"checkAmount"];
  [coder encodeObject:checkPhoneNumber forKey:@"checkPhoneNumber"];
  [coder encodeObject:checkAddress forKey:@"checkAddress"];
  [coder encodeObject:invoiceUid forKey:@"invoiceUid"];
  [coder encodeBool:checkCleared forKey:@"checkCleared"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setDateOnCheck:[coder decodeObjectForKey:@"dateOnCheck"]];
  [self setNameOnCheck:[coder decodeObjectForKey:@"nameOnCheck"]];
  [self setCheckNumber:[coder decodeIntForKey:@"checkNumber"]];
	[self setCheckAmount:[coder decodeDoubleForKey:@"checkAmount"]];
  [self setCheckAddress:[coder decodeObjectForKey:@"checkAddress"]];
  [self setInvoiceUid:[coder decodeObjectForKey:@"invoiceUid"]];
  [self setCheckCleared:[coder decodeBoolForKey:@"checkCleared"]];
  return self;
}


//******************************************************************************
// accessor
//******************************************************************************

- (NSCalendarDate *)dateOnCheck {
  return dateOnCheck;
}

- (NSString *)nameOnCheck {
  return nameOnCheck;
}

- (int) checkNumber {
  return checkNumber;
}

- (double) checkAmount {
  return checkAmount;
}

- (NSString *)checkPhoneNumber {
  return checkPhoneNumber;
}

- (NSString *)checkAddress {
  return checkAddress;
}

- (NSString *)invoiceUid {
  return invoiceUid;
}

- (bool)checkCleared {
  return checkCleared;
}

//******************************************************************************
// setter
//******************************************************************************

- (void) setDateOnCheck:(NSCalendarDate *)newDate {
  [newDate retain];
  [dateOnCheck release];
  dateOnCheck = newDate;
}

- (void) setNameOnCheck:(NSString *)name {
  [name retain];
  [nameOnCheck release];
  nameOnCheck = name;
}

- (void) setCheckNumber:(int) number {
  checkNumber = number;
}

- (void) setCheckAmount:(double) amount {
  checkAmount = amount;
}

- (void) setCheckPhoneNumber:(NSString *)phoneNumber {
  phoneNumber = [phoneNumber copy];
  [checkPhoneNumber release];
  checkPhoneNumber = phoneNumber;
}

- (void) setCheckAddress:(NSString *)address {
  address = [address copy];
  [checkAddress release];
  checkAddress = address;
}

- (void) setInvoiceUid:(NSString *)invoice {
  invoice = [invoice copy];
  [invoiceUid release];
  invoiceUid = invoice;
}

- (void) setCheckCleared:(bool)cleared {
  checkCleared = cleared;
}

@end
