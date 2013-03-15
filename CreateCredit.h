//
//  CreateCredit.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "ShopCredit.h"
#import "Person.h"

@interface CreateCredit : BasicWindowController {
  
  ShopCredit *credit;
  Person *person;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSTextField *amountTextField;
  IBOutlet NSTextField *reasonTextField;
  IBOutlet NSTextView *notesTextView;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSButton *cancelButton;
  IBOutlet NSButton *createCreditButton;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (ShopCredit *)credit;
- (void)setCredit:(ShopCredit *)arg;
- (Person *)person;
- (void)setPerson:(Person *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)datePickerClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)createCreditButtonClicked:(id)sender;


  //******************************************************************************
  // handlers
  //******************************************************************************



  //******************************************************************************
  // misc
  //******************************************************************************
- (void)enableSaveButtonAppropriately;

@end