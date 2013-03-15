//
//  OpenBookController.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "OpenBookController.h"
#import "Books.h";
#import "Book.h"
#import "PreferenceController.h"

@implementation OpenBookController

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:YES];
    self = [super initWithWindowNibName:@"OpenBook"];
  }
  return self;
}

- (void) dealloc {
  [currentBook release];
  [super dealloc];
}


//******************************************************************************

- (void)runModalWithParent:(NSWindow *)parent {
  [super runModalWithParent:parent];
}

- (void)setupForModal {
  [super setupForModal];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  double starting = [[defaults objectForKey:TljBkPosStartingBookAmount] doubleValue];
  // should allow for less money to be present -jjm
  [openingStepper setMinValue:0.0];
  [openingStepper setDoubleValue:starting];
  [openingTextField setDoubleValue:starting];
  [haveCountedChangeButton setState:0];
  [doneButton setEnabled:NO];
}

//******************************************************************************

- (void)windowDidLoad {
  // only gets run once
  [super windowDidLoad];
  // have to have this here because when the window is first loaded, the fucking
  // browser isn't sized correctly.
}


- (IBAction)openingStepperClicked:(id)sender {
  [openingTextField setDoubleValue:[openingStepper doubleValue]];
}

- (IBAction)haveCountedChangeButtonClicked:(id)sender {
  if ([haveCountedChangeButton state] == 1) {
    [doneButton setEnabled:YES];
  } else {
    [doneButton setEnabled:NO];
  }
}

- (IBAction)cancelButtonClicked:(id)sender {
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

- (IBAction)doneButtonClicked:(id)sender {
  double opening = [openingStepper doubleValue];
  Book *book = [[Book alloc] init];
	[book setIsOpen:YES];
  [book setStartingBalance:opening];
  // date is already set to today
  [[Books sharedInstance] setObject:book forUid:[book uid]];
  [[Books sharedInstance] setCurrentBook:book];
  [self setCurrentBook:book];
  [book release];
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

- (Book *)currentBook {
  return currentBook;
}

- (void) setCurrentBook:(Book *)arg {
  [arg retain];
  [currentBook release];
  currentBook = arg;
}


@end
