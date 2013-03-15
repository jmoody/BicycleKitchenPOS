//
//  DataSingleton.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "DictionarySingleton.h"
#import "FTSWAbstractSingleton.h"
#import "CustomerContact.h"
#import "ShopCredit.h"
#import "Invoice.h"
#import "Person.h"
#import "Product.h"
#import "ProductCategory.h"
#import "Project.h"
#import "Book.h"
#import "OWUClassDescription.h"

@implementation DictionarySingleton

+ (DictionarySingleton *)sharedInstance {
  //NSLog(@"in sharedInstance DictionarySingleton");
  static DictionarySingleton *s_MySingleton = nil;
  
  @synchronized([DictionarySingleton class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }

  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  //NSLog(@"in initSingleton DictionarySingleton");
  if (self = [super initSingleton]) {
    // ? what to do here
    //if ([self singleton] == nil)  [singleton retain];
  }
  return self;
}

- (void) dealloc {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];  
  [dictionary release];
  [pathToArchive release];
  [notificationChangeString release];
  [super dealloc];
}


//******************************************************************************
// toCsv
//******************************************************************************

- (NSString *)toCsv {
  NSArray *array = [self arrayForDictionary];
  id stored = [array objectAtIndex:0];
  NSString *result = [NSString stringWithFormat:@"%@\n", [[stored class] className]];
  OWUClassDescription *cd = (OWUClassDescription *)[stored classDescription];
  NSArray *attributes = [cd attributeKeys];
  NSDictionary *types = [cd typeForKey];
  
  unsigned int i, count;
  count = [attributes count];
  for (i = 0; i < count; i++) {
    NSString *key = [attributes objectAtIndex:i];
    NSString *type = [types objectForKey:key];
    NSString *keyTypePair = [NSString stringWithFormat:@"%@:%@", key, type];
    result = [result stringByAppendingString:keyTypePair];
    if (i != (count - 1)) {
      result = [result stringByAppendingString:@","];
    }
  }
  result = [result stringByAppendingString:@"\n"];
  
  count = [array count];
  for (i = 0; i < count; i++) {
    id obj = [array objectAtIndex:i];
    //NSLog(@"[obj toCsv] = %@", [obj toCsv]);
    result = [result stringByAppendingFormat:@"%@\n", [obj toCsv]];
    //NSLog(@"result = %@", result);
  }
  //NSLog(@"result = %@", result);
  return result;
}

//******************************************************************************
// to Data
//******************************************************************************

- (NSData *)toData {
//  NSString *result = [self toCsv];
//  NSLog(@"length result = %d bytes = %d", [result length], [result lengthOfBytesUsingEncoding:NSASCIIStringEncoding]);
//  NSLog(@"can be converted to encoding: %d", [result canBeConvertedToEncoding:NSASCIIStringEncoding]);
//  NSData *data = [result dataUsingEncoding:NSASCIIStringEncoding];
//  NSLog(@"data = %@", data);
//  return data;
  return [[self toCsv] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
}


//******************************************************************************
// addObject:
//******************************************************************************

- (void)addObject:(ObjectWithUid *)owu {
  [self setObject:owu forUid:[owu uid]];
}


- (void)saveToDisk {
  //NSLog(@"in dictionary singleton saveToDisk");
  bool success;
  success = [NSKeyedArchiver archiveRootObject:[self dictionary] toFile:[self pathToArchive]];
  if (success) {
    //NSLog(@"%@ successfully archived", [self className]);
  } else {
    //NSLog(@"*** error archiving");
  }
}


- (void)setObject:(NSObject *)obj forUid:(NSString *)uid {
  //NSLog(@"in dictionary singleton setObject");
  //NSLog(@"obj %@ uid %@", obj, uid);
  [dictionary setObject:obj forKey:uid];
  //NSLog(@"dictionary after setObject: %@", dictionary);
  [self saveToDisk];
}

- (void)removeObjectForUid:(NSString *)uid {
  if (uid == nil) {
    NSLog(@"Error: tried to remove object for nil key.");
  } else {
    [dictionary removeObjectForKey:uid];
  }
  [self saveToDisk];
}

- (id)objectForUid:(NSString *)uid {
  NSEnumerator *ke = [dictionary keyEnumerator];
  id key;
  while (key = [ke nextObject]) {
    NSString *str = (NSString *)key;
    if ([str isEqualToString:uid]) {
      return [dictionary objectForKey:key];
    }
  }
  return nil;
}



- (NSMutableArray *)objectsForUids:(NSArray *)uids {
  NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[uids count]];
  unsigned int i, count = [uids count];
  for (i = 0; i < count; i++) {
    NSString *key = (NSString *)[uids objectAtIndex:i];
    id val = [self objectForUid:key];
    if (val) {
      [result addObject:val];
    }
  }
  NSMutableArray *returnVal = [NSMutableArray arrayWithArray:result];
  [result release];
  return returnVal;
}


- (NSMutableArray *)arrayForDictionary {
  NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    [result addObject:value];
  }
  NSMutableArray *returnVal = [NSMutableArray arrayWithArray:result];
  [result release];
  return returnVal;
}


// for contacts
- (CustomerContact *)contactForUid:(NSString *)uid {
  return nil;
}

  // for credits
- (ShopCredit *)creditForUid:(NSString *)uid {
  return nil;
}

  // for invoices
- (Invoice *)invoiceForUid:(NSString *)uid {
  return nil;
}


// for people
- (Person *)personForUid:(NSString *)uid {
  return nil;
}

- (Person *)personForName:(NSString *)uid {
  return nil;
}

- (bool)personNameAppearsInPeopleInSingleton:(Person *)p{
  return nil;
}

- (NSArray *)peopleForNameInPeopleInSingleton:(Person *)p{
  return nil;
}

- (NSArray *)peopleStringsForNameInPeopleInSingleton:(Person *)p{
  return nil;
}

- (NSString *)alertMessageForDuplicatePersonsInCustomerAdd:(Person *)p{
  return nil;
}

- (bool)emailAddressAppearsInPeopleInSingleton:(Person *)p{
  return nil;
}

- (bool)phoneNumberIsBadlyFormatted:(NSString *)number{
  return YES;
}

// for products

- (Product *)productForProductUid:(NSString *)uid {
  return nil;
}

- (Product *)productForProductCode:(NSString *)code {
  return nil;
}

- (Product *)productForProductName:(NSString *)name {
  return nil;
}

// for product categories
- (NSArray *)arrayFromCategoriesInSingleton {
  return nil;
}
  
- (NSArray *)arrayForBrowserFromProducts:(NSMutableDictionary *)products {
  return nil;
}

- (NSArray *)sortedProducts:(NSMutableDictionary *)products forCatagory:(NSString *)category {
  return nil;
}
  
- (void)incfCategoryTimesViewedForProduct:(Product *)p {

}

- (ProductCategory *)productCategoryForProduct:(Product *)p {
  return nil;
}

- (ProductCategory *)productCategoryForCategoryName:(NSString *)name {
  return nil;
}
  

// book/journal
- (Book *)currentBook {
  return nil;
}

- (void)setCurrentBook:(Book *)book {
  
}

- (void)setStandTime:(double)hours {
  
}

- (double)standTime {
  return 0.0;
}


- (NSMutableDictionary *)dictionary {
  return dictionary;
}

- (NSString *)pathToArchive {
  return pathToArchive;
}

- (NSString *)notificationChangeString {
  return notificationChangeString;
}

- (void)setNotificationChangeString:(NSString *)str {
  str = [str copy];
  [notificationChangeString release];
  notificationChangeString = str;
}


- (void)setDictionary:(NSDictionary *)dict {
  if (dict != dictionary) {
    [dictionary release];
    dictionary = [dict mutableCopy];
  } else if (dict == nil) {
    NSLog(@"dict argument was nil in setDictionary - something is probably wrong in an archived database");
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] init];
    [self setDictionary:tmp];
    [tmp release];
  }
}

- (void)setPathToArchive:(NSString *)path {
  [path copy];
  [pathToArchive release];
  pathToArchive = path;
}


@end
