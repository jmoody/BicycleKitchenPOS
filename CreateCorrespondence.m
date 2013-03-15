//
//  CreateCorrespondence.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CreateCorrespondence.h"
#import "Contacts.h"
#import "People.h"

@implementation CreateCorrespondence

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"CreateCorrespondence"];
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [contact release];
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
  //NSLog(@"setupForModal");
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
  [saveButton setEnabled:NO];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
  [messageTypeMatrix setState:1 atRow:0 column:0];
}

//******************************************************************************

- (void)setupTextFields {
  [self clearTextField:cookTextField];
  [self clearTextField:subjectTextField];
  [self clearTextView:noteTextView];
}

//******************************************************************************

- (void)setupTables {
  
}

//******************************************************************************

- (void)setupStateVariables {
  [self setContact:nil];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)datePickerClicked:(id)sender {
  //NSLog(@"datePicker clicked");
  
}

//******************************************************************************

- (IBAction)messageTypeMatrixClicked:(id)sender {
  //NSLog(@"messageTypeMatrix clicked");
}

//******************************************************************************

- (IBAction)saveButtonClicked:(id)sender {
  //NSLog(@"saveButton clicked");
  CustomerContact *new = [[CustomerContact alloc] init];
  [new setCommentAuthorName:[self latexSafeStringFromTextField:cookTextField]];
  [new setCommentSubject:[self lowercaseAndLatexSafeStringFromTextField:subjectTextField]];
  [new setCommentText:[self lowercaseAndLatexSafeStringFromTextView:noteTextView]];
  [new setDate:[self calendarDateFromDatePicker:datePicker]];
  int message = [[messageTypeMatrix cellAtRow:0 column:0] state];
  int spoke = [[messageTypeMatrix cellAtRow:0 column:1] state];
  int email = [[messageTypeMatrix cellAtRow:0 column:2] state];
  
  if (message == 1) {
    [new setLeftMessage:YES];
  } else {
    [new setLeftMessage:NO];
  }
  
  if (spoke == 1) {
    [new setSpokeDirectly:YES];
  } else {
    [new setSpokeDirectly:NO];
  }

  if (email == 1) {
    [new setSentEmail:YES];
  } else {
    [new setSentEmail:NO];
  }

  // do this first to get the tabling correct.
  [[person contactUids] addObject:[new uid]];
  [[People sharedInstance] saveToDisk];
  
  [new setPersonUid:[person uid]];
  [[Contacts sharedInstance] setObject:new forUid:[new uid]];
 
  [new release];
  
  [self setContact:new];
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
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
// misc
//******************************************************************************

- (void)enableSaveButtonAppropriately {
  if ([self textFieldIsEmpty:cookTextField] ||
      [self textFieldIsEmpty:subjectTextField]) {
    [saveButton setEnabled:NO];
  } else {
    [saveButton setEnabled:YES];
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

- (CustomerContact *)contact {
  return contact;
}
- (void) setContact:(CustomerContact *)arg {
  [arg retain];
  [contact release];
  contact = arg;
}
- (Person *)person {
  return person;
}
- (void) setPerson:(Person *)arg {
  //NSLog(@"person: %@", arg);
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
           object:subjectTextField];
  
}
@end