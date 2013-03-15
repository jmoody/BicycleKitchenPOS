//
//  ProgressiveWindowController.m
//  ProgressiveWindowsApp
//
//  Created by moody on 10/7/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ProgressiveWindowController.h"


@implementation ProgressiveWindowController

- (id)init {
  
  self = [super init];
  if (self != nil) {
    self = [super initWithWindowNibName:@"PWC"];
  } 
  return self;
}

- (void)awakeFromNib {
  NSString *str = [NSString stringWithFormat:@"Step 1 of %d",
    [pwcTabView numberOfTabViewItems]];
  [pwcStepTextField setStringValue:str];
  //[pwcTitleTextField setStringValue:@"New Title"];
  [pwcTabView selectFirstTabViewItem:self];
  [self setPwcCurrentStep:0];
  [pwcBackButton setEnabled:NO];
}


- (void) setupForModal {
  NSString *str = [NSString stringWithFormat:@"Step 1 of %d",
    [pwcTabView numberOfTabViewItems]];
  [pwcStepTextField setStringValue:str];
  //[pwcTitleTextField setStringValue:@"New Title"];
  [pwcTabView selectFirstTabViewItem:self];
  [self setPwcCurrentStep:0];
  [super setupForModal];
  [pwcBackButton setEnabled:NO];
}

- (void) setupForNonModal {
  NSString *str = [NSString stringWithFormat:@"Step 1 of %d",
    [pwcTabView numberOfTabViewItems]];
  [pwcStepTextField setStringValue:str];
  //[pwcTitleTextField setStringValue:@"New Title"];
  [pwcTabView selectFirstTabViewItem:self];
  [self setPwcCurrentStep:0];
  [super setupForModal];  
  [pwcBackButton setEnabled:NO];
}

- (void) windowDidLoad {
  NSString *str = [NSString stringWithFormat:@"Step 1 of %d",
    [pwcTabView numberOfTabViewItems]];
  [pwcStepTextField setStringValue:str];
  //[pwcTitleTextField setStringValue:@"New Title"];
  [pwcTabView selectFirstTabViewItem:self];
  [self setPwcCurrentStep:0];
  [super setupForModal];  
  [pwcBackButton setEnabled:NO];
}

//******************************************************************************
// accessors
//******************************************************************************

- (int)pwcCurrentStep {
  return pwcCurrentStep;
}

- (NSTabView *)pwcTabView {
  return pwcTabView;
}


//******************************************************************************
// setters
//******************************************************************************

- (void)setPwcCurrentStep:(int)step {
  pwcCurrentStep = step;
}

//******************************************************************************
// actions
//******************************************************************************

- (IBAction) pwcNextButtonClicked:(id)sender {
  ////NSLog(@"next button clicked");
  [[self pwcTabView] selectNextTabViewItem:self];
  pwcCurrentStep++;
}

- (IBAction) pwcBackButtonClicked:(id)sender {
  ////NSLog(@"back button clicked");
  [[self pwcTabView] selectPreviousTabViewItem:self];
  [pwcNextButton setTitle:@"Next"];
  pwcCurrentStep--;
}

- (IBAction)showWindow:(id)sender {
  [super showWindow:sender];
}

//******************************************************************************
// delegate
//******************************************************************************


- (void)tabView:(NSTabView *)theTabView willSelectTabViewItem:
  (NSTabViewItem *)theTabViewItem {    
  // Delegate method of NSTabView to provide the tab view item that is about to
  // be selected so the window controller can enable or disable the navigation 
  // buttons depending on whether the first, last or another tab view item is
  // being selected.
  ////NSLog(@"theTabView == pwcTabView: %d", theTabView == pwcTabView );
  ////NSLog(@"in willSelectTabViewItem super");
  if (theTabView == pwcTabView) {
    [pwcBackButton setEnabled:([theTabView indexOfTabViewItem:theTabViewItem] > 0)];
    [pwcNextButton setEnabled:([theTabView indexOfTabViewItem:theTabViewItem] + 1 
                                      < [theTabView numberOfTabViewItems])];
    NSString *str = [NSString stringWithFormat:@"Step %d of %d.",
      1 + [theTabView indexOfTabViewItem:theTabViewItem],
      [theTabView numberOfTabViewItems]];
    [pwcStepTextField setStringValue:(str)];
  }
}

- (void)enableNextButtonWhenAppropriate:(NSTabViewItem *)item {
  
}

@end
