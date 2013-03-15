//
//  InKindDonationManager.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "InKindDonationManager.h"
#import "InKindDonations.h"
#import "People.h"

@implementation InKindDonationManager

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"InKindDonationManager"];
    previousLengthOfDonationsSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [donationsArray release];
  [person release];
  [donation release];
  [donationViewer release];
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
  [self setupStateVariables];
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
  [self setupStateVariables];
}

//******************************************************************************

- (void)setupForNonModal {
  [super setupForNonModal];
  [self setupButtons];
  [self setupTextFields];
  [self setupTables];
  [self setupStateVariables];
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
  [self clearTextField:donationsSearchField];
}

//******************************************************************************

- (void)setupTables {
  [self setDonationsArray:[[InKindDonations sharedInstance] arrayForDictionary]];
	NSLog(@"donations: %@", donationsArray);
  [donationsTableView setTarget:self];
  [donationsTableView setDoubleAction:@selector(handleDonationsClicked:)];
}

//******************************************************************************

- (void)setupStateVariables {
  [self setPerson:nil];
  [self setDonation:nil];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)deleteButtonClicked:(id)sender {
  //NSLog(@"deleteButton clicked");
  NSArray *selected = [donationsArrayController selectedObjects];
  if ([selected count] > 0) {
    InKindDonation *tmp = (InKindDonation *)[selected objectAtIndex:0];
    if (tmp != nil) {
      Person *p = [[People sharedInstance] objectForUid:[tmp donorUid]];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF like %@)",
        [tmp uid]];
      NSArray *newUids = [[p inKindDonationUids] filteredArrayUsingPredicate:predicate];
      [p setInKindDonationUids:newUids];
      [[People sharedInstance] saveToDisk];
      
      NSFileManager *nsfm = [NSFileManager defaultManager];
      if ([nsfm fileExistsAtPath:[tmp pathToPdfArchive]])  {
        [nsfm removeFileAtPath:[tmp pathToPdfArchive] handler:self];
      }

      [[InKindDonations sharedInstance] removeObjectForUid:[tmp uid]];
    }
  }
}

//******************************************************************************

- (IBAction)newButtonClicked:(id)sender {
  //NSLog(@"newButton clicked");
  
}

//******************************************************************************
// misc
//******************************************************************************



//******************************************************************************
// handlers
//******************************************************************************

- (void) handleDonationsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == donationsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *donorString, *dateString, *companyString, *cityString, *stateString, *zipString, *cookString, *thankYouString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setDonationsArray:[[InKindDonations sharedInstance] arrayForDictionary]];
      previousLengthOfDonationsSearchString = 0;
      [donationsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfDonationsSearchString > [searchString length]) {
      [self setDonationsArray:[[InKindDonations sharedInstance] arrayForDictionary]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [donationsArray objectEnumerator];
    while (object = [e nextObject] ) {
      donorString = [[object personName] lowercaseString];
      NSRange donorRange = [donorString rangeOfString:searchString options:NSLiteralSearch];
      dateString = [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      companyString = [[object companyName] lowercaseString];
      NSRange companyRange = [companyString rangeOfString:searchString options:NSLiteralSearch];
      cityString = [[object city] lowercaseString];
      NSRange cityRange = [cityString rangeOfString:searchString options:NSLiteralSearch];
      stateString = [[object addressState] lowercaseString];
      NSRange stateRange = [stateString rangeOfString:searchString options:NSLiteralSearch];
      zipString = [[object zip] lowercaseString];
      NSRange zipRange = [zipString rangeOfString:searchString options:NSLiteralSearch];
      cookString = [[object cookNameOrInitials] lowercaseString];
      NSRange cookRange = [cookString rangeOfString:searchString options:NSLiteralSearch];
      thankYouString = [[object sentThankYouYesOrNo] lowercaseString];
      NSRange thankYouRange = [thankYouString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((donorRange.length) > 0) || ((dateRange.length) > 0) || ((companyRange.length) > 0) || ((cityRange.length) > 0) || ((stateRange.length) > 0) || ((zipRange.length) > 0) || ((cookRange.length) > 0) || ((thankYouRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setDonationsArray:filteredObjects];
    [donationsTableView reloadData];
    previousLengthOfDonationsSearchString = [searchString length];
  }
}

//******************************************************************************

- (void)handleInKindDonationsChange:(NSNotification *)note {
  NSArray *tmp = [[InKindDonations sharedInstance] arrayForDictionary];
  [self setDonationsArray:tmp];
  [donationsTableView reloadData];
}

//******************************************************************************

- (void)handleDonationsClicked:(id)sender {
  NSArray *selected = [donationsArrayController selectedObjects];
  if ([selected count] > 0) {
    InKindDonation *tmp = (InKindDonation *)[selected objectAtIndex:0];
    if (tmp != nil) {
      if (donationViewer == nil) {
        AcceptInKindDonation *tmp = [[AcceptInKindDonation alloc] init];
        [self setDonationViewer:tmp];
      }
      Person *p = [[People sharedInstance] objectForUid:[tmp donorUid]];
      [donationViewer setPerson:p];
      [donationViewer setInKindDonation:tmp];
      [donationViewer setupForModal];
      [donationViewer runModalWithParent:[self window]];
			[[self window] makeKeyWindow];
			NSLog(@"tmp: %@", tmp);
    }
  }
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (NSMutableArray *)donationsArray {
  return donationsArray;
}
- (void) setDonationsArray:(NSArray *)arg {
  if (arg != donationsArray) {
    [donationsArray release];
    donationsArray = [arg mutableCopy];
  }
}
- (Person *)person {
  return person;
}
- (void) setPerson:(Person *)arg {
  [arg retain];
  [person release];
  person = arg;
}
- (InKindDonation *)donation {
  return donation;
}
- (void)setDonation:(InKindDonation *)arg {
  [arg retain];
  [donation release];
  donation = arg;
}
- (AcceptInKindDonation *)donationViewer {
  return donationViewer;
}
- (void)setDonationViewer:(AcceptInKindDonation *)arg {
  [arg retain];
  [donationViewer release];
  donationViewer = arg;
}


//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(handleDonationsSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:donationsSearchField];
  
  [nc addObserver:self
         selector:@selector(handleInKindDonationsChange:)
             name:[[InKindDonations sharedInstance] notificationChangeString]
           object:nil];
  
}

//******************************************************************************
// file manager error handler
//******************************************************************************


- (bool)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo {
  int result;
  result = NSRunAlertPanel(@"Fuck all.  I hate ObjC", @"File  operation error: %@ with file: %@", 
                           @"Proceed", @"Stop",  NULL, 
                           [errorInfo objectForKey:@"Error"], 
                           [errorInfo objectForKey:@"Path"]);
  if (result == NSAlertDefaultReturn) {
    return YES;
  } else {
    return NO;
  }
}

@end