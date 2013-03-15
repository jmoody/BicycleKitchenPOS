// 
// Donation.m
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import "Donation.h"
#import "People.h"
#import "DonationClassDescription.h"

@implementation Donation

+ (void) initialize {
  if ( self == [Donation class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    DonationClassDescription *cd = [[DonationClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"sentThankYou",@"donationAmount",@"donorUid",@"cookNameOrInitials",@"pathToPdfArchive",nil]];
    [superTypes setObject:LjBooleanType forKey:@"sentThankYou"];
    [superTypes setObject:LjDoubleType forKey:@"donationAmount"];
    [superTypes setObject:LjStringType forKey:@"donorUid"];
    [superTypes setObject:LjStringType forKey:@"cookNameOrInitials"];
    [superTypes setObject:LjStringType forKey:@"pathToPdfArchive"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setSentThankYou:NO];
    [self setDonationAmount:0.0];
    [self setDonorUid:@""];
    [self setCookNameOrInitials:@""];
    [self setPathToPdfArchive:@""];
   
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void) dealloc {
  [donorUid release];
  [cookNameOrInitials release];
  [pathToPdfArchive release];
  [super dealloc];
}


//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeBool:sentThankYou forKey:@"sentThankYou"];
  [coder encodeDouble:donationAmount forKey:@"donationAmount"];
  [coder encodeObject:donorUid forKey:@"donorUid"];
  [coder encodeObject:cookNameOrInitials forKey:@"cookNameOrInitials"];
  [coder encodeObject:pathToPdfArchive forKey:@"pathToPdfArchive"];
 
}


//******************************************************************************
// decode
//******************************************************************************
- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setSentThankYou:[coder decodeBoolForKey:@"sentThankYou"]];
  [self setDonationAmount:[coder decodeDoubleForKey:@"donationAmount"]];
  [self setDonorUid:[coder decodeObjectForKey:@"donorUid"]];
  [self setCookNameOrInitials:[coder decodeObjectForKey:@"cookNameOrInitials"]];
  [self setPathToPdfArchive:[coder decodeObjectForKey:@"pathToPdfArchive"]];
 
 return self;
}


//******************************************************************************
// methods
//******************************************************************************
- (NSString *)sentThankYouYesOrNo {
  if (sentThankYou) {
    return @"yes";
  } else {
    return @"no";
  }
}

//******************************************************************************

- (Person *)personForDonation {
  return (Person *)[[People sharedInstance] objectForUid:[self donorUid]];
}

//******************************************************************************

- (NSString *)personName {
  Person *p = [self personForDonation];
  return [p personName];
}

- (NSString *)personEmail {
  Person *p = [self personForDonation];
  return [p emailAddress];
}
  
//******************************************************************************


- (NSString *)personPhone {
  Person *p = [self personForDonation];
  return [p phoneNumber];
}

//******************************************************************************

- (NSString *)companyName {
  Person *p = [self personForDonation];
  return [p companyName];
}

//******************************************************************************

- (NSString *)address {
  Person *p = [self personForDonation];
  return [p address];
}

//******************************************************************************

- (NSString *)city {
  Person *p = [self personForDonation];
  return [p city];
}

//******************************************************************************

- (NSString *)addressState {
  Person *p = [self personForDonation];
  return [p addressState];
}

//******************************************************************************

- (NSString *)zip {
  Person *p = [self personForDonation];
  return [p zip];
}

//******************************************************************************
// accessors and setters
//******************************************************************************
- (bool)sentThankYou {
  return sentThankYou;
}
- (void) setSentThankYou:(bool)arg {
 sentThankYou = arg;
}
- (double)donationAmount {
  return donationAmount;
}
- (void) setDonationAmount:(double)arg {
 donationAmount = arg;
}
- (NSString *)donorUid {
  return donorUid;
}
- (void) setDonorUid:(NSString *)arg {
  arg = [arg copy];
  [donorUid release];
  donorUid = arg;
}
- (NSString *)cookNameOrInitials {
  return cookNameOrInitials;
}
- (void) setCookNameOrInitials:(NSString *)arg {
  arg = [arg copy];
  [cookNameOrInitials release];
  cookNameOrInitials = arg;
}
- (NSString *)pathToPdfArchive {
  return pathToPdfArchive;
}
- (void) setPathToPdfArchive:(NSString *)arg {
  arg = [arg copy];
  [pathToPdfArchive release];
  pathToPdfArchive = arg;
}

@end