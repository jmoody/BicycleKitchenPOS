//
//  CreateCustomerController.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/21/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "CreateCustomerController.h"
#import "Person.h"
#import "People.h"
#import "Membership.h"
#import "Memberships.h"

@implementation CreateCustomerController

- (id)init {
  self = [super init];
  if (self != nil) {
    self =  [super initWithWindowNibName:@"CreateCustomer"];
    bypassDuplicatePerson = NO;
  }
  return self;
}

- (void)awakeFromNib {
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [mainWindow release];
  [peopleArrayController release];
  [super dealloc];
}

- (void)setMainWindow:(NSWindow *)mainAppWindow {
  [mainAppWindow retain];
  [mainWindow release];
  mainWindow = mainAppWindow;
}

- (bool)bypassDuplicatePerson {
  return bypassDuplicatePerson;
}

- (void)setBypassDuplicatePerson:(bool)bypass {
  bypassDuplicatePerson = bypass;
}

- (void)setPeopleArrayController:(NSArrayController *)ac {
  [ac retain];
  [peopleArrayController release];
  peopleArrayController = ac;
}

//******************************************************************************
// create person methods
//******************************************************************************

- (IBAction)createCustomerCancelButtonClicked:(id)sender {
  NSString *emptyString = [NSString stringWithFormat:@""];
  [createCustomerNameTextField setStringValue:emptyString];
  [createCustomerPhoneTextField setStringValue:emptyString];
  [createCustomerEmailTextField setStringValue:emptyString];
  [createCustomerFailedTextField setStringValue:emptyString];
  [NSApp stopModal];
}

//******************************************************************************

- (void)runCreateCustomerModal {
  [NSApp beginSheet:[self window]
     modalForWindow:mainWindow
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];
  
  [NSApp runModalForWindow:[self window]];
  
  [NSApp endSheet:[self window]];
  [[self window] orderOut:self];
  if ([createCustomerNameTextField acceptsFirstResponder]) {
    [[self window] makeFirstResponder:createCustomerNameTextField];
  }
}

//******************************************************************************

- (IBAction)createCustomerAddButtonClicked:(id)sender {
  NSString *newName = [self lowercaseAndLatexSafeStringFromTextField:createCustomerNameTextField];
  NSString *newPhone = [createCustomerPhoneTextField stringValue];
  NSString *newEmail = [self lowercaseAndLatexSafeStringFromTextField:createCustomerEmailTextField];
  
  // requires a release
  Person *newPerson = [[Person alloc] init];
  
  [newPerson setPersonName:newName];
  [newPerson setPhoneNumber:newPhone];
  [newPerson setEmailAddress:newEmail];
	
  bool badPerson = [[People sharedInstance] personNameAppearsInPeopleInSingleton:newPerson];
  bool badPhone = [[People sharedInstance] phoneNumberIsBadlyFormatted:newPhone];
  bool badEmail = [[People sharedInstance] emailAddressAppearsInPeopleInSingleton:newPerson];
  

  
  if (badPerson && (!bypassDuplicatePerson)) {
    [self runBadPersonWithPerson:newPerson andBadPhone:badPhone andBadEmail:badEmail];
  } else if (badPhone) {  
    [self runBadPhoneWithPerson:newPerson];
  } else if (badEmail) {
    [self runBadEmailWithPerson:newPerson];
  } else {
    [self runAddPersonWithPerson:newPerson];
  }
}

//******************************************************************************

- (void)runBadPersonWithPerson:(Person *)p andBadPhone:(bool)badPhone andBadEmail:(bool)badEmail {
  NSString *emptyString = [NSString stringWithFormat:@""];
  NSString *failMessage = [NSString stringWithFormat:@"%@ already exists.", [p personName]];
  NSString *message = 
    [NSString stringWithFormat:@"Person with name %@ already exists.",[p personName]];
  NSString *duplicatePeopleString =
    [[People sharedInstance] alertMessageForDuplicatePersonsInCustomerAdd:p];
  message = [message stringByAppendingString:[NSString stringWithFormat:@"\n%@", duplicatePeopleString]];
  int choice = NSRunAlertPanel(@"Duplicate Name", message, @"Cancel", @"Continue Add",nil);
  //int choice = NSRunAlertPanel(@"Duplicate Name", message, @"Try Again", @"Continue Add",@"Cancel");
  
  // try again = 1, cancel = -1, continue add = 0
  if (choice == 1) {
    [createCustomerFailedTextField setStringValue:failMessage]; 
    if ([createCustomerNameTextField acceptsFirstResponder]) {
      [[self window] makeFirstResponder:createCustomerNameTextField];
    }
    [NSApp stopModal];
    // releae the person
    [p release];
    // rerun create customer
    [self runCreateCustomerModal];
  } else if (choice == 0) {
    bypassDuplicatePerson = YES;
    if (badPhone) {
      [self runBadPhoneWithPerson:p];
    } else if (badEmail) {
      [self runBadEmailWithPerson:p];
    } else {
      [self runAddPersonWithPerson:p];
    }
  } else {
    // release the person
    [p release];
    [NSApp stopModal];
    [createCustomerFailedTextField setStringValue:emptyString];
    [createCustomerNameTextField setStringValue:emptyString];
    [createCustomerPhoneTextField setStringValue:emptyString];
    [createCustomerEmailTextField setStringValue:emptyString];
  }
}

//******************************************************************************

- (void)runBadPhoneWithPerson:(Person *)p {
  [NSApp stopModal];
  
  [p setPersonName:[self lowercaseAndLatexSafeStringFromTextField:createCustomerNameTextField]];
  [p setPhoneNumber:[self lowercaseAndLatexSafeStringFromTextField:createCustomerPhoneTextField]];
  [p setEmailAddress:[self lowercaseAndLatexSafeStringFromTextField:createCustomerEmailTextField]];
  
  NSString *emptyString = [NSString stringWithFormat:@""];
  NSString *failMessage = [NSString stringWithFormat:@"%@ is badly formated", [p phoneNumber]];
  NSString *message = [NSString stringWithFormat:@"Phone number %@ is badly formatted", [p phoneNumber]];
  //int choice = NSRunAlertPanel(@"Bad Phone Number", message, @"Try Again", @"Cancel", nil);
  int choice = NSRunAlertPanel(@"Bad Phone Number", message, @"Cancel", @"Cancel Add", nil);
  //int choice = NSRunAlertPanel(@"Bad Phone Number", message, @"Try Again", @"Cancel", nil);
  if (choice == 1) {
    [createCustomerFailedTextField setStringValue:failMessage];
    if ([createCustomerPhoneTextField acceptsFirstResponder]) {
      [[self window] makeFirstResponder:createCustomerPhoneTextField];
    } 
    // release the person
    [p release];
    // rerun create customer
    [self runCreateCustomerModal];
  } else {
    // release the person
    [p release];
    [createCustomerFailedTextField setStringValue:emptyString];
    [createCustomerNameTextField setStringValue:emptyString];
    [createCustomerPhoneTextField setStringValue:emptyString];
    [createCustomerEmailTextField setStringValue:emptyString];
  }
}

//******************************************************************************

- (void)runBadEmailWithPerson:(Person *)p {
  [NSApp stopModal];
  
  [p setPersonName:[self lowercaseAndLatexSafeStringFromTextField:createCustomerNameTextField]];
  [p setPhoneNumber:[self lowercaseAndLatexSafeStringFromTextField:createCustomerPhoneTextField]];
  [p setEmailAddress:[self lowercaseAndLatexSafeStringFromTextField:createCustomerEmailTextField]];
  
  NSString *emptyString = [NSString stringWithFormat:@""];
  NSString *message = 
    [NSString stringWithFormat:@"Person with email %@ already exists.", [p emailAddress]];
  NSString *failMessage = [NSString stringWithFormat:@"%@ already exists", [p emailAddress]];
  int choice = NSRunAlertPanel(@"Duplicate Email Address", message, @"Cancel", @"Cancel Add", nil);
//  int choice = NSRunAlertPanel(@"Duplicate Email Address", message, @"Try Again", @"Cancel", nil);
  
  if (choice == 1) {
    [createCustomerFailedTextField setStringValue:failMessage];
    if ([createCustomerPhoneTextField acceptsFirstResponder]) {
      [[self window] makeFirstResponder:createCustomerPhoneTextField];
    } 
    [p release];
    // rerun create customer
    [self runCreateCustomerModal];
  } else {
    [p release];
    [createCustomerFailedTextField setStringValue:emptyString];
    [createCustomerNameTextField setStringValue:emptyString];
    [createCustomerPhoneTextField setStringValue:emptyString];
    [createCustomerEmailTextField setStringValue:emptyString];
  }
}

//******************************************************************************

- (void)runAddPersonWithPerson:(Person *)p {
  [NSApp stopModal];
  
  [p setPersonName:[self lowercaseAndLatexSafeStringFromTextField:createCustomerNameTextField]];
  [p setPhoneNumber:[self lowercaseAndLatexSafeStringFromTextField:createCustomerPhoneTextField]];
  [p setEmailAddress:[self lowercaseAndLatexSafeStringFromTextField:createCustomerEmailTextField]];
	
	Membership *new = [[Membership alloc] init];
	[new setPersonUid:[p uid]];
  
	[p setMembershipUid:[new uid]];
  [[Memberships sharedInstance] setObject:new forUid:[new uid]];
  [[People sharedInstance] setObject:p forUid:[p uid]];
  [[People sharedInstance] saveToDisk];

  [new release];
  [p release];
  NSString *emptyString = [NSString stringWithFormat:@""];
  
  [peopleArrayController insertObject:p atArrangedObjectIndex:0];
  [createCustomerFailedTextField setStringValue:emptyString];
  [createCustomerNameTextField setStringValue:emptyString];
  [createCustomerPhoneTextField setStringValue:emptyString];
  [createCustomerEmailTextField setStringValue:emptyString];
  
}


@end
