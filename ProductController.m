//
//  ProductController.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/17/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "ProductController.h"
#import "Products.h"
#import "Product.h"
#import "ProductCategoriesDataSource.h"
#import "PreferenceController.h"

@implementation ProductController

- (id) init {
  self = [super init];
  if (self != nil) {
    self = [super initWithWindowNibName:@"ProductManager"];
    [self setupNotificationObservers];
    ProductCategoriesDataSource *tmp = [[ProductCategoriesDataSource alloc] init];
    [self setCategoriesDataSource:tmp];
    [tmp release];
  }
  return self;
}

- (void)setCategoriesDataSource:(ProductCategoriesDataSource *)pcds {
  if (categoriesDataSource != pcds) {
    [pcds retain];
    [categoriesDataSource release];
    categoriesDataSource = pcds;
  }
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
  NSEnumerator *enumerator;
  id value;
  
  enumerator = [productsInController objectEnumerator];
  while ((value = [enumerator nextObject])) {
    [value release];
  }
  [categoriesDataSource release];
  [productsInController release];
  [currentlyViewedProduct release];
  [super dealloc];
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<ProductController: %@>",
    [self productsInController]];
}

//******************************************************************************
// windowing
//******************************************************************************

- (void)setupForNonModal {
  // combo box setup
  [categoriesComboBox setDataSource:categoriesDataSource];
  [categoriesComboBox setStringValue:@"Axles"];
  [categoriesComboBox setNumberOfVisibleItems:10];
  
  [self setProductsInController:[[Products sharedInstance] arrayForDictionary]];
  [productsTableView setTarget:self];
  [productsTableView setDoubleAction:@selector(showProductInfoWindow:)];
    
}

//******************************************************************************

- (void)windowDidLoad {
  // only get called once
  [super windowDidLoad];
}

//******************************************************************************
// searching
//******************************************************************************

- (void)handleProductSearchFieldTextDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *productCodeString;
    NSString *productNameString;
    NSString *categoryString;
    NSString *activeString;
    NSString *priceString;
    NSString *quantityString;
    
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setProductsInController:[[Products sharedInstance] arrayForDictionary]];
      previousLengthOfSearchString = 0;
      [productsTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfSearchString > [searchString length]) {
      [self setProductsInController:[[Products sharedInstance] arrayForDictionary]];
    }
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [productsInController objectEnumerator];
    while ( object = [e nextObject] ) {
      productCodeString = [[object productCode] lowercaseString];
      productNameString = [[object productName] lowercaseString];
      categoryString = [[object productCategory] lowercaseString];

      activeString = [[object activeYesOrNo] lowercaseString];
      NSRange activeRange = [activeString rangeOfString:searchString options:NSLiteralSearch];
      priceString = [NSString stringWithFormat:@"%1.2f", [object productPrice]];
      NSRange priceRange = [priceString rangeOfString:searchString options:NSLiteralSearch];
      quantityString = [NSString stringWithFormat:@"%d", [object productQuantity]];
      NSRange quantityRange = [quantityString rangeOfString:searchString options:NSLiteralSearch];
      
      
      
      NSRange codeRange = [productCodeString rangeOfString:searchString options:NSLiteralSearch];
      NSRange nameRange = [productNameString rangeOfString:searchString options:NSLiteralSearch];
      NSRange categoryRange = [categoryString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((codeRange.length) > 0) || ((nameRange.length) > 0) || ((categoryRange.length) > 0)
          || ((activeRange.length) > 0) || ((priceRange.length) > 0)
          || ((quantityRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setProductsInController:filteredObjects];
    [productsTableView reloadData];
    previousLengthOfSearchString = [searchString length];
    [filteredObjects release];
  }
}  

//******************************************************************************
// IBActions
//******************************************************************************

//******************************************************************************
// makeNewProduct
//******************************************************************************

- (IBAction)makeNewProduct:(id)sender {
  [saveOrAddProductButton setTitle:@"Add"];
  [saveOrAddProductButton setEnabled:NO];
  
  [productTaxableSwitch setState:1];
  [productActiveSwitch setState:1];
  [self clearTextFields];
  if ([productCodeTextField acceptsFirstResponder]) {
    [productInfoPanel makeFirstResponder:productCodeTextField];
  }
  [productPriceTextField setDoubleValue:1.0];
  [productQuantityTextField setIntValue:1];
  [categoriesComboBox setStringValue:[NSString stringWithFormat:@"Axles"]];
  [productPriceStepper setDoubleValue:1.0];
  [productQuantityStepper setDoubleValue:1.0];
  [productInfoPanel makeKeyAndOrderFront:self];

}


//******************************************************************************
// showProductInfoWindow
//******************************************************************************

- (IBAction)showProductInfoWindow:(id)sender {
  ////NSLog(@"in showProductInfoWindow");
  // get the product

  Product *selectedProduct = [[productsArrayController selectedObjects] objectAtIndex:0];
  [self setCurrentlyViewedProduct:selectedProduct];
  
  // adjust the button
  [saveOrAddProductButton setTitle:@"Save Edit"];
  [saveOrAddProductButton setEnabled:NO];
  
  // fill in the text fields
  [productCodeTextField setStringValue:[selectedProduct productCode]];
  [productNameTextField setStringValue:[selectedProduct productName]];
  [productPriceTextField setDoubleValue:[selectedProduct productPrice]];
  [productQuantityTextField setIntValue:[selectedProduct productQuantity]];
  [categoriesComboBox setStringValue:[selectedProduct productCategory]];
  
  // set the steppers
  [productQuantityStepper setDoubleValue:[selectedProduct productQuantity]];
  [productPriceStepper setDoubleValue:[selectedProduct productPrice]];
  

  // set the active button
  if ([selectedProduct active]) 
    [productActiveSwitch setState:1];
  else {
    [productActiveSwitch setState:0];
  }

  // set the taxable button
  if ([selectedProduct taxable]) 
    [productTaxableSwitch setState:1];
  else {
    [productTaxableSwitch setState:0];
  }
  
  // make the productCodeTextField the first responder
  if ([productCodeTextField acceptsFirstResponder]) {
    [productInfoPanel makeFirstResponder:productCodeTextField];
  }
  
  [productInfoPanel makeKeyAndOrderFront:self];
}

//******************************************************************************
// saveOrAddProductAction
//******************************************************************************

- (IBAction)saveOrAddProductAction:(id)sender {
  if ([[saveOrAddProductButton title] isEqualToString:@"Add"]) {
    [self addProduct];
  } else {
    [self saveProduct];
  }
}

- (IBAction)switchFlipped:(id)sender {
  if ([[saveOrAddProductButton title] isEqualToString:@"Save Edit"]) {
    [saveOrAddProductButton setEnabled:YES];
  }
}

- (IBAction)productQuantityStepperClicked:(id)sender {
  ////NSLog(@"productQuantityStepperClicked");
  [productQuantityTextField setDoubleValue:[productQuantityStepper doubleValue]];
  [self enableSaveEditButtonAppropriately:sender];
}

- (IBAction)productPriceStepperClicked:(id)sender {
  ////NSLog(@"productPriceStepperClicked");
  [productPriceTextField setDoubleValue:[productPriceStepper doubleValue]];
  [self enableSaveEditButtonAppropriately:sender];
}

//******************************************************************************
// addProduct
//******************************************************************************

- (void)addProduct {
  NSString *newProductCode = [self lowercaseAndLatexSafeStringFromTextField:productCodeTextField];
  NSString *newProductName = [self lowercaseAndLatexSafeStringFromTextField:productNameTextField];
  // what if the search field has context (ie. there is a search in progress)
  // we should search over the products in the singleton instead
  NSArray *products = [[Products sharedInstance] arrayForDictionary];
  unsigned int i, count = [products count];
  for (i = 0; i < count; i++) {
    Product *value = [products objectAtIndex:i];
    // duplicate productCode?
    if ([[value productCode] isEqualToString:newProductCode]) {
      NSString *message = 
      [NSString stringWithFormat:@"A product with code %@ already exists:\n <Product: %@ %@>", 
        newProductCode, [value productCode], [value productName]];
      int choice = NSRunAlertPanel(@"Duplicate Product Code",message,@"Cancel Add",
                                   @"Try Again",nil);
      if (choice == 1) {
        [self handleCancelAdd];
        return;
      } else {
        [self handleTryAgainAdd];
        return;
      }
    }
    // duplicate productName
    if ([[value productName] isEqualToString:newProductName]) {
      NSString *message = 
      [NSString stringWithFormat:@"A product with description %@ already exists:\n <Product: %@ %@>", 
        newProductName, [value productCode], [value productName]];
      int choice = NSRunAlertPanel(@"Duplicate Product Description",message,@"Cancel Add",
                                   @"Try Again",nil);
      if (choice == 1) {
        [self handleCancelAdd];
        return;
      } else {
        [self handleTryAgainAdd];
        return;
      }
    }
  }
  // make a new product
  Product *newProduct = [[Product alloc] init];
  [newProduct setProductCode:newProductCode];
  [newProduct setProductName:newProductName];
  [newProduct setProductPrice: [productPriceTextField doubleValue]];
  [newProduct setProductQuantity:[productQuantityTextField intValue]];
  [newProduct setActive:[productActiveSwitch state]];
  [newProduct setTaxable:[productTaxableSwitch state]];
  // we use objectValueOfSelectedItem vs. stringValue because
  // occassionally stringValue is retarted by 1 click
  // motherfucker.  can't used objectValueOfSelectedItem with
  // combo boxes backed by a data source
  //int index = [categoriesComboBox indexOfSelectedItem];
  int indexOfCategory = [categoriesComboBox indexOfSelectedItem];
  NSString *currentCat;
  if (indexOfCategory == -1) {
    currentCat = [categoriesComboBox stringValue];
  } else {
    currentCat = [[categoriesComboBox dataSource] comboBox:categoriesComboBox
                                 objectValueForItemAtIndex:indexOfCategory];
  }
  ////NSLog(@"index: %d currentCategory: %@", indexOfCategory, currentCat);
  
  [newProduct setProductCategory:currentCat];
  
  // getting the undo/redo right
  addingNew = YES;
  // insert it
  [productsArrayController insertObject:newProduct atArrangedObjectIndex:0];
  // cleanup
  [self clearTextFields];
  [newProduct release];
  
  [productInfoPanel close];
}

//******************************************************************************

- (void)clearTextFields {
  NSString *emptyString = [NSString stringWithFormat:@""];
  [productCodeTextField setStringValue:emptyString];
  [productNameTextField setStringValue:emptyString];
  [productPriceTextField setStringValue:emptyString];
  [productQuantityTextField setStringValue:emptyString];
  [categoriesComboBox setStringValue:[NSString stringWithFormat:@"Axles"]];
}

//******************************************************************************

- (void)handleCancelAdd {
  [self clearTextFields];
  [productInfoPanel close];
}

//******************************************************************************

- (void)handleTryAgainAdd {
  [saveOrAddProductButton setEnabled:NO];
  [productActiveSwitch setState:1];
  [productInfoPanel makeKeyAndOrderFront:self];
}
    
//******************************************************************************

- (void)handleProductInformationChange:(NSNotification *)note {
  if ([productInfoPanel isKeyWindow]) {
    // handling new product editing
    if ([[saveOrAddProductButton title] isEqualToString:[NSString stringWithFormat:@"Add"]]) {
      [self enableAddProductButtonAppropriately];
    } else {
      [self enableSaveEditButtonAppropriately:[note object]];
    }
  }
}

- (void)enableAddProductButtonAppropriately {
  NSString *emptyString = [NSString stringWithFormat:@""];
  if ((![[productCodeTextField stringValue] isEqualToString:emptyString]) &&
      (![[productNameTextField stringValue] isEqualToString:emptyString]) &&
      (![[productPriceTextField stringValue] isEqualToString:emptyString]) &&
      (![[productQuantityTextField stringValue] isEqualToString:emptyString])) {
    [saveOrAddProductButton setEnabled:YES];
  } else {
    [saveOrAddProductButton setEnabled:NO];
  }
}

- (void)enableSaveEditButtonAppropriately:(id)object {
  // motherfucker.  can't used objectValueOfSelectedItem with
  // combo boxes backed by a data source
  //int index = [categoriesComboBox indexOfSelectedItem];
  ////NSLog(@"object in enableSaveEditButtonAppropriately: %@", object);
  NSString *currentCat;
  int indexOfCategory;
  
  if (object == categoriesComboBox) {
    indexOfCategory = [categoriesComboBox indexOfSelectedItem];
    if (indexOfCategory == -1) {
      currentCat = [[categoriesComboBox dataSource] comboBox:categoriesComboBox
                                             completedString:[categoriesComboBox stringValue]];
    } else {
      currentCat = [[categoriesComboBox dataSource] comboBox:categoriesComboBox
                                   objectValueForItemAtIndex:indexOfCategory];
    }
  } else {
    currentCat = [categoriesComboBox stringValue];
  }
  
  ////NSLog(@"index: %d currentCategory: %@", indexOfCategory, currentCat);
  
  NSString *originalProductCode = [currentlyViewedProduct productCode];
  NSString *originalProductName = [currentlyViewedProduct productName];
  NSString *originalCategory = [currentlyViewedProduct productCategory];
  double originalProductPrice = [currentlyViewedProduct productPrice];
  int originalProductQuantity = [currentlyViewedProduct productQuantity];
  bool originalProductTaxable = [currentlyViewedProduct taxable];
  bool originalProductActive = [currentlyViewedProduct active];
  if (((![[productCodeTextField stringValue] isEqualToString:originalProductCode]) ||
      (![[productNameTextField stringValue] isEqualToString:originalProductName]) ||
      (![currentCat isEqualToString:originalCategory]) ||
      ([productPriceTextField doubleValue] != originalProductPrice) ||
      ([productQuantityTextField intValue] != originalProductQuantity) ||
      ([productTaxableSwitch state] != [self intForBoolean:originalProductTaxable]) ||
      ([productActiveSwitch state] != [self intForBoolean:originalProductActive]))
      && [[categoriesComboBox dataSource] validCategory:currentCat]) {
    [saveOrAddProductButton setEnabled:YES];
  } else {
    [saveOrAddProductButton setEnabled:NO];
  }
}

//******************************************************************************

- (int)intForBoolean:(bool)b {
  if (b) {
    return 1;
  } else {
    return 0;
  }
}

//******************************************************************************
// saveProduct
//******************************************************************************

- (void)saveProduct {
  NSString *newProductCode = [self lowercaseAndLatexSafeStringFromTextField:productCodeTextField];
  NSString *newProductName = [self lowercaseAndLatexSafeStringFromTextField:productNameTextField];
  double newProductPrice = [productPriceTextField doubleValue];
  
  NSString *stand, *project, *donation;
  stand = TljBkPosStandTimeProductCode;
  project = TljBkPosProjectProductCode;
  donation = TljBkPosDonationProductCode;
  NSString *code = [currentlyViewedProduct productCode];
  
  
  bool alertForStandOrProject = NO;
  NSString *alertMessage;
  if ([code isEqualToString:stand]) {
    alertForStandOrProject = YES;
    if (![newProductCode isEqualToString:stand]) {
      alertMessage = [NSString stringWithFormat:@"Changing the code for stand will break\n certain features in the POS."];
    } else if (newProductPrice != [currentlyViewedProduct productPrice]) {
      alertForStandOrProject = YES;
      alertMessage = [NSString stringWithFormat:@"The price of stand time cannot be changed here.  Make sure the book is closed\nand open the Preferences window to make this change."];
    } 
  } else if ([code isEqualToString:project]) {
    if (![newProductCode isEqualToString:project]) {
      alertForStandOrProject = YES;
      alertMessage = [NSString stringWithFormat:@"Changing the code for project will break\n certain features in the POS."];
    } 
  } else if ([code isEqualToString:donation]) {
    if (![newProductCode isEqualToString:donation]) {
      alertForStandOrProject = YES;
      alertMessage = [NSString stringWithFormat:@"Changing the code for donation will break\n certain features in the POS."];
    }
  } 
  
  if (alertForStandOrProject) {
    int thisChoice = NSRunAlertPanel(@"Operation Not Permitted",
                                     alertMessage,@"Continue",nil,nil);
    // the only choice
    if (thisChoice == 1) {
      [self handleCancelAdd];
      return;
    }
  }

  ////NSLog(@"In save product");
  Product *candidateMatch;
  candidateMatch = [[Products sharedInstance] productForProductCode:newProductCode];
  ////NSLog(@"code match: %@", candidateMatch);
  if ((candidateMatch != nil) && ![currentlyViewedProduct samep:candidateMatch]) {
    NSString *message =
    [NSString stringWithFormat:@"A product with code %@ already exists:\n <Product: %@ %@>", 
      newProductCode, [candidateMatch productCode], [candidateMatch productName]];
    int choice = NSRunAlertPanel(@"Duplicate Product Code",message,@"Cancel Add",
                                 @"Try Again",nil);
    if (choice == 1) {
      [self handleCancelAdd];
      return;
    } else {
      [self handleTryAgainAdd];
      return;
    }
  }
  
  candidateMatch = [[Products sharedInstance] productForProductName:newProductName];
  ////NSLog(@"name match: %@", candidateMatch);
  if ((candidateMatch != nil) && ![currentlyViewedProduct samep:candidateMatch]) {
    NSString *message = 
    [NSString stringWithFormat:@"A product with description %@ already exists:\n <Product: %@ %@>", 
      newProductCode, [candidateMatch productCode], [candidateMatch productName]];
    int choice = NSRunAlertPanel(@"Duplicate Product Description",message,
                                 @"Cancel Add", @"Try Again",nil);
    if (choice == 1) {
      [self handleCancelAdd];
      return;
    } else {
      [self handleTryAgainAdd];
      return;
    }    
  }
  
  [currentlyViewedProduct setProductCode:newProductCode];
  [currentlyViewedProduct setProductName:newProductName];
  [currentlyViewedProduct setProductPrice: newProductPrice];
  [currentlyViewedProduct setProductQuantity:[productQuantityTextField intValue]];
  [currentlyViewedProduct setActive:[productActiveSwitch state]];
  [currentlyViewedProduct setTaxable:[productTaxableSwitch state]];
  // use objectValueOfSelectedItem vs. stringValue
  // motherfucker, can't used objectValueOfSelectedItem with combo
  // boxes backed by a data source
  //int index = [categoriesComboBox indexOfSelectedItem];
  // this throws an exception.  fuck all
  int indexOfCategory = [categoriesComboBox indexOfSelectedItem];
  NSString *currentCat;
  if (indexOfCategory == -1) {
    currentCat = [categoriesComboBox stringValue];
  } else {
    currentCat = [[categoriesComboBox dataSource] comboBox:categoriesComboBox
                                 objectValueForItemAtIndex:indexOfCategory];
  }
  ////NSLog(@"index: %d currentCategory: %@", indexOfCategory, currentCat);
    
  [currentlyViewedProduct setProductCategory:currentCat];
  // save the edit to disk
  [[Products sharedInstance] saveToDisk];
  
  //[[Products sharedInstance] setObject:currentlyViewedProduct forUid:[currentlyViewedProduct uid]];
  
  // clean up
  [self clearTextFields];
  [productInfoPanel close];
}


//******************************************************************************
// accessor
//******************************************************************************

- (NSMutableArray *)productsInController {
  return productsInController;
}

- (Product *)currentlyViewedProduct {
  return currentlyViewedProduct;
}

- (ProductCategoriesDataSource *)categoriesDataSource {
  return categoriesDataSource;
}

//******************************************************************************
// setter
//******************************************************************************

- (void)setProductsInController:(NSArray *)array {
  if (productsInController != array) {
    
    NSEnumerator *enumerator = [productsInController objectEnumerator];
    id value;
    while ((value = [enumerator nextObject])) {
      [self stopObservingProduct:value];
    }
    
    [productsInController release];
    productsInController = [array mutableCopy];
    
    enumerator = [productsInController objectEnumerator];
    while ((value = [enumerator nextObject])) {
      [self startObservingProduct:value];
    }
  }
}

- (void)setCurrentlyViewedProduct:(Product *)product {
  if (product != currentlyViewedProduct) {
    [currentlyViewedProduct release];
    [product retain];
    currentlyViewedProduct = product;
  }
}


- (void)handleProductsChange:(NSNotification *)note {
  [self clearTextField:productSearchField];
  [self setProductsInController:[[Products sharedInstance] arrayForDictionary]];
  [productsTableView reloadData];
  
}

//******************************************************************************
// insert/remove
//******************************************************************************

- (void)insertObject:(Product *)p inProductsInControllerAtIndex:(int)index {
  //Add the inverse of this operaton to the undo stack
  NSUndoManager *undo = [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self]
    removeObjectFromProductsInControllerAtIndex:index];
  if (![undo isUndoing]) {
    [undo setActionName:@"Add Product"];
  }
  
  [self startObservingProduct:p];
//  [productsInController insertObject:p atIndex:index];
  [[Products sharedInstance] setObject:p forUid:[p uid]];
//  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//  [nc postNotificationName:[[Products sharedInstance] notificationChangeString] object:self];
  
}

//******************************************************************************

- (void) removeObjectFromProductsInControllerAtIndex:(int)index {
  Product *p = [productsInController objectAtIndex:index];
  // Add the inverse of this operation to the undo stack
  
  NSUndoManager *undo =  [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self] insertObject:p
                                     inProductsInControllerAtIndex:index];
  
  if (![undo isUndoing]) {
    [undo setActionName:@"Delete Product"];
  }
  
  [self stopObservingProduct:p];
//  [productsInController removeObjectAtIndex:index];
  [[Products sharedInstance] removeObjectForUid:[p uid]];
//  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//  [nc postNotificationName:[[Products sharedInstance] notificationChangeString] object:self];

  
}

//******************************************************************************

// undo for edits
- (void)startObservingProduct:(Product *)p {
  [p addObserver:self
      forKeyPath:@"productCode"
         options:NSKeyValueObservingOptionOld
         context:NULL];
  
  [p addObserver:self
      forKeyPath:@"productName"
         options:NSKeyValueObservingOptionOld
         context:NULL];
  
  [p addObserver:self
      forKeyPath:@"productPrice"
         options:NSKeyValueObservingOptionOld
         context:NULL];
  
  [p addObserver:self
      forKeyPath:@"productQuantity"
         options:NSKeyValueObservingOptionOld
         context:NULL];
  
  [p addObserver:self
      forKeyPath:@"productCategory"
         options:NSKeyValueObservingOptionOld
         context:NULL];
  
  [p addObserver:self
      forKeyPath:@"taxable"
         options:NSKeyValueObservingOptionOld
         context:NULL];
  
  [p addObserver:self
      forKeyPath:@"active"
         options:NSKeyValueObservingOptionOld
         context:NULL];
}

//******************************************************************************

- (void)stopObservingProduct:(Product *)p {
  [p removeObserver:self forKeyPath:@"productCode"];
  [p removeObserver:self forKeyPath:@"productName"];
  [p removeObserver:self forKeyPath:@"productPrice"];
  [p removeObserver:self forKeyPath:@"productCategory"];
  [p removeObserver:self forKeyPath:@"productQuantity"];
  [p removeObserver:self forKeyPath:@"taxable"];
  [p removeObserver:self forKeyPath:@"active"];
}

//******************************************************************************

- (void)changeKeyPath:(NSString *)keyPath
            ofObject:(id)obj
             toValue:(id)newValue {
  // setValue:forKeyPath will cause the key-value observing method
  // to be called, which takes care of the undo stuff
  [obj setValue:newValue forKeyPath:keyPath];
}

//******************************************************************************

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  
  NSUndoManager *undo = [[self window] undoManager];
  id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
  ////NSLog(@"oldValue = %@", oldValue);
  [[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath
                                                ofObject:object
                                                 toValue:oldValue];
  [undo setActionName:@"Edit Product"];
}

//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  // enabling buttons
  [nc addObserver:self 
         selector:@selector(handleProductInformationChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productCodeTextField];
  
  [nc addObserver:self 
         selector:@selector(handleProductInformationChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productNameTextField];
  
  [nc addObserver:self 
         selector:@selector(handleProductInformationChange:)
             name:@"NSComboBoxSelectionDidChangeNotification"
           object:categoriesComboBox];
  
  [nc addObserver:self 
         selector:@selector(handleProductInformationChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productPriceTextField];
  
  [nc addObserver:self 
         selector:@selector(handleProductInformationChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productQuantityTextField];
  
  [nc addObserver:self 
         selector:@selector(handleProductInformationChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productActiveSwitch];
  
  [nc addObserver:self 
         selector:@selector(handleProductInformationChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productTaxableSwitch];
  
  // searching
  [nc addObserver:self
         selector:@selector(handleProductSearchFieldTextDidChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productSearchField];
    
  
  // handling undo/redo edits
  [nc addObserver:self
         selector:@selector(handleUndoEdits:)
             name:@"NSUndoManagerDidRedoChangeNotification"
           object:nil];

  [nc addObserver:self
         selector:@selector(handleUndoEdits:)
             name:@"NSUndoManagerDidUndoChangeNotification"
           object:nil];
  
  [nc addObserver:self
         selector:@selector(handleProductsChange:)
             name:[[Products sharedInstance] notificationChangeString]
           object:nil];
  
}

- (void)handleUndoEdits:(NSNotification *)note {
  if ([note object] == [[self window] undoManager]) {
    [[Products sharedInstance] saveToDisk];
  }
  
}


@end
