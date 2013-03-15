//
//  MembershipManager.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/5/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "MembershipManager.h"
#import "Memberships.h"

@implementation MembershipManager

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"MembershipManager"];
    previousLengthOfMembershipSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [membersArray release];
  [currentPerson release];
  [currentMembership release];
  [super dealloc];
}

//******************************************************************************
// windowing
//******************************************************************************

- (void)windowDidLoad {
  [super windowDidLoad];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
}

//******************************************************************************

- (void)setupForNonModal {
  [super setupForNonModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
}

//******************************************************************************

- (void)runModalWithParent:(NSWindow *) parent {
  [super runModalWithParent:parent];
}


//******************************************************************************
// setup
//******************************************************************************

- (void)setupButtons {
}

//******************************************************************************

- (void)setupTextFields {
  [membershipSearchField setStringValue:@""];
}

//******************************************************************************

- (void)setupTables {
  [self setMembersArray:[self filteredMembers]];
}


//******************************************************************************
// button actions
//******************************************************************************



//******************************************************************************
// misc
//******************************************************************************

- (NSArray *)filteredMembers {
  NSMutableArray *all = [[Memberships sharedInstance] arrayForDictionary];
  NSMutableArray *filtered = [[NSMutableArray alloc] init];
  unsigned int i, count = [all count];
  for (i = 0; i < count; i++) {
    Membership *obj = (Membership *)[all objectAtIndex:i];
    if (![[obj membershipType] isEqualToString:@"no"] &&
        ![[obj membershipType] isEqualToString:@"cook"]) {
      [filtered addObject:obj];
    }
  }
  NSArray *returnVal = [NSArray arrayWithArray:filtered];
  [filtered release];
  return returnVal;
}

//******************************************************************************
// handlers
//******************************************************************************

- (void) handleMembershipSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == membershipSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *personString, *startString, *endString, *typeString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setMembersArray:[self filteredMembers]];
      previousLengthOfMembershipSearchString = 0;
      [membersTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfMembershipSearchString > [searchString length]) {
      [self setMembersArray:[self filteredMembers]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [membersArray objectEnumerator];
    while (object = [e nextObject] ) {
      personString = [[object personName] lowercaseString];
      NSRange personRange = [personString rangeOfString:searchString options:NSLiteralSearch];
      startString = [[[object startDate]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange startRange = [startString rangeOfString:searchString options:NSLiteralSearch];
      endString = [[[object endDate]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange endRange = [endString rangeOfString:searchString options:NSLiteralSearch];
      typeString = [[object membershipType] lowercaseString];
      NSRange typeRange = [typeString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((personRange.length) > 0) || ((startRange.length) > 0) || ((endRange.length) > 0) || ((typeRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setMembersArray:filteredObjects];
    [membersTableView reloadData];
    previousLengthOfMembershipSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************


- (void)handleMembershipsChange:(NSNotification *)note {
  //NSLog(@"handle memberships change");
  [self setMembersArray:[self filteredMembers]];
  [membersTableView reloadData];
}

//******************************************************************************



//******************************************************************************
// accessors and setters
//******************************************************************************

- (NSMutableArray *)membersArray {
  return membersArray;
}
- (void) setMembersArray:(NSArray *)arg {
  if (arg != membersArray) {
    [membersArray release];
    membersArray = [arg mutableCopy];
  }
}
- (Person *)currentPerson {
  return currentPerson;
}
- (void) setCurrentPerson:(Person *)arg {
  [arg retain];
  [currentPerson release];
  currentPerson = arg;
}
- (Membership *)currentMembership {
  return currentMembership;
}
- (void) setCurrentMembership:(Membership *)arg {
  [arg retain];
  [currentMembership release];
  currentMembership = arg;
}



//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(handleMembershipSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:membershipSearchField];
  
  [nc addObserver:self
         selector:@selector(handleMembershipsChange:)
             name:[[Memberships sharedInstance] notificationChangeString]
           object:nil];
  
}
@end