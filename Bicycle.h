//
//  Bicycle.h
//  AnotherApp
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithUid.h"

@interface Bicycle : ObjectWithUid {
  NSString *bicycleMake;
  NSString *bicycleModel;
  NSString *bicycleColor;
  NSString *bicycleType;
}

- (NSString *)shortDescription;

- (NSString *)bicycleMake;
- (NSString *)bicycleModel;
- (NSString *)bicycleColor;
- (NSString *)bicycleType;


- (void)setBicycleMake:(NSString *)make;
- (void)setBicycleModel:(NSString *)model;
- (void)setBicycleColor:(NSString *)color;
- (void)setBicycleType:(NSString *)type;

@end
