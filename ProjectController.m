//
//  ProjectController.m
//  BicycleKitchenPOS
//
//  Created by moody on 10/15/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ProjectController.h"
#import "Project.h"
#import "Projects.h"
#import "Bicycle.h"

#import "ProjectInformationController.h"

@implementation ProjectController

- (id) init {
  self = [super init];
  if (self != nil) {
    self = [super initWithWindowNibName:@"ProjectManager"];
    [self setupNotificationObservers];
    previousLengthOfProjectSearchString = 0;
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  
  [projectsInController release];
  [currentPerson release];
  [currentlyViewedProject release];
  [projectInfoController release];
  [createProjectController release];
  
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<ProjectController>"];
}

//******************************************************************************
// windowing
//******************************************************************************

- (void)windowDidLoad {
  // only called once
  [super windowDidLoad];
}

//******************************************************************************

- (void)setupForNonModal {
  [super setupForNonModal];
  [[self window] makeFirstResponder:projectSearchField];
  [self clearTextField:projectSearchField];
  [self setProjectsInController:[self arrayForView]];
 
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];
  [[self window] makeFirstResponder:projectSearchField];
  [self clearTextField:projectSearchField];
  [self setProjectsInController:[self arrayForView]];
  [projectsTableView setTarget:self];
}

//******************************************************************************

- (void)setupButtonsForUpdateProject {
  [self hideAndDisableButton:newProjectButton];
  [self hideAndDisableButton:deleteProjectButton];
  
  [self showAndEnableButton:cancelSelectProjectButton];
  [self showAndEnableButton:selectProjectButton];
  
  [self hideAndDisableButton:invoiceNewButton];
  [self hideAndDisableButton:invoiceCancelButton];
  [self hideAndDisableButton:invoiceSelectButton];
  
  [self hideAndDisableButton:addInvoiceSelectButton];
  [self hideAndDisableButton:addInvoiceCancelButton];
  
  [viewMatrix setState:1 atRow:0 column:0];
  [viewMatrix setEnabled:NO];
  [projectsTableView setTarget:self];
  [projectsTableView setDoubleAction:@selector(showProjectInfoWindow:)];
}

//******************************************************************************

- (void)setupButtonsForManager {
  [self showAndEnableButton:newProjectButton];
  [self showAndEnableButton:deleteProjectButton];
  
  [self hideAndDisableButton:cancelSelectProjectButton];
  [self hideAndDisableButton:selectProjectButton];
  
  [self hideAndDisableButton:invoiceNewButton];
  [self hideAndDisableButton:invoiceCancelButton];
  [self hideAndDisableButton:invoiceSelectButton];
  
  [self hideAndDisableButton:addInvoiceSelectButton];
  [self hideAndDisableButton:addInvoiceCancelButton];
  
  [viewMatrix setState:1 atRow:0 column:0];
  [viewMatrix setEnabled:YES];
  [projectsTableView setDoubleAction:@selector(showProjectInfoWindow:)];
  [self setCurrentPerson:nil];
}

//******************************************************************************

- (void)setupButtonsForAddProjectToInvoice {
 
  [self hideAndDisableButton:newProjectButton];
  [self hideAndDisableButton:deleteProjectButton];

  [self hideAndDisableButton:cancelSelectProjectButton];
  [self hideAndDisableButton:selectProjectButton];
  
  // disabling this for now - until i figure out how
  // to influence the create project controller tab
  // view to skip the first page.
  //[self showAndEnableButton:invoiceNewButton];
  [self hideAndDisableButton:invoiceNewButton];
  [self showAndEnableButton:invoiceCancelButton];
  [self showAndEnableButton:invoiceSelectButton];

  [self hideAndDisableButton:addInvoiceSelectButton];
  [self hideAndDisableButton:addInvoiceCancelButton];
  
  [viewMatrix setState:1 atRow:0 column:0];
  [viewMatrix setEnabled:NO];
  
  [projectsTableView setTarget:self];
  [projectsTableView setDoubleAction:@selector(handleInvoiceProjectClicked:)]; 

}

//******************************************************************************

- (void)setupButtonsForAddInvoiceToProject {

  [self hideAndDisableButton:newProjectButton];
  [self hideAndDisableButton:deleteProjectButton];
  
  [self hideAndDisableButton:cancelSelectProjectButton];
  [self hideAndDisableButton:selectProjectButton];
  
  [self hideAndDisableButton:invoiceNewButton];
  [self hideAndDisableButton:invoiceCancelButton];
  [self hideAndDisableButton:invoiceSelectButton];
  
  [self showAndEnableButton:addInvoiceSelectButton];
  [self showAndEnableButton:addInvoiceCancelButton];
  
  [viewMatrix setState:1 atRow:0 column:0];
  [viewMatrix setEnabled:NO];
  [projectsTableView setTarget:self];
  [projectsTableView setDoubleAction:@selector(handleAddInvoiceToProjectClicked:)];
    
}

//******************************************************************************

- (IBAction)addInvoiceSelectButtonClicked:(id)sender {
  Project *p = [[projectsArrayController selectedObjects] objectAtIndex:0];
  [self setCurrentlyViewedProject:p];
  [self stopModalAndCloseWindow];
}

//******************************************************************************

- (IBAction)addInvoiceCancelButtonClicked:(id)sender {
  [self setCurrentlyViewedProject:nil];
  [self stopModalAndCloseWindow];
}

//******************************************************************************

- (void)handleAddInvoiceToProjectClicked:(id)sender {
  Project *p = [[projectsArrayController selectedObjects] objectAtIndex:0];
  [self setCurrentlyViewedProject:p];
  [self stopModalAndCloseWindow];
}

//******************************************************************************

- (void)handleInvoiceProjectClicked:(id)sender {
  Project *p = [[projectsArrayController selectedObjects] objectAtIndex:0];
  [self setCurrentlyViewedProject:p];
  [self stopModalAndCloseWindow];
}

//******************************************************************************

- (IBAction)invoiceSelectButtonClicked:(id)sender {
  Project *p = [[projectsArrayController selectedObjects] objectAtIndex:0];
  [self setCurrentlyViewedProject:p];
  [self stopModalAndCloseWindow];  
}

//******************************************************************************

- (IBAction)invoiceCancelButtonClicked:(id)sender {
  [self stopModalAndCloseWindow];
  [self setCurrentlyViewedProject:nil];
  //[[self parentWindow] close];
}

//******************************************************************************

- (IBAction)invoiceNewButtonClicked:(id)sender {
  if (!createProjectController) {
    CreateProjectController *tmp = [[CreateProjectController alloc] init];
    [self setCreateProjectController:tmp];
    [tmp release];
  }
  [createProjectController setMainApplicationWindow:[self window]];
  [createProjectController setRunningModal:YES];
  [createProjectController runCreateProjectModal];
  Project *p = [createProjectController newProject];
  //NSLog(@"project: %@", p);
  if (p != nil) {
    [self setCurrentlyViewedProject:p];
    [self stopModalAndCloseWindow];
  }
}

//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  // refreshing the table
  [nc addObserver:self
         selector:@selector(handleProjectListChange:)
             name:[[Projects sharedInstance] notificationChangeString]
           object:nil];
  
  // search field
  [nc addObserver:self
         selector:@selector(handleProjectSearchFieldTextDidChange:)
             name:@"NSControlTextDidChangeNotification"
           object:projectSearchField];
}

//******************************************************************************
// handlers
//******************************************************************************

- (void)handleProjectListChange:(NSNotification *) note {
  //NSLog(@"in handleProjectListChange");
  [self setProjectsInController:[[Projects sharedInstance] arrayForDictionary]];
  [projectsTableView reloadData];
  
}

//******************************************************************************

- (void)handleProjectSearchFieldTextDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && projectSearchField == [note object]) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *bicycleStr, *startDateStr, *lastDateStr, *quoteStr, 
      *balanceStr, *nameStr, *emailStr, *phoneStr, *commentStr;
    
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setProjectsInController:[self arrayForView]];
      previousLengthOfProjectSearchString = 0;
      [projectsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfProjectSearchString > [searchString length]) {
      [self setProjectsInController:[self arrayForView]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    NSEnumerator *e = [projectsInController objectEnumerator];
    while ( object = [e nextObject] ) {
      bicycleStr = [[[object bicycle] shortDescription] lowercaseString];
      startDateStr = [[object startDate] descriptionWithCalendarFormat:@"%m/%d/%Y" 
                                                              timeZone:nil 
                                                                locale:nil];
      lastDateStr =  [[object dateLastWorked] descriptionWithCalendarFormat:@"%m/%d/%Y" 
                                                                    timeZone:nil 
                                                                     locale:nil];
      quoteStr = [NSString stringWithFormat:@"%1.2f",  [object quote]];
      balanceStr = [NSString stringWithFormat:@"%1.2f",  [object balance]];
      nameStr = [[object ownerName] lowercaseString];
      emailStr = [[object ownerEmail] lowercaseString];
      phoneStr = [[object ownerPhone] lowercaseString];
      commentStr = [[object note] lowercaseString];
            
      NSRange bicycleRange = [bicycleStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange startDateRange = [startDateStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange lastDateRange = [lastDateStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange quoteRange = [quoteStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange nameRange = [nameStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange emailRange = [emailStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange phoneRange = [phoneStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange commentRange = [commentStr rangeOfString:searchString options:NSLiteralSearch];
      

      if (((bicycleRange.length) > 0) || ((startDateRange.length) > 0) ||
          ((lastDateRange.length) > 0) || ((quoteRange.length) > 0) ||
          ((nameRange.length) > 0) || ((emailRange.length) > 0) ||
          ((phoneRange.length) > 0) || ((commentRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }

    [self setProjectsInController:filteredObjects];
    [projectsTableView reloadData];
    previousLengthOfProjectSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (IBAction)newProjectButtonClicked:(id)sender {
  if (createProjectController == nil) {
    CreateProjectController *cpc = [[CreateProjectController alloc] init];
    [self setCreateProjectController:cpc];
    [cpc release];
  }
  [createProjectController setMainApplicationWindow:[self window]];
  [createProjectController setRunningModal:YES];
  [createProjectController runCreateProjectModal];
}

//******************************************************************************

- (IBAction)showProjectInfoWindow:(id)sender {
 
  Project *p;
  p = [[projectsArrayController selectedObjects] objectAtIndex:0];
  [self setCurrentlyViewedProject:p];
  ////NSLog(@"currentlyViewedProject ProjectController: %@", [self currentlyViewedProject]);
  if (!projectInfoController) {
    ProjectInformationController *pic;
    pic = [[ProjectInformationController alloc] init];
    [self setProjectInfoController:pic];
    [pic release];
  }
  [projectInfoController setProject:[self currentlyViewedProject]];
  [projectInfoController setupForModal];
  [projectInfoController runModalWithParent:[self window]];
}

- (ProjectInformationController *)projectInfoController {
  return projectInfoController;
}

- (void)setProjectInfoController:(ProjectInformationController *)controller {
  [controller retain];
  [projectInfoController release];
  projectInfoController = controller;
}


//******************************************************************************

- (IBAction)cancelSelectProjectButtonClicked:(id)sender {
  if (runningModal) {
    [NSApp stopModal];
  }
  [[self window] close];
}

//******************************************************************************

- (void)insertObject:(Project *)p inProjectsInControllerAtIndex:(int)index {
  //NSLog(@"in remove object in project controller");
  NSUndoManager *undo = [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self]
    removeObjectFromProjectsInControllerAtIndex:index];
  if (![undo isUndoing]) {
    [undo setActionName:@"Delete Project"];
  }
  
  [[Projects sharedInstance] setObject:p forUid:[p uid]];
}

//******************************************************************************
// probably should not allow deletes from here because we need to keep
// the list of project uids for people in synch.
//******************************************************************************

- (void)removeObjectFromProjectsInControllerAtIndex:(int)index {
  //NSLog(@"in remove object in project controller");
  Project *p = [projectsInController objectAtIndex:index];
  NSUndoManager *undo = [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self] insertObject:p
                          inProjectsInControllerAtIndex:index];
  
  if (![undo isUndoing]) {
    [undo setActionName:@"Delete Project"];
  }
  [[Projects sharedInstance] removeObjectForUid:[p uid]];
}

//******************************************************************************
// accessor
//******************************************************************************

- (NSMutableArray *)projectsInController {
  return projectsInController;
}

//******************************************************************************

- (Project *)currentlyViewedProject {
  return currentlyViewedProject;
}

- (NSButton *)newProjectButton {
  return newProjectButton;
}


//******************************************************************************

- (NSSearchField *)projectSearchField {
  return projectSearchField;
}

- (CreateProjectController *)createProjectController {
  if (createProjectController == nil) {
    CreateProjectController *cpc = [[CreateProjectController alloc] init];
    [self setCreateProjectController:cpc];
    [cpc release];
  }
  return createProjectController;
}

- (void)setCreateProjectController:(CreateProjectController *)controller {
  [controller retain];
  [controller release];
  createProjectController = controller;
}


//******************************************************************************
// setter
//******************************************************************************

- (void)setProjectsInController:(NSArray *)array {
  if (projectsInController != array) {
    [projectsInController release];
    projectsInController = [array mutableCopy];
  }
}

- (NSMutableArray *)arrayForView {
  NSPredicate * predicate;
  NSArray *filtered;
  
  if ([[viewMatrix cellAtRow:0 column:0] state] == 1) {
    // active projects
    if (currentPerson == nil) {
      predicate = [NSPredicate predicateWithFormat:@"isFinished == NO"];
    } else {
      predicate = [NSPredicate predicateWithFormat:@"isFinished == NO AND ownerUid like %@",
        [currentPerson uid]];
    }
  } else if ([[viewMatrix cellAtRow:0 column:1] state] == 1) {
    if (currentPerson == nil) {
      predicate = [NSPredicate predicateWithFormat:@"isFinished == YES"];
    } else {
      predicate = [NSPredicate predicateWithFormat:@"isFinished == YES AND ownerUid like %@",
        [currentPerson uid]];
    }
  } else if ([[viewMatrix cellAtRow:0 column:2] state] == 1) {
    if (currentPerson == nil) {
      predicate = [NSPredicate predicateWithFormat:@"isOverdue == YES"];
    } else {
      predicate = [NSPredicate predicateWithFormat:@"isOverdue == YES AND ownerUid like %@",
        [currentPerson uid]];
    }
  } else {
    return [[Projects sharedInstance] arrayForDictionary];
  }
  filtered = [[[Projects sharedInstance] arrayForDictionary] filteredArrayUsingPredicate:predicate];
  return [NSArray arrayWithArray:filtered];
}
  
- (IBAction) viewMatrixClicked:(id)sender {
  //NSLog(@"viewMatrixClicked");
  [self setProjectsInController:[self arrayForView]];
  [projectsTableView reloadData];
}

- (Person *)currentPerson {
  return currentPerson;
}

- (void)setCurrentPerson:(Person *)person {
  [person retain];
  [currentPerson release];
  currentPerson = person;
}


//******************************************************************************

- (void)setCurrentlyViewedProject:(Project *)p {
  [p retain];
  [currentlyViewedProject release];
  currentlyViewedProject = p;
}


@end
