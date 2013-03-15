//
//  BooksViewer.h
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"
#import "Book.h"
#import "BookViewer.h"

@interface BooksViewer : BasicWindowController {

  BookViewer *bookViewer;
  
  //variables
  Book *currentBook;
  int previousLengthOfSearchString;
  NSMutableArray *booksArray;
 
  IBOutlet NSSearchField *booksSearchField;
  IBOutlet NSButton *selectItemButton;
  IBOutlet NSTableView *booksTableView;
  IBOutlet NSArrayController *booksArrayController;
  IBOutlet NSButton *deleteBookButton;
  IBOutlet NSButton *viewCurrentBookButton;
  IBOutlet NSButton *closeWindowButton;
  
}

- (BookViewer *)bookViewer;
- (void)setBookViewer:(BookViewer *)arg;


//proto-types
- (Book *)currentBook;
- (void)setCurrentBook:(Book *)arg;
- (int)previousLengthOfSearchString;
- (void)setPreviousLengthOfSearchString:(int)arg;
- (NSMutableArray *)booksArray;
- (void)setBooksArray:(NSArray *)arg;

// prototypes
- (IBAction)selectItemButtonClicked:(id)sender;
- (IBAction)deleteBookButtonClicked:(id)sender;
- (IBAction)viewCurrentBookButtonClicked:(id)sender;
- (IBAction)closeWindowButtonClicked:(id)sender;

  // handlers
- (void)handleSearchFieldChange:(NSNotification *)note;
- (void)handleBooksChange:(NSNotification *)note;
- (void)handleBookClicked:(id)sender;

@end
