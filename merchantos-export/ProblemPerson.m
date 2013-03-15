// Copyright (c) 2011 Little Joy Software
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

//  ProblemPerson.m
//  BicycleKitchenPOS
//
//  Created by Joshua Moody on 2/11/11.

#import "ProblemPerson.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *FIXED = @"fixed";
NSString *NOTFIXED = @"NOT fixed";

@implementation ProblemPerson

@synthesize person;
@synthesize field;
@synthesize reason;
@synthesize value;
@synthesize state;

- (id) initWithPerson:(Person *) aPerson 
                field:(NSString *) aField 
               reason:(NSString *) aReason
               value:(NSString *) aValue
                state:(NSString *) aState {
  self = [super init];
  if (self != nil) {
    self.person = aPerson;
    self.field = aField;
    self.reason = aReason;
    self.value = aValue;
    self.state = aState;
  }
  return self;
}


- (void) dealloc {
  [person release];
  [field release];
  [reason release];
  [value release];
  [state release];
  [super dealloc];
}

- (NSString *) description {
  NSString *result = [NSString stringWithFormat:@"%@ %@ field: %@ reason: %@ value: %@ status: %@",
                      [self.person uid], [self.person personName], 
                      self.field, self.reason, self.value, self.state];
  return result;
}


@end

