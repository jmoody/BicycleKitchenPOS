//
//  AcceptInKindDonation.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Person.h"
#import "InKindDonation.h"
//#import "PeopleController.h"
#import "PersonSelector.h"

@interface AcceptInKindDonation : BasicWindowController {
  // manager
  //PeopleController *customerManager;
    
  IBOutlet NSTableView *itemsTableView;
  IBOutlet NSArrayController *itemsArrayController;
  NSMutableArray *itemsArray;
  Person *person;
  InKindDonation *inKindDonation;
  IBOutlet NSTextField *nameTextField;
  IBOutlet NSTextField *companyTextField;
  IBOutlet NSTextField *addressTextField;
  IBOutlet NSTextField *cityTextField;
  IBOutlet NSTextField *stateTextField;
  IBOutlet NSTextField *zipTextField;
  IBOutlet NSTextField *phoneTextField;
  IBOutlet NSTextField *emailTextField;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSButton *newButton;
  IBOutlet NSButton *deleteButton;
  IBOutlet NSButton *printButton;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSButton *cancelButton;
  IBOutlet NSPanel *itemPanel;
  IBOutlet NSTextField *descriptionTextField;
  IBOutlet NSButton *saveButton;
  double monetaryAmount;
  PersonSelector *clientSelector;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSMutableArray *)itemsArray;
- (void)setItemsArray:(NSArray *)arg;
- (void)handleItemsClicked:(id)sender;
- (Person *)person;
- (void)setPerson:(Person *)arg;
- (InKindDonation *)inKindDonation;
- (void)setInKindDonation:(InKindDonation *)arg;

- (double)monetaryAmount;
- (void)setMonetaryAmount:(double)arg;

- (PersonSelector *)clientSelector;
- (void)setClientSelector:(PersonSelector *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)newButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)printButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)showPersonSelector:(id)sender;


//******************************************************************************
// handlers
//******************************************************************************


//******************************************************************************
// misc
//******************************************************************************
- (void)enablePrintButtonAppropriately;
- (void)runMonetaryWarning;

@end