//
//  Customers.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "People.h"
#import "Person.h"

@implementation People

+ (People *)sharedInstance {
  ////NSLog(@"in sharedInstance People");
  static People *s_MySingleton = nil;
  
  @synchronized([People class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}


- (id)initSingleton {
  if (self = [super initSingleton]) {
    ////NSLog(@"in people initSingleton");
    
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/people.db";
    pathString = [pathString stringByStandardizingPath];
    [self setPathToArchive:pathString];
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:[self pathToArchive]]; 
    
    [self setDictionary:dict];

    [self setNotificationChangeString:@"PeopleChanged"];
    //[self setDictionary:[[NSMutableDictionary alloc] init]];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}


- (void)saveToDisk {
  // post a notification that contacts has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}


//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<People: %@>", dictionary];
  
}

- (Person *)personForUid:(NSString *)uid {
  return [dictionary objectForKey:uid];
}

- (Person *)personForName:(NSString *)name {
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    if ([[value personName] isEqualToString:@"quick sale"]) {
      return value;
    }
  }
  return nil;
}

//******************************************************************************

- (bool)personNameAppearsInPeopleInSingleton:(Person *)p {
  NSString *name = [p personName];
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    ////NSLog(@"%@ == %@ is: %d" , value, p, ([[value personName] isEqualToString:name] && (p != value)));
    if ([[value personName] isEqualToString:name] && (p != value)) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (NSArray *)peopleForNameInPeopleInSingleton:(Person *) p {
  NSString *name = [p personName];
  NSMutableArray *matches = [[NSMutableArray alloc] init];
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while ((value = [e nextObject])) {
    if ([[value personName] isEqualToString:name] && (p != value)) {
      [matches addObject:value];
    }
  }
  NSArray *returnVal = [NSArray arrayWithArray:matches];
  [matches release];
  return returnVal;
}

//******************************************************************************

- (NSArray *)peopleStringsForNameInPeopleInSingleton:(Person *)p {
  NSString *name = [p personName];
  NSMutableArray *matches = [[NSMutableArray alloc] init];
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while ((value = [e nextObject])) {
    if ([[value personName] isEqualToString:name] && (p != value)) {
      [matches addObject:[NSString stringWithFormat:@"%@ %@ %@", [value personName],
        [value phoneNumber], [value emailAddress]]];
    }
  }
  NSArray *returnVal = [NSArray arrayWithArray:matches];
  [matches release];
  return returnVal;
}

//******************************************************************************

- (NSString *)alertMessageForDuplicatePersonsInCustomerAdd:(Person *) p {
  NSArray *matches = [self peopleStringsForNameInPeopleInSingleton:p];
  NSString *result = [NSString stringWithFormat:@""];
  
  unsigned int i, count = [matches count];
  for (i = 0; i < count; i++) {
    id value = [matches objectAtIndex:i];
    result = [result stringByAppendingString:[NSString stringWithFormat:@"%@\n", value]];
  }
  return result;
}

//******************************************************************************

- (bool)emailAddressAppearsInPeopleInSingleton:(Person *)p {
  NSString *email = [p emailAddress];
  // empty email address will exist
  if ([email isEqualToString:[NSString stringWithFormat:@""]]) {
    return NO;
  }
  
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while ((value = [e nextObject])) {
    if ([[value emailAddress]isEqualToString:email] && (p != value)) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (bool)phoneNumberIsBadlyFormatted:(NSString *)number {

  // 123.456.7890
  // 012345678901
  if ([number length] == 0) {
    return NO;
  }
  
  if ([number length] != 12) {
    return YES;
  }
  
  char period = '.';
  
  if (([number characterAtIndex:3] != period) &&
      ([number characterAtIndex:7] != period)) {
    return YES;
  }
  
  NSString *firstThree = [number substringToIndex:3];
  int firstThreeAsInt = [firstThree intValue];
  
  // new jersey is 201 and 200 is a service access code
  if (firstThreeAsInt < 201) {
    return YES;
  }
  
  NSString *nextThree = [[number substringToIndex:7] substringFromIndex: 4];
  int nextThreeAsInt = [nextThree intValue];
  
  // let's assume that 100 is valid
  if (nextThreeAsInt < 100) {
    return YES;
  }
  
  NSCharacterSet *decimalSet = [NSCharacterSet decimalDigitCharacterSet];
  
////NSLog(@"number at 8 = %c is decimal: %d", [number characterAtIndex:8], 
//        [decimalSet characterIsMember:[number characterAtIndex:8]]);
//  
//  //NSLog(@"number at 9 = %c is decimal: %d", [number characterAtIndex:9], 
//        [decimalSet characterIsMember:[number characterAtIndex:9]]);
//  
//  //NSLog(@"number at 10 = %c is decimal: %d", [number characterAtIndex:10], 
//        [decimalSet characterIsMember:[number characterAtIndex:10]]);
//  
//  //NSLog(@"number at 11 = %c is decimal: %d", [number characterAtIndex:11], 
//        [decimalSet characterIsMember:[number characterAtIndex:11]]);
  
  if (!([decimalSet characterIsMember:[number characterAtIndex:8]]) ||
      !([decimalSet characterIsMember:[number characterAtIndex:9]]) ||
      !([decimalSet characterIsMember:[number characterAtIndex:10]]) ||
      !([decimalSet characterIsMember:[number characterAtIndex:11]])) {
    return YES;
  }
  return NO;
}


@end

