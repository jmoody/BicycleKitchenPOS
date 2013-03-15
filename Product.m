//
//  Product.m
//  AnotherApp
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "Product.h"
#import "ProductClassDescription.h"

@implementation Product

+ (void) initialize {
  if ( self == [Product class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    ProductClassDescription *cd = [[ProductClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"productCode",@"productName",@"productCategory",@"productPrice",@"productQuantity",@"taxable",@"active",@"productDiscount",@"productTotal",nil]];
    [superTypes setObject:LjStringType forKey:@"productCode"];
    [superTypes setObject:LjStringType forKey:@"productName"];
    [superTypes setObject:LjStringType forKey:@"productCategory"];
    [superTypes setObject:LjDoubleType forKey:@"productPrice"];
    [superTypes setObject:LjIntType forKey:@"productQuantity"];
    [superTypes setObject:LjBooleanType forKey:@"taxable"];
    [superTypes setObject:LjBooleanType forKey:@"active"];
    [superTypes setObject:LjFloatType forKey:@"productDiscount"];
    [superTypes setObject:LjFloatType forKey:@"productTotal"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}

- (id) init {
  
  self = [super init];
  if (self != nil) {
    [self setProductCode:@""];
    [self setProductName:@""];
    [self setProductCategory:@""];
    [self setProductPrice:1.00];
    [self setProductQuantity:1];
    [self setTaxable:YES];
    [self setActive:YES];
  }
  //NSLog(@"in Product init");
  return self;
}

- (id) initWithCode:(NSString *)code 
               name:(NSString *)name 
           category:(NSString *)category 
              price:(double)price 
           quantity:(int)quantity 
            taxable:(bool)tax 
             active:(bool)act {
  self = [super init];
  if (self != nil) {
    
    [self setProductCode:code];
    // also sets the display name
    [self setProductName:name];
    [self setProductCategory:category];
    [self setProductPrice:price];
    [self setProductQuantity:quantity];
    [self setTaxable:tax];
    [self setActive:act];
    [self setProductDiscount:0.0];
    [self setProductTotal:0.0];
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************

- (void)dealloc {
  [productCode release];
  [productCategory release];
  [productName release];
  [super dealloc];
}


//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<Product: %@ %@ %@ %@ %f %d %d>",
    uid, productCode, productName, productCategory, productPrice, productQuantity, active];
}

- (NSString *)searchDescription {
  NSString *result = [NSString stringWithFormat:@"%@ %@ %@", productCode, productName, productCategory];
  return [result lowercaseString];
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  // for uid
  [super encodeWithCoder:coder];
  [coder encodeObject:productCode forKey:@"productCode"];
  [coder encodeObject:productName forKey:@"productName"];
  [coder encodeObject:productCategory forKey:@"productCategory"];
  [coder encodeDouble:productPrice forKey:@"productPrice"];
  [coder encodeInt:productQuantity forKey:@"productQuantity"];
  [coder encodeDouble:productDiscount forKey:@"productDiscount"];
  [coder encodeDouble:productTotal forKey:@"productTotal"];
  [coder encodeBool:taxable forKey:@"taxable"];
  [coder encodeBool:active forKey:@"active"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  // for uid
  [super initWithCoder:coder];
  [self setProductCode:[coder decodeObjectForKey:@"productCode"]];
  [self setProductName:[coder decodeObjectForKey:@"productName"]];
  [self setProductCategory:[coder decodeObjectForKey:@"productCategory"]];
  [self setProductPrice:[coder decodeDoubleForKey:@"productPrice"]];
  [self setProductQuantity:[coder decodeIntForKey:@"productQuantity"]];
  [self setProductDiscount:[coder decodeDoubleForKey:@"productDiscount"]];
  [self setProductTotal:[coder decodeDoubleForKey:@"productTotal"]];
  [self setTaxable:[coder decodeBoolForKey:@"taxable"]];
  [self setActive:[coder decodeBoolForKey:@"active"]];
  return self;
}

- (NSString *)activeYesOrNo {
  if (active) {
    return @"yes";
  } else {
    return @"no";
  }
}

//******************************************************************************
// accessors
//******************************************************************************

- (NSString *) productCode {
  return productCode;
}

- (NSString *) productName {
  return productName;
}

- (NSString *) productCategory {
  return productCategory;
}

- (double) productPrice {
  return productPrice;
}

- (int) productQuantity {
  return productQuantity;
}

- (double)productDiscount {
  return productDiscount;
}

- (double)productTotal {
  return productTotal;
}

- (bool)taxable {
  return taxable;
}

- (bool)active {
  return active;
}

//******************************************************************************
// setters
//******************************************************************************

- (void) setProductCode:(NSString *)code {
  code = [code copy];
  [productCode release];
  productCode = code;
}

- (void) setProductName:(NSString *)name {
  name = [name copy];
  [productName release];
  productName = name;
  // kind of like a super.
  [self setDisplayName:name];
}

- (void) setProductCategory:(NSString *)category {
  category = [category copy];
  [productCategory release];
  productCategory = category;
}

- (void) setProductPrice:(double)price {
  productPrice = price;
}

- (void) setProductQuantity:(int)quantity {
  productQuantity = quantity;  
}

- (void) setProductDiscount:(double)discount {
  productDiscount = discount;
}

- (void) setProductTotal:(double)total {
  productTotal = total;
}


- (void) setTaxable:(bool)isTaxable {
  taxable = isTaxable;
}

- (void) setActive:(bool)isActive {
  active = isActive;
}

- (bool) samep:(Product *)p {
  if ([[self uid] isEqualToString:[p uid]]) {
    return YES;
  } else {
    return NO;
  }
  
}


@end
