//
//  PeopleController.h
//  BicycleKitchenPOS
//
//  Created by moody on 7/23/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Person.h"
//#import "PersonInfoController.h"
//#import "DeletePersonController.h"
#import "CreateCustomerController.h"
#import "PersonEditor.h"

@class DeletePersonController;

@interface PeopleController : BasicWindowController {
  IBOutlet NSButton *newPersonButton;
  IBOutlet NSButton *deletePersonButton;
  IBOutlet NSSearchField *personSearchField;
  IBOutlet NSButton *selectPersonButton;
  IBOutlet NSButton *cancelSelectPersonButton;
  IBOutlet NSButton *quickSaleButton;

  
  //PersonInfoController *personInfoController;
  PersonEditor *personEditor;
  DeletePersonController *deletePersonController;
  CreateCustomerController *createCustomerController;
  
  // data
  NSMutableArray *peopleInController;
  IBOutlet NSTableView *peopleTableView;
  IBOutlet NSArrayController *peopleArrayController;
  
  // capturing return button pressed
  IBOutlet NSButton *openInfoWindowButton;

  // placeholder persons for enabling/disabling buttons
  Person *currentlyViewedPerson;
  
  // searching
  int previousLengthOfPeopleSearchString;
}

- (void)setCreateCustomerController:(CreateCustomerController *)ccc;

- (DeletePersonController *)deletePersonController;
- (void)setDeletePersonController:(DeletePersonController *)controller;

- (PersonEditor *)personEditor;
- (void)setPersonEditor:(PersonEditor *)arg;

//******************************************************************************
// accessors
//******************************************************************************
- (NSMutableArray *)peopleInController;
- (Person *)currentlyViewedPerson;

//******************************************************************************
// setters
//******************************************************************************
- (void)setPeopleInController:(NSArray *)array;
- (void)setCurrentlyViewedPerson:(Person *)person;

//******************************************************************************
// insert remove
//******************************************************************************

- (void)insertObject:(Person *)p inPeopleInControllerAtIndex:(int)index;
- (void)removeObjectFromPeopleInControllerAtIndex:(int)index;

//******************************************************************************
// showing info window
//******************************************************************************

//- (void)showInfoWindowForPerson:(Person *)p;

- (IBAction)selectPersonButtonClicked:(id)sender;
- (IBAction)cancelSelectPersonButtonClicked:(id)sender;
- (IBAction)quickSaleButtonClicked:(id)sender;
- (void) handleSelectPerson:(id)sender;


//******************************************************************************
// actions
//******************************************************************************

- (IBAction)deletePersonButtonClicked:(id)sender;
- (IBAction)newPersonButtonClicked:(id)sender;
- (IBAction)openPersonInfoWindow:(id)sender;

//******************************************************************************
// handlers
//******************************************************************************

- (void)setupNotificationObservers;

  // searching
- (void)handlePeopleSearchFieldDidChange:(NSNotification *)note;


// undo for edits
- (void)startObservingPerson:(Person *)p;
- (void)stopObservingPerson:(Person *)p;
- (void)changeKeyPath:(NSString *)keyPath
             ofObject:(id)obj
              toValue:(id)newValue;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;

@end
