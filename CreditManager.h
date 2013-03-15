//
//  CreditManager.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/4/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "ShopCredit.h"
#import "PeopleController.h"
#import "Person.h"

@interface CreditManager : BasicWindowController {
  
  IBOutlet NSTableView *creditsTableView;
  IBOutlet NSArrayController *creditsArrayController;
  NSMutableArray *creditsArray;
  Person *currentPerson;
  PeopleController *peopleController;
  ShopCredit *currentCredit;
  IBOutlet NSSearchField *creditsSearchField;
  int previousLengthOfCreditsSearchString;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSTextField *creditAmountTextField;
  IBOutlet NSTextField *subjectTextField;
  IBOutlet NSTextView *reasonTextView;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSButton *saveEditButton;
  IBOutlet NSButton *deleteCreditButton;
  IBOutlet NSButton *closeButton;
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSMutableArray *)creditsArray;
- (void)setCreditsArray:(NSArray *)arg;
- (Person *)currentPerson;
- (void)setCurrentPerson:(Person *)arg;
- (PeopleController *)peopleController;
- (void)setPeopleController:(PeopleController *)arg;
- (ShopCredit *)currentCredit;
- (void)setCurrentCredit:(ShopCredit *)arg;


//******************************************************************************
// button actions
//******************************************************************************
- (IBAction)datePickerClicked:(id)sender;
- (IBAction)saveEditButtonClicked:(id)sender;
- (IBAction)deleteCreditButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;


//******************************************************************************
// handlers
//******************************************************************************
- (void)handleCreditsChange:(NSNotification *)note;
- (void)handleCreditsTextViewSelectionChange:(NSNotification *)note;
- (void)handleCreditsSearchFieldChange:(NSNotification *)note;


  //******************************************************************************
  // misc
  //******************************************************************************
- (void)enableSaveButtonAppropriately;
- (void)handleCreditClicked:(id)sender;

@end