// 
// ProjectInformationController.h
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Project.h"
#import "Product.h"
#import "CreateCorrespondence.h"
#import "CustomerContact.h"
#import "ProductSelectorForProject.h"


@interface ProjectInformationController : BasicWindowController {
  
  Project *project;
  Product *product;
  CreateCorrespondence *contactCreator;
  CustomerContact *contact;
  IBOutlet NSTableView *contactsTableView;
  IBOutlet NSArrayController *contactsArrayController;
  NSMutableArray *contactsArray;
  IBOutlet NSTableView *productsTableView;
  IBOutlet NSArrayController *productsArrayController;
  NSMutableArray *productsArray;
  ProductSelectorForProject *productSelector;
  IBOutlet NSTabView *theTabView;
  IBOutlet NSButton *closeButton;
  IBOutlet NSTextField *clientInfoTextField;
  IBOutlet NSTextField *nameTextField;
  IBOutlet NSButton *changeOwnerButton;
  IBOutlet NSForm *bicycleForm;
  IBOutlet NSComboBox *typeComboBox;
  IBOutlet NSTextField *startDateTextField;
  IBOutlet NSDatePicker *lastDatePicker;
  IBOutlet NSButton *todayButton;
  IBOutlet NSTextField *endDateTextField;
  IBOutlet NSTextField *standTimeTextField;
  IBOutlet NSStepper *standTimeStepper;
  IBOutlet NSTextView *noteTextView;
  IBOutlet NSButton *summarySaveEditButton;
  IBOutlet NSButton *summaryCancelEditButton;
  IBOutlet NSSearchField *contactsSearchField;
  int previousLengthOfContactsSearchString;
  IBOutlet NSButton *deleteContactButton;
  IBOutlet NSButton *newContactButton;
  IBOutlet NSTextField *contactCookTextField;
  IBOutlet NSMatrix *messageTypeMatrix;
  IBOutlet NSTextField *contactSubjectTextField;
  IBOutlet NSTextView *contactNoteTextView;
  IBOutlet NSDatePicker *contactDatePicker;
  IBOutlet NSButton *contactCancelButton;
  IBOutlet NSButton *contactSaveButton;
  IBOutlet NSTextField *priceTextField;
  IBOutlet NSTextField *quantityTextField;
  IBOutlet NSStepper *priceStepper;
  IBOutlet NSStepper *quantityStepper;
  IBOutlet NSButton *deleteProductButton;
  IBOutlet NSButton *addProductButton;
  IBOutlet NSTextField *quoteTextField;
  IBOutlet NSTextField *totalProductsTextField;
  IBOutlet NSTextField *balanceTextField;
  IBOutlet NSButton *financialSaveEditButton;
  IBOutlet NSButton *financialCancelEditButton;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (Project *)project;
- (void)setProject:(Project *)arg;
- (Product *)product;
- (void)setProduct:(Product *)arg;
- (CreateCorrespondence *)contactCreator;
- (void)setContactCreator:(CreateCorrespondence *)arg;
- (CustomerContact *)contact;
- (void)setContact:(CustomerContact *)arg;
- (NSMutableArray *)contactsArray;
- (void)setContactsArray:(NSArray *)arg;
- (void)handleContactsClicked:(id)sender;
- (NSMutableArray *)productsArray;
- (void)setProductsArray:(NSArray *)arg;
- (void)handleProductsClicked:(id)sender;
- (void) handleProductsTableViewSelectionChange:(NSNotification *)note;
- (ProductSelectorForProject *)productSelector;
- (void)setProductSelector:(ProductSelectorForProject *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)changeOwnerButtonClicked:(id)sender;
- (IBAction)lastDatePickerClicked:(id)sender;
- (IBAction)todayButtonClicked:(id)sender;
- (IBAction)standTimeStepperClicked:(id)sender;
- (IBAction)summarySaveEditButtonClicked:(id)sender;
- (IBAction)summaryCancelEditButtonClicked:(id)sender;
- (IBAction)deleteContactButtonClicked:(id)sender;
- (IBAction)newContactButtonClicked:(id)sender;
- (IBAction)messageTypeMatrixClicked:(id)sender;
- (IBAction)contactDatePickerClicked:(id)sender;
- (IBAction)contactCancelButtonClicked:(id)sender;
- (IBAction)contactSaveButtonClicked:(id)sender;
- (IBAction)priceStepperClicked:(id)sender;
- (IBAction)quantityStepperClicked:(id)sender;
- (IBAction)deleteProductButtonClicked:(id)sender;
- (IBAction)addProductButtonClicked:(id)sender;
- (IBAction)financialSaveEditButtonClicked:(id)sender;
- (IBAction)financialCancelEditButtonClicked:(id)sender;

  //******************************************************************************
  // handlers
  //******************************************************************************
- (void)handleContactsChange:(NSNotification *)note;
- (void)handleContactsSearchFieldChange:(NSNotification *)note;
- (void)handleContactsTableViewSelectionChange:(NSNotification *)note;


  //******************************************************************************
  // misc
  //******************************************************************************
- (void)enableSummarySaveButtonAppropriately;
- (void)enableContactSaveButtonAppropriately;
- (void)enableFinacialSaveEditButton;
- (void)adjustProductPricing;
- (void)insertObject:(Product *)p inProductsArrayAtIndex:(int)index;
- (void)removeObjectFromProductsArrayAtIndex:(int)index;






@end