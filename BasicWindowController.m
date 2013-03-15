//
//  BasicWindowController.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "BasicWindowController.h"
#import "Books.h"
#import "BugReportController.h"

//@class BasicWindowController;

@implementation BasicWindowController

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setupNotificationObservers];
    NSCharacterSet *tmp = [NSCharacterSet characterSetWithCharactersInString:@"#\\${}()[]%&^_<>"];
    NSMutableCharacterSet *badChars = [tmp mutableCopy];
    [self setBadLatexChars:badChars];
  }
  return self;
}

- (void) dealloc {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  [parentWindow release];
  [bugReportController release];
  [badLatexChars release];
  [super dealloc];
}



//******************************************************************************

- (NSString *)lowercaseAndLatexSafeStringFromTextField:(NSTextField *)tf {
  return [self lowercaseAndLatexSafeStringFromString:[tf stringValue]];
}


//******************************************************************************

- (NSString *)lowercaseStringFromTextField:(NSTextField *)tf {
  return [[tf stringValue] lowercaseString];
}


//******************************************************************************

- (NSString *)latexSafeStringFromTextField:(NSTextField *)tf {
  return [self latexSafeStringFromString:[tf stringValue]];
}

//******************************************************************************

- (NSString *)lowercaseAndLatexSafeStringFromTextView:(NSTextView *)tv {
  return [self lowercaseAndLatexSafeStringFromString:[tv string]];
}

//******************************************************************************

- (NSString *)lowercaseStringFromTextView:(NSTextView *)tv {
  return [[tv string] lowercaseString];
}

//******************************************************************************


- (NSString *)latexSafeStringFromTextView:(NSTextView *)tv {
  return [self latexSafeStringFromString:[tv string]];
}

//******************************************************************************


- (NSString *)lowercaseAndLatexSafeStringFromString:(NSString *)str {
  NSMutableString *mstr = [[str lowercaseString] mutableCopy];
  NSRange range = [mstr rangeOfCharacterFromSet:badLatexChars];
  while (range.location != NSNotFound) {
    [mstr replaceCharactersInRange:range withString:@" "];
    range = [mstr rangeOfCharacterFromSet:badLatexChars];
  }
  NSString *returnVal = [NSString stringWithString:mstr];
  [mstr release];
  return returnVal;
}

//******************************************************************************

- (NSString *)lowercaseStringFromString:(NSString *)str {
  return [str lowercaseString];
}

//******************************************************************************

- (NSString *)latexSafeStringFromString:(NSString *)str {
  NSMutableString *mstr = [str mutableCopy];
  NSRange range = [mstr rangeOfCharacterFromSet:badLatexChars];
  while (range.location != NSNotFound) {
    [mstr replaceCharactersInRange:range withString:@" "];
    range = [mstr rangeOfCharacterFromSet:badLatexChars];
  }
  return [mstr copy];
}

//******************************************************************************

- (void)setBugReportController:(BugReportController *)brc {
  if (bugReportController != brc) {
    [brc retain];
    [bugReportController release];
    bugReportController = brc;
  }
}

-(IBAction)bugButtonClicked:(id)sender {
  if (bugReportController == nil) {
    BugReportController *tmp = [[BugReportController alloc] init];
    [self setBugReportController:tmp];
    [tmp release];
  }
  if (runningModal) {
    ////NSLog(@"window is running modal");
    [bugReportController setupForModal];
    [bugReportController runModalWithParent:[self window]];
   // [[self window] makeKeyAndOrderFront:self];
  } else {
    [bugReportController setupForNonModal];
    [bugReportController runNonModal:self];
   // [[self window] makeKeyAndOrderFront:self];
  }
}

- (void)windowDidLoad {
  if (runningModal) {
    [self setupForModal];
  } else {
    [self setupForNonModal];
  }  
  [super windowDidLoad];
}


- (NSWindow *)parentWindow {
  return parentWindow;
}

- (void)setParentWindow:(NSWindow *)w {
  [w retain];
  [parentWindow release];
  parentWindow = w;
}


- (void)setupForNonModal {
  // put your non modal setup stuff here
  [self setRunningModal:NO];
}

- (void)setupForModal {
  // put your modal setup stuff here
  [self setRunningModal:YES];
}


- (void)runModalWithParent:(NSWindow *)parent {
  // do all of your initialization BEFORE you call the modal code
  [self setParentWindow:parent];
  [NSApp beginSheet:[self window]
     modalForWindow:parent
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];
  
  [NSApp runModalForWindow:[self window]];
  
  [NSApp endSheet:[self window]];
  [[self window] orderOut:self];
  
}

- (void)stopModalAndCloseWindow {
  [NSApp stopModal];
  [[self window] close];
}


- (void)runNonModal:(id)sender {
  //NSLog(@"runNonModal");
  [[self window] makeKeyAndOrderFront:sender];
}

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
}

// this is for textView changes
- (void) textDidChange: (NSNotification *) notifications {
}


- (void)showProgressPanel:(NSString *)message {
  [progressIndicator startAnimation:self];
  [progressMessageTextField setStringValue:message];
  [progressPanel makeKeyAndOrderFront:self];
}

- (void)closeProgressPanel {
  [progressIndicator stopAnimation:self];
  [self clearTextField:progressMessageTextField];
  [progressPanel close];
}

//******************************************************************************

- (NSArray *)arrayFromDictionary:(NSDictionary *) dict {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  NSEnumerator *e = [dict objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    [result addObject:value];
  }
  NSArray *returnVal = [NSArray arrayWithArray:result];
  [result release];
  return returnVal;
}

//******************************************************************************

- (void)setupButtons {
  
}

//******************************************************************************

- (void)setupTextFields {
  
}

//******************************************************************************

- (void)setupTables {
  
}

//******************************************************************************


- (void)setupStateVariables {
  
}


//******************************************************************************

- (void)clearTextField:(NSTextField *)tf {
  NSString *emptyString = [NSString stringWithFormat:@""];
  [tf setStringValue:emptyString];
}

//******************************************************************************

- (void)clearTextView:(NSTextView *)tw {
  NSString *emptyString = [NSString stringWithFormat:@""];
  [tw setString:emptyString];
}

//******************************************************************************

- (void)clear1DForm:(NSForm *)f {
  NSString *emptyString = [NSString stringWithFormat:@""];
  int i;
  for (i=0; i < [f numberOfRows]; i++) {
    [[f cellAtIndex:i] setStringValue:emptyString];
  }
}


//******************************************************************************
// controlling edit/save buttons
//******************************************************************************

- (void)hideAndDisableButton:(NSButton *)b {
  [b setHidden:YES];
  [b setEnabled:NO];
}

- (void)showAndEnableButton:(NSButton *)b {
  [b setHidden:NO];
  [b setEnabled:YES];
}


- (NSString *)datePickerDateToString:(NSDatePicker *)dp {
  NSDate *date = [dp dateValue];
  NSCalendarDate *newCDate = 
    [NSCalendarDate dateWithString:[date description]
                    calendarFormat: @"%Y-%m-%d %H:%M:%S %z"];
  NSString *dateStr  = 
    [[newCDate descriptionWithCalendarFormat:@"%m/%d/%Y" timeZone:nil locale:nil]
      description];
  return dateStr;
}

//******************************************************************************

- (bool)date:(NSCalendarDate *)d1 equalsDate:(NSCalendarDate *)d2 {
  NSString *d1String = [[d1 descriptionWithCalendarFormat:@"%m/%d/%Y" 
                                                 timeZone:nil 
                                                   locale:nil]
    description];
  NSString *d2String = [[d2 descriptionWithCalendarFormat:@"%m/%d/%Y" 
                                                 timeZone:nil 
                                                   locale:nil]
    description];
  
  return [d1String isEqualToString:d2String];
}

//******************************************************************************

- (NSCalendarDate *)calendarDateFromDate:(NSDate *)date {
  NSCalendarDate *newCDate = 
  [NSCalendarDate dateWithString:[date description]
                  calendarFormat: @"%Y-%m-%d %H:%M:%S %z"];
  return newCDate;
}

//******************************************************************************

- (NSCalendarDate *)calendarDateFromDatePicker:(NSDatePicker *)dp {
  return [self calendarDateFromDate:[dp dateValue]];
}

//******************************************************************************

- (bool)string:(NSString *)s1 equalsString:(NSString *)s2 {
  return [s1 isEqualToString:s2];
}

//******************************************************************************

- (bool)textField:(NSTextField *)tf equalsString:(NSString *)str {
  return [self string:str equalsString:[[tf stringValue] lowercaseString]];
}

//******************************************************************************

- (bool)textView:(NSTextView *)tv equalsString:(NSString *)str {
  ////NSLog(@"tv string: %@", [tv string]);
  ////NSLog(@"str: %@", str);
  return [self string:str equalsString:[[tv string] lowercaseString]];
}

//******************************************************************************

- (bool)formCell:(NSFormCell *)fc equalsString:(NSString *)str {
  return [self string:str equalsString:[[fc stringValue] lowercaseString]];
}

//******************************************************************************

- (bool)stringIsEmpty:(NSString *)str {
  return [str isEqualToString:[NSString stringWithFormat:@""]];
}

- (NSString *)stringFromComboBox:(NSComboBox *)box {
  NSString *result = [box objectValueOfSelectedItem];
  if (result == nil) result = [box stringValue];
  return result;
}

- (bool)textFieldIsEmpty:(NSTextField *)tf {
  NSString *emptyString = [NSString stringWithFormat:@""];
  return [self textField:tf equalsString:emptyString];
}

- (bool)textViewIsEmpty:(NSTextView *)tv {
  NSString *emptyString = [NSString stringWithFormat:@""];
  return [self textView:tv equalsString:emptyString];
}  

- (bool)formCellIsEmpty:(NSFormCell *)fc {
  NSString *emptyString = [NSString stringWithFormat:@""];
  return [self formCell:fc equalsString:emptyString];
}


- (void)makeTextFieldEditable:(NSTextField *)tf {
  [tf setEnabled:YES];
  [tf setEditable:YES];
}

- (void)makeTextFieldUneditable:(NSTextField *)tf {
  [tf setEnabled:NO];
  [tf setEditable:NO];
}

//******************************************************************************

- (NSString *)stringFromTextField:(NSTextField *)tf andCalendarDate:(NSCalendarDate *)c {
  NSFormatter *form = [tf formatter];
  NSString *str = [form stringForObjectValue:c];
  return str;
}

//******************************************************************************

- (bool)boolValueForRadioMatrix:(NSMatrix *)m cell:(NSCell *)cell {
  NSCell *selected = [m selectedCell];
  if ([cell state] == 1 && cell == selected) {
    return YES;
  } else {
    return NO;
  }
}

//******************************************************************************

- (bool)runningModal {
  return runningModal;
}

- (void)setRunningModal:(bool)modal {
  runningModal = modal;
}

- (NSMutableCharacterSet *)badLatexChars {
  return badLatexChars;
}
- (void) setBadLatexChars:(NSMutableCharacterSet *)arg {
  [arg retain];
  [badLatexChars release];
  badLatexChars = arg;
}


@end
