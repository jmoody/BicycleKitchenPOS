//
//  InvoiceController.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "ProjectController.h"
#import "Product.h"
#import "Invoice.h"
#import "Person.h"
#import "PeopleController.h"
#import "PayInvoiceController.h"

@interface InvoiceController : BasicWindowController {
    
  PeopleController *peopleController;
  ProjectController *projectController;
  PayInvoiceController *payInvoiceController;
  Project *projectInInvoice;
  Person *currentlyViewedPerson;

  
  // table and browser
  IBOutlet NSSearchField *productsSearchField;
  int previousLengthOfSearchString;
  IBOutlet NSTableView *productsTableView;
  NSArray *productsInInvoice;
  Product *currentlyViewedProduct;
  IBOutlet NSArrayController *productsInInvoicesController;

  IBOutlet NSBrowser *categoryBrowser;
  NSArray *categories;
  IBOutlet NSTreeController *categoriesTreeController;

  // invoice view
  IBOutlet NSTableView *invoiceTableView;
  NSMutableArray *invoiceItems;
  Product *currentlyViewedInvoiceItem;
  IBOutlet NSArrayController *invoiceItemsController;
  Invoice *currentInvoice;
  
  // adding stuff
  IBOutlet NSButton *addStandTimeButton;
  IBOutlet NSButton *addProjectButton;
  
  IBOutlet NSButton *applyDiscountButton;
  double appliedDiscount;
  bool applyDiscount;
  
  // total
  IBOutlet NSTextField *roundedTextField;
  IBOutlet NSTextField *totalTextField;
  
  // saving
  IBOutlet NSButton *saveToPersonButton;
  IBOutlet NSButton *saveToProjectButton;
  IBOutlet NSButton *payInvoiceButton;
  
   
  // quanity/price
  IBOutlet NSTextField *priceTextField;
  IBOutlet NSStepper *priceStepper;
  IBOutlet NSTextField *priceOrStandTimeTextField;
  IBOutlet NSTextField *quantityTextField;
  IBOutlet NSStepper *quantityStepper;
  
  // delete item
  IBOutlet NSButton *deleteButton;

  // quit
  IBOutlet NSButton *cancelButton;
  //IBOutlet NSButton *changePersonButton;
}

- (void)runSelectPersonModal;

- (void)setupProductsAndCategoriesDoubleActions;

- (void)setupTableViewsAndBrowser;
- (void)setupTextFields;
- (void)setTotalTextFieldValue;
- (void)enablePayButtonAppropriately;
- (void)enableAddProjectButtonAppropriately;

- (NSArray *)productsInInvoice;
- (Product *)currentlyViewedProduct;
- (NSMutableArray *)invoiceItems;
- (Product *)currentlyViewedInvoiceItem;
- (Invoice *)currentInvoice;
- (NSArray *)categories;
- (Person *)currentlyViewedPerson;

- (void)setProductsInInvoice:(NSArray *)array;
- (void)setCurrentlyViewedProduct:(Product *)product;
- (void)setInvoiceItems:(NSArray *)array;
- (void)setCurrentlyViewedInvoiceItem:(Product *)product;
- (void)setCurrentInvoice:(Invoice *)invoice;
- (void)setCategories:(NSArray *)array;
- (void)setCurrentlyViewedPerson:(Person *)person;

- (Project *)projectInInvoice;
- (void)setProjectInInvoice:(Project *)p;

- (PeopleController *)peopleController;
- (void)setPeopleController:(PeopleController *)controller;
- (ProjectController *)projectController;
- (void)setProjectController:(ProjectController *)controller;
- (PayInvoiceController *)payInvoiceController;
- (void)setPayInvoiceController:(PayInvoiceController *)controller;



- (bool)projectInInvoiceP;
- (bool)donationInInvoice;
- (bool)membershipInInvoice;

- (void)setProjectInInvoice:(Project *)project;

- (void)setupPriceAndQuantityFields;

- (void)addInvoiceItem:(Product *)p;
- (bool)invoiceHasItemWithCodeAlready:(NSString *)code;

- (void)insertObject:(Product *)invoice inInvoiceItemsAtIndex:(int)index;
- (void)removeObjectFromInvoiceItemsAtIndex:(int)index;

- (void)handleProductsSearchFieldChange:(NSNotification *) note;
- (void)handleProductClicked:(id)sender;
- (void)handleCategoryClicked:(id)sender;
- (void)handleInvoiceClicked:(id)sender;

- (void)handleTextFieldChange:(NSNotification *)note;

- (IBAction)applyDiscountButtonClicked:(id)sender;
- (IBAction)addStandTimeButtonClicked:(id)sender;
- (IBAction)addProjectButtonClicked:(id)sender;
- (IBAction)saveToPersonButtonClicked:(id)sender;
- (IBAction)saveToProjectButtonClicked:(id)sender;
- (IBAction)payInvoiceButtonClicked:(id)sender;
- (IBAction)priceStepperClicked:(id)sender;
- (IBAction)quantityStepperClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
//- (IBAction)changePersonButtonClicked:(id)sender;

- (void)makeUnpaidInvoice;

- (double)totalInvoiceAmount;
- (double)totalDiscounts;
- (double)computeTaxOwed:(double)taxableAmount;
- (double)computeTaxableAmount;
- (double)computeNonTaxableAmount:(double)taxableAmount;



- (bool)donationInInvoice;
- (bool)membershipInInvoice;
- (bool)projectInInvoiceP;
- (bool)membershipInInvoiceP;

- (bool)cvpIsStand;
- (bool)cvpIsProject;
- (bool)cvpIsDonation;
- (bool)cvpIsClass;
- (bool)cvpIsAnonymous;
- (bool)cvpIsMember;
- (bool)cvpIsMembership;

@end
