//
//  Project.m
//  AnotherApp
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "Project.h"
#import "Invoices.h"
#import "People.h"
#import "ProjectClassDescription.h"

@implementation Project

+ (void) initialize {
  if ( self == [Project class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    ProjectClassDescription *cd = [[ProjectClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"ownerUid",@"bicycle",@"startDate",@"dateLastWorked",@"finishedDate",@"isFinished",@"quote",@"standTime",@"invoiceUid",@"contactUids",@"note",nil]];
    [superTypes setObject:LjStringType forKey:@"ownerUid"];
    [superTypes setObject:LjOwuType forKey:@"bicycle"];
    [superTypes setObject:LjCalendarDateType forKey:@"startDate"];
    [superTypes setObject:LjCalendarDateType forKey:@"dateLastWorked"];
    [superTypes setObject:LjCalendarDateType forKey:@"finishedDate"];
    [superTypes setObject:LjBooleanType forKey:@"isFinished"];
    [superTypes setObject:LjDoubleType forKey:@"quote"];
    [superTypes setObject:LjDoubleType forKey:@"standTime"];
    [superTypes setObject:LjStringType forKey:@"invoiceUid"];
    [superTypes setObject:LjArrayType forKey:@"contactUids"];
    [superTypes setObject:LjStringType forKey:@"note"];
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
    [self setStartDate:today];
    [self setDateLastWorked:today];
    [self setFinishedDate:[today dateByAddingYears:25 months:0 days:0 hours:0 minutes:0 seconds:0]];
    [self setIsFinished:NO];
    NSArray *cuids = [[NSArray alloc] init]; 
    [self setContactUids:cuids];
    [cuids release];
    [self setNote:@"note"];
    [self setInvoiceUid:@""];
    [self setOwnerUid:@""];
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void) dealloc {
  [ownerUid release];
  [bicycle release];
  [startDate release];
  [dateLastWorked release];
  [finishedDate release];
  [invoiceUid release];
  [contactUids release];
  [note release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<Project: %@ %@ %@ %@ %@ %d>", 
    [self ownerName], bicycle, [startDate descriptionWithCalendarFormat:@"%m/%d/%Y"], 
    [dateLastWorked descriptionWithCalendarFormat:@"%m/%d/%Y"], 
    [finishedDate descriptionWithCalendarFormat:@"%m/%d/%Y"], quote];
}

//******************************************************************************
// encode
//******************************************************************************
- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:ownerUid forKey:@"ownerUid"];
  [coder encodeObject:bicycle forKey:@"bicycle"];
  [coder encodeObject:startDate forKey:@"startDate"];
  [coder encodeObject:dateLastWorked forKey:@"dateLastWorked"];
  [coder encodeObject:finishedDate forKey:@"finishedDate"];
  [coder encodeBool:isFinished forKey:@"isFinished"];
  [coder encodeDouble:quote forKey:@"quote"];
  [coder encodeDouble:standTime forKey:@"standTime"];
  [coder encodeObject:invoiceUid forKey:@"invoiceUid"];
  [coder encodeObject:contactUids forKey:@"contactUids"];
  [coder encodeObject:note forKey:@"note"];
}


//******************************************************************************
// decode
//******************************************************************************
- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setOwnerUid:[coder decodeObjectForKey:@"ownerUid"]];
  [self setBicycle:[coder decodeObjectForKey:@"bicycle"]];
  [self setStartDate:[coder decodeObjectForKey:@"startDate"]];
  [self setDateLastWorked:[coder decodeObjectForKey:@"dateLastWorked"]];
  [self setFinishedDate:[coder decodeObjectForKey:@"finishedDate"]];
  [self setIsFinished:[coder decodeBoolForKey:@"isFinished"]];
  [self setQuote:[coder decodeDoubleForKey:@"quote"]];
  [self setStandTime:[coder decodeDoubleForKey:@"standTime"]];
  [self setInvoiceUid:[coder decodeObjectForKey:@"invoiceUid"]];
  [self setContactUids:[coder decodeObjectForKey:@"contactUids"]];
  [self setNote:[coder decodeObjectForKey:@"note"]];
  return self;
}


//******************************************************************************
// methods
//******************************************************************************
- (bool)isOverdue {
  NSCalendarDate *today = [NSCalendarDate calendarDate];
  int todayDay = [today dayOfCommonEra];
  int dayLastWorked = [[self dateLastWorked] dayOfCommonEra];
  if ((todayDay - dayLastWorked) >= 30) {
    return YES;
  } else {
    return NO;
  }
}

//******************************************************************************

- (NSString *)isOverdueYesOrNo {
  if ([self isOverdue]) {
    return @"yes";
  } else {
    return @"no";
  }
}

//******************************************************************************

- (NSString *)finishedYesOrNo {
  if (isFinished) {
    return @"yes";
  } else {
    return @"no";
  }
}

//******************************************************************************

- (NSString *)ownerName {
  Person *person = [[People sharedInstance] objectForUid:ownerUid];
  return [person personName];
}

//******************************************************************************

- (NSString *)ownerEmail {
  Person *person = [[People sharedInstance] objectForUid:ownerUid];
  return [person emailAddress];
}

//******************************************************************************

- (NSString *)ownerPhone {
  Person *person = [[People sharedInstance] objectForUid:ownerUid];
  return [person phoneNumber];
}
//******************************************************************************

- (NSString *)bicycleDescription {
  return [bicycle shortDescription];
}

//******************************************************************************

- (Invoice *)invoice {
  return [[Invoices sharedInstance] objectForUid:invoiceUid];
}

//******************************************************************************

- (NSMutableArray *)productsInInvoice {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  NSEnumerator *e = [[[self invoice] items] objectEnumerator];
  id val;
  while (val = [e nextObject]) {
    [result addObject:val];
  }
  NSMutableArray *returnVal = [NSMutableArray arrayWithArray:result];
  [result release];
  return returnVal;
}

//******************************************************************************

- (double)balance {
  return [self totalFromProducts] + [self quote];
}

//******************************************************************************

- (NSMutableArray *)taxableItemsInInvoice {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"taxable == YES"];
  NSArray *filtered = [[[self invoice] items] filteredArrayUsingPredicate:predicate];
  return [filtered mutableCopy];
}

//******************************************************************************

- (double)totalFromProducts {
  double sum = 0.0;
  NSArray *array = [NSArray arrayWithArray:[[self invoice] items]];
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[array objectAtIndex:i];
    if (![[p productCode] isEqualToString:@"project"]) {
      sum = sum + [p productTotal];
    }
  }
  return sum;
}


//******************************************************************************

- (Product *)projectProduct {
  Invoice *inv = [self invoice];
  NSEnumerator *e = [[inv items] objectEnumerator];
  Product *result = nil;
  Product *p;
  while (p = (Product *)[e nextObject]) {
    if ([[p productCode] isEqualToString:@"project"]) {
      result = p;
    }
  }
  return result;
}

//******************************************************************************
// accessors and setters
//******************************************************************************
- (NSString *)ownerUid {
  return ownerUid;
}
- (void) setOwnerUid:(NSString *)arg {
  arg = [arg retain];
  [ownerUid release];
  ownerUid = arg;
}
- (Bicycle *)bicycle {
  return bicycle;
}
- (void) setBicycle:(Bicycle *)arg {
  [arg retain];
  [bicycle release];
  bicycle = arg;
}
- (NSCalendarDate *)startDate {
  return startDate;
}
- (void) setStartDate:(NSCalendarDate *)arg {
  arg = [arg retain];
  [startDate release];
  startDate = arg;
}
- (NSCalendarDate *)dateLastWorked {
  return dateLastWorked;
}
- (void) setDateLastWorked:(NSCalendarDate *)arg {
  [arg retain];
  [dateLastWorked release];
  dateLastWorked = arg;
}
- (NSCalendarDate *)finishedDate {
  return finishedDate;
}
- (void) setFinishedDate:(NSCalendarDate *)arg {
  [arg retain];
  [finishedDate release];
  finishedDate = arg;
}
- (bool)isFinished {
  return isFinished;
}
- (void) setIsFinished:(bool)arg {
  isFinished = arg;
}
- (double)quote {
  return quote;
}
- (void) setQuote:(double)arg {
  quote = arg;
}
- (double)standTime {
  return standTime;
}
- (void) setStandTime:(double)arg {
  standTime = arg;
}
- (NSString *)invoiceUid {
  return invoiceUid;
}
- (void) setInvoiceUid:(NSString *)arg {
  arg = [arg retain];
  [invoiceUid release];
  invoiceUid = arg;
}
- (NSMutableArray *)contactUids {
  return contactUids;
}
- (void) setContactUids:(NSArray *)arg {
  if (arg != contactUids) {
    [contactUids release];
    contactUids = [arg mutableCopy];
  }
}
- (NSString *)note {
  return note;
}
- (void) setNote:(NSString *)arg {
  arg = [arg retain];
  [note release];
  note = arg;
}
@end