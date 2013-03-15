//
//  AcceptInKindDonation.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "AcceptInKindDonation.h"
#import "People.h"
#import "InKindDonations.h"
#import "InKindDonationItem.h"
#import "InKindDonationArchiver.h"

@implementation AcceptInKindDonation

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"AcceptInKindDonation"];
    [self setMonetaryAmount:0.0];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [itemsArray release];
  [clientSelector release];
  [person release];
  [inKindDonation release];
  [super dealloc];
}

//******************************************************************************
// windowing
//******************************************************************************

- (void)windowDidLoad {
  [super windowDidLoad];
//  
//  [self setupButtons];
//  [self setupTextFields];
//  [self setupTables];
//  [self setupStateVariables];
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];

  [self hideAndDisableButton:newButton];
  [self hideAndDisableButton:deleteButton];
  [self showAndEnableButton:printButton];

	[cookTextField setStringValue:[inKindDonation cookNameOrInitials]];
  [nameTextField setStringValue:[person personName]];
  [phoneTextField setStringValue:[person phoneNumber]];
  [emailTextField setStringValue:[person emailAddress]];
  [companyTextField setStringValue:[person companyName]];
  [addressTextField setStringValue:[person address]];
  [stateTextField setStringValue:[person addressState]];
  [zipTextField setStringValue:[person zip]];
  [datePicker setDateValue:[inKindDonation date]];
  [datePicker setEnabled:NO];
  
  [self setItemsArray:[inKindDonation items]];
	
	
	
  [cookTextField setEditable:NO];
  [companyTextField setEditable:NO];
  [addressTextField setEditable:NO];
  [cityTextField setEditable:NO];
  [stateTextField setEditable:NO];
  [zipTextField setEditable:NO];
  [phoneTextField setEditable:NO];
  [emailTextField setEditable:NO];
	
	
//	NSLog(@"inKindDonation: %@", inKindDonation);
//	NSLog(@"person: %@", person);
	
//  [cookTextField setStringValue:[inKindDonation cookNameOrInitials]];
//  [nameTextField setStringValue:[person personName]];
//  [phoneTextField setStringValue:[person phoneNumber]];
//  [emailTextField setStringValue:[person emailAddress]];
//  [companyTextField setStringValue:[inKindDonation companyName]];
//  [addressTextField setStringValue:[inKindDonation address]];
//  [stateTextField setStringValue:[inKindDonation theState]];
//  [zipTextField setStringValue:[inKindDonation zip]];
//  [datePicker setDateValue:[inKindDonation date]];
//  [datePicker setEnabled:NO];
//  
//  [self setItemsArray:[inKindDonation items]];
  
}

//******************************************************************************

- (void)setupForNonModal {
  [super setupForNonModal];
  [self setupButtons];
  
  [cancelButton setHidden:NO];
  [saveButton setHidden:NO];
  
  [self setupTextFields];
  [cookTextField setEditable:YES];
  [companyTextField setEditable:YES];
  [addressTextField setEditable:YES];
  [cityTextField setEditable:YES];
  [stateTextField setEditable:YES];
  [zipTextField setEditable:YES];
  [phoneTextField setEditable:YES];
  [emailTextField setEditable:YES];
  
  [self setupTables];
  [self setupStateVariables];
  
}

//******************************************************************************

- (void)runMonetaryWarning {
  int choice = NSRunAlertPanel(@"Warning!",@"DO NOT use this this form to accept a MONETARY donation.  To accept a donation by cash, check, or card create an invoice and sell the client a donation.",
                               @"Continue", @"Cancel", nil);
  if (choice == 0) {
    [self cancelButtonClicked:self];
  }
}


//******************************************************************************

- (void)runModalWithParent:(NSWindow *) parent {
  [super runModalWithParent:parent];
}


//******************************************************************************
// setup
//******************************************************************************

- (void)setupButtons {
  [printButton setEnabled:NO];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
}

//******************************************************************************

- (void)setupTextFields {
//  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//  double minAmount = [[defaults objectForKey:TljBkPosMinMonetaryInKindDonation] doubleValue];
//  NSString *instr = [NSString stringWithFormat:@"To accept a monetary donation, create an invoice and\nsell a donation.  Note that a monetary donation needs\nto be at least $%1.2f to be considered \"in kind\".",
//    minAmount];
//  [instructionsTextField setStringValue:instr];
  [self clearTextField:descriptionTextField];
  [self clearTextField:cookTextField];

  [self clearTextField:nameTextField];
  [self clearTextField:companyTextField];
  [self clearTextField:addressTextField];
  [self clearTextField:cityTextField];
  [self clearTextField:stateTextField];
  [self clearTextField:zipTextField];
  [self clearTextField:phoneTextField];
  [self clearTextField:emailTextField];
  
}

//******************************************************************************

- (void)setupTables {
  NSArray *tmp = [[NSArray alloc] init];
  [self setItemsArray:tmp];
  [tmp release];
}

//******************************************************************************

- (void)setupStateVariables {
  [self setPerson:nil];
  [self setInKindDonation:nil];
}

//******************************************************************************

- (IBAction)showPersonSelector:(id)sender {
  if (clientSelector == nil) {
    PersonSelector *tmp = [[PersonSelector alloc] init];
    [self setClientSelector:tmp];
    [tmp release];
  }
  [clientSelector setupForModal];
  [clientSelector runModalWithParent:[self window]];
  Person *tmp = [clientSelector person];
  if (tmp != nil) {
    if ([[tmp personName] isEqualToString:@"quick sale"]) {
      NSRunAlertPanel(@"Operation Not Permitted",
                      @"You must select a customer with name.",
                      @"Try Again", nil, nil);
      [self showPersonSelector:self];
    } else {
      [self setPerson:tmp];
      [nameTextField setStringValue:[person personName]];
      [phoneTextField setStringValue:[person phoneNumber]];
      [emailTextField setStringValue:[person emailAddress]];
      [companyTextField setStringValue:[person companyName]];
      [addressTextField setStringValue:[person address]];
      [cityTextField setStringValue:[person city]];
      [stateTextField setStringValue:[person addressState]];
      [zipTextField setStringValue:[person zip]];
      [self enablePrintButtonAppropriately];
    }
  }
}

//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)newButtonClicked:(id)sender {
  [NSApp beginSheet:itemPanel
     modalForWindow:[self window]
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];
  
  [NSApp runModalForWindow:[self window]];
  
  [NSApp endSheet:itemPanel];
  [itemPanel orderOut:self];
  
}

//******************************************************************************

- (IBAction)saveButtonClicked:(id)sender {
  //NSLog(@"saveButton clicked");
  if (![self textFieldIsEmpty:descriptionTextField]) {
    NSMutableArray *newItems = [NSMutableArray arrayWithArray:itemsArray];
    InKindDonationItem *newItem = [[InKindDonationItem alloc] init];
    [newItem setItem:[self lowercaseAndLatexSafeStringFromTextField:descriptionTextField]];
    [newItems addObject:newItem];
    [self setItemsArray:newItems];
    [newItem release];
    [itemsTableView reloadData];  
    [NSApp stopModal];
    [itemPanel close];
    [self clearTextField:descriptionTextField];
    [self enablePrintButtonAppropriately];
  }
}

//******************************************************************************

- (IBAction)deleteButtonClicked:(id)sender {
  //NSLog(@"deleteButton clicked");
}

//******************************************************************************

- (IBAction)printButtonClicked:(id)sender {
  //NSLog(@"printButton clicked");
  
  [self showProgressPanel:@"Printing..."];
  if (inKindDonation == nil) {

    InKindDonation *new = [[InKindDonation alloc] init];
    [self setInKindDonation:new];
    [new setItems:itemsArray];
    [new setDonorUid:[person uid]];
    [person setCompanyName:[self lowercaseAndLatexSafeStringFromTextField:companyTextField]];
    [person setAddress:[self lowercaseAndLatexSafeStringFromTextField:addressTextField]];
    [person setCity:[self lowercaseAndLatexSafeStringFromTextField:cityTextField]];
    [person setAddressState:[self lowercaseAndLatexSafeStringFromTextField:stateTextField]];
    [person setZip:[self lowercaseAndLatexSafeStringFromTextField:zipTextField]];
    [new setDate:[self calendarDateFromDatePicker:datePicker]];
    [new setDonationAmount:[self monetaryAmount]];
    [new setCookNameOrInitials:[cookTextField stringValue]];
    [[person inKindDonationUids] addObject:[new uid]];
    [person setEmailAddress:[self lowercaseAndLatexSafeStringFromTextField:emailTextField]];
    [person setPhoneNumber:[phoneTextField stringValue]];
    
    //NSLog(@"in kind donations: %@", [[InKindDonations sharedInstance] dictionary]);
    [[InKindDonations sharedInstance] setObject:new forUid:[new uid]];
    //NSLog(@"in kind donations: %@", [[InKindDonations sharedInstance] dictionary]);
    [[People sharedInstance] saveToDisk];
    //NSLog(@"items: %@", [new items]);
    
    [[InKindDonationArchiver sharedInstance] archiveDonation:new andPrint:YES];
    [new release];
    
    if (runningModal) {
      [self stopModalAndCloseWindow];
    } else {
      [[self window] close];
    }
  } else {
    [[InKindDonationArchiver sharedInstance] printInKindDonation:inKindDonation];
  }
  [self closeProgressPanel];
 
}

//******************************************************************************

- (IBAction)cancelButtonClicked:(id)sender {
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

//******************************************************************************
// misc
//******************************************************************************
- (void)enablePrintButtonAppropriately {
  if ([self textFieldIsEmpty:nameTextField] ||
      [self textFieldIsEmpty:addressTextField] ||
      [self textFieldIsEmpty:cityTextField] ||
      [self textFieldIsEmpty:stateTextField] ||
      [self textFieldIsEmpty:zipTextField] ||
      [self textFieldIsEmpty:phoneTextField] ||
      [self textFieldIsEmpty:cookTextField] ||
      [itemsArray count] == 0) {
    [printButton setEnabled:NO];
  } else {
    [printButton setEnabled:YES];
  }
}

//******************************************************************************
// handlers
//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    [self enablePrintButtonAppropriately];
  }
}

//******************************************************************************

- (void)handleItemsClicked:(id)sender {
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (NSMutableArray *)itemsArray {
  return itemsArray;
}
- (void) setItemsArray:(NSArray *)arg {
  if (arg != itemsArray) {
    [itemsArray release];
    itemsArray = [arg mutableCopy];
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
- (InKindDonation *)inKindDonation {
  return inKindDonation;
}
- (void) setInKindDonation:(InKindDonation *)arg {
  [arg retain];
  [inKindDonation release];
  inKindDonation = arg;
}
- (double)monetaryAmount {
  return monetaryAmount;
}
- (void) setMonetaryAmount:(double)arg {
  monetaryAmount = arg;
}
- (PersonSelector *)clientSelector {
  return clientSelector;
}
- (void)setClientSelector:(PersonSelector *)arg {
  [arg retain];
  [clientSelector release];
  clientSelector = arg;
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
           object:addressTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:cityTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:stateTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:zipTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:phoneTextField];

  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:cookTextField];
  
 
  
  
}
@end