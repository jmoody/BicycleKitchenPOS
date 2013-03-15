//
//  PeopleController.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/23/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PeopleController.h"
#import "PreferenceController.h"
#import "BasicWindowController.h"
#import "PersonInfoController.h"
#import "DeletePersonController.h"
#import "Person.h"
#import "People.h"

@implementation PeopleController
- (id) init {
  self = [super init];
  if (self != nil) {
    self = [super initWithWindowNibName:@"CustomerManager"];
    [self setupNotificationObservers];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
  NSEnumerator *enumerator;
  id value;
  
  enumerator = [peopleInController objectEnumerator];
  while ((value = [enumerator nextObject])) {
    [value release];
  }
  [peopleInController release];
  [personEditor release];
  [deletePersonController release];
  [currentlyViewedPerson release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<PersonController: %@>",
    [self peopleInController]];
}

//******************************************************************************
// windowing
//******************************************************************************

//******************************************************************************

- (void)setupForNonModal {
  ////NSLog(@"in setup for non modal");
  [self setPeopleInController:[[People sharedInstance] arrayForDictionary]];
  ////NSLog(@"people controller arranged objects: %@", [peopleArrayController arrangedObjects]);
  ////NSLog(@"people controller content: %@", [peopleArrayController content]);
  
  [peopleTableView setTarget:self];
  [peopleTableView setDoubleAction:@selector(openPersonInfoWindow:)];
  [self setCurrentlyViewedPerson:nil];
  
  [openInfoWindowButton setEnabled:YES];
  [openInfoWindowButton setState:1];
  [quickSaleButton setEnabled:NO];
  [quickSaleButton setHidden:YES];
  [deletePersonButton setEnabled:YES];
  [deletePersonButton setHidden:NO];
  [selectPersonButton setEnabled:NO];
  [selectPersonButton setHidden:YES];
  [cancelSelectPersonButton setEnabled:YES];
  [cancelSelectPersonButton setHidden:NO];

  [super setupForNonModal];
  
}

- (void)windowDidLoad {
  // only called once - consider moving this to basic window
  // the call would then be [super windowDidLoad];
  //  if (runningModal) {
  //    [self setupForModal];
  //  } else {
  //    [self setupForNonModal];
  //  }
//  [self setupForNonModal];
  [super windowDidLoad];
}


- (void)setupForModal {
  [self setPeopleInController:[[People sharedInstance] arrayForDictionary]];
  ////NSLog(@"people controller arranged objects: %@", [peopleArrayController arrangedObjects]);
  ////NSLog(@"people controller content: %@", [peopleArrayController content]);
	[self clearTextField:personSearchField];
  [peopleTableView setTarget:self];
  [peopleTableView setDoubleAction:@selector(handleSelectPerson:)];
  [self setCurrentlyViewedPerson:nil];
  
  [deletePersonButton setEnabled:NO];
  [deletePersonButton setHidden:YES];
 
  [selectPersonButton setEnabled:YES];
  [selectPersonButton setHidden:NO];

  //[selectPersonButton setKeyEquivalent:@"Return"];
  [cancelSelectPersonButton setEnabled:YES];
  [cancelSelectPersonButton setHidden:NO];
  [quickSaleButton setEnabled:YES];
  [quickSaleButton setHidden:NO];
  [super setupForModal];
}


- (void)runModalWithParent:(NSWindow *)parent {
  // handles the running of modal
  [super runModalWithParent:parent];
}

- (IBAction)selectPersonButtonClicked:(id)sender {
  [self handleSelectPerson:self];
}

- (IBAction)cancelSelectPersonButtonClicked:(id)sender {
  // hmm, will this work always? are there going to be cases where i want
  // leave the parent window open?
  [[self parentWindow] close];
  [super stopModalAndCloseWindow];
}

- (void)handleSelectPerson:(id)sender {
  Person *p = [[peopleArrayController selectedObjects] objectAtIndex:0];
  [self setCurrentlyViewedPerson:p];
  [super stopModalAndCloseWindow];
}

- (IBAction)quickSaleButtonClicked:(id)sender {
  Person *p = [[People sharedInstance] personForName:TljBkPosAnonymousClientName];
  [self setCurrentlyViewedPerson:p];
  [super stopModalAndCloseWindow];
}

//******************************************************************************
// searching
//******************************************************************************

- (void)handlePeopleSearchFieldDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *nameString, *emailString, *phoneString, *membershipString;
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setPeopleInController:[[People sharedInstance] arrayForDictionary]];
      previousLengthOfPeopleSearchString = 0;
      [peopleTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfPeopleSearchString > [searchString length]) {
      [self setPeopleInController:[[People sharedInstance] arrayForDictionary]];
    }
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [peopleInController objectEnumerator];
    while ( object = [e nextObject] ) {
      nameString = [[object personName] lowercaseString];
      emailString = [[object emailAddress] lowercaseString];
      phoneString = [[object phoneNumber] lowercaseString];
      membershipString = [[object memberType] lowercaseString];
      
      NSRange nameRange = [nameString rangeOfString:searchString options:NSLiteralSearch];
      NSRange emailRange = [emailString rangeOfString:searchString options:NSLiteralSearch];
      NSRange phoneRange = [phoneString rangeOfString:searchString options:NSLiteralSearch];
      NSRange membershipRange = [membershipString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((emailRange.length) > 0) || ((nameRange.length) > 0) || ((phoneRange.length) > 0) || ((membershipRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setPeopleInController:filteredObjects];
    [peopleTableView reloadData];
    previousLengthOfPeopleSearchString = [searchString length];
    [filteredObjects release];
  }
}


//******************************************************************************
// IBActions
//******************************************************************************

- (IBAction)openPersonInfoWindow:(id)sender {
  ////NSLog(@"view person");
  NSArray *selected = [peopleArrayController selectedObjects];
  if ([selected count] > 0) {
    Person *selectedPerson = [selected objectAtIndex:0];
    if (selectedPerson != nil) {
      if (personEditor == nil) {
        PersonEditor *tmp = [[PersonEditor alloc] init];
        [self setPersonEditor:tmp];
        [tmp release];
      }
      [personEditor setPerson:selectedPerson];
      [personEditor setupForModal];
      [personEditor runModalWithParent:[self window]];
    }
  }
}

- (void)setCreateCustomerController:(CreateCustomerController *)ccc {
  if (createCustomerController != ccc) {
    [ccc retain];
    [createCustomerController release];
    createCustomerController = ccc;
  }
}

- (IBAction)newPersonButtonClicked:(id)sender {
  ////NSLog(@"newPersonButtonClicked");
  
  if (createCustomerController == nil) {
    CreateCustomerController *tmp = [[CreateCustomerController alloc] init];
    [self setCreateCustomerController:tmp];
    [tmp release];
  }
  [createCustomerController setMainWindow:[self window]];
  [createCustomerController setPeopleArrayController:peopleArrayController];
  [createCustomerController setBypassDuplicatePerson:NO];
  [createCustomerController runCreateCustomerModal];  
}


//******************************************************************************

- (IBAction)deletePersonButtonClicked:(id)sender {
  if (deletePersonController == nil) {
    ////NSLog(@"making deletePersonController");
    DeletePersonController *tmp = [[DeletePersonController alloc] init];
    [self setDeletePersonController:tmp];
    [tmp release];
  }
  
  Person *selectedPerson = [[peopleArrayController selectedObjects] objectAtIndex:0];
  // do i have to set this person to the currentViewedPerson for self?
  ////NSLog(@"calling setupForModal");
  [deletePersonController setPeopleController:self];
  [deletePersonController setCvp:selectedPerson];
  [deletePersonController setupForModal];
 // //NSLog(@"calling runModalWithParent");
  [deletePersonController runModalWithParent:[self window]];
  
  
//  NSString *message = 
//  [NSString stringWithFormat:@"Deleting a person will delete all the associated contacts,\ncomments, and projects. to the person (ie. invoices, comments, contacts, etc.). Proceed with caution"];
//  int choice = NSRunAlertPanel(@"Delete Person",
//                               message,@"Continue With Delete",@"Cancel Delete",
//                               nil);
//  if (choice == 1) {
//    Person *selectedPerson = [[peopleArrayController selectedObjects] objectAtIndex:0];
//    [peopleArrayController removeObject:selectedPerson];
//  } 
}

- (DeletePersonController *)deletePersonController {
  return deletePersonController;
}


- (void)setDeletePersonController:(DeletePersonController *)controller {
  [controller retain];
  [deletePersonController release];
  deletePersonController = controller;
}


//******************************************************************************
// accessor
//******************************************************************************

- (NSMutableArray *)peopleInController {
  return peopleInController;
}

//******************************************************************************

- (Person *)currentlyViewedPerson {
  return currentlyViewedPerson;
}

//******************************************************************************
// setter
//******************************************************************************

- (void)setPeopleInController:(NSArray *)array {
  if (peopleInController != array) {
    
    NSEnumerator *enumerator = [peopleInController objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
      [self stopObservingPerson:value];
    }
    
    [peopleInController release];
    
    peopleInController = [array mutableCopy];
    
    enumerator = [peopleInController objectEnumerator];
    while ((value = [enumerator nextObject])) {
      [self startObservingPerson:value];
    }
  }
}

- (PersonEditor *)personEditor {
  return personEditor;
}
- (void)setPersonEditor:(PersonEditor *)arg {
  [arg retain];
  [personEditor release];
  personEditor = arg;
}

//******************************************************************************

- (void)setCurrentlyViewedPerson:(Person *)person {
  if (person != currentlyViewedPerson) {
    [currentlyViewedPerson release];
    [person retain];
    currentlyViewedPerson = person;
  }
}

- (void)handlePeopleChange:(NSNotification *)note {
  if ([note object] != self) {
    [self setPeopleInController:[[People sharedInstance] arrayForDictionary]];
    [peopleTableView reloadData];
  }
}

//******************************************************************************
// insert/remove
//******************************************************************************

- (void)insertObject:(Person *)p inPeopleInControllerAtIndex:(int)index {
  //Add the inverse of this operaton to the undo stack
 // //NSLog(@"in insertObject in people controller");
  NSUndoManager *undo = [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self]
    removeObjectFromPeopleInControllerAtIndex:index];
  if (![undo isUndoing]) {
    [undo setActionName:@"Add Person"];
  }
  
  [self startObservingPerson:p];
//  [peopleInController insertObject:p atIndex:index];
  [[People sharedInstance] setObject:p forUid:[p uid]];
//  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//  [nc postNotificationName:[[People sharedInstance] notificationChangeString] object:self];
}


//******************************************************************************

- (void) removeObjectFromPeopleInControllerAtIndex:(int)index {
  Person *p = [peopleInController objectAtIndex:index];
  // Add the inverse of this operation to the undo stack
  
  NSUndoManager *undo =  [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self] insertObject:p
                          inPeopleInControllerAtIndex:index];
  
  if (![undo isUndoing]) {
    [undo setActionName:@"Delete Person"];
  }
  
  [self stopObservingPerson:p];
//  [peopleInController removeObjectAtIndex:index];
  [[People sharedInstance] removeObjectForUid:[p uid]];
//  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//  [nc postNotificationName:[[People sharedInstance] notificationChangeString] object:self];
}

//******************************************************************************

- (void)startObservingPerson:(Person *)p {
  [p addObserver:self
      forKeyPath:@"personName"
         options:NSKeyValueObservingOptionOld
         context:NULL];
  
  [p addObserver:self
      forKeyPath:@"phoneNumber"
         options:NSKeyValueObservingOptionOld
         context:NULL];
  
  [p addObserver:self
      forKeyPath:@"emailAddress"
         options:NSKeyValueObservingOptionOld
         context:NULL];
}

- (void)stopObservingPerson:(Person *)p {
  [p removeObserver:self forKeyPath:@"personName"];
  [p removeObserver:self forKeyPath:@"phoneNumber"];
  [p removeObserver:self forKeyPath:@"emailAddress"];
}

//******************************************************************************

- (void)changeKeyPath:(NSString *)keyPath
             ofObject:(id)obj
              toValue:(id)newValue {
  // setValue:forKeyPath will cause the key-value observing method
  // to be called, which takes care of the undo stuff
  [obj setValue:newValue forKeyPath:keyPath];
}

//******************************************************************************

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  NSUndoManager *undo = [[self window] undoManager];
  id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
  ////NSLog(@"oldValue = %@", oldValue);
  [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                ofObject:object
                                                 toValue:oldValue];
  [undo setActionName:@"Edit Person"];
}

//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
   
  // searching
  [nc addObserver:self
         selector:@selector(handlePeopleSearchFieldDidChange:)
             name:@"NSControlTextDidChangeNotification"
           object:personSearchField];
  
  // handling undo/redo edits
  [nc addObserver:self
         selector:@selector(handleUndoEdits:)
             name:@"NSUndoManagerDidRedoChangeNotification"
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleUndoEdits:)
             name:@"NSUndoManagerDidUndoChangeNotification"
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handlePeopleChange:)
             name:[[People sharedInstance] notificationChangeString]
           object:nil];
}

- (void)handleUndoEdits:(NSNotification *)note {
  if ([note object] == [[self window] undoManager]) {
    [[People sharedInstance] saveToDisk];
  }
}

@end
