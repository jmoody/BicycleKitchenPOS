//
//  BrowserNode.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/17/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ProductBrowserNode.h"
#import "PBNClassDescription.h"

@implementation ProductBrowserNode

+ (void) initialize {
  if ( self == [ProductBrowserNode class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    PBNClassDescription *cd = [[PBNClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"timesViewed",@"displayName",nil]];
    [superTypes setObject:LjIntType forKey:@"timesViewed"];
    [superTypes setObject:LjStringType forKey:@"displayName"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setTimesViewed:0];
  }
  return self;
}

- (void) dealloc {
  [displayName release];
  [super dealloc];
}




- (NSString *)displayName {
  return displayName;
}

- (bool)isLeafNode {
  return YES;
}

- (unsigned int)countOfChildren {
  return 0;
}

- (ProductBrowserNode *)objectInChildrenAtIndex:(unsigned int)index {
  return nil;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@ %@>", [[self class] description], 
    displayName];
}

- (void)setDisplayName:(NSString *)name {
  name = [name copy];
  [displayName release];
  displayName = name;
}

- (unsigned int) timesViewed {
  return timesViewed;
}

- (void) setTimesViewed:(unsigned int)times {
  timesViewed = times;
}

- (void) incfTimesViewed {
  timesViewed++;
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  // for uid
  [super encodeWithCoder:coder];
  [coder encodeInt:timesViewed forKey:@"timesViewed"];
  [coder encodeObject:displayName forKey:@"displayName"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  // for uid
  [super initWithCoder:coder];
  [self setTimesViewed:[coder decodeIntForKey:@"timesViewed"]];
  [self setDisplayName:[coder decodeObjectForKey:@"displayName"]];
  return self;
}

@end
