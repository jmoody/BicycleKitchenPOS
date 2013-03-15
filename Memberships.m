//
//  Memberships.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/28/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Memberships.h"


@implementation Memberships

+ (Memberships *)sharedInstance {
  ////NSLog(@"in sharedInstance Memberships");
  static Memberships *s_MySingleton = nil;
  
  @synchronized([Memberships class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  if (self = [super initSingleton]) {
    ////NSLog(@"in Memberships initSingleton");
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/memberships.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"MembershipsChanged"];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}


- (void)saveToDisk {
  // post a notification that contacts has changed.
  //NSLog(@"in Memberships save to disk");
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}
  


@end
