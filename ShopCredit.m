// 
// ShopCredit.m
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import "ShopCredit.h"
#import "Credits.h"
#import "People.h"
#import "Person.h"
#import "ShopCreditClassDescription.h"

@implementation ShopCredit


+ (void) initialize {
  if ( self == [ShopCredit class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    ShopCreditClassDescription *cd = [[ShopCreditClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"creditAmount",@"remainingAmount",@"usedAmount",@"ownerUid",@"hasBeenUsed",@"invoiceUids",nil]];
    [superTypes setObject:LjDoubleType forKey:@"creditAmount"];
    [superTypes setObject:LjDoubleType forKey:@"remainingAmount"];
    [superTypes setObject:LjDoubleType forKey:@"usedAmount"];
    [superTypes setObject:LjStringType forKey:@"ownerUid"];
    [superTypes setObject:LjBooleanType forKey:@"hasBeenUsed"];
    [superTypes setObject:LjArrayType forKey:@"invoiceUids"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setCreditAmount:0.0];
    [self setRemainingAmount:0.0];
    [self setUsedAmount:0.0];
    [self setOwnerUid:@""];
    [self setHasBeenUsed:NO];
    NSArray *array = [[NSArray alloc] init];
    [self setInvoiceUids:array];
    [array release];

  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void) dealloc {
  [ownerUid release];
  [invoiceUids release];
  [super dealloc];
}


//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeDouble:creditAmount forKey:@"creditAmount"];
  [coder encodeDouble:remainingAmount forKey:@"remainingAmount"];
  [coder encodeDouble:usedAmount forKey:@"usedAmount"];
  [coder encodeObject:ownerUid forKey:@"ownerUid"];
  [coder encodeBool:hasBeenUsed forKey:@"hasBeenUsed"];
  [coder encodeObject:invoiceUids forKey:@"invoiceUids"];
}


//******************************************************************************
// decode
//******************************************************************************
- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setCreditAmount:[coder decodeDoubleForKey:@"creditAmount"]];
  [self setRemainingAmount:[coder decodeDoubleForKey:@"remainingAmount"]];
  [self setUsedAmount:[coder decodeDoubleForKey:@"usedAmount"]];
  [self setOwnerUid:[coder decodeObjectForKey:@"ownerUid"]];
  [self setHasBeenUsed:[coder decodeBoolForKey:@"hasBeenUsed"]];
  [self setInvoiceUids:[coder decodeObjectForKey:@"invoiceUids"]];
 return self;
}


//******************************************************************************
// methods
//******************************************************************************
- (NSString *)hasBeenUsedYesOrNo {
  if (hasBeenUsed) {
    return @"yes";
  } else {
    return @"no";
  }
}

- (NSString *)personName {
  Person *p = [[People sharedInstance] objectForUid:[self ownerUid]];
  return [p personName];
}


//******************************************************************************
// accessors and setters
//******************************************************************************
- (double)creditAmount {
  return creditAmount;
}
- (void) setCreditAmount:(double)arg {
 creditAmount = arg;
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
- (NSString *)ownerUid {
  return ownerUid;
}
- (void) setOwnerUid:(NSString *)arg {
 arg = [arg copy];
  [ownerUid release];
  ownerUid = arg;
}
- (bool)hasBeenUsed {
  return hasBeenUsed;
}
- (void) setHasBeenUsed:(bool)arg {
 hasBeenUsed = arg;
}
- (NSMutableArray *)invoiceUids {
  return invoiceUids;
}
- (void) setInvoiceUids:(NSArray *)arg {
  if (arg != invoiceUids) {
    [invoiceUids release];
    invoiceUids = [arg mutableCopy];
  }
}
@end