//
//  DeletePersonController.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/25/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "DeletePersonController.h"
#import "BasicWindowController.h"
#import "Person.h"
#import "People.h"
#import "Project.h"
#import "Projects.h"
#import "Invoice.h"
#import "Invoices.h"
//#import "Comment.h"
//#import "Comments.h"
#import "CustomerContact.h"
#import "Contacts.h"
#import "ShopCredit.h"
#import "Credits.h"

#import "CreateCustomerController.h"
#import "PeopleController.h"



@implementation DeletePersonController

- (id) init {
  self = [super init];
  if (self != nil) {
    self = [super initWithWindowNibName:@"DeletePersonPanel"];
  }
  return self;
}


- (void) dealloc {
  [cvp release];
  [personToTransferTo release];
  [createCustomerController release];
  [peopleController release];
  [super dealloc];
}

- (void)windowDidLoad {
  [super windowDidLoad];
}

- (void)setupForModal {
  ////NSLog(@"in setup for modal");
  [super setupForModal];
  
  [continueButton setHidden:YES];
  [continueButton setEnabled:NO];
  
  
  NSMutableArray *inv = [cvp invoiceUids];
  NSMutableArray *prUids = [cvp projectUids];
 // //NSLog(@"inv: %@\nprUids: %@", inv, prUids);
  
  
    
  NSString *title;
  
  if (([inv count] == 0) && ([prUids count] == 0)) {
    title = [NSString stringWithFormat:@"%@ can be safely deleted.", [cvp personName]];
    [deleteButton setHidden:NO];
    [deleteButton setEnabled:YES];
    [transferButton setHidden:YES];
    [transferButton setEnabled:NO];
  } else {
    [deleteButton setHidden:YES];
    [deleteButton setEnabled:NO];
    [transferButton setHidden:NO];
    [transferButton setEnabled:YES];
  }
  
  ////NSLog(@"buttons are set");
  
  if (([inv count] > 0) && ([prUids count] > 0)) {
    title = [NSString stringWithFormat:@"%@ has invoices and projects.", [cvp personName]];
  } else if (([inv count] > 0) && ([prUids count] == 0)) {
    title = [NSString stringWithFormat:@"%@ has invoices.", [cvp personName]];
  } else if (([inv count] == 0) && ([prUids count] > 0)) {
    title = [NSString stringWithFormat:@"%@ has projects.", [cvp personName]];
  }
  
 
  [titleTextField setStringValue:title];
  

}




- (IBAction)deleteButtonClicked:(id)sender {
  NSMutableArray *contactUids = [cvp contactUids];
  unsigned int i, count = [contactUids count];
  for (i = 0; i < count; i++) {
    NSString *owu = (NSString *)[contactUids objectAtIndex:i];
    [[Contacts sharedInstance] removeObjectForUid:owu];
  }
  
//  NSMutableArray *commentUids = [cvp commentUids];
//  i = 0, count = [commentUids count];
//  for (i = 0; i < count; i++) {
//  NSString *owu = (NSString *)[commentUids objectAtIndex:i];
//    [[Comments sharedInstance] removeObjectForUid: uid];
//  }
  
  NSMutableArray *creditUids = [cvp creditUids];
  i = 0, count = [creditUids count];
  for (i = 0; i < count; i++) {
    NSString *owu = (NSString *)[creditUids objectAtIndex:i];
    [[Credits sharedInstance] removeObjectForUid:owu];
  }
  
  // remove the person, sends a notification to the observers to update tables
  [[People sharedInstance] removeObjectForUid:[cvp uid]];
  [super stopModalAndCloseWindow];
}


- (IBAction)transferButtonClicked:(id)sender {
  if (peopleController == nil) {
    PeopleController *tmp = [[PeopleController alloc] init];
    [self setPeopleController:tmp];
    [tmp release];
  }
  [peopleController setupForModal];
  [peopleController runModalWithParent:[self window]];
  
 // //NSLog(@"Do we wait for modal to return?");
  Person *selectedPerson = [peopleController currentlyViewedPerson];
  if (selectedPerson == nil) {
    [self setPersonToTransferTo:selectedPerson];
    NSString *title = [NSString stringWithFormat:@"Transfering %@ to %@", [cvp personName],
      [personToTransferTo personName]];
    
    [continueButton setHidden:NO];
    [continueButton setEnabled:YES];
    [titleTextField setStringValue:title];
  }    
}


- (IBAction)continueButtonClicked:(id)sender {
 // //NSLog(@"Continue button clicked");
  
}


- (IBAction)cancelButtonClicked:(id)sender {
  [super stopModalAndCloseWindow];
}

- (CreateCustomerController *)createCustomerController {
  return createCustomerController;
}
- (void)setCreateCustomerController:(CreateCustomerController *)controller {
  [controller retain];
  [createCustomerController release];
  createCustomerController = controller;
}

- (PeopleController *)peopleController {
  return peopleController;
}

- (void)setPeopleController:(PeopleController *)controller {
  [controller retain];
  [peopleController release];
  peopleController = controller;
}

- (Person *)cvp {
  return cvp;
}

- (void)setCvp:(Person *)p {
  [p retain];
  [cvp release];
  cvp = p;
}

- (Person *)personToTransferTo {
  return personToTransferTo;
}

- (void)setPersonToTransferTo:(Person *)p {
  [p retain];
  [personToTransferTo release];
  personToTransferTo = p;
}

@end
