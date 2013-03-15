// 
// Person.h
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import <Cocoa/Cocoa.h>
#import "ObjectWithUid.h"
#import "Invoice.h"
#import "Product.h"
#import "ShopCredit.h"
#import "Membership.h"
@interface Person : ObjectWithUid {
  NSString *personName;
  NSString *phoneNumber;
  NSString *emailAddress;
  NSString *companyName;
  NSString *address;
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
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSString *)personName;
- (void)setPersonName:(NSString *)arg;
- (NSString *)phoneNumber;
- (void)setPhoneNumber:(NSString *)arg;
- (NSString *)emailAddress;
- (void)setEmailAddress:(NSString *)arg;
- (NSString *)companyName;
- (void)setCompanyName:(NSString *)arg;
- (NSString *)address;
- (void)setAddress:(NSString *)arg;
- (NSString *)city;
- (void)setCity:(NSString *)arg;
- (NSString *)addressState;
- (void)setAddressState:(NSString *)arg;
- (NSString *)zip;
- (void)setZip:(NSString *)arg;
- (bool)willTakeCheckFrom;
- (void)setWillTakeCheckFrom:(bool)arg;
- (bool)hasSignedLiabilityWaiver;
- (void)setHasSignedLiabilityWaiver:(bool)arg;
- (NSString *)membershipUid;
- (void)setMembershipUid:(NSString *)arg;
- (NSMutableArray *)projectUids;
- (void)setProjectUids:(NSArray *)arg;
- (NSMutableArray *)commentUids;
- (void)setCommentUids:(NSArray *)arg;
- (NSMutableArray *)invoiceUids;
- (void)setInvoiceUids:(NSArray *)arg;
- (NSMutableArray *)creditUids;
- (void)setCreditUids:(NSArray *)arg;
- (NSMutableArray *)contactUids;
- (void)setContactUids:(NSArray *)arg;
- (NSMutableArray *)cashDonationUids;
- (void)setCashDonationUids:(NSArray *)arg;
- (NSMutableArray *)inKindDonationUids;
- (void)setInKindDonationUids:(NSArray *)arg;
- (NSMutableArray *)compUids;
- (void)setCompUids:(NSArray *)arg;


//******************************************************************************
// misc
//******************************************************************************
- (Membership *)membership;
- (bool)isMember;
- (NSString *)memberType;
- (NSCalendarDate *)membershipEndDate;
- (double)personBalance;
- (double)creditAvailable;
- (bool)hasAvailableCredit;
- (NSArray *)unpaidInvoices;
- (NSArray *)paidInvoices;
- (ShopCredit *)leastActiveCredit;
- (NSArray *)activeCredits;
- (void)applyMembership:(Product *)p forInvoice:(NSString *)aUid;

@end