//
//  ReturnManager.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ReturnManager.h"
#import "Returns.h"
#import "People.h"
#import "Credits.h"

@implementation ReturnManager

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"ReturnManager"];
    previousLengthOfReturnsSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [theReturn release];
  [person release];
  [credit release];
  [returnsArray release];
  [productsArray release];
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
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
  [cancelEditButton setEnabled:NO];
  [saveEditButton setEnabled:NO];
}

//******************************************************************************

- (void)setupTextFields {
  [returnsSearchField setStringValue:@""];
  [self clearTextField:personTextField];
  [self clearTextField:amountTextField];
  [self clearTextField:cookTextField];
  [self clearTextField:subjectTextField];
  [self clearTextView:reasonTextView];
}

//******************************************************************************

- (void)setupTables {
  [self setReturnsArray:[[Returns sharedInstance] arrayForDictionary]];
  [returnsTableView setTarget:self];
  [returnsTableView setDoubleAction:@selector(handleReturnsClicked:)];
  
  NSArray *tmp = [[NSArray alloc] init];
  [self setProductsArray:tmp];
  [tmp release];
}

//******************************************************************************

- (void)setupStateVariables {
  [self setPerson:nil];
  [self setCredit:nil];
  [self setTheReturn:nil];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)deleteButtonClicked:(id)sender {
  //NSLog(@"deleteButton clicked");
  
  NSArray *selected = [returnsArrayController selectedObjects];
  if ([selected count] > 0) {
    Return *tmp = (Return *)[selected objectAtIndex:0];
    if (tmp != nil) {
      ShopCredit *theCredit = [[Credits sharedInstance] objectForUid:[tmp creditUid]];
      if ([theCredit hasBeenUsed] == YES ||
          [theCredit creditAmount] != [tmp quantity]) {
        NSString *str = @"ShopCredit has been used, so the return can not be deleted.";
        NSRunAlertPanel(@"ShopCredit can't be deleted",str,@"Continue",nil,nil);
      } else {
        //NSLog(@"tmp: %@", tmp);
        //NSLog(@"[tmp uid]: %@", [tmp uid]);
        //NSLog(@"[tmp creditUid]: %@", [tmp creditUid]);
        //NSLog(@"[tmp ownerUid]: %@", [tmp ownerUid]);
        [[Returns sharedInstance] removeObjectForUid:[tmp uid]];
        [[Credits sharedInstance] removeObjectForUid:[tmp creditUid]];
        Person *p = [[People sharedInstance] objectForUid:[tmp ownerUid]];
        //NSLog(@"person: %@", p);
        NSMutableArray *oldCreditUids = [p creditUids];
        //NSLog(@"oldCreditUids: %@", [p creditUids]);
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"!(SELF like %@)",
          [tmp creditUid]];
        //NSLog(@"predicate: %@", predicate);
        NSArray *newCredits = [oldCreditUids filteredArrayUsingPredicate:predicate];
        //NSLog(@"newCredits: %@", newCredits);
        [p setCreditUids:newCredits];
        [[People sharedInstance] saveToDisk];
        
        unsigned int i, count = [[self returnedProducts] count];
        for (i = 0; i < count; i++) {
          Product *obj = (Product *)[[self returnedProducts] objectAtIndex:i];
          [obj setActive:YES];
        }
        
        NSArray *tmp = [[NSArray alloc] init];
        [self setProductsArray:tmp];
        [tmp release];
        [self setupButtons];
        [self clearTextField:personTextField];
        [self clearTextField:amountTextField];
        [self clearTextField:cookTextField];
        [self clearTextField:subjectTextField];
        [self clearTextView:reasonTextView];
        
        [self setTheReturn:nil];
        [self setPerson:nil];
        [self setCredit:nil];
      }
    }
  }  
}

//******************************************************************************

- (IBAction)datePickerClicked:(id)sender {
  //NSLog(@"datePicker clicked");
  [self enableSaveEditButtonAppropriately];
}

//******************************************************************************

- (IBAction)cancelEditButtonClicked:(id)sender {
  //NSLog(@"cancelEditButton clicked");
  [cookTextField setStringValue:[theReturn commentAuthorName]];
  [subjectTextField setStringValue:[theReturn commentSubject]];
  [reasonTextView setString:[theReturn commentText]];
  [datePicker setDateValue:[theReturn date]];
  [cancelEditButton setEnabled:NO];
  [saveEditButton setEnabled:NO];
}

//******************************************************************************

- (IBAction)saveEditButtonClicked:(id)sender {
  //NSLog(@"saveEditButton clicked");
  [theReturn setCommentAuthorName:[self latexSafeStringFromTextField:cookTextField]];
  [theReturn setCommentSubject:[self lowercaseAndLatexSafeStringFromTextField:subjectTextField]];
  [theReturn setCommentText:[self lowercaseAndLatexSafeStringFromTextView:reasonTextView]];
  [theReturn setDate:[self calendarDateFromDatePicker:datePicker]];
  [cancelEditButton setEnabled:NO];
  [saveEditButton setEnabled:NO];
}

//******************************************************************************
// misc
//******************************************************************************
- (NSArray *)returnedProducts {
  return [theReturn products];
}

//******************************************************************************

- (void)enableSaveEditButtonAppropriately {
  NSString *newCook = [cookTextField stringValue];
  NSString *orgCook = [theReturn commentAuthorName];
  NSString *newSubject = [subjectTextField stringValue];
  NSString *orgSubject = [theReturn commentSubject];
  NSString *newBody = [reasonTextView string];
  NSString *orgBody = [theReturn commentText];
  bool isDifferent;
  if ([self date:[theReturn date] equalsDate:[self calendarDateFromDatePicker:datePicker]]) {
    isDifferent = NO;
  } else {
    isDifferent = YES;
  }
  
  if (!isDifferent &&
      [newCook isEqualToString:orgCook] &&
      [newSubject isEqualToString:orgSubject] &&
      [newBody isEqualToString:orgBody]) {
    [cancelEditButton setEnabled:NO];
    [saveEditButton setEnabled:NO];
  } else {
    [cancelEditButton setEnabled:YES];
    [saveEditButton setEnabled:YES];
  }
}

//******************************************************************************
// handlers
//******************************************************************************

- (void) handleReturnsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == returnsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *personString, *dateString, *cookString, *bodyString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setReturnsArray:[[Returns sharedInstance] arrayForDictionary]];
      previousLengthOfReturnsSearchString = 0;
      [returnsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfReturnsSearchString > [searchString length]) {
      [self setReturnsArray:[[Returns sharedInstance] arrayForDictionary]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [returnsArray objectEnumerator];
    while (object = [e nextObject] ) {
      personString = [[object personName] lowercaseString];
      NSRange personRange = [personString rangeOfString:searchString options:NSLiteralSearch];
      dateString = [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      cookString = [[object commentAuthorName] lowercaseString];
      NSRange cookRange = [cookString rangeOfString:searchString options:NSLiteralSearch];
      bodyString = [[object commentText] lowercaseString];
      NSRange bodyRange = [bodyString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((personRange.length) > 0) || ((dateRange.length) > 0) || ((cookRange.length) > 0) || 
          ((bodyRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setReturnsArray:filteredObjects];
    [returnsTableView reloadData];
    previousLengthOfReturnsSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void)handleReturnsChange:(NSNotification *)note {
  NSArray *tmp = [[Returns sharedInstance] arrayForDictionary];
  [self setReturnsArray:tmp];
  [returnsTableView reloadData];
}

//******************************************************************************

- (void)handleReturnsClicked:(id)sender {
  NSArray *selected = [returnsArrayController selectedObjects];
  if ([selected count] > 0) {
    Return *tmp = [selected objectAtIndex:0];
    if (tmp != nil) {
      [self setTheReturn:tmp];
      [self setPerson:[[People sharedInstance] objectForUid:[tmp ownerUid]]];
      [self setCredit:[[Credits sharedInstance] objectForUid:[tmp creditUid]]];
      [self setProductsArray:[theReturn products]];
      [productsTableView reloadData];
      [personTextField setStringValue:[theReturn personName]];
      [cookTextField setStringValue:[theReturn commentAuthorName]];
      [amountTextField setIntValue:[theReturn quantity]];
      [subjectTextField setStringValue:[theReturn commentSubject]];
      [reasonTextView setString:[theReturn commentText]];
      [datePicker setDateValue:[theReturn date]];
      [cancelEditButton setEnabled:NO];
      [saveEditButton setEnabled:NO];
    }
  }
}

//******************************************************************************

- (void)handleProductsClicked:(id)sender {
  // nothing
}

- (void)handleReturnsArraySelectionChange:(NSNotification *)note {
  if ([note object] == returnsTableView) {
    [self handleReturnsClicked:self];
  }
}

//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    [self enableSaveEditButtonAppropriately];
  }
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (Return *)theReturn {
  return theReturn;
}
- (void) setTheReturn:(Return *)arg {
  [arg retain];
  [theReturn release];
  theReturn = arg;
}
- (Person *)person {
  return person;
}
- (void) setPerson:(Person *)arg {
  [arg retain];
  [person release];
  person = arg;
}
- (ShopCredit *)credit {
  return credit;
}
- (void) setCredit:(ShopCredit *)arg {
  [arg retain];
  [credit release];
  credit = arg;
}
- (NSMutableArray *)returnsArray {
  return returnsArray;
}
- (void) setReturnsArray:(NSArray *)arg {
  if (arg != returnsArray) {
    [returnsArray release];
    returnsArray = [arg mutableCopy];
  }
}
- (NSMutableArray *)productsArray {
  return productsArray;
}
- (void) setProductsArray:(NSArray *)arg {
  if (arg != productsArray) {
    [productsArray release];
    productsArray = [arg mutableCopy];
  }
}


//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(handleReturnsSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:returnsSearchField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:cookTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:subjectTextField];
  
  [nc addObserver:self
         selector:@selector(textDidChange:)
             name:NSControlTextDidChangeNotification
           object:reasonTextView];
    
  [nc addObserver:self
         selector:@selector(handleReturnsChange:)
             name:[[Returns sharedInstance] notificationChangeString]
           object:nil];
  

  [nc addObserver:self
         selector:@selector(handleReturnsArraySelectionChange:)
             name:NSTableViewSelectionDidChangeNotification
           object:returnsTableView];
  
  
}
@end