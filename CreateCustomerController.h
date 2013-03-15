//
//  CreateCustomerController.h
//  BicycleKitchenPOS
//
//  Created by moody on 7/21/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Person.h"
#import "BasicWindowController.h"

@interface CreateCustomerController : BasicWindowController {
  
  // pointer to the mainWindow
  NSWindow *mainWindow;
  // pointer to the array controller in the main window
  NSArrayController *peopleArrayController;
  
 // IBOutlet NSPanel *createCustomerPanel;
  IBOutlet NSTextField *createCustomerNameTextField;
  IBOutlet NSTextField *createCustomerPhoneTextField;
  IBOutlet NSTextField *createCustomerEmailTextField;
  IBOutlet NSButton *createCustomerCancelButton;
  IBOutlet NSButton *createCustomerAddButton;
  IBOutlet NSTextField *createCustomerFailedTextField;
  bool bypassDuplicatePerson;
}

- (bool)bypassDuplicatePerson;

- (void)setPeopleArrayController:(NSArrayController *)ac;
- (void)setMainWindow:(NSWindow *)mainAppWindow;
- (void)setBypassDuplicatePerson:(bool)bypass;

- (IBAction)createCustomerAddButtonClicked:(id)sender;
- (IBAction)createCustomerCancelButtonClicked:(id)sender;

- (void)runCreateCustomerModal;
- (void)runBadPersonWithPerson:(Person *)p andBadPhone:(bool)badPhone andBadEmail:(bool)badEmail;
- (void)runBadPhoneWithPerson:(Person *)p;
- (void)runBadEmailWithPerson:(Person *)p;
- (void)runAddPersonWithPerson:(Person *)p;

@end
