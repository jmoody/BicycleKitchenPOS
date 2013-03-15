//
//  Checks.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/9/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Checks.h"


@implementation Checks

+ (Checks *)sharedInstance {
  ////NSLog(@"in sharedInstance Checks");
  static Checks *s_MySingleton = nil;
  
  @synchronized([Checks class]) {
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
    
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/checks.db";
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
  // post a notification that Checks has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}


@end
