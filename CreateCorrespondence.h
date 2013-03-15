//
//  CreateCorrespondence.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/21/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "CustomerContact.h"
#import "Person.h"

@interface CreateCorrespondence : BasicWindowController {
  
  CustomerContact *contact;
  Person *person;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSTextField *subjectTextField;
  IBOutlet NSTextView *noteTextView;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSMatrix *messageTypeMatrix;
  IBOutlet NSButton *saveButton;
  IBOutlet NSButton *cancelButton;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (CustomerContact *)contact;
- (void)setContact:(CustomerContact *)arg;
- (Person *)person;
- (void)setPerson:(Person *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)datePickerClicked:(id)sender;
- (IBAction)messageTypeMatrixClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;


  //******************************************************************************
  // handlers
  //******************************************************************************



  //******************************************************************************
  // misc
  //******************************************************************************
- (void)enableSaveButtonAppropriately;

@end