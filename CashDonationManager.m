// 
// CashDonationManager.m
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import "CashDonationManager.h"
#import "Donation.h"
#import "Donations.h"

@implementation CashDonationManager

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"CashDonationController"];
    previousLengthOfDonationsSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [donationsArray release];
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
  // nothing to be done
}

//******************************************************************************

- (void)setupTextFields {
  [self clearTextField:donationsSearchField];
}

//******************************************************************************

- (void)setupTables {
  [self setDonationsArray:[[Donations sharedInstance] arrayForDictionary]];
  [donationsTableView setTarget:self];
  [donationsTableView setDoubleAction:@selector(handleDonationsClicked:)];
}

//******************************************************************************

- (void)setupStateVariables {
  // nothing to be done
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)closeButtonClicked:(id)sender {
  //NSLog(@"closeButton clicked");
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}


//******************************************************************************
// misc
//******************************************************************************



//******************************************************************************
// handlers
//******************************************************************************


//******************************************************************************

- (void) handleDonationsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == donationsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *dateString, *companyString, *nameString, *addressString, *cityString, *theStateString, *zipString, *cookString, *emailString, *phoneString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setDonationsArray:[[Donations sharedInstance] arrayForDictionary]];
      previousLengthOfDonationsSearchString = 0;
      [donationsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfDonationsSearchString > [searchString length]) {
      [self setDonationsArray:[[Donations sharedInstance] arrayForDictionary]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [donationsArray objectEnumerator];
    while (object = [e nextObject] ) {
      dateString = [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      companyString = [[object companyName] lowercaseString];
      NSRange companyRange = [companyString rangeOfString:searchString options:NSLiteralSearch];
      nameString = [[object personName] lowercaseString];
      NSRange nameRange = [nameString rangeOfString:searchString options:NSLiteralSearch];
      addressString = [[object address] lowercaseString];
      NSRange addressRange = [addressString rangeOfString:searchString options:NSLiteralSearch];
      cityString = [[object city] lowercaseString];
      NSRange cityRange = [cityString rangeOfString:searchString options:NSLiteralSearch];
      theStateString = [[object addressState] lowercaseString];
      NSRange theStateRange = [theStateString rangeOfString:searchString options:NSLiteralSearch];
      zipString = [[object zip] lowercaseString];
      NSRange zipRange = [zipString rangeOfString:searchString options:NSLiteralSearch];
      cookString = [[object cookNameOrInitials] lowercaseString];
      NSRange cookRange = [cookString rangeOfString:searchString options:NSLiteralSearch];
      emailString = [[object personEmail] lowercaseString];
      NSRange emailRange = [emailString rangeOfString:searchString options:NSLiteralSearch];
      phoneString = [[object personPhone] lowercaseString];
      NSRange phoneRange = [phoneString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((dateRange.length) > 0) || ((companyRange.length) > 0) || ((nameRange.length) > 0) || ((addressRange.length) > 0) || ((cityRange.length) > 0) || ((theStateRange.length) > 0) || ((zipRange.length) > 0) || ((cookRange.length) > 0) || ((emailRange.length) > 0) || ((phoneRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setDonationsArray:filteredObjects];
    [donationsTableView reloadData];
    previousLengthOfDonationsSearchString = [searchString length];
    [filteredObjects release];
  }
}

- (void)handleDonationsChange:(NSNotification *)note {
  NSArray *tmp = [[Donations sharedInstance] arrayForDictionary];
  [self setDonationsArray:tmp];
  [donationsTableView reloadData];
}

//******************************************************************************

- (void)handleDonationsClicked:(id)sender {
  NSArray *selected = [donationsArrayController selectedObjects];
  if ([selected count] > 0) {
    Donation *tmp = (Donation *)[selected objectAtIndex:0];
    if (tmp != nil) {
      if (donationViewer == nil) {
        ViewCashDonation *vikd = [[ViewCashDonation alloc] init];
        [self setDonationViewer:vikd];
        [vikd release];
      }
      [donationViewer setDonation:tmp];
      [donationViewer setupForModal];
      [donationViewer runModalWithParent:[self window]];
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
- (ViewCashDonation *)donationViewer {
  return donationViewer;
}
- (void) setDonationViewer:(ViewCashDonation *)arg {
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
    selector:@selector(handleDonationsChange:)
    name:[[Donations sharedInstance] notificationChangeString]
    object:nil];

}
@end