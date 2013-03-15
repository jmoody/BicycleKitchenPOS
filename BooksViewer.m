//
//  BooksViewer.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "BooksViewer.h"
#import "Books.h"
#import "Book.h"

@implementation BooksViewer

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    previousLengthOfSearchString = 0;
    self =  [super initWithWindowNibName:@"BooksViewer"]; 
  }
  return self;
}

//dealloc
- (void) dealloc {
  [currentBook release];
  [bookViewer release];
  [booksArray release];
  [super dealloc];
}

// windowing
- (void)windowDidLoad {
  [super windowDidLoad];
}
- (void)setupForModal {
  [super setupForModal];
  [self setBooksArray:[[Books sharedInstance] arrayForDictionary]];
  //NSLog(@"booksArray: %@", booksArray);
  [booksTableView setTarget:self];
  [booksTableView setDoubleAction:@selector(handleBookClicked:)];
}

- (void)setupForNonModal {
  [super setupForNonModal];
  [self setBooksArray:[[Books sharedInstance] arrayForDictionary]];
  //NSLog(@"booksArray: %@", booksArray);
  [booksTableView setTarget:self];
  [booksTableView setDoubleAction:@selector(handleBookClicked:)];  
}


- (void)runModalWithParent:(NSWindow *) parent {
  [super runModalWithParent:parent];
}


//accessors and setters
- (Book *)currentBook {
  return currentBook;
}
- (void) setCurrentBook:(Book *)arg {
  [arg retain];
  [currentBook release];
  currentBook = arg;
}
- (int)previousLengthOfSearchString {
  return previousLengthOfSearchString;
}
- (void) setPreviousLengthOfSearchString:(int)arg {
  previousLengthOfSearchString = arg;
}
- (NSMutableArray *)booksArray {
  return booksArray;
}
- (void) setBooksArray:(NSArray *)arg {
  if (arg != booksArray) {
    [booksArray release];
    booksArray = [arg mutableCopy];
  }
}

- (void)handleBookClicked:(id)sender {
  if (bookViewer == nil) {
    BookViewer *bv = [[BookViewer alloc] init];
    [self setBookViewer:bv];
    [bv release];
  }
  Book *book = (Book *)[[booksArrayController selectedObjects] objectAtIndex:0];
  [bookViewer setCurrentBook:book];
  [bookViewer setupForNonModal];
  [[bookViewer window] makeKeyAndOrderFront:self];
}

// actions
- (IBAction)selectItemButtonClicked:(id)sender {
  ////NSLog(@"selectItemButton clicked");
}

- (IBAction)deleteBookButtonClicked:(id)sender {
 // //NSLog(@"deleteBookButton clicked");
  Book *book = (Book *)[[booksArrayController selectedObjects] objectAtIndex:0];
  [[Books sharedInstance] removeObjectForUid:[book uid]];
}

- (IBAction)viewCurrentBookButtonClicked:(id)sender {
 // //NSLog(@"viewCurrentBookButton clicked");
  
  
}


- (IBAction)closeWindowButtonClicked:(id)sender {
  ////NSLog(@"closeWindowButton clicked");
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}


- (void)handleSearchFieldChange:(NSNotification *)note {
  if ([[self window] isKeyWindow]) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *dateString, *closerString;
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setBooksArray:[[Books sharedInstance] arrayForDictionary]];
      previousLengthOfSearchString = 0;
      [booksTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfSearchString > [searchString length]) {
      [self setBooksArray:[[Books sharedInstance] arrayForDictionary]];
    }
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [booksArray objectEnumerator];
    while ( object = [e nextObject] ) {
      dateString = [[object date] descriptionWithCalendarFormat:@"%m/%d/%Y"];
      closerString = [[object closerNameOrInitials] lowercaseString];
      
      NSRange dateRange = [dateString rangeOfString:searchString options:NSLiteralSearch];
      NSRange closerRange = [closerString rangeOfString:searchString options:NSLiteralSearch];
            
      if (((dateRange.length) > 0) || ((closerRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setBooksArray:filteredObjects];
    [booksTableView reloadData];
    previousLengthOfSearchString = [searchString length];
  }
  
}

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(handleSearchFieldChange:)
             name:NSControlTextDidChangeNotification
           object:booksSearchField];

  [nc addObserver:self
         selector:@selector(handleBooksChange:)
             name:[[Books sharedInstance] notificationChangeString]
           object:nil];
}

- (void)handleBooksChange:(NSNotification *)note {
  [self setBooksArray:[[Books sharedInstance] arrayForDictionary]];
  [booksTableView reloadData];
}

- (BookViewer *)bookViewer {
  return bookViewer;
}
- (void) setBookViewer:(BookViewer *)arg {
  [arg retain];
  [bookViewer release];
  bookViewer = arg;
}


@end
