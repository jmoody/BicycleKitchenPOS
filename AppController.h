//
//  AppController.h
//  AnotherApp
//
//  Created by moody on 6/17/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PreferenceController.h";
#import "ProductController.h"
#import "ProductManagerLoginController.h"
#import "PeopleController.h"
#import "PeopleManagerLoginController.h"
#import "CreateCustomerController.h"
//#import "PersonInfoController.h"
#import "ClientInfoManager.h"
#import "Products.h"
#import "People.h"
#import "ProgressiveWindowController.h"
#import "CreateProjectController.h"
#import "ProjectController.h"
//#import "ProjectInformationController.h"
#import "CustomerContactController.h"
#import "InvoiceController.h"
#import "InvoiceManager.h"
#import "BugReportController.h"
#import "FormPrinter.h"
#import "OpenBookController.h"
#import "BooksViewer.h"
#import "BookViewer.h"
#import "CloseBookController.h"
#import "CreditManager.h"
#import "MembershipManager.h"
#import "CreateAComp.h"
#import "CompManager.h"
#import "ReturnHandler.h"
#import "ReturnManager.h"
#import "AcceptInKindDonation.h"
#import "InKindDonationManager.h"
#import "AcceptCashDonation.h"
#import "CreateInvoice.h"
#import "CashDonationManager.h"
#import "ProjectSelector.h"
#import "Books.h"


@interface AppController : NSObject { 

  IBOutlet NSWindow *mainWindow;
  
  // controllers for various supporting controllers
  PreferenceController *preferenceController;
  ProductController *productController;
  ProductManagerLoginController *productManagerLoginController;
  PeopleController *peopleController;
  PeopleManagerLoginController *peopleManagerLoginController;
  
  // invoice
  InvoiceController *invoiceController;
  InvoiceManager *invoiceManager;
  CreateInvoice *createInvoice;
  
  
  // customer contacts
  CustomerContactController *contactsManager;
 
  // people
  CreateCustomerController *createCustomerController;
  //PersonInfoController *personInfoController;
  ClientInfoManager *clientInfoManager;
  
  // create project
  CreateProjectController *createProjectController;
  
  // bug reporting
  BugReportController *bugReportController;
  
  // the books
  OpenBookController *openBookController;
  BooksViewer *booksViewer;
  CloseBookController *closeBookController;
  BookViewer *currentBookViewer;
  
  // credits
  CreditManager *creditsManager;
  
  // comp
  CreateAComp *compAProduct;
  CompManager *compManager;
  
  // returns
  ReturnHandler *handleReturn;
  ReturnManager *returnManager;
  
  // donations
  AcceptInKindDonation *acceptInKindDonation;
  InKindDonationManager *inKindDonationManager;
  AcceptCashDonation *acceptCashDonationManager;
  CashDonationManager *cashDonationManager;
  
  // for the manager
  ProjectController *projectController;
  // for update project
  //ProjectController *modalProjectController;
  ProjectSelector *projectSelector;
  //ProjectInformationController *projectInformationController;
  
  MembershipManager *membershipManager;
  
  // for product table
  NSMutableArray *productsInMainWindow;
  IBOutlet NSTableView *productsTableView;
  IBOutlet NSArrayController *productsArrayController; 
  IBOutlet NSSearchField *productsSearchField;
  
  // for people table
  NSMutableArray *peopleInMainWindow;
  IBOutlet NSTableView *peopleTableView;
  IBOutlet NSArrayController *peopleArrayController; 
  IBOutlet NSSearchField *peopleSearchField;
  
  // capturing return button pressed
  IBOutlet NSButton *openInfoWindowButton;
  
  // toolbars
  NSToolbar *mainWindowToolbar;
  // all items that are allowed to be in the toolbar
  NSMutableDictionary *mainWindowToolbarItems;
  NSArray *toolbarItemsForOpenJournal;
  NSArray *toolbarItemsForClosedJournal;
  
  // we'll probably move this - we use it for selecting the toolbar
  bool journalIsOpen;

  // searching
  int previousLengthOfProductSearchString;
  int previousLengthOfPeopleSearchString;
  
  IBOutlet NSStepper *standTimeStepper;
  IBOutlet NSStepper *clientStepper;
  IBOutlet NSTextField *standTextField;
  IBOutlet NSTextField *clientTextField;
  
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification;
- (NSArray *)arrayFromDictionary:(NSDictionary *) DictionarySingleton;

- (void)setProductManagerLoginController:(ProductManagerLoginController *)pmlc;

- (void)setPreferenceController:(PreferenceController *)pc;
- (void)setProjectController:(ProjectController *)pc;
- (void)setInvoiceManager:(InvoiceManager *)im;
- (void)setPeopleManagerLoginController:(PeopleManagerLoginController *)pmlc;
- (void)setCreateCustomerController:(CreateCustomerController *)ccc;
- (void)setCreateProjectController:(CreateProjectController *)cpc;
- (void)setBugReportController:(BugReportController *)brc;

- (BooksViewer *)booksViewer;
- (void)setBooksViewer:(BooksViewer *)arg;
- (IBAction)showBooksViewerWindow:(id)sender;

- (BookViewer *)currentBookViewer;
- (void)setCurrentBookViewer:(BookViewer *)arg;
- (IBAction)showCurrentBook:(id)sender;

- (CreditManager *)creditsManager;
- (void)setCreditsManager:(CreditManager *)arg;
- (IBAction)showCreditsManager:(id)sender;

- (MembershipManager *)membershipManager;
- (void)setMembershipManager:(MembershipManager *)arg;
- (IBAction)showMembershipManager:(id)sender;

- (CustomerContactController *)contactsManager;
- (void)setContactsManager:(CustomerContactController *)arg;
- (IBAction)showContactsManager:(id)sender;

- (CreateAComp *)compAProduct;
- (void)setCompAProduct:(CreateAComp *)arg;
- (IBAction)showCompAProduct:(id)sender;

- (CompManager *)compManager;
- (void)setCompManager:(CompManager *)arg;
- (IBAction)showCompManager:(id)sender;

- (ReturnHandler *)handleReturn;
- (void)setHandleReturn:(ReturnHandler *)arg;
- (IBAction)showReturnHandler:(id)sender;

- (ReturnManager *)returnManager;
- (void)setReturnManager:(ReturnManager *)arg;
- (IBAction)showReturnManager:(id)sender;

- (AcceptInKindDonation *)acceptInKindDonation;
- (void)setAcceptInKindDonation:(AcceptInKindDonation *)arg;
- (IBAction)showAcceptInKindDonation:(id)sender;

- (InKindDonationManager *)inKindDonationManager;
- (void)setInKindDonationManager:(InKindDonationManager *)arg;
- (IBAction)showInKindDonationManager:(id)sender;

- (ClientInfoManager *)clientInfoManager;
- (void)setClientInfoManager:(ClientInfoManager *)arg;
- (IBAction)showClientInfo:(id)sender;

- (CreateInvoice *)createInvoice;
- (void)setCreateInvoice:(CreateInvoice *)arg;

- (AcceptCashDonation *)acceptCashDonationManager;
- (void)setAcceptCashDonationManager:(AcceptCashDonation *)arg;

- (CashDonationManager *)cashDonationManager;
- (void)setCashDonationManager:(CashDonationManager *)arg;

- (ProjectSelector *)projectSelector;
- (void)setProjectSelector:(ProjectSelector *)arg;


//******************************************************************************
// accessors
//******************************************************************************
- (NSWindow *)mainWindow;

- (OpenBookController *)openBookController;
- (void)setOpenBookController:(OpenBookController *)controller;

- (NSMutableDictionary *)mainWindowToolbarItems;
- (void) setMainWindowToolbarItems:(NSDictionary *)arg;

- (CloseBookController *)closeBookController;
- (void)setCloseBookController:(CloseBookController *)arg;


//******************************************************************************
// setters
//******************************************************************************

//******************************************************************************
// we'll probably move this - we use it for selecting the toolbar
//******************************************************************************

- (bool)journalIsOpen;
- (void)setJournalIsOpen:(bool) flag;

//******************************************************************************
// Allows external classes to runCreateCustomer
//******************************************************************************

- (void)runCreateCustomer;

//******************************************************************************
// for better or worse, awakeFromNib is the init method because 
// I'm using initialize vs. init to capture user prefs.
//******************************************************************************

- (void)awakeFromNib;

//******************************************************************************
// showing windows
//******************************************************************************

- (IBAction)showPreferencePanel:(id)sender;
- (IBAction)showProductManager:(id)sender;
- (IBAction)showProjectManager:(id)sender;
- (IBAction)showInvoiceManager:(id)sender;
- (IBAction)showCustomerManager:(id)sender;
- (IBAction)showCustomerInfoPanel:(id)sender;
- (IBAction)showMainApplicationWindow:(id)sender;
- (IBAction)showBugReportWindow:(id)sender;
- (IBAction)showAcceptCashDonationCreator:(id)sender;
- (IBAction)showCashDonationManager:(id)sender;

//******************************************************************************
// dealing with tables
//******************************************************************************

- (NSMutableArray *)productsInMainWindow;
- (void)setProductsInMainWindow:(NSArray *)array;
- (void)handlePeopleChange:(NSNotification *)note;
- (NSMutableArray *)peopleInMainWindow;
- (void)setPeopleInMainWindow:(NSArray *)array;
- (void)insertObject:(Person *)p inPeopleInMainWindowAtIndex:(int)index;
- (void)removeObjectFromPeopleInMainWindowAtIndex:(int) index;
  
// printing
- (IBAction)printInKindDonationForm:(id)sender;
- (IBAction)printLiabilityForm:(id)sender;

//******************************************************************************
// handlers
//******************************************************************************
- (void)setupNotificationObservers;
- (void)handleProductsChange:(NSNotification *)note;
// searching the products
- (void)handleProductSearchFieldDidChange:(NSNotification *)note;

//******************************************************************************
// toolbar
//******************************************************************************
- (NSToolbar *)mainWindowToolbar;
- (void)setMainWindowToolbar:(NSToolbar *)toolbar;

- (NSMutableDictionary *)mainWindowToolbarItems;

- (NSArray *)toolbarItemsForOpenJournal;
- (NSArray *)toolbarItemsForClosedJournal;
- (void)setToolbarItemsForOpenJournal:(NSArray *)array;
- (void)setToolbarItemsForClosedJournal:(NSArray *)array;



- (void)setupToolbar;

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier 
 willBeInsertedIntoToolbar:(bool)flag;
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;

- (void)addCustomerClicked:(NSToolbarItem *)item;
- (void)createProjectClicked:(NSToolbarItem *)item;
- (void)updateProjectClicked:(NSToolbarItem *)item;
- (void)openJournalClicked:(NSToolbarItem *)item;
- (void)closeJournalClicked:(NSToolbarItem *)item;
- (void)createAdjustmentClicked:(NSToolbarItem *)item;
- (void)sellSomethingClicked:(NSToolbarItem *)item;
- (void)submitBugClicked:(NSToolbarItem *)item;

- (IBAction)standTimeStepperClicked:(id)sender;
- (IBAction)clientStepperClicked:(id)sender;

@end
