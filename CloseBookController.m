//
//  CloseBookController.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/18/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "CloseBookController.h"
#import "Books.h"
#import "Book.h"
#import "DebitOrCredit.h"
#import "DebitsAndCredits.h"
#import "Check.h"
#import "Checks.h"
#import "Invoice.h"
#import "Invoices.h"
#import "Product.h"
#import "ShopCredit.h"
#import "Credits.h"
#import "BookArchiver.h"

@implementation CloseBookController

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self =  [super initWithWindowNibName:@"CloseBook"]; 
  }
  return self;
}

- (void) dealloc {
  [checksArray release];
  [cardsArray release];
  [creditsArray release];
  [formAndStepper release];
  [super dealloc];
}


// windowing
- (void)windowDidLoad {
  [self initFormsAndSteppers];
  [self doSetup];
  [super windowDidLoad];
}

- (void)setupForModal {
  [self doSetup];
  [super setupForModal];
}

- (void)setupForNonModal {
  [self doSetup];
  [super setupForNonModal];
}

- (void)doSetup {
  [pwcTitleTextField setStringValue:@"Pull the Starting Balance"];
  [cashTotalsTextField setDoubleValue:0.0];
  [self setupButtons];
  [self clearTextFields];
  [self clear1DForm:cashForm];
  [self resetFormsAndSteppers];
  [self setChecksCardsInvoicesAndTotals];
}


- (void)setChecksCardsInvoicesAndTotals {
  [[totalsForm cellAtIndex:0] setDoubleValue:0.0];
  
  Book *journal = [[Books sharedInstance] currentBook];
  [self setChecksArray:[[Checks sharedInstance] objectsForUids:[journal checkUids]]];
  double checkSum = 0.0;
  unsigned int i, count = [checksArray count];
  for (i = 0; i < count; i++) {
    Check *check = (Check *)[checksArray objectAtIndex:i];
    checkSum = checkSum + [check checkAmount];
  }
  //NSLog(@"checksArray: %@", checksArray);
	//NSLog(@"checkSum: %1.2f", checkSum);
  [[totalsForm cellAtIndex:1] setDoubleValue:checkSum];
  
  [self setCardsArray:[[DebitsAndCredits sharedInstance] objectsForUids:[journal debitUids]]];
  double cardSum = 0.0;
  count = [cardsArray count];
  for (i = 0; i < count; i++) {
    DebitOrCredit *debit = (DebitOrCredit *)[cardsArray objectAtIndex:i];
    cardSum += [debit debitAmount];
  }
  
  [[totalsForm cellAtIndex:2] setDoubleValue:cardSum];

  [self setCreditsArray:[[Credits sharedInstance] objectsForUids:[journal creditUids]]];
  double creditSum = 0.0;
  count = [creditsArray count];
  for (i = 0; i < count; i++) {
    ShopCredit *crd = (ShopCredit *)[creditsArray objectAtIndex:i];
    creditSum += [crd creditAmount];
  }
  
  [[totalsForm cellAtIndex:3] setDoubleValue:creditSum];
  
  
  [[totalsForm cellAtIndex:4] setDoubleValue:cardSum + checkSum + creditSum];
  
  double invoiceSum = 0.0;
  NSArray *invoices = [[Invoices sharedInstance] objectsForUids:[journal invoiceUids]];
  count = [invoices count];
  for (i = 0; i < count; i++) {
    Invoice *inv = (Invoice *)[invoices objectAtIndex:i];
    invoiceSum += [inv invoiceTotal];
  }
  
  [[totalsForm cellAtIndex:5] setDoubleValue:invoiceSum];
  
  [[totalsForm cellAtIndex:6] setDoubleValue:[self actualTotal] - [self expectedTotal]];
  
  [pulledStartingBalanceButton setTitle:[NSString stringWithFormat:@"Starting balance of $%1.2f has been pulled",
    [journal startingBalance]]];
}


- (double)totalCash {
  return [[totalsForm cellAtIndex:0] doubleValue];
}

- (double)totalCheck {
  return [[totalsForm cellAtIndex:1] doubleValue];
}

- (double)totalCards {
  return [[totalsForm cellAtIndex:2] doubleValue];
}

- (double)totalCredits {
  return [[totalsForm cellAtIndex:3] doubleValue];
}

- (double)actualTotal {
  return [self totalCash] + [self totalCheck] + [self totalCards] + [self totalCredits];
}

- (double)expectedTotal {
  return [[totalsForm cellAtIndex:5] doubleValue];
}

- (double)variance {
  return [[totalsForm cellAtIndex:6] doubleValue];
}


- (NSArray *)arrayWithCell:(NSFormCell *)cell stepper:(NSStepper *)stepper 
                 textField:(NSTextField *) tf scalar:(NSNumber *)num  {
  NSMutableArray *tmp = [[NSMutableArray alloc] init];
  [tmp insertObject:cell atIndex:0];
  [tmp insertObject:stepper atIndex:1];
  [tmp insertObject:tf atIndex:2];
  [tmp insertObject:num atIndex:3];
  NSArray *returnVal = [NSArray arrayWithArray:tmp];
  [tmp release];
  return returnVal;
}



- (void)initFormsAndSteppers {
  NSMutableDictionary *fas = [[NSMutableDictionary alloc] init];
  [fas setObject:[self arrayWithCell:[cashForm cellAtIndex:0]
                             stepper:hundredsStepper
                           textField:hundredsTextField
                              scalar:[NSNumber numberWithInt:100]]
          forKey:@"hundreds"];
  
  [fas setObject:[self arrayWithCell:[cashForm cellAtIndex:1]
                             stepper:fiftiesStepper
                           textField:fiftiesTextField
                              scalar:[NSNumber numberWithInt:50]]
          forKey:@"fifties"];
  
  [fas setObject:[self arrayWithCell:[cashForm cellAtIndex:2]
                             stepper:twentiesStepper
                           textField:twentiesTextField
                              scalar:[NSNumber numberWithInt:20]]
          forKey:@"twenties"];


  [fas setObject:[self arrayWithCell:[cashForm cellAtIndex:3]
                             stepper:tensStepper
                           textField:tensTextField
                              scalar:[NSNumber numberWithInt:10]]
          forKey:@"tens"];
  
  [fas setObject:[self arrayWithCell:[cashForm cellAtIndex:4]
                             stepper:fivesStepper
                           textField:fivesTextField
                              scalar:[NSNumber numberWithInt:5]]
          forKey:@"fives"];

  [fas setObject:[self arrayWithCell:[cashForm cellAtIndex:5]
                             stepper:twosStepper
                           textField:twosTextField
                              scalar:[NSNumber numberWithInt:2]]
          forKey:@"twos"];
  
  [fas setObject:[self arrayWithCell:[cashForm cellAtIndex:6]
                             stepper:onesStepper
                           textField:onesTextField
                              scalar:[NSNumber numberWithInt:1]]
          forKey:@"ones"];
  [self setFormAndStepper:fas];
  [fas release];
}

- (void)resetFormsAndSteppers {
  NSEnumerator *e = [formAndStepper objectEnumerator];
  NSArray *val;
  while (val = (NSArray *)[e nextObject]) {
    NSFormCell *cell = [val objectAtIndex:0];
    [cell setDoubleValue:0.0];
    NSStepper *stp = [val objectAtIndex:1];
    [stp setDoubleValue:0.0];
    NSTextField *tf = [val objectAtIndex:2];
    [tf setDoubleValue:0.0];
  }
}


- (void)setupButtons {
  [pwcBackButton setEnabled:NO];
  [pwcNextButton setEnabled:NO];
  [pwcNextButton setHidden:NO];
  [self hideAndDisableButton:printAndSaveButton];
  [printAndSaveButton setState:0];
  
  [pulledStartingBalanceButton setState:0];
  [pulledStartingBalanceButton setTitle:@""];
  
  NSCalendarDate *today = [NSCalendarDate calendarDate];
  int numHours;
  int numCooks;
  int day = [today dayOfWeek];
  
  if (day == 0 || day == 6) {
    numHours = 6;
    numCooks = 8;
  } else if (day == 1) {
    numHours = 10;
    numCooks = 4;
  } else {
    numHours = 3;
    numCooks = 3;
  }
  [numCooksStepper setIntValue:numCooks];
  [numHoursStepper setIntValue:numHours];
  [numCooksTextField setIntValue:[numCooksStepper intValue]];
  [numHoursTextField setIntValue:[numHoursStepper intValue]];
  int total = [numCooksTextField intValue] * [numHoursTextField intValue];
  [numVolunteerHours setIntValue:total];
  
  [verfiedCardsButton setState:0];
  [verfiedChecksButton setState:0];
  [verfiedCreditsButton setState:0];
  
  Book *cb = [[Books sharedInstance] currentBook];
  
  [clientsStepper setIntValue:[cb numberOfClients]];
  [numClientsTextField setIntValue:[cb numberOfClients]];
}

- (void)clearTextFields {
  [self clearTextField:initialsTextField];
}

- (void)runModalWithParent:(NSWindow *) parent {
  [super runModalWithParent:parent];
}


- (void)handleTextFieldChange:(NSNotification *)note {
//  if ([[self window] isKeyWindow]) {
//    if ([[note object] isKindOfClass:[NSTextField class]]) {
//      NSTextField *tf = (NSTextField *)[note object];
//      if (tf != initialsTextField) {
//        if ([self textFieldIsEmpty:tf]) {
//          [pwcNextButton setEnabled:NO];
//        } else {
//          [pwcNextButton setEnabled:YES];
//        }
//      } else {
//        if ([self textFieldIsEmpty:tf]) {
//          [printAndSaveButton setEnabled:NO];
//          [printAndSaveButton setState:0];
//        } else {
//          [printAndSaveButton setEnabled:YES];
//          [printAndSaveButton setState:1];
//        }
//      }
//    }
//  }
//
  if ([[self window] isKeyWindow]) {
    if ([[note object] isKindOfClass:[NSTextField class]]) {
      NSTextField *tf = (NSTextField *)[note object];
      if (tf == initialsTextField) {
        if ([self textFieldIsEmpty:tf]) {
          [printAndSaveButton setEnabled:NO];
          [printAndSaveButton setState:0];
        } else {
          [printAndSaveButton setEnabled:YES];
          [printAndSaveButton setState:1];
        }
      }
    }
  }
}
      
 
// actions
- (IBAction)hundredsStepperClicked:(id)sender {
  [self stepperClicked];
}

- (IBAction)fiftiesStepperClicked:(id)sender {
  [self stepperClicked];
}

- (IBAction)twentiesStepperClicked:(id)sender {
  [self stepperClicked];
}

- (IBAction)tensStepperClicked:(id)sender {
  [self stepperClicked];
}

- (IBAction)fivesStepperClicked:(id)sender {
  [self stepperClicked];
}

- (IBAction)twosStepperClicked:(id)sender {
  [self stepperClicked];
}

- (IBAction)onesStepperClicked:(id)sender {
  [self stepperClicked];
}

- (void)stepperClicked {
  double cashTotal = 0.0;
  NSEnumerator *e  = [formAndStepper objectEnumerator];
  NSArray *val;
  while (val = (NSArray *)[e nextObject]) {
    NSFormCell *cell = [val objectAtIndex:0];
    NSStepper *stp = [val objectAtIndex:1];
    NSTextField *tf = [val objectAtIndex:2];
    int scalar = [[val objectAtIndex:3] intValue];
    double product = scalar * [stp intValue];
    [tf setDoubleValue:product];
    [cell setIntValue:[stp intValue]];
    cashTotal += product;
  }
  [cashTotalsTextField setDoubleValue:cashTotal];
  [[totalsForm cellAtIndex:0] setDoubleValue:cashTotal];
  double actual = ([self totalCash] + [self totalCheck] + [self totalCards] + [self totalCredits]);
  [[totalsForm cellAtIndex:4] setDoubleValue:actual];
  [[totalsForm cellAtIndex:6] setDoubleValue:[self actualTotal] - [self expectedTotal]];
}

- (IBAction)printAndSaveButtonClicked:(id)sender {
	[self showProgressPanel:@"Printing..."];
  ////NSLog(@"printAndSaveButton clicked");
  Book *journal = [[Books sharedInstance] currentBook];

  [journal setActualTotal:[self actualTotal]];
  [journal setExpectedTotal:[self expectedTotal]];
  [journal setVariance:[self variance]];
  [journal setTotalChecks:[self totalCheck]];
  [journal setTotalCards:[self totalCards]];
  [journal setTotalCredits:[self totalCredits]];
  [journal setTotalCash:[self totalCash]];
  [journal setCloserNameOrInitials:[self lowercaseAndLatexSafeStringFromTextField:initialsTextField]];
  [journal setHundreds:[[cashForm cellAtIndex:0] intValue]];
  [journal setFifties:[[cashForm cellAtIndex:1] intValue]];
  [journal setTwenties:[[cashForm cellAtIndex:2] intValue]];
  [journal setTens:[[cashForm cellAtIndex:3] intValue]];
  [journal setFives:[[cashForm cellAtIndex:4] intValue]];
  [journal setTwos:[[cashForm cellAtIndex:5] intValue]];
  [journal setOnes:[[cashForm cellAtIndex:6] intValue]];
  [journal setIsOpen:NO];

  NSArray *invs = [[Invoices sharedInstance] objectsForUids:[journal invoiceUids]];
  double taxable = 0.0;
  double untaxable = 0.0;
  double taxOwed = 0.0;
  double donations = 0.0;
  double paidHoursOfStandTime = 0.0;
  double unpaidHoursOfStandTime = [journal freeStandTime];
  int projects = 0;

  
  unsigned int i, count = [invs count];
  for (i = 0; i < count; i++) {
    Invoice *inv = (Invoice *)[invs objectAtIndex:i];
    taxable += [inv totalTaxableAmount];
    untaxable += [inv totalNonTaxableAmount];
    taxOwed += [inv taxOwed];
    donations += [inv amountOfDonationInInvoice];
    paidHoursOfStandTime += [inv hoursOfStandTime];
    if ([inv itemsContainsProjectP]) {
      projects++;
      Project *p = [inv projectForInvoice];
      if (p != nil) {
        unpaidHoursOfStandTime += [p standTime];
      }
    }
  }
  
//	NSLog(@"taxable: %1.2f", taxable);
//	NSLog(@"untaxable: %1.2f", untaxable);
//	NSLog(@"donations: %1.2f", donations);
//	NSLog(@"journal standTimeTotal: %1.2f", hoursOfStandTime);
//	NSLog(@"projects: %1.2f", projects);
//  NSLog(@"numClients: %d%", [numClientsTextField intValue]);
//  NSLog(@"numClients: %d%", [clientsStepper intValue]);
//  NSLog(@"numVolunteerHours: %d", [numVolunteerHours intValue]);
  
  [journal setTaxableTotal:taxable];
  [journal setUntaxableTotal:untaxable];
  [journal setTaxOwed:taxOwed];
  [journal setDonationsTotal:donations];
  [journal setStandTimeTotal:(paidHoursOfStandTime + unpaidHoursOfStandTime)];
  [journal setProjectsCompletedTotal:projects];
  [journal setVolunteerHoursTotal:[numVolunteerHours intValue]];
  [journal setNumberOfClients:[clientsStepper intValue]];
  
  
  [[Books sharedInstance] saveToDisk];
  
  [[Books sharedInstance] setCurrentBook:nil];

  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:@"TljJournalClosedNotification" object:self];  
    
  [[BookArchiver sharedInstance] archiveBook:journal andPrint:YES];
  
	[self closeProgressPanel];
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

- (IBAction)cancelButtonClicked:(id)sender {
  ////NSLog(@"cancelButton clicked");
  ////NSLog(@"runningModal: %d", runningModal);
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

- (IBAction)pulledStartingBalanceButtonClicked:(id)sender {
  ////NSLog(@"pulledStartingBalanceButton clicked");
  if ([pulledStartingBalanceButton state] == 1) {
    [pwcNextButton setEnabled:YES];
  } else {
    [pwcNextButton setEnabled:YES];
  }
}


- (IBAction)clientsStepperClicked:(id)sender {
  //NSLog(@"clientsStepper clicked");
  int clients = [clientsStepper intValue];
  [numClientsTextField setIntValue:clients];
  
}

- (IBAction)verfiedChecksButtonClicked:(id)sender {
  //NSLog(@"verfiedChecksButton clicked");
  if ([verfiedChecksButton state]) {
    [pwcNextButton setEnabled:YES];
    [pwcNextButton setState:1]; 
  } else {
    [pwcNextButton setEnabled:NO];
    [pwcNextButton setState:0]; 
  }  
}

- (IBAction)verfiedCardsButtonClicked:(id)sender {
  //NSLog(@"verfiedCardsButton clicked");
  if ([verfiedCardsButton state]) {
    [pwcNextButton setEnabled:YES];
    [pwcNextButton setState:1]; 
  } else {
    [pwcNextButton setEnabled:NO];
    [pwcNextButton setState:0]; 
  }  
}
- (IBAction)verfiedCreditsButtonClicked:(id)sender {
  //NSLog(@"verfiedCreditsButton clicked");
  if ([verfiedCreditsButton state]) {
    [pwcNextButton setEnabled:YES];
    [pwcNextButton setState:1]; 
  } else {
    [pwcNextButton setEnabled:NO];
    [pwcNextButton setState:0]; 
  }  
  
}

- (IBAction)clientsFiveButtonClicked:(id)sender {
  //NSLog(@"clientsFiveButton clicked");
  double new = [clientsStepper intValue] + 5;
  [clientsStepper setIntValue:new];
  [numClientsTextField setIntValue:new];
}
- (IBAction)clientsTenButtonClicked:(id)sender {
  //NSLog(@"clientsTenButton clicked");
  double new = [clientsStepper intValue] + 10;
  [clientsStepper setIntValue:new];
  [numClientsTextField setIntValue:new];
}
- (IBAction)clientsTwentyButtonClicked:(id)sender {
  //NSLog(@"clientsTwentyButton clicked");
  double new = [clientsStepper intValue] + 20;
  [clientsStepper setIntValue:new];
  [numClientsTextField setIntValue:new];  
}
- (IBAction)clientsClearButtonClicked:(id)sender {
  //NSLog(@"clientsClearButton clicked");
  [numClientsTextField setIntValue:0];
  [clientsStepper setIntValue:0];
}


- (IBAction)numCooksStepperClicked:(id)sender {
  ////NSLog(@"numCooksStepper clicked");
  [numCooksTextField setIntValue:[numCooksStepper intValue]];
  int total = [numCooksTextField intValue] * [numHoursTextField intValue];
  [numVolunteerHours setIntValue:total];
}

- (IBAction)numHoursStepperClicked:(id)sender {
 // //NSLog(@"numHoursStepper clicked");
  [numHoursTextField setIntValue:[numHoursStepper intValue]];
  int total = [numCooksTextField intValue] * [numHoursTextField intValue];
  [numVolunteerHours setIntValue:total];  
}


- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(handleTextFieldChange:)
             name:NSControlTextDidChangeNotification
           object:initialsTextField];
}
  
//accessors and setters
- (NSMutableArray *)checksArray {
  return checksArray;
}

- (void) setChecksArray:(NSArray *)arg {
  if (arg != checksArray) {
    [checksArray release];
    checksArray = [arg mutableCopy];
  }
}

- (NSMutableArray *)cardsArray {
  return cardsArray;
}

- (void) setCardsArray:(NSMutableArray *)arg {
  [arg retain];
  [cardsArray release];
  cardsArray = arg;
}

- (NSMutableDictionary *)formAndStepper {
  return formAndStepper;
}

- (void) setFormAndStepper:(NSDictionary *)arg {
  if (arg != formAndStepper) {
    [formAndStepper release];
    formAndStepper = [arg mutableCopy];
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


- (IBAction)pwcNextButtonClicked:(id)sender {
  //////NSLog(@"pwcNextButtonClicked");
 // //NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
  [super pwcNextButtonClicked:sender];
 // //NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
  [self showAndEnableButton:pwcBackButton];
  if (pwcCurrentStep == 6) {
    [printAndSaveButton setHidden:NO];
    [printAndSaveButton setEnabled:NO];
    [printAndSaveButton setState:0];
    [self hideAndDisableButton:pwcNextButton];
  }
}

- (IBAction)pwcBackButtonClicked:(id)sender {
 // //NSLog(@"pwcBackButtonClicked");
  if (pwcCurrentStep == 6) {
    [self showAndEnableButton:pwcNextButton];
    [self hideAndDisableButton:printAndSaveButton];
  }
  ////NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
  [super pwcBackButtonClicked:sender];
 // //NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
}


/******************************************************************************/

- (void)tabView:(NSTabView *)theTabView willSelectTabViewItem:
  (NSTabViewItem *)theTabViewItem {
  if (theTabView == pwcTabView) {
    [super tabView:theTabView willSelectTabViewItem:theTabViewItem];
    int currentView = [theTabView indexOfTabViewItem:theTabViewItem] ;
    if (currentView == 0) {
      [pwcTitleTextField setStringValue:@"Pull the Starting Balance"];
    } else if (currentView == 1) {
      [pwcTitleTextField setStringValue:@"Compute Volunteer Hours and Number of Clients"];
    } else if (currentView == 2) {
      [pwcTitleTextField setStringValue:@"Verify and Checks"];
    } else if (currentView == 3) {
      [pwcTitleTextField setStringValue:@"Verify Cards"];
    } else if (currentView == 4) {
      [pwcTitleTextField setStringValue:@"Verify Credits"];
    } else if (currentView == 5) {
      [pwcTitleTextField setStringValue:@"Tally Cash"];
    } else if (currentView == 6) {
      [pwcTitleTextField setStringValue:@"Verify and Initial Book"];
      if ([initialsTextField acceptsFirstResponder]) {
        [[self window] makeFirstResponder:initialsTextField];
      }      
    }
  }
  [self enableNextButtonWhenAppropriate:theTabViewItem];
}


/******************************************************************************/

- (void)enableNextButtonWhenAppropriate:(NSTabViewItem *)item {
  int currentView = [pwcTabView indexOfTabViewItem: item];
  if (currentView == 0) {
    if ([pulledStartingBalanceButton state] == 1) {
      [pwcNextButton setEnabled:YES];
      [pwcNextButton setState:1]; 
    } else {
      [pwcNextButton setEnabled:NO];
      [pwcNextButton setState:0]; 
    }
  } else if (currentView == 1) {
    [pwcNextButton setEnabled:YES];
    [pwcNextButton setState:1]; 
  } else if (currentView == 2) {
    if ([verfiedChecksButton state]) {
      [pwcNextButton setEnabled:YES];
      [pwcNextButton setState:1]; 
    } else {
      [pwcNextButton setEnabled:NO];
      [pwcNextButton setState:0]; 
    }
  } else if (currentView == 3) {
    if ([verfiedCardsButton state]) {
      [pwcNextButton setEnabled:YES];
      [pwcNextButton setState:1]; 
    } else {
      [pwcNextButton setEnabled:NO];
      [pwcNextButton setState:0]; 
    }
  } else if (currentView == 4) {
    if ([verfiedCreditsButton state]) {
      [pwcNextButton setEnabled:YES];
      [pwcNextButton setState:1]; 
    } else {
      [pwcNextButton setEnabled:NO];
      [pwcNextButton setState:0]; 
    }
  } else if (currentView == 5) {
    [pwcNextButton setEnabled:YES];
    [pwcNextButton setState:1]; 
  } else if (currentView == 6) {
    [pwcNextButton setHidden:YES];
    [pwcNextButton setEnabled:NO];
    [pwcNextButton setState:0]; 
    [printAndSaveButton setHidden:NO];
    [printAndSaveButton setKeyEquivalent:@"Return"];
    if (![self textFieldIsEmpty:initialsTextField]) {
      [printAndSaveButton setEnabled:YES];
      [printAndSaveButton setState:1];
    } else {
      [printAndSaveButton setEnabled:NO];
      [printAndSaveButton setState:0];
    }
  }
}

@end
