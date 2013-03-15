//
//  Credits.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Credits.h"
#import "DictionarySingleton.h"

@implementation Credits

+ (Credits *)sharedInstance {
  ////NSLog(@"in sharedInstance Credits");
  static Credits *s_MySingleton = nil;
  
  @synchronized([Credits class]) {
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
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/credits.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
   // if ([self dictionary] == nil) {
//      [self setDictionary:[[NSMutableDictionary alloc] init]];
//    }
    [self setNotificationChangeString:@"CreditsChanged"];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}


- (void)saveToDisk {
  NSLog(@"in creditsSaveToDisk");
  // post a notification that contacts has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}



@end
