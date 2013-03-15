//
//  BasicWindowController.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class BugReportController;

@interface BasicWindowController : NSWindowController {
  bool runningModal;
  
  NSWindow *parentWindow;
  BugReportController *bugReportController;
  
  IBOutlet NSButton *bugButton;
  
  IBOutlet NSProgressIndicator *progressIndicator;
  IBOutlet NSPanel *progressPanel;
  IBOutlet NSTextField *progressMessageTextField;
  
  NSMutableCharacterSet *badLatexChars;
  
}

-(IBAction)bugButtonClicked:(id)sender;

- (void)setBugReportController:(BugReportController *)brc;

- (NSWindow *)parentWindow;
- (void)setParentWindow:(NSWindow *)w;
- (NSMutableCharacterSet *)badLatexChars;
- (void)setBadLatexChars:(NSMutableCharacterSet *)arg;

- (void)setupButtons;
- (void)setupTextFields;
- (void)setupTables;
- (void)setupStateVariables;
  
- (void)setupForNonModal;
- (void)setupForModal;
- (void)runModalWithParent:(NSWindow *)parent;
- (void)stopModalAndCloseWindow;
- (void)runNonModal:(id)sender;


- (NSArray *)arrayFromDictionary:(NSDictionary *) DictionarySingleton;

  // clear methods
- (void)clearTextField:(NSTextField *)tf;
- (void)clearTextView:(NSTextView *)tv;
- (void)clear1DForm:(NSForm *)f;

- (void)hideAndDisableButton:(NSButton *)b;
- (void)showAndEnableButton:(NSButton *)b;

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
- (bool)formCell:(NSFormCell *)fc equalsString:(NSString *)str;
- (bool)stringIsEmpty:(NSString *)str;
- (bool)textFieldIsEmpty:(NSTextField *)tf;
- (bool)textViewIsEmpty:(NSTextView *)tv;
- (bool)formCellIsEmpty:(NSFormCell *)fc;
- (NSString *)stringFromComboBox:(NSComboBox *)box;
- (void)makeTextFieldEditable:(NSTextField *)tf;
- (void)makeTextFieldUneditable:(NSTextField *)tf;
- (NSString *)lowercaseAndLatexSafeStringFromTextField:(NSTextField *)tf;
- (NSString *)lowercaseStringFromTextField:(NSTextField *)tf;
- (NSString *)latexSafeStringFromTextField:(NSTextField *)tf;
- (NSString *)lowercaseAndLatexSafeStringFromTextView:(NSTextView *)tv;
- (NSString *)lowercaseStringFromTextView:(NSTextView *)tv;
- (NSString *)latexSafeStringFromTextView:(NSTextView *)tv;
- (NSString *)lowercaseAndLatexSafeStringFromString:(NSString *)str;
- (NSString *)lowercaseStringFromString:(NSString *)str;
- (NSString *)latexSafeStringFromString:(NSString *)str;


- (bool)boolValueForRadioMatrix:(NSMatrix *)m cell:(NSCell *)cell;

- (void)showProgressPanel:(NSString *)msg;
- (void)closeProgressPanel;

  // handlers
- (void)setupNotificationObservers;
- (void)textDidChange:(NSNotification *) note;

- (bool)runningModal;
- (void)setRunningModal:(bool)modal;


@end
