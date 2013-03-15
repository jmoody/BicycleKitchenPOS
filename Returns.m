//
//  Returns.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/6/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Returns.h"


@implementation Returns

+ (Returns *)sharedInstance {
  ////NSLog(@"in sharedInstance Returns");
  static Returns *s_MySingleton = nil;
  
  @synchronized([Returns class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id) initSingleton {
  ////NSLog(@"in checks init");
  if (self = [super initSingleton]) {
    
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/returns.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"ChecksChanged"];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (void)saveToDisk {
  // post a notification that Returns has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}


@end
