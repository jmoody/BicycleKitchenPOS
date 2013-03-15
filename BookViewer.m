//
//  BookViewer.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "BookViewer.h"
#import "Invoice.h"
#import "Invoices.h"
#import "Check.h"
#import "Checks.h"
#import "DebitOrCredit.h"
#import "DebitsAndCredits.h"
#import "ShopCredit.h"
#import "Credits.h"
#import "Book.h"
#import "BookArchiver.h"

@implementation BookViewer

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"BookDetails"];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [currentBook release];
  [invoicesArray release];
  [checksArray release];
  [creditsArray release];
  [cardsArray release];
  [invoiceViewer release];  
  [super dealloc];
}

//******************************************************************************
// windowing
// requires that currentBook is set
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
  if ([currentBook isOpen]) {
    [printButton setEnabled:NO];
  } else {
    [printButton setEnabled:YES];
  }
}

//******************************************************************************

- (void)setupTextFields {
  if ([currentBook isOpen]) {
    [self clearTextField:checksInitialsTextField];
    [self clearTextField:creditsInitialsTextField];
    [self clearTextField:cardsInitialsTextField];
    [self clear1DForm:cashForm];
    [self clear1DForm:summaryForm];
    [self clearTextField:cashTotalTextField];
    [self clearTextField:closerInitialsTextField];
    [self clearTextField:hundredsTextField];
    [self clearTextField:fiftiesTextField];
    [self clearTextField:twentiesTextField];
    [self clearTextField:tensTextField];
    [self clearTextField:fivesTextField];
    [self clearTextField:twosTextField];
    [self clearTextField:onesTextField];
  } else {
    [checksInitialsTextField setStringValue:[currentBook closerNameOrInitials]];
    [creditsInitialsTextField setStringValue:[currentBook closerNameOrInitials]];
    [cardsInitialsTextField setStringValue:[currentBook closerNameOrInitials]];
    [closerInitialsTextField setStringValue:[currentBook closerNameOrInitials]];
    [[cashForm cellAtIndex:0] setIntValue:[currentBook hundreds]];
    [hundredsTextField setDoubleValue:[currentBook hundreds] * 100.0];
    [[cashForm cellAtIndex:1] setIntValue:[currentBook fifties]];
    [fiftiesTextField setDoubleValue:[currentBook fifties] * 50.0];
    [[cashForm cellAtIndex:2] setIntValue:[currentBook twenties]];
    [twentiesTextField setDoubleValue:[currentBook twenties] * 20.0];
    [[cashForm cellAtIndex:3] setIntValue:[currentBook tens]];
    [tensTextField setDoubleValue:[currentBook tens] * 10.0];
    [[cashForm cellAtIndex:4] setIntValue:[currentBook fives]];
    [fivesTextField setDoubleValue:[currentBook fives] * 5.0];
    [[cashForm cellAtIndex:5] setIntValue:[currentBook twos]];
    [twosTextField setDoubleValue:[currentBook twos] * 2.0];
    [[cashForm cellAtIndex:6] setIntValue:[currentBook ones]];
    [onesTextField setDoubleValue:[currentBook ones] * 1.0];
    [cashTotalTextField setDoubleValue:[currentBook totalCash]];
    [[summaryForm cellAtIndex:0] setDoubleValue:[currentBook totalCash]];
    [[summaryForm cellAtIndex:1] setDoubleValue:[currentBook totalChecks]];
    [[summaryForm cellAtIndex:2] setDoubleValue:[currentBook totalCards]];
    [[summaryForm cellAtIndex:3] setDoubleValue:[currentBook totalCredits]];
    [[summaryForm cellAtIndex:4] setDoubleValue:[currentBook actualTotal]];
    [[summaryForm cellAtIndex:5] setDoubleValue:[currentBook expectedTotal]];
    [[summaryForm cellAtIndex:6] setDoubleValue:[currentBook variance]];
  }
}

//******************************************************************************

- (void)setupTables {
  [self setInvoicesArray:[[Invoices sharedInstance] objectsForUids:[currentBook invoiceUids]]];
  [invoicesTableView setTarget:self];
  [invoicesTableView setDoubleAction:@selector(handleInvoiceClicked:)];
  [self setChecksArray:[[Checks sharedInstance] objectsForUids:[currentBook checkUids]]];
  [self setCreditsArray:[[Credits sharedInstance] objectsForUids:[currentBook creditUids]]];
  [self setCardsArray:[[DebitsAndCredits sharedInstance] objectsForUids:[currentBook debitUids]]];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)printButtonClicked:(id)sender {
  [[BookArchiver sharedInstance] printBook:currentBook];
}

//******************************************************************************

- (IBAction)closeButtonClicked:(id)sender {
  //NSLog(@"closeButton clicked");
  if (runningModal) {
    [self stopModalAndCloseWindow];
  }
  else {
    [[self window] close];
  }
}


//******************************************************************************
// handlers
//******************************************************************************

- (void)handleInvoicesChange:(NSNotification *)note {
  NSArray *tmp = [[Invoices sharedInstance] objectsForUids:[currentBook invoiceUids]];
  [self setInvoicesArray:tmp];
  [invoicesTableView reloadData];
}

//******************************************************************************

- (void)handleInvoiceClicked:(id)sender {
  NSArray *selected = [invoicesArrayController selectedObjects];
  if ([selected count] > 0) {
    Invoice *select = (Invoice *)[selected objectAtIndex:0];
    if (select != nil) {
      if (invoiceViewer == nil) {
        ViewInvoice *vi = [[ViewInvoice alloc] init];
        [self setInvoiceViewer:vi];
        [vi release];
      }
      [invoiceViewer setInvoice:select];
      [invoiceViewer setupForModal];
      [invoiceViewer runModalWithParent:[self window]];
    }
  }
}

//******************************************************************************

- (void)handleChecksChange:(NSNotification *)note {
  NSArray *tmp = [[Checks sharedInstance] objectsForUids:[currentBook checkUids]];
  [self setChecksArray:tmp];
  [checksTableView reloadData];
}

//******************************************************************************

- (void)handleCreditsChange:(NSNotification *)note {
  NSArray *tmp = [[Credits sharedInstance] objectsForUids:[currentBook creditUids]];
  [self setCreditsArray:tmp];
  [creditsTableView reloadData];
}

//******************************************************************************

- (void)handleDebitsAndCreditsChange:(NSNotification *)note {
  NSArray *tmp = [[DebitsAndCredits sharedInstance] objectsForUids:[currentBook debitUids]];
  [self setCardsArray:tmp];
  [cardsTableView reloadData];
}

//******************************************************************************



//******************************************************************************
// accessors and setters
//******************************************************************************

- (Book *)currentBook {
  return currentBook;
}
- (void) setCurrentBook:(Book *)arg {
  [arg retain];
  [currentBook release];
  currentBook = arg;
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
- (NSMutableArray *)checksArray {
  return checksArray;
}
- (void) setChecksArray:(NSArray *)arg {
  if (arg != checksArray) {
    [checksArray release];
    checksArray = [arg mutableCopy];
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
- (NSMutableArray *)cardsArray {
  return cardsArray;
}
- (void) setCardsArray:(NSArray *)arg {
  if (arg != cardsArray) {
    [cardsArray release];
    cardsArray = [arg mutableCopy];
  }
}

- (ViewInvoice *)invoiceViewer {
  return invoiceViewer;
}
- (void)setInvoiceViewer:(ViewInvoice *)arg {
  [arg retain];
  [invoiceViewer release];
  invoiceViewer = arg;
}


//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(handleInvoicesChange:)
             name:[[Invoices sharedInstance] notificationChangeString]
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleChecksChange:)
             name:[[Checks sharedInstance] notificationChangeString]
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleCreditsChange:)
             name:[[Credits sharedInstance] notificationChangeString]
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleDebitsAndCreditsChange:)
             name:[[DebitsAndCredits sharedInstance] notificationChangeString]
           object:nil];
  
}
@end