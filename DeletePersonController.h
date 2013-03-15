//
//  DeletePersonController.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/25/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
//#import "PeopleController.h"
#import "CreateCustomerController.h"
#import "Person.h"
@class PeopleController;

@interface DeletePersonController : BasicWindowController {

  CreateCustomerController *createCustomerController;
  PeopleController *peopleController;
  Person *cvp;
  Person *personToTransferTo;
  
  IBOutlet NSTextField *titleTextField;
  IBOutlet NSButton *deleteButton;
  IBOutlet NSButton *transferButton;
  IBOutlet NSButton *continueButton;
  IBOutlet NSButton *cancelButton;
}


- (CreateCustomerController *)createCustomerController;
- (void)setCreateCustomerController:(CreateCustomerController *)controller;

- (PeopleController *)peopleController;
- (void)setPeopleController:(PeopleController *)controller;

- (Person *)cvp;
- (void)setCvp:(Person *)p;

- (Person *)personToTransferTo;
- (void)setPersonToTransferTo:(Person *)p;


- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)transferButtonClicked:(id)sender;
- (IBAction)continueButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;

@end
