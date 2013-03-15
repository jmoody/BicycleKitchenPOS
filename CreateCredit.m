//
//  CreateCredit.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CreateCredit.h"
#import "Credits.h"
#import "People.h"

@implementation CreateCredit

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"CreateCredit"];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [credit release];
  [person release];
  [super dealloc];
}

//******************************************************************************
// windowing
//******************************************************************************

- (void)windowDidLoad {
  [super windowDidLoad];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
  [self setupStateVariables];
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
  [self setupStateVariables];
}

//******************************************************************************

- (void)setupForNonModal {
  [super setupForNonModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
  [self setupStateVariables];
}

//******************************************************************************

- (void)runModalWithParent:(NSWindow *) parent {
  [super runModalWithParent:parent];
}


//******************************************************************************
// setup
//******************************************************************************

- (void)setupButtons {
  [createCreditButton setEnabled:NO];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
}

//******************************************************************************

- (void)setupTextFields {
  [self clearTextField:cookTextField];
  [self clearTextField:amountTextField];
  [self clearTextField:reasonTextField];
  [self clearTextView:notesTextView];
}

//******************************************************************************

- (void)setupTables {
}

//******************************************************************************

- (void)setupStateVariables {
  [self setCredit:nil];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)datePickerClicked:(id)sender {
  //NSLog(@"datePicker clicked");
}

//******************************************************************************

- (IBAction)cancelButtonClicked:(id)sender {
  //NSLog(@"cancelButton clicked");
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

//******************************************************************************

- (IBAction)createCreditButtonClicked:(id)sender {
  //NSLog(@"createCreditButton clicked");
  ShopCredit *new = [[ShopCredit alloc] init];
  [new setCommentAuthorName:[self latexSafeStringFromTextField:cookTextField]];
  [new setCreditAmount:[amountTextField doubleValue]];
  [new setCommentSubject:[self lowercaseAndLatexSafeStringFromTextField:reasonTextField]];
  [new setCommentText:[self lowercaseAndLatexSafeStringFromTextView:notesTextView]];
  [new setDate:[self calendarDateFromDatePicker:datePicker]];
  //NSLog(@"new credit: %@", new);
  // keep this order to get the tabling correct
  //NSLog(@"person creditUids: %@", [person creditUids]);
  [[person creditUids] addObject:[new uid]];
  [[People sharedInstance] saveToDisk];
 // NSLog(@"person creditUids: %@", [person creditUids]);
  
  //NSLog(@"credits: %@",[[Credits sharedInstance] dictionary]);
  [new setOwnerUid:[person uid]];
  [[Credits sharedInstance] setObject:new forUid:[new uid]];
  //NSLog(@"credits: %@",[[Credits sharedInstance] dictionary]);
  
  [new release];
  
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}


//******************************************************************************
// misc
//******************************************************************************
- (void)enableSaveButtonAppropriately {
  if ([self textFieldIsEmpty:cookTextField] ||
      [self textFieldIsEmpty:amountTextField] ||
      [self textFieldIsEmpty:reasonTextField]) {
    [createCreditButton setEnabled:NO];
  } else {
    [createCreditButton setEnabled:YES];
  }
}

//******************************************************************************
// handlers
//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    [self enableSaveButtonAppropriately];
  }
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (ShopCredit *)credit {
  return credit;
}
- (void) setCredit:(ShopCredit *)arg {
  [arg retain];
  [credit release];
  credit = arg;
}
- (Person *)person {
  return person;
}
- (void) setPerson:(Person *)arg {
  [arg retain];
  [person release];
  person = arg;
}



//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:cookTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:amountTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:reasonTextField];
  
}
@end