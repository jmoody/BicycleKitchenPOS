//
//  InvoiceController.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/19/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "InvoiceController.h"
#import "PeopleController.h"
#import "ProjectController.h"
#import "CreateProjectController.h"
#import "PreferenceController.h"
#import "MembershipInformation.h"
#import "BasicWindowController.h"
#import "Person.h"
#import "People.h"
#import "Product.h"
#import "Products.h"
#import "ProductCategory.h"
#import "ProductCategories.h"
#import "Invoice.h"
#import "Invoices.h"

#import "PayInvoiceController.h"

@implementation InvoiceController

- (id) init {
  self = [super init];
  if (self != nil) {
    [self setRunningModal:NO];
    previousLengthOfSearchString = 0;
    self =  [super initWithWindowNibName:@"Invoice"];
  }
  return self;
}

//******************************************************************************

- (void) dealloc {
  [self deallocAnArray:productsInInvoice];
  [self deallocAnArray:invoiceItems];
  [self deallocAnArray:categories];
  [projectController release];
  [peopleController release];
  [payInvoiceController release];
  [projectInInvoice release];
  [currentlyViewedPerson release];
  [currentlyViewedProduct release];
  [currentlyViewedInvoiceItem release];
  [currentInvoice release];
  [super dealloc];
}


//******************************************************************************

- (void)setupForNonModal {
  [super setupForModal];
  [self setInvoiceItems:[[NSMutableArray alloc] init]];
  [self setupTableViewsAndBrowser];
  [self setupTextFields];
}

//******************************************************************************

//- (void)runModalWithParent:(NSWindow *)parent {
//  [self setupTableViewsAndBrowser];
//  [self setupTextFields];
//  [super runModalWithParent:parent];
//}

//******************************************************************************

- (void)windowDidLoad {
  // only gets run once
  [super windowDidLoad];
  // have to have this here because when the window is first loaded, the fucking
  // browser isn't sized correctly.
  [self setupTableViewsAndBrowser];
}

//******************************************************************************

- (void)runSelectPersonModal {
  if (peopleController == nil) {
    PeopleController *pc = [[PeopleController alloc] init];
    [self setPeopleController:pc];
  }
  [peopleController setupForModal];
  [peopleController runModalWithParent:[self window]];

  [self setCurrentlyViewedPerson:[peopleController currentlyViewedPerson]];
  [peopleController setCurrentlyViewedPerson:nil];
  [[self window] setTitle:[NSString stringWithFormat:@"Invoice for: %@",
    [currentlyViewedPerson personName]]];
  
  // adjust all the buttons to reflect the person's profile
  if ([self cvpIsAnonymous]) {
    [applyDiscountButton setEnabled:YES];
    [saveToPersonButton setEnabled:NO];
    [saveToProjectButton setEnabled:NO];
    [addProjectButton setEnabled:NO];
  } else {
    if ([self cvpIsMember]) {
      [applyDiscountButton setEnabled:NO];
    } else {
      [applyDiscountButton setEnabled:YES];
    }
    //[saveToPersonButton setEnabled:YES];
    //[saveToProjectButton setEnabled:YES];
    [addProjectButton setEnabled:YES];
  }
  // for some reason, returning from modal frells the double actions
  [self setupProductsAndCategoriesDoubleActions];
}

//******************************************************************************

- (void)setupTableViewsAndBrowser {
  ////NSLog(@"in setup table views and browser");
  [productsTableView setTarget:self];
  [productsTableView setDoubleAction:@selector(handleProductClicked:)];
  [self setProductsInInvoice:[[Products sharedInstance] arrayForDictionary]];

  // collect the sorted categories and products
  [self setCategories:[[ProductCategories sharedInstance]
 arrayForBrowserFromProducts:[[Products sharedInstance] dictionary]]];
  // force a refresh of the browser
  [categoriesTreeController setContent:nil];
  [categoriesTreeController setContent:categories];
  
  [categoryBrowser setTarget:self];
  [categoryBrowser setDoubleAction:@selector(handleCategoryClicked:)];
  // i don't think so
  //[categoryBrowser setAction:@selector(handleCategoryClicked:)];
  // must have this exactly here
  [categoryBrowser setMinColumnWidth:150.0];

  [categoryBrowser setWidth:150.0 ofColumn:0];
  // the max is set in the ib
  // here is the deal.  figure out the max column
  // width, set it in the ib and then set it again
  // here.
  // in the ib set the column resizing to None.
  [categoryBrowser setWidth:350.0 ofColumn:1];
  [categoryBrowser setMaxVisibleColumns:2];
  
  [categoryBrowser setMinColumnWidth:150.0];
  [categoryBrowser setWidth:150.0 ofColumn:0];

  
  [invoiceTableView setTarget:self];
  [invoiceTableView setDoubleAction:@selector(handleInvoiceClicked:)];
  [invoiceTableView setAction:@selector(handleInvoiceClicked:)];
  
  // set the window title to "Invoice for: "
  [[self window] setTitle:[NSString stringWithFormat:@"Invoice for: %@", @"nobody"]];
}

//******************************************************************************

- (void)setupTextFields {
  [payInvoiceButton setEnabled:NO];
  [saveToPersonButton setEnabled:NO];
  [saveToProjectButton setEnabled:NO];
  [productsSearchField setStringValue:[NSString stringWithFormat:@""]];
  [self clearTextField:priceTextField];
  [self clearTextField:quantityTextField];
  [self clearTextField:totalTextField];
  [self clearTextField:roundedTextField];
  NSNumberFormatter *formatter = [priceTextField formatter];
  [formatter setFormat:@"$#,##0.00"];
  [priceOrStandTimeTextField setStringValue:@"Price:"];
  applyDiscount = NO;
}

//******************************************************************************

- (void)setupPriceAndQuantityFields {
  
  if ([self cvpIsProject] || [self cvpIsStand] || [self cvpIsDonation]) {
    [quantityTextField setEditable:NO];
  } else {
    [quantityTextField setEditable:YES];
  }
  
  if ([self cvpIsStand]) {
    [priceTextField setEditable:NO];
    [priceStepper setIncrement:0.25];
    [priceStepper setMinValue:0.25];
    double currentPrice = [currentlyViewedProduct productPrice];
		double newPrice = currentPrice / 7.0;
		[priceStepper setDoubleValue:newPrice];
		[priceTextField setDoubleValue:newPrice];
		
    [priceOrStandTimeTextField setStringValue:@"Hours of Stand Time:"];
    NSNumberFormatter *formatter = [priceTextField formatter];
    [formatter setFormat:@"##0.00"];
  } else {
    double price = [currentlyViewedProduct productPrice];
    int quantity = [currentlyViewedProduct productQuantity];
    
    [quantityStepper setIntValue:quantity];
    [quantityTextField setIntValue:quantity];

    [priceStepper setDoubleValue:price];
    [priceTextField setDoubleValue:price];
    
    [priceTextField setEditable:YES];
    [priceStepper setIncrement:1.0];
    [priceStepper setMinValue:0.0];
    [priceOrStandTimeTextField setStringValue:@"Price:"];
    NSNumberFormatter *formatter = [priceTextField formatter];
    //[formatter setFormatterBehavior:NSNumberFormatterCurrencyStyle];
    [formatter setFormat:@"$#,##0.00"];
  }
  
  [invoiceTableView reloadData];
  
}

//******************************************************************************

- (void)enableSaveToButtonsAppropriately {
  if ([self cvpIsAnonymous] ||  [self donationInInvoice] ||  [self projectInInvoiceP] ||
      [self membershipInInvoiceP] || ([invoiceItems count] == 0)) {
    //NSLog(@"cvpIsAnonymous: %d", [self cvpIsAnonymous]);
    //NSLog(@"donationInInvoice: %d", [self donationInInvoice]);
    //NSLog(@"projectInVoiceP: %d", [self projectInInvoiceP]);
    //NSLog(@"membershipInInvoiceP: %d", [self membershipInInvoiceP]);
    //NSLog(@"[invoiceItems count] == 0]: %d", [invoiceItems count] == 0);
    
    [saveToPersonButton setEnabled:NO];
    [saveToProjectButton setEnabled:NO];
  } else {
    [saveToPersonButton setEnabled:YES];
    [saveToProjectButton setEnabled:YES];
  }
}

- (void)enablePayButtonAppropriately {
  if ([invoiceItems count] == 0 || [self totalInvoiceAmount] == 0.0) {
    [payInvoiceButton setEnabled:NO];
  } else {
    [payInvoiceButton setEnabled:YES];
  }
}

//******************************************************************************

- (void)addInvoiceItem:(Product *)p {
    
  Product *pcopy = [[Product alloc] init];
  [pcopy setUid:[p uid]];
  [pcopy setDisplayName:[p displayName]];
  [pcopy setProductName:[p productName]];
  [pcopy setProductCategory:[p productCategory]];
  [pcopy setProductCode:[p productCode]];
  [pcopy setTaxable:[p taxable]];
  [pcopy setProductPrice:[p productPrice]];
  [pcopy setProductQuantity:1];
  
  // don't reverse this order
  [self setCurrentlyViewedProduct:pcopy];
  [self setupPriceAndQuantityFields];
  
  // apply discount
  double percentDiscount = 0.0;
  if ([self cvpIsMember]) {
    NSString *mt = [currentlyViewedPerson memberType];
    ////NSLog(@"mt: %@", mt);
    NSData *mid =  [[NSUserDefaults standardUserDefaults] objectForKey:mt];
    ////NSLog(@"mid: %@", mid);
    MembershipInformation *mi = [NSKeyedUnarchiver unarchiveObjectWithData:mid];
    ////NSLog(@"mi: %@", mi);
    if ([self cvpIsClass]) {
      percentDiscount = [mi discountOnWorkshops] * .01;
    } else if ([self cvpIsStand]) {
      percentDiscount = 1.0;
    } else if ([currentlyViewedProduct taxable]) {
      percentDiscount = [mi discountOnNewParts]  * .01;
    }
  } else if (applyDiscount && [currentlyViewedProduct taxable]) {
    percentDiscount = 0.1;
  }
  
  ////NSLog(@"percentDiscount: %1.2f", percentDiscount);
  
  double price = [pcopy productPrice];
  double total = round(1.0 * price * (1.0 - percentDiscount));
  double discount = price - total;
  [pcopy setProductDiscount:discount];
  [pcopy setProductTotal:total];
  
  [invoiceItemsController insertObject:pcopy atArrangedObjectIndex:[invoiceItems count]];
  [invoiceTableView reloadData];  
  [self setTotalTextFieldValue];
  [self enableSaveToButtonsAppropriately];
  [self enablePayButtonAppropriately];
  [self enableAddProjectButtonAppropriately];
}


- (void)enableAddProjectButtonAppropriately {
  if ([self projectInInvoiceP]) {
    [addProjectButton setEnabled:NO];
  } else {
    [addProjectButton setEnabled:YES];
  }
}

//******************************************************************************

- (void)handleInvoiceClicked:(id)sender {
  ////NSLog(@"invoice clicked");
  [self setCurrentlyViewedProduct:[[invoiceItemsController selectedObjects] objectAtIndex:0]];
  [self setupPriceAndQuantityFields];  
}

//******************************************************************************

- (void)handleTextFieldChange:(NSNotification *)note {
  ////NSLog(@"handle main window text change");
  if (([[self window] isKeyWindow]) && ([note object] != productsSearchField)) {
    id sender = [note object];
    if (sender == quantityTextField) {
      int newValue = [quantityTextField intValue];
      double price = [currentlyViewedProduct productPrice];
      [currentlyViewedProduct setProductQuantity:newValue];
      [quantityStepper setIntValue:newValue];
      
      double percentDiscount;
      if (applyDiscount) {
        percentDiscount = 0.1;
      } else {
        percentDiscount = 0.0;
      }      
      double totalBeforeDiscount = 1.0 * newValue * price;
      double total = round(totalBeforeDiscount * (1.0 - percentDiscount));
      double discount = totalBeforeDiscount - total;
      [currentlyViewedProduct setProductDiscount:discount];
      [currentlyViewedProduct setProductTotal:total];
      [self setTotalTextFieldValue];
      [invoiceTableView reloadData];
    } else if (sender == priceTextField) {
      double newPrice = [priceTextField doubleValue];
      if (newPrice < 1.0) {
        newPrice = 1.0;
      }
      int quantity = [currentlyViewedProduct productQuantity];
      [currentlyViewedProduct setProductPrice:newPrice];
      [priceStepper setDoubleValue:newPrice];
      
      double percentDiscount;
      
      if (applyDiscount) {
        percentDiscount = 0.1;
      } else {
        percentDiscount = 0.0;
      }      
      double totalBeforeDiscount = 1.0 * quantity * newPrice;
      double total = round(totalBeforeDiscount * (1.0 - percentDiscount));
      double discount = totalBeforeDiscount -  total;
      [currentlyViewedProduct setProductDiscount:discount];
      [currentlyViewedProduct setProductTotal:total];
      [self setTotalTextFieldValue];
      [invoiceTableView reloadData];
    }
  }
}

//******************************************************************************

- (IBAction)addStandTimeButtonClicked:(id)sender {
  ////NSLog(@"add stand time button clicked");
  // simple insert
    
  if ([self invoiceHasItemWithCodeAlready:@"stand"]) {
    NSString *message =
    [NSString stringWithFormat:@"To increase the amount of stand time\nuse the PRICE Stepper button."];
    NSRunAlertPanel(@"Stand Time Already in Invoice", message,@"Cancel",nil,nil);
  } else {
    Product *p = [[Products sharedInstance] productForProductCode:@"stand"];
    [self addInvoiceItem:p];
  }
}

//******************************************************************************

- (bool)invoiceHasItemWithCodeAlready:(NSString *)code {
  NSEnumerator *e = [invoiceItems objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    if ([[value productCode] isEqualToString:code]) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (IBAction)applyDiscountButtonClicked:(id)sender {
  if ([applyDiscountButton state]) {
    applyDiscount = YES;
  } else {
    applyDiscount = NO;
  }
  // apply discount to discountable items in invoice
  unsigned int i, count = [invoiceItems count];
  double percentDiscount = 0.0;
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    if ([p taxable]) {
      if (applyDiscount && [p taxable]) {
        percentDiscount = 0.1;
      } else {
        percentDiscount = 0.0;
      }
      double price = [p productPrice];
      int quantity = [p productQuantity];
      double totalBeforeDiscount = 1.0 * quantity * price;
      double total = round(totalBeforeDiscount * (1.0 - percentDiscount));
      double discount = totalBeforeDiscount - total;
      [p setProductDiscount:discount];
      [p setProductTotal:total];
    } 
  }
  [self setTotalTextFieldValue];
}

//******************************************************************************

- (IBAction)addProjectButtonClicked:(id)sender {
  //NSLog(@"add project button clicked");
  // what to do about projects?
  // 1. add remaining balance as project line item
  // 2. loop through the unpaid invoices and collect
  // the products, adding each on as a line item
  // 3. sum all the stand times - this means don't allow
  //    stand time to be added when adding invoice to project?
  NSString *message = @"Adding a project to an invoice adds the bicycle\n and ALL the items from all the unpaid invoices.";
  int choice = NSRunAlertPanel(@"Adding Project To Invoice",message,@"Continue",@"Cancel",nil);
  if (choice != 0) {
    if (projectController == nil) {
      ProjectController *pc = [[ProjectController alloc] init];
      [self setProjectController:pc];
    }
    [projectController setupForModal];
    [projectController setProjectsInController:[[Projects sharedInstance] objectsForUids:[currentlyViewedPerson projectUids]]];
    [projectController setupButtonsForAddProjectToInvoice];
    [projectController runModalWithParent:[self window]];
    Project *p = [projectController currentlyViewedProject];
    //NSLog(@"project = %@", p);
    if (p != nil) {
      [self setProjectInInvoice:p];
      Product *project = [[Product alloc] init];
      [project setUid:[p uid]];
      [project setProductName:[p bicycleDescription]];
      [project setDisplayName:[p bicycleDescription]];
      [project setProductCategory:@"Project"];
      [project setProductCode:@"project"];
      [project setProductQuantity:1];
      [project setTaxable:NO];
      [project setProductPrice:[p quote]];
      [self addInvoiceItem:project];
      
      //NSArray *unpaidProducts = [p itemsFromUnpaidInvoices];
      //NSLog(@"unpaidProducts: %@", unpaidProducts);
      NSMutableArray *unpaidProducts = [p productsInInvoice];
      unsigned int i, count = [unpaidProducts count];
      for (i = 0; i < count; i++) {
        Product *product = (Product *)[unpaidProducts objectAtIndex:i];
        [self addInvoiceItem:product];
      }
    }
  } else {
    [self setupProductsAndCategoriesDoubleActions];
  }
}
  
//******************************************************************************

- (void)setupProductsAndCategoriesDoubleActions {
  [productsTableView setTarget:self];
  [productsTableView setDoubleAction:@selector(handleProductClicked:)];
  [categoryBrowser setTarget:self];
  [categoryBrowser setDoubleAction:@selector(handleCategoryClicked:)];  
}

//******************************************************************************

- (IBAction)saveToPersonButtonClicked:(id)sender {
  //NSLog(@"save to person button clicked");
  // alls setCurrentInvoice
  [self makeUnpaidInvoice];
  // don't archive to disk (make pdf and lisp) yet
  // we do that when the invoice is  paid.
  // saves invoice, saves person
  [[currentlyViewedPerson invoiceUids] addObject:[currentInvoice uid]];
  [[People sharedInstance] saveToDisk];
  //NSLog(@"invoices before %@", [[Invoices sharedInstance] dictionary]);
  [[Invoices sharedInstance] setObject:currentInvoice forUid:[currentInvoice uid]];
  //NSLog(@"invoices after %@", [[Invoices sharedInstance] dictionary]);
  [[self window] close];
}

//******************************************************************************

- (IBAction)saveToProjectButtonClicked:(id)sender {
//  //NSLog(@"save to project button clicked");
//  // stand time is take off the invoice and added to the project. fact.
//  
//  if (projectController == nil) {
//    projectController = [[ProjectController alloc] init];
//  }
//  [projectController setupForModal];
//  NSArray *projects;
//  projects = [[Projects sharedInstance] objectsForUids:[currentlyViewedPerson projectUids]];
//  [projectController setProjectsInController:projects];
//  [projectController setupButtonsForAddInvoiceToProject];
//  [[projectController projectSearchField] setEnabled:NO];
//  [projectController runModalWithParent:[self window]];
//    
//  Project *p = [projectController currentlyViewedProject];
//  //NSLog(@"project = %@", p);
//  if (p != nil) {
//    // don't print now
//    [self makeUnpaidInvoice];
//    // saves to person and saves to Invoices
//    // doesn't archive to pdf or lisp, that is only
//    // done for paid invoices
//    [[currentlyViewedPerson invoiceUids] addObject:[currentInvoice uid]];
//    [[People sharedInstance] saveToDisk];
//    [[Invoices sharedInstance] setObject:currentInvoice forUid:[currentInvoice uid]];
//    [[p projectInvoiceUids] addObject:[currentInvoice uid]];
//    [[Projects sharedInstance] saveToDisk];
//    [[self window] close];
//  }
//  [[projectController projectSearchField] setEnabled:YES];
}

//******************************************************************************

- (IBAction)payInvoiceButtonClicked:(id)sender {
  [self makeUnpaidInvoice];
  // here is the run order
  // setCurrentlyViewedPerson
  // setCurrentInvoice - requires that an invoice is made in InvoiceController
  // with date, nonMemberDiscountGiven, nonMemberDiscountAmount, invoiceItems,
  // and projectInInvoice 
  // runModalWithParent
  if (payInvoiceController == nil) {
    PayInvoiceController *pic = [[PayInvoiceController alloc] init];
    [self setPayInvoiceController:pic];
  }
  [payInvoiceController setPerson:[self currentlyViewedPerson]];
  [payInvoiceController setInvoice:[self currentInvoice]];
  // might need a setupForModal here - not sure
  [payInvoiceController runModalWithParent:[self window]];
  // the pay invoice controller will close this window if payment is successful
  if ([currentInvoice invoicePaid]) {
    if (runningModal) {
      [self stopModalAndCloseWindow];
    } else {
      [[self window] close];
    }
  }
}

//******************************************************************************

- (IBAction)priceStepperClicked:(id)sender {
  ////NSLog(@"price stepper clicked");
  // check to see if there is a invoice line highlighted
  // if not, do nothing
  // if so, do table math to find the current cell
  // and incf the value
  // also figure synch the text field!
  // well, it seems like i can't figure out when 
  // the invoice table has focus.
  if ([self cvpIsStand]) {
    double hours = [priceStepper doubleValue];
    double newPrice = hours * 7.00;
    double percentDiscount;
    if ([self cvpIsMember]) {
      percentDiscount = 1.0;
    } else {
      percentDiscount = 0.0;
    }
    double totalBeforeDiscount = newPrice;
    double total = round(totalBeforeDiscount * (1.0 - percentDiscount));
    double discount = totalBeforeDiscount - total;
    [priceTextField setDoubleValue:hours];
    [currentlyViewedProduct setProductDiscount:discount];
    [currentlyViewedProduct setProductPrice:newPrice];
    [currentlyViewedProduct setProductTotal:total];
  }  else {
    // applyDiscount refers to applyDiscountButton
    
    double value = [priceStepper doubleValue];
    double originalPrice = [currentlyViewedProduct productPrice];
    double newPrice;
    double delta = [priceStepper increment];
    if (value > originalPrice) {
      newPrice = originalPrice + delta;
    } else if (value <= 1.0) {
      newPrice = 1.0;
    } else {
      newPrice = originalPrice - delta;
    }
    
    [priceTextField setDoubleValue:newPrice];
    [currentlyViewedProduct setProductPrice:newPrice];
    
    int quantity = [currentlyViewedProduct productQuantity];
    
    double percentDiscount = 0.0;
    if ([self cvpIsMember]) {
      NSString *mt = [currentlyViewedPerson memberType];
      ////NSLog(@"mt: %@", mt);
      NSData *mid =  [[NSUserDefaults standardUserDefaults] objectForKey:mt];
      ////NSLog(@"mid: %@", mid);
      MembershipInformation *mi = [NSKeyedUnarchiver unarchiveObjectWithData:mid];
      ////NSLog(@"mi: %@", mi);
      if ([self cvpIsClass]) {
        percentDiscount = [mi discountOnWorkshops] * .01;
      } else if ([self cvpIsStand]) {
        percentDiscount = 1.0;
      } else if ([currentlyViewedProduct taxable]) {
        percentDiscount = [mi discountOnNewParts]  * .01;
      }
    } else if (applyDiscount && [currentlyViewedProduct taxable]) {
      percentDiscount = 0.1;
    }
		
    double totalBeforeDiscount = 1.0 * quantity * newPrice;
    double total = round(totalBeforeDiscount * (1.0 - percentDiscount));
    double discount = totalBeforeDiscount - total;
    [currentlyViewedProduct setProductDiscount:discount];
    [currentlyViewedProduct setProductTotal:total];
  }
    
  [self setTotalTextFieldValue];
  [invoiceTableView reloadData];
}

//******************************************************************************

- (void)setTotalTextFieldValue {
  unsigned int i, count = [invoiceItems count];
  double sum = 0.0;
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    sum += [p productTotal];
  }
  double rounded = round(sum);
  [roundedTextField setDoubleValue:rounded];
  [totalTextField setDoubleValue:sum];
  [self enablePayButtonAppropriately];
}

//******************************************************************************

- (IBAction)quantityStepperClicked:(id)sender {
  ////NSLog(@"quantity stepper clicked");
  // do i need an invoice product here?
  // check to see if there is a invoice line highlighted
  // if not, do nothing
  // if so, do table math to find the current cell
  // and incf the value
  // also figure synch the text field!  
  if ([self cvpIsProject]) {
    NSString *message =
    [NSString stringWithFormat:@"Only one project per invoice."];
    NSRunAlertPanel(@"Operation not permitted.", message,@"Cancel",nil,nil);
  } else if ([self cvpIsStand]) {
    NSString *message =
    [NSString stringWithFormat:@"To increase the amount of stand time\nuse the PRICE Stepper button."];
    NSRunAlertPanel(@"Operaton not permitted.",message,@"Cancel",nil,nil);
  } else if ([self cvpIsDonation]) {
    NSString *message =
    [NSString stringWithFormat:@"Use PRICE Stepper to increase donation."];
    NSRunAlertPanel(@"Operation not permitted.", message,@"Cancel",nil,nil);
  } else {
     
    double newQuantity = [quantityStepper intValue];
    if (newQuantity <= 0) {
      newQuantity = 1;
      [quantityStepper setIntValue:1];
    }
    
    [quantityTextField setIntValue:newQuantity];
    [currentlyViewedProduct setProductQuantity:newQuantity];
    
    double price = [currentlyViewedProduct productPrice];
    
    double percentDiscount;
    if ([currentlyViewedProduct taxable]) {
      if (applyDiscount) {
        percentDiscount = 0.1;
      } else if ([self cvpIsMember]) {
        NSString *mt = [currentlyViewedPerson memberType];
        ////NSLog(@"mt: %@", mt);
        NSData *mid =  [[NSUserDefaults standardUserDefaults] objectForKey:mt];
        ////NSLog(@"mid: %@", mid);
        MembershipInformation *mi = [NSKeyedUnarchiver unarchiveObjectWithData:mid];
        ////NSLog(@"mi: %@", mi);
        if ([self cvpIsClass]) {
          percentDiscount = [mi discountOnWorkshops] * .01;
        } else {
          percentDiscount = [mi discountOnNewParts] * .01;
        }
      }
    } else {
      percentDiscount = 0.0;
    }
    
    double totalBeforeDiscount = 1.0 * newQuantity * price;
    double total = round(totalBeforeDiscount * (1.0 - percentDiscount));
    double discount = totalBeforeDiscount - total;
    [currentlyViewedProduct setProductDiscount:discount];
    [currentlyViewedProduct setProductTotal:total];
    [self setTotalTextFieldValue];
    [invoiceTableView reloadData];
  }
}

//******************************************************************************

- (void)makeUnpaidInvoice {
  // sets the date field to today
  [self setCurrentInvoice:[[Invoice alloc] init]];
  
  [currentInvoice setCustomerUid:[currentlyViewedPerson uid]];
  
  unsigned int i, count = [invoiceItems count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    [[currentInvoice items] setObject:p forKey:[p uid]];
  }

  [currentInvoice setInvoicePaid:NO];
  [currentInvoice setNonMemberDiscountGiven:[applyDiscountButton state]];
  if ([applyDiscountButton state]) {
    [currentInvoice setAmountOfNonMemberDiscountGiven:[self totalDiscounts]];
  } else {
    [currentInvoice setAmountOfNonMemberDiscountGiven:0.0];
  }
  
  [currentInvoice setInvoiceTotal:[roundedTextField doubleValue]];
  [currentInvoice setInvoiceTotal:[totalTextField doubleValue]];
    
  [currentInvoice setInvoiceTotal:[totalTextField doubleValue]];
  [currentInvoice setInvoiceTotal:[self totalInvoiceAmount]];
  
  [currentInvoice setTotalDiscounts:[self totalDiscounts]];
  
  double taxableAmount = [self computeTaxableAmount];
  ////NSLog(@"taxableAmount: %f", taxableAmount);
  double nontaxableAmount = [self computeNonTaxableAmount:taxableAmount];
  ////NSLog(@"nontaxableAmount: %f", nontaxableAmount);
  double tax = [self computeTaxOwed:taxableAmount];
  ////NSLog(@"tax: %f", tax);
  [currentInvoice setTotalTaxableAmount:taxableAmount];
  [currentInvoice setTotalNonTaxableAmount:nontaxableAmount];
  [currentInvoice setTaxOwed:tax];  
}


- (double)totalInvoiceAmount {
  return [roundedTextField doubleValue];
}

//******************************************************************************

- (double)computeTaxOwed:(double)taxableAmount {
  double taxRate = [[[NSUserDefaults standardUserDefaults] objectForKey:TljBkPosSalesTaxRate] doubleValue] * .01;
  return taxableAmount * taxRate;
}

//******************************************************************************

- (double)computeTaxableAmount {
  double sum = 0.0;
  unsigned int i, count = [invoiceItems count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    if ([p taxable]) {
      sum = sum + [p productTotal];
    }
  }
  return sum;
}

//******************************************************************************

- (double)computeNonTaxableAmount:(double)taxableAmount {
  double sum = 0.0;
  unsigned int i, count = [invoiceItems count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    if (![p taxable]) {
      sum = sum + [p productTotal];
    }
  }
  return sum;
}

//******************************************************************************

- (double)totalDiscounts {
  double sum = 0.0;
  unsigned int i, count = [invoiceItems count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    sum += [p productDiscount];
  }
  return sum;
}

//******************************************************************************

- (Product *)productForUid:(NSString *)aUid fromArray:(NSArray *)array {
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[array objectAtIndex:i];
    if ([aUid isEqualToString:[p uid]]) {
      return p;
    }
  }
  return nil;
}

//******************************************************************************

- (bool)array:(NSArray *)array containsProductWithUid:(NSString *)aUid {
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[array objectAtIndex:i];
    if ([aUid isEqualToString:[p uid]]) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (bool)keepAfterDecfProduct:(Product *)p quantityByDelta:(int)delta {
  int newQuantity = [p productQuantity] - delta;
  [p setProductQuantity:newQuantity];
  return (newQuantity != 0);
}

//******************************************************************************

- (IBAction)deleteButtonClicked:(id)sender {
  ////NSLog(@"delete button clicked");
  // simple remove and update totals 
  // bound to command + delete
  int index = [invoiceItemsController selectionIndex];
  Product *p = [[invoiceItemsController selectedObjects] objectAtIndex:0];
  
  // attempting to remove project
  if ([p uid:[p uid] isEqual:[projectInInvoice uid]]) {
    int choice; 
    choice = NSRunAlertPanel(@"Deleting Project",
                             @"Deleting a project will remove all the products associated with project",
                             @"Continue",@"Cancel",nil);
    if (choice == 1) {
      // remove the project
      NSMutableArray *newItems = [[NSMutableArray alloc] init];
      NSArray *itemsToRemoveOrDecf = [projectInInvoice productsInInvoice];
      NSEnumerator *e = [invoiceItems objectEnumerator];
      Product *value;
      while (value = (Product *)[e nextObject]) {
        ////NSLog(@"value: %@", value);
        if (![(ObjectWithUid *)value samep:(ObjectWithUid *)projectInInvoice]) {
          if ([self array:itemsToRemoveOrDecf containsProductWithUid:[value uid]]) {
            Product *productToRemove = [self productForUid:[value uid]
                                                 fromArray:itemsToRemoveOrDecf];
            
            if ([self keepAfterDecfProduct:value quantityByDelta:[productToRemove productQuantity]]) {
              [newItems addObject:value];
            } 
          } else {
            [newItems addObject:value];
          }
        }
      }
      
      
      [self setInvoiceItems:newItems];
      [productsTableView reloadData];
      [self enableAddProjectButtonAppropriately];
    } else {
      return;
    }
  } else {
    [self removeObjectFromInvoiceItemsAtIndex:index];
    [self setTotalTextFieldValue];
    if ([invoiceItems count] == 0) {
      [self setCurrentlyViewedProduct:nil];
      [self clearTextField:priceTextField];
      [self clearTextField:quantityTextField];
      [payInvoiceButton setEnabled:NO];
      [saveToPersonButton setEnabled:NO];
      [saveToProjectButton setEnabled:NO];
    } else {
      p =  [[invoiceItemsController selectedObjects] objectAtIndex:0];
      [self setCurrentlyViewedProduct:p];
      double price = [currentlyViewedProduct productPrice];
      int quantity = [currentlyViewedProduct productQuantity];
      [priceStepper setDoubleValue:price];
      [quantityStepper setDoubleValue:(double)quantity];
      [priceTextField setDoubleValue:price];
      [quantityTextField setIntValue:quantity];
    }
  }
}
     
//******************************************************************************

- (IBAction)cancelButtonClicked:(id)sender {
  ////NSLog(@"cancel button clicked");
  [[ProductCategories sharedInstance] saveToDisk];
  [[self window] close];
}

//******************************************************************************

//- (IBAction)changePersonButtonClicked:(id)sender {
//  [self runSelectPersonModal];
//}

//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(handleProductsSearchFieldChange:)
             name:@"NSControlTextDidChangeNotification"
           object:productsSearchField];
  
//  may not need this as I am just reading the shit off
//  [nc addObserver:self
//         selector:@selector(handleSummaryInfoChange:)
//             name:@"NSComboBoxSelectionDidChangeNotification"
//           object:summaryTypeComboBox];
  

  [nc addObserver:self
         selector:@selector(handleTextFieldChange:)
             name:@"NSControlTextDidChangeNotification"
           object:priceTextField];

  [nc addObserver:self
         selector:@selector(handleTextFieldChange:)
             name:@"NSControlTextDidChangeNotification"
           object:quantityTextField];
}

//******************************************************************************

- (void)insertObject:(Product *)p inInvoiceItemsAtIndex:(int)index {
  ////NSLog(@"insertObject inInvoicesAtIndex");
  //Add the inverse of this operaton to the undo stack
  NSUndoManager *undo = [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self]
    removeObjectFromInvoiceItemsAtIndex:index];
  if (![undo isUndoing]) {
    [undo setActionName:@"Add Item"];
  }  
  // [self startObservingProduct:p];
  [invoiceItems insertObject:p atIndex:index];
}

//******************************************************************************

- (void)removeObjectFromInvoiceItemsAtIndex:(int)index {
  ////NSLog(@"removeObjectFromInvoicesAtIndex");
  Product *p = [invoiceItems objectAtIndex:index];
  // Add the inverse of this operation to the undo stack
  
  NSUndoManager *undo =  [[self window] undoManager];
  [[undo prepareWithInvocationTarget:self] insertObject:p
                                  inInvoiceItemsAtIndex:index];
  if (![undo isUndoing]) {
    [undo setActionName:@"Delete Item"];
  }
  //[self stopObservingProduct:p];
  [invoiceItems removeObjectAtIndex:index];  
}

//******************************************************************************

- (void)handleProductsSearchFieldChange:(NSNotification *) note {
  ////NSLog(@"in handle product search field change");
  if (([[self window] isKeyWindow]) && ([note object] == productsSearchField)) {
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
      [self setProductsInInvoice:[[Products sharedInstance] arrayForDictionary]];
      previousLengthOfSearchString = 0;
      [productsTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfSearchString > [searchString length]) {
      [self setProductsInInvoice:[[Products sharedInstance] arrayForDictionary]];
    }
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [productsInInvoice objectEnumerator];
    while ( object = [e nextObject] ) {
      productCodeString = [[object productCode] lowercaseString];
      productNameString = [[object productName] lowercaseString];
      categoryString = [[object productCategory] lowercaseString];
      
      NSRange codeRange = [productCodeString rangeOfString:searchString options:NSLiteralSearch];
      NSRange nameRange = [productNameString rangeOfString:searchString options:NSLiteralSearch];
      NSRange categoryRange = [categoryString rangeOfString:searchString options:NSLiteralSearch];
      
      activeString = [[object activeYesOrNo] lowercaseString];
      NSRange activeRange = [activeString rangeOfString:searchString options:NSLiteralSearch];
      priceString = [NSString stringWithFormat:@"%1.2f", [object productPrice]];
      NSRange priceRange = [priceString rangeOfString:searchString options:NSLiteralSearch];
      quantityString = [NSString stringWithFormat:@"%d", [object productQuantity]];
      NSRange quantityRange = [quantityString rangeOfString:searchString options:NSLiteralSearch];
      
      
      
      if (((codeRange.length) > 0) || ((nameRange.length) > 0) || ((categoryRange.length) > 0) ||
          ((activeRange.length) > 0) || ((priceRange.length) > 0) || ((quantityRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setProductsInInvoice:filteredObjects];
    [productsTableView reloadData];
    previousLengthOfSearchString = [searchString length];
  }
}

//******************************************************************************

- (void)handleProductClicked:(id)sender {
  //NSLog(@"product clicked");
  Product *p = [[productsInInvoicesController selectedObjects] objectAtIndex:0];
  if (p != nil) {
    NSString *code = [p productCode];
    if ([self invoiceHasItemWithCodeAlready:code]) {
      NSRunAlertPanel(@"Product Already In Invoice",@"Use the steppers to increase the quantity",
                      @"Continue",nil,nil);
    } else {
      if ([code isEqualToString:@"project"]) {
        [addProjectButton performClick:self];
      } else {
        [self addInvoiceItem:p];
        [self clearTextField:productsSearchField];
        [self setProductsInInvoice:[[Products sharedInstance] arrayForDictionary]];
        [productsTableView reloadData];
      }
    }
  }
}
  
//******************************************************************************

- (void)handleCategoryClicked:(id)sender {
  ////NSLog(@"category clicked");
  NSCell *selectedCatCell = [categoryBrowser selectedCellInColumn:0];
  NSCell *selectedProductCell = [categoryBrowser selectedCellInColumn:1];
  ProductCategory *pc = [[ProductCategories sharedInstance] productCategoryForCategoryName:[selectedCatCell objectValue]];
  Product *p = [[Products sharedInstance] productForProductName:[selectedProductCell objectValue]];
  if (p != nil) {
    [pc incfTimesViewed];
    [p incfTimesViewed];
    [[ProductCategories sharedInstance] saveToDisk];
    [[Products sharedInstance] saveToDisk];
    NSString *code = [p productCode];
    if ([self invoiceHasItemWithCodeAlready:code]) {
      NSRunAlertPanel(@"Product Already In Invoice",@"Use the steppers to increase the quantity",
                      @"Continue",nil,nil);
    } else {
      if ([code isEqualToString:@"project"]) {
        [addProjectButton performClick:self];
      } else {
        [self addInvoiceItem:p];
      }
    }
  }
}

//******************************************************************************

- (NSArray *)productsInInvoice {
  return productsInInvoice;
}

//******************************************************************************

- (Product *)currentlyViewedProduct {
  return currentlyViewedProduct;
}

//******************************************************************************

- (NSMutableArray *)invoiceItems {
  return invoiceItems;
}

//******************************************************************************

- (Product *)currentlyViewedInvoiceItem {
  return currentlyViewedInvoiceItem;
}

//******************************************************************************

- (Invoice *)currentInvoice {
  return currentInvoice;
}

//******************************************************************************

- (NSArray *)categories {
  return categories;
}

//******************************************************************************


- (Person *)currentlyViewedPerson {
  return currentlyViewedPerson;
}

//******************************************************************************

- (Project *)projectInInvoice {
  return projectInInvoice;
}

//******************************************************************************

- (void)setProjectInInvoice:(Project *)p {
  [p retain];
  [projectInInvoice release];
  projectInInvoice = p;
}


//******************************************************************************

- (void)setPeopleController:(PeopleController *)pc {
  [peopleController release];
  [pc retain];
  peopleController = pc;
}

//******************************************************************************

- (void)setCurrentlyViewedPerson:(Person *)person {
  [person retain];
  [currentlyViewedPerson release];
  currentlyViewedPerson = person;
}

//******************************************************************************

- (void)setProductsInInvoice:(NSArray *)array {
  if (productsInInvoice != array) {
    [self deallocAnArray:productsInInvoice];
  }
  productsInInvoice = [[NSArray alloc] initWithArray:array];
}

//******************************************************************************

- (void)setCurrentlyViewedProduct:(Product *)product {
  [currentlyViewedProduct release];
  [product retain];
  currentlyViewedProduct = product;
}

//******************************************************************************

- (void)setInvoiceItems:(NSArray *)array {
  if (invoiceItems != array) {
    [self deallocAnArray:invoiceItems];
  }
  invoiceItems = [[NSMutableArray alloc] initWithArray:array];
}

//******************************************************************************

- (void)setCurrentlyViewedInvoiceItem:(Product *)product {
  [currentlyViewedInvoiceItem release];
  [product retain];
  currentlyViewedInvoiceItem = product;
}

//******************************************************************************

- (void)setCurrentInvoice:(Invoice *)invoice {
  [currentInvoice release];
  [invoice retain];
  currentInvoice = invoice;
}

//******************************************************************************

- (void)setCategories:(NSArray *)array {
  if (categories != array) {
    [self deallocAnArray:categories];
  }
  categories = [[NSArray alloc] initWithArray:array];
}

//******************************************************************************

- (bool)cvpIsAnonymous {
  return [[currentlyViewedPerson personName] isEqualToString:TljBkPosAnonymousClientName];
}

//******************************************************************************

- (bool)cvpIsMember {
  return [currentlyViewedPerson isMember];
}

//******************************************************************************

- (bool)cvpIsProject {
  NSString *prj = [NSString stringWithFormat:@"project"];
  return [[currentlyViewedProduct productCode] isEqualToString:prj];
}

//******************************************************************************

- (bool)cvpIsStand {
  NSString *stand = [NSString stringWithFormat:@"stand"];
  return [[currentlyViewedProduct productCode] isEqualToString:stand];
}

//******************************************************************************

- (bool)cvpIsDonation {
  NSString *donation = [NSString stringWithFormat:@"donation"];
  return [[currentlyViewedProduct productCode] isEqualToString:donation];
}

//******************************************************************************

- (bool)cvpIsClass {
  NSString *class = [NSString stringWithFormat:@"Class"];
  return [[currentlyViewedProduct productCategory] isEqualToString:class];
}

//******************************************************************************

- (bool)cvpIsMembership {
  NSString *prjc = @"Membership";
  return [[currentlyViewedProduct productCategory] isEqualToString:prjc];
}

//******************************************************************************

- (bool)donationInInvoice {
  unsigned int i, count = [invoiceItems count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    if ([[p productCode] isEqualToString:@"donation"]) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (bool)projectInInvoiceP {
  unsigned int i, count = [invoiceItems count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    if ([[p productCode] isEqualToString:@"project"]) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (bool)membershipInInvoiceP {
  unsigned int i, count = [invoiceItems count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    if ([[p productCategory] isEqualToString:@"Membership"]) {
      return YES;
    }
  }
  return NO;
}

//******************************************************************************

- (PeopleController *)peopleController {
  return peopleController;
}

//******************************************************************************

- (ProjectController *)projectController {
  return projectController;
}

//******************************************************************************

- (void)setProjectController:(ProjectController *)controller {
  [controller retain];
  [projectController release];
  projectController = controller;
}

//******************************************************************************

- (PayInvoiceController *)payInvoiceController {
  return payInvoiceController;
}

//******************************************************************************

- (void)setPayInvoiceController:(PayInvoiceController *)controller {
  [controller retain];
  [payInvoiceController release];
  payInvoiceController = controller;
}


//******************************************************************************

- (bool)membershipInInvoice {
  unsigned int i, count = [invoiceItems count];
  for (i = 0; i < count; i++) {
    Product *p = (Product *)[invoiceItems objectAtIndex:i];
    if ([[p productCategory] isEqualToString:@"Membership"]) {
      return YES;
    }
  }
  return NO;
}


@end
