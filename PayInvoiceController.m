// 
// PayInvoiceController.m
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import "PayInvoiceController.h"
#import "PreferenceController.h"
#import "MembershipInformation.h"
#import "Invoices.h"
#import "Project.h"
#import "Projects.h"
#import "Product.h"
#import "Products.h"
#import "People.h"
#import "InvoiceArchiver.h"
#import "ExpirationDateMaker.h"
#import "DebitOrCredit.h"
#import "DebitsAndCredits.h"
#import "Check.h"
#import "Checks.h"
#import "Donation.h"
#import "Donations.h"
#import "Books.h"
#import "ShopCredit.h"
#import "Credits.h"
#import "PreferenceController.h"

@implementation PayInvoiceController

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"PayInvoice"];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [person release];
  [invoice release];
  [acceptCashDonation release];
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
  // person is already defined, as is the invoice
  double total = [invoice invoiceTotal];
  [cashStepper setDoubleValue:0.0];
	
  if ([person willTakeCheckFrom]) {
    [checkStepper setMaxValue:total];
    [checkStepper setEnabled:YES];
    [checkTotalButton setEnabled:YES];
    [checkRemainingButton setEnabled:YES];
    [checkClearButton setEnabled:YES];
    [checkNumberTextField setEditable:YES];
    [checkNumberTextField setEnabled:YES];
  } else {
    [checkStepper setEnabled:NO];
    [checkTotalButton setEnabled:NO];
    [checkRemainingButton setEnabled:NO];
    [checkClearButton setEnabled:NO];
    [checkNumberTextField setEditable:NO];
    [checkNumberTextField setEnabled:NO];    
  }
  
  if ([person hasAvailableCredit]) {
    [creditStepper setEnabled:YES];
    [creditStepper setMaxValue:[self maxCreditAmountAllowed]];
    [creditTotalButton setEnabled:YES];
    [creditRemainingButton setEnabled:YES];
    [creditClearButton setEnabled:YES];
  } else {
    [creditStepper setEnabled:NO];
    [creditTotalButton setEnabled:NO];
    [creditRemainingButton setEnabled:NO];
    [creditClearButton setEnabled:NO];    
  }
  
  if ([self acceptingCreditCardsP] && ![self personIsQuickSale]) {
    [cardStepper setMaxValue:total];
    [cardStepper setEnabled:YES];
    [cardTotalButton setEnabled:YES];
    [cardRemainingButton setEnabled:YES];
    [cardClearButton setEnabled:YES];
  } else {
    [cardStepper setEnabled:NO];
    [cardTotalButton setEnabled:NO];
    [cardRemainingButton setEnabled:NO];
    [cardClearButton setEnabled:NO];
  }
  
  // don't enable these yet
  [cardBrandComboBox setEnabled:NO];
  [cardBrandComboBox setEditable:NO];
  [debitOrCreditComboBox setEnabled:NO];
  [debitOrCreditComboBox setEditable:NO];
  
  [expirationDatePicker setDateValue:[[ExpirationDateMaker sharedInstance] expirationDate]];
  // don't enable these yet
  [expirationDatePicker setEnabled:NO];
  

  [saveButton setEnabled:NO];
  [saveAndPrintButton setEnabled:NO];
  [clearFormButton setEnabled:YES];
  [goBackButton setEnabled:YES];
}

//******************************************************************************

- (void)setupTextFields {
  [personInformationTextField setStringValue:[person personName]];
  [cashTextField setDoubleValue:0.0];
  [self clearTextField:checkNumberTextField];
  // disable until appropriate
  [checkNumberTextField setEditable:NO];
  [checkNumberTextField setEnabled:NO];
  [checkTextField setDoubleValue:0.0];
  [creditAvailableTextField setDoubleValue:[person creditAvailable]];
  [creditTextField setDoubleValue:0.0];
  
  [self clearTextField:lastFourDigitsTextField];
  // disable until appropriate
  [lastFourDigitsTextField setEditable:NO];
  [lastFourDigitsTextField setEnabled:NO];
  
  [cardBrandComboBox setStringValue:@""];
  [debitOrCreditComboBox setStringValue:@""];
  
  [cardTextField setDoubleValue:0.0];
  if ([self acceptingCreditCardsP]) {
    [self clearTextField:cardMessageTextField];
  } else {
    [cardMessageTextField setStringValue:@"We do not accept cards at this time"];
  }
  [invoiceTextField setDoubleValue:[invoice invoiceTotal]];
  [self updateTotalReceived];
}

//******************************************************************************

- (void)setupTables {
  // noop
}

//******************************************************************************

- (void)setupStateVariables {
  // noop

}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)cashStepperClicked:(id)sender {
  //NSLog(@"cashStepper clicked");
  [cashTextField setDoubleValue:[cashStepper doubleValue]];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)fiveButtonClicked:(id)sender {
  //NSLog(@"fiveButton clicked");
  double new = [cashTextField doubleValue] + 5.0;
  [cashTextField setDoubleValue:new];
  [cashStepper setDoubleValue:new];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)tenButtonClicked:(id)sender {
  //NSLog(@"tenButton clicked");
  double new = [cashTextField doubleValue] + 10.0;
  [cashTextField setDoubleValue:new];
  [cashStepper setDoubleValue:new];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)twentyButtonClicked:(id)sender {
  //NSLog(@"twentyButton clicked");
  double new = [cashTextField doubleValue] + 20.0;
  [cashTextField setDoubleValue:new];
  [cashStepper setDoubleValue:new];
  [self updateTotalReceived];
  
}

//******************************************************************************

- (IBAction)fiftyButtonClicked:(id)sender {
  //NSLog(@"fiftyButton clicked");
  double new = [cashTextField doubleValue] + 50.0;
  [cashTextField setDoubleValue:new];
  [cashStepper setDoubleValue:new];
  [self updateTotalReceived];
  
}

//******************************************************************************

- (IBAction)hundredButtonClicked:(id)sender {
  //NSLog(@"hundredButton clicked");
  double new = [cashTextField doubleValue] + 100.0;
  [cashTextField setDoubleValue:new];
  [cashStepper setDoubleValue:new];
  [self updateTotalReceived];
  
}

//******************************************************************************

- (IBAction)clearCashButtonClicked:(id)sender {
  //NSLog(@"clearCashButton clicked");
  [cashTextField setDoubleValue:0.0];
  [cashStepper setDoubleValue:0.0];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)checkStepperClicked:(id)sender {
  //NSLog(@"checkStepper clicked");
  double new = [checkStepper doubleValue];
  double total = [invoice invoiceTotal];

  if (new > total) {
    [checkStepper setDoubleValue:[checkTextField doubleValue]];
  } else {
    [checkTextField setDoubleValue:new];
    if (new > 0) {
      [checkNumberTextField setEditable:YES];
      [checkNumberTextField setEnabled:YES];
    } else {
      [self clearTextField:checkNumberTextField];
      [checkNumberTextField setEditable:NO];
      [checkNumberTextField setEnabled:NO];
    }
  }
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)checkTotalButtonClicked:(id)sender {
  //NSLog(@"checkTotalButton clicked");
  [self clearCashButtonClicked:self];
  [self creditClearButtonClicked:self];
  [self cardClearButtonClicked:self];
  double total = [invoice invoiceTotal];
  [checkTextField setDoubleValue:total];
  [checkStepper setDoubleValue:total];
  [checkNumberTextField setEditable:YES];
  [checkNumberTextField setEnabled:YES]; 
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)checkRemainingButtonClicked:(id)sender {
  //NSLog(@"checkRemainingButton clicked");
  if ([checkTextField doubleValue] != 0) {
    [self checkTotalButtonClicked:self];
  } else {
    double remaining = [self updateTotalReceived];
    if (remaining < 0.0) {
      remaining = -1.0 * remaining;
      [checkStepper setDoubleValue:remaining];
      [checkTextField setDoubleValue:remaining];
      [checkNumberTextField setEditable:YES];
      [checkNumberTextField setEnabled:YES]; 
    } else {
      //noop
    }
  }
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)checkClearButtonClicked:(id)sender {
  //NSLog(@"checkClearButton clicked");
  [checkStepper setDoubleValue:0.0];
  [checkTextField setDoubleValue:0.0];
  [checkNumberTextField setEditable:NO];
  [checkNumberTextField setEnabled:NO];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)creditStepperClicked:(id)sender {
  //NSLog(@"creditStepper clicked");
  double new = [creditStepper doubleValue];
  double total = [invoice invoiceTotal];
  if (new > total || new > [self maxCreditAmountAllowed]) {
    [creditStepper setDoubleValue:[creditTextField doubleValue]];
  } else {
    [creditTextField setDoubleValue:new];
  }
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)creditTotalButtonClicked:(id)sender {
  //NSLog(@"creditTotalButton clicked");
  [self clearCashButtonClicked:self];
  [self checkClearButtonClicked:self];
  [self cardClearButtonClicked:self];
  
  double crdAvail = [self maxCreditAmountAllowed];
  [creditStepper setDoubleValue:crdAvail];
  [creditTextField setDoubleValue:crdAvail];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)creditRemainingButtonClicked:(id)sender {
  //NSLog(@"creditRemainingButton clicked");
  double remaining = [self updateTotalReceived];
  double crdAvail = [self maxCreditAmountAllowed];
  if (remaining < 0.0) {
    remaining = -1.0 * remaining;
    if (crdAvail >= remaining) {
      [creditTextField setDoubleValue:remaining];
      [creditStepper setDoubleValue:remaining];
    }
  }
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)creditClearButtonClicked:(id)sender {
  //NSLog(@"creditClearButton clicked");
  [creditTextField setDoubleValue:0.0];
  [creditStepper setDoubleValue:0.0];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)cardStepperClicked:(id)sender {
  //NSLog(@"cardStepper clicked");
  double new = [cardStepper doubleValue];
  double total = [invoice invoiceTotal];
  
  if (new > total) {
    [cardStepper setDoubleValue:[cardTextField doubleValue]];
  } else {
    [cardTextField setDoubleValue:new];
    if (new > 0.0) {
      [cardBrandComboBox setEnabled:YES];
      [cardBrandComboBox setEditable:YES];
      [debitOrCreditComboBox setEnabled:YES];
      [debitOrCreditComboBox setEditable:YES];
      [expirationDatePicker setEnabled:YES];
      [lastFourDigitsTextField setEnabled:YES];
      [lastFourDigitsTextField setEditable:YES];
    } else {
      [cardBrandComboBox setEnabled:NO];
      [cardBrandComboBox setEditable:NO];
      [debitOrCreditComboBox setEnabled:NO];
      [debitOrCreditComboBox setEditable:NO];
      [expirationDatePicker setEnabled:NO];
      [lastFourDigitsTextField setEnabled:NO];
      [lastFourDigitsTextField setEditable:NO];
    }
  }
}

//******************************************************************************

- (IBAction)cardTotalButtonClicked:(id)sender {
  //NSLog(@"cardTotalButton clicked");
  [self clearCashButtonClicked:self];
  [self checkClearButtonClicked:self];
  [self creditClearButtonClicked:self];
  double total = [invoice invoiceTotal];
  [cardStepper setDoubleValue:total];
  [cardTextField setDoubleValue:total];
  [cardBrandComboBox setEnabled:YES];
  [cardBrandComboBox setEditable:YES];
  [debitOrCreditComboBox setEnabled:YES];
  [debitOrCreditComboBox setEditable:YES];
  [expirationDatePicker setEnabled:YES];
  [lastFourDigitsTextField setEnabled:YES];
  [lastFourDigitsTextField setEditable:YES];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)cardRemainingButtonClicked:(id)sender {
  //NSLog(@"cardRemainingButton clicked");
  double remaining = [self updateTotalReceived];
  if (remaining < 0.0) {
    remaining = -1.0 * remaining;
    [cardStepper setDoubleValue:remaining];
    [cardTextField setDoubleValue:remaining];
    [cardBrandComboBox setEnabled:YES];
    [cardBrandComboBox setEditable:YES];
    [debitOrCreditComboBox setEnabled:YES];
    [debitOrCreditComboBox setEditable:YES];
    [expirationDatePicker setEnabled:YES];
    [lastFourDigitsTextField setEnabled:YES];
    [lastFourDigitsTextField setEditable:YES];
  } else {
    // noop
  } 
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)cardClearButtonClicked:(id)sender {
  //NSLog(@"cardClearButton clicked");
  [cardTextField setDoubleValue:0.0];
  [cardStepper setDoubleValue:0.0];
  [cardBrandComboBox setEditable:NO];
  [cardBrandComboBox setEnabled:NO];
  [debitOrCreditComboBox setEnabled:NO];
  [debitOrCreditComboBox setEditable:NO];
  [expirationDatePicker setEnabled:NO];
  [lastFourDigitsTextField setEnabled:NO];
  [lastFourDigitsTextField setEditable:NO];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)expirationDatePickerClicked:(id)sender {
  //NSLog(@"expirationDatePicker clicked");
  [self enableSaveButtonsAppropriately];
}

//******************************************************************************

- (IBAction)clearFormButtonClicked:(id)sender {
  //NSLog(@"clearFormButton clicked");
  [self setupButtons];
  [self setupTextFields];
  [self setupStateVariables];
  [self updateTotalReceived];
}

//******************************************************************************

- (IBAction)saveButtonClicked:(id)sender {
  //NSLog(@"saveButton clicked");
  [self saveInvoiceAndPrint:NO];
}

//******************************************************************************

- (IBAction)saveAndPrintButtonClicked:(id)sender {
  //NSLog(@"saveAndPrintButton clicked");
  [self saveInvoiceAndPrint:YES];
}

//******************************************************************************

- (IBAction)goBackButtonClicked:(id)sender {
  //NSLog(@"goBackButton clicked");
  [self clearFormButtonClicked:self];
  [self stopModalAndCloseWindow];
}

//******************************************************************************
// misc
//******************************************************************************
- (double)updateTotalReceived {
  double sum = [cashTextField doubleValue] + [checkTextField doubleValue] 
  + [creditTextField doubleValue] + [cardTextField doubleValue];
  [receivedTextField setDoubleValue:sum];
  double change = sum - [invoice invoiceTotal];
  
  [changeTextField setDoubleValue:change];
  [self enableSaveButtonsAppropriately];
  return change;
}

//******************************************************************************

- (void)clearPayments {
  //noop
}

//******************************************************************************

- (double)totalCash {
  return [cashTextField doubleValue];
}

//******************************************************************************

- (double)totalCheck {
  return [checkTextField doubleValue];
}

//******************************************************************************

- (double)totalCredit {
  return [creditTextField doubleValue];
}

//******************************************************************************

- (double)totalCard {
  return [cardTextField doubleValue];
}

//******************************************************************************

- (double)totalReceived {
  return [self totalCash] + [self totalCredit] + [self totalCheck] + [self totalCard];
}

//******************************************************************************

- (double)changeDue {
  return [self updateTotalReceived];
}

//******************************************************************************

- (Product *)donationInInvoice {
  NSEnumerator *en = [[invoice items] objectEnumerator];
  Product *p;
  while (p = (Product *)[en nextObject]) {
    if ([[p productCode] isEqualToString:@"donation"]) {
      return p;
    }
  }
  return nil;
}

//******************************************************************************

- (Product *)standTimeInInvoice {
  NSEnumerator *en = [[invoice items] objectEnumerator];
  Product *p;
  while (p = (Product *)[en nextObject]) {
    if ([[p productCode] isEqualToString:@"stand"]) {
      return p;
    }
  }
  return nil;
}

//******************************************************************************

- (Book *)currentBook {
  return [[Books sharedInstance] currentBook];
}

//******************************************************************************

- (Product *)productForCode:(NSString *)code {
  NSArray *prods = [[Products sharedInstance] arrayForDictionary]; 
  unsigned int i, count = [prods count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[prods objectAtIndex:i];
    if ([[p productCode] isEqualToString:code]) {
      return p;
    }
  }
  return nil;  
}

//******************************************************************************

- (Product *)membershipInInvoice {
  NSArray *array = [invoice items];
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[array objectAtIndex:i];
    if ([[p productCategory] isEqualToString:@"Memberships"]) {
      return p;
    }
  }
  return nil;    
}

//******************************************************************************


- (void)closeProject {
  // there is only one project! yippee!
  // this is a little weird, if I don't set the project to nil, I sometimes see
  // project = <NSButton: 0x3e1560>
  Product *project = nil;
  NSEnumerator *e = [[invoice items] objectEnumerator];
  Product *p;
  while (p = (Product *)[e nextObject]) {
    //NSLog(@"product in enum: %@", p);
    if ([[p productCode] isEqualToString:@"project"]) {
      project = p;
    }
  }
  //NSLog(@"project in close project: %@", project);
  if (project != nil) {
    Project *theProject = [[Projects sharedInstance] objectForUid:[project uid]];
    //NSLog(@"project uid: %@", [project uid]);

    //NSLog(@"project in close project: %@", theProject);
    [theProject setFinishedDate:[NSCalendarDate calendarDate]];
    
    // remove the old invoice from the person
    Invoice *oldInvoice = [theProject invoice];
    NSString *oldInvoiceUid = [oldInvoice uid];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF like %@)", oldInvoiceUid];
    [[person invoiceUids] filterUsingPredicate:predicate];
    // add this invoice to the person
    NSString *newInvoiceUid = [invoice uid];
    [[person invoiceUids] addObject:newInvoiceUid];
    // switch the invoice uid of the project    
    [theProject setInvoiceUid:newInvoiceUid];
    // remove the old invoice from the list of invoices
    [[Invoices sharedInstance] removeObjectForUid:oldInvoiceUid];
    
    [theProject setIsFinished:YES];
    
    [[People sharedInstance] saveToDisk];
    [[Projects sharedInstance] saveToDisk];
    [[Invoices sharedInstance] saveToDisk];
  }
}

//******************************************************************************

- (void)decfProductsInInvoice {
  NSEnumerator *e = [[invoice items] objectEnumerator];
  Product *p;
  while (p = (Product *)[e nextObject]) {
    Product *root = [[Products sharedInstance] objectForUid:[p uid]];
    int delta;
    int original = [root productQuantity];
    NSString *code = [p productCode];
    if ([code isEqualToString:@"stand"]) {
      // price of stand time is always at least $1.00
      delta = (int)round([p productPrice] / [self priceOfStandTime]);
    } else {
      delta = [p productQuantity];
    }
    [root setProductQuantity:(original - delta)];    
  }
  [[Products sharedInstance] saveToDisk];  
}

//******************************************************************************

- (void)saveInvoiceAndPrint:(bool)print {
  [self showProgressPanel:@"Saving invoice..."];
	[self applyPaymentToInvoice];
  
	// includes saving uid to person, do it now so i have chance to recover later
  // if the archiving fails
  [[person invoiceUids] addObject:[invoice uid]];
  [[People sharedInstance] saveToDisk];

  [[Invoices sharedInstance] setObject:invoice forUid:[invoice uid]];
  [[Invoices sharedInstance] saveToDisk];
  
  // archive that shit
  ///[[InvoiceArchiver sharedInstance] archiveInvoice:invoice andPrint:print];
  // includes saving products
  [self decfProductsInInvoice];
  [self closeProject];
	
  
  [self clearFormButtonClicked:self];
  [self closeProgressPanel];
  [self stopModalAndCloseWindow];
  
}

//******************************************************************************

- (bool)personIsQuickSale {
  return [[person personName] isEqualToString:TljBkPosAnonymousClientName];
}

//******************************************************************************

- (void)applyCreditsToInvoice {
  [invoice setAmountReceivedStoreCredit:[self totalCredit]];
  if ([self totalCredit] > 0.0) {

    double targetAmount = [self totalCredit];
    
    while (targetAmount != 0.0) {
      //NSLog(@"targetAmount: %1.2f", targetAmount);
      ShopCredit *least = [person leastActiveCredit];
      NSString *commentStr = [least commentText];
      NSString *dateStr = [[NSCalendarDate calendarDate] descriptionWithCalendarFormat:@"%m/%d/%Y %H:%M:%S"];
      double leastCreditAmount = [least creditAmount];
      //NSLog(@"least credit: %@", least);
      if (targetAmount >= leastCreditAmount) {
        //NSLog(@"targetAmount >= leastCreditAmount");
        [least setHasBeenUsed:YES];
        [least setCommentText:[NSString stringWithFormat:@"%@\n* $%1.2f used on %@\n",
          commentStr, leastCreditAmount, dateStr]];
        [[[self currentBook] creditUids] addObject:[least uid]];
        [[Credits sharedInstance] saveToDisk];
        targetAmount = targetAmount - leastCreditAmount;
      } else {
        //NSLog(@"making a new credit");
        // make an "new" credit which indicates the portion that we have used
        double newCreditAmount = targetAmount;
        ShopCredit *new = [[ShopCredit alloc] init];
        [new setHasBeenUsed:YES];
        [new setCreditAmount:newCreditAmount];
        [new setCommentText:[NSString stringWithFormat:@"%@\n* $%1.2f of $%1.2f used on %@\n",
          commentStr, newCreditAmount, leastCreditAmount, dateStr]];
        [new setCommentAuthorName:[least commentAuthorName]];
        [new setCommentSubject:[least commentSubject]];
        [new setOwnerUid:[person uid]];
        [[person creditUids] addObject:[new uid]];
        [[[self currentBook] creditUids] addObject:[new uid]];
        double remaining = leastCreditAmount - targetAmount;
        [least setCreditAmount:remaining];
        [least setCommentText:[NSString stringWithFormat:@"%@\n* $%1.2f remaining of $%1.2f used on %@\n",
          commentStr, remaining, leastCreditAmount, dateStr]];
        [[Credits sharedInstance] setObject:new forUid:[new uid]];
        targetAmount = 0.0;
        [new release];
      }
    }
  }
}

//******************************************************************************

- (void)applyCardsToInvoice {
  if ([self totalCard] > 0.0) {
    NSString *cardBrand = [self latexSafeStringFromString:[cardBrandComboBox stringValue]];
    NSString *cardType = [self latexSafeStringFromString:[debitOrCreditComboBox stringValue]];
    NSCalendarDate *expDate = [self calendarDateFromDatePicker:expirationDatePicker];
    NSString *lastFour = [self latexSafeStringFromTextField:lastFourDigitsTextField];
    
    [invoice setCardBrand:cardBrand];
    [invoice setCardType:cardType];
    [invoice setExpirationDate:expDate];
    [invoice setLastFourDigits:lastFour];
    
    if ([cardType isEqualToString:TljBkPosCreditString]) {
      [invoice setAmountReceivedCreditCard:[self totalCard]];
      [invoice setAmountReceivedDebitCard:0.0];
    } else {
      [invoice setAmountReceivedCreditCard:0.0];
      [invoice setAmountReceivedDebitCard:[self totalCard]];  
    }
    
    // this is badly named, should be DebitOrCredit
    DebitOrCredit *debit = [[DebitOrCredit alloc] init];
    
    // not exactly right either, we're just assuming it is correct.
    [debit setNameOnDebit:[person personName]];
    [debit setDebitAmount:([self totalReceived] - [self changeDue])];
    [debit setLastFourDigits:lastFour];
    [debit setExpirationDate:expDate];
    [debit setInvoiceUid:[invoice uid]];
    if ([cardType isEqualToString:TljBkPosCreditString]) {
      [debit setDebitOrCredit:TljBkPosCreditString];
    } else {
      [debit setDebitOrCredit:TljBkPosDebitString];
    }
    // added to the current book first to keep the tables in synch
    [[[self currentBook] debitUids] addObject:[debit uid]];
    [[DebitsAndCredits sharedInstance] setObject:debit forUid:[debit uid]];
    //NSLog(@"finished the credit processing");
    [debit release];
  } 
}

//******************************************************************************

- (void)applyCheckToInvoice {
  // do the check
  if ([self totalCheck] > 0.0) {
    //NSLog(@"there is a check");
    Check *check = [[Check alloc] init];
    // not quite right, using today's date
    [check setDateOnCheck:[NSCalendarDate calendarDate]];
    // not quite right, we're just assuming the currentPerson is the name on the
    // check.
    [check setNameOnCheck:[person personName]];
    [check setCheckNumber:[checkNumberTextField intValue]];
    [check setCheckAmount:[self totalCheck]];
    //NSLog(@"checkAmount: %1.2f", [self totalCheck]);
    // not setting the phone number or the check address
    [check setInvoiceUid:[invoice uid]];
    // add to the current book first to keep the tables in synch
    [[[self currentBook] checkUids] addObject:[check uid]];
    [[Checks sharedInstance] setObject:check forUid:[check uid]];
    
    
    [invoice setAmountReceivedCheck:[self totalCheck]];
    [invoice setCheckNumber:[checkNumberTextField intValue]];
    [check release];
  }
}

//******************************************************************************

- (void)applyPaymentToInvoice {
  Product *don = [self donationInInvoice];
  if (don != nil && ![self personIsQuickSale]) {
    int choice = NSRunAlertPanel(@"Donation In Invoice",
                                 @"There is a donation in the invoice.  Does the client want a receipt for a Cash Donation?  This would be useful for tax purposes if the donation is significant.",
                                 @"Yes, Client Wants Receipt", @"No, Client Does Not Want Receipt", nil);
    if (choice == 1) {
      [self showAcceptCashDonation];
    } 
  }
  
  [self applyCreditsToInvoice];
  [self applyCardsToInvoice];
  [self applyCheckToInvoice];
  
  Product *membership = [self membershipInInvoice];
  //NSLog(@"membership: %@", membership);
  if (membership != nil) {
    [person applyMembership:membership forInvoice:[invoice uid]];
  }
  
  
  [invoice setPaidDate:[NSCalendarDate calendarDate]];
  [invoice setInvoicePaid:YES];
  [invoice setTotalAmountReceived:[self totalReceived]];
  
  [[[self currentBook] invoiceUids] addObject:[invoice uid]];
  [invoice setAmountReceivedCash:[self totalCash]];
  [invoice setAmountOfChangeGiven:[self changeDue]];
  [[Invoices sharedInstance] saveToDisk];
  [[Books sharedInstance] saveToDisk];
    
}

//******************************************************************************

- (void)enableSaveButtonsAppropriately {
  bool sufficientFunds = [self totalReceived] >= [invoice invoiceTotal];
  bool thereIsCheck;
  if ([self totalCheck] > 0.0) {
    thereIsCheck = YES;
  } else {
    thereIsCheck = NO;
  }
  bool checkNumberOk;
  if (thereIsCheck && [self textFieldIsEmpty:checkNumberTextField]) {
    checkNumberOk = NO;
  } else {
    checkNumberOk = YES;
  }
  bool thereIsCard;
  if ([self totalCard] > 0.0) {
    thereIsCard = YES;
  } else {
    thereIsCard = NO;
  }
  bool cardOk = YES;
  if (thereIsCard) {
    NSCalendarDate *expDate = [self calendarDateFromDatePicker:expirationDatePicker];
    NSCalendarDate *today = [NSCalendarDate calendarDate];
    bool badDate = NO;
    if ([expDate earlierDate:today] == expDate) {
      badDate = YES;
    }
    NSString *lastFour = [lastFourDigitsTextField stringValue];
    //NSLog(@"lastFour = %@", lastFour);
    bool badDigits;
    // bool badDigits = NO;
    NSCharacterSet *decSet = [NSCharacterSet decimalDigitCharacterSet];
    NSMutableCharacterSet *iDecSet = [[decSet invertedSet] mutableCopy];
    NSRange range = [lastFour rangeOfCharacterFromSet:iDecSet];
    NSLog(@"%d != %d", range.location, NSNotFound);
    if (([lastFour length] != 4) || (range.location != NSNotFound)) {
      badDigits = YES;
    } else {
      badDigits = NO;
    }
    
    NSString *brand = [self stringFromComboBox:cardBrandComboBox];
    bool badBrand;
    //original
    //bool badBrand = [self stringIsEmpty:brand];
    if ([brand isEqualToString:@"American Express"] ||
        [brand isEqualToString:@"Visa"] ||
        [brand isEqualToString:@"Master Card"]) {
      badBrand = NO;
    } else {
      badBrand = YES;
    }
    
    NSString *debitOrCredit = [self stringFromComboBox:debitOrCreditComboBox];
    bool badType;
    //bool badType = [self stringIsEmpty:debitOrCredit];
    //NSLog(@"debitOrCredit: %@", debitOrCredit);
    if ([debitOrCredit isEqualToString:@"Debit"] ||
        [debitOrCredit isEqualToString:@"Credit"]) {
      badType = NO;
    } else {
      badType = YES;
    }
    NSLog(@"badDigits: %d badDate: %d badType: %d badBrand: %d", badDigits, badDate, badType, badBrand);
    
    if (badDigits || badDate || badType || badBrand) {
      cardOk = NO;
    }
  }
  
  if (sufficientFunds && checkNumberOk && cardOk) {
    [saveButton setEnabled:YES];
    [saveAndPrintButton setEnabled:YES];
  } else {
    [saveButton setEnabled:NO];
    [saveAndPrintButton setEnabled:NO];
  }
}

//******************************************************************************

- (void)showAcceptCashDonation {
  if (acceptCashDonation == nil) {
    AcceptCashDonation *tmp = [[AcceptCashDonation alloc] init];
    [self setAcceptCashDonation:tmp];
    [tmp release];
  } 
  
  [acceptCashDonation setRunningFromPayInvoice:YES];
  Product *don = [self donationInInvoice];
  [acceptCashDonation setDonationAmount:[don productTotal]];
  [acceptCashDonation setPerson:[self person]];
  [acceptCashDonation setupForModal];
  [acceptCashDonation runModalWithParent:[self window]];
}

//******************************************************************************

- (double)maxCreditAmountAllowed {
  double totalOfInvoice = [invoice invoiceTotal];
  double totalCredits = [person creditAvailable];
  if (totalCredits > totalOfInvoice) {
    return totalOfInvoice;
  } else {
    return totalCredits;
  }
}

//******************************************************************************

- (bool)acceptingCreditCardsP {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  int tmp = [[defaults objectForKey:TljBkPosWillAcceptCreditCards] intValue];
  //NSLog(@"accepting cards? %d", tmp);
  if (tmp == 1) {
    return YES;
  } else {
    return NO;
  }
}

//******************************************************************************

- (double)priceOfStandTime {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSNumber *standTimeRate = [defaults objectForKey:TljBkPosStandTimeRateKey];
  return [standTimeRate doubleValue];
}


//******************************************************************************
// handlers
//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    ////NSLog(@"handle pay bill text change");
    id sender = [note object];
    if (sender == lastFourDigitsTextField) {
      NSString *lastFour = [lastFourDigitsTextField stringValue];
      if ([lastFour length] > 4) {
        NSRunAlertPanel(@"Operation Not Permitted",@"Only enter 4 digits",@"Continue",nil,nil);
        NSString *new = [lastFour substringToIndex:4];
        [lastFourDigitsTextField setStringValue:new];
      }
    }
    [self enableSaveButtonsAppropriately];
  }
}


//******************************************************************************
// accessors and setters
//******************************************************************************

- (Person *)person {
  return person;
}
- (void) setPerson:(Person *)arg {
  [arg retain];
  [person release];
  person = arg;
}
- (Invoice *)invoice {
  return invoice;
}
- (void) setInvoice:(Invoice *)arg {
  [arg retain];
  [invoice release];
  invoice = arg;
}
- (AcceptCashDonation *)acceptCashDonation {
  return acceptCashDonation;
}
- (void) setAcceptCashDonation:(AcceptCashDonation *)arg {
  [arg retain];
  [acceptCashDonation release];
  acceptCashDonation = arg;
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
           object:checkNumberTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:lastFourDigitsTextField];
  
}
@end