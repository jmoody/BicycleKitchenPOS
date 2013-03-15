//
//  CurrentJournal.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "CurrentJournal.h"


@implementation CurrentJournal

+ (CurrentJournal *)sharedInstance {
  //NSLog(@"in sharedInstance CurrentJournal");
  static CurrentJournal *s_MySingleton = nil;
  
  @synchronized([CurrentJournal class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
    }
  }
  
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  //NSLog(@"in initSingleton CurrentJournal");
  if (self = [super initSingleton]) {
    
  }
  return self;
}

- (void) dealloc {
  [journal release];
  [super dealloc];
}


- (Book *)journal {
  return journal;
}

- (void) setJournal:(Book *)arg {
  [arg retain];
  [journal release];
  journal = arg;
}


@end
