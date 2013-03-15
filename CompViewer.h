// 
// CompViewer.h
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Comp.h"

@interface CompViewer : BasicWindowController {
  
  IBOutlet NSTableView *compsTableView;
  IBOutlet NSArrayController *compsArrayController;
  NSMutableArray *compsArray;
  Comp *comp;
  IBOutlet NSTextField *nameTextField;
  IBOutlet NSTextField *cookTextField;
  IBOutlet NSTextField *reasonTextField;
  IBOutlet NSTextView *noteTextView;
  IBOutlet NSDatePicker *datePicker;
  IBOutlet NSTextField *valueTextField;
  IBOutlet NSButton *cancelButton;
  IBOutlet NSButton *printButton;
  
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSMutableArray *)compsArray;
- (void)setCompsArray:(NSArray *)arg;
- (void)handleCompsClicked:(id)sender;
- (Comp *)comp;
- (void)setComp:(Comp *)arg;


  //******************************************************************************
  // button actions
  //******************************************************************************
- (IBAction)datePickerClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)printButtonClicked:(id)sender;


  //******************************************************************************
  // handlers
  //******************************************************************************



  //******************************************************************************
  // misc
  //******************************************************************************


@end