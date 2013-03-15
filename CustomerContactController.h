//
//  CustomerContactController.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "PeopleController.h"
#import "Person.h"
#import "CustomerContact.h"
#import "CreateCorrespondence.h"
@interface CustomerContactController : BasicWindowController {
  
  CreateCorrespondence *contactCreator;
  
  IBOutlet NSTableView *contactsTableView;
  IBOutlet NSArrayController *contactsArrayController;
  NSMutableArray *contactsArray;
  Person *person;
  CustomerContact *contact;
  PeopleController *peopleController;
  IBOutlet NSSearchField *contactsSearchField;
  int previousLengthOfContactsSearchString;
  IBOutlet NSTextField *personTextField;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSTextField *subjectTextField;
  IBOutlet NSTextView *bodyTextView;
  IBOutlet NSMatrix *typeMatrix;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSButton *cancelEditButton;
  IBOutlet NSButton *saveEditButton;
  IBOutlet NSButton *deleteButton;
  IBOutlet NSButton *newButton;
  IBOutlet NSButton *closeButton;
  
}


//******************************************************************************
// prototypes
//******************************************************************************

- (CreateCorrespondence *)contactCreator;
- (void)setContactCreator:(CreateCorrespondence *)arg;
- (NSMutableArray *)contactsArray;
- (void)setContactsArray:(NSArray *)arg;
- (void)handleContactsClicked:(id)sender;
- (Person *)person;
- (void)setPerson:(Person *)arg;
- (CustomerContact *)contact;
- (void)setContact:(CustomerContact *)arg;
- (PeopleController *)peopleController;
- (void)setPeopleController:(PeopleController *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)typeMatrixClicked:(id)sender;
- (IBAction)datePickerClicked:(id)sender;
- (IBAction)cancelEditButtonClicked:(id)sender;
- (IBAction)saveEditButtonClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)newButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;
  
  //******************************************************************************
  // handlers
  //******************************************************************************
- (void)handleContactsChange:(NSNotification *)note;
- (void)handleContactsSearchFieldChange:(NSNotification *)note;
- (void)handleContactsTableViewSelectionChange:(NSNotification *)note;


  //******************************************************************************
  // misc
  //******************************************************************************
- (void)enableSaveButtonAppropriately;
- (NSString *)stringFromTypeMatrix;

@end