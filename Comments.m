//
//  Comments.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/25/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Comments.h"
#import "DictionarySingleton.h"

@implementation Comments

+ (Comments *)sharedInstance {
  ////NSLog(@"in sharedInstance Comments");
  static Comments *s_MySingleton = nil;
  
  @synchronized([Comments class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}


- (id) initSingleton {
 // //NSLog(@"in contacts init");
  if (self = [super initSingleton]) {
    
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/comments.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"CommentsChanged"];
    
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}

- (void)saveToDisk {
  // post a notification that contacts has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}


@end
