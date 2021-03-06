// 
// Comp.m
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import "Comp.h"
#import "Invoices.h"
#import "People.h"
#import "Books.h"
#import "Product.h"
#import "CompClassDescription.h"

@implementation Comp

+ (void) initialize {
  if ( self == [Comp class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    CompClassDescription *cd = [[CompClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"personUid",@"items",@"bookUid",@"pathToPdfArchive",nil]];
    [superTypes setObject:LjStringType forKey:@"personUid"];
    [superTypes setObject:LjArrayType forKey:@"items"];
    [superTypes setObject:LjStringType forKey:@"bookUid"];
    [superTypes setObject:LjStringType forKey:@"pathToPdfArchive"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}


- (id) init {
  self = [super init];
  if (self != nil) {
    [self setPersonUid:@""];
    NSArray *array = [[NSArray alloc] init];
    [self setItems:array];
    [array release];
    [self setBookUid:@""];

  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void) dealloc {
  [personUid release];
  [items release];
  [bookUid release];
  [pathToPdfArchive release];  
  [super dealloc];
}


//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:personUid forKey:@"personUid"];
  [coder encodeObject:items forKey:@"items"];
  [coder encodeObject:pathToPdfArchive forKey:@"pathToPdfArchive"];
}


//******************************************************************************
// decode
//******************************************************************************
- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setPersonUid:[coder decodeObjectForKey:@"personUid"]];
  [self setItems:[coder decodeObjectForKey:@"items"]];
  [self setPathToPdfArchive:[coder decodeObjectForKey:@"pathToPdfArchive"]];
  
  return self;
}


//******************************************************************************
// methods
//******************************************************************************
- (Book *)bookForComp {
  Book *b = (Book *)[[Books sharedInstance] objectForUid:[self bookUid]];
  return b;
}

//******************************************************************************

- (Person *)personForComp {
  Person *p = (Person *)[[People sharedInstance] objectForUid:[self personUid]];
  return p;
}

//******************************************************************************

- (NSString *)personName {
  return [[self personForComp] personName];
}

//******************************************************************************

- (NSString *)personPhone {
  return [[self personForComp] phoneNumber];
}

//******************************************************************************

- (NSString *)personEmail {
  return [[self personForComp] emailAddress];
}

//******************************************************************************

- (NSString *)personCompany {
  return [[self personForComp] companyName];
}

//******************************************************************************

- (NSString *)personAddress {
  return [[self personForComp] address];
}

//******************************************************************************

- (NSString *)personCity {
  return [[self personForComp] city];
}

//******************************************************************************

- (NSString *)personState {
  return [[self personForComp] addressState];
}

//******************************************************************************

- (NSString *)personZip {
  return [[self personForComp] zip];
}

//******************************************************************************

- (NSString *)cookNameOrInitials {
  return [self commentAuthorName];
}

//******************************************************************************

- (NSString *)reason {
  return [self commentSubject];
}

//******************************************************************************

- (NSString *)note {
  return [self commentText];
}

//******************************************************************************

- (double)valueOfComp {
  double sum = 0.0;
  unsigned int i, count = [items count];
  for (i = 0; i < count; i++) {
    Product *p = [items objectAtIndex:i];
    int qty = [p productQuantity];
    double price = [p productPrice];
    double total = qty * price;
    sum = sum + total;
  }
  return sum;
}

//******************************************************************************

- (double)taxableValue {
  double sum = 0.0;
  unsigned int i, count = [items count];
  for (i = 0; i < count; i++) {
    Product *p = [items objectAtIndex:i];
    if ([p taxable]) {
      int qty = [p productQuantity];
      double price = [p productPrice];
      double total = qty * price;
      sum = sum + total;
    }
  }
  return sum;  
}

//******************************************************************************

- (double)untaxableValue {
  double sum = 0.0;
  unsigned int i, count = [items count];
  for (i = 0; i < count; i++) {
    Product *p = [items objectAtIndex:i];
    if (![p taxable]) {
      int qty = [p productQuantity];
      double price = [p productPrice];
      double total = qty * price;
      sum = sum + total;
    }
  }
  return sum;    
}

//******************************************************************************
// accessors and setters
//******************************************************************************
- (NSString *)personUid {
  return personUid;
}
- (void) setPersonUid:(NSString *)arg {
 arg = [arg copy];
  [personUid release];
  personUid = arg;
}
- (NSMutableArray *)items {
  return items;
}
- (void) setItems:(NSArray *)arg {
  if (arg != items) {
    [items release];
    items = [arg mutableCopy];
  }
}
- (NSString *)bookUid {
  return bookUid;
}
- (void) setBookUid:(NSString *)arg {
 arg = [arg copy];
  [bookUid release];
  bookUid = arg;
}
- (NSString *)pathToPdfArchive {
  return pathToPdfArchive;
}
- (void) setPathToPdfArchive:(NSString *)arg {
  arg = [arg copy];
  [pathToPdfArchive release];
  pathToPdfArchive = arg;
}
@end