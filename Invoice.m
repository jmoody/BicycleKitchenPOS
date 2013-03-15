// 
// Invoice.m
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import "Invoice.h"
//#import "Product.h"
#import "People.h"
#import "Projects.h"
#import "InvoiceClassDescription.h"

@implementation Invoice


+ (void) initialize {
  if ( self == [Invoice class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    InvoiceClassDescription *cd = [[InvoiceClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"paidDate",@"personUid",@"items",@"invoicePaid",@"invoiceTotal",@"totalAmountReceived",@"amountReceivedCash",@"amountReceivedStoreCredit",@"amountReceivedCreditCard",@"amountReceivedDebitCard",@"amountReceivedCheck",@"amountOfChangeGiven",@"checkNumber",@"nameOnCheck",@"cardBrand",@"cardType",@"lastFourDigits",@"expirationDate",@"nonMemberDiscountGivenP",@"amountOfNonMemberDiscountGiven",@"memberDiscountGivenP",@"amountOfMemberDiscountGiven",@"pathToPdf",@"hoursOfStandTime",@"totalTaxableAmount",@"totalNonTaxableAmount",@"taxOwed",nil]];
    [superTypes setObject:LjCalendarDateType forKey:@"paidDate"];
    [superTypes setObject:LjStringType forKey:@"personUid"];
    [superTypes setObject:LjArrayType forKey:@"items"];
    [superTypes setObject:LjBooleanType forKey:@"invoicePaid"];
    [superTypes setObject:LjDoubleType forKey:@"invoiceTotal"];
    [superTypes setObject:LjDoubleType forKey:@"totalAmountReceived"];
    [superTypes setObject:LjDoubleType forKey:@"amountReceivedCash"];
    [superTypes setObject:LjDoubleType forKey:@"amountReceivedStoreCredit"];
    [superTypes setObject:LjDoubleType forKey:@"amountReceivedCreditCard"];
    [superTypes setObject:LjDoubleType forKey:@"amountReceivedDebitCard"];
    [superTypes setObject:LjDoubleType forKey:@"amountReceivedCheck"];
    [superTypes setObject:LjDoubleType forKey:@"amountOfChangeGiven"];
    [superTypes setObject:LjIntType forKey:@"checkNumber"];
    [superTypes setObject:LjStringType forKey:@"nameOnCheck"];
    [superTypes setObject:LjStringType forKey:@"cardBrand"];
    [superTypes setObject:LjStringType forKey:@"cardType"];
    [superTypes setObject:LjStringType forKey:@"lastFourDigits"];
    [superTypes setObject:LjCalendarDateType forKey:@"expirationDate"];
    [superTypes setObject:LjBooleanType forKey:@"nonMemberDiscountGivenP"];
    [superTypes setObject:LjDoubleType forKey:@"amountOfNonMemberDiscountGiven"];
    [superTypes setObject:LjBooleanType forKey:@"memberDiscountGivenP"];
    [superTypes setObject:LjDoubleType forKey:@"amountOfMemberDiscountGiven"];
    [superTypes setObject:LjStringType forKey:@"pathToPdf"];
    [superTypes setObject:LjDoubleType forKey:@"hoursOfStandTime"];
    [superTypes setObject:LjDoubleType forKey:@"totalTaxableAmount"];
    [superTypes setObject:LjDoubleType forKey:@"totalNonTaxableAmount"];
    [superTypes setObject:LjDoubleType forKey:@"taxOwed"];
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
    NSCalendarDate *twentyFiveYears = [today dateByAddingYears:25 
                                                        months:0 
                                                          days:0
                                                         hours:0
                                                       minutes:0
                                                       seconds:0];
    
    [self setPaidDate:twentyFiveYears];    
    [self setPersonUid:@""];
    NSArray *iarray = [[NSArray alloc] init];
    [self setItems:iarray];
    [iarray release];
    [self setInvoicePaid:NO];
    [self setInvoiceTotal:0.0];
    [self setTotalAmountReceived:0.0];
    [self setAmountReceivedCash:0.0];
    [self setAmountReceivedStoreCredit:0.0];
    [self setAmountReceivedCreditCard:0.0];
    [self setAmountReceivedDebitCard:0.0];
    [self setAmountReceivedCheck:0.0];
    [self setAmountOfChangeGiven:0.0];
    [self setCheckNumber:0];
    [self setNameOnCheck:@""];
    [self setCardBrand:@""];
    [self setCardType:@""];
    [self setLastFourDigits:@""];
    [self setExpirationDate:nil];
    [self setNonMemberDiscountGivenP:NO];
    [self setAmountOfNonMemberDiscountGiven:0.0];
    [self setMemberDiscountGivenP:NO];
    [self setAmountOfMemberDiscountGiven:0.0];
    [self setPathToPdf:@""];
    [self setHoursOfStandTime:0.0];
    [self setTotalTaxableAmount:0.0];
    [self setTotalNonTaxableAmount:0.0];
    [self setTaxOwed:0.0];
   

  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void) dealloc {
  [paidDate release];
  [personUid release];
  [items release];
  [nameOnCheck release];
  [cardBrand release];
  [cardType release];
  [lastFourDigits release];
  [expirationDate release];
  [pathToPdf release];
 
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<Invoice: uid %@ person %@ personUid %@ date %@ paidDate %@ >",
    uid, [self personName], personUid, date, paidDate];
}

- (NSString *)searchDescription {
  NSString *productDescriptions = [NSString stringWithFormat:@""];
  NSEnumerator *e = [items objectEnumerator];
  Product *product;
  while (product = (Product *)[e nextObject]) {
    productDescriptions = [NSString stringWithFormat:@"%@ %@", productDescriptions,
                           [product searchDescription]];
  }
  NSString *invoiceDescription = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                  [self personName], 
                                  [[self paidDate]  descriptionWithCalendarFormat:@"%m/%d/%Y"], 
                                  [self paidYesOrNo],
                                  productDescriptions];
  return [invoiceDescription lowercaseString];
}

//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:paidDate forKey:@"paidDate"];
  [coder encodeObject:personUid forKey:@"personUid"];
  [coder encodeObject:items forKey:@"items"];
  [coder encodeBool:invoicePaid forKey:@"invoicePaid"];
  [coder encodeDouble:invoiceTotal forKey:@"invoiceTotal"];
  [coder encodeDouble:totalAmountReceived forKey:@"totalAmountReceived"];
  [coder encodeDouble:amountReceivedCash forKey:@"amountReceivedCash"];
  [coder encodeDouble:amountReceivedStoreCredit forKey:@"amountReceivedStoreCredit"];
  [coder encodeDouble:amountReceivedCreditCard forKey:@"amountReceivedCreditCard"];
  [coder encodeDouble:amountReceivedDebitCard forKey:@"amountReceivedDebitCard"];
  [coder encodeDouble:amountReceivedCheck forKey:@"amountReceivedCheck"];
  [coder encodeDouble:amountOfChangeGiven forKey:@"amountOfChangeGiven"];
  [coder encodeInt:checkNumber forKey:@"checkNumber"];
  [coder encodeObject:nameOnCheck forKey:@"nameOnCheck"];
  [coder encodeObject:cardBrand forKey:@"cardBrand"];
  [coder encodeObject:cardType forKey:@"cardType"];
  [coder encodeObject:lastFourDigits forKey:@"lastFourDigits"];
  [coder encodeObject:expirationDate forKey:@"expirationDate"];
  [coder encodeBool:nonMemberDiscountGivenP forKey:@"nonMemberDiscountGivenP"];
  [coder encodeDouble:amountOfNonMemberDiscountGiven forKey:@"amountOfNonMemberDiscountGiven"];
  [coder encodeBool:memberDiscountGivenP forKey:@"memberDiscountGivenP"];
  [coder encodeDouble:amountOfMemberDiscountGiven forKey:@"amountOfMemberDiscountGiven"];
  [coder encodeObject:pathToPdf forKey:@"pathToPdf"];
  [coder encodeDouble:hoursOfStandTime forKey:@"hoursOfStandTime"];
  [coder encodeDouble:totalTaxableAmount forKey:@"totalTaxableAmount"];
  [coder encodeDouble:totalNonTaxableAmount forKey:@"totalNonTaxableAmount"];
  [coder encodeDouble:taxOwed forKey:@"taxOwed"];


}


//******************************************************************************
// decode
//******************************************************************************
- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setPaidDate:[coder decodeObjectForKey:@"paidDate"]];
  [self setPersonUid:[coder decodeObjectForKey:@"personUid"]];
  [self setItems:[coder decodeObjectForKey:@"items"]];
  [self setInvoicePaid:[coder decodeBoolForKey:@"invoicePaid"]];
  [self setInvoiceTotal:[coder decodeDoubleForKey:@"invoiceTotal"]];
  [self setTotalAmountReceived:[coder decodeDoubleForKey:@"totalAmountReceived"]];
  [self setAmountReceivedCash:[coder decodeDoubleForKey:@"amountReceivedCash"]];
  [self setAmountReceivedStoreCredit:[coder decodeDoubleForKey:@"amountReceivedStoreCredit"]];
  [self setAmountReceivedCreditCard:[coder decodeDoubleForKey:@"amountReceivedCreditCard"]];
  [self setAmountReceivedDebitCard:[coder decodeDoubleForKey:@"amountReceivedDebitCard"]];
  [self setAmountReceivedCheck:[coder decodeDoubleForKey:@"amountReceivedCheck"]];
  [self setAmountOfChangeGiven:[coder decodeDoubleForKey:@"amountOfChangeGiven"]];
  [self setCheckNumber:[coder decodeIntForKey:@"checkNumber"]];
  [self setNameOnCheck:[coder decodeObjectForKey:@"nameOnCheck"]];
  [self setCardBrand:[coder decodeObjectForKey:@"cardBrand"]];
  [self setCardType:[coder decodeObjectForKey:@"cardType"]];
  [self setLastFourDigits:[coder decodeObjectForKey:@"lastFourDigits"]];
  [self setExpirationDate:[coder decodeObjectForKey:@"expirationDate"]];
  [self setNonMemberDiscountGivenP:[coder decodeBoolForKey:@"nonMemberDiscountGivenP"]];
  [self setAmountOfNonMemberDiscountGiven:[coder decodeDoubleForKey:@"amountOfNonMemberDiscountGiven"]];
  [self setMemberDiscountGivenP:[coder decodeBoolForKey:@"memberDiscountGivenP"]];
  [self setAmountOfMemberDiscountGiven:[coder decodeDoubleForKey:@"amountOfMemberDiscountGiven"]];
  [self setPathToPdf:[coder decodeObjectForKey:@"pathToPdf"]];
  [self setHoursOfStandTime:[coder decodeDoubleForKey:@"hoursOfStandTime"]];
  [self setTotalTaxableAmount:[coder decodeDoubleForKey:@"totalTaxableAmount"]];
  [self setTotalNonTaxableAmount:[coder decodeDoubleForKey:@"totalNonTaxableAmount"]];
  [self setTaxOwed:[coder decodeDoubleForKey:@"taxOwed"]];
 

 return self;
}


//******************************************************************************
// methods
//******************************************************************************
- (bool)itemsContainsDonationP {
  unsigned int i, count = [items count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[items objectAtIndex:i];
    if ([[p productCode] isEqualTo:@"donation"]) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (double)amountOfDonationInInvoice {
  unsigned int i, count = [items count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[items objectAtIndex:i];
    if ([[p productCode] isEqualTo:@"donation"]) {
      return [p productTotal];
    }
  }
  return 0.0;
}

//******************************************************************************

- (bool)invoiceContainsTaxableItemsP {
  unsigned int i, count = [items count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[items objectAtIndex:i];
    if ([p taxable]) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (NSString *)personName {
  return [[[People sharedInstance] objectForUid:[self personUid]] personName];
}

//******************************************************************************

- (Person *)person {
  return [[People sharedInstance] objectForUid:[self personUid]];
}

//******************************************************************************

- (NSString *)paidYesOrNo {
  if (invoicePaid) {
    return @"yes";
  } else {
    return @"no";
  }  
}

//******************************************************************************

- (bool)itemsContainsProjectP {
  unsigned int i, count = [items count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[items objectAtIndex:i];
    if ([[p productCode] isEqualTo:@"project"]) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (double)totalDiscounts {
  return [self amountOfMemberDiscountGiven] + [self amountOfNonMemberDiscountGiven];
}

//******************************************************************************

- (Project *)projectForInvoice {
  Product *p = [self projectProductForInvoice];
  if (p != nil) {
    return [[Projects sharedInstance] objectForUid:[p uid]];
  } else {
    return nil;
  }
}

//******************************************************************************

- (Product *)projectProductForInvoice {
  unsigned int i, count = [items count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[items objectAtIndex:i];
    if ([[p productCode] isEqualToString:@"project"]) {
      return p;
    }
  }
  return nil;
}


//******************************************************************************
// accessors and setters
//******************************************************************************
- (NSCalendarDate *)paidDate {
  return paidDate;
}
- (void) setPaidDate:(NSCalendarDate *)arg {
  [arg retain];
  [paidDate release];
  paidDate = arg;
}
- (NSString *)personUid {
  return personUid;
}
- (void) setPersonUid:(NSString *)arg {
  arg = [arg copy];
  [personUid release];
  personUid = arg;
}
- (NSMutableArray *)items {
  return items;
}
- (void) setItems:(NSArray *)arg {
  if (arg != items) {
    [items release];
    items = [arg mutableCopy];
  }
}
- (bool)invoicePaid {
  return invoicePaid;
}
- (void) setInvoicePaid:(bool)arg {
 invoicePaid = arg;
}
- (double)invoiceTotal {
  return invoiceTotal;
}
- (void) setInvoiceTotal:(double)arg {
 invoiceTotal = arg;
}
- (double)totalAmountReceived {
  return totalAmountReceived;
}
- (void) setTotalAmountReceived:(double)arg {
 totalAmountReceived = arg;
}
- (double)amountReceivedCash {
  return amountReceivedCash;
}
- (void) setAmountReceivedCash:(double)arg {
 amountReceivedCash = arg;
}
- (double)amountReceivedStoreCredit {
  return amountReceivedStoreCredit;
}
- (void) setAmountReceivedStoreCredit:(double)arg {
 amountReceivedStoreCredit = arg;
}
- (double)amountReceivedCreditCard {
  return amountReceivedCreditCard;
}
- (void) setAmountReceivedCreditCard:(double)arg {
 amountReceivedCreditCard = arg;
}
- (double)amountReceivedDebitCard {
  return amountReceivedDebitCard;
}
- (void) setAmountReceivedDebitCard:(double)arg {
 amountReceivedDebitCard = arg;
}
- (double)amountReceivedCheck {
  return amountReceivedCheck;
}
- (void) setAmountReceivedCheck:(double)arg {
 amountReceivedCheck = arg;
}
- (double)amountOfChangeGiven {
  return amountOfChangeGiven;
}
- (void) setAmountOfChangeGiven:(double)arg {
 amountOfChangeGiven = arg;
}
- (int)checkNumber {
  return checkNumber;
}
- (void) setCheckNumber:(int)arg {
 checkNumber = arg;
}
- (NSString *)nameOnCheck {
  return nameOnCheck;
}
- (void) setNameOnCheck:(NSString *)arg {
  arg = [arg copy];
  [nameOnCheck release];
  nameOnCheck = arg;
}
- (NSString *)cardBrand {
  return cardBrand;
}
- (void) setCardBrand:(NSString *)arg {
  arg = [arg copy];
  [cardBrand release];
  cardBrand = arg;
}
- (NSString *)cardType {
  return cardType;
}
- (void) setCardType:(NSString *)arg {
  arg = [arg copy];
  [cardType release];
  cardType = arg;
}
- (NSString *)lastFourDigits {
  return lastFourDigits;
}
- (void) setLastFourDigits:(NSString *)arg {
  arg = [arg copy];
  [lastFourDigits release];
  lastFourDigits = arg;
}
- (NSCalendarDate *)expirationDate {
  return expirationDate;
}
- (void) setExpirationDate:(NSCalendarDate *)arg {
  [arg retain];
  [expirationDate release];
  expirationDate = arg;
}
- (bool)nonMemberDiscountGivenP {
  return nonMemberDiscountGivenP;
}
- (void) setNonMemberDiscountGivenP:(bool)arg {
 nonMemberDiscountGivenP = arg;
}
- (double)amountOfNonMemberDiscountGiven {
  return amountOfNonMemberDiscountGiven;
}
- (void) setAmountOfNonMemberDiscountGiven:(double)arg {
 amountOfNonMemberDiscountGiven = arg;
}
- (bool)memberDiscountGivenP {
  return memberDiscountGivenP;
}
- (void) setMemberDiscountGivenP:(bool)arg {
 memberDiscountGivenP = arg;
}
- (double)amountOfMemberDiscountGiven {
  return amountOfMemberDiscountGiven;
}
- (void) setAmountOfMemberDiscountGiven:(double)arg {
 amountOfMemberDiscountGiven = arg;
}
- (NSString *)pathToPdf {
  return pathToPdf;
}
- (void) setPathToPdf:(NSString *)arg {
  arg = [arg copy];
  [pathToPdf release];
  pathToPdf = arg;
}
- (double)hoursOfStandTime {
  return hoursOfStandTime;
}
- (void) setHoursOfStandTime:(double)arg {
 hoursOfStandTime = arg;
}
- (double)totalTaxableAmount {
  return totalTaxableAmount;
}
- (void) setTotalTaxableAmount:(double)arg {
 totalTaxableAmount = arg;
}
- (double)totalNonTaxableAmount {
  return totalNonTaxableAmount;
}
- (void) setTotalNonTaxableAmount:(double)arg {
 totalNonTaxableAmount = arg;
}
- (double)taxOwed {
  return taxOwed;
}
- (void) setTaxOwed:(double)arg {
 taxOwed = arg;
}

@end