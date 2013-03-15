//
//  DailyCashJournal.h
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithDate.h"


@interface DailyCashJournal : ObjectWithDate {

  double startingBalance;

  double actualTotal;
  double expectedTotal;
  double variance;
  double totalChecks;
  double totalCards;
  double totalCash;
  double totalCredits;
     
  NSMutableArray *invoiceUids;
  NSMutableArray *checkUids;
  NSMutableArray *debitUids;
  NSMutableArray *creditUids;
  
  NSString *closerNameOrInitials;

  int hundreds;
  int fifties;
  int twenties;
  int tens;
  int fives;
  int twos;
  int ones;
  bool isOpen;
  
  double untaxableTotal;
  double taxableTotal;
  double taxOwed;
    
  int projectsCompletedTotal;
  
  double donationsTotal;
  double standTimeTotal;
  double volunteerHoursTotal;
  
  NSString *pathToPdfArchive;
}

- (NSString *)bookOpenYesOrNo;

- (NSMutableArray *)creditUids;
- (void)setCreditUids:(NSArray *)uids;

- (int)projectsCompletedTotal;
- (void)setProjectsCompletedTotal:(int)total;
- (double) donationsTotal;
- (void) setDonationsTotal:(double)total;
- (double) standTimeTotal;
- (void)setStandTimeTotal:(double)total;
- (double)volunteerHoursTotal;
- (void)setVolunteerHoursTotal:(double)total;
- (double)totalChecks;
- (void)setTotalChecks:(double)arg;
- (double)totalCards;
- (void)setTotalCards:(double)arg;
- (double)totalCredits;
- (void)setTotalCredits:(double)arg;

- (double)startingBalance;
- (void)setStartingBalance:(double)arg;
- (double)actualTotal;
- (void)setActualTotal:(double)arg;
- (double)expectedTotal;
- (void)setExpectedTotal:(double)arg;
- (double)variance;
- (void)setVariance:(double)arg;
- (int)twos;
- (void)setTwos:(int)arg;
- (double)totalCash;
- (void)setTotalCash:(double)arg;

- (NSMutableArray *)invoiceUids;
- (NSString *)closerNameOrInitials;
- (int) hundreds;
- (int) fifties;
- (int) twenties;
- (int) tens;
- (int) fives;
- (int) ones;
- (NSMutableArray *)checkUids;
- (NSMutableArray *)debitUids;
- (bool) isOpen;
- (double) taxableTotal;
- (double) untaxableTotal;
- (NSString *)pathToPdfArchive;
- (void)setPathToPdfArchive:(NSString *)arg;


- (void) setInvoiceUids:(NSArray *)invoices;
- (void) setCloserNameOrInitials:(NSString *)nameOrInitials;
- (void) setHundreds:(int) h;
- (void) setFifties:(int) f;
- (void) setTwenties:(int) t;
- (void) setTens:(int) t;
- (void) setFives:(int) f;
- (void) setOnes:(int) o;
- (void) setCheckUids:(NSArray *)checks;
- (void) setDebitUids:(NSArray *)debits;
- (void) setIsOpen:(bool) open;
- (void) setTaxableTotal:(double) total;
- (void) setUntaxableTotal:(double) total;
- (double)taxOwed;
- (void)setTaxOwed:(double)arg;

@end
