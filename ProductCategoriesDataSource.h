//
//  ProductCategoriesDataSource.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/18/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ProductCategoriesDataSource : NSObject {

  NSArray *data;
  int previousSearchStringLength;
}

- (NSArray *)data;
- (void)setData:(NSArray *)newData;

// required
- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox;
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index;
// required for autocomplete
- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)uncompletedString;


- (NSString *)categoryAtIndex:(int)index;
- (bool)validCategory:(NSString *)category;

- (void)makeData;



@end
