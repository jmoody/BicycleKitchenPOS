//
//  Products.h
//  BicycleKitchenPOS
//
//  Created by moody on 7/17/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DictionarySingleton.h"
#import "Product.h"

@interface Products : DictionarySingleton {

}

- (void)makeProducts;

//  NSMutableDictionary *productsInSingleton;
//  NSString *pathToProductsArchive;
//}
//
//- (NSMutableDictionary *)productsInSingleton;
//- (NSString *)pathToProductsArchive;
//
//- (void)setProductsInSingleton:(NSDictionary *)dictionary;
//- (void)setPathToProductsArchive:(NSString *)path;
//
//- (void)handleProductInsert:(NSNotification *)note;
//- (void)handleProductDelete:(NSNotification *)note;
//- (void)applyEditAndSaveToDisk:(Product *)p;
//- (void)saveProductsToDisk;
//
//- (void)makeProducts;
//
//- (NSMutableArray *)arrayForDictionary;
//
//
//- (Product *)productForProductUid:(NSString *)uid;
//- (Product *)productForProductCode:(NSString *)code;
//- (Product *)productForProductName:(NSString *)name;
//
//
//+ (id)sharedInstance;


@end
