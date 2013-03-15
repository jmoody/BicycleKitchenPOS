//
//  CompAProduct.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/6/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Product.h"
#import "Comp.h"

@interface CompAProduct : BasicWindowController {
  
  Comp *comp;
  IBOutlet NSTableView *productsTableView;
  IBOutlet NSArrayController *productsArrayController;
  NSMutableArray *productsArray;
  Product *product;
  IBOutlet NSSearchField *productsSearchField;
  int previousLengthOfProductsSearchString;
  IBOutlet NSTextField *nameTextField;
  IBOutlet NSTextField *quantityTextField;
  IBOutlet NSStepper *quantityStepper;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSTextField *subjectTextField;
  IBOutlet NSTextView *reasonTextView;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSButton *cancelButton;
  IBOutlet NSButton *compButton;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (Comp *)comp;
- (void)setComp:(Comp *)arg;
- (NSMutableArray *)productsArray;
- (void)setProductsArray:(NSArray *)arg;
- (void)handleProductsClicked:(id)sender;
- (Product *)product;
- (void)setProduct:(Product *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)quantityStepperClicked:(id)sender;
- (IBAction)datePickerClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)compButtonClicked:(id)sender;


  //******************************************************************************
  // handlers
  //******************************************************************************
- (void)handleProductsChange:(NSNotification *)note;
- (void)handleProductsSearchFieldChange:(NSNotification *)note;


  //******************************************************************************
  // misc
  //******************************************************************************
- (void)enableCompButtonAppropriately;

@end