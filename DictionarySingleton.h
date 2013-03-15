//
//  DataSingleton.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"
#import "CustomerContact.h"
#import "ShopCredit.h"
#import "Invoice.h"
#import "Person.h"
#import "Product.h"
#import "ProductCategory.h"
#import "Project.h"
#import "Book.h"
#import "ObjectWithUid.h"

@interface DictionarySingleton : FTSWAbstractSingleton {

  NSMutableDictionary *dictionary;
  NSString *pathToArchive;
  NSString *notificationChangeString;
}
 
+ (DictionarySingleton*)sharedInstance;


- (NSMutableDictionary *)dictionary;
- (NSString *)pathToArchive;
- (NSString *)notificationChangeString;

- (void)setDictionary:(NSDictionary *)dict;
- (void)setPathToArchive:(NSString *)path;
- (void)setNotificationChangeString:(NSString *)str;

- (void)saveToDisk;
- (NSMutableArray *)objectsForUids:(NSArray *)uids;


- (void)setObject:(NSObject *)obj forUid:(NSString *)uid;
- (void)removeObjectForUid:(NSString *)uid;
- (id)objectForUid:(NSString *)uid;

- (NSMutableArray *)arrayForDictionary;

// for contacts
- (CustomerContact *)contactForUid:(NSString *)uid;

// for credits
- (ShopCredit *)creditForUid:(NSString *)uid;

// for invoices
- (Invoice *)invoiceForUid:(NSString *)uid;


// for people
- (Person *)personForUid:(NSString *)uid;
- (Person *)personForName:(NSString *)uid;
- (bool)personNameAppearsInPeopleInSingleton:(Person *)p;
- (NSArray *)peopleForNameInPeopleInSingleton:(Person *)p;
- (NSArray *)peopleStringsForNameInPeopleInSingleton:(Person *)p;
- (NSString *)alertMessageForDuplicatePersonsInCustomerAdd:(Person *)p;
- (bool)emailAddressAppearsInPeopleInSingleton:(Person *)p;
- (bool)phoneNumberIsBadlyFormatted:(NSString *)number;

// for products
- (Product *)productForProductUid:(NSString *)uid;
- (Product *)productForProductCode:(NSString *)code;
- (Product *)productForProductName:(NSString *)name;

// for product categories
- (NSArray *)arrayFromCategoriesInSingleton;
- (NSArray *)arrayForBrowserFromProducts:(NSMutableDictionary *)products;
- (NSArray *)sortedProducts:(NSMutableDictionary *)products forCatagory:(NSString *)category;
- (void)incfCategoryTimesViewedForProduct:(Product *)p;
- (ProductCategory *)productCategoryForProduct:(Product *)p;
- (ProductCategory *)productCategoryForCategoryName:(NSString *)name;

  // book/journal
- (Book *)currentBook;
- (void)setCurrentBook:(Book *)book;

- (void)setStandTime:(double)hours;
- (double)standTime;

- (void)addObject:(ObjectWithUid *)owu;
- (NSString *)toCsv;
- (NSData *)toData;


@end
