// 
// CreateInvoice.h
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Person.h"
#import "Product.h"
#import "Project.h"
//#import "PeopleController.h"
#import "PayInvoiceController.h"
//#import "ProjectController.h"
#import "Invoice.h"
#import "PersonSelector.h"
#import "ProjectSelector.h"

@interface CreateInvoice : BasicWindowController {

IBOutlet NSTableView *productsTableView;
IBOutlet NSArrayController *productsArrayController;
NSMutableArray *productsArray;
IBOutlet NSTableView *invoiceItemsTableView;
IBOutlet NSArrayController *invoiceItemsArrayController;
NSMutableArray *invoiceItemsArray;
Person *person;
Product *product;
Product *invoiceItem;
Project *project;
PayInvoiceController *payInvoiceController;
//ProjectController *projectController;
NSArray *categories;
//PeopleController *peopleController;
IBOutlet NSSearchField *productsSearchField;
int previousLengthOfProductsSearchString;
IBOutlet NSBrowser *categoryBrowser;
IBOutlet NSTreeController *categoriesTreeController;
IBOutlet NSButton *addProjectButton;
IBOutlet NSButton *applyDiscountButton;
IBOutlet NSTextField *totalTextField;
IBOutlet NSButton *payInvoiceButton;
IBOutlet NSTextField *priceTextField;
IBOutlet NSStepper *priceStepper;
IBOutlet NSTextField *priceOrStandTimeTextField;
IBOutlet NSTextField *quantityTextField;
IBOutlet NSStepper *quantityStepper;
IBOutlet NSButton *deleteButton;
IBOutlet NSButton *cancelButton;
IBOutlet NSButton *addStandTimeButton;
IBOutlet NSButton *addDonationButton;
PersonSelector *clientSelector;
ProjectSelector *projectSelector;

}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSMutableArray *)productsArray;
- (void)setProductsArray:(NSArray *)arg;
- (void)handleProductsClicked:(id)sender;
- (NSMutableArray *)invoiceItemsArray;
- (void)setInvoiceItemsArray:(NSArray *)arg;
- (void)handleInvoiceItemsClicked:(id)sender;
- (Person *)person;
- (void)setPerson:(Person *)arg;
- (Product *)product;
- (void)setProduct:(Product *)arg;
- (Product *)invoiceItem;
- (void)setInvoiceItem:(Product *)arg;
- (Project *)project;
- (void)setProject:(Project *)arg;
- (PayInvoiceController *)payInvoiceController;
- (void)setPayInvoiceController:(PayInvoiceController *)arg;
//- (ProjectController *)projectController;
//- (void)setProjectController:(ProjectController *)arg;
- (NSArray *)categories;
- (void)setCategories:(NSArray *)arg;
//- (PeopleController *)peopleController;
//- (void)setPeopleController:(PeopleController *)arg;
- (PersonSelector *)clientSelector;
- (void)setClientSelector:(PersonSelector *)arg;
- (ProjectSelector *)projectSelector;
- (void)setProjectSelector:(ProjectSelector *)arg;


//******************************************************************************
// button actions
//******************************************************************************
- (IBAction)addProjectButtonClicked:(id)sender;
- (IBAction)applyDiscountButtonClicked:(id)sender;
- (IBAction)payInvoiceButtonClicked:(id)sender;
- (IBAction)priceStepperClicked:(id)sender;
- (IBAction)quantityStepperClicked:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)addStandTimeButtonClicked:(id)sender;
- (IBAction)addDonationButtonClicked:(id)sender;


//******************************************************************************
// handlers
//******************************************************************************
- (void)handleProductsChange:(NSNotification *)note;
- (void)handleProductsSearchFieldChange:(NSNotification *)note;
- (void)handleTableViewSelectionChange:(NSNotification *)note;


//******************************************************************************
// misc
//******************************************************************************
- (bool) productAddableP:(Product *)p;
- (void)enableAddProjectButtonAppropriately;
- (void)enablePayInvoiceButtonAppropriately;
- (void)enableApplyDiscountButtonAppropriately;
- (bool)itemsContainsDonationP;
- (Product *)projectInItems;
- (bool)itemsContainsMembershipP;
- (Product *)membershipInItems;
- (bool)itemsContainsProjectP;
- (bool)itemIsStand:(Product *)item;
- (bool)itemsContainsStandP;
- (Product *)standTimeInItems;
- (bool)itemIsProject:(Product *)item;
- (bool)itemIsDonation:(Product *)item;
- (Product *)donationInInvoice;
- (bool)itemIsWorkshop:(Product *)item;
- (Product *)workshopInInvoice;
- (bool)itemIsMembership:(Product *)item;
- (bool)personIsQuickSale;
- (bool)personIsMember;
- (Invoice *)makeInvoice;
- (double)totalInvoiceAmount;
- (double)totalDiscounts;
- (double)computeTaxOwed:(double)taxableAmount;
- (double)computeTaxableAmount;
- (double)computeNonTaxableAmount;
- (void)handleCategoryClicked:(id)sender;
- (void)addInvoiceItem:(Product *)p;
- (void)insertObject:(Product *)p inInvoiceItemsArrayAtIndex:(int)index;
- (void)removeObjectFromInvoiceItemsArrayAtIndex:(int)index;
- (bool)itemsContainsItemP:(NSString *)code;
- (Product *)productForCode:(NSString *)code;
- (void)runSelectPersonModal;
- (bool)applyDiscountButtonChecked;
- (void)setupProductsAndCategoriesDoubleActions;
- (double)priceOfStandTime;

@end