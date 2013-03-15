//
//  ReturnManager.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Return.h"
#import "Person.h"
#import "ShopCredit.h"

@interface ReturnManager : BasicWindowController {
  
  Return *theReturn;
  Person *person;
  ShopCredit *credit;
  IBOutlet NSTableView *returnsTableView;
  IBOutlet NSArrayController *returnsArrayController;
  NSMutableArray *returnsArray;
  IBOutlet NSTableView *productsTableView;
  IBOutlet NSArrayController *productsArrayController;
  NSMutableArray *productsArray;
  IBOutlet NSSearchField *returnsSearchField;
  int previousLengthOfReturnsSearchString;
  IBOutlet NSButton *deleteButton;
  IBOutlet NSTextField *personTextField;
  IBOutlet NSTextField *amountTextField;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSTextField *subjectTextField;
  IBOutlet NSTextView *reasonTextView;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSButton *cancelEditButton;
  IBOutlet NSButton *saveEditButton;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (Return *)theReturn;
- (void)setTheReturn:(Return *)arg;
- (Person *)person;
- (void)setPerson:(Person *)arg;
- (ShopCredit *)credit;
- (void)setCredit:(ShopCredit *)arg;
- (NSMutableArray *)returnsArray;
- (void)setReturnsArray:(NSArray *)arg;
- (void)handleReturnsClicked:(id)sender;
- (NSMutableArray *)productsArray;
- (void)setProductsArray:(NSArray *)arg;
- (void)handleProductsClicked:(id)sender;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)deleteButtonClicked:(id)sender;
- (IBAction)datePickerClicked:(id)sender;
- (IBAction)cancelEditButtonClicked:(id)sender;
- (IBAction)saveEditButtonClicked:(id)sender;


  //******************************************************************************
  // handlers
  //******************************************************************************
- (void)handleReturnsChange:(NSNotification *)note;
- (void)handleReturnsSearchFieldChange:(NSNotification *)note;
- (void)handleReturnsArraySelectionChange:(NSNotification *)note;


  //******************************************************************************
  // misc
  //******************************************************************************
- (NSArray *)returnedProducts;
- (void)enableSaveEditButtonAppropriately;

@end