//
//  Invoices.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/23/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Invoices.h"
#import "Invoice.h"


@implementation Invoices

+ (Invoices *)sharedInstance {
  ////NSLog(@"in sharedInstance Invoices");
  static Invoices *s_MySingleton = nil;
  
  @synchronized([Invoices class]) {
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
    ////NSLog(@"in invoices initSingleton");
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/invoices.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"InvoicesChanged"];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}


- (void)saveToDisk {
  // post a notification that contacts has changed.
  //NSLog(@"in invoices save to disk");
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}



@end
