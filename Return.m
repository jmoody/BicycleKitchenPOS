//
//  Return.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/6/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Return.h"
#import "People.h"
#import "Person.h"
#import "ReturnClassDescription.h"

@implementation Return


+ (void) initialize {
  if ( self == [Return class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    ReturnClassDescription *cd = [[ReturnClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"ownerUid",@"invoiceUid",@"creditUid",@"quantity",@"products",nil]];
    [superTypes setObject:LjStringType forKey:@"ownerUid"];
    [superTypes setObject:LjStringType forKey:@"invoiceUid"];
    [superTypes setObject:LjStringType forKey:@"creditUid"];
    [superTypes setObject:LjDoubleType forKey:@"quantity"];
    [superTypes setObject:LjArrayType forKey:@"products"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setOwnerUid:@""];
    [self setInvoiceUid:@""];
    [self setCreditUid:@""];
    NSArray *array = [[NSArray alloc] init];
    [self setProducts:array];
    [array release];
    [self setQuantity:0.0];
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void) dealloc {
  [ownerUid release];
  [invoiceUid release];
  [creditUid release];
  [products release];
  [super dealloc];
}


//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:ownerUid forKey:@"ownerUid"];
  [coder encodeObject:invoiceUid forKey:@"invoiceUid"];
  [coder encodeObject:creditUid forKey:@"creditUid"];
  [coder encodeDouble:quantity forKey:@"quantity"];
  [coder encodeObject:products forKey:@"products"];
}


//******************************************************************************
// decode
//******************************************************************************
- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setOwnerUid:[coder decodeObjectForKey:@"ownerUid"]];
  [self setInvoiceUid:[coder decodeObjectForKey:@"invoiceUid"]];
  [self setCreditUid:[coder decodeObjectForKey:@"creditUid"]];
  [self setQuantity:[coder decodeDoubleForKey:@"quantity"]];
  [self setProducts:[coder decodeObjectForKey:@"products"]];
  return self;
}


//******************************************************************************
// methods
//******************************************************************************
- (NSString *)personName {
  return [[[People sharedInstance] objectForUid:ownerUid] personName];
}


//******************************************************************************
// accessors and setters
//******************************************************************************
- (NSString *)ownerUid {
  return ownerUid;
}
- (void) setOwnerUid:(NSString *)arg {
  arg = [arg retain];
  [ownerUid release];
  ownerUid = arg;
}
- (NSString *)invoiceUid {
  return invoiceUid;
}
- (void) setInvoiceUid:(NSString *)arg {
  arg = [arg retain];
  [invoiceUid release];
  invoiceUid = arg;
}
- (NSString *)creditUid {
  return creditUid;
}
- (void) setCreditUid:(NSString *)arg {
  arg = [arg retain];
  [creditUid release];
  creditUid = arg;
}
- (double)quantity {
  return quantity;
}
- (void) setQuantity:(double)arg {
  quantity = arg;
}
- (NSMutableArray *)products {
  return products;
}
- (void) setProducts:(NSArray *)arg {
  if (arg != products) {
    [products release];
    products = [arg mutableCopy];
  }
}
@end
