//
//  PersonInfoController.h
//  BicycleKitchenPOS
//
//  Created by moody on 7/21/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Person.h"
#import "CustomerContact.h"
#import "ProjectInformationController.h"
#import "ViewInvoice.h"

@interface PersonInfoController : BasicWindowController {
  
  ProjectInformationController *projectInformationController;
  NSWindow *mainApplicationWindow;
  
  ViewInvoice *invoiceViewer;
  
  // setting the title
  IBOutlet NSTextField *titleTextField;
  // close window button
  IBOutlet NSButton *closePanelButton;
  // pointer to main application window
  IBOutlet NSTabView *personInfoTabView;
  
  // pointer to people controller
  NSArrayController *peopleController;
  
  // information tab
  IBOutlet NSTextField *infoNameTextField;
  IBOutlet NSTextField *infoPhoneTextField;
  IBOutlet NSTextField *infoEmailTextField;
  IBOutlet NSTextField *infoBalanceTextField;
  IBOutlet NSButton *infoAcceptCheckButton;
  IBOutlet NSButton *infoSignedWaiverButton;
  IBOutlet NSButton *infoSaveEditButton;
  IBOutlet NSButton *infoCancelButton;
  IBOutlet NSTextField *infoMemberTypeTextField;
  IBOutlet NSComboBox *infoMemberTypeComboBox;
  IBOutlet NSTextField *infoMembershipEndTextField;
  IBOutlet NSDatePicker *infoMembershipEndDateDatePicker;
  
  // projects tab
  IBOutlet NSSearchField *projectSearchField;
  IBOutlet NSTableView *projectTableView;
  IBOutlet NSArrayController *projectsControllerInPersonInfoPanel;
  NSMutableArray *projectsInPersonInfoPanel;
  
  // contacts tab
  IBOutlet NSSearchField *contactsSearchField;
  IBOutlet NSTableView *contactsTableView;
  IBOutlet NSButton *contactsDeleteButton;
  IBOutlet NSButton *contactsNewButton;
  IBOutlet NSTextField *contactCookTextField;
  IBOutlet NSDatePicker *contactDatePicker;
  IBOutlet NSTextField *contactSubjectTextField;
  IBOutlet NSTextView *contactBodyTextView;
  //IBOutlet NSTextField *contactBodyTextField;
  IBOutlet NSMatrix *contactTypeMatrix;
  //IBOutlet NSButton *contactPhoneButton;
  //IBOutlet NSButton *contactEmailButton;
  //IBOutlet NSButton *contactInPerson;
  IBOutlet NSButton *contactSaveButton;
  IBOutlet NSButton *contactCancelButton;
  IBOutlet NSArrayController *contactsControllerInPersonInfoPanel;
  NSMutableArray *contactsInPersonInfoPanel;
  CustomerContact *currentlyViewedContact;
  
  // comments
//  IBOutlet NSSearchField *commentSearchField;
//  IBOutlet NSTableView *commentTableView;
//  IBOutlet NSButton *commentDeleteButton;
//  IBOutlet NSButton *commentNewButton;
//  IBOutlet NSTextField *commentCookTextField;
//  IBOutlet NSDatePicker *commentDatePicker;
//  IBOutlet NSTextField *commentSubjectTextField;
//  IBOutlet NSTextView *commentTextView;
//  IBOutlet NSButton *commentSaveButton;
//  IBOutlet NSArrayController *commentsControllerInPersonInfoPanel;
  NSMutableArray *commentsInPersonInfoPanel;
  
  // invoices
  //IBOutlet NSSearchField *invoicesSearchField;
  IBOutlet NSTableView *invoicesTableView;
  //IBOutlet NSTableView *itemsTableView;
  IBOutlet NSArrayController *invoicesControllerInPersonInfoPanel;
  //IBOutlet NSArrayController *itemsControllerForInvoiceInInfoPanel;
  NSMutableArray *invoicesInPersonInfoPanel;
  //NSMutableArray *itemsForInvoiceInInfoPanel;
  
  // credits
  IBOutlet NSSearchField *creditsSearchField;
  IBOutlet NSTableView *creditsTableView;
  IBOutlet NSButton *creditsDeleteButton;
  IBOutlet NSButton *creditsNewButton;
  IBOutlet NSTextField *creditsTotalCreditsTextField;
  IBOutlet NSTextField *creditsRemainingCreditsTextField;
  IBOutlet NSTextField *creditsCookTextField;
  IBOutlet NSDatePicker *creditsDatePicker;
  IBOutlet NSTextField *creditsCommentTextField;
  IBOutlet NSTextField *creditsAmountTextField;
  IBOutlet NSButton *creditsSaveButton;
  IBOutlet NSArrayController *creditsControllerInPersonInfoPanel;
  IBOutlet NSTextView *creditsBodyTextView;
  NSMutableArray *creditsInPersonInfoPanel;

  Person *currentlyViewedPerson;
  
  bool bypassDuplicatePerson;
  
  //searching
  int previousLengthOfContactSearchString;
}

//******************************************************************************
// accessor
//******************************************************************************

- (NSWindow *)mainApplicationWindow;
- (NSArrayController *)peopleController;
- (NSMutableArray *)projectsInPersonInfoPanel;
- (NSMutableArray *)contactsInPersonInfoPanel;  
- (NSMutableArray *)commentsInPersonInfoPanel;  
- (NSMutableArray *)invoicesInPersonInfoPanel;
//- (NSMutableArray *)itemsForInvoiceInInfoPanel;  
- (NSMutableArray *)creditsInPersonInfoPanel;
- (Person *)currentlyViewedPerson;
- (CustomerContact *)currentlyViewedContact;
- (ProjectInformationController *)projectInformationController;
- (void)setProjectInformationController:(ProjectInformationController *)controller;

//******************************************************************************
// setters
//******************************************************************************
- (void)setMainApplicationWindow:(NSWindow *)w;
- (void)setPeopleController:(NSArrayController *)pc;
- (void)setProjectsInPersonInfo:(NSMutableArray *)pc;
- (void)setContactsInPersonInfoPanel:(NSMutableArray *)cp;
- (void)setCommentsInPersonInfoPanel:(NSMutableArray *)cp;
- (void)setInvoicesInPersonInfoPanel:(NSMutableArray *)ip;
//- (void)setItemsForInvoiceInInfoPanel:(NSMutableArray *)ip;
- (void)setCreditsInPersonInfoPanel:(NSMutableArray *)cp;
- (void)setCurrentlyViewedPerson:(Person *)p;
- (void)setCurrentlyViewedContact:(CustomerContact *)contact;

//******************************************************************************
// actions
//******************************************************************************

- (IBAction)closePanelButtonClicked:(id)sender;

- (IBAction)infoAcceptCheckButtonClicked:(id)sender;
- (IBAction)infoSignedWaiverButtonClicked:(id)sender;
- (IBAction)infoCancelButtonClicked:(id)sender;
- (IBAction)infoSaveEditButtonClicked:(id)sender; 
- (IBAction)infoMembershipEndDateDatePicker:(id)sender;
//- (IBAction)infoEditMembershipEndDateButtonClicked:(id)sender;
- (NSCalendarDate *)membershipEndDateForMemberType:(NSString *)type;

- (void)runBadNameWithName:(NSString *)name andBadPhone:(bool)badPhone andBadEmail:(bool)badEmail;
- (void)runBadPhone;
- (void)runBadEmail;
- (void)runEditPerson;
        

- (IBAction)contactDeleteButtonClicked:(id)sender;
- (IBAction)contactNewButtonClicked:(id)sender;
- (IBAction)contactCancelButtonClicked:(id)sender;
- (IBAction)contactDatePickerClicked:(id)sender;
- (IBAction)contactSaveButtonClicked:(id)sender; 
- (IBAction)displayContactInfo:(id)sender;

- (IBAction)commentDeleteButtonClicked:(id)sender;
- (IBAction)commentNewButtonClicked:(id)sender;
- (IBAction)commentSaveButtonClicked:(id)sender;

- (IBAction)creditsDeleteButtonClicked:(id)sender;
- (IBAction)creditsNewButtonClicked:(id)sender;
- (IBAction)creditsSaveButtonClicked:(id)sender;

//******************************************************************************
// helpers
//******************************************************************************

//******************************************************************************
// content setup
//******************************************************************************

- (void)setTitle;
- (void)setupInfoTab;
- (void)setupProjectsTab;
- (void)setupContactsTab;
- (void)setupCommentsTab;
- (void)setupInvoicesTab;
- (void)setupCreditsTab;

//******************************************************************************
// handlers
//******************************************************************************

- (void)handlePersonInfoChange:(NSNotification *)note;
- (bool)personInfoIsDifferent;
- (void)enableInfoEditButtonsIfAppropriate;
- (bool)personNameIsNotEmpty;

- (void)handleContactInfoChange:(NSNotification *)note;
- (bool)contactCookAndSubjectAreNotEmpty;
- (bool)contactIsDifferent;
- (NSString *)stringForContactTypeFromMatrix;
- (NSString *)stringForContactTypeFromContact;
- (void)enableContactSaveButtonIfAppropriate;
- (void)enableCreditsSaveButtonIfAppropriate;
          
- (void)textDidChange:(NSNotification *)note;
- (void)handleCommentInfoChange:(NSNotification *)note;
- (void)handleCreditInfoChange:(NSNotification *)note;
- (void)handleProjectSearchFieldChange:(NSNotification *)note;
- (void)handleContactSearchFieldChange:(NSNotification *)note;
- (void)handleCommentSearchFieldChange:(NSNotification *)note;
//- (void)handleInvoiceSearchFieldChange:(NSNotification *)note;
- (void)handleCreditSearchFieldChange:(NSNotification *)note;
- (void)handleInvoiceClicked:(id)sender;

//******************************************************************************
// undo
//******************************************************************************

- (void)startObservingPerson:(Person *)p;
- (void)stopObservingPerson:(Person *)p;

- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)obj toValue:(id)newValue;
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context;


- (void)insertObject:(CustomerContact *)c inContactsInPersonInfoPanelAtIndex:(int)index;
- (void) removeObjectFromContactsInPersonInfoPanelAtIndex:(int)index;

  
  
@end
