//
//  ProductCategories.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/18/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DictionarySingleton.h"

@interface ProductCategories : DictionarySingleton {

}

- (void)makeProductCategories;


//- (NSMutableDictionary *)categoriesInSingleton;
//- (NSString *)pathToCategoriesArchive;
//
//- (void)setCategoriesInSingleton:(NSDictionary *)dictionary;
//- (void)setPathToCategoriesArchive:(NSString *)path;


//- (void)handleCategoryInsert:(NSNotification *)note;
//- (void)handleCategoryDelete:(NSNotification *)note;
//- (void)applyEditToProductCategoriesAndSaveToDisk:(ProductCategory *)pc;


//+ (id)sharedInstance;


@end
