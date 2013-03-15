//
//  CustomerContactController.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "CustomerContactController.h"
#import "CustomerContact.h"
#import "Contacts.h"
#import "ObjectWithComment.h"
#import "ObjectWithDate.h"
#import "ObjectWithUid.h"

@implementation CustomerContactController

- (id) init {
  self = [super init];
  if (self != nil) {
    self = [super initWithWindowNibName:@"CustomerContactManager"];
    [self setupNotificationObservers];
    previousLengthOfContactSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
  [self deallocAnArray:contactsArray];

  [currentlyViewedContact release];
  [mainApplicationWindow release];
  
  [super dealloc];
}

//******************************************************************************

- (void)deallocAnArray:(NSArray *)array {
  NSEnumerator *e = [array objectEnumerator];
  id value;
  while ((value = [e nextObject])) {
    [value release];
  }
  [array release];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<CustomerContactController: %@>",
    [self currentlyViewedContact]];
}

//******************************************************************************
// preparing the window
//******************************************************************************

- (void)windowDidLoad {
  // is not called when running modal
  ////NSLog(@"CustomerContactController windowDidLoad");
  [self setupWindow];
}

//******************************************************************************

- (void)setupWindow {
  ////NSLog(@"CustomerContactController setupWindow");
  if ([contactsSearchField acceptsFirstResponder]) {
    [[self window] makeFirstResponder:contactsSearchField]; 
  }
  [self setContactsArray:[[Contacts sharedInstance] arrayForDictionary]];
  ////NSLog(@"contactsArray: %@", contactsArray);
  [contactsTableView setTarget:self];
  [contactsTableView setDoubleAction:@selector(showContactInfo:)];
  [self enableOrDisableContactsTab:NO];
  
}

//******************************************************************************

- (void)runCustomerContactModal {
  ////NSLog(@"CustomerContactController runProjectInfoModal");
 
  [self setupWindow];
  [NSApp beginSheet:[self window]
     modalForWindow:mainApplicationWindow
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];
  
  [NSApp runModalForWindow:[self window]];
  
  
  [NSApp endSheet:[self window]];
  [[self window] orderOut:self];
}

//******************************************************************************

- (IBAction)closeWindowButtonClicked:(id)sender {
  if (runningModal) {
    [NSApp stopModal];
  } else {
    [[self window] close];
  }
  [self clearContactsTab];
}

//******************************************************************************

- (NSString *)stringFromTextField:(NSTextField *)tf andCalendarDate:(NSCalendarDate *)c {
  NSFormatter *form = [tf formatter];
  NSString *str = [form stringForObjectValue:c];
  return str;
}

//******************************************************************************

- (void)clearContactsTab {
  [self clearTextField:contactsSearchField];
  [self clearTextField:contactsCookTextField];
  [self clearTextField:contactsSubjectTextField];
  [self clearTextView:contactsBodyTextView];
  [self enableOrDisableContactsTab:NO];
}

//******************************************************************************

- (void)clearTextField:(NSTextField *)tf {
  NSString *emptyString = [NSString stringWithFormat:@""];
  [tf setStringValue:emptyString];
}

//******************************************************************************

- (void)clearTextView:(NSTextView *)tw {
  NSString *emptyString = [NSString stringWithFormat:@""];
  [tw setString:emptyString];
}

//******************************************************************************
// notifications
//******************************************************************************

- (void) textDidChange: (NSNotification *) notifications {
  ////NSLog(@"in textDidChange");
  if ([notifications object] == contactsBodyTextView) {
    [self enableContactSaveButtonIfAppropriate];
  } 
}

//******************************************************************************

- (void)updateContacts:(NSNotification *)note {
  [self setContactsArray:[[Contacts sharedInstance] arrayForDictionary]];
  [contactsTableView reloadData];
}

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(updateContacts:)
             name:@"TljBkPosContactAdded" 
           object:NULL];

  [nc addObserver:self
         selector:@selector(updateContacts:)
             name:@"TljBkPosContactDeleted" 
           object:NULL];
  
  [nc addObserver:self
         selector:@selector(handleContactSearchFieldDidChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactsSearchField];
  
  [nc addObserver:self
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactsCookTextField];
  
  [nc addObserver:self
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactsDatePicker];
  
  [nc addObserver:self
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactsDatePicker];
  
  [nc addObserver:self
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactsSubjectTextField];
  
  [nc addObserver:self
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactsBodyTextView];
  
  // handle when contants change
  [nc addObserver:self
         selector:@selector(handleContactsChange:)
             name:[[Contacts sharedInstance] notificationChangeString]
           object:nil];
  
}

//******************************************************************************
// searching
//******************************************************************************

- (void)handleContactSearchFieldDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && contactsSearchField == [note object]) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *authorString, *subjectString, *bodyString, *dateString,
      *personStr, *emailStr, *phoneStr;
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setContactsArray:[[Contacts sharedInstance] arrayForDictionary]];
      previousLengthOfContactSearchString = 0;
      [contactsTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfContactSearchString > [searchString length]) {
      [self setContactsArray:[[Contacts sharedInstance] arrayForDictionary]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    NSEnumerator *e = [contactsArray objectEnumerator];
    while ( object = [e nextObject] ) {
      authorString = [[object commentAuthorName] lowercaseString];
      subjectString = [[object commentSubject] lowercaseString];
      bodyString = [[object commentText] lowercaseString];
      dateString = [[object date] descriptionWithCalendarFormat:@"%m/%d/%yy" timeZone:nil
                                                         locale:nil];
      personStr = [[object personName] lowercaseString];
      emailStr = [[object personEmail] lowercaseString];
      phoneStr = [[object personPhone] lowercaseString];
      
      NSRange authorRange = [authorString rangeOfString:searchString options:NSLiteralSearch];
      NSRange subjectRange = [subjectString rangeOfString:searchString options:NSLiteralSearch];
      NSRange bodyRange = [bodyString rangeOfString:searchString options:NSLiteralSearch];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      NSRange personRange = [personStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange emailRange = [emailStr rangeOfString:searchString options:NSLiteralSearch];
      NSRange phoneRange = [phoneStr rangeOfString:searchString options:NSLiteralSearch];
      
      if (((authorRange.length) > 0) || ((subjectRange.length) > 0) ||
          ((bodyRange.length) > 0) || ((dateRange.length) > 0) ||
          ((personRange.length) > 0) || ((emailRange.length) > 0) ||
          ((phoneRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }    
    [self setContactsArray:filteredObjects];
    [contactsTableView reloadData];
    previousLengthOfContactSearchString = [searchString length];
  }
}

//******************************************************************************
// controlling edit/save buttons
//******************************************************************************

- (NSString *)datePickerDateToString:(NSDatePicker *)dp {
  NSDate *date = [dp dateValue];
  NSCalendarDate *newCDate = 
    [NSCalendarDate dateWithString:[date description]
                    calendarFormat: @"%Y-%m-%d %H:%M:%S %z"];
  NSString *dateStr  = 
    [[newCDate descriptionWithCalendarFormat:@"%m/%d/%Y" timeZone:nil locale:nil]
      description];
  return dateStr;
}

//******************************************************************************

- (bool)date:(NSCalendarDate *)d1 equalsDate:(NSCalendarDate *)d2 {
  NSString *d1String = [[d1 descriptionWithCalendarFormat:@"%m/%d/%Y" 
                                                 timeZone:nil 
                                                   locale:nil]
    description];
  NSString *d2String = [[d2 descriptionWithCalendarFormat:@"%m/%d/%Y" 
                                                 timeZone:nil 
                                                   locale:nil]
    description];
  
  return [d1String isEqualToString:d2String];
}

//******************************************************************************

- (NSCalendarDate *)calendarDateFromDate:(NSDate *)date {
  NSCalendarDate *newCDate = 
  [NSCalendarDate dateWithString:[date description]
                  calendarFormat: @"%Y-%m-%d %H:%M:%S %z"];
  return newCDate;
}

//******************************************************************************

- (NSCalendarDate *)calendarDateFromDatePicker:(NSDatePicker *)dp {
  return [self calendarDateFromDate:[dp dateValue]];
}

//******************************************************************************

- (bool)string:(NSString *)s1 equalsString:(NSString *)s2 {
  return [s1 isEqualToString:s2];
}

//******************************************************************************

- (bool)textField:(NSTextField *)tf equalsString:(NSString *)str {
  return [self string:str equalsString:[[tf stringValue] lowercaseString]];
}

//******************************************************************************

- (bool)textView:(NSTextView *)tv equalsString:(NSString *)str {
//  //NSLog(@"tv string: %@", [tv string]);
//  //NSLog(@"str: %@", str);
  return [self string:str equalsString:[[tv string] lowercaseString]];
}

//******************************************************************************

- (void)handleContactsChange:(NSNotification *)note {
  [self setContactsArray:[[Contacts sharedInstance] arrayForDictionary]];
  [contactsTableView reloadData];
}

- (void)handleContactInfoChange:(NSNotification *)note {
  if ([[self window] isMainWindow]) {
    [self enableContactSaveButtonIfAppropriate];
  } 
}

//******************************************************************************

- (bool)contactCookAndSubjectAreNotEmpty {
  NSString *emptyString = [NSString stringWithFormat:@""];
  if ([self textField:contactsCookTextField equalsString:emptyString] ||
      [self textField:contactsSubjectTextField equalsString:emptyString]) {
    return NO;
  } else {
    return YES;
  }
}

//******************************************************************************

- (bool)contactIsDifferent {
  NSString *cook = [currentlyViewedContact commentAuthorName];
  NSString *subject = [currentlyViewedContact commentSubject];
  NSString *body = [currentlyViewedContact commentText];
  NSCalendarDate *contactDate = [currentlyViewedContact date];
  
  if ([self textField:contactsCookTextField equalsString:cook] &&
      [self textField:contactsSubjectTextField equalsString:subject] &&
      [self textView:contactsBodyTextView equalsString:body] &&
      [self date:contactDate 
      equalsDate:[self calendarDateFromDatePicker:contactsDatePicker]] &&
      [self string:[self stringForContactTypeFromMatrix] 
      equalsString:[self stringForContactTypeFromContact]]) {
    return NO;
  } else {
    return YES;
  }
}

//******************************************************************************

- (void)enableContactSaveButtonIfAppropriate {
  ////NSLog(@"contact is different: %d", [self contactIsDifferent]);
  ////NSLog(@"required fields present: %d", [self contactCookAndSubjectAreNotEmpty]);
  
  if ([self contactIsDifferent] && [self contactCookAndSubjectAreNotEmpty]) {
    [contactsSaveEditButton setEnabled:YES];
    [contactsCancelEditButton setEnabled:YES];
  } else {
    [contactsSaveEditButton setEnabled:NO];
    [contactsCancelEditButton setEnabled:NO];
  }
}

//******************************************************************************
// contacts actions
//******************************************************************************

- (IBAction) contactsDatePickerClicked:(id)sender {
  [self enableContactSaveButtonIfAppropriate];
}

//******************************************************************************

- (IBAction) contactsMessageTypeMatrixClicked:(id)sender {
  [self enableContactSaveButtonIfAppropriate];
}

//******************************************************************************

- (void)enableOrDisableContactsTab:(bool)enable {
  [contactsCookTextField setEnabled:enable];
  [contactsSubjectTextField setEnabled:enable];
  [contactsBodyTextView setEditable:enable];
  [contactsCancelEditButton setEnabled:enable];
  [contactsSaveEditButton setEnabled:enable];
  [contactsCancelEditButton setEnabled:enable];
  [contactsDatePicker setEnabled:enable];
  [contactsMessageTypeMatrix setEnabled:enable];
}
//******************************************************************************


- (IBAction) contactsCancelEditButtonClicked:(id)sender {
  
  if ([[contactsSaveEditButton title] isEqualToString:@"Add"]) {
    [self clearContactsTab];
  } else {
    [contactsSaveEditButton setEnabled:NO];
    [contactsCancelEditButton setEnabled:NO];
    
    [contactsCookTextField setStringValue:[currentlyViewedContact commentAuthorName]];
    [contactsSubjectTextField setStringValue:[currentlyViewedContact commentSubject]];
    [contactsBodyTextView setString:[currentlyViewedContact commentText]];
    [contactsDatePicker setDateValue:[currentlyViewedContact date]];
    
    if ([currentlyViewedContact leftMessage]) {
      [contactsMessageTypeMatrix setState:1 atRow:0 column:0];
    } else if ([currentlyViewedContact sentEmail]) {
      [contactsMessageTypeMatrix setState:1 atRow:1 column:0];
    } else {
      [contactsMessageTypeMatrix setState:1 atRow:2 column:0];
    }    
  }  
}

//******************************************************************************

- (NSString *)stringForContactTypeFromMatrix {
  if ([[contactsMessageTypeMatrix cellAtRow:0 column:0] state]) {
    return [NSString stringWithFormat:@"leftMessage"];
  } else if ([[contactsMessageTypeMatrix cellAtRow:1 column:0] state]) {
    return [NSString stringWithFormat:@"sentEmail"];
  } else {
    return [NSString stringWithFormat:@"spokeDirectly"];
  }
}

//******************************************************************************

- (NSString *)stringForContactTypeFromContact {
  if ([currentlyViewedContact leftMessage]) {
    return [NSString stringWithFormat:@"leftMessage"];
  } else if ([currentlyViewedContact sentEmail]) {
    return [NSString stringWithFormat:@"sentEmail"];
  } else {
    return [NSString stringWithFormat:@"spokeDirectly"];
  }
}

//******************************************************************************

- (IBAction) contactsSaveEditButtonClicked:(id)sender {
  
  NSString *cook = [[contactsCookTextField stringValue] lowercaseString];
  NSString *subject = [[contactsSubjectTextField stringValue] lowercaseString];
  NSString *body = [[contactsBodyTextView string] lowercaseString];
  NSCalendarDate *date = [self calendarDateFromDatePicker:contactsDatePicker];
  
  [currentlyViewedContact setCommentAuthorName:cook];
  [currentlyViewedContact setCommentSubject:subject];
  [currentlyViewedContact setCommentText:body];
  [currentlyViewedContact setDate:date];
  [currentlyViewedContact setLeftMessage:[contactsMessageTypeMatrix cellAtRow:0 
                                                                       column:0]];
  [currentlyViewedContact setSentEmail:[contactsMessageTypeMatrix cellAtRow:1
                                                                     column:0]];
  [currentlyViewedContact setSpokeDirectly:[contactsMessageTypeMatrix cellAtRow:2
                                                                         column:0]];
  
  if ([[contactsSaveEditButton title] isEqualToString:[NSString stringWithFormat:@"Add"]]) {
    
    [contactsArrayController insertObject:currentlyViewedContact 
                    atArrangedObjectIndex:0];
  } else {
    [[Contacts sharedInstance] saveToDisk];
  }
  
  [contactsSaveEditButton setTitle:@"Save Edit"];
  [contactsCancelEditButton setTitle:@"Cancel Edit"];
  [contactsSaveEditButton setEnabled:NO];
  [contactsCancelEditButton setEnabled:NO];
  
  
  if ([contactsSearchField acceptsFirstResponder]) {
    [[self window] makeFirstResponder:contactsSearchField];
  } 
}

//******************************************************************************

// proxy for selectButtonClicked
- (IBAction) showContactInfo:(id)sender {
  CustomerContact *selectedContact = [[contactsArrayController selectedObjects]
 objectAtIndex:0];
  [self setCurrentlyViewedContact:selectedContact];
  
  [self enableOrDisableContactsTab:YES];
  [contactsSaveEditButton setTitle:[NSString stringWithFormat:@"Save Edit"]];
  [contactsCancelEditButton setTitle:[NSString stringWithFormat:@"Cancel Edit"]];
  [contactsSaveEditButton setEnabled:NO];
  [contactsCancelEditButton setEnabled:NO];
  
  
  [contactsCookTextField setStringValue:[selectedContact commentAuthorName]];
  [contactsSubjectTextField setStringValue:[selectedContact commentSubject]];
  [contactsBodyTextView setString:[selectedContact commentText]];
  [contactsDatePicker setDateValue:[selectedContact date]];
  
  if ([selectedContact leftMessage]) {
    [contactsMessageTypeMatrix setState:1 atRow:0 column:0];
  } else if ([selectedContact sentEmail]) {
    [contactsMessageTypeMatrix setState:1 atRow:1 column:0];
  } else {
    [contactsMessageTypeMatrix setState:1 atRow:2 column:0];
  }
}

//******************************************************************************
// accessors
//******************************************************************************

- (NSWindow *)mainApplicationWindow {
  return mainApplicationWindow;
}

- (NSMutableArray *)contactsArray {
  return contactsArray;
}

- (CustomerContact *)currentlyViewedContact {
  return currentlyViewedContact;
}

- (bool)runningModal {
  return runningModal;
}

//******************************************************************************
// setters
//******************************************************************************

- (void)setMainApplicationWindow:(NSWindow *)mainWindow {
  [mainWindow retain];
  [mainApplicationWindow release];
  mainApplicationWindow = mainWindow;
}

- (void)setContactsArray:(NSMutableArray *)array {
  if (array != contactsArray) {
    NSEnumerator *e = [contactsArray objectEnumerator];
    id value;
    while (value = [e nextObject]) {
      [value release];
    }
    [contactsArray release];
    contactsArray = [[NSMutableArray alloc] initWithArray:array];
  }
}

- (void)setCurrentlyViewedContact:(CustomerContact *)contact {
  [currentlyViewedContact release];
  [contact retain];
  currentlyViewedContact = contact;
}

- (void)setRunningModal:(bool)modal {
  runningModal = modal;
}

@end
