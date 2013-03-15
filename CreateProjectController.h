//
//  CreateProjectController.h
//  BicycleKitchenPOS
//
//  Created by moody on 10/8/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressiveWindowController.h"
#import "CreateCustomerController.h"
#import "Person.h"
#import "Project.h"
#import "Bicycle.h"
#import "People.h"
#import "Projects.h"

@interface CreateProjectController : ProgressiveWindowController {
  
  // Select Person Tab
  IBOutlet NSSearchField *clientsSearchField;
  IBOutlet NSTableView *clientsTableView;
  IBOutlet NSButton *newButton;
  //IBOutlet NSButton *selectButton;
  IBOutlet NSTextField *selectedClientTextField1;
  IBOutlet NSButton *cancelButton;
  

  NSWindow *mainApplicationWindow;
  
  CreateCustomerController *createCustomerController;
  
  NSMutableArray *clientsInCreateProject;
  IBOutlet NSArrayController *clientsArrayController;
  
  // Details tab
  IBOutlet NSForm *makeModelColorForm;
  IBOutlet NSComboBox *typeComboBox;
  IBOutlet NSDatePicker *startDatePicker;
  IBOutlet NSTextField *endDateTextField1;
  IBOutlet NSTextField *quoteTextField1;
  IBOutlet NSTextView *noteTextView;
  IBOutlet NSTextField *selectedClientTextField2;
  IBOutlet NSStepper *standTimeStepper;
  IBOutlet NSTextField *standTimeTextField;
  
  
  // Summary tab
  IBOutlet NSTextField *personNameTextField;
  IBOutlet NSTextField *makeModelTextField;
  IBOutlet NSTextField *colorTextField;
  IBOutlet NSTextField *typeTextField;
  IBOutlet NSTextField *quoteTextField2;
  IBOutlet NSTextField *startDateTextField;
  IBOutlet NSTextField *endDateTextField2;
  IBOutlet NSTextField *noteTextField;
  IBOutlet NSButton *hasSignedWaiver;
  IBOutlet NSTextField *personHasNotSignedTextField;
  IBOutlet NSTextField *instructionsTextField;
  IBOutlet NSButton *printWaiverButton;
  IBOutlet NSTextField *selectedClientTextField3;
  
  Person *selectedClient;
  Bicycle *selectedBicycle;
  Project *newProject;
  int previousLengthOfPeopleSearchString;
  
}

- (void)setupWindow;
- (void)runCreateProjectModal;

//******************************************************************************
// accessors
//******************************************************************************
- (NSWindow *)mainApplicationWindow;
- (NSMutableArray *)clientsInCreateProject;
- (Person *)selectedClient;
- (Bicycle *)selectedBicycle;
- (Project *)newProject;
- (bool)runningModal;


//******************************************************************************
// setters
//******************************************************************************

- (void)setMainApplicationWindow:(NSWindow *)mainWindow;
- (void)setClientsInCreateProject:(NSMutableArray *)array;
- (void)setSelectedClient:(Person *)client;
- (void)setSelectedBicycle:(Bicycle *)bicycle;
- (void)setNewProject:(Project *)project;
- (void)setRunningModal:(bool)modal;

- (void)setCreateCustomerController:(CreateCustomerController *)ccc;

//******************************************************************************
// actions
//******************************************************************************

- (IBAction) cancelButtonClicked:(id)sender;
- (IBAction) newButtonClicked:(id)sender;
- (IBAction) selectButtonClicked:(id)sender;
- (IBAction) startDatePickerClicked:(id)sender;
- (IBAction) standTimeStepperClicked:(id)sender;


- (IBAction) printWaiverButtonClicked:(id)sender;
- (IBAction) hasSignedWaiverButtonClicked:(id)sender;

//******************************************************************************
// searching
//******************************************************************************
- (void)handlePeopleSearchFieldDidChange:(NSNotification *)note;
- (void)setupNotificationObservers;

- (void)enableNextButtonWhenAppropriate:(NSTabViewItem *)item;

- (void)handleDetailsChange:(NSNotification *) note;

        

@end
