//
//  InKindDonations.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "InKindDonations.h"

@implementation InKindDonations

+ (InKindDonations *)sharedInstance {
  static InKindDonations *s_MySingleton = nil;
  
  @synchronized([InKindDonations class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id) initSingleton {
  if (self = [super initSingleton]) {
    
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/inKindDonations.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"InKindDonationsChanged"];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (void)saveToDisk {
  // post a notification that InKindDonations has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}

@end
