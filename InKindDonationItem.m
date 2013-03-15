//
//  InKindDonationItem.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "InKindDonationItem.h"

@implementation InKindDonationItem
- (id) init {
  self = [super init];
  if (self != nil) {
    [self setItem:@""];
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void) dealloc {
  [item release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

//- (NSString *)description {
//  return [NSString stringWithFormat:@"<InKindDonationItem %@>", item];
//}

- (NSString *)description {
  return item;
}


//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  //[super encodeWithCoder:coder];
  [coder encodeObject:item forKey:@"item"];
}


//******************************************************************************
// decode
//******************************************************************************
- (id)initWithCoder:(NSCoder *)coder {
  //[super initWithCoder:coder];
  [self setItem:[coder decodeObjectForKey:@"item"]];
  return self;
}


//******************************************************************************
// methods
//******************************************************************************



//******************************************************************************
// accessors and setters
//******************************************************************************
- (NSString *)item {
  return item;
}
- (void) setItem:(NSString *)arg {
  arg = [arg retain];
  [item release];
  item = arg;
}
@end