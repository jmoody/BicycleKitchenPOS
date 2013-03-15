//
//  DailyCashJournal.m
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "DailyCashJournal.h"
#import "PreferenceController.h"
@implementation DailyCashJournal

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setInvoiceUids:[[NSMutableArray alloc] init]];
    [self setCheckUids:[[NSMutableArray alloc] init]];
    [self setDebitUids:[[NSMutableArray alloc] init]];
    [self setCreditUids:[[NSMutableArray alloc] init]];
    [self setActualTotal:0.0];
    [self setExpectedTotal:0.0];
    [self setVariance:0.0];
    [self setTotalChecks:0.0];
    [self setTotalCards:0.0];
    [self setTotalCash:0.0];
    [self setTotalCredits:0.0];
    [self setCloserNameOrInitials:[NSString stringWithFormat:@""]];
    [self setHundreds:0];
    [self setFifties:0];
    [self setTwenties:0];
    [self setTens:0];
    [self setFives:0];
    [self setTwos:0];
    [self setOnes:0];
    [self setIsOpen:YES];
    [self setUntaxableTotal:0.0];
    [self setTaxableTotal:0.0];
    [self setTaxOwed:0.0];
    [self setProjectsCompletedTotal:0.0];
    [self setDonationsTotal:0.0];
    [self setStandTimeTotal:0.0];
    [self setVolunteerHoursTotal:0.0];
    [self setPathToPdfArchive:@""];
    
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    [self setStartingBalance:[[defaults objectForKey:TljBkPosStartingBookAmount] doubleValue]];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [closerNameOrInitials release];
  [pathToPdfArchive release];
  [self deallocAnArray:invoiceUids];
  [self deallocAnArray:checkUids];
  [self deallocAnArray:debitUids];
  [self deallocAnArray:creditUids];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<DailyCashJournal: %@ %@ %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %@>",
    [[self date] descriptionWithCalendarFormat:@"%m/%d/%Y"],
    [self bookOpenYesOrNo], startingBalance, expectedTotal, actualTotal, variance,
    taxableTotal, untaxableTotal, closerNameOrInitials];
}

- (NSString *)bookOpenYesOrNo {
  if (isOpen) {
    return @"yes";
  } else {
    return @"no";
  }
}


//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeDouble:actualTotal forKey:@"actualTotal"];
  [coder encodeDouble:expectedTotal forKey:@"expectedTotal"];
  [coder encodeDouble:variance forKey:@"variance"];
  [coder encodeObject:invoiceUids forKey:@"invoiceUids"];
  [coder encodeObject:closerNameOrInitials forKey:@"closerNameOrInitials"];
  [coder encodeInt:hundreds forKey:@"hundreds"];
  [coder encodeInt:fifties forKey:@"fifties"];
  [coder encodeInt:twenties forKey:@"twenties"];
  [coder encodeInt:tens forKey:@"tens"];
  [coder encodeInt:fives forKey:@"fives"];
  [coder encodeInt:ones forKey:@"ones"];
  [coder encodeObject:checkUids forKey:@"checkUids"];
  [coder encodeObject:debitUids forKey:@"debitUids"];
  [coder encodeBool:isOpen forKey:@"isOpen"];
  [coder encodeDouble:taxableTotal forKey:@"taxableTotal"];
  [coder encodeDouble:untaxableTotal forKey:@"untaxableTotal"];
  [coder encodeObject:creditUids forKey:@"creditUids"];
  [coder encodeInt:projectsCompletedTotal forKey:@"projectsCompletedTotal"];
  [coder encodeDouble:donationsTotal forKey:@"donationsTotal"];
  [coder encodeDouble:standTimeTotal forKey:@"standTimeTotal"];
  [coder encodeDouble:volunteerHoursTotal forKey:@"volunteerHoursTotal"];
  [coder encodeDouble:totalChecks forKey:@"totalChecks"];
  [coder encodeDouble:totalCards forKey:@"totalCards"];
  [coder encodeDouble:startingBalance forKey:@"startingBalance"];
  [coder encodeInt:twos forKey:@"twos"];
  [coder encodeDouble:totalCash forKey:@"totalCash"]; 
  [coder encodeDouble:taxOwed forKey:@"taxOwed"];
  [coder encodeObject:pathToPdfArchive forKey:@"pathToPdfArchive"];  
  [coder encodeDouble:totalCredits forKey:@"totalCredits"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setStartingBalance:[coder decodeDoubleForKey:@"startingBalance"]];
  [self setActualTotal:[coder decodeDoubleForKey:@"actualTotal"]];
  [self setExpectedTotal:[coder decodeDoubleForKey:@"expectedTotal"]];
  [self setVariance:[coder decodeDoubleForKey:@"variance"]];
  [self setCloserNameOrInitials:[coder decodeObjectForKey:@"closerNameOrInitials"]];
  [self setHundreds:[coder decodeIntForKey:@"hundreds"]];
  [self setFifties:[coder decodeIntForKey:@"fifties"]];
  [self setTwenties:[coder decodeIntForKey:@"twenties"]];
  [self setTens:[coder decodeIntForKey:@"tens"]];
  [self setFives:[coder decodeIntForKey:@"fives"]];
  [self setOnes:[coder decodeIntForKey:@"ones"]];
  [self setInvoiceUids:[coder decodeObjectForKey:@"invoiceUids"]];
  [self setCheckUids:[coder decodeObjectForKey:@"checkUids"]];
  [self setDebitUids:[coder decodeObjectForKey:@"debitUids"]];
  [self setIsOpen:[coder decodeBoolForKey:@"isOpen"]];
  [self setTaxableTotal:[coder decodeDoubleForKey:@"taxableTotal"]];
  [self setUntaxableTotal:[coder decodeDoubleForKey:@"untaxableTotal"]];
  [self setCreditUids:[coder decodeObjectForKey:@"creditUids"]];
  [self setProjectsCompletedTotal:[coder decodeIntForKey:@"projectsCompletedTotal"]];
  [self setDonationsTotal:[coder decodeDoubleForKey:@"donationsTotal"]];
  [self setStandTimeTotal:[coder decodeDoubleForKey:@"standTimeTotal"]];
  [self setVolunteerHoursTotal:[coder decodeDoubleForKey:@"volunteerHoursTotal"]];
  [self setTotalChecks:[coder decodeDoubleForKey:@"totalChecks"]];
  [self setTotalCards:[coder decodeDoubleForKey:@"totalCards"]];
  [self setTwos:[coder decodeIntForKey:@"twos"]];
  [self setTotalCash:[coder decodeDoubleForKey:@"totalCash"]];
  [self setTaxOwed:[coder decodeDoubleForKey:@"taxOwed"]];
  [self setPathToPdfArchive:[coder decodeObjectForKey:@"pathToPdfArchive"]];
  [self setTotalCredits:[coder decodeDoubleForKey:@"totalCredits"]];

    
  return self;
}


- (NSMutableArray *)invoiceUids {
  return invoiceUids;
}

- (NSString *)closerNameOrInitials {
  return closerNameOrInitials;
}


- (int) hundreds {
  return hundreds;
}

- (int) fifties {
  return fifties;
}

- (int) twenties {
  return twenties;
}

- (int) tens {
  return tens;
}

- (int) fives {
  return fives;
}

- (int) ones {
  return ones;
}

- (NSMutableArray *)checkUids {
  return checkUids;
}

- (NSMutableArray *)debitUids {
  return debitUids;
}

- (bool) isOpen {
  return isOpen;
}

- (double) taxableTotal {
  return taxableTotal;
}

- (double) untaxableTotal {
  return untaxableTotal;
}


- (double)startingBalance {
  return startingBalance;
}

- (void) setStartingBalance:(double)arg {
  startingBalance = arg;  
}

- (void) setInvoiceUids:(NSArray *)invoices {
  if (invoiceUids != invoices) {
    
    NSEnumerator *enumerator = [invoiceUids objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
      [value release];
    }  
    
    invoiceUids = 
      [[NSMutableArray alloc] initWithArray:invoices];
  }
}

- (void) setCloserNameOrInitials:(NSString *)nameOrInitials {
  [nameOrInitials retain];
  [closerNameOrInitials release];
  closerNameOrInitials = nameOrInitials;
}


- (void) setHundreds:(int) h {
  hundreds = h;
}

- (void) setFifties:(int) f {
  fifties = f;
}

- (void) setTwenties:(int) t {
  twenties = t;
}

- (void) setTens:(int) t {
  tens = t;
}

- (void) setFives:(int) f {
  fives = f;
}

- (void) setOnes:(int) o {
  ones = o;
}

- (void) setCheckUids:(NSArray *)checks {
  if (checkUids != checks) {
    
    NSEnumerator *enumerator = [checkUids objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
      [value release];
    }  
    
    checkUids = 
      [[NSMutableArray alloc] initWithArray:checks];
  }
  
}

- (void) setDebitUids:(NSArray *)debits {
  if (debitUids != debits) {
    
    NSEnumerator *enumerator = [debitUids objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
      [value release];
    }  
    
    debitUids = 
      [[NSMutableArray alloc] initWithArray:debits];
  }
}

- (void) setIsOpen:(bool) open {
  isOpen = open;
}

- (void) setTaxableTotal:(double) total {
  taxableTotal = total;
}

- (void) setUntaxableTotal:(double) total {
  untaxableTotal = total;
}

- (NSMutableArray *)creditUids {
  return creditUids;
}
- (void) setCreditUids:(NSArray *)arg {
  if (arg != creditUids) {
    [self deallocAnArray:creditUids];
    creditUids = [[NSMutableArray alloc] initWithArray:arg];
  }
}
- (int)projectsCompletedTotal {
  return projectsCompletedTotal;
}
- (void) setProjectsCompletedTotal:(int)arg {
  projectsCompletedTotal = arg;
}
- (double)donationsTotal {
  return donationsTotal;
}
- (void) setDonationsTotal:(double)arg {
  donationsTotal = arg;
}
- (double)standTimeTotal {
  return standTimeTotal;
}
- (void) setStandTimeTotal:(double)arg {
  standTimeTotal = arg;
}
- (double)volunteerHoursTotal {
  return volunteerHoursTotal;
}
- (void) setVolunteerHoursTotal:(double)arg {
  volunteerHoursTotal = arg;
}

- (double)actualTotal {
  return actualTotal;
}
- (void) setActualTotal:(double)arg {
  actualTotal = arg;
}
- (double)expectedTotal {
  return expectedTotal;
}
- (void) setExpectedTotal:(double)arg {
  expectedTotal = arg;
}
- (double)variance {
  return variance;
}
- (void) setVariance:(double)arg {
  variance = arg;
}

- (double)totalChecks {
  return totalChecks;
}
- (void) setTotalChecks:(double)arg {
  totalChecks = arg;
}
- (double)totalCards {
  return totalCards;
}
- (void) setTotalCards:(double)arg {
  totalCards = arg;
}

- (int)twos {
  return twos;
}
- (void) setTwos:(int)arg {
  twos = arg;
}
- (double)totalCash {
  return totalCash;
}
- (void) setTotalCash:(double)arg {
  totalCash = arg;
}

- (double)taxOwed {
  return taxOwed;
}
- (void) setTaxOwed:(double)arg {
  taxOwed = arg;
}

- (NSString *)pathToPdfArchive {
  return pathToPdfArchive;
}
- (void) setPathToPdfArchive:(NSString *)arg {
  arg = [arg copy];
  [pathToPdfArchive release];
  pathToPdfArchive = arg;
}

- (double)totalCredits {
  return totalCredits;
}
- (void) setTotalCredits:(double)arg {
  totalCredits = arg;
}


@end
