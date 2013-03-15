//
//  InKindDonationManager.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "InKindDonation.h"
#import "Person.h"
#import "AcceptInKindDonation.h"

@interface InKindDonationManager : BasicWindowController {
  
  IBOutlet NSTableView *donationsTableView;
  IBOutlet NSArrayController *donationsArrayController;
  NSMutableArray *donationsArray;
  Person *person;
  InKindDonation *donation;
  IBOutlet NSSearchField *donationsSearchField;
  int previousLengthOfDonationsSearchString;
  IBOutlet NSButton *deleteButton;
  IBOutlet NSButton *newButton;
  
  AcceptInKindDonation *donationViewer;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSMutableArray *)donationsArray;
- (void)setDonationsArray:(NSArray *)arg;
- (void)handleDonationsClicked:(id)sender;
- (Person *)person;
- (void)setPerson:(Person *)arg;
- (InKindDonation *)donation;
- (void)setDonation:(InKindDonation *)arg;
- (AcceptInKindDonation *)donationViewer;
- (void)setDonationViewer:(AcceptInKindDonation *)arg;



//******************************************************************************
// button actions
//******************************************************************************
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)newButtonClicked:(id)sender;


//******************************************************************************
// handlers
//******************************************************************************
- (void)handleInKindDonationsChange:(NSNotification *)note;
- (void)handleDonationsSearchFieldChange:(NSNotification *)note;
- (bool)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;


//******************************************************************************
// misc
//******************************************************************************


@end