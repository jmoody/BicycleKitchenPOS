// 
// InvoiceManager.h
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "ViewInvoice.h"

@interface InvoiceManager : BasicWindowController {

  ViewInvoice *invoiceViewer;
  IBOutlet NSTableView *invoicesTableView;
  IBOutlet NSArrayController *invoicesArrayController;
  NSMutableArray *invoicesArray;
  IBOutlet NSSearchField *invoicesSearchField;
  int previousLengthOfInvoicesSearchString;
  IBOutlet NSButton *closeButton;

}


//******************************************************************************
// prototypes
//******************************************************************************
- (ViewInvoice *)invoiceViewer;
- (void)setInvoiceViewer:(ViewInvoice *)arg;
- (NSMutableArray *)invoicesArray;
- (void)setInvoicesArray:(NSArray *)arg;
- (void)handleInvoicesClicked:(id)sender;


//******************************************************************************
// button actions
//******************************************************************************
- (IBAction)closeButtonClicked:(id)sender;


//******************************************************************************
// handlers
//******************************************************************************
- (void)handleInvoicesChange:(NSNotification *)note;
- (void)handleInvoicesSearchFieldChange:(NSNotification *)note;


//******************************************************************************
// misc
//******************************************************************************


@end