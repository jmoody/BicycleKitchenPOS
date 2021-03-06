// 
// OWUClassDescription.m
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import "OWUClassDescription.h"

NSString *LjArrayType = @"array";
NSString *LjIntType = @"int";
NSString *LjDoubleType = @"double";
NSString *LjStringType = @"string";
NSString *LjDateType = @"date";
NSString *LjDateFormat = @"%Y-%m-%d %H:%M:%S %z";
NSString *LjCalendarDateType = @"calendarDate";
NSString *LjCalendarDateFormat = @"%Y-%m-%d %H:%M:%S %z";
NSString *LjBooleanType = @"boolean";
NSString *LjFloatType = @"float";
NSString *LjOwuType = @"owu";
NSString *LjOwuArrayType = @"owuArray";
NSString *LjNewlineSubstitute = @"|";

@implementation OWUClassDescription
- (id) init {
  self = [super init];
  if (self != nil) {
    NSArray *tmpA = [[NSArray alloc] init];
    [self setAttributeKeys:tmpA];
    [tmpA release];
    NSDictionary *tmpD = [[NSDictionary alloc] init];
    [self setTypeForKey:tmpD];
    [tmpD release];
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void) dealloc {
  [attributeKeys release];
  [super dealloc];
}


//******************************************************************************
// description
//******************************************************************************
- (NSString *)description {
  return [NSString stringWithFormat:@"<OWUClassDescription: >"];
}


//******************************************************************************
// methods
//******************************************************************************

- (NSString *)inverseForRelationshipKey:(NSString *)key {
  return @"";
}

//******************************************************************************

- (NSArray *)toManyRelationshipKeys {
  NSMutableArray *toMany = [[NSMutableArray alloc] init];
  NSEnumerator *keys = [[self typeForKey] keyEnumerator];
  NSString *key;
  while (key = [keys nextObject]) {
    NSString *val = [[self typeForKey] objectForKey:key];
    if ([val isEqualToString:LjArrayType]) {
      [toMany addObject:key];
    }
  }
  NSArray *returnVal = [NSArray arrayWithArray:toMany];
  [toMany release];
  return returnVal;
}

//******************************************************************************

- (NSArray *)toOneRelationshipKeys {
  NSMutableArray *toOne = [[NSMutableArray alloc] init];
  NSEnumerator *keys = [[self typeForKey] keyEnumerator];
  NSString *key;
  while (key = [keys nextObject]) {
    NSString *val = [[self typeForKey] objectForKey:key];
    if (![val isEqualToString:LjArrayType]) {
      [toOne addObject:key];
    }
  }
  NSArray *returnVal = [NSArray arrayWithArray:toOne]; 
  [toOne release];
  return returnVal;
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (NSArray *)attributeKeys {
  return attributeKeys;
}

- (void) setAttributeKeys:(NSArray *)arg {
  if (arg != attributeKeys) {
    [attributeKeys release];
    NSArray *sorted = [arg sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    attributeKeys = [sorted mutableCopy];
  }
}
- (NSDictionary *)typeForKey {
  return typeForKey;
}
- (void) setTypeForKey:(NSDictionary *)arg {
  if (arg != typeForKey) {
    [typeForKey release];
    typeForKey = [arg mutableCopy];
  }
}

@end