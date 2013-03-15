//
//  CustomerContactController.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CustomerContact.h"


@interface CustomerContactController : NSWindowController {

  NSWindow *mainApplicationWindow;
  IBOutlet NSButton *closeWindowButton;
  bool runningModal;
  
  IBOutlet NSButton *contactsSelectButton;
  IBOutlet NSSearchField *contactsSearchField;
  int previousLengthOfContactSearchString;
  IBOutlet NSTableView *contactsTableView;
  IBOutlet NSArrayController *contactsArrayController;
  NSMutableArray *contactsArray;
  CustomerContact *currentlyViewedContact;
  IBOutlet NSTextField *contactsCookTextField;
  IBOutlet NSTextField *contactsSubjectTextField;
  IBOutlet NSDatePicker *contactsDatePicker;
  IBOutlet NSTextView *contactsBodyTextView;
  IBOutlet NSMatrix *contactsMessageTypeMatrix;
  IBOutlet NSButton *contactsCancelEditButton;
  IBOutlet NSButton *contactsSaveEditButton;
}

// for dealloc
- (void)deallocAnArray:(NSArray *)array;

// preparing window
- (void)runCustomerContactModal;
- (void)setupWindow;

  // closing the window
- (IBAction)closeWindowButtonClicked:(id)sender;

  // clear tabs
- (void)clearContactsTab;

// clear methods
- (void)clearTextField:(NSTextField *)tf;
- (void)clearTextView:(NSTextView *)tv;

 // date munging
- (NSString *)datePickerDateToString:(NSDatePicker *)dp;
- (bool)date:(NSCalendarDate *)d1 equalsDate:(NSCalendarDate *)d2;
- (NSCalendarDate *)calendarDateFromDate:(NSDate *)date;
- (NSCalendarDate *)calendarDateFromDatePicker:(NSDatePicker *)dp;
- (NSString *)stringFromTextField:(NSTextField *)tf andCalendarDate:(NSCalendarDate *)c;

  // textfield, textview, formcell string testing
- (bool)string:(NSString *) s1 equalsString:(NSString *)s2;
- (bool)textField:(NSTextField *)tf equalsString:(NSString *)str;
- (bool)textView:(NSTextView *)tv equalsString:(NSString *)str;

// handlers
- (void)setupNotificationObservers;
- (void)handleContactsChange:(NSNotification *)note;

  // searching
- (void)handleContactSearchFieldDidChange:(NSNotification *)note;

// editing
- (void)handleContactInfoChange:(NSNotification *)note;

// a delegate for text view changes
- (void) textDidChange: (NSNotification *) notification;


// actions
- (IBAction) contactsDatePickerClicked:(id)sender;
- (IBAction) contactsMessageTypeMatrixClicked:(id)sender;
- (IBAction) contactsCancelEditButtonClicked:(id)sender;
- (IBAction) contactsSaveEditButtonClicked:(id)sender;
  // proxy for selectButtonClicked
- (IBAction) showContactInfo:(id)sender;
- (NSString *)stringForContactTypeFromMatrix;
- (NSString *)stringForContactTypeFromContact;
- (void)enableOrDisableContactsTab:(bool)enable;
- (void)enableContactSaveButtonIfAppropriate;


// accessors
- (NSWindow *)mainApplicationWindow;
- (NSMutableArray *)contactsArray;
- (CustomerContact *)currentlyViewedContact;
- (bool)runningModal;

  // setters
- (void)setMainApplicationWindow:(NSWindow *)mainWindow;
- (void)setContactsArray:(NSMutableArray *)array;
- (void)setCurrentlyViewedContact:(CustomerContact *)contact;
- (void)setRunningModal:(bool)modal;

@end
