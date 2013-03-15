//
//  MembershipInformation.h
//  AnotherApp
//
//  Created by moody on 6/17/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MembershipInformation : NSObject<NSCoding> {
  int durationInDays;
  double priceOfMembership;
  double discountOnNewParts;
  double discountOnWorkshops;
  NSString *membershipType;
}

- (id) initWithMemberType:(NSString *)type
                     cost:(double) c
         newPartsDiscount:(double) npd 
         workshopDiscount:(double) wd 
                 duration:(int) days;

- (int) durationInDays;
- (double) priceOfMembership;
- (double) discountOnNewParts;
- (double) discountOnWorkshops;
- (NSString *) membershipType;

- (void) setDurationInDays:(int)duration;
- (void) setPriceOfMembership:(double)price;
- (void) setDiscountOnNewParts:(double)discount;
- (void) setDiscountOnWorkshops:(double)discount;
- (void) setMembershipType:(NSString *)type;


- (bool) samep:(MembershipInformation *) other;

@end
