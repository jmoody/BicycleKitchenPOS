//
//  Bicycle.m
//  AnotherApp
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "Bicycle.h"
#import "BicycleClassDescription.h"


@implementation Bicycle

+ (void) initialize {
  if ( self == [Bicycle class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    BicycleClassDescription *cd = [[BicycleClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"bicycleMake",@"bicycleModel",@"bicycleColor",@"bicycleType",nil]];
    [superTypes setObject:LjStringType forKey:@"bicycleMake"];
    [superTypes setObject:LjStringType forKey:@"bicycleModel"];
    [superTypes setObject:LjStringType forKey:@"bicycleColor"];
    [superTypes setObject:LjStringType forKey:@"bicycleType"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setBicycleMake:@"make"];
    [self setBicycleModel:@"model"];
    [self setBicycleColor:@"color"];
    [self setBicycleType:@"type"];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [bicycleMake release];
  [bicycleModel release];
  [bicycleColor release];
  [bicycleType release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)shortDescription {
  return [NSString stringWithFormat:@"%@ %@ %@ %@", 
    bicycleColor, bicycleMake, bicycleModel, bicycleType];
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<Bicycle: %@>", [self shortDescription]];
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  // for uid
  [super encodeWithCoder:coder];
  [coder encodeObject:bicycleModel forKey:@"bicycleModel"];
  [coder encodeObject:bicycleMake forKey:@"bicycleMake"];
  [coder encodeObject:bicycleColor forKey:@"bicycleColor"];
  [coder encodeObject:bicycleType forKey:@"bicycleType"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  // for uid
  [super initWithCoder:coder];
  [self setBicycleModel:[coder decodeObjectForKey:@"bicycleModel"]];
  [self setBicycleMake:[coder decodeObjectForKey:@"bicycleMake"]];
  [self setBicycleColor:[coder decodeObjectForKey:@"bicycleColor"]];
  [self setBicycleType:[coder decodeObjectForKey:@"bicycleType"]];
  return self;
}

//******************************************************************************
// accessors
//******************************************************************************

- (NSString *)bicycleMake {
  return bicycleMake;
}

- (NSString *)bicycleModel {
  return bicycleModel;
}

- (NSString *)bicycleColor {
  return bicycleColor;
}

- (NSString *)bicycleType {
  return bicycleType;
}

//******************************************************************************
// setters
//******************************************************************************

- (void)setBicycleMake:(NSString *)make {
  make = [make copy];
  [bicycleMake release];
  bicycleMake = make;
}

- (void)setBicycleModel:(NSString *)model {
  model = [model copy];
  [bicycleModel release];
  bicycleModel = model;
}

- (void)setBicycleColor:(NSString *)color {
  color = [color copy];
  [bicycleColor release];
  bicycleColor = color;
}

- (void)setBicycleType:(NSString *)type {
  type = [type copy];
  [bicycleType release];
  bicycleType = type;
}

//- (void)setBicycleType:(NSString *)type {
//  if (!([type isEqualToString:[NSString stringWithFormat:@"mountain"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"road"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"hybrid"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"step-through"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"cruiser"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"BMX-style"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"tandem"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"tricycle"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"other"]] |
//        [type isEqualToString:[NSString stringWithFormat:@"track"]])) {
//    NSRunAlertPanel(@"Error:  bad bicycle type",
//                    @"Bicycle type must be mountain, road, hybrid, step-through, cruiser, BMX, track, or other",
//                    @"Ok",nil,nil);
//    
//  } else {
//    type = [type copy];
//    [bicycleType release];
//    bicycleType = type;
//  }  
//}


@end
