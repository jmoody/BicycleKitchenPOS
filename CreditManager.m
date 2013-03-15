//
//  CreditManager.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/4/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CreditManager.h"
#import "ShopCredit.h"
#import "Credits.h"
#import "People.h"

@implementation CreditManager

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"CreditManager"];
    previousLengthOfCreditsSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [creditsArray release];
  [currentPerson release];
  [peopleController release];
  [currentCredit release];
  [super dealloc];
}

//******************************************************************************
// windowing
//******************************************************************************

- (void)windowDidLoad {
  [super windowDidLoad];
  [self setupTables];
  [self setupTextFields];
}

//******************************************************************************

- (void)setupForModal {
  [super setupForModal];
}

//******************************************************************************

- (void)setupForNonModal {
  [super setupForNonModal];
  [self setupTables];
  [self setupTextFields];
}

//******************************************************************************

- (void)runModalWithParent:(NSWindow *) parent {
  [super runModalWithParent:parent];
}


//******************************************************************************
// setup
//******************************************************************************

- (void)setupButtons {
  [saveEditButton setEnabled:NO];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
  [datePicker setEnabled:NO];
  
}

//******************************************************************************

- (void)setupTextFields {
  [self clearTextField:cookTextField];
  [self clearTextField:creditAmountTextField];
  [self clearTextField:subjectTextField];
  [self clearTextView:reasonTextView];
  [creditsSearchField setStringValue:@""];
}

//******************************************************************************

- (void)setupTables {
  [self setCreditsArray:[[Credits sharedInstance] arrayForDictionary]];
  [creditsTableView setTarget:self];
  [creditsTableView setDoubleAction:@selector(handleCreditClicked:)];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)datePickerClicked:(id)sender {
  //NSLog(@"datePicker clicked");
  [self enableSaveButtonAppropriately];
}

//******************************************************************************

- (IBAction)saveEditButtonClicked:(id)sender {
  //NSLog(@"saveEditButton clicked");
  [currentCredit setCommentAuthorName:[self latexSafeStringFromTextField:cookTextField]];
  [currentCredit setCreditAmount:[creditAmountTextField doubleValue]];
  [currentCredit setCommentSubject:[self lowercaseAndLatexSafeStringFromTextField:subjectTextField]];
  [currentCredit setCommentText:[self lowercaseAndLatexSafeStringFromTextView:reasonTextView]];
  [currentCredit setDate:[self calendarDateFromDatePicker:datePicker]];
  
}

//******************************************************************************

- (IBAction)deleteCreditButtonClicked:(id)sender {
  //NSLog(@"deleteCreditButton clicked");
  NSArray *selectedObjects = [creditsArrayController selectedObjects];
  if ([selectedObjects count] > 0) {
    ShopCredit *tmp = (ShopCredit *)[selectedObjects objectAtIndex:0];
    if (tmp != nil) {
      Person *p = [[People sharedInstance] objectForUid:[tmp ownerUid]];
      if (p == nil) {
        NSLog(@"Null person when deleting credit");
      }
      NSPredicate *pred = [NSPredicate predicateWithFormat:@"!(SELF like %@)", [tmp uid]];
      [[p creditUids] filterUsingPredicate:pred];
      [[People sharedInstance] saveToDisk];
      [[Credits sharedInstance] removeObjectForUid:[tmp uid]];
      [self setCurrentCredit:nil];
      [self setCurrentPerson:nil];
      [self setupTextFields];
    }
  }
}

//******************************************************************************

- (IBAction)closeButtonClicked:(id)sender {
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

//******************************************************************************
// misc
//******************************************************************************

- (void)enableSaveButtonAppropriately {
  NSString *orgCook = [currentCredit commentAuthorName];
  NSString *newCook = [cookTextField stringValue];
  double orgAmount = [currentCredit creditAmount];
  double newAmount = [creditAmountTextField doubleValue];
  NSString *orgSubject = [currentCredit commentSubject];
  NSString *newSubject = [subjectTextField stringValue];
  NSString *orgReason = [currentCredit commentText];
  NSString *newReason = [reasonTextView string];
  NSString *orgDate = [[currentCredit date] descriptionWithCalendarFormat:@"%m/%d/%Y"];
  NSString *newDate = [[self calendarDateFromDatePicker:datePicker] descriptionWithCalendarFormat:@"%m/%d/%Y"];
  
  if ([self string:orgCook equalsString:newCook] &&
      orgAmount == newAmount &&
      [self string:orgSubject equalsString:newSubject] &&
      [self string:orgReason equalsString:newReason] &&
      [self string:orgDate equalsString:newDate]) {
    [saveEditButton setEnabled:NO];
  } else {
    [saveEditButton setEnabled:YES];
  }
}

//******************************************************************************

- (void)handleCreditClicked:(id)sender {
  NSArray *selectedObjects = [creditsArrayController selectedObjects];
  if ([selectedObjects count] > 0) {
    ShopCredit *tmp = (ShopCredit *)[selectedObjects objectAtIndex:0];
    if (tmp != nil) {
      [self setCurrentCredit:tmp];
      Person *p = [[People sharedInstance] objectForUid:[currentCredit ownerUid]];
      [self setCurrentPerson:p];
      [cookTextField setStringValue:[currentCredit commentAuthorName]];
      [creditAmountTextField setDoubleValue:[currentCredit creditAmount]];
      [subjectTextField setStringValue:[currentCredit commentSubject]];
      [reasonTextView setString:[currentCredit commentText]];
      [datePicker setDateValue:[currentCredit date]];
    }
  }
}

- (void)handleCreditsTextViewSelectionChange:(NSNotification *)note {
  if ([note object] == creditsTableView) {
    [self handleCreditClicked:[note object]];
  }
}

//******************************************************************************
// handlers
//******************************************************************************

- (void) handleCreditsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == creditsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *personString, *dateString, *usedString, *cookString, *subjectString,
      *bodyString;
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setCreditsArray:[[Credits sharedInstance] arrayForDictionary]];
      previousLengthOfCreditsSearchString = 0;
      [creditsTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfCreditsSearchString > [searchString length]) {
      [self setCreditsArray:[[Credits sharedInstance] arrayForDictionary]];
    }
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [creditsArray objectEnumerator];
    while ( object = [e nextObject] ) {
      personString = [[object personName] lowercaseString];
      dateString = [[[object date] descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      usedString = [[object hasBeenUsedYesOrNo] lowercaseString];
      cookString = [[object commentAuthorName] lowercaseString];
      subjectString = [[object commentSubject] lowercaseString];
      bodyString = [[object commentText] lowercaseString];
      
      NSRange personRange = [personString rangeOfString:searchString options:NSLiteralSearch];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      NSRange usedRange = [usedString rangeOfString:searchString options:NSLiteralSearch];
      NSRange cookRange = [cookString rangeOfString:searchString options:NSLiteralSearch];
      NSRange subjectRange = [subjectString rangeOfString:searchString options:NSLiteralSearch];
      NSRange bodyRange = [bodyString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((personRange.length) > 0) || ((dateRange.length) > 0) || 
          ((usedRange.length) > 0) || ((cookRange.length) > 0) ||
          ((subjectRange.length) > 0) || ((bodyRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setCreditsArray:filteredObjects];
    [creditsTableView reloadData];
    previousLengthOfCreditsSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow])  {
    [self enableSaveButtonAppropriately];
  }
}

//******************************************************************************

- (void)handleCreditsChange:(NSNotification *)note {
  NSArray *tmp = [[Credits sharedInstance] arrayForDictionary];
  [self setCreditsArray:tmp];
  [creditsTableView reloadData];
}


//******************************************************************************
// accessors and setters
//******************************************************************************

- (NSMutableArray *)creditsArray {
  return creditsArray;
}
- (void) setCreditsArray:(NSArray *)arg {
  if (arg != creditsArray) {
    [creditsArray release];
    creditsArray = [arg mutableCopy];
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
- (PeopleController *)peopleController {
  return peopleController;
}
- (void) setPeopleController:(PeopleController *)arg {
  [arg retain];
  [peopleController release];
  peopleController = arg;
}
- (ShopCredit *)currentCredit {
  return currentCredit;
}
- (void) setCurrentCredit:(ShopCredit *)arg {
  [arg retain];
  [currentCredit release];
  currentCredit = arg;
}

//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(handleCreditsSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:creditsSearchField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:cookTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:creditAmountTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:subjectTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:reasonTextView];
  
  
  [nc addObserver:self
         selector:@selector(handleCreditsChange:)
             name:[[Credits sharedInstance] notificationChangeString]
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleCreditsTextViewSelectionChange:)
             name:NSTextViewDidChangeSelectionNotification
           object:creditsTableView];
  
  
}
@end