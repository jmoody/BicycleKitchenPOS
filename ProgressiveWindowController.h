//
//  ProgressiveWindowController.h
//  ProgressiveWindowsApp
//
//  Created by moody on 10/7/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"

@interface ProgressiveWindowController : BasicWindowController {

  IBOutlet NSTextField *pwcTitleTextField;
  IBOutlet NSTabView *pwcTabView;
  IBOutlet NSTextField *pwcStepTextField;
  IBOutlet NSButton *pwcNextButton;
  IBOutlet NSButton *pwcBackButton;
  int pwcCurrentStep;
}

//******************************************************************************
// accessors
//******************************************************************************

- (int)pwcCurrentStep;

//******************************************************************************
// setters
//******************************************************************************

- (void)setPwcCurrentStep:(int)step;

//******************************************************************************
// actions
//******************************************************************************

- (IBAction) pwcNextButtonClicked:(id)sender;
- (IBAction) pwcBackButtonClicked:(id)sender;
- (NSTabView *) pwcTabView;

- (IBAction)showWindow:(id)sender;
- (void)enableNextButtonWhenAppropriate:(NSTabViewItem *)item;


@end
