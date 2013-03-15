//
//  AppController.m
//  AnotherApp
//
//  Created by moody on 6/17/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"
#import "ProductController.h"
#import "ProductManagerLoginController.h"
#import "CreateCustomerController.h"
//#import "PersonInfoController.h"
#import "MembershipInformation.h"
#import "Person.h"
#import "ProgressiveWindowController.h"
#import "CreateProjectController.h"
#import "CustomerContactController.h"
#import "ProductCategories.h"
#import "InvoiceController.h"
#import "FormPrinter.h"
#import "Invoices.h"
#import "Book.h"
#import "Books.h"
#import "BookArchiver.h"
#import "Memberships.h"
#import "Membership.h"
#import "Projects.h"
#import "Project.h"
#import "Credits.h"
#import "InKindDonation.h"
#import "InKindDonations.h"
#import "Comps.h"
#import "Checks.h"
#import "Comments.h"
#import "Contacts.h"
#import "DebitsAndCredits.h"
#import "Donations.h"
#import "Returns.h"

#import "MerchantOSExport.h"
#import "Lumberjack.h"

#ifdef LOG_CONFIGURATION_DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation AppController

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  //NSLog(@"applicationDidFinishLaunching");
  // One of the things we do is to read the last value recorded from userdefaults
  // and set that as the value of the textfield. We have a handle to the textfield
  // (myTextField) because it is set up as an outlet in InterfaceBuilder.
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  
  NSNumber *salesTaxNumber = [defaults objectForKey:TljBkPosSalesTaxRate];
  //NSLog(@"salesTax: %1.2f", [salesTaxNumber doubleValue]);
  if (salesTaxNumber == nil) {
    [defaults setObject:[NSNumber numberWithDouble:8.25] forKey:TljBkPosSalesTaxRate];
  }
                                                             
  NSNumber *startingBookAmountNumber = [defaults objectForKey:TljBkPosStartingBookAmount];
  //NSLog(@"startingBookAmount: %1.2f", [startingBookAmountNumber doubleValue]);
  if (startingBookAmountNumber == nil) {
    [defaults setObject:[NSNumber numberWithDouble:100.0] forKey:TljBkPosStartingBookAmount];
  }
  
  NSNumber *standTimeRateNumber = [defaults objectForKey:TljBkPosStandTimeRateKey];
  NSLog(@"standTimeRateNumber: %1.2f", [standTimeRateNumber doubleValue]);
  if (standTimeRateNumber == nil) {
    [defaults setObject:[NSNumber numberWithDouble:7.0] forKey:TljBkPosStandTimeRateKey];
  }
  
  NSNumber *pathToLatex = [defaults objectForKey:TljBkPosPathToLatexKey];
  if (pathToLatex == nil) {
    [defaults setObject:@"/opt/local/bin/pdflatex" forKey:TljBkPosPathToLatexKey];
  }
  
//  NSNumber *willAcceptCardsNumber = [defaults objectForKey:TljBkPosWillAcceptCreditCards];
//  NSLog(@"willAcceptCards: %d", [willAcceptCardsNumber boolValue]);
//  if (willAcceptCardsNumber == nil) {
//    [defaults setObject:[NSNumber numberWithBool:YES] forKey:TljBkPosWillAcceptCreditCards];
//  }
  NSData *cookAsData = [defaults objectForKey:TljBkPosCookMembershipInfo];
  if (cookAsData == nil) {
    MembershipInformation *cook;
    cook = [[MembershipInformation alloc] initWithMemberType:@"cook" cost:1.0 newPartsDiscount:40.0 workshopDiscount:100.0 duration:9125];
    cookAsData = [NSKeyedArchiver archivedDataWithRootObject:cook];
    [defaults setObject:cookAsData forKey:TljBkPosCookMembershipInfo];
    [cook release];
  }
  
  NSData *deluxeAsData = [defaults objectForKey:TljBkPosDeluxeMembershipInfo];
  if (deluxeAsData == nil) {
    MembershipInformation *deluxe;
    deluxe = [[MembershipInformation alloc] initWithMemberType:@"deluxe" cost:100.0 newPartsDiscount:10.0 workshopDiscount:30.0 duration:365];
    deluxeAsData = [NSKeyedArchiver archivedDataWithRootObject:deluxe];
    [defaults setObject:deluxeAsData forKey:TljBkPosDeluxeMembershipInfo];
    [deluxe release];
  }
  
  NSData *lifetimeAsData = [defaults objectForKey:TljBkPosLifetimeMembershipInfo];
  if (lifetimeAsData == nil) {
    MembershipInformation *lifetime;
    lifetime = [[MembershipInformation alloc] initWithMemberType:@"lifetime" cost:1.0 newPartsDiscount:15.0 workshopDiscount:30.0 duration:9125];
    lifetimeAsData = [NSKeyedArchiver archivedDataWithRootObject:lifetime];
    [defaults setObject:lifetimeAsData forKey:TljBkPosLifetimeMembershipInfo];
    [lifetime release];
  }
  
  NSData *regularAsData = [defaults objectForKey:TljBkPosRegularMembershipInfo];
  if (regularAsData == nil) {
    MembershipInformation *regular;
    regular = [[MembershipInformation alloc] initWithMemberType:@"regular" cost:70.0 newPartsDiscount:10.0 workshopDiscount:15.0 duration:365];
    regularAsData = [NSKeyedArchiver archivedDataWithRootObject:regular];
    [defaults setObject:regularAsData forKey:TljBkPosRegularMembershipInfo];
    [regular release];
  }

  //[NSUserDefaults resetStandardUserDefaults];
  // Now show the window... (By default we've set it in IB not to be visible at start)
  //[myWindow makeKeyAndOrderFront:nil];
}



//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
//  NSEnumerator *enumerator;
//  id value;
//  enumerator = [mainWindowToolbarItems objectEnumerator];
//  while ((value = [enumerator nextObject])) {
//    [value release];
//  }  
  [mainWindowToolbarItems release];

//  enumerator = [toolbarItemsForOpenJournal objectEnumerator];
//  while ((value = [enumerator nextObject])) {
//    [value release];
//  }  
  [toolbarItemsForOpenJournal release];
  
//  enumerator = [toolbarItemsForClosedJournal objectEnumerator];
//  while ((value = [enumerator nextObject])) {
//    [value release];
//  }  
  [toolbarItemsForClosedJournal release];
  
//  enumerator = [peopleInMainWindow objectEnumerator];
//  while ((value = [enumerator nextObject])) {
//    [value release];
//  }
  [peopleInMainWindow release];
  
//  enumerator = [productsInMainWindow objectEnumerator];
//  while ((value = [enumerator nextObject])) {
//    [value release];
//  }
  
  [clientInfoManager release];
  [inKindDonationManager release];
  [acceptInKindDonation release];  
  [returnManager release];  
  [handleReturn release];  
  [compManager release];
  [compAProduct release];
  [contactsManager release];
  [membershipManager release];
  [creditsManager release];
  [productsInMainWindow release];
  [currentBookViewer release];
  [booksViewer release];
  [openBookController release];
  [closeBookController release];
  [mainWindowToolbar release];
  [bugReportController release];
  [mainWindow release];
  [preferenceController release];
  [productController release];
  //[personInfoController release];
  [createProjectController release];
  [projectController release];
  //[modalProjectController release];
  //[projectInformationController release];
  [invoiceController release];
  [invoiceManager release];
  [createInvoice release];
  [acceptCashDonationManager release];
  [cashDonationManager release];
  [projectSelector release];
  [super dealloc];
}


//******************************************************************************

- (void)awakeFromNib {
//	NSArray *array = [[Products sharedInstance] arrayForDictionary];
//	unsigned int i, count = [array count];
//	for (i = 0; i < count; i++) {
//		Product *obj = [array objectAtIndex:i];
//		if (![obj taxable]) {
//			int qty = [obj productQuantity];
//			if (qty <= 0) {
//				[obj setProductQuantity:999999];
//			}
//		}
//	}
  
//	NSSortDescriptor *codeDescriptor = [[NSSortDescriptor alloc] initWithKey:@"productCode" 
//																																ascending:YES
//																																 selector:@selector(caseInsensitiveCompare:)];
//	NSArray *sorters = [NSArray arrayWithObject:codeDescriptor];
//	NSArray *array = [[Products sharedInstance] arrayForDictionary];
//  NSArray *products = [array sortedArrayUsingDescriptors:sorters];
//	NSMutableData *tmp = [[NSMutableData alloc] init];
//	unsigned int i, count = [products count];
//	for (i = 0; i < count; i++) {
//		Product *obj = [products objectAtIndex:i];
//		if ([obj taxable]) {
//			NSString *str = [NSString stringWithFormat:@"%@ ||      %d || %@ \n",
//				[obj productCode], [obj productQuantity], [obj productName]];
//			[tmp appendData:[str dataUsingEncoding:NSASCIIStringEncoding]]; 
//		}
//	}
//
//	NSFileManager *nsfm = [NSFileManager defaultManager];
//	[nsfm createFileAtPath:@"/Users/floor/tmp/products.txt" 
//								contents:tmp attributes:nil];
	
  // fix the broken book
//  NSArray *array = [[Books sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Book *b = [array objectAtIndex:i];
//    if ([[b uid] isEqualToString:@"2007022219055301"]) {
//      [b setCloserNameOrInitials:@"kris10 and brett"];
//      NSLog(@"b: %@", b);
//      NSString *tmp = [NSString stringWithFormat:@"/Library/Application Support/BicycleKitchenPOS/ArchivedBooks/2007/02/22/book-2007022219055301.pdf"];
//      [b setPathToPdfArchive:[tmp stringByStandardizingPath]];
//      [[BookArchiver sharedInstance] printFileAtPath:[b pathToPdfArchive]];
//    }
//  }

// fix the broken book
//  NSArray *array = [[Books sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  unsigned int numClients = 0;
//  unsigned int numVols = 0;
//  unsigned int numProj = 0;
//  double numFree = 0.0;
//  double numSold = 0.0;
//  double compTotal = 0.0;
//  double taxable = 0.0;
//  double untaxable = 0.0;
//  int numInvoices = 0;
//  
//  for (i = 0; i < count; i++) {
//    Book *b = [array objectAtIndex:i];
//    numClients = numClients + [b numberOfClients];
//    numVols = numVols + [b volunteerHoursTotal];
//    numProj = numProj + [b projectsCompletedTotal];
//    numFree = numFree + [b freeStandTime];
//    numSold = numSold + [b soldStandTime];
//    taxable = taxable + [b taxableTotal];
//    compTotal = compTotal + [b totalValueOfComps];
//    untaxable = untaxable + [b untaxableTotal];
//    numInvoices = numInvoices + [[b invoiceUids] count];
//    }
//  NSLog(@"clients: %d, volunteers: %d, projects: %d", numClients, numVols, numProj);
//  NSLog(@"free: %1.2f sold: %1.2f comp:%1.2f tax:%1.2f untax:%1.2f numInvoices: %d", 
//        numFree, numSold, compTotal, taxable, untaxable, numInvoices);
//  
//  NSData *data = [[Books sharedInstance] toData];
//  NSFileManager *fm = [NSFileManager defaultManager];
//  [fm createFileAtPath:@"/Users/moody/Desktop/books.csv" contents:data attributes:nil];

//  NSData *data = [[Projects sharedInstance] toData];
//  NSFileManager *fm = [NSFileManager defaultManager];
//  [fm createFileAtPath:@"/Users/moody/Desktop/projects.csv" contents:data attributes:nil];  
  

//  NSArray *singletons = [NSArray arrayWithObjects:[Books sharedInstance], [Checks sharedInstance],
//    [Comps sharedInstance], [Contacts sharedInstance],
//    [Credits sharedInstance], [DebitsAndCredits sharedInstance], [Donations sharedInstance],
//    [Invoices sharedInstance],[InKindDonations sharedInstance], [Memberships sharedInstance],
//    [People sharedInstance], [Products sharedInstance], [ProductCategories sharedInstance],
//    [Projects sharedInstance], [Returns sharedInstance], nil];
//  

//  NSArray *singletons = [NSArray arrayWithObject:[Comments sharedInstance]];
//
//  NSEnumerator *enumer = [singletons objectEnumerator];
//  id singleton;
//  while (singleton = [enumer nextObject]) {
//    NSData *data = [singleton toData];
//    NSFileManager *fm = [NSFileManager defaultManager];
//    NSString *path = [NSString stringWithFormat:@"/Library/Application Support/BicycleKitchenPOS/pos-csv/%@.csv", [[singleton class] className]];
//    //NSString *path = [NSString stringWithFormat:@"/Users/moody/Desktop/%@.csv", [[singleton class] className]];
//    //NSLog(@"path = %@", path);
//    [fm createFileAtPath:path contents:data attributes:nil];  
//  }
  
//  NSArray *projects = [[Projects sharedInstance] arrayForDictionary];
//  NSEnumerator *enumer = [projects objectEnumerator];
//  NSString *str = @"";
//  Project *p;
//  while (p = [enumer nextObject]) {
//    Bicycle *b = [p bicycle];
//    NSString *csv = [b toCsv];
//    NSString *csvNewline = [csv stringByAppendingString:@"\n"];
//    str = [str stringByAppendingString:csvNewline];
//  }
//  
//  NSData *data = [str dataUsingEncoding:NSASCIIStringEncoding];
//  NSFileManager *fm = [NSFileManager defaultManager];
//  NSString *path = @"/Users/moody/Desktop/Bicycle.csv";
//  [fm createFileAtPath:path contents:data attributes:nil];  
  
  
  
  
  // fix the bug where invoices for new projects are not added to the person,
  // not assigned to a person, and the invoice total is incorrect
//  NSArray *array = [[Projects sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Project *proj = [array objectAtIndex:i];
//    NSString *invUid = [proj invoiceUid];
//    Person *per = [[People sharedInstance] objectForUid:[proj ownerUid]];
//    Invoice *projInvoice = [proj invoice];
//    [projInvoice setPersonUid:[per uid]];
//    NSArray *tmp2 = [projInvoice items];
//    unsigned int k, count1 = [tmp2 count];
//    double sum = 0.0;
//    for (k = 0; k < count1; k++) {
//      Product *invProduct  = [tmp2 objectAtIndex:k];
//      sum = sum + [invProduct productTotal];
//    }
//    [projInvoice setInvoiceTotal:sum];
//    
//    NSArray *personInvoiceUids = [per invoiceUids];
//    bool found = NO;
//    unsigned int j, count2 = [personInvoiceUids count];
//    for (j = 0; j < count2; j++) {
//      NSString *aUid = [personInvoiceUids objectAtIndex:j];
//      if ([aUid isEqualToString:invUid]) {
//        found = YES;
//      }
//    }
//    if (!found) {
//      [[per invoiceUids] addObject:invUid];
//    }
//  }
//  [[Invoices sharedInstance] saveToDisk];
//  [[People sharedInstance] saveToDisk];
  
  // fix the bug where project product uids did not match the project uid
  // making it impossible to close a project
//  NSArray *array = [[Projects sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Project *proj = [array objectAtIndex:i];
//    NSString *projUid = [proj uid];
//    Invoice *inv = [proj invoice];
//    NSArray *items = [inv items];
//    unsigned int j, count1 = [items count];
//    for (j = 0; j < count1; j++) {
//      Product *prod = [items objectAtIndex:j];
//      if ([[prod productCode] isEqualToString:@"project"]) {
//        [prod setUid:projUid];
//      }
//    }
//  }

  // comps refactor - remove all the Comps
//  [[Comps sharedInstance] setDictionary:[[NSMutableDictionary alloc] init]];
//  [[Comps sharedInstance] saveToDisk];
//  // add compUids to person
//  NSArray *array = [[People sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Person *p = [array objectAtIndex:i];
//    [p setCompUids:[[NSArray alloc] init]];
//  }
//  [[People sharedInstance] saveToDisk];
//  
//  // add new slots to Books
//  NSArray *array = [[Books sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Book *b = [array objectAtIndex:i];
//    [b setFreeStandTime:0.0];
//    [b setSoldStandTime:[b standTimeTotal]];
//    [b setCompUids:[[NSArray alloc] init]];
//    [b setTotalValueOfComps:0.0];
//  }
//  [[Books sharedInstance] saveToDisk];
  
  
//  NSArray *array = [[Projects sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Project *proj = [array objectAtIndex:i];
//    NSLog(@"project startDate: %@", [proj startDate]);
//    NSLog(@"project finishDate: %@", [proj finishedDate]);
//  }
  
  // rests the counts
//  NSArray *products = [[Products sharedInstance] arrayForDictionary];
//  unsigned int i, count = [products count];
//  for (i = 0; i < count; i++) {
//    Product *p = [products objectAtIndex:i];
//    NSString *description = [p productName];
//    NSRange nameRange = [description rangeOfString:@"used" options:NSLiteralSearch];
//    if (nameRange.length > 0) {
//      [p setProductQuantity:999999];
//    } else {
//      [p setProductQuantity:0];
//    }
//  }
  
    
//	NSArray *ikd = [[InKindDonations sharedInstance] arrayForDictionary];
//	unsigned int i, count = [ikd count];
//	for (i = 0; i < count; i++) {
//		InKindDonation *don = [ikd objectAtIndex:i];
//		NSLog(@"path: %@", [don pathToPdfArchive]);
//	}
	
  // clearing credits
//  [[Credits sharedInstance] setDictionary:[[NSMutableDictionary alloc] init]];  
//  NSArray *array  = [[People sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Person *obj = (Person *)[array objectAtIndex:i];
//    NSLog(@"person %@ %@", [obj personName], [obj creditUids]);
//    [[obj creditUids] removeAllObjects];
//    NSLog(@"person %@ %@", [obj personName], [obj creditUids]);
//  }

//  NSArray *array  = [[People sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Person *obj = (Person *)[array objectAtIndex:i];
//    NSLog(@"person %@ membership: %@", [obj personName], [obj membership]);
//    
//  }
  
  
	
//  NSUserDefaults *defaults;
//  defaults = [NSUserDefaults standardUserDefaults];
//  NSLog(@"salesTax: %f", [[defaults objectForKey:TljBkPosSalesTaxRate] doubleValue]);
  
//  // clearing the invoices
//  NSArray *array  = [[People sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Person *obj = (Person *)[array objectAtIndex:i];
//    NSMutableArray *invoiceUids = [obj invoiceUids];
//    NSLog(@"%@ invoiceUids count: %d", [obj personName], [invoiceUids count]);
//    NSLog(@"invoiceUids: %@", invoiceUids);
//    NSArray *new = [[NSArray alloc] init];
//    [obj setInvoiceUids:new];
//    [[People sharedInstance] saveToDisk];
//  }
//  [[Books sharedInstance] setDictionary:[[NSMutableDictionary alloc] init]];
//  
//  array = [[Memberships sharedInstance] arrayForDictionary];
//  count = [array count];
//  for (i = 0; i < count; i++) {
//    Membership *mem = (Membership *)[array objectAtIndex:i];
//    [mem setInvoiceUid:@""];
//  }
//  [[Memberships sharedInstance] saveToDisk];
//  
//  array = [[Projects sharedInstance] arrayForDictionary];
//  count = [array count];
//  for (i = 0; i < count; i++) {
//    Project *proj = (Project *)[array objectAtIndex:i];
//    [proj setInvoiceUid:@""];
//  }
//  [[Projects sharedInstance] saveToDisk];
//  
//  
//  [[Invoices sharedInstance] setDictionary:[[NSMutableDictionary alloc] init]];
//  [[Invoices sharedInstance] saveToDisk];
  
//  NSArray *array = [[Projects sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Project *proj = (Project *)[array objectAtIndex:i];
//    Invoice *inv = [[Invoices sharedInstance] objectForUid:[proj invoiceUid]];
//		unsigned int j, foo = [[inv items] count];
//		for (j = 0; j < foo; j++) {
//			Product *prod = [[inv items] objectAtIndex:j];
//			if ([[prod productCode] isEqualToString:@"project"]) {
//				NSLog(@"prod: %@", prod);
//				[prod setTaxable:NO];
//		  }
//		}
//	}	
	
  
  // creating project invoices
//  NSArray *array = [[Projects sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Project *proj = (Project *)[array objectAtIndex:i];
//    Invoice *inv =  [[Invoice alloc] init];
//    [inv setItems:[[NSArray alloc] init]];
//    Person *p = [[People sharedInstance] objectForUid:[proj ownerUid]];
//    
//    [inv setPersonUid:[p uid]];
//    [p setInvoiceUids:[[NSArray alloc] init]];
//    [[p invoiceUids] addObject:[inv uid]];
//    [[People sharedInstance] saveToDisk];
//    
//    [proj setInvoiceUid:[inv uid]];
//    Product *prod = [[Product alloc] init];
//    [prod setProductCode:@"project"];
//    [prod setProductName:[proj bicycleDescription]];
//    [prod setProductPrice:[proj quote]];
//    [prod setProductTotal:[proj quote]];
//    [[Projects sharedInstance] saveToDisk];
//    
//    [inv setInvoiceTotal:[proj quote]];
//    
//    [[inv items] addObject:prod];
//    [[Invoices sharedInstance] setObject:inv forUid:[inv uid]];
//
//  }
//
//  [[Invoices sharedInstance] saveToDisk];
  
// deleting a person  
//  NSArray *array = [[People sharedInstance] arrayForDictionary];
//  unsigned int i, count = [array count];
//  for (i = 0; i < count; i++) {
//    Person *p = (Person *)[array objectAtIndex:i];
//    if ([[p personName] isEqualToString:@"some guy"]) {
//      NSString *aUid = [p uid];
//      [[People sharedInstance] removeObjectForUid:aUid];
//    }
//  }

  
//  MerchantOSExport *exporter = [[MerchantOSExport alloc] init];
//  [exporter doCustomerExport:pathToCustomerCsvDelimited delimiter:@"," error:nil];

  NSArray *bookArray = [[Books sharedInstance] arrayForDictionary];
  DDLogVerbose(@"number of books = %d", [bookArray count]);
  int invoicesInBooks = 0;
  for (Book *aBook in bookArray) {
    NSArray *invoiceUids = [aBook invoiceUids];
    invoicesInBooks = invoicesInBooks + [invoiceUids count];
  }
  
  NSArray *invoiceArray = [[Invoices sharedInstance] arrayForDictionary];
  DDLogVerbose(@"number of invoices = %d", [invoiceArray count]);
  
  DDLogVerbose(@"number of invoices in books = %d :: the difference is %d", invoicesInBooks, [invoiceArray count] - invoicesInBooks);
  
  
  NSArray *projectArray = [[Projects sharedInstance] arrayForDictionary];
  DDLogVerbose(@"number of projects = %d", [projectArray count]);
  
  [self setupNotificationObservers];

  [self setupToolbar];
  [self setJournalIsOpen:NO];
  [self setProductsInMainWindow:[[Products sharedInstance] arrayForDictionary]];
  ////NSLog(@"people array %@",[[People sharedInstance] arrayForDictionary]);
  [self setPeopleInMainWindow:[[People sharedInstance] arrayForDictionary]];
  
  //opening customer info panel
  [peopleTableView setTarget:self];
  //[peopleTableView setDoubleAction:@selector(showCustomerInfoPanel:)];
  [peopleTableView setDoubleAction:@selector(showClientInfo:)];
  
  // disable the minizing and close features
  NSButton *closeButton = [[self mainWindow] standardWindowButton:NSWindowCloseButton];
  [closeButton setEnabled:NO];
  NSButton *minimizeButton = [[self mainWindow] standardWindowButton:NSWindowMiniaturizeButton];
  [minimizeButton setEnabled:NO];
  
  // check for an open book
  Book *cb = [[Books sharedInstance] currentBook];
  double stand = 0.0;
  int client = 0;
  if (cb != nil) {
    //NSLog(@"open journal");
    [self setJournalIsOpen:YES];
    [mainWindowToolbar removeItemAtIndex:5];
    [mainWindowToolbar insertItemWithItemIdentifier:@"closeJournal" atIndex:5];
    stand = [cb freeStandTime];
    client = [cb numberOfClients];
  } else {
    [self setJournalIsOpen:NO];
    [mainWindowToolbar removeItemAtIndex:5];
    [mainWindowToolbar insertItemWithItemIdentifier:@"openJournal" atIndex:5];
  }
  [clientStepper setIntValue:client];
  [clientTextField setIntValue:client];
  [standTimeStepper setDoubleValue:stand];
  [standTextField setDoubleValue:stand];
  
}

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];

  // handling product inserts and deletes to keep tables in synch
  [nc addObserver:self 
         selector:@selector(handleProductsChange:)
             name:[[Products sharedInstance] notificationChangeString]
           object:nil];
  
  
  // handling person inserts and deletes to keep tables in synch
  [nc addObserver:self 
         selector:@selector(handlePeopleChange:)
             name:[[People sharedInstance] notificationChangeString]
           object:nil];
  
  // for searching products
  [nc addObserver:self
         selector:@selector(handleProductSearchFieldDidChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productsSearchField];
  
  // for searching projects
  [nc addObserver:self
         selector:@selector(handlePeopleSearchFieldDidChange:)
             name:@"NSControlTextDidChangeNotification"
           object:peopleSearchField];
  
  // for handling journal close messages
  [nc addObserver:self
         selector:@selector(handleJournalClosed:)
             name:@"TljJournalClosedNotification"
           object:nil];
}

- (void)handleProductsChange:(NSNotification *)note {
  if ([note object] != self) {
    [self setProductsInMainWindow:[[Products sharedInstance] arrayForDictionary]];
    [productsTableView reloadData];
  }
}


- (BOOL)windowShouldClose:(id)sender {
  ////NSLog(@"in window should close");
  return NO;
}


//******************************************************************************
// showing windows
//******************************************************************************

- (IBAction)showMainApplicationWindow:(id)sender {
  [mainWindow makeKeyAndOrderFront:self];
}

- (void)setPreferenceController:(PreferenceController *)pc {
  if (preferenceController != pc) {
    [preferenceController release];
    [pc retain];
    preferenceController = pc;
  }
}

- (IBAction)showPreferencePanel:(id)sender {
  if (!preferenceController) {
    PreferenceController *tmp = [[PreferenceController alloc] init];
    [self setPreferenceController:tmp];
    [tmp release];
  }
  //[preferenceController setupForNonModal];
  [preferenceController runNonModal:self];
  [preferenceController setupForNonModal];
}

//******************************************************************************

- (void)setProductManagerLoginController:(ProductManagerLoginController *)pmlc {
  if (productManagerLoginController != pmlc) {
    [pmlc retain];
    [productManagerLoginController release];
    productManagerLoginController = pmlc;
  }
}

- (IBAction)showProductManager:(id)sender {
  if (!productManagerLoginController) {
    ProductManagerLoginController *tmp = [[ProductManagerLoginController alloc] init];
    [self setProductManagerLoginController:tmp];
    [tmp release];
  }
  [productManagerLoginController setMainApplicationWindow:mainWindow];
  [productManagerLoginController runProductManagerLoginModal];
}

//******************************************************************************

- (void)setProjectController:(ProjectController *)pc {
  if (projectController != pc) {
    [pc retain];
    [projectController release];
    projectController = pc;
  }
}

- (IBAction)showProjectManager:(id)sender {
  if (!projectController) {
    ProjectController *pc = [[ProjectController alloc] init];
    [self setProjectController:pc];
    [pc release];
  }
  [projectController setupForNonModal];
  [projectController setupButtonsForManager];
  [projectController showWindow:self];
}

//******************************************************************************

- (void)setInvoiceManager:(InvoiceManager *)im {
  if (invoiceManager != im) {
    [im retain];
    [invoiceManager release];
    invoiceManager = im;
  }
}

- (IBAction)showInvoiceManager:(id)sender {
  ////NSLog(@"show invoice manager");
  if (invoiceManager == nil) {
    InvoiceManager *im = [[InvoiceManager alloc] init];
    [self setInvoiceManager:im];
    [im release];
  }
  [invoiceManager setupForNonModal];
  [invoiceManager showWindow:self];
  [[invoiceManager window] makeKeyAndOrderFront:self];
}

//******************************************************************************

- (void)setPeopleManagerLoginController:(PeopleManagerLoginController *)pmlc {
  if (peopleManagerLoginController != pmlc) {
    [pmlc retain];
    [peopleManagerLoginController release];
    peopleManagerLoginController = pmlc;
  }
}

- (IBAction)showCustomerManager:(id)sender {
  if (!peopleManagerLoginController) {
    PeopleManagerLoginController *tmp = [[PeopleManagerLoginController alloc] init];
    [self setPeopleManagerLoginController:tmp];
    [tmp release];
    [peopleManagerLoginController setMainApplicationWindow:mainWindow];
  }
  [peopleManagerLoginController runPeopleManagerLoginModal];
}

//******************************************************************************

- (IBAction)showCustomerInfoPanel:(id)sender {
//  if (!personInfoController) {
//    personInfoController = [[PersonInfoController alloc] init];
//  }
//  
//  Person *selectedPerson = [[peopleArrayController selectedObjects] objectAtIndex:0];
//  ////NSLog(@"selectedPerson: %@", selectedPerson);
//  [personInfoController setMainApplicationWindow:mainWindow];
//  [personInfoController setPeopleController:peopleArrayController];
//  [personInfoController setCurrentlyViewedPerson:selectedPerson];
//  [personInfoController setupForModal];
//  [personInfoController runModalWithParent:mainWindow];
  
}

//******************************************************************************

- (IBAction)showClientInfo:(id)sender {
  NSArray *selected = [peopleArrayController selectedObjects];
  if ([selected count] > 0) {
    Person *select = (Person *)[selected objectAtIndex:0];
    if (select != nil) {
      if (clientInfoManager == nil) {
        ClientInfoManager *tmp = [[ClientInfoManager alloc] init];
        [self setClientInfoManager:tmp];
        [tmp release];
      }
      [clientInfoManager setPerson:select];
      [clientInfoManager setupForModal];
      [clientInfoManager runModalWithParent:mainWindow];
      [peopleSearchField setStringValue:@""];
      [self setPeopleInMainWindow:[[People sharedInstance] arrayForDictionary]];
      [peopleTableView reloadData];
      
    }
  }
}

//******************************************************************************

- (IBAction)showContactsManager:(id)sender {
  if (contactsManager == nil) {
    CustomerContactController *tmp = [[CustomerContactController alloc] init];
    [self setContactsManager:tmp];
    [tmp release];
  }
  [contactsManager setupForNonModal];
  [[contactsManager window] makeKeyAndOrderFront:self];
}  

//******************************************************************************
// searching
//******************************************************************************

- (void)handleProductSearchFieldDidChange:(NSNotification *)note {
  if ([mainWindow isKeyWindow]) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *productCodeString;
    NSString *productNameString;
    NSString *categoryString;
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setProductsInMainWindow:[[Products sharedInstance] arrayForDictionary]];
      previousLengthOfProductSearchString = 0;
      [productsTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfProductSearchString > [searchString length]) {
      [self setProductsInMainWindow:[[Products sharedInstance] arrayForDictionary]];
    }
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [productsInMainWindow objectEnumerator];
    while ( object = [e nextObject] ) {
      productCodeString = [[object productCode] lowercaseString];
      productNameString = [[object productName] lowercaseString];
      categoryString = [[object productCategory] lowercaseString];
      
      NSRange codeRange = [productCodeString rangeOfString:searchString options:NSLiteralSearch];
      NSRange nameRange = [productNameString rangeOfString:searchString options:NSLiteralSearch];
      NSRange categoryRange = [categoryString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((codeRange.length) > 0) || ((nameRange.length) > 0) || ((categoryRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setProductsInMainWindow:filteredObjects];
    [productsTableView reloadData];
    previousLengthOfProductSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************

- (void)handlePeopleSearchFieldDidChange:(NSNotification *)note {
  if ([mainWindow isKeyWindow]) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *nameString, *emailString, *phoneString, *membershipString;
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setPeopleInMainWindow:[[People sharedInstance] arrayForDictionary]];
      previousLengthOfPeopleSearchString = 0;
      [peopleTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfPeopleSearchString > [searchString length]) {
      [self setPeopleInMainWindow:[[People sharedInstance] arrayForDictionary]];
    }
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [peopleInMainWindow objectEnumerator];
    while ( object = [e nextObject] ) {
      nameString = [[object personName] lowercaseString];
      emailString = [[object emailAddress] lowercaseString];
      phoneString = [[object phoneNumber] lowercaseString];
      membershipString = [[object memberType] lowercaseString];
      
      NSRange nameRange = [nameString rangeOfString:searchString options:NSLiteralSearch];
      NSRange emailRange = [emailString rangeOfString:searchString options:NSLiteralSearch];
      NSRange phoneRange = [phoneString rangeOfString:searchString options:NSLiteralSearch];
      NSRange membershipRange = [membershipString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((emailRange.length) > 0) || ((nameRange.length) > 0) || 
          ((phoneRange.length) > 0) || ((membershipRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setPeopleInMainWindow:filteredObjects];
    [peopleTableView reloadData];
    previousLengthOfPeopleSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************
// setting up the product table
//******************************************************************************

- (NSMutableArray *)productsInMainWindow {
  return productsInMainWindow;
}

//******************************************************************************

- (void)setProductsInMainWindow:(NSArray *)array {
  if (productsInMainWindow != array) {
    [productsInMainWindow release];
    productsInMainWindow = [array mutableCopy];
  }
}

//******************************************************************************
// setting up the people
//******************************************************************************

- (NSMutableArray *)peopleInMainWindow {
  return peopleInMainWindow;
}

//******************************************************************************

- (void)setPeopleInMainWindow:(NSArray *)array {
  if (peopleInMainWindow != array) {
    [peopleInMainWindow release];
    peopleInMainWindow = [array mutableCopy];
  }  
}

//******************************************************************************

- (void)handlePeopleChange:(NSNotification *)note {
  //NSLog(@"handlePeopleChange:");
  [self setPeopleInMainWindow:[[People sharedInstance] arrayForDictionary]];
  [peopleTableView reloadData];
}

//******************************************************************************
// insert/remove person
//******************************************************************************

- (void)insertObject:(Person *)p inPeopleInMainWindowAtIndex:(int)index {
  NSUndoManager *undo = [mainWindow undoManager];
  [[undo prepareWithInvocationTarget:self]
    removeObjectFromPeopleInMainWindowAtIndex:index];
  if (![undo isUndoing]) {
    [undo setActionName:@"Add Person"];
  }
  
  //[peopleInMainWindow insertObject:p atIndex:index];
  [[People sharedInstance] setObject:p forUid:[p uid]];
//  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//  [nc postNotificationName:[[People sharedInstance] notificationChangeString] object:self];  
}

//******************************************************************************

- (void)removeObjectFromPeopleInMainWindowAtIndex:(int) index {
  Person *p = [peopleInMainWindow objectAtIndex:index];
  
  NSUndoManager *undo = [mainWindow undoManager];
  [[undo prepareWithInvocationTarget:self] insertObject:p
                            inPeopleInMainWindowAtIndex:index];
  
  if (![undo isUndoing]) {
    [undo setActionName:@"Delete Person"];
  }
  
//  [peopleInMainWindow removeObjectAtIndex:index];
  [[People sharedInstance] removeObjectForUid:[p uid]];
//  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//  [nc postNotificationName:[[People sharedInstance] notificationChangeString] object:self];
}


- (IBAction)standTimeStepperClicked:(id)sender {
  //NSLog(@"standTimeStepper clicked");
  if (journalIsOpen) {
    Book *cb = [[Books sharedInstance] currentBook];
    double newVal = [standTimeStepper doubleValue];
    [cb setFreeStandTime:newVal];
    [standTextField setDoubleValue:newVal];
    [[Books sharedInstance] saveToDisk];
  } else {
    NSRunAlertPanel(@"Operation Not Permitted",
                    @"There is no Book open.",
                    @"Continue", nil, nil);
  }
}
- (IBAction)clientStepperClicked:(id)sender {
  //NSLog(@"clientStepper clicked");
  if (journalIsOpen) {
    Book *cb = [[Books sharedInstance] currentBook];
    double newVal = [clientStepper intValue];
    [cb setNumberOfClients:newVal];
    [clientTextField setIntValue:newVal];
    [[Books sharedInstance] saveToDisk];
  } else {
    NSRunAlertPanel(@"Operation Not Permitted",
                    @"There is no Book open.",
                    @"Continue", nil, nil);
  }  
}



- (IBAction)printInKindDonationForm:(id)sender {
  [[FormPrinter sharedInstance] printFormWithName:TljBkPosInKindDonationFromName];
}

- (IBAction)printLiabilityForm:(id)sender {
  [[FormPrinter sharedInstance] printFormWithName:TljBkPosLiabilityWaiverFormName];
}


- (BooksViewer *)booksViewer {
  return booksViewer;
}

- (void) setBooksViewer:(BooksViewer *)arg {
  [arg retain];
  [booksViewer release];
  booksViewer = arg;
}



//******************************************************************************
// toolbar stuff
//******************************************************************************

- (void)addCustomerClicked:(NSToolbarItem *)item {
  [self runCreateCustomer];
}

- (void)setCreateCustomerController:(CreateCustomerController *)ccc {
  if (createCustomerController != ccc) {
    [ccc retain];
    [createCustomerController release];
    createCustomerController = ccc;
  }
}

- (void)runCreateCustomer {
  if (!createCustomerController) {
    CreateCustomerController *tmp = [[CreateCustomerController alloc] init];
    [self setCreateCustomerController:tmp];
    [tmp release];
    [createCustomerController setMainWindow:mainWindow];
    [createCustomerController setPeopleArrayController:peopleArrayController];
  }
  [createCustomerController setBypassDuplicatePerson:NO];
  [createCustomerController runCreateCustomerModal];  
}

//******************************************************************************

- (void)setCreateProjectController:(CreateProjectController *)cpc {
  if (createProjectController != cpc) {
    [cpc retain];
    [createProjectController release];
    createProjectController = cpc;
  }
}

- (void)createProjectClicked:(NSToolbarItem *)item {
  ////NSLog(@"createProjectClicked");
  if (!createProjectController) {
    CreateProjectController *tmp = [[CreateProjectController alloc] init];
    [self setCreateProjectController:tmp];
    [tmp release];
  }
  [createProjectController setSelectedClient:nil];
  //[createProjectController showWindow:self];
  [createProjectController setRunningModal:YES];
  [createProjectController setupWindow];
  [createProjectController setMainApplicationWindow:mainWindow];
  [createProjectController runCreateProjectModal];
}

//******************************************************************************

- (void)updateProjectClicked:(NSToolbarItem *)item {
  if (projectSelector == nil) {
    ProjectSelector *tmp = [[ProjectSelector alloc] init];
    [self setProjectSelector:tmp];
    [tmp release];
  }
  [projectSelector setupForModal];
  [projectSelector runModalWithParent:mainWindow];

  //  [modalProjectController setupForModal];
  //  [modalProjectController setupButtonsForUpdateProject];
  //  [modalProjectController runModalWithParent:mainWindow];
}

//******************************************************************************

- (void)openJournalClicked:(NSToolbarItem *)item {
  ////NSLog(@"openJournalClicked");
  if (openBookController == nil) {
    OpenBookController *con = [[OpenBookController alloc] init];
    [self setOpenBookController:con];
    [con release];
  }
  [openBookController setupForModal];
  [openBookController runModalWithParent:mainWindow];
  
  if ([[Books sharedInstance] currentBook] != nil) {
    ////NSLog(@"open journal");
    [self setJournalIsOpen:YES];
    [mainWindowToolbar removeItemAtIndex:5];
    [mainWindowToolbar insertItemWithItemIdentifier:@"closeJournal" atIndex:5];
  } else {
    [self setJournalIsOpen:NO];
    [mainWindowToolbar removeItemAtIndex:5];
    [mainWindowToolbar insertItemWithItemIdentifier:@"openJournal" atIndex:5];
  }
}

//******************************************************************************

- (void)closeJournalClicked:(NSToolbarItem *)item {
  ////NSLog(@"closeJournalClicked");
  if (closeBookController == nil) {
    CloseBookController *con = [[CloseBookController alloc] init];
    [self setCloseBookController:con];
    [con release];
  }
  [closeBookController setupForNonModal];
  [[closeBookController window] makeKeyAndOrderFront:self];
  //[closeBookController setupForModal];
  //[closeBookController runModalWithParent:mainWindow];
  //if ([[Books sharedInstance] currentBook] == nil) {
  //[self setJournalIsOpen:NO];
  //[mainWindowToolbar removeItemAtIndex:5];
  //[mainWindowToolbar insertItemWithItemIdentifier:@"openJournal" atIndex:5];  
  //}
}

- (void)handleJournalClosed:(NSNotification *) note {
  [self setJournalIsOpen:NO];
  [mainWindowToolbar removeItemAtIndex:5];
  [mainWindowToolbar insertItemWithItemIdentifier:@"openJournal" atIndex:5];
  [standTimeStepper setDoubleValue:0.0];
  [standTextField setDoubleValue:0.0];
  [clientStepper setIntValue:0];
  [clientTextField setIntValue:0];
}


//******************************************************************************

- (IBAction)showCurrentBook:(id)sender {
  ////NSLog(@"showCurrentBook clicked");
  if (currentBookViewer == nil) {
    BookViewer *bv = [[BookViewer alloc] init];
    [self setCurrentBookViewer:bv];
    [bv release];
  }
  [currentBookViewer setCurrentBook:[[Books sharedInstance] currentBook]];
  [currentBookViewer setupForNonModal];
  [[currentBookViewer window] makeKeyAndOrderFront:self];
}

//******************************************************************************

- (IBAction)showBooksViewerWindow:(id)sender {
  ////NSLog(@"show books clicked");
  if (booksViewer == nil) {
    BooksViewer *bv = [[BooksViewer alloc] init];
    [self setBooksViewer:bv];
    [bv release];
  }
  [booksViewer setupForNonModal];
  [[booksViewer window] makeKeyAndOrderFront:self];
}

//******************************************************************************

- (IBAction)showCreditsManager:(id)sender {
  ////NSLog(@"show credits manager");
  if (creditsManager == nil) {
    CreditManager *cm = [[CreditManager alloc] init];
    [self setCreditsManager:cm];
    [cm release];
  }
  [creditsManager setupForNonModal];
  [[creditsManager window] makeKeyAndOrderFront:self];
}

-(IBAction)showMembershipManager:(id)sender {
  if (membershipManager == nil) {
    MembershipManager *tmp = [[MembershipManager alloc] init];
    [self setMembershipManager:tmp];
    [tmp release];
  }
  [membershipManager setupForModal];
  [[membershipManager window] makeKeyAndOrderFront:self];
}

- (IBAction)showCompAProduct:(id)sender {
  if (compAProduct == nil) {
    CreateAComp *tmp = [[CreateAComp alloc] init];
    [self setCompAProduct:tmp];
    [tmp release];
  }
  [compAProduct setupForNonModal];
  [compAProduct runNonModal:self];
  [compAProduct showPersonSelector];
  
}

//******************************************************************************

- (IBAction)showCompManager:(id)sender {
  if (compManager == nil) {
    CompManager *tmp = [[CompManager alloc] init];
    [self setCompManager:tmp];
    [tmp release];
  }
  [compManager setupForNonModal];
  [[compManager window] makeKeyAndOrderFront:self];
}

//******************************************************************************

- (IBAction)showReturnHandler:(id)sender {
  if (handleReturn == nil) {
    ReturnHandler *tmp = [[ReturnHandler alloc] init];
    [self setHandleReturn:tmp];
    [tmp release];
  }
  [handleReturn setupForModal];
  [handleReturn runModalWithParent:[self mainWindow]];
}

//******************************************************************************

- (IBAction)showReturnManager:(id)sender {
  if (returnManager == nil) {
    ReturnManager *tmp = [[ReturnManager alloc] init];
    [self setReturnManager:tmp];
    [tmp release];
  }
  [returnManager setupForNonModal];
  [[returnManager window] makeKeyAndOrderFront:self];
}

//******************************************************************************

- (IBAction)showAcceptInKindDonation:(id)sender {
  if (acceptInKindDonation == nil) {
    AcceptInKindDonation *tmp = [[AcceptInKindDonation alloc] init];
    [self setAcceptInKindDonation:tmp];
    [tmp release];
  }
  [acceptInKindDonation setupForNonModal];
  [acceptInKindDonation runMonetaryWarning];
  [acceptInKindDonation showWindow:self];
  [acceptInKindDonation showPersonSelector:self];
}

//******************************************************************************

- (IBAction)showInKindDonationManager:(id)sender {
  if (inKindDonationManager == nil) {
    InKindDonationManager *tmp = [[InKindDonationManager alloc] init];
    [self setInKindDonationManager:tmp];
    [tmp release];
  }
  [inKindDonationManager setupForNonModal];
  [inKindDonationManager runNonModal:self];
}

//******************************************************************************


- (IBAction)showAcceptCashDonationCreator:(id)sender {
  // Fuck this shit, make 'em use the invoice controller
  //  if (acceptCashDonationManager == nil) {
  //    AcceptCashDonation *tmp = [[AcceptCashDonation alloc] init];
  //    [self setAcceptCashDonationManager:tmp];
  //  }
  NSRunAlertPanel(@"Alert!",
                  @"To accept a donation by cash, check, or card create an invoice and sell the client a donation.",
                  @"Continue",nil,nil);
  
}

- (IBAction)showCashDonationManager:(id)sender {
  if (cashDonationManager == nil) {
    CashDonationManager *tmp = [[CashDonationManager alloc] init];
    [self setCashDonationManager:tmp];
    [tmp release];
  }
  [cashDonationManager setupForNonModal];
  [cashDonationManager runNonModal:self];
}



//******************************************************************************

- (void)createAdjustmentClicked:(NSToolbarItem *)item {
  ////NSLog(@"createAdjustmentClicked");
}

//******************************************************************************

- (void)sellSomethingClicked:(NSToolbarItem *)item {
 // //NSLog(@"sellSomethingClicked");
  if (journalIsOpen) {
    if (!createInvoice) {
      CreateInvoice *ci = [[CreateInvoice alloc] init];
      [self setCreateInvoice:ci];
      [ci release];
    }
    [createInvoice setupForNonModal];
    [createInvoice showWindow:self];
    [createInvoice runSelectPersonModal];
  } else {
    NSRunAlertPanel(@"No book is open",@"you must open a book before adding invoices",
                    @"Continue",nil,nil);
  }
}

- (void)setBugReportController:(BugReportController *)brc {
  if (bugReportController != brc) {
    [brc retain];
    [bugReportController release];
    bugReportController = brc;
  }
}
- (void)submitBugClicked:(NSToolbarItem *)item {
  ////NSLog(@"submitBugClicked");
  if (!bugReportController) {
    BugReportController *tmp = [[BugReportController alloc] init];
    [self setBugReportController:tmp];
    [tmp release];
  }
  [bugReportController setupForNonModal];
  [bugReportController runNonModal:self];
}

- (IBAction)showBugReportWindow:(id)sender {
  if (!bugReportController) {
    BugReportController *tmp = [[BugReportController alloc] init];
    [self setBugReportController:tmp];
    [tmp release];
  }
  [bugReportController setupForNonModal];
  [bugReportController runNonModal:self];
}

//******************************************************************************

- (NSToolbar *)mainWindowToolbar {
  return mainWindowToolbar;
}

- (void)setMainWindowToolbar:(NSToolbar *)toolbar {
  if (mainWindowToolbar != toolbar) {
    [mainWindowToolbar release];
    [toolbar retain];
    mainWindowToolbar = toolbar;
  }
}

//******************************************************************************

- (NSMutableDictionary *)mainWindowToolbarItems {
  return mainWindowToolbarItems;
}

//******************************************************************************

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(bool)flag {
  return [mainWindowToolbarItems objectForKey:itemIdentifier];
}

//******************************************************************************

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar {
  return toolbarItemsForClosedJournal;
//  if ([self journalIsOpen]) {
//    return toolbarItemsForOpenJournal;
//  } else {
//    return toolbarItemsForClosedJournal;
//  }
}

//******************************************************************************

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar {
  return [mainWindowToolbarItems allKeys];
}

//******************************************************************************

- (NSArray *)toolbarItemsForOpenJournal {
  return toolbarItemsForOpenJournal;
}

- (void)setToolbarItemsForOpenJournal:(NSArray *)array {
  if (toolbarItemsForOpenJournal != array) {
    [toolbarItemsForOpenJournal release];
    [array retain];
    toolbarItemsForOpenJournal = array;
  }
}

//******************************************************************************

- (NSArray *)toolbarItemsForClosedJournal {
  return toolbarItemsForClosedJournal;
}

- (void)setToolbarItemsForClosedJournal:(NSArray *)array {
  if (toolbarItemsForClosedJournal != array) {
    [toolbarItemsForClosedJournal release];
    [array retain];
    toolbarItemsForClosedJournal = array;
  }
}
//******************************************************************************

- (void) setupToolbar {
  
  ////NSLog(@"in setupToolbar");
  
  // the items
  NSToolbarItem *emptyImage;
  NSToolbarItem *addCustomer;
  NSToolbarItem *createProject;
  NSToolbarItem *updateProject;
  // close Journal will replace open journal
  NSToolbarItem *openJournal;
  NSToolbarItem *closeJournal;
  // will be added when a journal is open
//  NSToolbarItem *createAdjustment;
  NSToolbarItem *sellSomething;
  NSToolbarItem *bug;
  
  emptyImage =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Empty Image"];
  [emptyImage setPaletteLabel:@""];
  [emptyImage setLabel:@""];
  [emptyImage setToolTip:[NSString stringWithFormat:@""]];
  [emptyImage setTarget:self];
//  [addCustomer setAction:@selector(addCustomerClicked:)];
 // done't use the empty-image
  [emptyImage setImage:[NSImage imageNamed:@""]];
  
  
  addCustomer =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Add Customer"];
  [addCustomer setPaletteLabel:@"Add Customer"];
  [addCustomer setLabel:@"Add Customer"];
  [addCustomer setToolTip:[NSString stringWithFormat:@"Add a customer"]];
  [addCustomer setTarget:self];
  [addCustomer setAction:@selector(addCustomerClicked:)];
  [addCustomer setImage:[NSImage imageNamed:@"AddCustomer"]];
  
  createProject =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Create Project"];
  [createProject setPaletteLabel:@"Create Project"];
  [createProject setLabel:@"Create Project"];
  [createProject setToolTip:[NSString stringWithFormat:@"Create a project"]];
  [createProject setTarget:self];
  [createProject setAction:@selector(createProjectClicked:)];
  [createProject setImage:[NSImage imageNamed:@"CreateProject"]];
  
  updateProject =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Update Project"];
  [updateProject setPaletteLabel:@"Update Project"];
  [updateProject setLabel:@"Update Project"];
  [updateProject setToolTip:[NSString stringWithFormat:@"Update a project"]];
  [updateProject setTarget:self];
  [updateProject setAction:@selector(updateProjectClicked:)];
  [updateProject setImage:[NSImage imageNamed:@"UpdateProject"]];
  
  openJournal =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Open Book"];
  [openJournal setPaletteLabel:@"Open Book"];
  [openJournal setLabel:@"Open Book"];
  [openJournal setToolTip:[NSString stringWithFormat:@"Open the daily book"]];
  [openJournal setTarget:self];
  [openJournal setAction:@selector(openJournalClicked:)];
  [openJournal setImage:[NSImage imageNamed:@"OpenJournal"]];
  
  closeJournal =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Close Book"];
  [closeJournal setPaletteLabel:@"Close Book"];
  [closeJournal setLabel:@"Close Book"];
  [closeJournal setToolTip:[NSString stringWithFormat:@"Close the daily book"]];
  [closeJournal setTarget:self];
  [closeJournal setAction:@selector(closeJournalClicked:)];
  [closeJournal setImage:[NSImage imageNamed:@"CloseJournal"]];
  
//  createAdjustment =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Create Adjustment"];
//  [createAdjustment setPaletteLabel:@"Create Adjustment"];
//  [createAdjustment setLabel:@"Create Adjustment"];
//  [createAdjustment setToolTip:[NSString stringWithFormat:@"Create an adjustment (e.g. for petty cash, etc.)"]];
//  [createAdjustment setTarget:self];
//  [createAdjustment setAction:@selector(createAdjustmentClicked:)];
//  [createAdjustment setImage:[NSImage imageNamed:@"CreateAdjustment"]];
  
  sellSomething =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Sell Something"];
  [sellSomething setPaletteLabel:@"Sell Something"];
  [sellSomething setLabel:@"Sell Something"];
  [sellSomething setToolTip:[NSString stringWithFormat:@"Create an invoice to sell products and/or projects"]];
  [sellSomething setTarget:self];
  [sellSomething setAction:@selector(sellSomethingClicked:)];
  [sellSomething setImage:[NSImage imageNamed:@"SellSomething"]];

  
  bug =  [[NSToolbarItem alloc] initWithItemIdentifier:@"Bug"];
  [bug setPaletteLabel:@"Submit Bug"];
  [bug setLabel:@"Submit Bug"];
  [bug setToolTip:[NSString stringWithFormat:@"Submit a bug report or feature request."]];
  [bug setTarget:self];
  [bug setAction:@selector(submitBugClicked:)];
  [bug setImage:[NSImage imageNamed:@"bug"]];
  
  
  NSArray *toolbarItems = [NSArray arrayWithObjects:emptyImage, addCustomer,
    createProject, updateProject, openJournal, closeJournal, sellSomething, bug, nil];
  NSArray *toolbarKeys = [NSArray arrayWithObjects:@"emptyImage", @"addCustomer",
    @"createProject", @"updateProject", @"openJournal", @"closeJournal", @"sellSomething", @"bug", nil];
  NSDictionary *mwti = [NSDictionary dictionaryWithObjects:toolbarItems forKeys:toolbarKeys];
  [self setMainWindowToolbarItems:mwti];
  NSLog(@"mainWindowToolbarItems = %@", [self mainWindowToolbarItems]);
  
  NSArray *tifoj = [NSArray arrayWithObjects:@"emptyImage", @"addCustomer",
    @"createProject", @"updateProject", @"sellSomething", @"closeJournal",
    @"bug", nil];
  [self setToolbarItemsForOpenJournal:tifoj];
    
  NSArray *tifcj = [NSArray arrayWithObjects:@"emptyImage", @"addCustomer",
    @"createProject", @"updateProject", @"sellSomething", @"openJournal", @"bug",
    nil];
  [self setToolbarItemsForClosedJournal:tifcj];
    
  
  [emptyImage release];
  [addCustomer release];
  [createProject release];
  [updateProject release];
  [openJournal release];
  [closeJournal release];
  [sellSomething release];
  [bug release];
  
  
  // identifier has to be unique per window type
  NSToolbar *mwToolbar = [[NSToolbar alloc] initWithIdentifier:@"mainMenuToolbar"]; 
  
  [mwToolbar setDelegate:self];
  [mwToolbar setAllowsUserCustomization:NO];
  [mwToolbar setAutosavesConfiguration:NO];
  [mainWindow setToolbar:mwToolbar];
  [self setMainWindowToolbar:mwToolbar];
  [mwToolbar release];
  
  [mainWindow makeKeyAndOrderFront:nil];

}


//******************************************************************************
// accessor
//******************************************************************************

- (NSWindow *)mainWindow {
  return mainWindow;
}

- (bool)journalIsOpen {
  return journalIsOpen;
}

- (OpenBookController *)openBookController {
  return openBookController;
}

- (void) setOpenBookController:(OpenBookController *)arg {
  [arg retain];
  [openBookController release];
  openBookController = arg;
}



- (void) setMainWindowToolbarItems:(NSDictionary *)arg {
  if (arg != mainWindowToolbarItems) {
    [arg retain];
    [mainWindowToolbarItems release];
    mainWindowToolbarItems = [arg mutableCopy];
  }
}


- (NSArray *)arrayFromDictionary:(NSDictionary *) dict {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  NSEnumerator *e = [dict objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    [result addObject:value];
  }
  NSArray *returnVal = [NSArray arrayWithArray:result];
  [result release];
  return returnVal;
}


//******************************************************************************
// setter
//******************************************************************************

- (ClientInfoManager *)clientInfoManager {
  return clientInfoManager;
}
- (void)setClientInfoManager:(ClientInfoManager *)arg {
  [arg retain];
  [clientInfoManager release];
  clientInfoManager = arg;
}

- (void)setJournalIsOpen:(bool) flag {
  journalIsOpen = flag;
}

- (CloseBookController *)closeBookController {
  return closeBookController;
}

- (void) setCloseBookController:(CloseBookController *)arg {
  [arg retain];
  [closeBookController release];
  closeBookController = arg;
}

- (BookViewer *)currentBookViewer {
  return currentBookViewer;
}

- (void) setCurrentBookViewer:(BookViewer *)arg {
  [arg retain];
  [currentBookViewer release];
  currentBookViewer = arg;
}

- (CreditManager *)creditsManager {
  return creditsManager;
}
- (void) setCreditsManager:(CreditManager *)arg {
  [arg retain];
  [creditsManager release];
  creditsManager = arg;
}

- (MembershipManager *)membershipManager {
  return membershipManager;
}
- (void)setMembershipManager:(MembershipManager *)arg {
  [arg retain];
  [membershipManager release];
  membershipManager = arg;
}
- (CustomerContactController *)contactsManager {
  return contactsManager;
}
- (void)setContactsManager:(CustomerContactController *)arg {
  [arg retain];
  [contactsManager release];
  contactsManager = arg;
}
- (CreateAComp *)compAProduct {
  return compAProduct;
}
- (void)setCompAProduct:(CreateAComp *)arg {
  [arg retain];
  [compAProduct release];
  compAProduct = arg;
}

- (CompManager *)compManager {
  return compManager;
}
- (void)setCompManager:(CompManager *)arg {
  [arg retain];
  [compManager release];
  compManager = arg;
}

- (ReturnHandler *)handleReturn {
  return handleReturn;
}
- (void)setHandleReturn:(ReturnHandler *)arg {
  [arg retain];
  [handleReturn release];
  handleReturn = arg;
}
- (ReturnManager *)returnManager {
  return returnManager;
}
- (void)setReturnManager:(ReturnManager *)arg {
  [arg retain];
  [returnManager release];
  returnManager = arg;
}
- (AcceptInKindDonation *)acceptInKindDonation {
  return acceptInKindDonation;
}
- (void)setAcceptInKindDonation:(AcceptInKindDonation *)arg {
  [arg retain];
  [acceptInKindDonation release];
  acceptInKindDonation = arg;
}

- (InKindDonationManager *)inKindDonationManager {
  return inKindDonationManager;
}
- (void)setInKindDonationManager:(InKindDonationManager *)arg {
  [arg retain];
  [inKindDonationManager release];
  inKindDonationManager = arg;
}
- (CreateInvoice *)createInvoice {
  return createInvoice;
}
- (void)setCreateInvoice:(CreateInvoice *)arg {
  [arg retain];
  [createInvoice release];
  createInvoice = arg;
}

- (AcceptCashDonation *)acceptCashDonationManager {
  return acceptCashDonationManager;
}
- (void)setAcceptCashDonationManager:(AcceptCashDonation *)arg {
  [arg retain];
  [acceptCashDonationManager release];
  acceptCashDonationManager = arg;
}

- (CashDonationManager *)cashDonationManager {
  return cashDonationManager;
}
- (void)setCashDonationManager:(CashDonationManager *)arg {
  [arg retain];
  [cashDonationManager release];
  cashDonationManager = arg;
}

- (ProjectSelector *)projectSelector {
  return projectSelector;
}
- (void)setProjectSelector:(ProjectSelector *)arg {
  [arg retain];
  [projectSelector release];
  projectSelector = arg;
}


// dead sea
//+ (void)initialize {
//  NSMutableDictionary *applicationDefaultSettings = [[NSMutableDictionary alloc] init];
//  MembershipInformation *cook, *deluxe, *regular, *lifetime;
//  
//  // 25 years for lifetime membership
//  // where the fuck will we be in 25 years? -jjm      
//  lifetime = [[MembershipInformation alloc] initWithMemberType:@"lifetime" cost:1.0 newPartsDiscount:15.0 workshopDiscount:30.0 duration:9125];
//  // 25 years for cook membership
//  // where the fuck will we be in 25 years? -jjm
//  cook = [[MembershipInformation alloc] initWithMemberType:@"cook" cost:1.0 newPartsDiscount:40.0 workshopDiscount:100.0 duration:9125];
//  
//  regular = [[MembershipInformation alloc] initWithMemberType:@"regular" cost:70.0 newPartsDiscount:10.0 workshopDiscount:15.0 duration:365];
//  
//  deluxe = [[MembershipInformation alloc] initWithMemberType:@"deluxe" cost:100.0 newPartsDiscount:10.0 workshopDiscount:30.0 duration:365];
//  
//  // put defaults in the dictionary
//  [applicationDefaultSettings setObject:[NSNumber numberWithDouble:8.25]
//                                 forKey:TljBkPosSalesTaxRate];
//  
//  [applicationDefaultSettings setObject:[NSNumber numberWithDouble:100.0]
//                                 forKey:TljBkPosStartingBookAmount];
//  
//  [applicationDefaultSettings setObject:[NSNumber numberWithInt:1]
//                                 forKey:TljBkPosWillAcceptCreditCards];
//  
//  NSData *cookAsData = [NSKeyedArchiver archivedDataWithRootObject:cook];
//  NSData *lifetimeAsData = [NSKeyedArchiver archivedDataWithRootObject:lifetime];
//  NSData *regularAsData = [NSKeyedArchiver archivedDataWithRootObject:regular];
//  NSData *deluxeAsData = [NSKeyedArchiver archivedDataWithRootObject:deluxe];
//
//  [applicationDefaultSettings setObject:lifetimeAsData forKey:TljBkPosLifetimeMembershipInfo];
//  [applicationDefaultSettings setObject:cookAsData forKey:TljBkPosCookMembershipInfo];
//  [applicationDefaultSettings setObject:regularAsData forKey:TljBkPosRegularMembershipInfo];
//  [applicationDefaultSettings setObject:deluxeAsData forKey:TljBkPosDeluxeMembershipInfo];
//  
//  NSLog(@"applicationDefaultSettings: %@", applicationDefaultSettings);
//  
//  [[NSUserDefaults standardUserDefaults] registerDefaults:applicationDefaultSettings];
//  
//  //[lifetime release];
//  //[cook release];
//  //[deluxe release];
//  //[regular release];
//  // don't release this!
//  //[applicationDefaultSettings release];
//  
//  
//}


@end
