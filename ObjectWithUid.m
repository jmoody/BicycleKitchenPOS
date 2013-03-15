//
//  ObjectWithUid.m
//  UidGeneratorTest
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "ObjectWithUid.h"
#import "UidGenerator.h"
#import "OWUClassDescription.h"

@implementation ObjectWithUid

+ (void) initialize {
  if ( self == [ObjectWithUid class] ) {
    OWUClassDescription *cd = [[OWUClassDescription alloc] init];
    NSArray *keys = [NSArray arrayWithObject:@"uid"];
    NSArray *types = [NSArray arrayWithObject:LjStringType];
    NSDictionary *typeForKey = [NSDictionary dictionaryWithObjects:types forKeys:keys];
    [cd setAttributeKeys:keys];
    [cd setTypeForKey:typeForKey];
    [NSClassDescription registerClassDescription:cd forClass:[self class]]; 
    [cd release];
  }  
}

//******************************************************************************
// init
//******************************************************************************

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setUid:[[UidGenerator sharedInstance] generateUid]];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [uid release];
  [super dealloc];
}


//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  // you need this if object's superclass is something other than
  // NSObject
  // [super encodeWithCoder:coder];
  [coder encodeObject:uid forKey:@"uid"];
}

//******************************************************************************
// decode
//******************************************************************************
- (id)initWithCoder:(NSCoder *)coder {
  // you need this if object's superclass is something other than
  // NSObject
  //[super init];
  [self setUid:[coder decodeObjectForKey:@"uid"]];
  return self;
}

//******************************************************************************


- (NSString *)toCsv {
  id cd = [self classDescription];
  NSArray *attributes = [cd attributeKeys];
  NSDictionary *types = [cd typeForKey];
  
  NSString *result = @"";
  unsigned int i, count = [attributes count];
  //NSLog(@"UID = %@", [self uid]);
  for (i = 0; i < count; i++) {
    NSString *key = [attributes objectAtIndex:i];
    NSString *type = [types objectForKey:key];
    //NSLog(@"key, type = %@, %@", key, type);
    if ([type isEqualToString:LjArrayType]) {
      NSString *inner = @"";
      NSArray *innerArray = [self valueForKey:key];
      unsigned int j, innerCount = [innerArray count];
      for (j = 0; j < innerCount; j++) {
        NSString *str;
        id obj = [innerArray objectAtIndex:j];
        if ([obj isKindOfClass:[ObjectWithUid class]]) {
          str = [obj toCsv];
          NSArray *components = [str componentsSeparatedByString:@","];
          str = @"";
          unsigned int k, innerInnerCount = [components count];
          for (k = 0; k < innerInnerCount; k++) {
            str = [str stringByAppendingString:[components objectAtIndex:k]];
            if (k != (innerInnerCount - 1)) {
              str = [str stringByAppendingString:@" "];
            }
          }
          str = [NSString stringWithFormat:@"[%@]", str];
        } else if ([obj isKindOfClass:[NSString class]]) {
          str = [innerArray objectAtIndex:j];
        } else {
          str = [[innerArray objectAtIndex:j] description];
        }
        inner = [inner stringByAppendingString:str];
        if (j != (innerCount - 1)) {
          inner = [inner stringByAppendingString:@" "];
        }
      }
      result = [result stringByAppendingString:inner];
    } else if ([type isEqualToString:LjDoubleType]) {
      id val = [self valueForKey:key];
      double num = [val doubleValue];
      result = [result stringByAppendingString:[NSString stringWithFormat:@"%1.2f", num]];
    } else if ([type isEqualToString:LjFloatType]) {
      id val = [self valueForKey:key];
      float num = [val floatValue];
      result = [result stringByAppendingString:[NSString stringWithFormat:@"%1.2f", num]];
    } else if ([type isEqualToString:LjCalendarDateType]) {
      NSCalendarDate *date = [self valueForKey:key];
      NSString *dateStr = @"";
      if (date != nil) {
        dateStr = [date descriptionWithCalendarFormat:LjCalendarDateFormat];
      }
      result = [result stringByAppendingString:dateStr];
    } else if ([type isEqualToString:LjIntType]) {
      id val = [self valueForKey:key];
      int num = [val intValue];
      result = [result stringByAppendingString:[NSString stringWithFormat:@"%d", num]];
    } else if ([type isEqualToString:LjBooleanType]) {
      id val = [self valueForKey:key];
      bool boolVal = [val boolValue];
      result = [result stringByAppendingString:[NSString stringWithFormat:@"%d", boolVal]];
    } else if ([type isEqualToString:LjOwuType]) {
      ObjectWithUid *innerObject = [self valueForKey:key];
      NSString *str = [innerObject toCsv];
      NSArray *components = [str componentsSeparatedByString:@","];
      str = @"";
      unsigned int k, innerInnerCount = [components count];
      for (k = 0; k < innerInnerCount; k++) {
        str = [str stringByAppendingString:[components objectAtIndex:k]];
        if (k != (innerInnerCount - 1)) {
          str = [str stringByAppendingString:@" "];
        }
      }
      str = [NSString stringWithFormat:@"[%@]", str];
      result = [result stringByAppendingString:str];
    } else {
      NSString *str = [self valueForKey:key];
      NSArray *components = [str componentsSeparatedByString:@"\n"];
      str = [components componentsJoinedByString:LjNewlineSubstitute];
      components = [str componentsSeparatedByString:@","];
      str = [components componentsJoinedByString:@" "];
      if (str == nil) {
        str = @"";
      }
      result = [result stringByAppendingString:str];
    }
    if (i != (count - 1)) {
      result = [result stringByAppendingString:@","];
    }
  }
  return result;
}

//******************************************************************************

+ (id) fromCsv:(NSString *)str {
  id cd = [NSClassDescription classDescriptionForClass:[self class]];
  NSArray *attributeKeys = [cd attributeKeys];
  NSDictionary *types = [cd typeForKey];
  NSArray *tokens = [str componentsSeparatedByString:@","];
  
  id tmp = [[[self class] alloc] init];
  unsigned int i, count = [tokens count];
  for (i = 0; i < count; i++) {
    NSString *val = [tokens objectAtIndex:i];
    NSString *key = [attributeKeys objectAtIndex:i];
    NSString *type = [types objectForKey:key];
    if ([type isEqualToString:LjArrayType]) {
      NSMutableArray *innerArray = [[NSMutableArray alloc] init];
      NSArray *innerTokens = [val componentsSeparatedByString:@" "];
      NSEnumerator *enumer = [innerTokens objectEnumerator];
      NSString *token;
      while (token = [enumer nextObject]) {
        [innerArray addObject:token];
      }
      [tmp setValue:[NSArray arrayWithArray:innerArray] forKey:key];
      [innerArray release];
    } else if ([type isEqualToString:LjCalendarDateType]) {
      NSCalendarDate *date = [NSCalendarDate dateWithString:val calendarFormat:LjCalendarDateFormat];
      [tmp setValue:date forKey:key];
    } else {
      [tmp setValue:val forKey:key];
    }
  }
  [tmp autorelease];
  return tmp;  
}

//******************************************************************************
// uid comparison
//******************************************************************************

- (bool)uid:(NSString *)uid1 isEqual:(NSString *)uid2 {
  return [uid1 isEqualToString:uid2];
}

- (bool)object:(ObjectWithUid *)o1 isEqual:(ObjectWithUid *)o2 {
  return [self uid:[o1 uid] isEqual:[o2 uid]];
}

- (bool)samep:(ObjectWithUid *)owu {
  return [[self uid] isEqualToString:[owu uid]];
}

- (bool)array:(NSArray *)array containsUid:(NSString *)aUid {
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    NSString *str = (NSString *)[array objectAtIndex:i];
    if ([self uid:aUid isEqual:str]) {
      return YES;
    }
  }
  return NO;
}

- (bool)dictionary:(NSDictionary *)dict containsObjectForUid:(NSString *)aUid {
  NSEnumerator *ke = [dict keyEnumerator];
  id key;
  while (key = [ke nextObject]) {
    if ([self uid:key isEqual:aUid]) {
      return YES;
    }
  }
  return NO;
}

- (NSMutableArray *)newArrayByRemovingUid:(NSString *)aUid fromArray:(NSMutableArray *)array {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    NSString *str = (NSString *)[array objectAtIndex:i];
    if (![self uid:str isEqual:aUid]) {
      [result addObject:[str copy]];
    }
  }
  NSMutableArray *returnVal = [NSMutableArray arrayWithArray:result];
  [result release];
  return returnVal;
}


- (NSMutableArray *)newArrayByRemovingUids:(NSArray *)uids fromArray:(NSMutableArray *)array {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    NSString *uidInArray = (NSString *)[array objectAtIndex:i];
    if (![self array:uids containsUid:uidInArray]) {
      [result addObject:[uidInArray copy]];
    }
  }
  NSMutableArray *returnVal = [NSMutableArray arrayWithArray:result];
  [result release];
  return returnVal;
}

- (int)indexOfObjectWithUid:(NSString *)aUid inArrayOfUids:(NSArray *) array {
  //NSLog(@"index of object with uid");
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    NSString *obj = (NSString *)[array objectAtIndex:i];
    if ([aUid isEqualToString:obj]) {
      return i;
    }
  }
  return -1;
}


- (int)indexOfObjectWithUid:(NSString *)aUid inArray:(NSArray *) array {
  //NSLog(@"index of object with uid");
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    ObjectWithUid *obj = (ObjectWithUid *)[array objectAtIndex:i];
    if ([aUid isEqualToString:[obj uid]]) {
      return i;
    }
  }
  return -1;
}

- (void)removeObjectWithUid:(NSString *)aUid fromArray:(NSMutableArray *)array {
  //NSLog(@"remove object with uid");
  int index = [self indexOfObjectWithUid:aUid inArray:array];
  [array removeObjectAtIndex:index];
}

- (void)removeObjectWithUid:(NSString *)aUid fromArrayOfUids:(NSMutableArray *)array {
  //NSLog(@"remove object with uid");
  int index = [self indexOfObjectWithUid:aUid inArrayOfUids:array];
  [array removeObjectAtIndex:index];
}

//******************************************************************************
// accessors
//****************************************************************************** 

- (NSString *)uid {
  return uid;
}


//******************************************************************************
// setters
//******************************************************************************

- (void) setUid:(NSString *)newUid {
  newUid = [newUid copy];
  [uid release];
  uid = newUid;
}


@end
