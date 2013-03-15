//
//  CompAProduct.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/6/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CompAProduct.h"
#import "Products.h"
#import "Comp.h"
#import "Comps.h"

@implementation CompAProduct

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    self = [super initWithWindowNibName:@"CompAProduct"];
    previousLengthOfProductsSearchString = 0;
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************

- (void) dealloc {
  [productsArray release];
  [comp release];  
  [product release];
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
  [compButton setEnabled:NO];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
  [quantityStepper setDoubleValue:1.0];
}

//******************************************************************************

- (void)setupTextFields {
  [self clearTextField:nameTextField];
  [quantityTextField setIntValue:1];
  [self clearTextField:cookTextField];
  [self clearTextField:subjectTextField];
  [self clearTextView:reasonTextView];
  [productsSearchField setStringValue:@""];
}

//******************************************************************************

- (void)setupTables {
  [self setProductsArray:[[Products sharedInstance] arrayForDictionary]];
  [productsTableView setTarget:self];
  [productsTableView setDoubleAction:@selector(handleProductsClicked:)];
  [self setComp:nil];
}

//******************************************************************************

- (void)setupStateVariables {
  [self setComp:nil];
  [self setProduct:nil];
}


//******************************************************************************
// button actions
//******************************************************************************

- (IBAction)quantityStepperClicked:(id)sender {
  //NSLog(@"quantityStepper clicked");
  int value = [quantityStepper intValue];
  [quantityTextField setIntValue:value];
}

//******************************************************************************

- (IBAction)datePickerClicked:(id)sender {
  
}

//******************************************************************************

- (IBAction)cancelButtonClicked:(id)sender {
  //NSLog(@"cancelButton clicked");
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

//******************************************************************************

- (IBAction)compButtonClicked:(id)sender {
  //NSLog(@"compButton clicked");
  Comp *new = [[Comp alloc] init];
  [new setProductName:[product productName]];
  [new setProductCode:[product productCode]];
  [new setProductQuantity:[quantityTextField intValue]];
  [new setProductUid:[product uid]];
  [new setCommentAuthorName:[cookTextField stringValue]];
  [new setCommentSubject:[subjectTextField stringValue]];
  [new setCommentText:[reasonTextView string]];
  [new setDate:[self calendarDateFromDatePicker:datePicker]];
  [[Comps sharedInstance] setObject:new forUid:[new uid]];
  [self setComp:new];
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

//******************************************************************************
// misc
//******************************************************************************
- (void)enableCompButtonAppropriately {  
  if ([self textFieldIsEmpty:cookTextField] ||
      [self textFieldIsEmpty:subjectTextField] ||
      [self textFieldIsEmpty:nameTextField]) {
    [compButton setEnabled:NO];
  } else {
    [compButton setEnabled:YES];
  }
}


//******************************************************************************
// handlers
//******************************************************************************

- (void) handleProductsSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] && [note object] == productsSearchField) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *codeString, *nameString, *activeString, *priceString, *quantityString;
    id object;
    // revert to whole list of objects
    if ( [searchString length] == 0 ) {
      [self setProductsArray:[[Products sharedInstance] arrayForDictionary]];
      previousLengthOfProductsSearchString = 0;
      [productsTableView reloadData];
      return;
    }
    
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfProductsSearchString > [searchString length]) {
      [self setProductsArray:[[Products sharedInstance] arrayForDictionary]];
    }
    
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [productsArray objectEnumerator];
    while (object = [e nextObject] ) {
      codeString = [[object productCode] lowercaseString];
      NSRange codeRange = [codeString rangeOfString:searchString options:NSLiteralSearch];
      nameString = [[object productName] lowercaseString];
      NSRange nameRange = [nameString rangeOfString:searchString options:NSLiteralSearch];
      activeString = [[object activeYesOrNo] lowercaseString];
      NSRange activeRange = [activeString rangeOfString:searchString options:NSLiteralSearch];
      priceString = [NSString stringWithFormat:@"%1.2f", [object productPrice]];
      NSRange priceRange = [priceString rangeOfString:searchString options:NSLiteralSearch];
      quantityString = [NSString stringWithFormat:@"%d", [object productQuantity]];
      NSRange quantityRange = [quantityString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((codeRange.length) > 0) || ((nameRange.length) > 0) 
          || ((activeRange.length) > 0) || ((priceRange.length) > 0)
          || ((quantityRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setProductsArray:filteredObjects];
    [productsTableView reloadData];
    previousLengthOfProductsSearchString = [searchString length];
  }
}

//******************************************************************************

- (void) textDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    [self enableCompButtonAppropriately];
  }
}

- (void)handleProductsChange:(NSNotification *)note {
  NSArray *tmp = [[Products sharedInstance] arrayForDictionary];
  [self setProductsArray:tmp];
  [productsTableView reloadData];
}

//******************************************************************************

- (void)handleProductsClicked:(id)sender {
  NSArray *selectedObjects = [productsArrayController selectedObjects];
  if ([selectedObjects count] > 0) {
    Product *tmp = (Product *)[selectedObjects objectAtIndex:0];
    if (tmp != nil) {
      [self setProduct:tmp];
      [nameTextField setStringValue:[product productName]];
    }
  }
}

//******************************************************************************
// accessors and setters
//******************************************************************************

- (NSMutableArray *)productsArray {
  return productsArray;
}
- (void) setProductsArray:(NSArray *)arg {
  if (arg != productsArray) {
    [productsArray release];
    productsArray = [arg mutableCopy];
  }
}
- (Product *)product {
  return product;
}
- (void) setProduct:(Product *)arg {
  [arg retain];
  [product release];
  product = arg;
}

- (Comp *)comp {
  return comp;
}
- (void) setComp:(Comp *)arg {
  [arg retain];
  [comp release];
  comp = arg;
}



//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
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
         selector:@selector(handleProductsChange:)
             name:[[Products sharedInstance] notificationChangeString]
           object:nil];
  
}
@end