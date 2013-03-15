//
//  BookViewer.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/3/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Book.h"
#import "ViewInvoice.h"

@interface BookViewer : BasicWindowController {
  
  Book *currentBook;
  
  IBOutlet NSTableView *invoicesTableView;
  IBOutlet NSArrayController *invoicesArrayController;
  NSMutableArray *invoicesArray;
  IBOutlet NSTableView *checksTableView;
  IBOutlet NSArrayController *checksArrayController;
  NSMutableArray *checksArray;
  IBOutlet NSTableView *creditsTableView;
  IBOutlet NSArrayController *creditsArrayController;
  NSMutableArray *creditsArray;
  IBOutlet NSTableView *cardsTableView;
  IBOutlet NSArrayController *cardsArrayController;
  NSMutableArray *cardsArray;
  IBOutlet NSTextField *checksInitialsTextField;
  IBOutlet NSTextField *cardsInitialsTextField;
  IBOutlet NSTextField *creditsInitialsTextField;
  IBOutlet NSForm *cashForm;
  IBOutlet NSTextField *hundredsTextField;
  IBOutlet NSTextField *fiftiesTextField;
  IBOutlet NSTextField *twentiesTextField;
  IBOutlet NSTextField *tensTextField;
  IBOutlet NSTextField *fivesTextField;
  IBOutlet NSTextField *twosTextField;
  IBOutlet NSTextField *onesTextField;
  IBOutlet NSTextField *cashTotalTextField;
  IBOutlet NSForm *summaryForm;
  IBOutlet NSTextField *closerInitialsTextField;
  IBOutlet NSButton *printButton;
  IBOutlet NSButton *closeButton;
 
  ViewInvoice *invoiceViewer;
}


//******************************************************************************
// prototypes
//******************************************************************************

- (Book *)currentBook;
- (void)setCurrentBook:(Book *)arg;
- (NSMutableArray *)invoicesArray;
- (void)setInvoicesArray:(NSArray *)arg;
- (NSMutableArray *)checksArray;
- (void)setChecksArray:(NSArray *)arg;
- (NSMutableArray *)creditsArray;
- (void)setCreditsArray:(NSArray *)arg;
- (NSMutableArray *)cardsArray;
- (void)setCardsArray:(NSArray *)arg;
- (ViewInvoice *)invoiceViewer;
- (void)setInvoiceViewer:(ViewInvoice *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)printButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;



  //******************************************************************************
  // handlers
  //******************************************************************************
- (void)handleInvoicesChange:(NSNotification *)note;
- (void)handleInvoiceClicked:(id)sender;
- (void)handleChecksChange:(NSNotification *)note;
- (void)handleCreditsChange:(NSNotification *)note;
- (void)handleDebitsAndCreditsChange:(NSNotification *)note;


@end