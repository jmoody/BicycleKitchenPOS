//
//  BrowserNode.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/17/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithUid.h"


@interface ProductBrowserNode : ObjectWithUid {
  int timesViewed;
  NSString *displayName;
}

- (bool) isLeafNode;
- (unsigned int) timesViewed;
- (NSString *)displayName;
- (unsigned int)countOfChildren;
- (ProductBrowserNode *)objectInChildrenAtIndex:(unsigned int)index;
- (unsigned int) timesViewed;

- (void) setDisplayName:(NSString *)name;
- (void) setTimesViewed:(unsigned int)times;
- (void) incfTimesViewed;


@end
