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

//  MerchantOSExport.m
//  BicycleKitchenPOS
//
//  Created by Joshua Moody on 2/10/11.

#import "MerchantOSExport.h"
#import "LjsObjectExporter.h"
#import "Person.h"
#import "People.h"
#import "ProblemPerson.h"
#import "LjsStringUtils.h"
#import "Membership.h"
#import "Memberships.h"
#import "Lumberjack.h"
#import "Invoice.h"
#import "Invoices.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

NSString *FirstName = @"First Name";
NSString *LastName = @"Last Name";
NSString *Title = @"Title";
NSString *Company = @"Company";
NSString *DOB = @"DOB";
NSString *Address1 = @"Address 1";
NSString *Address2 = @"Address 2";
NSString *City = @"City";
NSString *State = @"State";
NSString *ZipCode = @"Zip Code";
NSString *Country = @"Country";
NSString *HomePhone = @"Home Phone";
NSString *WorkPhone = @"Work Phone";
NSString *Fax = @"Fax";
NSString *Pager = @"Pager";
NSString *Mobile = @"Mobile";
NSString *EMail = @"E-Mail";
NSString *EMail2 = @"E-Mail 2";
NSString *Website = @"Website";
NSString *Custom = @"Custom";
NSString *Notes = @"Notes";
NSString *TaxCategory = @"Tax Category";
NSString *DiscountCategory = @"Discount Category";
NSString *SerializedItemDescription = @"Serialized Item Description";
NSString *SerializedItemNumber = @"Serialized Item Number";
NSString *SerializedItemColor = @"Serialized Item Color";
NSString *SerializedItemSize = @"Serialized Item Size";


NSString *pathToCustomerTabDelimited = @"/Users/moody/tmp/customer-tab.txt";
NSString *pathToCustomerCsvDelimited = @"/Users/moody/tmp/customer.csv";

int const MinASCII = 32;
int const MaxASCII = 126;

int const MinNumericASCII = 48;
int const MaxNumericASCII = 57;

NSString *ForeignCharacters = @"foreign characters";
NSString *NonNumericValue = @"non-numeric characters";
NSString *InvalidEmail = @"invalid email";

NSString *InvalidEmailMissingAt =  @"email missing @";
NSString *InvalidEmailTooManyAt = @"email has too many @";
NSString *InvalidEmailNonAlphaNumeric = @"email contains non-alphanumeric characters";


NSString *TooManyCharacters = @"Too Many Characters";

NSString *CookMembership = @"cook";

int const TwoFiftyFive = 255;

@implementation MerchantOSExport

@synthesize allCustomerFields;
@synthesize problems;
@synthesize currentPerson;
@synthesize whiteSpace;

- (id) init {
  self = [super init];
  if (self != nil) {
    self.allCustomerFields = [NSArray arrayWithObjects:FirstName,
                              LastName,
                              Title,
                              Company,
                              DOB,
                              Address1,
                              Address2,
                              City,
                              State,
                              ZipCode,
                              Country,
                              HomePhone,
                              WorkPhone,
                              Fax,
                              Pager,
                              Mobile,
                              EMail,
                              EMail2,
                              Website,
                              Custom,
                              Notes,
                              TaxCategory,
                              DiscountCategory,
                              SerializedItemDescription,
                              SerializedItemNumber,
                              SerializedItemColor,
                              SerializedItemSize,
                              nil];
    
    self.problems = [[NSMutableArray alloc] init];
    self.currentPerson = nil;
    self.whiteSpace = [NSCharacterSet whitespaceCharacterSet];
  }
  return self;
}


- (void) dealloc {
  [allCustomerFields release];
  [problems release];
  [currentPerson release];
  [whiteSpace release];
  [super dealloc];
}


- (NSString *) makeLogMessageForError:(NSError *) error {
  NSString *result;
  NSString *message = [error localizedDescription];
  NSString *reason = [error localizedFailureReason];
  NSString *domain = [error domain];
  int code = [error code];
  NSDictionary *userInfo = [error userInfo];
  
  result = [NSString stringWithFormat:@"ERROR %@:%i => %@ %@:%@ userInfo has %i entries", domain, code, message, reason, [userInfo count]];
  return result;
               
}

- (BOOL) doCustomerExport:(NSString *) path delimiter:(NSString *) delimiter error:(NSError **) error {
  BOOL result;
  NSFileManager *fm = [NSFileManager defaultManager];
  if ([fm fileExistsAtPath:path]) {
    NSError *pathExistsError;
    BOOL resultOfRemove = [fm removeItemAtPath:path error:&pathExistsError];
    if (resultOfRemove != YES) {
      NSString *logMessage = [self makeLogMessageForError:pathExistsError];
      DDLogError(@"%@", logMessage);
      error = &pathExistsError;
      result = NO;
    }
  } else {
    NSError *lineError = nil;
    NSArray *people = [[People sharedInstance] arrayForDictionary];
    
    int numberOfPeople = [people count];
    DDLogVerbose(@"number of people = %i", numberOfPeople);
    int counter = 0;
    NSMutableArray *lines = [[NSMutableArray alloc] init];
    NSString *export = [self makeCustomerHeader:delimiter];
    [lines addObject:export];
    
    for (Person *person in people) {
      counter++;
      DDLogVerbose(@"processing person %i of %i", counter, numberOfPeople - 1);
      self.currentPerson = person;
      NSMutableArray *line = [[NSMutableArray alloc] initWithCapacity:[allCustomerFields count]];
      NSString *name = [[person personName] stringByTrimmingCharactersInSet:self.whiteSpace];
      
      
      /*
       
       20070507171505400
       20070923181722100

       ethan - want to delete, but has invoices i can't see
       2007071821295720
       
       buck - want to delete but has invoices i can't see
       maybe the same person as buck herra
       2008091313332190
       
       submergedart has no contact info, but invoices i can't see
       20070630152619100
       
       */
      if ([name isEqualToString:@""]) {        
        NSArray *invoicesIds = [person invoiceUids];
        if ([invoicesIds count] != 0) {
          NSMutableArray *tmpInvoices = [NSMutableArray arrayWithCapacity:[invoicesIds count]];
          for (NSString *invId in invoicesIds) {
            Invoice *invoice = [[Invoices sharedInstance] objectForUid:invId];
            if (invoice != nil) {
              [tmpInvoices addObject:invoice];
            }
          }
          
          if ([tmpInvoices count] != 0) {
            /*
            DDLogError(@"Person has no name but has invoices: %@", tmpInvoices);
            ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:FirstName reason:@"Person has no name but invoices" value:[person uid] state:NOTFIXED];
            [problems addObject:problem];
            [problem release];                      
             */
            name = @"Unknown Person-With-Invoices";
          } else {
            name = @"Unknown Person-Without-Invoices";
          }
        }
      }
      
      NSString *firstName = [[self firstNameFromName:name] stringByTrimmingCharactersInSet:self.whiteSpace];
      [self lengthOfString:firstName exceedsMaxCharacterCount:TwoFiftyFive atField:FirstName];
      
      [line addObject:firstName];
      NSString *lastName = [[self lastNameFromName:name] stringByTrimmingCharactersInSet:self.whiteSpace];
      [self lengthOfString:lastName exceedsMaxCharacterCount:TwoFiftyFive atField:LastName];
      
      [line addObject:lastName];
      // Title
      [line addObject:@""];
      // Company
      [line addObject:@""];
      // DOB
      [line addObject:@""];
      // Address1
      NSString *address =  [[person address] stringByTrimmingCharactersInSet:self.whiteSpace];
      address =[address stringByReplacingOccurrencesOfString:@"," withString:@""];
      if (![self stringContainsNoForeignCharacters:address]) {
        DDLogError(@"address1 contains foreign characters:  %@", address);
        ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:Address1 reason:ForeignCharacters value:address state:NOTFIXED];
        [problems addObject:problem];
        [problem release];
      }
      [self lengthOfString:address exceedsMaxCharacterCount:TwoFiftyFive atField:Address1];
      [line addObject:address];
      
      
      // Address2
      [line addObject:@""];
      
      // City
      NSString *city = [[person city] stringByTrimmingCharactersInSet:self.whiteSpace];
      if (![self stringContainsNoForeignCharacters:address]) {
        DDLogError(@"city contains foreign characters:  %@", city);
        ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:City reason:ForeignCharacters value:city state:NOTFIXED];
        [problems addObject:problem];
        [problem release];
      }
      [self lengthOfString:city exceedsMaxCharacterCount:TwoFiftyFive atField:City];
      [line addObject:city];
      
      // State
      NSString *state = [[person addressState] stringByTrimmingCharactersInSet:self.whiteSpace];
      if (![self stringContainsNoForeignCharacters:state]) {
        DDLogError(@"state contains foreign characters:  %@", state);
        ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:State reason:ForeignCharacters value:state state:NOTFIXED];
        [problems addObject:problem];
        [problem release];
      }
      [self lengthOfString:state exceedsMaxCharacterCount:TwoFiftyFive atField:State];
      [line addObject:state];
      
      // ZipCode
      NSString *zip = [[person zip] stringByTrimmingCharactersInSet:self.whiteSpace];
      zip = [self fixZipCode:zip];

      [self lengthOfString:zip exceedsMaxCharacterCount:5 atField:ZipCode];
      [line addObject:zip];
      
      // Country
      [line addObject:@""];
      
      // HomePhone
      [line addObject:@""];
      
      // WorkPhone
      [line addObject:@""];
      
      // Fax
      [line addObject:@""];
      
      // Pager
      [line addObject:@""];
      
      // Mobile
      NSString *phone = [[person phoneNumber] stringByTrimmingCharactersInSet:self.whiteSpace];
      
      /**
       2008090410332566 mike heasley field: Mobile reason: non-numeric characters value: na status: NOT fixed
       20080113164952394 santa clara cycling club field: Mobile reason: non-numeric characters value: 323nocarro status: NOT fixed
       */
      if ([[person uid] isEqualToString:@"2008090410332566"]) {
        phone = @"";
      } else if ([[person uid] isEqualToString:@"20080113164952394"]) {
        phone = @"";
      }
      
      
      
      /*
       20070620184708450 david kesler field: Mobile reason: Not Exactly 10 digits value: 000000 status: NOT fixed
       2011011516174473 anne mcneal field: Mobile reason: non-numeric characters value: n/a status: NOT fixed
       */
       
      if ([[person uid] isEqualToString:@"20070620184708450"] ||
          [[person uid] isEqualToString:@"2011011516174473"] ) {
        phone = @"";
      }
      
      phone = [phone stringByReplacingOccurrencesOfString:@"." withString:@""];
      phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
      phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
      phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
      phone = [phone stringByReplacingOccurrencesOfString:@"," withString:@""];
      
      if (![phone isEqualToString:@""]) {
        if (![LjsObjectExporter allCharacterOfString:phone areBetweenMin:MinNumericASCII maxASCII:MaxNumericASCII]) {
          DDLogError(@"phone contains non-numeric characters:  %@", phone);
          ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:Mobile reason:NonNumericValue value:phone state:NOTFIXED];
          [problems addObject:problem];
          [problem release];        
        } else if ([phone length] != 10) {
          DDLogError(@"phone does not contain exactly 10 digits: %@", phone);
          ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:Mobile reason:@"Not Exactly 10 digits" value:phone state:NOTFIXED];
          [problems addObject:problem];
          [problem release];
        } else {
          NSString *formatedString = [self formatPhoneNumber:phone];
          [line addObject:formatedString];
        }
      } else {
        [line addObject:@""];
      }

      // Email
      NSString *email = [[person emailAddress] stringByTrimmingCharactersInSet:self.whiteSpace];
      
      // experimental
      email = [email stringByReplacingOccurrencesOfString:@" " withString:@""];
      
      
      /*
       20090430190111366 sparkle wilkerson field: E-Mail reason: email contains non-alphanumeric characters value: djspank86@yahoo,com status: NOT fixed
       2008030912301053 ian forester field: E-Mail reason: email contains non-alphanumeric characters value: ianforester@gmail,com status: NOT fixed
       */
      email = [email stringByReplacingOccurrencesOfString:@",com" withString:@".com"];
      
      /*
       20090112151123373 rob sprinkle field: E-Mail reason: email contains non-alphanumeric characters value: liveintruth@gmail/com status: NOT fixed
       */
      email = [email stringByReplacingOccurrencesOfString:@"/com" withString:@".com"];
      
      /*
       20071119165009488 damien newton field: E-Mail reason: email missing @ value: ? status: NOT fixed
       20071115191908294  wyatt cenac field: E-Mail reason: email missing @ value: ? status: NOT fixed
       */
      if ([email isEqualToString:@"?"]) {
        email = @"";
      }
      
      /*
       2008030914373278 sharon chan field: E-Mail reason: email missing @ value: quietstormking2hotmail.com status: NOT fixed
       */
      if ([[person uid] isEqualToString:@"2008030914373278"]) {
        email = @"quietstormking2@hotmail.com";
      }
      
      /*
       maybe don't fix
       bad email and address damein
       20071119165009500
       */
    
      
      if ([email isEqualToString:@"?"]) {
        email = @"";
      }
      
      if (![email isEqualToString:@""]) {
        NSArray *tokens = [email componentsSeparatedByString:@"@"];
        int tokenCount = [tokens count];
        if (tokenCount == 1) {
          DDLogError(@"email does not contain @ symbol: %@", email);
//          ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:EMail reason:InvalidEmailMissingAt value:email state:FIXED];
//          [problems addObject:problem];
//          [problem release];
          email = @"";
          
        } else if (tokenCount > 2) {
          DDLogError(@"email has too many @ symbols: %@", email);
          ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:EMail reason:InvalidEmailTooManyAt value:email state:NOTFIXED];
          [problems addObject:problem];
          [problem release];
        }
         
                
        NSCharacterSet *nonAlphaNumeric = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        
        
        NSString *withoutAt = [email stringByReplacingOccurrencesOfString:@"@" withString:@""];
        NSString *withoutUnderscore = [withoutAt stringByReplacingOccurrencesOfString:@"_" withString:@""];
        NSString *withoutDots = [withoutUnderscore stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSString *withoutDashes = [withoutDots stringByReplacingOccurrencesOfString:@"-" withString:@""];
        tokens = [withoutDashes componentsSeparatedByCharactersInSet:nonAlphaNumeric];
        
        if ([tokens count] != 1) {
          DDLogError(@"email has non-alphanumeric characters:  %@", email);
          ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:EMail reason:InvalidEmailNonAlphaNumeric value:email state:NOTFIXED];
          [problems addObject:problem];
          [problem release];
        }
      }
    
      [self lengthOfString:email exceedsMaxCharacterCount:TwoFiftyFive atField:EMail];
      [line addObject:email];
    
      // Email2
      [line addObject:@""];
      
      // Website
      [line addObject:@""];
      
      // Custom
      [line addObject:[[person uid] stringByTrimmingCharactersInSet:self.whiteSpace]];
      
      // Notes
      [line addObject:@""];
      
      // TaxCategory
      [line addObject:@""];
      
      // DiscountCategory
      Membership *membership = [person membership];
      NSString *membershipType = [[membership membershipType] stringByTrimmingCharactersInSet:self.whiteSpace];
      if (![membershipType isEqualToString:CookMembership] &&
          ![membershipType isEqualToString:@"regular"] &&
          ![membershipType isEqualToString:@"deluxe"] &&
          ![membershipType isEqualToString:@"no"] ) {
        DDLogError(@"unknown membership type:  %@ for %@", membershipType, [currentPerson personName]);
        ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:DiscountCategory reason:@"unknown membership"
                                                                 value:membershipType state:NOTFIXED];
        [self.problems addObject:problem];
        [problem release];
      }
      
      if ([membershipType isEqualToString:CookMembership]) {
        [line addObject:membershipType];
      } else {
        [line addObject:@""];
      }

      // SerializedItemDescription,  
      [line addObject:@""];
      
      // SerializedItemNumber,  
      [line addObject:@""];
      
      // SerializedItemColor,  
      [line addObject:@""];
      
      // SerializedItemSize
      [line addObject:@""];
      
      //     0 1        1 1     2 0    3 0     4 0   5 1       6 ?      7  1  8  1   9  1      10  0    11   0    12  0    13 0  14 0    15 1    16 1   17 0  
      // FirstName, LastName, Title, Company, DOB, Address1, Address2, City, State, ZipCode, Country, HomePhone, WorkPhone, Fax, Pager, Mobile, EMail, EMail2, 
      //  18 0     19 1    20 0   21  0         22  1               23 0                        24 0                  24 0                     25 0
      // Website, Custom, Notes, TaxCategory, DiscountCategory, SerializedItemDescription,  SerializedItemNumber,  SerializedItemColor,  SerializedItemSize,
          
      /**
       NSString *phoneNumber;
       NSString *emailAddress;
       NSString *companyName;
       NSString *city;
       NSString *addressState;
       NSString *zip;
       bool willTakeCheckFrom;
       bool hasSignedLiabilityWaiver;
       NSString *membershipUid;
       NSMutableArray *projectUids;
       NSMutableArray *commentUids;
       NSMutableArray *invoiceUids;
       NSMutableArray *creditUids;
       NSMutableArray *contactUids;
       NSMutableArray *cashDonationUids;
       NSMutableArray *inKindDonationUids;
       NSMutableArray *compUids;
       */
      
      NSString *lineString = [LjsObjectExporter arrayOfStrings:line separatedByDelimiter:delimiter error:&lineError];
      if (lineError != nil) {
        NSString *message = [self makeLogMessageForError:lineError];
        DDLogError(@"error exporting line %i: %@", counter, message);
        break;
      } else {
        [lines addObject:lineString];
      }

    }
    
    
    
    DDLogVerbose(@"the following problems where found:");

    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"field" ascending:YES] autorelease];
    NSArray *sorters = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sorted = [self.problems sortedArrayUsingDescriptors:sorters];
    for (ProblemPerson *problem in sorted) {
      DDLogVerbose(@"%@", problem);
    }
    
    if ([self.problems count] == 0) {
      NSError *linesError = nil;
      NSString *exportString = [LjsObjectExporter arrayOfStrings:lines separatedByDelimiter:@"\n" error:&linesError];
      if (linesError != nil) {
        NSString *message = [self makeLogMessageForError:linesError];
        DDLogError(@"error exporting lines: %@", message);
        result = NO;
      } else {
        NSData *asData = [exportString dataUsingEncoding:NSASCIIStringEncoding];
        [fm createFileAtPath:path contents:asData attributes:nil];
      }

    } else {
      result = NO;
    }
  }
  return result;
}

                           
- (NSString *) makeCustomerHeader:(NSString *) delimiter {
  NSString *result = [LjsObjectExporter arrayOfStrings:self.allCustomerFields 
                                  separatedByDelimiter:delimiter 
                                                 error:nil];
  return result;
}

- (BOOL) stringContainsNoForeignCharacters:(NSString *) string {
  BOOL result = [LjsObjectExporter allCharacterOfString:string areBetweenMin:MinASCII maxASCII:MaxASCII];
  return result;
}


- (NSString *) firstNameFromName:(NSString *) name {
  
  NSArray *tokens = [name componentsSeparatedByString:@" "];
  NSString *result = @"";
  result = [result stringByAppendingFormat:@"%@", [tokens objectAtIndex:0]];
  if (![self stringContainsNoForeignCharacters:result]) {
    DDLogError(@"first name contains foreign characters:  %@", result);
    ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:FirstName reason:ForeignCharacters value:result state:NOTFIXED];
    [problems addObject:problem];
    [problem release];
  }
  return result;
}

- (NSString *) lastNameFromName:(NSString *) name {
  // 20070414153411507 juan guillén field: Last Name reason: foreign characters value: guillén status: NOT fixed
  // 2008030915180389 bj dehu† field: Last Name reason: foreign characters value: dehu† status: NOT fixed
  
  NSString *uid = [self.currentPerson uid];
  NSArray *tokens = [name componentsSeparatedByString:@" "];
  NSString *result = @"";
  int length = [tokens count];
  for (int index = 1; index < length; index++) {
    result = [result stringByAppendingFormat:@"%@", [tokens objectAtIndex:index]];
  }
  
  if (![self stringContainsNoForeignCharacters:result]) {
    DDLogError(@"last name contains foreign characters:  %@", result);
    if ([uid isEqualToString:@"20070414153411507"]) {
      result = @"guillen";
    } else if ([uid isEqualToString:@"2008030915180389"]) {
      result = @"dehu";
    } else {
      ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:LastName reason:ForeignCharacters value:result state:NOTFIXED];
      [problems addObject:problem];
      [problem release];
    }
  }
  return result;
}


- (NSString *) fixZipCode:(NSString *) zip {
/*
 2007011418141716 thomas gotschi field: Zip Code reason: Too Man Characters value: 123456 status: NOT fixed
 20080609125306201 kelly egeck field: Zip Code reason: non-numeric characters value: 9-0266 status: NOT fixed
 20080609125306201 kelly egeck field: Zip Code reason: Too Man Characters value: 9-0266 status: NOT fixed
 2009100513290896 audrey pino field: Zip Code reason: non-numeric characters value: t status: NOT fixed
 20101009172449133 pablo henriquez field: Zip Code reason: non-numeric characters value: fhdry status: NOT fixed
 20071119165009488 damien newton field: Zip Code reason: non-numeric characters value: ? status: NOT fixed
 20071115191908294  wyatt cenac field: Zip Code reason: non-numeric characters value: ? status: NOT fixed
  */
  
  /*
   20110109131539332 ron lis field: Zip Code reason: non-numeric characters value: fdf status: NOT fixed
   2011020820595004 jill sykes field: Zip Code reason: non-numeric characters value: sdsdas status: NOT fixed
   2011020820595004 jill sykes field: Zip Code reason: Too Many Characters value: sdsdas status: NOT fixed
*/   
  
  NSString *result = @"";
  NSString *personId = [self.currentPerson uid];
  if ([zip isEqualToString:@"?"] ||
      [zip isEqualToString:@"t"] ||
      [personId isEqualToString:@"2007011418141716"] ||
      [personId isEqualToString:@"20101009172449133"] ||
      [personId isEqualToString:@"20110109131539332"] ||
      [personId isEqualToString:@"2011020820595004"]) {
    result = @"";
  } else if ([zip isEqualToString:@"9-0266"]) {
    result = @"90266";
  } else if ([zip isEqualToString:@"91066-0844"]) {
    // 2010082914060152 james rasulo  field: Zip Code reason: non-numeric characters value: 91066-0844 status: NOT fixed
    result = @"91066";
  } else if ([personId isEqualToString:@"2010112913452725"]) {
    // 2010112913452725 christian schrader field: Zip Code reason: Too Many Characters value: 900005 status: NOT fixed
    result = @"90005";
  } else if (![zip isEqualToString:@""]) {
    
     if (![self stringContainsNoForeignCharacters:zip]) {
      DDLogError(@"zip contains foreign characters:  %@", zip);
      ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:ZipCode reason:ForeignCharacters value:zip state:NOTFIXED];
      [problems addObject:problem];
      [problem release];
    }
  
    if (![LjsObjectExporter allCharacterOfString:zip areBetweenMin:MinNumericASCII maxASCII:MaxNumericASCII]) {
      DDLogError(@"zip contains non-numeric characters:  %@", zip);
      ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:ZipCode reason:NonNumericValue value:zip state:NOTFIXED];
      [problems addObject:problem];
      [problem release];
    }
     result = zip;
   }
  
  /*
  NSArray *tokens = [zip componentsSeparatedByString:@"-"];
  NSString *result = @"";
  result = [result stringByAppendingFormat:@"%@", [tokens objectAtIndex:0]];
   */
  
  return result;
}

- (BOOL) lengthOfString:(NSString *) string exceedsMaxCharacterCount:(int) max atField:(NSString *) field {
  BOOL result = YES;
  int length = [string length];
  if (length > max) {
    DDLogVerbose(@"string:  %@ length %i exceeds max: %i for field: %@", string, length, max, field);
    ProblemPerson *problem = [[ProblemPerson alloc] initWithPerson:currentPerson field:field reason:TooManyCharacters
                                                             value:string state:NOTFIXED];
    [self.problems addObject:problem];
    [problem release];
    result = NO;
  }
  return result;
}


- (NSString *) formatPhoneNumber:(NSString *) number {
  NSString *result = @"";
  
  NSString *areaCode = [number substringToIndex:3];
  
  NSRange range = NSMakeRange(3, 3);
  NSString *localCode = [number substringWithRange:range];
  
  NSString *lastFour = [number substringFromIndex:6];
  
  result = [NSString stringWithFormat:@"(%@)%@-%@", areaCode, localCode, lastFour];
  return result;
}


@end

