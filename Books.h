//
//  Books.h
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DictionarySingleton.h"
#import "Book.h"
//@class Book;

@interface Books : DictionarySingleton {
  Book *currentBook;
}

- (Book *)currentBook;
- (void)setCurrentBook:(Book *)book;

- (void)setStandTime:(double)hours;
- (double)standTime;

@end
