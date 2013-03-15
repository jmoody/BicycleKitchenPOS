//
//  ProductController.h
//  BicycleKitchenPOS
//
//  Created by moody on 7/17/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Product.h"
#import "ProductCategoriesDataSource.h"

@interface ProductController : BasicWindowController {
  IBOutlet NSButton *newProductButton;
  IBOutlet NSButton *deleteProductButton;
  IBOutlet NSSearchField *productSearchField;
  
  NSMutableArray *productsInController;
  
  IBOutlet NSTableView *productsTableView;
  IBOutlet NSArrayController *productsArrayController;
  
  // capturing return button pressed
  IBOutlet NSButton *openInfoWindowButton;
  
  // product info panel
  IBOutlet NSPanel *productInfoPanel;
  IBOutlet NSTextField *productCodeTextField;
  IBOutlet NSTextField *productNameTextField;
  IBOutlet NSTextField *productPriceTextField;
  IBOutlet NSStepper *productPriceStepper;
  IBOutlet NSStepper *productQuantityStepper;
  IBOutlet NSTextField *productQuantityTextField;
  IBOutlet NSButton *productActiveSwitch;
  IBOutlet NSButton *productTaxableSwitch;
  IBOutlet NSButton *saveOrAddProductButton;
  IBOutlet NSButton *cancelButton;
  IBOutlet NSComboBox *categoriesComboBox;
  ProductCategoriesDataSource *categoriesDataSource;
  
  // placeholder products for enabling/disabling buttons
  Product *currentlyViewedProduct;
  
  // searching
  int previousLengthOfSearchString;
  
  bool addingNew;
  
 }

// accessors
- (NSMutableArray *)productsInController;
- (Product *)currentlyViewedProduct;

// setters
- (void)setProductsInController:(NSArray *)array;
- (void)setCurrentlyViewedProduct:(Product *)product;
- (void)setCategoriesDataSource:(ProductCategoriesDataSource *)pcds;

// insert/remove
- (void)insertObject:(Product *)p inProductsInControllerAtIndex:(int)index;
- (void)removeObjectFromProductsInControllerAtIndex:(int)index;

// ibactions for displaying productInfoPanel
- (IBAction)makeNewProduct:(id)sender;
- (IBAction)saveOrAddProductAction:(id)sender;
- (IBAction)showProductInfoWindow:(id)sender;
- (IBAction)productQuantityStepperClicked:(id)sender;
- (IBAction)productPriceStepperClicked:(id)sender;
- (IBAction)switchFlipped:(id)sender;
// we've got this bound to the window's performClose:
// let's see how it works.
//- (IBAction)cancelButtonClicked:(id)sender;



//******************************************************************************
// handlers
//******************************************************************************

- (void)setupNotificationObservers;

- (void)handleProductsChange:(NSNotification *)note;
// handles enabling/disabling buttons
- (void)handleProductInformationChange:(NSNotification *)note;
// searching
- (void)handleProductSearchFieldTextDidChange:(NSNotification *)note;


// does the insertion of new objects and editing of existing objects
- (void)saveProduct;
- (void)addProduct;

// helpers
- (void)clearTextFields;
- (void)handleCancelAdd;
- (void)handleTryAgainAdd;
- (int)intForBoolean:(bool)b;

  
- (void)enableAddProductButtonAppropriately;
- (void)enableSaveEditButtonAppropriately:(id)object;


// undo for edits
- (void)startObservingProduct:(Product *)p;
- (void)stopObservingProduct:(Product *)p;
- (void)changeKeyPath:(NSString *)keyPath
            ofObject:(id)obj
             toValue:(id)newValue;
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;
@end
