//
//  InKindDonationItem.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface InKindDonationItem : NSObject <NSCoding> {
  NSString *item;
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSString *)item;
- (void)setItem:(NSString *)arg;

  //******************************************************************************
  // misc
  //******************************************************************************


@end