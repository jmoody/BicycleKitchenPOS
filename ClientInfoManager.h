//
//  ClientInfoManager.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/20/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Person.h"
#import "Project.h"
#import "CustomerContact.h"
#import "Invoice.h"
#import "ShopCredit.h"
#import "CreateCorrespondence.h"
#import "CreateCredit.h"
#import "ProjectInformationController.h"
#import "ViewInvoice.h"


@interface ClientInfoManager : BasicWindowController {
  
  CreateCorrespondence *contactCreator;
  CreateCredit *creditCreator;
  ProjectInformationController *projectInfo;
  ViewInvoice *invoiceViewer;
    
  Person *person;
  Project *project;
  CustomerContact *contact;
  Invoice *invoice;
  ShopCredit *credit;
  IBOutlet NSTableView *projectsTableView;
  IBOutlet NSArrayController *projectsArrayController;
  NSMutableArray *projectsArray;
  IBOutlet NSTableView *contactsTableView;
  IBOutlet NSArrayController *contactsArrayController;
  NSMutableArray *contactsArray;
  IBOutlet NSTableView *invoicesTableView;
  IBOutlet NSArrayController *invoicesArrayController;
  NSMutableArray *invoicesArray;
  IBOutlet NSTableView *creditsTableView;
  IBOutlet NSArrayController *creditsArrayController;
  NSMutableArray *creditsArray;
  IBOutlet NSButton *closeButton;
  IBOutlet NSButton *infoSaveButton;
  IBOutlet NSButton *infoCancelButton;
  IBOutlet NSButton *acceptCheckButton;
  IBOutlet NSButton *waiverButton;
  IBOutlet NSTextField *nameTextField;
  IBOutlet NSTextField *phoneTextField;
  IBOutlet NSTextField *emailTextField;
  IBOutlet NSTextField *companyTextField;
  IBOutlet NSTextField *addressTextField;
  IBOutlet NSTextField *addressStateTextField;
  IBOutlet NSTextField *cityTextField;
  IBOutlet NSTextField *zipTextField;
  IBOutlet NSTextField *membershipTextField;
  IBOutlet NSTextField *endDate1TextField;
  IBOutlet NSTextField *endDate2TextField;
  IBOutlet NSTextField *balanceTextField;
  IBOutlet NSSearchField *projectsSearchField;
  int previousLengthOfProjectsSearchString;
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
  IBOutlet NSSearchField *invoicesSearchField;
  int previousLengthOfInvoicesSearchString;
  IBOutlet NSTextField *creditTotalTextField;
  IBOutlet NSSearchField *creditsSearchField;
  int previousLengthOfCreditsSearchString;
  IBOutlet NSButton *newCreditButton;
  IBOutlet NSButton *deleteCreditButton;
  IBOutlet NSTextField *creditCookTextField;
  IBOutlet NSTextField *creditAmountTextField;
  IBOutlet NSTextField *creditReasonTextField;
  IBOutlet NSTextView *creditNoteTextView;
  IBOutlet NSDatePicker *creditDatePicker;
  IBOutlet NSButton *creditCancelButton;
  IBOutlet NSButton *creditSaveButton;
  IBOutlet NSTabView *theTabView;
}


//******************************************************************************
// prototypes
//******************************************************************************

- (CreateCorrespondence *)contactCreator;
- (void)setContactCreator:(CreateCorrespondence *)arg;
- (CreateCredit *)creditCreator;
- (void)setCreditCreator:(CreateCredit *)arg;
- (ProjectInformationController *)projectInfo;
- (void)setProjectInfo:(ProjectInformationController *)arg;
- (ViewInvoice *)invoiceViewer;
- (void)setInvoiceViewer:(ViewInvoice *)arg;

- (Person *)person;
- (void)setPerson:(Person *)arg;
- (Project *)project;
- (void)setProject:(Project *)arg;
- (CustomerContact *)contact;
- (void)setContact:(CustomerContact *)arg;
- (Invoice *)invoice;
- (void)setInvoice:(Invoice *)arg;
- (ShopCredit *)credit;
- (void)setCredit:(ShopCredit *)arg;
- (NSMutableArray *)projectsArray;
- (void)setProjectsArray:(NSArray *)arg;
- (void)handleProjectsClicked:(id)sender;
- (NSMutableArray *)contactsArray;
- (void)setContactsArray:(NSArray *)arg;
- (void)handleContactsClicked:(id)sender;
- (NSMutableArray *)invoicesArray;
- (void)setInvoicesArray:(NSArray *)arg;
- (void)handleInvoicesClicked:(id)sender;
- (NSMutableArray *)creditsArray;
- (void)setCreditsArray:(NSArray *)arg;
- (void)handleCreditsClicked:(id)sender;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)infoSaveButtonClicked:(id)sender;
- (IBAction)infoCancelButtonClicked:(id)sender;
- (IBAction)acceptCheckButtonClicked:(id)sender;
- (IBAction)waiverButtonClicked:(id)sender;
- (IBAction)deleteContactButtonClicked:(id)sender;
- (IBAction)newContactButtonClicked:(id)sender;
- (IBAction)messageTypeMatrixClicked:(id)sender;
- (IBAction)contactDatePickerClicked:(id)sender;
- (IBAction)contactCancelButtonClicked:(id)sender;
- (IBAction)contactSaveButtonClicked:(id)sender;
- (IBAction)newCreditButtonClicked:(id)sender;
- (IBAction)deleteCreditButtonClicked:(id)sender;
- (IBAction)creditDatePickerClicked:(id)sender;
- (IBAction)creditCancelButtonClicked:(id)sender;
- (IBAction)creditSaveButtonClicked:(id)sender;


  //******************************************************************************
  // handlers
  //******************************************************************************
- (void)handleProjectsChange:(NSNotification *)note;
- (void)handleCustomerContactsChange:(NSNotification *)note;
- (void)handleInvoicesChange:(NSNotification *)note;
- (void)handleCreditsChange:(NSNotification *)note;
- (void)handleProjectsSearchFieldChange:(NSNotification *)note;
- (void)handleContactsSearchFieldChange:(NSNotification *)note;
- (void)handleContactsTableViewSelectionChange:(NSNotification *)note;
- (void)handleInvoicesSearchFieldChange:(NSNotification *)note;
- (void)handleCreditsSearchFieldChange:(NSNotification *)note;
- (void)handleCreditsTableViewSelectionChange:(NSNotification *)note;

  //******************************************************************************
  // misc
  //******************************************************************************
- (NSMutableArray *)clientProjects;
- (NSMutableArray *)clientContacts;
- (NSMutableArray *)clientInvoices;
- (NSMutableArray *)clientCredits;
- (void)runBadNameWithName:(NSString *)name andBadPhone:(bool)badPhone andBadEmail:(bool)badEmail;
- (void)runBadPhone;
- (void)runBadEmail;
- (void)runEditPerson;
- (void)enableInfoSaveEditAppropriately;
- (void)enableContactSaveEditAppropriately;
- (void)enableCreditSaveEditAppropriately;
        

@end