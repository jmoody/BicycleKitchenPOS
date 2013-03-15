//
//  ReturnHandler.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/6/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "ReturnHandler.h"
#import "Invoices.h"
#import "Products.h"
#import "Credits.h"
#import "Membership.h"
#import "Memberships.h"
#import "Projects.h"
#import "People.h"
#import "Returns.h"
#import "Donations.h"

@implementation ReturnHandler

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"ReturnHandler"];
    previousLengthOfInvoicesSearchString = 0;
    previousLengthOfProductsSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [donation release];  
  [invoice release];
  [product release];
  [returnedProduct release];
  [credit release];
  [project release];
  [person release];
  [membership release];
  [theReturn release];
  [invoicesArray release];
  [productsArray release];
  [returnedArray release];
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
  [self hideAndDisableButton:makeCreditButton];
  [pwcBackButton setEnabled:NO];
  [pwcNextButton setEnabled:NO];
  [pwcNextButton setHidden:NO];
  [quantityStepper setIntValue:0];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
}

//******************************************************************************

- (void)setupTextFields {
  [pwcTitleTextField setStringValue:@"Select Invoice"];
  [self clearTextField:invoiceTextField];
  [invoicesSearchField setStringValue:@""];
  [productsSearchField setStringValue:@""];
  [quantityTextField setIntValue:0];
  [self clearTextField:amountTextField];
  [self clearTextField:personTextField];
  [self clearTextField:cookTextField];
  [self clearTextField:subjectTextField];
  [self clearTextView:reasonTextView];
}

//******************************************************************************

- (void)setupTables {
  [self setInvoicesArray:[self paidInvoices]];
  [invoicesTableView setTarget:self];
  [invoicesTableView setDoubleAction:@selector(handleInvoicesClicked:)];
  
  [productsTableView setTarget:self];
  [productsTableView setDoubleAction:@selector(handleProductsClicked:)];
  
  [returnedTableView setTarget:self];
  [returnedTableView setDoubleAction:@selector(handleReturnedClicked:)];
  
  NSArray *tmp = [[NSArray alloc] init];
  [self setReturnedArray:tmp];
  [tmp release];

}

//******************************************************************************

- (void)setupStateVariables {
  [self setInvoice:nil];
  [self setProduct:nil];
  [self setReturnedProduct:nil];
  [self setPerson:nil];
  [self setTheReturn:nil];
  [self setCredit:nil];
  [self setMembership:nil];
  [self setDonation:nil];
}

//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)transferAllButtonClicked:(id)sender {
  //NSLog(@"transferAllButton clicked");
  [self setReturnedArray:productsArray];
  [returnedTableView reloadData];
  if ([returnedArray count] == 0) {
    [pwcNextButton setEnabled:NO];
  } else {
    [pwcNextButton setEnabled:YES];
  }
}

//******************************************************************************

- (IBAction)quantityStepperClicked:(id)sender {
  //NSLog(@"quantityStepper clicked");
  if (returnedProduct != nil) {
    int value = [quantityStepper intValue];
    if (value == 0) {
      [quantityStepper setIntValue:1];
      [quantityTextField setIntValue:1];
    } else if (value > [returnedProduct productQuantity]) {
      [quantityStepper setIntValue:[returnedProduct productQuantity]];
      [quantityTextField setIntValue:[returnedProduct productQuantity]];
    } else {
      [quantityTextField setIntValue:value];
    }
  }
}

//******************************************************************************

- (IBAction)deleteButtonClicked:(id)sender {
  //NSLog(@"deleteButton clicked");
  NSArray *selectedObjects = [returnedArrayController selectedObjects];
  if ([selectedObjects count] > 0) {
    Product *tmp = (Product *)[selectedObjects objectAtIndex:0];
    if (tmp != nil) {
      [self setReturnedProduct:nil];
      int index = -1;
      unsigned int i, count = [returnedArray count];
      for (i = 0; i < count; i++) {
        NSObject *obj = [returnedArray objectAtIndex:i];
        if (tmp == obj) {
          index = i;
        }
      }
  
      [returnedArray removeObjectAtIndex:index];
      [returnedTableView reloadData];
      [quantityStepper setIntValue:0];
      [quantityTextField setStringValue:@""];
      if ([returnedArray count] == 0) {
        [pwcNextButton setEnabled:NO];
      }
    }
  }
}

//******************************************************************************

- (IBAction)makeCreditButtonClicked:(id)sender {
  //NSLog(@"makeCreditButton clicked");
  NSString *author = [self latexSafeStringFromTextField:cookTextField];
  NSString *subject = [self lowercaseAndLatexSafeStringFromTextField:subjectTextField];
  NSString *body = [self lowercaseAndLatexSafeStringFromTextView:reasonTextView];

  ShopCredit *newCredit = [[ShopCredit alloc] init];
  [newCredit setOwnerUid:[person uid]];
  [newCredit setDate:[self calendarDateFromDatePicker:datePicker]];
  [newCredit setCreditAmount:[amountTextField doubleValue]];
  [newCredit setCommentAuthorName:author];
  [newCredit setCommentSubject:subject];
  [newCredit setCommentText:body];
  [[person creditUids] addObject:[newCredit uid]];
  [[Credits sharedInstance] setObject:newCredit forUid:[newCredit uid]];
  
  Return *newReturn = [[Return alloc] init];
  [newReturn setOwnerUid:[person uid]];
  [newReturn setInvoiceUid:[invoice uid]];
  [newReturn setCreditUid:[newCredit uid]];
  [newReturn setProducts:returnedArray];
  [newReturn setQuantity:[amountTextField doubleValue]];
  [newReturn setDate:[self calendarDateFromDatePicker:datePicker]];
  [newReturn setCommentAuthorName:author];
  [newReturn setCommentSubject:subject];
  [newReturn setCommentText:body];
  // use the active tag to set the product as non-returnable
  unsigned int i, count = [returnedArray count];
  for (i = 0; i < count; i++) {
    Product *obj = (Product *)[returnedArray objectAtIndex:i];
    [obj setActive:NO];
  }
  
  [[Returns sharedInstance] setObject:newReturn forUid:[newReturn uid]];
  [newCredit release];
  [newReturn release];
  
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

//******************************************************************************

- (IBAction)cancelButtonClicked:(id)sender {
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

//******************************************************************************
// next and back  button navigation
//******************************************************************************

- (IBAction)pwcNextButtonClicked:(id)sender {
  //////NSLog(@"pwcNextButtonClicked");
  // //NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
  [super pwcNextButtonClicked:sender];
  // //NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
  [self showAndEnableButton:pwcBackButton];
  if (pwcCurrentStep == 1) {
    
  } else if (pwcCurrentStep == 2) {
    [makeCreditButton setHidden:NO];
    [makeCreditButton setEnabled:NO];
    [makeCreditButton setState:0];
    [self hideAndDisableButton:pwcNextButton];
  }
}

- (IBAction)pwcBackButtonClicked:(id)sender {
  // //NSLog(@"pwcBackButtonClicked");
  if (pwcCurrentStep == 1) {
    [returnedArray removeAllObjects];
  } else if (pwcCurrentStep == 2) {
    [self showAndEnableButton:pwcNextButton];
    [self hideAndDisableButton:makeCreditButton];
  }
  ////NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
  [super pwcBackButtonClicked:sender];
  // //NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
}


/******************************************************************************/

- (void)tabView:(NSTabView *)theTabView willSelectTabViewItem:
  (NSTabViewItem *)theTabViewItem {
  if (theTabView == pwcTabView) {
    [super tabView:theTabView willSelectTabViewItem:theTabViewItem];
    int currentView = [theTabView indexOfTabViewItem:theTabViewItem] ;
    if (currentView == 0) {
      [pwcTitleTextField setStringValue:@"Select Invoice"];
    } else if (currentView == 1) {
      if ([returnedArray count] == 0) {
        [pwcNextButton setEnabled:NO];
      } else {
        [pwcNextButton setEnabled:YES];
      }
      [pwcTitleTextField setStringValue:@"Select Products to Return"];
    } else if (currentView == 2) {
      [pwcTitleTextField setStringValue:@"Make ShopCredit"];
    }
  }
}

//******************************************************************************
// misc
//******************************************************************************
- (NSArray *)paidInvoices {
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"invoicePaid == YES"];
  NSArray *filtered = [[[Invoices sharedInstance] arrayForDictionary] filteredArrayUsingPredicate:predicate];
  return filtered;
}

//******************************************************************************

- (NSArray *)returnableProducts {
  NSMutableArray *tmp = [[NSMutableArray alloc] init];
  id val;
  NSEnumerator *en = [[invoice items] objectEnumerator];
  while (val = [en nextObject]) {
    [tmp addObject:val];
  }
//  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active == YES"];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"active == YES AND !(productCode like %@)",
    @"stand"];
  NSArray *returnVal = [tmp filteredArrayUsingPredicate:predicate]; 
  [tmp release];
  return returnVal;
}

//******************************************************************************

- (bool)productIsMembership:(Product *)p {
  return [[p productCategory] isEqualToString:@"Membership"];
}

//******************************************************************************

- (bool)productIsProject:(Product *)p {
  return [[p productCode] isEqualToString:@"project"];
}

//******************************************************************************

- (bool)productIsDonation:(Product *)p {
  return [[p productCode] isEqualToString:@"donation"];
}

//******************************************************************************

- (void)enableMakeCreditButtonAppropriately {
  if ([self textFieldIsEmpty:cookTextField] ||
      [self textFieldIsEmpty:subjectTextField]) {
    [makeCreditButton setEnabled:NO];
  } else {
    [makeCreditButton setEnabled:YES];
  }
}

//******************************************************************************
// handlers
//******************************************************************************

- (void) handleInvoicesSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == invoicesSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *personString, *creationString, *paidString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setInvoicesArray:[self paidInvoices]];
      previousLengthOfInvoicesSearchString = 0;
      [invoicesTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfInvoicesSearchString > [searchString length]) {
      [self setInvoicesArray:[self paidInvoices]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [invoicesArray objectEnumerator];
    while (object = [e nextObject] ) {
      personString = [[object personName] lowercaseString];
      NSRange personRange = [personString rangeOfString:searchString options:NSLiteralSearch];
      creationString = [[[object date]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange creationRange = [creationString rangeOfString:searchString options:NSLiteralSearch];
      paidString = [[[object paidDate]  descriptionWithCalendarFormat:@"%m/%d/%Y"] lowercaseString];
      NSRange paidRange = [paidString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((personRange.length) > 0) || ((creationRange.length) > 0) || ((paidRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setInvoicesArray:filteredObjects];
    [invoicesTableView reloadData];
    previousLengthOfInvoicesSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void) handleProductsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == productsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *codeString, *nameString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setProductsArray:[self returnableProducts]];
      previousLengthOfProductsSearchString = 0;
      [productsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfProductsSearchString > [searchString length]) {
      [self setProductsArray:[self returnableProducts]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [productsArray objectEnumerator];
    while (object = [e nextObject] ) {
      codeString = [[object productCode] lowercaseString];
      NSRange codeRange = [codeString rangeOfString:searchString options:NSLiteralSearch];
      nameString = [[object productName] lowercaseString];
      NSRange nameRange = [nameString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((codeRange.length) > 0) || ((nameRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setProductsArray:filteredObjects];
    [productsTableView reloadData];
    previousLengthOfProductsSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    [self enableMakeCreditButtonAppropriately];
  }
}

//******************************************************************************

- (void)handleInvoicesChange:(NSNotification *)note {
  [self setInvoicesArray:[self paidInvoices]];
  [invoicesTableView reloadData];
}

//******************************************************************************

- (void)handleInvoicesClicked:(id)sender {
  NSArray *selectedObjects = [invoicesArrayController selectedObjects];
  if ([selectedObjects count] > 0) {
    Invoice *tmp = (Invoice *)[selectedObjects objectAtIndex:0];
    if (tmp != nil) {
      [self setInvoice:tmp];
      NSString *invoiceStr = [NSString stringWithFormat:@"Invoice: %@ %@ $%1.2f",
        [invoice personName], [invoice paidDate], [invoice invoiceTotal]];
      [invoiceTextField setStringValue:invoiceStr];
      Person *p = [[People sharedInstance] objectForUid:[invoice personUid]];
      [self setPerson:p];
      [personTextField setStringValue:[person personName]];
      [self setProductsArray:[self returnableProducts]];
      [pwcNextButton setEnabled:YES];
    }
  }
}

//******************************************************************************

- (void)handleProductsClicked:(id)sender {
  NSArray *selectedObjects = [productsArrayController selectedObjects];
  //NSLog(@"selectedObjects: %@", selectedObjects);
  if ([selectedObjects count] > 0) {
    Product *tmp = (Product *)[selectedObjects objectAtIndex:0];
    //NSLog(@"tmp: %@", tmp);
    if (tmp != nil) {
      NSArray *tmpArray = [NSArray arrayWithArray:returnedArray];
      NSMutableArray *newArray = [tmpArray mutableCopy];
      bool found = NO;
      NSString *tmpUid = [tmp uid];
      unsigned int i, count = [newArray count];
      for (i = 0; i < count; i++) {
        Product *obj = (Product *)[newArray objectAtIndex:i];
        if ([[obj uid] isEqualToString:tmpUid]) {
          found = YES;
        }
      }
      if (!found) {
        [newArray addObject:tmp];
        [self setProduct:tmp];
        [self setReturnedArray:newArray];
        //NSLog(@"returnedArray: %@", returnedArray);
        [returnedTableView reloadData];
        [pwcNextButton setEnabled:YES];
        double total = 0.0;
        unsigned int i, count = [returnedArray count];
        for (i = 0; i < count; i++) {
          Product *p = (Product *)[returnedArray objectAtIndex:i];
          total += [p productTotal];
        }
        //NSLog(@"total: $%1.2f", total);
        total = round(total);
        //NSLog(@"total: $%1.2f", total);
        [amountTextField setDoubleValue:total];
      }
    }
  }
}

//******************************************************************************

- (void)handleReturnedClicked:(id)sender {
  NSLog(@"handleReturnedClicked:");
  NSArray *selectedObjects = [returnedArrayController selectedObjects];
  if ([selectedObjects count] > 0) {
    Product *tmp = (Product *)[selectedObjects objectAtIndex:0];
    if (tmp != nil) {
      [self setReturnedProduct:tmp];
      int quantity = [product productQuantity];
      double doubleQ = quantity * 1.0;
      [quantityStepper setIntValue:quantity];
      [quantityStepper setMaxValue:doubleQ];
      [quantityTextField setIntValue:quantity];
    }
  }
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (Invoice *)invoice {
  return invoice;
}
- (void) setInvoice:(Invoice *)arg {
  [arg retain];
  [invoice release];
  invoice = arg;
}
- (Product *)product {
  return product;
}
- (void) setProduct:(Product *)arg {
  [arg retain];
  [product release];
  product = arg;
}
- (ShopCredit *)credit {
  return credit;
}
- (void) setCredit:(ShopCredit *)arg {
  [arg retain];
  [credit release];
  credit = arg;
}
- (Project *)project {
  return project;
}
- (void) setProject:(Project *)arg {
  [arg retain];
  [project release];
  project = arg;
}
- (Person *)person {
  return person;
}
- (void) setPerson:(Person *)arg {
  [arg retain];
  [person release];
  person = arg;
}
- (Membership *)membership {
  return membership;
}
- (void) setMembership:(Membership *)arg {
  [arg retain];
  [membership release];
  membership = arg;
}
- (Return *)theReturn {
  return theReturn;
}
- (void) setTheReturn:(Return *)arg {
  [arg retain];
  [theReturn release];
  theReturn = arg;
}
- (NSMutableArray *)invoicesArray {
  return invoicesArray;
}
- (void) setInvoicesArray:(NSArray *)arg {
  if (arg != invoicesArray) {
    [invoicesArray release];
    invoicesArray = [arg mutableCopy];
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
- (NSMutableArray *)returnedArray {
  return returnedArray;
}
- (void) setReturnedArray:(NSArray *)arg {
  if (arg != returnedArray) {
    [returnedArray release];
    returnedArray = [arg mutableCopy];
  }
}

- (Product *)returnedProduct {
  return returnedProduct;
}
- (void) setReturnedProduct:(Product *)arg {
  [arg retain];
  [returnedProduct release];
  returnedProduct = arg;
}

- (Donation *)donation {
  return donation;
}
- (void) setDonation:(Donation *)arg {
  [arg retain];
  [donation release];
  donation = arg;
}


//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(handleInvoicesSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:invoicesSearchField];
  
  [nc addObserver:self
         selector:@selector(handleProductsSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:productsSearchField];
  
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
         selector:@selector(handleInvoicesChange:)
             name:[[Invoices sharedInstance] notificationChangeString]
           object:nil];
  

  
}
@end