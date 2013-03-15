//
//  Membership.m
//  AnotherApp
//
//  Created by moody on 6/10/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "Membership.h"
#import "People.h"
#import "Person.h"
#import "MembershipClassDescription.h"

@implementation Membership


+ (void) initialize {
  if ( self == [Membership class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    MembershipClassDescription *cd = [[MembershipClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"creationDate",@"startDate",@"endDate",@"membershipType",@"invoiceUid",@"personUid",nil]];
    [superTypes setObject:LjCalendarDateType forKey:@"creationDate"];
    [superTypes setObject:LjCalendarDateType forKey:@"startDate"];
    [superTypes setObject:LjCalendarDateType forKey:@"endDate"];
    [superTypes setObject:LjStringType forKey:@"membershipType"];
    [superTypes setObject:LjStringType forKey:@"invoiceUid"];
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
    NSCalendarDate *today = [NSCalendarDate calendarDate];
    [self setCreationDate:today];
    
    [self setEndDate:today];
    [self setStartDate:today];
    [self setMembershipType:@"no"];
    [self setInvoiceUid:@"no invoice"];
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [invoiceUid release];
  [personUid release];
  [creationDate release];
  [startDate release];
  [endDate release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<Membership: %@ %@ %@ %@>",
    [self personName], startDate, endDate, membershipType];
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:creationDate forKey:@"creationDate"];
  [coder encodeObject:startDate forKey:@"startDate"];
  [coder encodeObject:endDate forKey:@"endDate"];
  [coder encodeObject:membershipType forKey:@"membershipType"];
  [coder encodeObject:invoiceUid forKey:@"invoiceUid"];
  [coder encodeObject:personUid forKey:@"personUid"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setCreationDate:[coder decodeObjectForKey:@"creationDate"]];
  [self setStartDate:[coder decodeObjectForKey:@"startDate"]];
  [self setEndDate:[coder decodeObjectForKey:@"endDate"]];
  [self setMembershipType:[coder decodeObjectForKey:@"membershipType"]];
  [self setInvoiceUid:[coder decodeObjectForKey:@"invoiceUid"]];
  [self setPersonUid:[coder decodeObjectForKey:@"personUid"]];
  return self;
}

- (NSString *)personName {
  Person *p = [[People sharedInstance] objectForUid:personUid];
  return [p personName];
}

- (NSString *)invoiceUid {
  return invoiceUid;
}

- (void)setInvoiceUid:(NSString *)aUid {
  aUid = [aUid copy];
  [invoiceUid release];
  invoiceUid = aUid;
}


- (NSString *)personUid {
  return personUid;
}

- (void)setPersonUid:(NSString *)aUid {
  aUid = [aUid copy];
  [personUid release];
  personUid = aUid;
}

//******************************************************************************
// accessor
//******************************************************************************

- (NSCalendarDate *)creationDate {
  return creationDate;
}

- (NSCalendarDate *)startDate {
  return startDate;
}

- (NSCalendarDate *)endDate {
  return endDate;
}

- (NSString *)membershipType {
  return membershipType;
}


//******************************************************************************
// setter
//******************************************************************************

- (void)setCreationDate:(NSCalendarDate *)date {
  [date retain];
  [creationDate release];
  creationDate = date;
}

- (void)setStartDate:(NSCalendarDate *)date {
  [date retain];
  [startDate release];
  startDate = date;
}

- (void)setEndDate:(NSCalendarDate *)date {
  [date retain];
  [endDate release];
  endDate = date;
}

- (void)setMembershipType:(NSString *)type {
  type = [type copy];
  [membershipType release];
  membershipType = type;  
}

@end
