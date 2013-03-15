//
//  MembershipManager.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/5/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Person.h"
#import "Membership.h"

@interface MembershipManager : BasicWindowController {
  
  IBOutlet NSTableView *membersTableView;
  IBOutlet NSArrayController *membersArrayController;
  NSMutableArray *membersArray;
  Person *currentPerson;
  Membership *currentMembership;
  IBOutlet NSSearchField *membershipSearchField;
  int previousLengthOfMembershipSearchString;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSMutableArray *)membersArray;
- (void)setMembersArray:(NSArray *)arg;
- (Person *)currentPerson;
- (void)setCurrentPerson:(Person *)arg;
- (Membership *)currentMembership;
- (void)setCurrentMembership:(Membership *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************



  //******************************************************************************
  // handlers
  //******************************************************************************
- (void)handleMembershipsChange:(NSNotification *)note;
- (void)handleMembershipSearchFieldChange:(NSNotification *)note;


  //******************************************************************************
  // misc
  //******************************************************************************
- (NSArray *)filteredMembers;

@end