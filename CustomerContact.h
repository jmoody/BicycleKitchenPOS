//
//  CustomerContact.h
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithComment.h"

@interface CustomerContact : ObjectWithComment {
  bool leftMessage;
  bool spokeDirectly;
  bool sentEmail;
  NSString *personUid;
}

- (NSString *)personName;
- (NSString *)personEmail;
- (NSString *)personPhone;

- (NSString *)stringForContactType;

- (bool) leftMessage;
- (bool) spokeDirectly;
- (bool) sentEmail;
- (NSString *)personUid;

- (void) setLeftMessage:(bool)left;
- (void) setSpokeDirectly:(bool)spoke;
- (void) setSentEmail:(bool)sent;
- (void) setPersonUid:(NSString *)newUid;

@end
