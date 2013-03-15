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

//  MerchantOSExport.h
//  BicycleKitchenPOS
//
//  Created by Joshua Moody on 2/10/11.

#import <Foundation/Foundation.h>
#import "Person.h"

extern NSString *FirstName;
extern NSString *LastName;
extern NSString *Title;
extern NSString *Company;
extern NSString *DOB;
extern NSString *Address1;
extern NSString *Address2;
extern NSString *City;
extern NSString *State;
extern NSString *ZipCode;
extern NSString *Country;
extern NSString *HomePhone;
extern NSString *WorkPhone;
extern NSString *Fax;
extern NSString *Pager;
extern NSString *Mobile;
extern NSString *EMail;
extern NSString *EMail2;
extern NSString *Website;
extern NSString *Custom;
extern NSString *Notes;
extern NSString *TaxCategory;
extern NSString *DiscountCategory;
extern NSString *SerializedItemDescription;
extern NSString *SerializedItemNumber;
extern NSString *SerializedItemColor;
extern NSString *SerializedItemSize;

extern NSString *pathToCustomerTabDelimited;
extern NSString *pathToCustomerCsvDelimited;

extern int const MinASCII;
extern int const MaxASCII;

extern int const MinNumericASCII;
extern int const MaxNumericASCII;

extern NSString *ForeignCharacters;
extern NSString *NonNumericValue;
extern NSString *InvalidEmailMissingAt;
extern NSString *InvalidEmailTooManyAt;
extern NSString *InvalidEmailNonAlphaNumeric;

extern NSString *TooManyCharacters;

extern NSString *CookMembership;

extern int const TwoFiftyFive;

@interface MerchantOSExport : NSObject {
  NSArray *allCustomerFields;
  NSMutableArray *problems;
  Person *currentPerson;
  NSCharacterSet *whiteSpace;
}

@property (nonatomic, retain) NSArray *allCustomerFields;
@property (nonatomic, retain) NSMutableArray *problems;
@property (nonatomic, retain) Person *currentPerson;
@property (nonatomic, retain) NSCharacterSet *whiteSpace;

- (NSString *) makeLogMessageForError:(NSError *) error;

- (BOOL) doCustomerExport:(NSString *) path delimiter:(NSString *) delimiter error:(NSError **) error;

- (NSString *) makeCustomerHeader:(NSString *) delimiter;

- (BOOL) stringContainsNoForeignCharacters:(NSString *) string;

- (NSString *) firstNameFromName:(NSString *) name;

- (NSString *) lastNameFromName:(NSString *) name;

- (NSString *) fixZipCode:(NSString *) zip;

- (BOOL) lengthOfString:(NSString *) string exceedsMaxCharacterCount:(int) max atField:(NSString *) field;

- (NSString *) formatPhoneNumber:(NSString *) number;

@end
