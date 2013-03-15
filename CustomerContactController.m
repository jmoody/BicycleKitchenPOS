//
//  CustomerContactController.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "CustomerContactController.h"
#import "People.h"
#import "Contacts.h"
#import "Project.h"
#import "Projects.h"

@implementation CustomerContactController

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"CustomerContactManager"];
    previousLengthOfContactsSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [contactsArray release];
  [contactCreator release];  
  [person release];
  [contact release];
  [peopleController release];
  [super dealloc];
}

//******************************************************************************
// windowing
//******************************************************************************

- (void)windowDidLoad {
  [super windowDidLoad];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
}

//******************************************************************************

- (void)setupForNonModal {
  [super setupForNonModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
}

//******************************************************************************

- (void)runModalWithParent:(NSWindow *) parent {
  [super runModalWithParent:parent];
}


//******************************************************************************
// setup
//******************************************************************************

- (void)setupButtons {
  [cancelEditButton setEnabled:NO];
  [saveEditButton setEnabled:NO];
  [typeMatrix setEnabled:YES];
  [typeMatrix setState:1 atRow:0 column:0];
  [typeMatrix setEnabled:NO];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
  [datePicker setEnabled:NO];
}

//******************************************************************************

- (void)setupTextFields {
  [self clearTextField:personTextField];
  [self clearTextField:cookTextField];
  [cookTextField setEnabled:NO];
  [self clearTextField:subjectTextField];
  [subjectTextField setEnabled:NO];
  [self clearTextView:bodyTextView];
  [bodyTextView setEditable:NO];
}

//******************************************************************************

- (void)setupTables {
  [self setContactsArray:[[Contacts sharedInstance] arrayForDictionary]];
  [contactsTableView setTarget:self];
  [contactsTableView setDoubleAction:@selector(handleContactsClicked:)];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)typeMatrixClicked:(id)sender {
  //NSLog(@"typeMatrix clicked");
  [self enableSaveButtonAppropriately];
}

//******************************************************************************

- (IBAction)datePickerClicked:(id)sender {
  //NSLog(@"datePicker clicked");
  [self enableSaveButtonAppropriately];
}

//******************************************************************************

- (IBAction)cancelEditButtonClicked:(id)sender {
  //NSLog(@"cancelEditButton clicked");
  [cookTextField setStringValue:[contact commentAuthorName]];
  [subjectTextField setStringValue:[contact commentSubject]];
  [bodyTextView setString:[contact commentText]];
  [datePicker setDateValue:[contact date]];
  if ([contact leftMessage]) {
    [typeMatrix setState:1 atRow:0 column:0];
  } else if ([contact sentEmail]) {
    [typeMatrix setState:1 atRow:1 column:0];
  } else {
    [typeMatrix setState:1 atRow:2 column:0];
  }
}

//******************************************************************************

- (IBAction)saveEditButtonClicked:(id)sender {
  NSLog(@"saveEditButton clicked");
  NSString *newCook = [self latexSafeStringFromTextField:cookTextField];
  NSString *newSubject = [self lowercaseAndLatexSafeStringFromTextField:subjectTextField];
  NSString *newBody = [self lowercaseAndLatexSafeStringFromTextView:bodyTextView];
  [contact setCommentAuthorName:newCook];
  [contact setCommentSubject:newSubject];
  [contact setCommentText:newBody];
  
  [contact setSentEmail:NO];
  [contact setLeftMessage:NO];
  [contact setSpokeDirectly:NO];
  
  if ([[typeMatrix cellAtRow:0 column:0] state]) {
    [contact setLeftMessage:YES];
  } else if ([[typeMatrix cellAtRow:1 column:0] state]) {
    [contact setSentEmail:YES];
  } else {
    [contact setSpokeDirectly:YES];
  }
  [saveEditButton setEnabled:NO];
  [cancelEditButton setEnabled:NO];
}

//******************************************************************************

- (IBAction)deleteButtonClicked:(id)sender {
  NSArray *selected = [contactsArrayController selectedObjects];
  if ([selected count] > 0) {
    CustomerContact *tmp = (CustomerContact *)[selected objectAtIndex:0];
    if (tmp != nil) {
      Person *p = [[People sharedInstance] objectForUid:[tmp personUid]];
      if (p == nil) {
        NSLog(@"Error in delete contact: person for uid %@ is nil", [tmp personUid]);
      }
      
      NSPredicate *pred = [NSPredicate predicateWithFormat:@"!(SELF like %@)", [tmp uid]];
      [[p contactUids] filterUsingPredicate:pred];
      [[People sharedInstance] saveToDisk];
      
      NSArray *allProjects = [[Projects sharedInstance] arrayForDictionary];
      unsigned int i, count = [allProjects count];
      for (i = 0; i < count; i++) {
        Project *pr = (Project *)[allProjects objectAtIndex:i];
        [[pr contactUids] filterUsingPredicate:pred];
      }
      [[Projects sharedInstance] saveToDisk];
      
      [[Contacts sharedInstance] removeObjectForUid:[tmp uid]];
      [self setupButtons];
      [self setupTextFields];
    }
  }
}

//******************************************************************************

- (IBAction)newButtonClicked:(id)sender {
  NSArray *selected = [contactsArrayController selectedObjects];
  if ([selected count] > 0) {
    CustomerContact *select = (CustomerContact *)[selected objectAtIndex:0];
    if (select != nil) {
      Person *p = [[People sharedInstance] objectForUid:[select personUid]];
      if (p != nil) {
        if (contactCreator == nil) {
          CreateCorrespondence *tmp = [[CreateCorrespondence alloc] init];
          [self setContactCreator:tmp];
          [tmp release];
        }
        [contactCreator setPerson:p];
        [contactCreator setupForModal];
        [contactCreator runModalWithParent:[self window]];
      }
    }
  }
}

- (IBAction)closeButtonClicked:(id)sender {
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}


//******************************************************************************
// misc
//******************************************************************************
- (void)enableSaveButtonAppropriately {
  NSString *orgCook = [contact commentAuthorName];
  NSString *newCook = [cookTextField stringValue];
  NSString *orgSubject = [contact commentSubject];
  NSString *newSubject = [subjectTextField stringValue];
  NSString *orgBody = [contact commentText];
  NSString *newBody = [bodyTextView string];
  
  bool messageTypeIsDifferent;
 
  bool newMessage = [self boolValueForRadioMatrix:typeMatrix cell:[typeMatrix cellAtRow:0 column:0]];
  bool newSpoke = [self boolValueForRadioMatrix:typeMatrix cell:[typeMatrix cellAtRow:0 column:1]];
  bool newEmail = [self boolValueForRadioMatrix:typeMatrix cell:[typeMatrix cellAtRow:0 column:2]];
  bool orgMessage = [contact leftMessage];
  bool orgSpoke = [contact spokeDirectly];
  bool orgEmail = [contact sentEmail];
  if ((newMessage != orgMessage) || (newSpoke != orgSpoke) || (newEmail != orgEmail)) {
    messageTypeIsDifferent = YES;
  } else {
    messageTypeIsDifferent = NO;
  }
  
  
  bool differentDate = YES;
  if ([self date:[contact date] equalsDate:[self calendarDateFromDatePicker:datePicker]]) {
    differentDate = NO;
  }
  //NSLog(@"date is different: %d", differentDate);
  //NSLog(@"type is different: %d", messageTypeIsDifferent);

  if (differentDate || messageTypeIsDifferent ||
      ![orgCook isEqualToString:newCook] ||
      ![orgSubject isEqualToString:newSubject] ||
      ![orgBody isEqualToString:newBody]) {
    [cancelEditButton setEnabled:YES];
    [saveEditButton setEnabled:YES];
  } else {
    [cancelEditButton setEnabled:NO];
    [saveEditButton setEnabled:NO];
  }
}

//******************************************************************************

- (NSString *)stringFromTypeMatrix {

  int index = [typeMatrix selectedRow];
  if (index == 0) {
    return [NSString stringWithFormat:@"left message"];
  } else if (index == 1) {
    return [NSString stringWithFormat:@"sent email"];
  } else {
    return [NSString stringWithFormat:@"spoke directly"];
  }
}


//******************************************************************************
// handlers
//******************************************************************************

- (void) handleContactsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == contactsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *personString, *emailString, *phoneString, *typeString, *nameString, 
      *subjectString, *bodyString, *dateString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setContactsArray:[[Contacts sharedInstance] arrayForDictionary]];
      previousLengthOfContactsSearchString = 0;
      [contactsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfContactsSearchString > [searchString length]) {
      [self setContactsArray:[[Contacts sharedInstance] arrayForDictionary]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [contactsArray objectEnumerator];
    while (object = [e nextObject] ) {
      personString = [[object personName] lowercaseString];
      NSRange personRange = [personString rangeOfString:searchString options:NSLiteralSearch];
      emailString = [[object personEmail] lowercaseString];
      NSRange emailRange = [emailString rangeOfString:searchString options:NSLiteralSearch];
      phoneString = [[object personPhone] lowercaseString];
      NSRange phoneRange = [phoneString rangeOfString:searchString options:NSLiteralSearch];
      typeString = [[object stringForContactType] lowercaseString];
      NSRange typeRange = [typeString rangeOfString:searchString options:NSLiteralSearch];
      nameString = [[object commentAuthorName] lowercaseString];
      NSRange nameRange = [nameString rangeOfString:searchString options:NSLiteralSearch];
      subjectString = [[object commentSubject] lowercaseString];
      NSRange subjectRange = [subjectString rangeOfString:searchString options:NSLiteralSearch];
      bodyString = [[object commentText] lowercaseString];
      NSRange bodyRange = [bodyString rangeOfString:searchString options:NSLiteralSearch];
      dateString = [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((personRange.length) > 0) || ((emailRange.length) > 0) || ((phoneRange.length) > 0) || 
          ((typeRange.length) > 0) || ((nameRange.length) > 0) || ((subjectRange.length) > 0) || 
          ((bodyRange.length) > 0) || ((dateRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setContactsArray:filteredObjects];
    [contactsTableView reloadData];
    previousLengthOfContactsSearchString = [searchString length];
    [filteredObjects release];
  }
}
  

- (void) handleContactsTableViewSelectionChange:(NSNotification *)note {
  if ([note object] == contactsTableView) {
    [self handleContactsClicked:[note object]];
  }
}

//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    [self enableSaveButtonAppropriately];
  }
}

//******************************************************************************

- (void)handleContactsChange:(NSNotification *)note {
  NSArray *tmp = [[Contacts sharedInstance] arrayForDictionary];
  [self setContactsArray:tmp];
  [contactsTableView reloadData];
}

//******************************************************************************

- (void)handleContactsClicked:(id)sender {
  //NSLog(@"handleContactsClicked");
  NSArray *selectedObjects = [contactsArrayController selectedObjects];
  if ([selectedObjects count] > 0) {
    CustomerContact *tmp = (CustomerContact *)[selectedObjects objectAtIndex:0];
    if (tmp != nil) {
      [self setContact:tmp];
      Person *p = [[People sharedInstance] objectForUid:[contact personUid]];
      [self setPerson:p];
      [personTextField setStringValue:[person personName]];
      [cookTextField setStringValue:[contact commentAuthorName]];
      [cookTextField setEnabled:YES];
      [subjectTextField setStringValue:[contact commentSubject]];
      [subjectTextField setEnabled:YES];
      [bodyTextView setString:[contact commentText]];
      [bodyTextView setEditable:YES];
      [datePicker setDateValue:[contact date]];
      [datePicker setEnabled:YES];
      if ([contact leftMessage]) {
         [typeMatrix setState:1 atRow:0 column:0];
      } else if ([contact sentEmail]) {
         [typeMatrix setState:1 atRow:1 column:0];
      } else {
         [typeMatrix setState:1 atRow:2 column:0];
      }
      [typeMatrix setEnabled:YES];
    }
  }
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (NSMutableArray *)contactsArray {
  return contactsArray;
}
- (void) setContactsArray:(NSArray *)arg {
  if (arg != contactsArray) {
    [contactsArray release];
    contactsArray = [arg mutableCopy];
  }
}
- (Person *)person {
  return person;
}
- (void) setPerson:(Person *)arg {
  [arg retain];
  [person release];
  person = arg;
}
- (CustomerContact *)contact {
  return contact;
}
- (void) setContact:(CustomerContact *)arg {
  [arg retain];
  [contact release];
  contact = arg;
}
- (PeopleController *)peopleController {
  return peopleController;
}
- (void) setPeopleController:(PeopleController *)arg {
  [arg retain];
  [peopleController release];
  peopleController = arg;
}
- (CreateCorrespondence *)contactCreator {
  return contactCreator;
}
- (void)setContactCreator:(CreateCorrespondence *)arg {
  [arg retain];
  [contactCreator release];
  contactCreator = arg;
}


//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(handleContactsSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:contactsSearchField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:personTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:cookTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:subjectTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:bodyTextView];
  
  [nc addObserver:self
         selector:@selector(handleContactsChange:)
             name:[[Contacts sharedInstance] notificationChangeString]
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleContactsTableViewSelectionChange:)
             name:NSTableViewSelectionDidChangeNotification
           object:contactsTableView];
  
}
@end