//
//  Books.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Books.h"
//#import "Book.h"


@implementation Books

+ (Books *)sharedInstance {
  ////NSLog(@"in sharedInstance Books");
  static Books *s_MySingleton = nil;
  
  @synchronized([Books class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id) initSingleton {
  ////NSLog(@"in Books init");
  if (self = [super initSingleton]) {
    
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/books.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"BooksChanged"];
    
    //NSLog(@"books: %@", dictionary);
    // find the most recent open book
    NSEnumerator *e = [dictionary objectEnumerator];
    Book *book;
    while (book = (Book *)[e nextObject]) {
      if ([book isOpen]) {
        if (currentBook == nil) {
          [self setCurrentBook:book];
        } else {
          NSCalendarDate *bookDate = [book date];
          NSCalendarDate *bestDate = [currentBook date];
          if ([bookDate laterDate:bestDate]) {
            [self setCurrentBook:book];
          }
        }
      }
    }
  }
  return self;
}

- (void) dealloc {
  [currentBook release];
  [super dealloc];
}

- (void)saveToDisk {
  // post a notification that Books has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}

- (Book *)currentBook {
  return currentBook;
}
- (void) setCurrentBook:(Book *)arg {
  [arg retain];
  [currentBook release];
  currentBook = arg;
}

- (void)setStandTime:(double)hours {
  if (currentBook != nil) {
    [currentBook setStandTimeTotal:hours];
  }
}

- (double)standTime {
  if (currentBook == nil) {
    return 0.0;
  } else {
    return [currentBook standTimeTotal];
  }
}


@end
