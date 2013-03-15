//
//  ObjectWithDate.h
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithUid.h"

@interface ObjectWithDate : ObjectWithUid {
  NSCalendarDate *date;
}

- (NSCalendarDate *)date;

- (void)setDate:(NSCalendarDate *) d;

@end
