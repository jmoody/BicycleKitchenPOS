//
//  Contacts.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/23/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Contacts.h"
#import "CustomerContact.h"
#import "DictionarySingleton.h"


@implementation Contacts

+ (Contacts *)sharedInstance {
  ////NSLog(@"in sharedInstance Contacts");
  static Contacts *s_MySingleton = nil;
  
  @synchronized([Contacts class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}


- (id) initSingleton {
  ////NSLog(@"in contacts init");
  if (self = [super initSingleton]) {
    
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/contacts.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"ContactsChanged"];
    
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
