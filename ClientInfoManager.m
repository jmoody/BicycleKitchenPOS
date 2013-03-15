//
//  ClientInfoManager.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/20/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ClientInfoManager.h"
#import "People.h"
#import "Projects.h"
#import "Contacts.h"
#import "Invoices.h"
#import "Credits.h"

@implementation ClientInfoManager

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"ClientInformation"];
    previousLengthOfProjectsSearchString = 0;
    previousLengthOfContactsSearchString = 0;
    previousLengthOfInvoicesSearchString = 0;
    previousLengthOfCreditsSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [contactCreator release];
  [creditCreator release];
  [projectInfo release];
  [invoiceViewer release];
  [person release];
  [project release];
  [contact release];
  [invoice release];
  [credit release];
  [projectsArray release];
  [contactsArray release];
  [invoicesArray release];
  [creditsArray release];
  
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
  [self setupStateVariables];
  [theTabView selectFirstTabViewItem:self];
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
  [self setupStateVariables];
  [theTabView selectFirstTabViewItem:self];
}

//******************************************************************************

- (void)setupForNonModal {
  [super setupForNonModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
  [self setupStateVariables];
  [theTabView selectFirstTabViewItem:self];
}

//******************************************************************************

- (void)runModalWithParent:(NSWindow *) parent {
  [super runModalWithParent:parent];
}


//******************************************************************************
// setup
//******************************************************************************

- (void)setupButtons {
  // info
  [infoCancelButton setEnabled:NO];
  [infoSaveButton setEnabled:NO];
  [acceptCheckButton setState:[person willTakeCheckFrom]];
  [waiverButton setState:[person hasSignedLiabilityWaiver]];
  // contact
  [contactCancelButton setEnabled:NO];
  [contactSaveButton setEnabled:NO];
  [messageTypeMatrix setState:1 atRow:0 column:0];
  [messageTypeMatrix setEnabled:NO];
  [contactDatePicker setDateValue:[NSCalendarDate calendarDate]];
  [contactDatePicker setEnabled:NO];
  // credit
  [creditCancelButton setEnabled:NO];
  [creditSaveButton setEnabled:NO];
  [creditDatePicker setDateValue:[NSCalendarDate calendarDate]];
  [creditDatePicker setEnabled:NO];
}

//******************************************************************************

- (void)setupTextFields {
  // info
  [nameTextField setStringValue:[person personName]];
  [phoneTextField setStringValue:[person phoneNumber]];
  [emailTextField setStringValue:[person emailAddress]];
  [companyTextField setStringValue:[person companyName]];
  [addressTextField setStringValue:[person address]];
  [cityTextField setStringValue:[person city]];
  [addressStateTextField setStringValue:[person addressState]];
  [zipTextField setStringValue:[person zip]];
  
  [membershipTextField setStringValue:[person memberType]];
  if ([person isMember]) {
    [endDate1TextField setHidden:NO];
    [endDate2TextField setHidden:NO];
    [endDate2TextField setStringValue:[[person membershipEndDate] descriptionWithCalendarFormat:@"%m/%d/%Y"]];
  } else {
    [endDate1TextField setHidden:YES];
    [endDate2TextField setHidden:YES];
  }
  [balanceTextField setDoubleValue:[person personBalance]];
  // project
  [self clearTextField:projectsSearchField];
  // contact
  [self clearTextField:contactsSearchField];
  [self clearTextField:contactCookTextField];
  [contactCookTextField setEnabled:NO];
  [self clearTextField:contactSubjectTextField];
  [contactSubjectTextField setEnabled:NO];
  [self clearTextView:contactNoteTextView];
  [contactNoteTextView setEditable:NO];
  // invoice
  [self clearTextField:invoicesSearchField];
  // credit
  [creditTotalTextField setDoubleValue:[person creditAvailable]];
  [self clearTextField:creditsSearchField];
  [self clearTextField:creditCookTextField];
  [creditCookTextField setEnabled:NO];
  [self clearTextField:creditAmountTextField];
  [creditAmountTextField setEnabled:NO];
  [self clearTextField:creditReasonTextField];
  [creditReasonTextField setEnabled:NO];
  [self clearTextView:creditNoteTextView];
  [creditNoteTextView setEditable:NO];
}


//******************************************************************************

- (void)setupTables {
  // project
  [self setProjectsArray:[self clientProjects]];
  [projectsTableView setTarget:self];
  [projectsTableView setDoubleAction:@selector(handleProjectsClicked:)];
  // contact
  [self setContactsArray:[self clientContacts]];
  [contactsTableView setTarget:self];
  [contactsTableView setDoubleAction:@selector(handleContactsClicked:)];
  // invoice
  [self setInvoicesArray:[self clientInvoices]];
  [invoicesTableView setTarget:self];
  [invoicesTableView setDoubleAction:@selector(handleInvoicesClicked:)];
  // credit
  [self setCreditsArray:[self clientCredits]];
  [creditsTableView setTarget:self];
  [creditsTableView setDoubleAction:@selector(handleCreditsClicked:)];
}

//******************************************************************************

- (void)setupStateVariables {
  // don't clear the person
  [self setProject:nil];
  [self setContact:nil];
  [self setInvoice:nil];
  [self setCredit:nil];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)closeButtonClicked:(id)sender {
  //NSLog(@"closeButton clicked");
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

//******************************************************************************

- (IBAction)infoSaveButtonClicked:(id)sender {
  NSString *newName = [self lowercaseAndLatexSafeStringFromTextField:nameTextField];
  NSString *newPhone = [phoneTextField stringValue];
  NSString *newEmail = [self lowercaseAndLatexSafeStringFromTextField:emailTextField];
  
  bool badPerson, badPhone, badEmail;
  NSString *thisUid = [person uid];
  // if there exists a person with the same name, but different uid then bad person
  if (![newName isEqualToString:[person personName]]) {
    NSMutableArray *all = [[People sharedInstance] arrayForDictionary];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"personName like %@ AND !(uid like %@)",
      newName, thisUid];
    NSArray *conflicts = [all filteredArrayUsingPredicate:pred];
    if ([conflicts count] > 0) {
      badPerson = YES;
    } 
  } else {
    badPerson = NO;
  }
  
  if (![newPhone isEqualToString:[person phoneNumber]]) {
    badPhone = [[People sharedInstance] phoneNumberIsBadlyFormatted:newPhone];
  } else {
    badPhone = NO;
  }
  
  if (![newEmail isEqualToString:[person emailAddress]]) {
    badEmail = [[People sharedInstance] emailAddressAppearsInPeopleInSingleton:person];
  } else {
    badEmail = NO;
  }
  
  //NSLog(@"bad person: %d !bypassDuplicatePerson: %d", badPerson, !bypassDuplicatePerson);
  if (badPerson) {
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
    [[People sharedInstance] alertMessageForDuplicatePersonsInCustomerAdd:person];
  message = [message stringByAppendingString:[NSString stringWithFormat:@"\n%@", duplicatePeopleString]];
  int choice = NSRunAlertPanel(@"Duplicate Name", message, @"Try Again", @"Continue Save",nil);
  
  // try again = 1, cancel = -1, continue add = 0
  if (choice == 1) {
    // do nothing methinks
    //    [NSApp stopModal];
    //    // rerun create customer
    //    [self runModalWithParent:m
  } else if (choice == 0) {
    //bypassDuplicatePerson = YES;
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
  NSString *newPhone = [phoneTextField stringValue];
  NSString *message = [NSString stringWithFormat:@"Phone number %@ is badly formatted,\nFollow the 213.700.6271 example.",
    newPhone];
  NSRunAlertPanel(@"Bad Phone Number", message, @"Try Again", @"Cancel", nil);
  //int choice = NSRunAlertPanel(@"Bad Phone Number", message, @"Try Again", @"Cancel", nil);
  
  
  
  // no matter what, we refocus - the phone number is badly formatted
  //  if ([infoPhoneTextField acceptsFirstResponder]) {
  //    [[self window] makeFirstResponder:infoPhoneTextField];
  //  } 
  //  if (choice == 1) {
  //    if ([infoPhoneTextField acceptsFirstResponder]) {
  //      [[self window] makeFirstResponder:infoPhoneTextField];
  //    } 
  //    // do nothing methinks
  //    //[NSApp stopModal];
  //    //// rerun create customer
  //    //[self runModalWithParent:mainApplicationWindow];
  //  }
}

//******************************************************************************

- (void)runBadEmail {
  NSString *newEmail = [self latexSafeStringFromTextField:emailTextField];
  NSString *message = 
    [NSString stringWithFormat:@"Person with email %@ already exists.\nThis is not allowed.", newEmail];
  NSRunAlertPanel(@"Duplicate Email Address", message, @"Try Again", @"Cancel", nil);
  //int choice = NSRunAlertPanel(@"Duplicate Email Address", message, @"Try Again", @"Cancel", nil);
  // no matter, what refocus - no duplicate emails
  //  if ([infoEmailTextField acceptsFirstResponder]) {
  //    [[self window] makeFirstResponder:infoEmailTextField];
  //  } 
  //  if (choice == 1) {
  //    if ([infoEmailTextField acceptsFirstResponder]) {
  //      [[self window] makeFirstResponder:infoEmailTextField];
  //    } 
  //    // do nothing methinks
  //    //    [NSApp stopModal];
  //    //    // rerun create customer
  //    //    [self runModalWithParent:mainApplicationWindow];
  //  } 
}

//******************************************************************************

- (void)runEditPerson {
  
	
	[person setPersonName:[self lowercaseAndLatexSafeStringFromTextField:nameTextField]];
  [person setPhoneNumber:[phoneTextField stringValue]];
  [person setEmailAddress:[self lowercaseAndLatexSafeStringFromTextField:emailTextField]];
  [person setCompanyName:[self lowercaseAndLatexSafeStringFromTextField:companyTextField]];
  [person setAddress:[self lowercaseAndLatexSafeStringFromTextField:addressTextField]];
  [person setCity:[self lowercaseAndLatexSafeStringFromTextField:cityTextField]];
  [person setAddressState:[self lowercaseAndLatexSafeStringFromTextField:addressStateTextField]];
  [person setZip:[self lowercaseAndLatexSafeStringFromTextField:zipTextField]];
  
  // accept check
  bool willTake;
  if ([acceptCheckButton state] == 1) {
    willTake = YES;
  } else {
    willTake = NO;
  }
  [person setWillTakeCheckFrom:willTake];
  
  bool hasSigned;
  if ([waiverButton state] == 1) {
    hasSigned = YES;
  } else {
    hasSigned = NO;
  }
  
  [person setHasSignedLiabilityWaiver:hasSigned];
  [[People sharedInstance] saveToDisk];
  
  [infoSaveButton setEnabled:NO];
  [infoCancelButton setEnabled:NO];
  
}

//******************************************************************************

- (IBAction)infoCancelButtonClicked:(id)sender {
  //NSLog(@"infoCancelButton clicked");
  [self setupButtons];
  [self setupTextFields];
}

//******************************************************************************

- (IBAction)acceptCheckButtonClicked:(id)sender {
  //NSLog(@"acceptCheckButton clicked");
  [self enableInfoSaveEditAppropriately];
}

//******************************************************************************

- (IBAction)waiverButtonClicked:(id)sender {
  //NSLog(@"waiverButton clicked");
  [self enableInfoSaveEditAppropriately];
}

//******************************************************************************

- (IBAction)deleteContactButtonClicked:(id)sender {
  //NSLog(@"deleteContactButton clicked");
  NSArray *selected = [contactsArrayController selectedObjects];
  if ([selected count] > 0) {
    CustomerContact *tmp = [selected objectAtIndex:0];
    if (tmp != nil) {
      NSString *aUid = [tmp uid];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF like %@)", aUid];
      [[person contactUids] filterUsingPredicate:predicate];
      [[People sharedInstance] saveToDisk];
      
      // could speed this up by looking at only the current person's projects
      // but for now we'll keep the search over the complete list.
      NSMutableArray *projects = [[Projects sharedInstance] arrayForDictionary];
      unsigned int i, count = [projects count];
      for (i = 0; i < count; i++) {
        Project *pr = (Project *) [projects objectAtIndex:i];
        [[pr contactUids] filterUsingPredicate:predicate];
      }
      [[Projects sharedInstance] saveToDisk];
      [[Contacts sharedInstance] removeObjectForUid:aUid];
    
      [contactCancelButton setEnabled:NO];
      [contactSaveButton setEnabled:NO];
      [messageTypeMatrix setState:1 atRow:0 column:0];
      [messageTypeMatrix setEnabled:NO];
      [contactDatePicker setDateValue:[NSCalendarDate calendarDate]];
      [contactDatePicker setEnabled:NO];
      
      [self clearTextField:contactsSearchField];
      [contactCookTextField setEnabled:NO];
      [self clearTextField:contactSubjectTextField];
      [contactSubjectTextField setEnabled:NO];
      [self clearTextView:contactNoteTextView];
      [contactNoteTextView setEditable:NO];
      
    }
  }
}

//******************************************************************************

- (IBAction)newContactButtonClicked:(id)sender {
  //NSLog(@"newContactButton clicked");
  if ([[person personName] isEqualToString:@"quick sale"]) {
    NSRunAlertPanel(@"Operation Not Permitted",
                    @"quick sale can't have a correspondence",
                    @"Continue", nil, nil);
  } else {

    if (contactCreator == nil) {
      CreateCorrespondence *tmp = [[CreateCorrespondence alloc] init];
      [self setContactCreator:tmp];
      [tmp release];
    }
    [contactCreator setPerson:person];
    [contactCreator setupForModal];
    [contactCreator runModalWithParent:[self window]];
    
    [contactCancelButton setEnabled:NO];
    [contactSaveButton setEnabled:NO];
    [messageTypeMatrix setState:1 atRow:0 column:0];
    [messageTypeMatrix setEnabled:NO];
    [contactDatePicker setDateValue:[NSCalendarDate calendarDate]];
    [contactDatePicker setEnabled:NO];
    
    //  [self clearTextField:contactsSearchField];
    //  [self clearTextField:contactCookTextField];
    //  [contactCookTextField setEnabled:NO];
    //  [self clearTextField:contactSubjectTextField];
    //  [contactSubjectTextField setEnabled:NO];
    //  [self clearTextView:contactNoteTextView];
    //  [contactNoteTextView setEditable:NO];
    //  [self setContact:nil];
  }
}

//******************************************************************************

- (IBAction)messageTypeMatrixClicked:(id)sender {
  //NSLog(@"messageTypeMatrix clicked");
  [self enableContactSaveEditAppropriately];
}

//******************************************************************************

- (IBAction)contactDatePickerClicked:(id)sender {
  //NSLog(@"contactDatePicker clicked");
  [self enableContactSaveEditAppropriately];
}

//******************************************************************************

- (IBAction)contactCancelButtonClicked:(id)sender {
  //NSLog(@"contactCancelButton clicked");
  [contactCookTextField setStringValue:[contact commentAuthorName]];
  [contactSubjectTextField setStringValue:[contact commentSubject]];
  [contactNoteTextView setString:[contact commentText]];
  [contactDatePicker setDateValue:[contact date]];
  if ([contact leftMessage]) {
    [messageTypeMatrix selectCellAtRow:0 column:0]; 
  } else if ([contact spokeDirectly]) {
    [messageTypeMatrix selectCellAtRow:0 column:1]; 
  } else {
    [messageTypeMatrix selectCellAtRow:0 column:2]; 
  }  
  [contactSaveButton setEnabled:NO];
  [contactCancelButton setEnabled:NO]; 
}

//******************************************************************************

- (IBAction)contactSaveButtonClicked:(id)sender {
  //NSLog(@"contactSaveButton clicked");
  [contact setCommentAuthorName:[self latexSafeStringFromTextField:contactCookTextField]];
  [contact setCommentSubject:[self lowercaseAndLatexSafeStringFromTextField:contactSubjectTextField]];
  [contact setCommentText:[self lowercaseAndLatexSafeStringFromTextView:contactNoteTextView]];
  [contact setDate:[self calendarDateFromDatePicker:contactDatePicker]];
  [contact setLeftMessage:[self boolValueForRadioMatrix:messageTypeMatrix cell:[messageTypeMatrix cellAtRow:0 column:0]]];
  [contact setSpokeDirectly:[self boolValueForRadioMatrix:messageTypeMatrix cell:[messageTypeMatrix cellAtRow:0 column:1]]];
  [contact setSentEmail:[self boolValueForRadioMatrix:messageTypeMatrix cell:[messageTypeMatrix cellAtRow:0 column:2]]];
  [[Contacts sharedInstance] saveToDisk];
  [contactSaveButton setEnabled:NO];
  [contactCancelButton setEnabled:NO];
}

//******************************************************************************

- (IBAction)newCreditButtonClicked:(id)sender {
  //NSLog(@"newCreditButton clicked");
  if ([[person personName] isEqualToString:@"quick sale"]) {
    NSRunAlertPanel(@"Operation Not Permitted",
                    @"quick sale can't have a credit",
                    @"Continue", nil, nil);
  } else {
    
    if (creditCreator == nil) {
      CreateCredit *tmp = [[CreateCredit alloc] init];
      [self setCreditCreator:tmp];
      [tmp release];
    }
    [creditCreator setPerson:person];
    [creditCreator setupForModal];
    [creditCreator runModalWithParent:[self window]];
    
    [creditCancelButton setEnabled:NO];
    [creditSaveButton setEnabled:NO];
    [creditDatePicker setDateValue:[NSCalendarDate calendarDate]];
    [creditDatePicker setEnabled:NO];
    
    //  [self clearTextField:creditsSearchField];
    //  [self clearTextField:creditCookTextField];
    //  [creditCookTextField setEnabled:NO];
    //  [self clearTextField:creditAmountTextField];
    //  [creditAmountTextField setEnabled:NO];
    //  [self clearTextField:creditReasonTextField];
    //  [creditReasonTextField setEnabled:NO];
    //  [self clearTextView:creditNoteTextView];
    //  [creditNoteTextView setEditable:NO];
    
  }
}

//******************************************************************************

- (IBAction)deleteCreditButtonClicked:(id)sender {
  //NSLog(@"deleteCreditButton clicked");
  NSArray *selected = [creditsArrayController selectedObjects];
  if ([selected count] > 0) {
    ShopCredit *tmp = (ShopCredit *)[selected objectAtIndex:0];
    if (tmp != nil) {
      NSString *aUid = [tmp uid];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF like %@)", aUid];
      [[person creditUids] filterUsingPredicate:predicate];
      [[People sharedInstance] saveToDisk];
      [[Credits sharedInstance] removeObjectForUid:aUid];
      
      [creditCancelButton setEnabled:NO];
      [creditSaveButton setEnabled:NO];
      [creditDatePicker setDateValue:[NSCalendarDate calendarDate]];
      [creditDatePicker setEnabled:NO];
      
      [self clearTextField:creditsSearchField];
      [self clearTextField:creditCookTextField];
      [creditCookTextField setEnabled:NO];
      [self clearTextField:creditAmountTextField];
      [creditAmountTextField setEnabled:NO];
      [self clearTextField:creditReasonTextField];
      [creditReasonTextField setEnabled:NO];
      [self clearTextView:creditNoteTextView];
      [creditNoteTextView setEditable:NO];
    }
  }
}

//******************************************************************************

- (IBAction)creditDatePickerClicked:(id)sender {
  //NSLog(@"creditDatePicker clicked");
  [self enableCreditSaveEditAppropriately];
}

//******************************************************************************

- (IBAction)creditCancelButtonClicked:(id)sender {
  //NSLog(@"creditCancelButton clicked");
  [creditCookTextField setStringValue:[credit commentAuthorName]];
  [creditAmountTextField setDoubleValue:[credit creditAmount]];
  [creditReasonTextField setStringValue:[credit commentSubject]];
  [creditNoteTextView setString:[credit commentText]];
  [creditDatePicker setDateValue:[credit date]];
  [creditCancelButton setEnabled:NO];
  [creditSaveButton setEnabled:NO];
}

//******************************************************************************

- (IBAction)creditSaveButtonClicked:(id)sender {
  //NSLog(@"creditSaveButton clicked");
  [credit setCommentAuthorName:[self latexSafeStringFromTextField:creditCookTextField]];
  [credit setCreditAmount:[creditAmountTextField doubleValue]];
  [credit setCommentSubject:[self lowercaseAndLatexSafeStringFromTextField:creditReasonTextField]];
  [credit setCommentText:[self lowercaseAndLatexSafeStringFromTextView:creditNoteTextView]];
  [credit setDate:[self calendarDateFromDatePicker:creditDatePicker]];
  [creditCancelButton setEnabled:NO];
  [creditSaveButton setEnabled:NO];
}

//******************************************************************************
// misc
//******************************************************************************

- (NSMutableArray *)clientProjects {
  return [[Projects sharedInstance] objectsForUids:[person projectUids]];
}

//******************************************************************************

- (NSMutableArray *)clientContacts {
  return [[Contacts sharedInstance] objectsForUids:[person contactUids]];
}

//******************************************************************************

- (NSMutableArray *)clientInvoices {
  return [[Invoices sharedInstance] objectsForUids:[person invoiceUids]];
}

//******************************************************************************

- (NSMutableArray *)clientCredits {
  return [[Credits sharedInstance] objectsForUids:[person creditUids]];
}

//******************************************************************************
// handlers
//******************************************************************************

- (void)enableInfoSaveEditAppropriately {
  bool acceptIsDifferent;
  bool orgWill = [person willTakeCheckFrom];
  bool newWill;
  if ([acceptCheckButton state] == 1) {
    newWill = YES;
  } else {
    newWill = NO;
  }
  if (orgWill == newWill) {
    acceptIsDifferent = NO;
  } else {
    acceptIsDifferent = YES;
  }
  
  bool waiverIsDifferent;
  bool org = [person hasSignedLiabilityWaiver];
  bool new;
  if ([waiverButton state] == 1) {
    new = YES;
  } else {
    new = NO;
  }
  if (org == new) {
    waiverIsDifferent = NO;
  } else {
    waiverIsDifferent = YES;
  }
  
  NSString *newName = [nameTextField stringValue];
  NSString *orgName = [person personName];
  NSString *newPhone = [phoneTextField stringValue];
  NSString *orgPhone = [person phoneNumber];
  NSString *newEmail = [emailTextField stringValue];
  NSString *orgEmail = [person emailAddress];
  NSString *newCompany = [companyTextField stringValue];
  NSString *orgCompany = [person companyName];
  NSString *newAddress = [addressTextField stringValue];
  NSString *orgAddress = [person address];
  NSString *newCity = [cityTextField stringValue];
  NSString *orgCity = [person city];
  NSString *newState = [addressStateTextField stringValue];
  NSString *orgState = [person addressState];
  NSString *newZip = [zipTextField stringValue];
  NSString *orgZip = [person zip];
  
  
  if (acceptIsDifferent || waiverIsDifferent || 
      ![self string:newName equalsString:orgName] ||
      ![self string:newPhone equalsString:orgPhone] ||
      ![self string:newEmail equalsString:orgEmail] ||
      ![self string:newCompany equalsString:orgCompany] ||
      ![self string:newAddress equalsString:orgAddress] ||
      ![self string:newCity equalsString:orgCity] ||
      ![self string:newState equalsString:orgState] ||
      ![self string:newZip equalsString:orgZip]){
    [infoCancelButton setEnabled:YES];
    [infoSaveButton setEnabled:YES];
  } else {
    [infoCancelButton setEnabled:NO];
    [infoSaveButton setEnabled:NO];
  }
}

//******************************************************************************

- (void)enableContactSaveEditAppropriately {
  bool messageTypeIsDifferent;
  
  bool newMessage = [self boolValueForRadioMatrix:messageTypeMatrix cell:[messageTypeMatrix cellAtRow:0 column:0]];
  bool newSpoke = [self boolValueForRadioMatrix:messageTypeMatrix cell:[messageTypeMatrix cellAtRow:0 column:1]];
  bool newEmail = [self boolValueForRadioMatrix:messageTypeMatrix cell:[messageTypeMatrix cellAtRow:0 column:2]];
  bool orgMessage = [contact leftMessage];
  bool orgSpoke = [contact spokeDirectly];
  bool orgEmail = [contact sentEmail];
  if ((newMessage != orgMessage) || (newSpoke != orgSpoke) || (newEmail != orgEmail)) {
    messageTypeIsDifferent = YES;
  } else {
    messageTypeIsDifferent = NO;
  }
  
  bool dateIsDifferent;
  
  NSCalendarDate *org = [contact date];
  NSCalendarDate *new = [self calendarDateFromDatePicker:contactDatePicker];
  if ([self date:org equalsDate:new]) {
    dateIsDifferent = NO;
  } else {
    dateIsDifferent = YES;
  }
  
  NSString *newCook = [[contactCookTextField stringValue] lowercaseString];
  NSString *orgCook = [contact commentAuthorName];
  NSString *newSub = [[contactSubjectTextField stringValue] lowercaseString];
  NSString *orgSub = [contact commentSubject];
  NSString *newNote = [[contactNoteTextView string] lowercaseString];
  NSString *orgNote = [contact commentText];
  
  
  if (messageTypeIsDifferent || dateIsDifferent ||
      ![self string:newCook equalsString:orgCook] ||
      ![self string:newSub equalsString:orgSub] ||
      ![self string:newNote equalsString:orgNote]) {
    [contactCancelButton setEnabled:YES];
    [contactSaveButton setEnabled:YES];
  } else {
    [contactCancelButton setEnabled:NO];
    [contactSaveButton setEnabled:NO];
  }
}

//******************************************************************************

- (void)enableCreditSaveEditAppropriately {
  bool dateIsDifferent;
  
  NSCalendarDate *new = [self calendarDateFromDatePicker:creditDatePicker];
  NSCalendarDate *org = [credit date];
  if ([self date:new equalsDate:org]) {
    dateIsDifferent = NO;
  } else {
    dateIsDifferent = YES;
  }
  NSString *newCook = [[creditCookTextField stringValue] lowercaseString];
  NSString *orgCook = [credit commentAuthorName];
  double newAm = [creditAmountTextField doubleValue];
  double orgAm = [credit creditAmount];
  NSString *newReason = [[creditReasonTextField stringValue] lowercaseString];
  NSString *orgReason = [credit commentSubject];
  NSString *newNote = [[creditNoteTextView string] lowercaseString];
  NSString *orgNote = [credit commentText];
  
  if (dateIsDifferent || (newAm != orgAm) ||
      ![self string:newCook equalsString:orgCook] ||
      ![self string:newReason equalsString:orgReason] ||
      ![self string:newNote equalsString:orgNote]) {
    [creditCancelButton setEnabled:YES];
    [creditSaveButton setEnabled:YES];
  } else {
    [creditCancelButton setEnabled:NO];
    [creditSaveButton setEnabled:NO];
  }
}

//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    id obj = [note object];
    if ((obj == nameTextField) || (obj == phoneTextField) || (obj == emailTextField)
        || (obj == companyTextField) || (obj == addressTextField) ||
        (obj == addressStateTextField) || (obj == cityTextField) || (obj == zipTextField)) {
      //NSLog(@"info");
      [self enableInfoSaveEditAppropriately];
    } else if ((obj == contactCookTextField) || (obj == contactSubjectTextField) ||
               (obj == contactNoteTextView)) {
      [self enableContactSaveEditAppropriately];
    } else {
      //NSLog(@"credit");
      [self enableCreditSaveEditAppropriately];
    }
  }
}

//******************************************************************************

- (void) handleProjectsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == projectsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *bicycleString, *startString, *lastString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setProjectsArray:[self clientProjects]];
      previousLengthOfProjectsSearchString = 0;
      [projectsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfProjectsSearchString > [searchString length]) {
      [self setProjectsArray:[self clientProjects]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [projectsArray objectEnumerator];
    while (object = [e nextObject] ) {
      bicycleString = [[object bicycleDescription] lowercaseString];
      NSRange bicycleRange = [bicycleString rangeOfString:searchString options:NSLiteralSearch];
      startString =  [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange startRange = [startString rangeOfString:searchString options:NSLiteralSearch];
      lastString =  [[[object dateLastWorked]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange lastRange = [lastString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((bicycleRange.length) > 0) || ((startRange.length) > 0) || ((lastRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setProjectsArray:filteredObjects];
    [projectsTableView reloadData];
    previousLengthOfProjectsSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void) handleContactsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == contactsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *authorString, *dateString, *typeString, *subjectString, *textString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setContactsArray:[self clientContacts]];
      previousLengthOfContactsSearchString = 0;
      [contactsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfContactsSearchString > [searchString length]) {
      [self setContactsArray:[self clientContacts]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [contactsArray objectEnumerator];
    while (object = [e nextObject] ) {
      authorString = [[object commentAuthorName] lowercaseString];
      NSRange authorRange = [authorString rangeOfString:searchString options:NSLiteralSearch];
      dateString = [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      typeString = [[object stringForContactType] lowercaseString];
      NSRange typeRange = [typeString rangeOfString:searchString options:NSLiteralSearch];
      subjectString = [[object commentSubject] lowercaseString];
      NSRange subjectRange = [subjectString rangeOfString:searchString options:NSLiteralSearch];
      textString = [[object commentText] lowercaseString];
      NSRange textRange = [textString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((authorRange.length) > 0) || ((dateRange.length) > 0) || ((typeRange.length) > 0) || ((subjectRange.length) > 0) || ((textRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setContactsArray:filteredObjects];
    [contactsTableView reloadData];
    previousLengthOfContactsSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void) handleInvoicesSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == invoicesSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *dateString, *paidString, *paid2String, *totalString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setInvoicesArray:[self clientInvoices]];
      previousLengthOfInvoicesSearchString = 0;
      [invoicesTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfInvoicesSearchString > [searchString length]) {
      [self setInvoicesArray:[self clientInvoices]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [invoicesArray objectEnumerator];
    while (object = [e nextObject] ) {
      dateString = [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      paidString =  [[[object paidDate]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange paidRange = [paidString rangeOfString:searchString options:NSLiteralSearch];
      paid2String = [[object paidYesOrNo] lowercaseString];
      NSRange paid2Range = [paid2String rangeOfString:searchString options:NSLiteralSearch];
      totalString = [NSString stringWithFormat:@"%1.2f", [object invoiceTotal]];
      NSRange totalRange = [totalString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((dateRange.length) > 0) || ((paidRange.length) > 0) || ((paid2Range.length) > 0) || ((totalRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setInvoicesArray:filteredObjects];
    [invoicesTableView reloadData];
    previousLengthOfInvoicesSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void) handleCreditsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == creditsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *dateString, *amountString, *usedString, *authorString, *subjectString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setCreditsArray:[self clientCredits]];
      previousLengthOfCreditsSearchString = 0;
      [creditsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfCreditsSearchString > [searchString length]) {
      [self setCreditsArray:[self clientCredits]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [creditsArray objectEnumerator];
    while (object = [e nextObject] ) {
      dateString = [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      amountString = [NSString stringWithFormat:@"%1.2f", [object creditAmount]];
      NSRange amountRange = [amountString rangeOfString:searchString options:NSLiteralSearch];
      usedString = [[object hasBeenUsedYesOrNo] lowercaseString];
      NSRange usedRange = [usedString rangeOfString:searchString options:NSLiteralSearch];
      authorString = [[object commentAuthorName] lowercaseString];
      NSRange authorRange = [authorString rangeOfString:searchString options:NSLiteralSearch];
      subjectString = [[object commentSubject] lowercaseString];
      NSRange subjectRange = [subjectString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((dateRange.length) > 0) || ((amountRange.length) > 0) || ((usedRange.length) > 0) || ((authorRange.length) > 0) || ((subjectRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setCreditsArray:filteredObjects];
    [creditsTableView reloadData];
    previousLengthOfCreditsSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void)handleProjectsChange:(NSNotification *)note {
  NSArray *tmp = [self clientProjects];
  [self setProjectsArray:tmp];
  [projectsTableView reloadData];
}

//******************************************************************************

- (void)handleProjectsClicked:(id)sender {
  NSArray *selected = [projectsArrayController selectedObjects];
  if ([selected count] > 0) {
    Project *tmp1 = (Project *)[selected objectAtIndex:0];
    if (tmp1 != nil) {
      [self setProject:tmp1];
      if (projectInfo == nil) {
        ProjectInformationController *tmp2 = [[ProjectInformationController alloc] init];
        [self setProjectInfo:tmp2];
        [tmp2 release];
      }
      [projectInfo setProject:tmp1];
      [projectInfo setupForModal];
      [projectInfo runModalWithParent:[self window]];      
    }
  }
}

//******************************************************************************

- (void)handleCustomerContactsChange:(NSNotification *)note {
  NSArray *tmp = [self clientContacts];
  [self setContactsArray:tmp];
  [contactsTableView reloadData];
}

//******************************************************************************

- (void)handleContactsClicked:(id)sender {
  NSArray *selected = [contactsArrayController selectedObjects];
  if ([selected count] > 0) {
    CustomerContact *tmp = (CustomerContact *)[selected objectAtIndex:0];
    if (tmp != nil) {
      [self setContact:tmp];
      [contactCookTextField setStringValue:[contact commentAuthorName]];
      [contactSubjectTextField setStringValue:[contact commentSubject]];
      [contactNoteTextView setString:[contact commentText]];
      [contactDatePicker setDateValue:[contact date]];
      if ([contact leftMessage]) {
        [messageTypeMatrix selectCellAtRow:0 column:0]; 
      } else if ([contact spokeDirectly]) {
        [messageTypeMatrix selectCellAtRow:0 column:1]; 
      } else {
        [messageTypeMatrix selectCellAtRow:0 column:2]; 
      }
      //NSLog(@"%@", [contactSubjectTextField stringValue]);
      [contactCancelButton setEnabled:NO];
      [contactSaveButton setEnabled:NO];
      [contactCookTextField setEnabled:YES];
      [contactSubjectTextField setEnabled:YES];
      [messageTypeMatrix setEnabled:YES];
      [contactDatePicker setEnabled:YES];
    }
  }
}


- (void)handleContactsTableViewSelectionChange:(NSNotification *)note {

  if ([note object] == contactsTableView) {
    //NSLog(@"contacts selection change");
    [self handleContactsClicked:[note object]];
  }
}


//******************************************************************************

- (void)handleInvoicesChange:(NSNotification *)note {
  [self clearTextField:contactsSearchField];
  [self setInvoicesArray:[self clientInvoices]];
  [invoicesTableView reloadData];
}

//******************************************************************************

- (void)handleInvoicesClicked:(id)sender {
  NSArray *selected = [invoicesArrayController selectedObjects];
  if ([selected count] > 0) {
    Invoice *tmp1 = (Invoice *)[selected objectAtIndex:0];
    if (tmp1 != nil) {
      [self setInvoice:tmp1];
      if (invoiceViewer == nil) {
        ViewInvoice *tmp2 = [[ViewInvoice alloc] init];
        [self setInvoiceViewer:tmp2];
        [tmp2 release];
      }
      [invoiceViewer setInvoice:tmp1];
      [invoiceViewer setupForModal];
      [invoiceViewer runModalWithParent:[self window]];
    }
  }
}


//******************************************************************************

- (void)handleCreditsChange:(NSNotification *)note {
  [self clearTextField:creditsSearchField];
  [self setCreditsArray:[self clientCredits]];
  [creditsTableView reloadData];
}

//******************************************************************************

- (void)handleCreditsClicked:(id)sender {
  NSArray *selected = [creditsArrayController selectedObjects];
  if ([selected count] > 0) {
    ShopCredit *tmp = (ShopCredit *)[selected objectAtIndex:0];
    if (tmp != nil) {
      [self setCredit:tmp];
      [creditCookTextField setStringValue:[credit commentAuthorName]];
      [creditAmountTextField setDoubleValue:[credit creditAmount]];
      [creditReasonTextField setStringValue:[credit commentSubject]];
      [creditNoteTextView setString:[credit commentText]];
      [creditDatePicker setDateValue:[credit date]];
      
      [creditCancelButton setEnabled:NO];
      [creditSaveButton setEnabled:NO];
      [creditDatePicker setEnabled:YES];
      [self clearTextField:creditsSearchField];
      [creditCookTextField setEnabled:YES];
      [creditAmountTextField setEnabled:YES];
      [creditReasonTextField setEnabled:YES];
      [creditNoteTextView setEditable:YES];
    }
  }
}

- (void)handleCreditsTableViewSelectionChange:(NSNotification *)note {

  if ([note object] == creditsTableView) {
    //NSLog(@"credits selection change");
    [self handleCreditsClicked:[note object]];
  }
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (CreateCorrespondence *)contactCreator {
  return contactCreator;
}
- (void)setContactCreator:(CreateCorrespondence *)arg {
  [arg retain];
  [contactCreator release];
  contactCreator = arg;
}

- (CreateCredit *)creditCreator {
  return creditCreator;
}
- (void)setCreditCreator:(CreateCredit *)arg {
  [arg retain];
  [creditCreator release];
  creditCreator = arg;
}
- (ProjectInformationController *)projectInfo {
  return projectInfo;
}
- (void)setProjectInfo:(ProjectInformationController *)arg {
  [arg retain];
  [projectInfo release];
  projectInfo = arg;
}

- (ViewInvoice *)invoiceViewer {
  return invoiceViewer;
}
- (void)setInvoiceViewer:(ViewInvoice *)arg {
  [arg retain];
  [invoiceViewer release];
  invoiceViewer = arg;
}

- (Person *)person {
  return person;
}
- (void) setPerson:(Person *)arg {
  [arg retain];
  [person release];
  person = arg;
}
- (Project *)project {
  return project;
}
- (void) setProject:(Project *)arg {
  [arg retain];
  [project release];
  project = arg;
}
- (CustomerContact *)contact {
  return contact;
}
- (void) setContact:(CustomerContact *)arg {
  [arg retain];
  [contact release];
  contact = arg;
}
- (Invoice *)invoice {
  return invoice;
}
- (void) setInvoice:(Invoice *)arg {
  [arg retain];
  [invoice release];
  invoice = arg;
}
- (ShopCredit *)credit {
  return credit;
}
- (void) setCredit:(ShopCredit *)arg {
  [arg retain];
  [credit release];
  credit = arg;
}
- (NSMutableArray *)projectsArray {
  return projectsArray;
}
- (void) setProjectsArray:(NSArray *)arg {
  if (arg != projectsArray) {
    [projectsArray release];
    projectsArray = [arg mutableCopy];
  }
}
- (NSMutableArray *)contactsArray {
  return contactsArray;
}
- (void) setContactsArray:(NSArray *)arg {
  if (arg != contactsArray) {
    [contactsArray release];
    contactsArray = [arg mutableCopy];
  }
}
- (NSMutableArray *)invoicesArray {
  return invoicesArray;
}
- (void) setInvoicesArray:(NSArray *)arg {
  if (arg != invoicesArray) {
    [invoicesArray release];
    invoicesArray = [arg mutableCopy];
  }
}
- (NSMutableArray *)creditsArray {
  return creditsArray;
}
- (void) setCreditsArray:(NSArray *)arg {
  if (arg != creditsArray) {
    [creditsArray release];
    creditsArray = [arg mutableCopy];
  }
}



//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:nameTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:phoneTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:emailTextField];
  
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:companyTextField];
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:addressTextField];
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:addressStateTextField];
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:cityTextField];
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:zipTextField];  

  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:membershipTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:balanceTextField];
  
  [nc addObserver:self
         selector:@selector(handleProjectsSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:projectsSearchField];
  
  [nc addObserver:self
         selector:@selector(handleContactsSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:contactsSearchField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:contactCookTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:contactSubjectTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:contactNoteTextView];
  
  [nc addObserver:self
         selector:@selector(handleContactsTableViewSelectionChange:)
             name:NSTableViewSelectionDidChangeNotification
           object:contactsTableView];
  
  [nc addObserver:self
         selector:@selector(handleInvoicesSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:invoicesSearchField];
  
  [nc addObserver:self
         selector:@selector(handleCreditsSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:creditsSearchField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:creditCookTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:creditAmountTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:creditReasonTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:creditNoteTextView];
  
  [nc addObserver:self
         selector:@selector(handleCreditsTableViewSelectionChange:)
             name:NSTableViewSelectionDidChangeNotification
           object:creditsTableView];
  
  
  [nc addObserver:self
         selector:@selector(handleProjectsChange:)
             name:[[Projects sharedInstance] notificationChangeString]
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleCustomerContactsChange:)
             name:[[Contacts sharedInstance] notificationChangeString]
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleInvoicesChange:)
             name:[[Invoices sharedInstance] notificationChangeString]
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleCreditsChange:)
             name:[[Credits sharedInstance] notificationChangeString]
           object:nil];
  
}


@end