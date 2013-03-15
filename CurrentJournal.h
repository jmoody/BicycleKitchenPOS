//
//  CurrentJournal.h
//  BicycleKitchenPOS
//
//  Created by moody on 12/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"
#import "Book.h"

@interface CurrentJournal : FTSWAbstractSingleton {
  Book *journal;
}

- (Book *)journal;
- (void)setJournal:(Book *)arg;

@end
