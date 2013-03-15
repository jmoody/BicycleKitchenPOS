//
//  ObjectWithDate.m
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "ObjectWithDate.h"
#import "OWDClassDescription.h"

@implementation ObjectWithDate

+ (void) initialize {
  if ( self == [ObjectWithDate class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    OWDClassDescription *cd = [[OWDClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"date",nil]];
    [superTypes setObject:LjCalendarDateType forKey:@"date"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setDate:[NSCalendarDate calendarDate]];
  
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [date release];
  [super dealloc];
}

//******************************************************************************
// encoding
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  // for uid
  [super encodeWithCoder:coder];
  [coder encodeObject:date forKey:@"date"];
}

//******************************************************************************
// decoding
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  // for uid
  [super initWithCoder:coder];
  [self setDate:[coder decodeObjectForKey:@"date"]];
  return self;
}

//******************************************************************************
// accessors
//******************************************************************************
- (NSCalendarDate *)date {
  return date;
}

//******************************************************************************
// setters
//******************************************************************************
- (void)setDate:(NSCalendarDate *) d {
  [d retain];
  [date release];
  date = d;
}

@end
