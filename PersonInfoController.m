//
//  PersonInfoController.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/21/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PersonInfoController.h"
#import "People.h"
#import "Person.h"
#import "Projects.h"
#import "Project.h"
#import "Contacts.h"
#import "CustomerContact.h"
#import "Invoices.h"
#import "Invoice.h"
#import "Credit.h"
#import "Credits.h"
#import "MembershipInformation.h"
#import "PreferenceController.h"
#import "Membership.h"
#import "Memberships.h"

@implementation PersonInfoController

- (id) init {
  self = [super init];
  if (self != nil) {
    self = [super initWithWindowNibName:@"PersonInfo"];
    
    [self setupNotificationObservers];
    bypassDuplicatePerson = NO;
  }

  ////NSLog(@"product info panel: %@", productInfoPanel);
  return self;
  
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
  // release the arrays
  [self deallocAnArray:projectsInPersonInfoPanel];
  [self deallocAnArray:contactsInPersonInfoPanel];
  [self deallocAnArray:commentsInPersonInfoPanel];
  [self deallocAnArray:invoicesInPersonInfoPanel];
//  [self deallocAnArray:itemsForInvoiceInInfoPanel];
  [self deallocAnArray:creditsInPersonInfoPanel];
  
  [invoiceViewer release];
  [peopleController release];
  [currentlyViewedPerson release];
  
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
// windowing
//******************************************************************************

- (void)setupForNonModal {
  ////NSLog(@"in setupForNonModal");
  [personInfoTabView selectFirstTabViewItem:self];

  if ([[currentlyViewedPerson personName] isEqualToString:[NSString stringWithFormat:@""]]) {
    [infoSaveEditButton setTitle:[NSString stringWithFormat:@"Add"]];
    [infoCancelButton setTitle:[NSString stringWithFormat:@"Cancel Add"]];    
  } else {
    [infoSaveEditButton setTitle:[NSString stringWithFormat:@"Save Edit"]];
    [infoCancelButton setTitle:[NSString stringWithFormat:@"Cancel Edit"]];
  }
    
  [self setTitle];
  [self setupInfoTab];
  [self setupProjectsTab];
  [self setupContactsTab];
  [self setupInvoicesTab];
  [self setupCreditsTab];
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];
 // //NSLog(@"prepare for modal");
  [personInfoTabView selectFirstTabViewItem:self];
  

  [self setTitle];
  [self setupInfoTab];
  [self setupProjectsTab];
  [self setupContactsTab];
  [self setupInvoicesTab];
  [self setupCreditsTab];
}


//******************************************************************************

- (void)setTitle {
  //[self setCurrentlyViewedPerson:p];
  [titleTextField setStringValue:[currentlyViewedPerson personName]];
}

//******************************************************************************

- (IBAction)infoMembershipEndDateDatePicker:(id)sender {
  [self enableInfoEditButtonsIfAppropriate];
}

- (void)setupInfoTab {
  ////NSLog(@"currently selected person: %@", currentlyViewedPerson);
  [infoSaveEditButton setEnabled:NO];
  [infoCancelButton setEnabled:NO];
  [infoNameTextField setStringValue:[currentlyViewedPerson personName]];
  [infoPhoneTextField setStringValue:[currentlyViewedPerson phoneNumber]];
  [infoEmailTextField setStringValue:[currentlyViewedPerson emailAddress]];
  // only running modal?
  if (runningModal) {
    [infoMembershipEndDateDatePicker setHidden:YES];
    [infoMembershipEndDateDatePicker setEnabled:NO];
    [infoMembershipEndTextField setHidden:NO];
    [infoMembershipEndTextField setStringValue:[[currentlyViewedPerson membershipEndDate] 
      descriptionWithCalendarFormat:@"%m/%d/%Y"]];
    [infoMemberTypeTextField setHidden:NO];
    [infoMemberTypeComboBox setHidden:YES];
    [infoMemberTypeTextField setStringValue:[currentlyViewedPerson memberType]];
    [infoAcceptCheckButton setEnabled:NO];
    [infoSignedWaiverButton setEnabled: NO];    
  } else {
    [infoMembershipEndDateDatePicker setHidden:NO];
    [infoMembershipEndDateDatePicker setEnabled:YES];
    [infoMembershipEndDateDatePicker setDateValue:[currentlyViewedPerson membershipEndDate]];
    [infoMembershipEndDateDatePicker setMinDate:[NSCalendarDate calendarDate]];
    [infoMembershipEndTextField setHidden:YES];
    [infoMemberTypeTextField setHidden:YES];
    [infoMemberTypeComboBox setHidden:NO];
    [infoMemberTypeComboBox setStringValue:[currentlyViewedPerson memberType]];
    [infoAcceptCheckButton setEnabled:YES];
    [infoSignedWaiverButton setEnabled:YES];
  }

  [infoBalanceTextField setDoubleValue:[currentlyViewedPerson personBalance]];
  [infoAcceptCheckButton setState:[currentlyViewedPerson willTakeCheckFrom]];
  [infoSignedWaiverButton setState:[currentlyViewedPerson hasSignedLiabilityWavier]];
  
  ////NSLog(@"infoNameTextField stringValue: %@", [infoNameTextField stringValue]);
}

//******************************************************************************

- (void)setupProjectsTab {
  ////NSLog(@"In setup projects tab");
  [self setProjectsInPersonInfo:[[Projects sharedInstance] objectsForUids:[currentlyViewedPerson projectUids]]];
  ////NSLog(@"projects for person: %@", projectsInPersonInfoPanel);
  // my guess is that i have to do this because I have not defined
  // insert and remove methods.  if i don't do this, the content is set only
  // once.
  //[projectsControllerInPersonInfoPanel setContent:projectsInPersonInfoPanel];
  [projectTableView setTarget:self];
  [projectTableView setDoubleAction:@selector(handleProjectClicked:)];
  ////NSLog(@"projects for person: %@", projectsInPersonInfoPanel);
  ////NSLog(@"projects: %@",[[Projects sharedInstance] projectsInSingleton]);
}

//******************************************************************************

- (void)setupContactsTab {
  [self setContactsInPersonInfoPanel:[[Contacts sharedInstance] objectsForUids:[currentlyViewedPerson contactUids]]];
  [contactsTableView setTarget:self];
  [contactsTableView setDoubleAction:@selector(displayContactInfo:)];
  [contactDatePicker setDateValue:[NSCalendarDate calendarDate]];
}


- (IBAction)displayContactInfo:(id)sender {
  CustomerContact *selectedContact = [[contactsControllerInPersonInfoPanel selectedObjects] objectAtIndex:0];
  [self setCurrentlyViewedContact:selectedContact];
  
  [contactCookTextField setEnabled:YES];
  [contactDatePicker setEnabled:YES];
  [contactSubjectTextField setEnabled:YES];
  [contactBodyTextView setEditable:YES];
  [contactTypeMatrix setHidden:NO];
  [contactSaveButton setTitle:[NSString stringWithFormat:@"Save Edit"]];
  [contactCancelButton setTitle:[NSString stringWithFormat:@"Cancel Edit"]];
  [contactSaveButton setEnabled:NO];
  [contactCancelButton setEnabled:NO];
  
  
  [contactCookTextField setStringValue:[selectedContact commentAuthorName]];
  [contactSubjectTextField setStringValue:[selectedContact commentSubject]];
  [contactBodyTextView setString:[selectedContact commentText]];
  [contactDatePicker setDateValue:[selectedContact date]];

  if ([selectedContact leftMessage]) {
    [contactTypeMatrix setState:1 atRow:0 column:0];
  } else if ([selectedContact sentEmail]) {
    [contactTypeMatrix setState:1 atRow:1 column:0];
  } else {
    [contactTypeMatrix setState:1 atRow:2 column:0];
  }
}



- (void)insertObject:(CustomerContact *)c inContactsInPersonInfoPanelAtIndex:(int)index {
  ////NSLog(@"in insert contact: %@", c);
  //Add the inverse of this operaton to the undo stack
  NSUndoManager *undo = [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self]
    removeObjectFromContactsInPersonInfoPanelAtIndex:index];
  if (![undo isUndoing]) {
    [undo setActionName:@"Add Contact"];
  }
  

  [[currentlyViewedPerson contactUids] addObject:[c uid]];
  [[People sharedInstance] saveToDisk];
  [[Contacts sharedInstance] setObject:c forUid:[c uid]];

}


//******************************************************************************

- (void) removeObjectFromContactsInPersonInfoPanelAtIndex:(int)index {
  CustomerContact *c = [contactsInPersonInfoPanel objectAtIndex:index];
  // Add the inverse of this operation to the undo stack
  
  NSUndoManager *undo =  [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self] insertObject:c
                     inContactsInPersonInfoPanelAtIndex:index];
  
  if (![undo isUndoing]) {
    [undo setActionName:@"Delete Contact"];
  }
  
  [[currentlyViewedPerson contactUids] removeObject:[c uid]];
  [[People sharedInstance] saveToDisk];
  [[Contacts sharedInstance] removeObjectForUid:[c uid]];
}

//******************************************************************************

- (void)setupCommentsTab {
//  NSArray *comments = [[Comments sharedInstanc] objectsForUids:[currentlyViewedPerson commentUids]];
//  [self setCommentsInPersonInfoPanel:comments];
}

//******************************************************************************

- (void)setupInvoicesTab {
  [self setInvoicesInPersonInfoPanel:[[Invoices sharedInstance] objectsForUids:[currentlyViewedPerson invoiceUids]]];
  [invoicesTableView setTarget:self];
  [invoicesTableView setDoubleAction:@selector(handleInvoiceClicked:)];
}

- (void)handleInvoiceClicked:(id)sender {
  Invoice *inv;
  inv = [[invoicesControllerInPersonInfoPanel selectedObjects] objectAtIndex:0];
  if (inv != nil) {
    if (invoiceViewer == nil) {
      invoiceViewer = [[ViewInvoice alloc] init];
    }
    [invoiceViewer setCurrentlyViewedInvoice:inv];
    [invoiceViewer setupForModal];
    [invoiceViewer runModalWithParent:[self window]];
  }
}

//******************************************************************************

- (void)setupCreditsTab {
  [self setCreditsInPersonInfoPanel:[[Credits sharedInstance] 
objectsForUids:[currentlyViewedPerson creditUids]]];
  [creditsTotalCreditsTextField setDoubleValue:[currentlyViewedPerson creditAvailable]];
  [self enableCreditsSaveButtonIfAppropriate];
  [self makeTextFieldUneditable:creditsCookTextField];
  [self makeTextFieldUneditable:creditsCommentTextField];
  [self makeTextFieldUneditable:creditsAmountTextField];
  [creditsBodyTextView setEditable:NO];

  [creditsDatePicker setDateValue:[NSCalendarDate calendarDate]];
  [creditsDatePicker setEnabled:NO];
  
  [creditsTableView setTarget:self];
  [creditsTableView setDoubleAction:@selector(handleCreditClicked:)];
}

- (void)handleCreditClicked:(id)sender {
  Credit *cr;
  cr = [[creditsControllerInPersonInfoPanel selectedObjects] objectAtIndex:0];
  if (cr != nil) {
    [creditsCookTextField setStringValue:[cr commentAuthorName]];
    [creditsCommentTextField setStringValue:[cr commentSubject]];
    [creditsAmountTextField setDoubleValue:[cr creditAmount]];
    [creditsBodyTextView setString:[cr commentText]];
    [creditsDatePicker setDateValue:[cr date]];
  }
}



//******************************************************************************
// actions
//******************************************************************************

- (IBAction)closePanelButtonClicked:(id)sender {
  //NSString *emptyString = [NSString stringWithFormat:@""];

  // do this now, otherwise we'll be observing while the window is not active
  [self stopObservingPerson:currentlyViewedPerson];
  
  
  // contacts
  NSString *emptyString = [NSString stringWithFormat:@""];
  [contactCookTextField setStringValue:emptyString];
  [contactSubjectTextField setStringValue:emptyString];
  [contactBodyTextView setString:emptyString];
  [contactDatePicker setDateValue:(NSDate *)[NSCalendarDate calendarDate]];
  
  
  [contactSaveButton setTitle:[NSString stringWithFormat:@"Save Edit"]];
  [contactCancelButton setTitle:[NSString stringWithFormat:@"Cancel Edit"]];
  [contactSaveButton setEnabled:NO];
  [contactCancelButton setEnabled:NO];
  [contactsNewButton setEnabled:YES];
  
  [contactsSearchField setStringValue:emptyString];
  
  [NSApp stopModal];
  [[self window] close];
}

//******************************************************************************

- (IBAction)infoCancelButtonClicked:(id)sender {
  ////NSLog(@"infoCancelButtonClicked");
  [self setupInfoTab];
  [self setTitle];
}

//******************************************************************************

- (IBAction)infoSaveEditButtonClicked:(id)sender {
  ////NSLog(@"infoSavedEditButtonClicked");
  
  NSString *newName = [[infoNameTextField stringValue] lowercaseString];
  NSString *newPhone = [[infoPhoneTextField stringValue] lowercaseString];
  //NSString *newEmail = [[infoEmailTextField stringValue] lowercaseString];
  
  bool badPerson, badPhone, badEmail;
  
  if (![newName isEqualToString:[currentlyViewedPerson personName]]) {
    badPerson = [[People sharedInstance] personNameAppearsInPeopleInSingleton:currentlyViewedPerson];
    ////NSLog(@"bad person: %d", badPerson);
    
  } else {
    badPerson = NO;
  }

  if (![newPhone isEqualToString:[currentlyViewedPerson phoneNumber]]) {
    badPhone = [[People sharedInstance] phoneNumberIsBadlyFormatted:newPhone];
  } else {
    badPhone = NO;
  }
    
  if (![newPhone isEqualToString:[currentlyViewedPerson emailAddress]]) {
    badEmail = [[People sharedInstance] emailAddressAppearsInPeopleInSingleton:currentlyViewedPerson];
  } else {
    badEmail = NO;
  }
  
  ////NSLog(@"bad person: %d !bypassDuplicatePerson: %d", badPerson, !bypassDuplicatePerson);
  if (badPerson && (!bypassDuplicatePerson)) {
    [self runBadNameWithName:newName andBadPhone:badPhone andBadEmail:badEmail];
  } else if (badPhone) {
    [self runBadPhone];
  } else if (badEmail) {
    [self runBadEmail];
  } else {
    [self runEditPerson];
  }
}

//******************************************************************************

- (void)runBadNameWithName:(NSString *)name andBadPhone:(bool)badPhone andBadEmail:(bool)badEmail {
  ////NSLog(@"in bad person");
  NSString *message = 
    [NSString stringWithFormat:@"Person with name %@ already exists.",name];
  NSString *duplicatePeopleString =
    [[People sharedInstance] alertMessageForDuplicatePersonsInCustomerAdd:currentlyViewedPerson];
  message = [message stringByAppendingString:[NSString stringWithFormat:@"\n%@", duplicatePeopleString]];
  int choice = NSRunAlertPanel(@"Duplicate Name", message, @"Try Again", @"Continue Add",@"Cancel");
  
  // try again = 1, cancel = -1, continue add = 0
  if (choice == 1) {
    [NSApp stopModal];
    // rerun create customer
    [self runModalWithParent:mainApplicationWindow];
  } else if (choice == 0) {
    bypassDuplicatePerson = YES;
    if (badPhone) {
      [self runBadPhone];
    } else if (badEmail) {
      [self runBadEmail];
    } else {
      [self runEditPerson];
    }
  }
}

//******************************************************************************

- (void)runBadPhone {
  NSString *newPhone = [[infoPhoneTextField stringValue] lowercaseString];
  NSString *message = [NSString stringWithFormat:@"Phone number %@ is badly formatted", newPhone];
  int choice = NSRunAlertPanel(@"Bad Phone Number", message, @"Try Again", @"Cancel", nil);
  if (choice == 1) {
    if ([infoPhoneTextField acceptsFirstResponder]) {
      [[self window] makeFirstResponder:infoPhoneTextField];
    } 
    [NSApp stopModal];
    // rerun create customer
    [self runModalWithParent:mainApplicationWindow];
  }
}

//******************************************************************************

- (void)runBadEmail {
  NSString *newEmail = [[infoEmailTextField stringValue] lowercaseString];
  NSString *message = 
    [NSString stringWithFormat:@"Person with email %@ already exists.", newEmail];
  int choice = NSRunAlertPanel(@"Duplicate Email Address", message, @"Try Again", @"Cancel", nil);
  
  if (choice == 1) {
    if ([infoEmailTextField acceptsFirstResponder]) {
      [[self window] makeFirstResponder:infoEmailTextField];
    } 
    [NSApp stopModal];
    // rerun create customer
    [self runModalWithParent:mainApplicationWindow];
  } 
}

//******************************************************************************

- (void)runEditPerson {
  [currentlyViewedPerson setPersonName:[[infoNameTextField stringValue] lowercaseString]];
  [currentlyViewedPerson setPhoneNumber:[[infoPhoneTextField stringValue] lowercaseString]];
  [currentlyViewedPerson setEmailAddress:[infoEmailTextField stringValue]];
  NSString *type = [self stringFromComboBox:infoMemberTypeComboBox];
  NSCalendarDate *endDate = [self calendarDateFromDatePicker:infoMembershipEndDateDatePicker];
  
  // accept check
  bool willTake;
  if ([infoAcceptCheckButton state] == 1) {
    willTake = YES;
  } else {
    willTake = NO;
  }
  [currentlyViewedPerson setWillTakeCheckFrom:willTake];
  
  bool hasSigned;
  if ([infoSignedWaiverButton state] == 1) {
    hasSigned = YES;
  } else {
    hasSigned = NO;
  }
  
  [currentlyViewedPerson setHasSignedLiabilityWaiver:hasSigned];
  
  //NSLog(@"type: %@", type);
  Membership *mem = [currentlyViewedPerson membership];
  [mem setMembershipType:type];
  [mem setEndDate:endDate];
  //NSLog(@"mem = %@", mem);
  [[Memberships sharedInstance] saveToDisk];
  //NSLog(@"memberships: %@", [[Memberships sharedInstance] dictionary]);
  
  if ([[infoSaveEditButton title] isEqualToString:[NSString stringWithFormat:@"Add"]]) {
    
    [peopleController insertObject:currentlyViewedPerson atArrangedObjectIndex:0];
    ////NSLog(@"peopleController: %@", peopleController);
    //[ac insertObject:currentlyViewedPerson atArrangedObjectIndex:0];
    [infoSaveEditButton setTitle:[NSString stringWithFormat:@"Save Edit"]];
    [infoCancelButton setTitle:[NSString stringWithFormat:@"Cancel Edit"]];
  } else {
   // //NSLog(@"button title: %@", [infoSaveEditButton title]);
    // save to disk
    [[People sharedInstance] saveToDisk];
  }
  [infoSaveEditButton setEnabled:NO];
  [infoCancelButton setEnabled:NO];
  bypassDuplicatePerson = NO;  
  ////NSLog(@"Person: %@", currentlyViewedPerson);
}


//******************************************************************************

//- (IBAction)infoEditMembershipEndDateButtonClicked:(id)sender {
//  ////NSLog(@"edit membership end date button clicked");
//  
//  if ([infoMembershipEndDateDatePicker isHidden]) {
//    NSString *memberType = [infoMemberTypeComboBox objectValueOfSelectedItem];
//    if (memberType == nil) memberType = [infoMemberTypeComboBox stringValue];
//    
//    if (([memberType isEqualToString:[NSString stringWithFormat:@"cook"]]) ||
//        ([memberType isEqualToString:[NSString stringWithFormat:@"lifetime"]])) {
//      NSCalendarDate *endDate = [self membershipEndDateForMemberType:memberType];
//      NSString *datestr = [[infoMembershipEndTextField formatter] stringFromDate:endDate];
//      [infoMembershipEndTextField setStringValue:datestr];
//      [self enableInfoEditButtonsIfAppropriate];
//    } else {
//      [infoMembershipEndDateDatePicker setHidden:NO];
//      [infoEditMembershipEndDateButton setTitle:[NSString stringWithFormat:@"Select"]];
//      [infoEditMembershipEndDateButton setKeyEquivalent:[NSString stringWithFormat:@"\r"]];
//    }
//  } else {
//    [infoMembershipEndDateDatePicker setHidden:YES];
//    
//    NSDate *newDate = [infoMembershipEndDateDatePicker dateValue];
//    NSString *datestr = [[infoMembershipEndTextField formatter] stringFromDate:newDate];
//    [infoMembershipEndTextField setStringValue:datestr];
//    
//    [infoEditMembershipEndDateButton setTitle:[NSString stringWithFormat:@"Edit"]];
//    [infoEditMembershipEndDateButton setKeyEquivalent:[NSString stringWithFormat:@""]];
//    
//    [self enableInfoEditButtonsIfAppropriate];
//  }
//}

- (IBAction)infoAcceptCheckButtonClicked:(id)sender {
  [self enableInfoEditButtonsIfAppropriate];
}

- (IBAction)infoSignedWaiverButtonClicked:(id)sender {
  [self enableInfoEditButtonsIfAppropriate];
}

//******************************************************************************

- (IBAction)contactDeleteButtonClicked:(id)sender {
  ////NSLog(@"contactDeleteButtonClicked");
  CustomerContact *selectedContact = [[contactsControllerInPersonInfoPanel
    selectedObjects] objectAtIndex:0];
  [contactsControllerInPersonInfoPanel removeObject:selectedContact];
}

//******************************************************************************

- (IBAction)contactNewButtonClicked:(id)sender {
  ////NSLog(@"contactNewButtonClicked");
  
  [contactCookTextField setEnabled:YES];
  [contactDatePicker setEnabled:YES];
  [contactSubjectTextField setEnabled:YES];
  [contactBodyTextView setEditable:YES];
  [contactTypeMatrix setHidden:NO];
  [contactsNewButton setEnabled:NO];
  [contactCancelButton setEnabled:NO];
  [contactSaveButton setTitle:[NSString stringWithFormat:@"Add"]];
  [contactCancelButton setTitle:[NSString stringWithFormat:@"Cancel Add"]];
  
  
  NSString *emptyString = [NSString stringWithFormat:@""];
  [contactCookTextField setStringValue:emptyString];
  [contactSubjectTextField setStringValue:emptyString];
  [contactBodyTextView setString:emptyString];
  [contactDatePicker setDateValue:(NSDate *)[NSCalendarDate calendarDate]];
  
  if ([contactCookTextField acceptsFirstResponder]) {
    [[self window] makeFirstResponder:contactCookTextField];
  }
  CustomerContact *newContact = [[CustomerContact alloc] init];
  [newContact setPersonUid:[currentlyViewedPerson uid]];
  
  [self setCurrentlyViewedContact:newContact];
  
}

- (IBAction)contactCancelButtonClicked:(id)sender {
  if ([[contactSaveButton title] isEqualToString:[NSString stringWithFormat:@"Add"]]) {
    [contactCookTextField setEnabled:NO];
    [contactDatePicker setEnabled:NO];
    [contactSubjectTextField setEnabled:NO];
    [contactBodyTextView setEditable:NO];
    [contactTypeMatrix setHidden:YES];
    [contactsNewButton setEnabled:NO];
    [contactSaveButton setEnabled:NO];
    [contactSaveButton setTitle:[NSString stringWithFormat:@"Save Edit"]];
    [contactCancelButton setTitle:[NSString stringWithFormat:@"Cancel Edit"]];
  } else {
    [contactCookTextField setEnabled:YES];
    [contactDatePicker setEnabled:YES];
    [contactSubjectTextField setEnabled:YES];
    [contactBodyTextView setEditable:YES];
    [contactTypeMatrix setHidden:NO];
    [contactSaveButton setTitle:[NSString stringWithFormat:@"Save Edit"]];
    [contactCancelButton setTitle:[NSString stringWithFormat:@"Cancel Edit"]];
    [contactSaveButton setEnabled:NO];
    [contactCancelButton setEnabled:NO];
    
    
    [contactCookTextField setStringValue:[currentlyViewedContact commentAuthorName]];
    [contactSubjectTextField setStringValue:[currentlyViewedContact commentSubject]];
    [contactBodyTextView setString:[currentlyViewedContact commentText]];
    [contactDatePicker setDateValue:[currentlyViewedContact date]];
    
    if ([currentlyViewedContact leftMessage]) {
      [contactTypeMatrix setState:1 atRow:0 column:0];
    } else if ([currentlyViewedContact sentEmail]) {
      [contactTypeMatrix setState:1 atRow:1 column:0];
    } else {
      [contactTypeMatrix setState:1 atRow:2 column:0];
    }    
  }
}

//******************************************************************************

- (IBAction)contactDatePickerClicked:(id)sender {
  ////NSLog(@"contact date picker clicked");
  [self enableContactSaveButtonIfAppropriate];
}

//******************************************************************************

- (IBAction)contactSaveButtonClicked:(id)sender {
  NSString *cook = [[contactCookTextField stringValue] lowercaseString];
  NSString *subject = [[contactSubjectTextField stringValue] lowercaseString];
  NSString *body = [[contactBodyTextView string] lowercaseString];
  NSDate *date = [contactDatePicker dateValue];
  NSString *newType = [self stringForContactTypeFromMatrix];
  NSString *emptyString = [NSString stringWithFormat:@""];
  
  [currentlyViewedContact setCommentAuthorName:cook];
  [currentlyViewedContact setCommentSubject:subject];
  [currentlyViewedContact setCommentText:body];
  [currentlyViewedContact setDate:[date dateWithCalendarFormat:@"%m/%d/%Y" timeZone:nil]];
  if ([newType isEqualToString:[NSString stringWithFormat:@"leftMessage"]]) {
    [contactTypeMatrix setState:1 atRow:0 column:0];
  } else if ([newType isEqualToString:[NSString stringWithFormat:@"sentEmail"]]) {
    [contactTypeMatrix setState:1 atRow:1 column:0];
  } else {
    [contactTypeMatrix setState:1 atRow:2 column:0];
  }

  if ([[contactSaveButton title] isEqualToString:[NSString stringWithFormat:@"Add"]]) {
  //  [self insertObject:currentlyViewedContact inContactsInPersonInfoPanelAtIndex:0];
    
    [contactsControllerInPersonInfoPanel insertObject:currentlyViewedContact 
                                atArrangedObjectIndex:0];
  } else {
    [[Contacts sharedInstance] saveToDisk];
  }
  
  [contactSaveButton setTitle:[NSString stringWithFormat:@"Save Edit"]];
  [contactCancelButton setTitle:[NSString stringWithFormat:@"Cancel Edit"]];
  [contactSaveButton setEnabled:NO];
  [contactCancelButton setEnabled:NO];
  [contactsNewButton setEnabled:YES];
  [contactCookTextField setStringValue:emptyString];
  [contactSubjectTextField setStringValue:emptyString];
  [contactBodyTextView setString:emptyString];
  if ([contactsSearchField acceptsFirstResponder]) {
    [[self window] makeFirstResponder:contactsSearchField];
  } 
  [contactTypeMatrix setState:0 atRow:0 column:0];
  [contactTypeMatrix setState:0 atRow:1 column:0];
  [contactTypeMatrix setState:0 atRow:2 column:0];
}

//******************************************************************************

- (IBAction)commentDeleteButtonClicked:(id)sender {
 // //NSLog(@"commentDeleteButtonClicked");
}

//******************************************************************************

- (IBAction)commentNewButtonClicked:(id)sender {
 // //NSLog(@"commentNewButtonClicked");
}

//******************************************************************************

- (IBAction)commentSaveButtonClicked:(id)sender {
 // //NSLog(@"commentSaveButtonClicked");
}

//******************************************************************************

- (IBAction)creditsDeleteButtonClicked:(id)sender {
 // //NSLog(@"creditsDeleteButtonClicked");
  Credit *cr;
  cr = [[creditsControllerInPersonInfoPanel selectedObjects] objectAtIndex:0];
  if (cr != nil) {
    [[Credits sharedInstance] removeObjectForUid:[cr uid]];
    [currentlyViewedPerson removeObjectWithUid:[cr uid] fromArrayOfUids:[currentlyViewedPerson creditUids]];
        
    [[People sharedInstance] saveToDisk];
    
    // clear the credits fields
    [self clearTextField:creditsCookTextField];
    [self clearTextField:creditsCommentTextField];
    [self clearTextField:creditsAmountTextField];
    [self makeTextFieldUneditable:creditsCookTextField];
    [self makeTextFieldUneditable:creditsCommentTextField];
    [self makeTextFieldUneditable:creditsAmountTextField];
    
    // update the total
    [creditsTotalCreditsTextField setDoubleValue:[currentlyViewedPerson creditAvailable]];
    [self enableCreditsSaveButtonIfAppropriate];
  }
}

//******************************************************************************

- (IBAction)creditsNewButtonClicked:(id)sender {
 // //NSLog(@"creditsNewButtonClicked");
  if ([creditsCookTextField acceptsFirstResponder]) {
    [[self window] makeFirstResponder:creditsCookTextField];
  }
  [self makeTextFieldEditable:creditsCookTextField];
  [self makeTextFieldEditable:creditsCommentTextField];
  [self makeTextFieldEditable:creditsAmountTextField];
  [creditsBodyTextView setEditable:YES];
  [creditsDatePicker setEnabled:YES];
}

//******************************************************************************

- (IBAction)creditsSaveButtonClicked:(id)sender {
 // //NSLog(@"creditsSaveButtonClicked");
  Credit *cr = [[Credit alloc] init];
  [cr setDate:[self calendarDateFromDatePicker:creditsDatePicker]];
  [cr setCommentAuthorName:[creditsCookTextField stringValue]];
  [cr setCommentSubject:[creditsCommentTextField stringValue]];
  [cr setCommentText:[creditsBodyTextView string]];
  [cr setCreditAmount:[creditsAmountTextField doubleValue]];
  [cr setOwnerUid:[currentlyViewedPerson uid]];
  [cr setHasBeenUsed:NO];
  [[currentlyViewedPerson creditUids] addObject:[cr uid]];
  [[People sharedInstance] saveToDisk];
  [[Credits sharedInstance] setObject:cr forUid:[cr uid]];
  
  // clear the credits fields
  [self clearTextField:creditsCookTextField];
  [self clearTextField:creditsCommentTextField];
  [self clearTextField:creditsAmountTextField];
  [self clearTextView:creditsBodyTextView];
  [self makeTextFieldUneditable:creditsCookTextField];
  [self makeTextFieldUneditable:creditsCommentTextField];
  [self makeTextFieldUneditable:creditsAmountTextField];
  
  // update the total
  [creditsTotalCreditsTextField setDoubleValue:[currentlyViewedPerson creditAvailable]];
  [self enableCreditsSaveButtonIfAppropriate];
    
}


//******************************************************************************
// accessor
//******************************************************************************

- (NSWindow *)mainApplicationWindow {
  return mainApplicationWindow;
}

- (NSArrayController *)peopleController {
  return peopleController;
}

- (NSMutableArray *)projectsInPersonInfoPanel {
  return projectsInPersonInfoPanel;
}

- (NSMutableArray *)contactsInPersonInfoPanel {
  return contactsInPersonInfoPanel;
}

- (NSMutableArray *)commentsInPersonInfoPanel {
  return commentsInPersonInfoPanel;
}

- (NSMutableArray *)invoicesInPersonInfoPanel {
  return invoicesInPersonInfoPanel;
}

//- (NSMutableArray *)itemsForInvoiceInInfoPanel {
//  return itemsForInvoiceInInfoPanel;
//}

- (NSMutableArray *)creditsInPersonInfoPanel {
  return creditsInPersonInfoPanel;
}

- (Person *)currentlyViewedPerson {
  return currentlyViewedPerson;
}

- (CustomerContact *)currentlyViewedContact {
  return currentlyViewedContact;
}


//******************************************************************************
// setters
//******************************************************************************

- (void)setMainApplicationWindow:(NSWindow *)w {
  [w retain];
  [mainApplicationWindow release];
  mainApplicationWindow = w;
}


- (void)setPeopleController:(NSArrayController *)pc {
  [pc retain];
  [peopleController release];
  peopleController = pc;
}

- (void)setProjectsInPersonInfo:(NSMutableArray *)pc {
  if (pc != projectsInPersonInfoPanel) {
    NSEnumerator *e = [projectsInPersonInfoPanel objectEnumerator];
    id value;
    while (value = [e nextObject]) {
     // //NSLog(@"value: %@", value);
      [value release];
    }
    [projectsInPersonInfoPanel release];
    projectsInPersonInfoPanel = [[NSMutableArray alloc] initWithArray:pc];
  }
}

- (void)setContactsInPersonInfoPanel:(NSMutableArray *)cp {
  if (cp != contactsInPersonInfoPanel) {
    NSEnumerator *e = [contactsInPersonInfoPanel objectEnumerator];
    id value;
    while (value = [e nextObject]) {
      [value release];
    }
    [contactsInPersonInfoPanel release];
    contactsInPersonInfoPanel = [[NSMutableArray alloc] initWithArray:cp];
  }
}

- (void)setCommentsInPersonInfoPanel:(NSMutableArray *)cp {
  if (cp != commentsInPersonInfoPanel) {
    NSEnumerator *e = [commentsInPersonInfoPanel objectEnumerator];
    id value;
    while (value = [e nextObject]) {
      [value release];
    }
    [commentsInPersonInfoPanel release];
    commentsInPersonInfoPanel = [[NSMutableArray alloc] initWithArray:cp];
  }
}

- (void)setInvoicesInPersonInfoPanel:(NSMutableArray *)ip {
  if (ip != invoicesInPersonInfoPanel) {
    NSEnumerator *e = [invoicesInPersonInfoPanel objectEnumerator];
    id value;
    while (value = [e nextObject]) {
      [value release];
    }
    [invoicesInPersonInfoPanel release];
    invoicesInPersonInfoPanel = [[NSMutableArray alloc] initWithArray:ip];
  }  
}

//- (void)setItemsForInvoiceInInfoPanel:(NSMutableArray *)ip {
//  if (ip != itemsForInvoiceInInfoPanel) {
//    NSEnumerator *e = [itemsForInvoiceInInfoPanel objectEnumerator];
//    id value;
//    while (value = [e nextObject]) {
//      [value release];
//    }
//    [itemsForInvoiceInInfoPanel release];
//    itemsForInvoiceInInfoPanel = [[NSMutableArray alloc] initWithArray:ip];
//  }    
//}

- (void)setCreditsInPersonInfoPanel:(NSMutableArray *)cp {
  if (cp != creditsInPersonInfoPanel) {
    NSEnumerator *e = [creditsInPersonInfoPanel objectEnumerator];
    id value;
    while (value = [e nextObject]) {
      [value release];
    }
    [creditsInPersonInfoPanel release];
    creditsInPersonInfoPanel = [[NSMutableArray alloc] initWithArray:cp];
  }
}

- (void)setCurrentlyViewedPerson:(Person *)p {
  [p retain];
  [currentlyViewedPerson release];
  currentlyViewedPerson = p;
  [self startObservingPerson:currentlyViewedPerson];
}

- (void)setCurrentlyViewedContact:(CustomerContact *)contact {
  [contact retain];
  [currentlyViewedContact release];
  currentlyViewedContact = contact;
}


//******************************************************************************
// setting up notifications
//******************************************************************************

- (void)textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    if ([note object] == contactBodyTextView) {
      [self enableContactSaveButtonIfAppropriate];
    }
  }
}

//******************************************************************************

- (void)setupNotificationObservers {
  
  // NSComboBoxSelectionDidChangeNotification
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  // information  
  [nc addObserver:self 
         selector:@selector(handlePersonInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:infoNameTextField];
  
  [nc addObserver:self 
         selector:@selector(handlePersonInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:infoPhoneTextField];
  
  [nc addObserver:self 
         selector:@selector(handlePersonInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:infoEmailTextField];
  
  [nc addObserver:self 
         selector:@selector(handlePersonInfoChange:)
             name:@"NSComboBoxSelectionDidChangeNotification"
           object:infoMemberTypeComboBox];
  
  
  // projects
  [nc addObserver:self 
         selector:@selector(handleProjectSearchFieldChange:)
             name:@"NSControlTextDidChangeNotification"
           object:projectSearchField];
  

  [nc addObserver:self 
         selector:@selector(handleProjectsChange:)
             name:[[Projects sharedInstance] notificationChangeString]
           object:nil];
  
  
  // contacts
  [nc addObserver:self 
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactCookTextField];
  
  [nc addObserver:self 
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactSubjectTextField];
  
  [nc addObserver:self 
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactDatePicker];
  
  [nc addObserver:self 
         selector:@selector(handleContactInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactTypeMatrix];
    
  [nc addObserver:self 
         selector:@selector(handleContactInfoChange:)
             name:@"NSTextDidEndEditingNotification"
           object:contactBodyTextView];

  [nc addObserver:self 
         selector:@selector(handleContactSearchFieldChange:)
             name:@"NSControlTextDidChangeNotification"
           object:contactsSearchField];
  
  [nc addObserver:self 
         selector:@selector(handleContactsChange:)
             name:[[Contacts sharedInstance] notificationChangeString]
           object:nil];
  
  
  // handling contact changes
  [nc addObserver:self 
         selector:@selector(handleContactsChange:)
             name:[[Contacts sharedInstance] notificationChangeString]
           object:nil];
  
  
  
  // comments
//  [nc addObserver:self 
//         selector:@selector(handleCommentSearchFieldChange:)
//             name:@"NSControlTextDidChangeNotification"
//           object:commentSearchField];
//  
//  [nc addObserver:self 
//         selector:@selector(handleCommentInfoChange:)
//             name:@"NSControlTextDidChangeNotification"
//           object:commentCookTextField];
//  
//  [nc addObserver:self 
//         selector:@selector(handleCommentInfoChange:)
//             name:@"NSControlTextDidChangeNotification"
//           object:commentSubjectTextField];
//  
//  [nc addObserver:self 
//         selector:@selector(handleCommentInfoChange:)
//             name:@"NSControlTextDidChangeNotification"
//           object:commentTextView];
//  
//  [nc addObserver:self 
//         selector:@selector(handleCommentInfoChange:)
//             name:@"NSControlTextDidChangeNotification"
//           object:commentDatePicker];
  
  // invoices
//  [nc addObserver:self 
//         selector:@selector(handleInvoiceSearchFieldChange:)
//             name:@"NSControlTextDidChangeNotification"
//           object:invoicesSearchField];
  
  // credits
  [nc addObserver:self 
         selector:@selector(handleCreditInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:creditsCookTextField];
  
  [nc addObserver:self 
         selector:@selector(handleCreditInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:creditsCommentTextField];
  
  [nc addObserver:self 
         selector:@selector(handleCreditInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:creditsAmountTextField];
  
  [nc addObserver:self 
         selector:@selector(handleCreditInfoChange:)
             name:@"NSControlTextDidChangeNotification"
           object:creditsDatePicker];
  
  [nc addObserver:self 
         selector:@selector(handleCreditSearchFieldChange:)
             name:@"NSControlTextDidChangeNotification"
           object:creditsSearchField];
  
  [nc addObserver:self 
         selector:@selector(handleCreditsChange:)
             name:[[Credits sharedInstance] notificationChangeString]
           object:nil];
  
  
}  

- (void)handleContactsChange:(NSNotification *)note {
  NSArray *array = [[Contacts sharedInstance] objectsForUids:[currentlyViewedPerson contactUids]];
  [self setContactsInPersonInfoPanel:[[NSMutableArray alloc] initWithArray:array]];
  [contactsTableView reloadData];
}

- (void)handleInvoicesChange:(NSNotification *)note {
  NSArray *array = [[Invoices sharedInstance] objectsForUids:[currentlyViewedPerson invoiceUids]];
  [self setInvoicesInPersonInfoPanel:[[NSMutableArray alloc] initWithArray:array]];
  [invoicesTableView reloadData];
}

- (void)handleProjectsChange:(NSNotification *)note {
  NSArray *array = [[Projects sharedInstance] objectsForUids:[currentlyViewedPerson projectUids]];
  [self setProjectsInPersonInfo:[[NSMutableArray alloc] initWithArray:array]];
  [projectTableView reloadData];
}

- (void)handleProjectClicked:(id)sender {
  Project *p;
  p = [[projectsControllerInPersonInfoPanel selectedObjects] objectAtIndex:0];
  if (projectInformationController == nil) {
    ProjectInformationController *pic;
    pic = [[ProjectInformationController alloc] init];
    [self setProjectInformationController:pic];
  }
  [projectInformationController setProject:p];
  [projectInformationController setupForModal];
  [projectInformationController runModalWithParent:[self window]];
}


- (void)handleCreditsChange:(NSNotification *)note {
  NSArray *array = [[Credits sharedInstance] objectsForUids:[currentlyViewedPerson creditUids]];
  [self setCreditsInPersonInfoPanel:[[NSMutableArray alloc] initWithArray:array]];
  [creditsTableView reloadData];
}



//******************************************************************************
// text field change handlers
//******************************************************************************
- (void)handlePersonInfoChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    [titleTextField setStringValue:[[infoNameTextField stringValue] lowercaseString]];
    [self enableInfoEditButtonsIfAppropriate];
  }       
}

//******************************************************************************

- (NSCalendarDate *)membershipEndDateForMemberType:(NSString *)type {
  NSString *key;
  if ([type isEqualToString:[NSString stringWithFormat:@"regular"]]) {
    key = TljBkPosRegularMembershipInfo;
  } else if ([type isEqualToString:[NSString stringWithFormat:@"deluxe"]]) {
    key = TljBkPosDeluxeMembershipInfo;
  } else if ([type isEqualToString:[NSString stringWithFormat:@"cook"]]) {
    key = TljBkPosCookMembershipInfo;
  } else if ([type isEqualToString:[NSString stringWithFormat:@"lifetime"]]) {
    key = TljBkPosLifetimeMembershipInfo;
  } else {
    // expired membership or not a member
    return [currentlyViewedPerson membershipEndDate];
  }
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  MembershipInformation *info =
    [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:key]];
  NSCalendarDate *endDate =
    [[NSCalendarDate calendarDate] dateByAddingYears:0 months:0 days:[info durationInDays]
                                               hours:0 minutes:0 seconds:0];
  return endDate;
}

//******************************************************************************

- (bool)personInfoIsDifferent {
  NSString *name = [[infoNameTextField stringValue] lowercaseString];
  NSString *email = [[infoEmailTextField stringValue] lowercaseString];
  NSString *phone = [[infoPhoneTextField stringValue] lowercaseString];
  
  NSString *type = [self stringFromComboBox:infoMemberTypeComboBox];
  NSCalendarDate *newEndDate = [self calendarDateFromDatePicker:infoMembershipEndDateDatePicker];
//  NSString *newEndDateStr = [newEndDate descriptionWithCalendarFormat:@"%m/%d/%Y"];
  NSCalendarDate *oldEndDate = [currentlyViewedPerson membershipEndDate];
//  NSString *oldEndDateStr = [oldEndDate descriptionWithCalendarFormat:@"%m/%d/%Y"];
  bool dateDifferent = YES;
  if ([self date:newEndDate equalsDate:oldEndDate]){
    dateDifferent = NO;
  }
  
  bool acceptCheck = [infoAcceptCheckButton state];
  bool signedWaiver = [infoSignedWaiverButton state];
  
  if ([name isEqualToString:[currentlyViewedPerson personName]] &&
      [email isEqualToString:[currentlyViewedPerson emailAddress]] &&
      [phone isEqualToString:[currentlyViewedPerson phoneNumber]] &&
      [type isEqualToString:[currentlyViewedPerson memberType]] &&
      !dateDifferent &&
      (acceptCheck == [currentlyViewedPerson willTakeCheckFrom]) &&
      (signedWaiver == [currentlyViewedPerson hasSignedLiabilityWavier])) {
    return NO;
  } else {
    return YES;
  }
}

//******************************************************************************

- (bool)personNameIsNotEmpty {
  NSString *name = [[infoNameTextField stringValue] lowercaseString];
  if ([name isEqualToString:[NSString stringWithFormat:@""]]) {
    return NO;
  } else {
    return YES;
  }
}

//******************************************************************************

- (void)enableInfoEditButtonsIfAppropriate {
  if ([self personInfoIsDifferent] && [self personNameIsNotEmpty]) {
    [infoCancelButton setEnabled:YES];
    [infoSaveEditButton setEnabled:YES];  
  } else {
    [infoCancelButton setEnabled:NO];
    [infoSaveEditButton setEnabled:NO];   
  }
}

//******************************************************************************

- (void)handleContactInfoChange:(NSNotification *)note {
 
  if ([[self window] isKeyWindow]) {
    if ([note object] != contactsSearchField) {
      [self enableContactSaveButtonIfAppropriate];
    }
  }
}

- (bool)contactCookAndSubjectAreNotEmpty {
  NSString *emptyString = [NSString stringWithFormat:@""];
  NSString *cook = [[contactCookTextField stringValue] lowercaseString];
  NSString *subject = [[contactSubjectTextField stringValue] lowercaseString];
  ////NSLog(@"cook: %@ subject: %@", cook, subject);
  if ([cook isEqualToString:emptyString] || 
      [subject isEqualToString:emptyString]) {
    return NO;
  } else {
    return YES;
  }
}

- (bool)contactIsDifferent {
  NSString *cook = [[contactCookTextField stringValue] lowercaseString];
  NSString *subject = [[contactSubjectTextField stringValue] lowercaseString];
  NSString *body = [[contactBodyTextView string] lowercaseString];
  NSDate *date = [contactDatePicker dateValue];
  NSString *newDatestr = [[date descriptionWithCalendarFormat:@"%m/%d/%Y" timeZone:nil locale:nil] description];
  NSString *oldDatestr = [[currentlyViewedContact date] description];
  NSString *newType = [self stringForContactTypeFromMatrix];
  NSString *oldType = [self stringForContactTypeFromContact];

//  //NSLog(@"old date: %@ new date: %@", newDatestr, oldDatestr);
//  //NSLog(@"cook same: %d", [cook isEqualToString:[currentlyViewedContact commentAuthorName]]);
//  //NSLog(@"subject same: %d", [subject isEqualToString:[currentlyViewedContact commentSubject]]);
//  //NSLog(@"body same: %d", [body isEqualToString:[currentlyViewedContact commentText]]);
//  //NSLog(@"date same: %d", [newDatestr isEqualToString:oldDatestr]);
//  //NSLog(@"type same: %d", [newType isEqualToString:oldType]);

  if ([cook isEqualToString:[currentlyViewedContact commentAuthorName]] &&
      [subject isEqualToString:[currentlyViewedContact commentSubject]] &&
      [body isEqualToString:[currentlyViewedContact commentText]] &&
      [newDatestr isEqualToString:oldDatestr] &&
      [newType isEqualToString:oldType]) {
    return NO;
  } else {
    return YES;
  }
}

- (NSString *)stringForContactTypeFromMatrix {
  if ([[contactTypeMatrix cellAtRow:0 column:0] state]) {
    return [NSString stringWithFormat:@"leftMessage"];
  } else if ([[contactTypeMatrix cellAtRow:1 column:0] state]) {
    return [NSString stringWithFormat:@"sentEmail"];
  } else {
    return [NSString stringWithFormat:@"spokeDirectly"];
  }
}

- (NSString *)stringForContactTypeFromContact {
  if ([currentlyViewedContact leftMessage]) {
    return [NSString stringWithFormat:@"leftMessage"];
  } else if ([currentlyViewedContact sentEmail]) {
    return [NSString stringWithFormat:@"sentEmail"];
  } else {
    return [NSString stringWithFormat:@"spokeDirectly"];
  }
}

- (void)enableContactSaveButtonIfAppropriate {
  ////NSLog(@"contact is different: %d", [self contactIsDifferent]);
  ////NSLog(@"required fields present: %d", [self contactCookAndSubjectAreNotEmpty]);
  
  if ([self contactIsDifferent] && [self contactCookAndSubjectAreNotEmpty]) {
    [contactSaveButton setEnabled:YES];
    [contactCancelButton setEnabled:YES];
  } else {
    [contactSaveButton setEnabled:NO];
    [contactCancelButton setEnabled:NO];
  }
}


- (void)enableCreditsSaveButtonIfAppropriate {
  if ([self textFieldIsEmpty:creditsCookTextField] ||
      [self textFieldIsEmpty:creditsCommentTextField] ||
      [self textFieldIsEmpty:creditsAmountTextField]) {
    [creditsSaveButton setEnabled:NO];
  } else {
    [creditsSaveButton setEnabled:YES];
  }
}


- (void)handleCommentInfoChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    
  }
}

- (void)handleCreditInfoChange:(NSNotification *)note {
 // //NSLog(@"in handleCreditInfoChange");
  if ([[self window] isKeyWindow]) {
    if ([note object] != creditsSearchField) {
      [self enableCreditsSaveButtonIfAppropriate];
    }
  }
}


//******************************************************************************
// search field change handlers
//******************************************************************************

- (void)handleProjectSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    if ([note object] == projectSearchField) {
      
    } 
  }
  
}

- (void)handleContactSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    if ([note object] == contactsSearchField) {
      ////NSLog(@"in contact search field");
      NSString *searchString = [[[note object] stringValue] lowercaseString];
      NSString *authorString, *subjectString, *bodyString, *dateString;
      id object;
      // revert to whole list of products
      if ( [searchString length] == 0 ) {
        [self setContactsInPersonInfoPanel:[[Contacts sharedInstance] objectsForUids:[currentlyViewedPerson contactUids]]];
        previousLengthOfContactSearchString = 0;
        [contactsTableView reloadData];
        return;
      }
      // this will hold our filtered list
      NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
      // if we back up, research the entire list
      if (previousLengthOfContactSearchString > [searchString length]) {
        [self setContactsInPersonInfoPanel:[[Contacts sharedInstance] objectsForUids:[currentlyViewedPerson contactUids]]];
      }
      
      // this needs to be exactly here, otherwise we won't iterate over the correct
      NSEnumerator *e = [contactsInPersonInfoPanel objectEnumerator];
      while ( object = [e nextObject] ) {
        authorString = [[object commentAuthorName] lowercaseString];
        subjectString = [[object commentSubject] lowercaseString];
        bodyString = [[object commentText] lowercaseString];
        dateString = [[object date] descriptionWithCalendarFormat:@"%m/%d/%yy" timeZone:nil
                                                           locale:nil];
        NSRange authorRange = [authorString rangeOfString:searchString options:NSLiteralSearch];
        NSRange subjectRange = [subjectString rangeOfString:searchString options:NSLiteralSearch];
        NSRange bodyRange = [bodyString rangeOfString:searchString options:NSLiteralSearch];
        NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
        if (((authorRange.length) > 0) || ((subjectRange.length) > 0) ||
            ((bodyRange.length) > 0) || ((dateRange.length) > 0)) {
          [filteredObjects addObject:object];
        }
      }    
      [self setContactsInPersonInfoPanel:filteredObjects];
      [contactsTableView reloadData];
      previousLengthOfContactSearchString = [searchString length];
    }
  }
}


- (void)handleCommentSearchFieldChange:(NSNotification *)note {
//  if ([[self window] isKeyWindow]) {
//    if ([note object] == commentSearchField) {
//      
//    }
//  }
//  
}

//- (void)handleInvoiceSearchFieldChange:(NSNotification *)note {
//  if ([[self window] isKeyWindow]) {
//    if ([note object] == invoicesSearchField) {
//      
//    }
//  }
//  
//}

- (void)handleCreditSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    if ([note object] == creditsSearchField) {
      
    }
  }  
}


//******************************************************************************
// undo for edits - not working
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

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue {
  // setValue:forKeyPath will cause the key-value observing method
  // to be called, which takes care of the undo stuff
 // //NSLog(@"in changeKeyPath in personInfoController");
  [obj setValue:newValue forKeyPath:keyPath];
  
  if (runningModal) {
    [self setupForModal];
    [self runModalWithParent:mainApplicationWindow];
  } else {
    [self setupForNonModal];
    [[self window] makeKeyAndOrderFront:self];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
  
  NSUndoManager *undo = [[self window] undoManager];
  id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
  [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                ofObject:object
                                                 toValue:oldValue];
  [undo setActionName:@"Edit"];
}


- (ProjectInformationController *)projectInformationController {
  return projectInformationController;
}

- (void)setProjectInformationController:(ProjectInformationController *)controller {
  [controller retain];
  [projectInformationController release];
  projectInformationController = controller;
  
}



@end
