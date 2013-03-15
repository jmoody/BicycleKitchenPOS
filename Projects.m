//
//  Projects.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/22/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Projects.h"
#import "Project.h"

Projects *projectsSingleton = nil;

@implementation Projects

+ (Projects *)sharedInstance {
  ////NSLog(@"in sharedInstance Products");
  static Projects *s_MySingleton = nil;
  
  @synchronized([Projects class]) {
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
    ////NSLog(@"in projects initSingleton");
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/projects.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"ProjectsChanged"];
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
