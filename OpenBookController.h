//
//  OpenBookController.h
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Book.h"

@interface OpenBookController : BasicWindowController {
  
  IBOutlet NSTextField *openingTextField;
  IBOutlet NSStepper *openingStepper;
  IBOutlet NSButton *cancelButton;
  IBOutlet NSButton *doneButton;
  IBOutlet NSButton *haveCountedChangeButton;
  Book *currentBook;
}


- (Book *)currentBook;
- (void)setCurrentBook:(Book *)arg;

- (IBAction)openingStepperClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)haveCountedChangeButtonClicked:(id)sender;


@end
