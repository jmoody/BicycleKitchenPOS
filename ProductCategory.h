//
//  ProductCategory.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/17/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProductBrowserNode.h"

@interface ProductCategory : ProductBrowserNode {
  NSArray *contents;
}

- (id)initWithDisplayName:(NSString *)name;
- (NSArray *)contents;
- (void)setContents:(NSArray *)array;


@end
