//
//  ProjectController.h
//  BicycleKitchenPOS
//
//  Created by moody on 10/15/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Project.h"
#import "Projects.h"
#import "ProjectInformationController.h"
#import "CreateProjectController.h"
#import "Person.h"

@interface ProjectController : BasicWindowController {
  
  IBOutlet NSMatrix *viewMatrix;
  IBOutlet NSButton *newProjectButton;
  IBOutlet NSButton *deleteProjectButton;
  IBOutlet NSSearchField *projectSearchField;
  // capturing return button pressed
  IBOutlet NSButton *selectProjectButton;
  IBOutlet NSButton *cancelSelectProjectButton;
  
  IBOutlet NSButton *invoiceSelectButton;
  IBOutlet NSButton *invoiceCancelButton;
  IBOutlet NSButton *invoiceNewButton;
  
  IBOutlet NSButton *addInvoiceSelectButton;
  IBOutlet NSButton *addInvoiceCancelButton;
  
  ProjectInformationController *projectInfoController;
  CreateProjectController *createProjectController;
  
  NSMutableArray *projectsInController;
  
  IBOutlet NSTableView *projectsTableView;
  IBOutlet NSArrayController *projectsArrayController;
  
  Project *currentlyViewedProject;
  Person *currentPerson;
  
  
  // searching
  int previousLengthOfProjectSearchString;
  
}

- (void)setupButtonsForUpdateProject;
- (void)setupButtonsForManager;
- (void)setupButtonsForAddProjectToInvoice;
- (void)setupButtonsForAddInvoiceToProject;

- (NSSearchField *)projectSearchField;

- (NSMutableArray *)arrayForView;

// accessors
- (NSMutableArray *)projectsInController;
- (Project *)currentlyViewedProject;
- (NSButton *)newProjectButton;
- (Person *)currentPerson;
- (void)setCurrentPerson:(Person *)person;

// setters
- (void)setProjectsInController:(NSArray *)array;
- (void)setCurrentlyViewedProject:(Project *)p;

- (CreateProjectController *)createProjectController;
- (void)setCreateProjectController:(CreateProjectController *)controller;

- (ProjectInformationController *)projectInfoController;
- (void)setProjectInfoController:(ProjectInformationController *)controller;


// insert/remove
- (void)insertObject:(Project *)p inProjectsInControllerAtIndex:(int)index;
- (void)removeObjectFromProjectsInControllerAtIndex:(int)index;

// ibactions for displaying ProjectInfoPanel
- (IBAction)newProjectButtonClicked:(id)sender;
- (IBAction)showProjectInfoWindow:(id)sender;
- (IBAction)cancelSelectProjectButtonClicked:(id)sender;

- (IBAction)invoiceSelectButtonClicked:(id)sender;
- (IBAction)invoiceCancelButtonClicked:(id)sender;
- (IBAction)invoiceNewButtonClicked:(id)sender;
- (void)handleInvoiceProjectClicked:(id)sender;

- (IBAction)addInvoiceSelectButtonClicked:(id)sender;
- (IBAction)addInvoiceCancelButtonClicked:(id)sender;
- (void)handleAddInvoiceToProjectClicked:(id)sender;

- (IBAction) viewMatrixClicked:(id)sender;

//******************************************************************************
// handlers
//******************************************************************************

- (void)handleProjectListChange:(NSNotification *) note;
- (void)setupNotificationObservers;
- (void)handleProjectSearchFieldTextDidChange:(NSNotification *)note;

@end
