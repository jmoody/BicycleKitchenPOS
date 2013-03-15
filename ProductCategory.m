//
//  ProductCategory.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/17/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//


#import "ProductCategory.h"
#import "ProductBrowserNode.h"
#import "PCClassDescription.h"

@implementation ProductCategory

+ (void) initialize {
  if ( self == [ProductCategory class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    PCClassDescription *cd = [[PCClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"contents",nil]];
    [superTypes setObject:LjArrayType forKey:@"contents"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}


- (id)initWithDisplayName:(NSString *)name {
  self = [super init];
  if (self != nil) {
    [self setDisplayName:name];
  }
  return self;
}


- (void) dealloc {
  NSEnumerator *e = [contents objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    [value release];
  }
  [contents release];
  [super dealloc];
}

- (NSArray *)contents {
  return contents;
}

- (void)setContents:(NSArray *)array {
  if (array != contents) {
    [contents release];
    contents = [array mutableCopy];
  }
}

- (bool)isLeafNode {
  return NO;
}

- (unsigned int)countOfChildren {
  return [[self contents] count];
}

- (ProductBrowserNode *)objectInChildrenAtIndex:(unsigned int)index {
  return [[self contents] objectAtIndex:index];
}


@end
