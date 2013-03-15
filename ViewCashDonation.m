// 
// ViewCashDonation.m
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import "ViewCashDonation.h"
#import "Person.h"
#import "Donations.h"
#import "CashDonationArchiver.h"

@implementation ViewCashDonation

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"ViewCashDonation"];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [donation release];
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
}

//******************************************************************************

- (void)setupForModal {
   [super setupForModal];
   [self setupButtons];
   [self setupTextFields];
   [self setupTables];
   [self setupStateVariables];
}

//******************************************************************************

- (void)setupForNonModal {
   [super setupForNonModal];
   [self setupButtons];
   [self setupTextFields];
   [self setupTables];
   [self setupStateVariables];
}

//******************************************************************************

- (void)runModalWithParent:(NSWindow *) parent {
   [super runModalWithParent:parent];
}


//******************************************************************************
// setup
//******************************************************************************

- (void)setupButtons {
}

//******************************************************************************

- (void)setupTextFields {
  Person *p = [donation personForDonation];
  [donorTextField setStringValue:[p personName]];
  [companyTextField setStringValue:[p companyName]];
  [addressTextField setStringValue:[p address]];
  [cityTextField setStringValue:[p city]];
  [stateTextField setStringValue:[p addressState]];
  [zipTextField setStringValue:[p zip]];
  [phoneTextField setStringValue:[p phoneNumber]];
  NSCalendarDate *date = [donation date];
  [dateTextField setStringValue:[date descriptionWithCalendarFormat:@"%m/%d/%Y"]];
  [emailTextField setStringValue:[p emailAddress]];
  [cookTextField setStringValue:[donation cookNameOrInitials]];
  [creditTextField setDoubleValue:[donation donationAmount]];
  
}

//******************************************************************************

- (void)setupTables {
}

//******************************************************************************

- (void)setupStateVariables {
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)thankYouButtonClicked:(id)sender {
  //NSLog(@"thankYouButton clicked");
  if ([thankYouButton state] == 1) {
    [donation setSentThankYou:YES];
  } else {
    [donation setSentThankYou:NO];
  }
  [[Donations sharedInstance] saveToDisk];
}

//******************************************************************************

- (IBAction)cancelButtonClicked:(id)sender {
    //NSLog(@"cancelButton clicked");
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }  
}

//******************************************************************************

- (IBAction)printFormButtonClicked:(id)sender {
  //NSLog(@"printFormButton clicked");
  [self showProgressPanel:@"Printing..."];
  [[CashDonationArchiver sharedInstance] printInKindDonation:[self donation]];
  [self closeProgressPanel];
  
}

//******************************************************************************



//******************************************************************************
// misc
//******************************************************************************



//******************************************************************************
// handlers
//******************************************************************************



//******************************************************************************
// accessors and setters
//******************************************************************************

- (Donation *)donation {
  return donation;
}
- (void) setDonation:(Donation *)arg {
  [arg retain];
  [donation release];
  donation = arg;
}



//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
     NSNotificationCenter *nc;
     nc = [NSNotificationCenter defaultCenter];

}
@end