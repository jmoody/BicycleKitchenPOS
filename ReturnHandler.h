//
//  ReturnHandler.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/6/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressiveWindowController.h"
#import "Invoice.h"
#import "Product.h"
#import "ShopCredit.h"
#import "Project.h"
#import "Person.h"
#import "Return.h"
#import "Donation.h"

@interface ReturnHandler : ProgressiveWindowController {
  
  Invoice *invoice;
  Product *product;
  Product *returnedProduct;
  ShopCredit *credit;
  Project *project;
  Person *person;
  Membership *membership;
  Donation *donation;
  Return *theReturn;
  IBOutlet NSTableView *invoicesTableView;
  IBOutlet NSArrayController *invoicesArrayController;
  NSMutableArray *invoicesArray;
  IBOutlet NSTextField *invoiceTextField;
  IBOutlet NSTableView *productsTableView;
  IBOutlet NSArrayController *productsArrayController;
  NSMutableArray *productsArray;
  IBOutlet NSTableView *returnedTableView;
  IBOutlet NSTableView *finalReturnedTableView;
  IBOutlet NSArrayController *returnedArrayController;
  NSMutableArray *returnedArray;
  IBOutlet NSSearchField *invoicesSearchField;
  int previousLengthOfInvoicesSearchString;
  IBOutlet NSSearchField *productsSearchField;
  int previousLengthOfProductsSearchString;
  IBOutlet NSButton *transferAllButton;
  IBOutlet NSTextField *quantityTextField;
  IBOutlet NSStepper *quantityStepper;
  IBOutlet NSButton *deleteButton;
  IBOutlet NSTextField *personTextField;
  IBOutlet NSTextField *amountTextField;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSTextField *subjectTextField;
  IBOutlet NSTextView *reasonTextView;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSButton *cancelButton;
  IBOutlet NSButton *makeCreditButton;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (Invoice *)invoice;
- (void)setInvoice:(Invoice *)arg;
- (Product *)product;
- (void)setProduct:(Product *)arg;
- (Product *)returnedProduct;
- (void)setReturnedProduct:(Product *)arg;
- (ShopCredit *)credit;
- (void)setCredit:(ShopCredit *)arg;
- (Project *)project;
- (void)setProject:(Project *)arg;
- (Person *)person;
- (void)setPerson:(Person *)arg;
- (Membership *)membership;
- (void)setMembership:(Membership *)arg;
- (Return *)theReturn;
- (void)setTheReturn:(Return *)arg;
- (NSMutableArray *)invoicesArray;
- (void)setInvoicesArray:(NSArray *)arg;
- (void)handleInvoicesClicked:(id)sender;
- (NSMutableArray *)productsArray;
- (void)setProductsArray:(NSArray *)arg;
- (void)handleProductsClicked:(id)sender;
- (NSMutableArray *)returnedArray;
- (void)setReturnedArray:(NSArray *)arg;
- (void)handleReturnedClicked:(id)sender;
- (Donation *)donation;
- (void)setDonation:(Donation *)arg;

  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)transferAllButtonClicked:(id)sender;
- (IBAction)quantityStepperClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)makeCreditButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;


  //******************************************************************************
  // handlers
  //******************************************************************************
- (void)handleInvoicesChange:(NSNotification *)note;
- (void)handleInvoicesSearchFieldChange:(NSNotification *)note;
- (void)handleProductsSearchFieldChange:(NSNotification *)note;


  //******************************************************************************
  // misc
  //******************************************************************************
- (NSArray *)paidInvoices;
- (NSArray *)returnableProducts;
- (bool)productIsMembership:(Product *)p;
- (bool)productIsProject:(Product *)p;
- (void)enableMakeCreditButtonAppropriately;

@end
