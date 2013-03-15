//
//  MembershipInformation.m
//  AnotherApp
//
//  Created by moody on 6/17/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "MembershipInformation.h"


@implementation MembershipInformation

- (id) initWithMemberType:(NSString *)type cost:(double) c
   newPartsDiscount:(double) npd workshopDiscount:(double) wd 
                 duration:(int) days {
  [super init];
  if (self != nil) {
    [self setMembershipType:type];
    [self setPriceOfMembership:c];
    [self setDiscountOnNewParts:npd];
    [self setDiscountOnWorkshops:wd];
    [self setDurationInDays:days];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [membershipType release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<MembershipInfo: %@ %d %f %f %f>",
    membershipType, durationInDays, priceOfMembership, discountOnNewParts,
    discountOnWorkshops];
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
 // [super encodeWithCoder:coder];
  [coder encodeInt:durationInDays forKey:@"durationInDays"];
  [coder encodeDouble:priceOfMembership forKey:@"priceOfMembership"];
  [coder encodeDouble:discountOnNewParts forKey:@"discountOnNewParts"];
  [coder encodeDouble:discountOnWorkshops forKey:@"discountOnWorkshops"];
  [coder encodeObject:membershipType forKey:@"membershipType"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
 // [super init];
  [self setDurationInDays:[coder decodeIntForKey:@"durationInDays"]];
  [self setPriceOfMembership:[coder decodeDoubleForKey:@"priceOfMembership"]];
  [self setDiscountOnNewParts:[coder decodeDoubleForKey:@"discountOnNewParts"]];
  [self setDiscountOnWorkshops:[coder decodeDoubleForKey:@"discountOnWorkshops"]];
  [self setMembershipType:[coder decodeObjectForKey:@"membershipType"]];
  return self;
}


//******************************************************************************
// accessor
//******************************************************************************

- (int) durationInDays {
  return durationInDays;
}

- (double) priceOfMembership {
  return priceOfMembership;
}

- (double) discountOnNewParts {
  return discountOnNewParts;
}

- (double) discountOnWorkshops {
  return discountOnWorkshops;
}

- (NSString *) membershipType {
  return membershipType;
}


//******************************************************************************
// setter
//******************************************************************************

- (void) setDurationInDays:(int)duration {
  durationInDays = duration;
}

- (void) setPriceOfMembership:(double)price {
  priceOfMembership = price;
}

- (void) setDiscountOnNewParts:(double)discount {
  discountOnNewParts = discount;
}

- (void) setDiscountOnWorkshops:(double)discount {
  discountOnWorkshops = discount;
}

- (void) setMembershipType:(NSString *)type {
  type = [type copy];
  [membershipType release];
  membershipType = type;
}

//******************************************************************************
// undo/redo
//******************************************************************************


//******************************************************************************
// I was going to use this, but i doubt it will ever be called
//******************************************************************************

- (bool) samep:(MembershipInformation *) other {
  return 
  [[self membershipType] isEqual: [other membershipType]] &&
  [self priceOfMembership] ==  [other priceOfMembership] &&
  [self durationInDays] == [other durationInDays] &&
  [self discountOnNewParts] == [other discountOnNewParts] &&
  [self discountOnWorkshops] == [other discountOnWorkshops];
  
}


@end
