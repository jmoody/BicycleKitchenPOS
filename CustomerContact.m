//
//  CustomerContact.m
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "CustomerContact.h"
#import "Person.h"
#import "People.h"
#import "CCClassDescription.h"

@implementation CustomerContact

+ (void) initialize {
  if ( self == [CustomerContact class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    CCClassDescription *cd = [[CCClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"leftMessage",@"spokeDirectly",@"sentEmail",@"personUid",nil]];
    [superTypes setObject:LjBooleanType forKey:@"leftMessage"];
    [superTypes setObject:LjBooleanType forKey:@"spokeDirectly"];
    [superTypes setObject:LjBooleanType forKey:@"sentEmail"];
    [superTypes setObject:LjStringType forKey:@"personUid"];
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
    [self setCommentAuthorName:[NSString stringWithFormat:@"some cook"]];
    [self setCommentSubject:[NSString stringWithFormat:@""]];
    [self setCommentText:[NSString stringWithFormat:@""]];
  }
  ////NSLog(@"in CustomerContact init: %@", self);
  return self;
}


//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<CustomerContact: %@ %@\n %@>",
    [self commentAuthorName], [self date], [self commentText]];
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [personUid release];
  [super dealloc];
}

//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  // for uid
  [super encodeWithCoder:coder];
  [coder encodeBool:leftMessage forKey:@"leftMessage"];
  [coder encodeBool:spokeDirectly forKey:@"spokeDirectly"];
  [coder encodeBool:sentEmail forKey:@"sentEmail"];
  [coder encodeObject:personUid forKey:@"personUid"];
}


//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  // for uid
  [super initWithCoder:coder];
  [self setLeftMessage:[coder decodeBoolForKey:@"leftMessage"]];
  [self setSpokeDirectly:[coder decodeBoolForKey:@"spokeDirectly"]];
  [self setSentEmail:[coder decodeBoolForKey:@"sentEmail"]];
  [self setPersonUid:[coder decodeObjectForKey:@"personUid"]];
  return self;
}

//******************************************************************************
// getting owner information
//******************************************************************************

- (NSString *)personName {
  Person *p = [[People sharedInstance] personForUid:personUid];
  return [p personName];
}

- (NSString *)personEmail {
  Person *p = [[People sharedInstance] personForUid:personUid];
  return [p emailAddress];
}

- (NSString *)personPhone {
  Person *p = [[People sharedInstance] personForUid:personUid];
  return [p phoneNumber];
}

- (NSString *)stringForContactType {
  if (sentEmail) {
    return @"sent email";
  } else if (leftMessage) {
    return @"left message";
  } else {
    return @"spoke directly";
  }
}

//******************************************************************************
// accessors
//****************************************************************************** 

- (bool) leftMessage {
  return leftMessage;
}

- (bool) spokeDirectly {
  return spokeDirectly;
}

- (bool) sentEmail {
  return sentEmail;
}

- (NSString *)personUid {
  return personUid;
}

//******************************************************************************
// setters
//******************************************************************************

- (void) setLeftMessage:(bool)left {
  leftMessage = left;
}

- (void) setSpokeDirectly:(bool)spoke {
  spokeDirectly = spoke;
}

- (void) setSentEmail:(bool)sent {
  sentEmail = sent;
}

- (void) setPersonUid:(NSString *)newUid {
  newUid = [newUid copy];
  [personUid release];
  personUid = newUid;
}

@end
