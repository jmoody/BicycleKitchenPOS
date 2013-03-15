//
//  DebitsAndCredits.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/9/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "DebitsAndCredits.h"

@implementation DebitsAndCredits

+ (DebitsAndCredits *)sharedInstance {
  ////NSLog(@"in sharedInstance debitsAndCredits");
  static DebitsAndCredits *s_MySingleton = nil;
  
  @synchronized([DebitsAndCredits class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id) initSingleton {
  ////NSLog(@"in debitsAndCredits init");
  if (self = [super initSingleton]) {
    
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/debits-and-credits.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"DebitsAndCreditsChanged"];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (void)saveToDisk {
  // post a notification that debitsAndCredits has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}

@end