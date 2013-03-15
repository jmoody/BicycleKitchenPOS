//
//  CreateProjectController.m
//  BicycleKitchenPOS
//
//  Created by moody on 10/8/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//


#import "CreateProjectController.h"
#import "ProgressiveWindowController.h"
#import "CreateCustomerController.h"
#import "PreferenceController.h"
#import "Person.h"
#import "Project.h"
#import "Bicycle.h"
#import "People.h"
#import "Projects.h"
#import "FormPrinter.h"
#import "Invoice.h"
#import "Invoices.h"
#import "Product.h"
#import "Products.h"

@implementation CreateProjectController

- (id)init {
  self = [super init];
  if (self != nil) {
    self =  [super initWithWindowNibName:@"CreateProjectWindow"];
    [self setupNotificationObservers];
    previousLengthOfPeopleSearchString = 0;
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
  NSEnumerator *enumerator;
  id value;
  
  enumerator = [clientsInCreateProject objectEnumerator];
  while ((value = [enumerator nextObject])) {
    [value release];
  }

  [createCustomerController release];
  [clientsInCreateProject release];  
  [selectedClient release];
  [selectedBicycle release];
  [newProject release];
  [mainApplicationWindow release];
  
  [super dealloc];
}

//******************************************************************************
// windowing
//******************************************************************************

- (void)awakeFromNib {
  [super awakeFromNib];
  [pwcTabView selectFirstTabViewItem:self];
  [pwcTitleTextField setStringValue:@"Select Client"];

 // [startDatePicker setDatePickerMode:NSSingleDateMode];
 // [startDatePicker setDatePickerStyle:NSClockAndCalendarDatePickerStyle];

}

/******************************************************************************/

- (void)windowDidLoad {
  [self setupWindow];
  ////NSLog(@"CreateCustomerManager nib file is loaded.");
}

/******************************************************************************/

- (IBAction)showWindow:(id)sender {
  [super showWindow:sender];
  [self setupWindow];
}

- (void)setupWindow {
  
  if (runningModal) {
    [cancelButton setHidden:NO];
  } else {
    [cancelButton setHidden:YES];
  }
  
  [self clearTextField:clientsSearchField];
  
  [self setClientsInCreateProject:[[People sharedInstance] arrayForDictionary]];
  [clientsTableView setTarget:self];
  [clientsTableView setDoubleAction:@selector(selectButtonClicked:)];
  [pwcNextButton setEnabled:NO];
  
  NSString *str = [NSString stringWithFormat:@"No client selected."];
  [selectedClientTextField1 setStringValue:str];
  [selectedClientTextField2 setStringValue:str];
  [selectedClientTextField3 setStringValue:str];
  
  NSString *str2 = [NSString stringWithFormat:@"Step 1 of %d",
    [pwcTabView numberOfTabViewItems]];
  [pwcStepTextField setStringValue:str2];
  [self setPwcCurrentStep:0];
  [pwcTabView selectFirstTabViewItem:self];
  
  
  NSCalendarDate *today = [NSCalendarDate calendarDate];
  [startDatePicker setDateValue:(NSDate *)today];
  NSCalendarDate *thirtyDays = [today dateByAddingYears:0 
                                                 months:0 
                                                   days:30
                                                  hours:0
                                                minutes:0
                                                seconds:0];
  
  NSString *endDateStr  = 
    [[thirtyDays descriptionWithCalendarFormat:@"%m/%d/%Y" timeZone:nil locale:nil]
      description];
  
  [endDateTextField1 setStringValue:endDateStr];
  
  ////NSLog(@"showing CreateCustomerManager window");
  [self clear1DForm:makeModelColorForm];
  
  NSString *required = [NSString stringWithFormat:@"required"];
  [[makeModelColorForm cellAtIndex:0] setPlaceholderString:required];
  [[makeModelColorForm cellAtIndex:1] setPlaceholderString:required];
  [[makeModelColorForm cellAtIndex:2] setPlaceholderString:required];
  
  [self clearTextField:quoteTextField1];
  [quoteTextField1 setStringValue:@""];
  
  if ([quoteTextField1 acceptsFirstResponder]) {
    [[self window] makeFirstResponder:quoteTextField1];
  }
  
  [self clearTextView:noteTextView];
  
  [standTimeStepper setDoubleValue:0.0];
	[standTimeTextField setDoubleValue:0.0];
  [[self window] recalculateKeyViewLoop];
  
}

- (void)runCreateProjectModal {
  ////NSLog(@"CreateProjectController runCreateProjectModal");
  [self setupWindow];
  [NSApp beginSheet:[self window]
     modalForWindow:mainApplicationWindow
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];
  
  [NSApp runModalForWindow:[self window]];
  
  [NSApp endSheet:[self window]];
  [[self window] orderOut:self];
  
}


//******************************************************************************
// notifications
//******************************************************************************

- (void)setupNotificationObservers {
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  
  // searching
  [nc addObserver:self
         selector:@selector(handlePeopleSearchFieldDidChange:)
             name:@"NSControlTextDidChangeNotification"
           object:clientsSearchField];
  
  // next button enabling
  [nc addObserver:self 
         selector:@selector(handleDetailsChange:)
             name:@"NSControlTextDidChangeNotification"
           object:[makeModelColorForm cellAtIndex:0]];

  [nc addObserver:self 
         selector:@selector(handleDetailsChange:)
             name:@"NSControlTextDidChangeNotification"
           object:[makeModelColorForm cellAtIndex:1]];
  
  
  [nc addObserver:self 
         selector:@selector(handleDetailsChange:)
             name:@"NSControlTextDidChangeNotification"
           object:[makeModelColorForm cellAtIndex:2]];
  
  
  [nc addObserver:self 
         selector:@selector(handleDetailsChange:)
             name:@"NSControlTextDidChangeNotification"
           object:quoteTextField1];
      
}

/******************************************************************************/

- (void)handleDetailsChange:(NSNotification *) note {
  if ([[self window] isKeyWindow]) {
    NSString *emptyString = [NSString stringWithFormat:@""];
    if (![emptyString isEqualToString:[[makeModelColorForm cellAtIndex:0] stringValue]] &&
        ![emptyString isEqualToString:[[makeModelColorForm cellAtIndex:1] stringValue]] &&
        ![emptyString isEqualToString:[[makeModelColorForm cellAtIndex:2] stringValue]] &&
        ![emptyString isEqualToString:[quoteTextField1 stringValue]]) {
      [pwcNextButton setEnabled:YES];
    } else {
      [pwcNextButton setEnabled:NO];
    }
  }
}

//******************************************************************************
// searching
//******************************************************************************

- (void)handlePeopleSearchFieldDidChange:(NSNotification *)note {
  if ([[self window] isKeyWindow] &&
      ([note object] == clientsSearchField)) {
    NSString *searchString = [[[note object] stringValue] lowercaseString];
    NSString *nameString, *emailString, *phoneString, *membershipString;
    id object;
    // revert to whole list of products
    if ( [searchString length] == 0 ) {
      [self setClientsInCreateProject:[[People sharedInstance] arrayForDictionary]];
      previousLengthOfPeopleSearchString = 0;
      [clientsTableView reloadData];
      return;
    }
    // this will hold our filtered list
    NSMutableArray *filteredObjects = [[NSMutableArray alloc] init];
    // if we back up, research the entire list
    if (previousLengthOfPeopleSearchString > [searchString length]) {
      [self setClientsInCreateProject:[[People sharedInstance] arrayForDictionary]];
    }
    // this needs to be exactly here, otherwise we won't iterate over the correct
    // set of objects
    NSEnumerator *e = [clientsInCreateProject objectEnumerator];
    while ( object = [e nextObject] ) {
      nameString = [[object personName] lowercaseString];
      emailString = [[object emailAddress] lowercaseString];
      phoneString = [[object phoneNumber] lowercaseString];
      membershipString = [[object memberType] lowercaseString];
      
      NSRange nameRange = [nameString rangeOfString:searchString options:NSLiteralSearch];
      NSRange emailRange = [emailString rangeOfString:searchString options:NSLiteralSearch];
      NSRange phoneRange = [phoneString rangeOfString:searchString options:NSLiteralSearch];
      NSRange membershipRange = [membershipString rangeOfString:searchString options:NSLiteralSearch];
      
      if (((emailRange.length) > 0) || ((nameRange.length) > 0) || ((phoneRange.length) > 0) || ((membershipRange.length) > 0)) {
        [filteredObjects addObject:object];
      }
    }
    [self setClientsInCreateProject:filteredObjects];
    [clientsTableView reloadData];
    previousLengthOfPeopleSearchString = [searchString length];
    [filteredObjects release];
  }
}

//******************************************************************************
// Actions
//******************************************************************************

- (IBAction) cancelButtonClicked:(id)sender {
  
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  } 
}

//******************************************************************************

- (void)setCreateCustomerController:(CreateCustomerController *)ccc {
  if (createCustomerController != ccc) {
    [ccc retain];
    [createCustomerController release];
    createCustomerController = ccc;
  }
}

- (IBAction) newButtonClicked:(id)sender {
  ////NSLog(@"newButtonClicked.");
  if (!createCustomerController) {
    CreateCustomerController *tmp =  [[CreateCustomerController alloc] init];
    [self setCreateCustomerController:tmp];
    [createCustomerController setMainWindow:[self window]];
    [createCustomerController setPeopleArrayController:clientsArrayController];
    [tmp release];
  }
  [createCustomerController setBypassDuplicatePerson:NO];
  [createCustomerController runCreateCustomerModal];
  
  Person *p = [[clientsArrayController selectedObjects] objectAtIndex:0];
  if (p != nil) {
    [[People sharedInstance] setObject:p forUid:[p uid]];
    [self setSelectedClient:p];
    [selectedClientTextField1 setStringValue:[p personName]];
    [selectedClientTextField2 setStringValue:[p personName]];
    [selectedClientTextField3 setStringValue:[p personName]];
    [pwcNextButton setEnabled:YES];
    [pwcNextButton performClick:self];
  }
}


/******************************************************************************/

- (IBAction) selectButtonClicked:(id)sender {
  ////NSLog(@"selectButtonClicked.");
  Person *p = [[clientsArrayController selectedObjects] objectAtIndex:0];
  if (![[p personName] isEqualToString:TljBkPosAnonymousClientName]) {
    [self setSelectedClient:p];
    [selectedClientTextField1 setStringValue:[p personName]];
    [selectedClientTextField2 setStringValue:[p personName]];
    [selectedClientTextField3 setStringValue:[p personName]];
    [pwcNextButton setEnabled:YES];
  } else {
    NSRunAlertPanel(@"Operation not permitted",@"You can't add a project to quick sale",
                    @"Continue", nil, nil);
  }
}

/******************************************************************************/

- (IBAction) startDatePickerClicked:(id)sender {
  NSDate *newDate = [startDatePicker dateValue];
  NSCalendarDate *newCDate = 
    [NSCalendarDate dateWithString:[newDate description]
                    calendarFormat:@"%Y-%m-%d %H:%M:%S %z"];
                   
  NSCalendarDate *thirtyDays = [newCDate dateByAddingYears:0 
                                                    months:0 
                                                      days:30
                                                     hours:0
                                                   minutes:0
                                                   seconds:0];
  
  NSString *endDateStr  = 
    [[thirtyDays descriptionWithCalendarFormat:@"%m/%d/%Y" timeZone:nil locale:nil]
      description];
  
  [endDateTextField1 setStringValue:endDateStr];
}

/******************************************************************************/

- (IBAction)standTimeStepperClicked:(id)sender {
  double standTime = [standTimeStepper doubleValue];
  [standTimeTextField setDoubleValue:standTime];
}

/******************************************************************************/

- (IBAction) printWaiverButtonClicked:(id)sender {
  ////NSLog(@"printWaiverButtonClicked.");
  bool success = [[FormPrinter sharedInstance] printFormWithName:TljBkPosLiabilityWaiverFormName];
  if (success) {
    [hasSignedWaiver setEnabled:YES];
    [printWaiverButton setEnabled:NO];
  } else {
    NSRunAlertPanel(@"Error Printing",@"There was an error printing, please  submit a bug.",@"Continue",nil,nil);
    [hasSignedWaiver setEnabled:YES];
  }
}

/******************************************************************************/

- (IBAction) hasSignedWaiverButtonClicked:(id)sender {
  ////NSLog(@"hasSignedWaiverButtonClicked."); 
  [selectedClient setHasSignedLiabilityWaiver:YES];
  [hasSignedWaiver setEnabled:NO];
  [pwcNextButton setEnabled:YES];
  [pwcNextButton setTitle:@"Done"]; 
  [personHasNotSignedTextField setHidden:YES];
  [instructionsTextField setHidden:YES];
}

/******************************************************************************/

- (IBAction)pwcNextButtonClicked:(id)sender {
  ////NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);
  [super pwcNextButtonClicked:sender];
  ////NSLog(@"pwcCurrentStep: %d", pwcCurrentStep);

  // (pwcCurrentStep == 2) 
  if ([[pwcNextButton title] isEqualToString:[NSString stringWithFormat:@"Done"]]) {

    if ([self runningModal]) {
      ////NSLog(@"stopping modal");
      [NSApp stopModal];
      ////NSLog(@"making mainWindow key and ordering front");
      [mainApplicationWindow makeKeyAndOrderFront:self];
    } else {
      ////NSLog(@"not running modal?");
      [[self window] close];
    }
        
    Bicycle *bike = [[Bicycle alloc] init];

    [bike setBicycleMake:[self lowercaseAndLatexSafeStringFromString:[[makeModelColorForm cellAtIndex:0] stringValue]]];
    [bike setBicycleModel:[self lowercaseAndLatexSafeStringFromString:[[makeModelColorForm cellAtIndex:1] stringValue]]];
    [bike setBicycleColor:[self lowercaseAndLatexSafeStringFromString:[[makeModelColorForm cellAtIndex:2] stringValue]]];
    [bike setBicycleType:[self lowercaseAndLatexSafeStringFromString:[typeComboBox stringValue]]];
    
    Project *project = [[Project alloc] init];
    [project setOwnerUid:[selectedClient uid]];
    [project setBicycle:bike];
    
    Invoice *inv = [[Invoice alloc] init];
    [project setInvoiceUid:[inv uid]];
    
    Product *prod = [[Product alloc] init];
    [prod setProductCode:@"project"];
    [prod setUid:[project uid]];
    [prod setProductName:[self lowercaseAndLatexSafeStringFromString:[bike shortDescription]]];
    [prod setProductPrice:[quoteTextField1 doubleValue]];
    [prod setProductTotal:[quoteTextField1 doubleValue]];
		[prod setTaxable:NO];
    [[inv items] addObject:prod];
    // hmm - this doesn't seem correct.
    [inv setInvoiceTotal:[quoteTextField1 doubleValue]];

     
    NSDate *newDate = [startDatePicker dateValue];
    NSCalendarDate *newCDate = 
      [NSCalendarDate dateWithString:[newDate description]
                      calendarFormat:@"%Y-%m-%d %H:%M:%S %z"];
    [project setStartDate:newCDate];
    [project setDateLastWorked:newCDate];
    
    NSCalendarDate *thirtyDays = [newCDate dateByAddingYears:0 
                                                      months:0 
                                                        days:30
                                                       hours:0
                                                     minutes:0
                                                     seconds:0];
    [project setFinishedDate:thirtyDays];
    [project setIsFinished:NO];
    [project setQuote:[quoteTextField1 doubleValue]];
    [project setStandTime:0.0];
    [project setNote:[self lowercaseAndLatexSafeStringFromTextView:noteTextView]];
    [project setStandTime:[standTimeTextField doubleValue]];
    // refactor warning
    [[selectedClient projectUids] addObject:[project uid]];

    // this was a bug
    [[selectedClient invoiceUids] addObject:[inv uid]];
    [inv setPersonUid:[selectedClient uid]];
    
    
    [[People sharedInstance] saveToDisk];
    [[Projects sharedInstance] setObject:project forUid:[project uid]];
    [[Invoices sharedInstance] setObject:inv forUid:[inv uid]];

    [self setNewProject:project];
    NSString *emptyString = [NSString stringWithFormat:@""];
    [[makeModelColorForm cellAtIndex:0] setStringValue:emptyString];
    [[makeModelColorForm cellAtIndex:1] setStringValue:emptyString];
    [[makeModelColorForm cellAtIndex:2] setStringValue:emptyString];
    [quoteTextField1 setStringValue:emptyString];
    [noteTextView setString:emptyString];
    [pwcTabView selectTabViewItemAtIndex:0];
    [pwcNextButton setTitle:@"Next"];
    
    [bike release];
    [project release];
    [inv release];
    [prod release];
    
    
  } else if ((pwcCurrentStep == 2) && [selectedClient hasSignedLiabilityWaiver]) {
    [pwcNextButton setTitle:@"Done"];
    [pwcNextButton setEnabled:YES];
  }
}

/******************************************************************************/

- (void)tabView:(NSTabView *)theTabView willSelectTabViewItem:
  (NSTabViewItem *)theTabViewItem {
  if (theTabView == pwcTabView) {
    [super tabView:theTabView willSelectTabViewItem:theTabViewItem];
    int currentView = [theTabView indexOfTabViewItem:theTabViewItem] ;
    if (currentView == 0) {
      [pwcTitleTextField setStringValue:@"Select Client"];
    } else if (currentView == 1) {
      [pwcTitleTextField setStringValue:@"Project Details"];
      if ([quoteTextField1 acceptsFirstResponder]) {
        [[self window] makeFirstResponder:quoteTextField1];
      }
    } else {
      // NSString *emptyString = [NSString stringWithFormat:@""];
      [pwcTitleTextField setStringValue:@"Project Summary"];
      
      
      [pwcNextButton setEnabled:NO];
      
      [personNameTextField setStringValue:[selectedClient personName]];
      NSString *str = [NSString stringWithFormat:@"%@ %@",
        [[makeModelColorForm cellAtIndex:0] stringValue],
        [[makeModelColorForm cellAtIndex:1] stringValue]];
      
      [makeModelTextField setStringValue:str];
      [colorTextField setStringValue:[[makeModelColorForm cellAtIndex:2] stringValue]];
      [typeTextField setStringValue:[typeComboBox stringValue]];
      [quoteTextField2 setStringValue:[quoteTextField1 stringValue]];
      
      NSDate *newDate = [startDatePicker dateValue];
      NSCalendarDate *newCDate = 
        [NSCalendarDate dateWithString:[newDate description]
                        calendarFormat:@"%Y-%m-%d %H:%M:%S %z"];
      
      NSString *startDateStr  = 
        [[newCDate descriptionWithCalendarFormat:@"%m/%d/%Y" timeZone:nil locale:nil]
          description];
      
      [startDateTextField setStringValue:startDateStr];
      [endDateTextField2 setStringValue:[endDateTextField1 stringValue]];
      //NSLog(@"note: %@", [noteTextView string]);
      [noteTextField setStringValue:[self lowercaseAndLatexSafeStringFromTextView:noteTextView]];
      bool waiverSigned = [selectedClient hasSignedLiabilityWaiver];
      
      [hasSignedWaiver setEnabled:NO];
      [hasSignedWaiver setState:waiverSigned];
      
      if (waiverSigned) {
        
        [hasSignedWaiver setHidden:NO];
        [personHasNotSignedTextField setHidden:YES];
        [instructionsTextField setHidden:YES];
        [printWaiverButton setHidden:YES];
        [pwcNextButton setEnabled:YES];
        
      } else {
        NSString *nameStr = [NSString stringWithFormat:@"%@ has not signed a Liability Waiver",
          [selectedClient personName]];
        [personHasNotSignedTextField setHidden:NO];
        
        [personHasNotSignedTextField setStringValue:nameStr];
        [instructionsTextField setHidden:NO];
        [printWaiverButton setHidden:NO];
        [printWaiverButton setEnabled:YES];
        [pwcNextButton setEnabled:NO];
      }
    }
    [self enableNextButtonWhenAppropriate:theTabViewItem];
  }
}


/******************************************************************************/

- (void)enableNextButtonWhenAppropriate:(NSTabViewItem *)item {
  NSString *emptyString = [NSString stringWithFormat:@""];
  int currentView = [pwcTabView indexOfTabViewItem: item];
  if (currentView == 1) {
    if (![emptyString isEqualToString:[[makeModelColorForm cellAtIndex:0] stringValue]] &&
        ![emptyString isEqualToString:[[makeModelColorForm cellAtIndex:1] stringValue]] &&
        ![emptyString isEqualToString:[[makeModelColorForm cellAtIndex:2] stringValue]] &&
        ![emptyString isEqualToString:[quoteTextField1 stringValue]]) {
      [pwcNextButton setEnabled:YES];
      [pwcNextButton setState:1];
    } else {
      [pwcNextButton setEnabled:NO];
      [pwcNextButton setState:0];
    }
  }
}

//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<CreateProjectController>"];
}

//******************************************************************************
// accessor
//******************************************************************************

- (NSWindow *)mainApplicationWindow {
  return mainApplicationWindow;
}

- (NSMutableArray *)clientsInCreateProject {
  return clientsInCreateProject;
}

- (Person *)selectedClient {
  return selectedClient;
}

- (Bicycle *)selectedBicycle {
  return selectedBicycle;
}

- (Project *)newProject {
  return newProject;
}

- (bool)runningModal {
  return runningModal;
}

//******************************************************************************
// setter
//******************************************************************************

- (void)setMainApplicationWindow:(NSWindow *)mainWindow {
  [mainWindow retain];
  [mainApplicationWindow release];
  mainApplicationWindow = mainWindow;
}

- (void)setClientsInCreateProject:(NSMutableArray *)array {
  if (clientsInCreateProject != array) {
    [clientsInCreateProject release];
    clientsInCreateProject = [array mutableCopy];
  }
}

- (void)setSelectedClient:(Person *)client {
  if (client != selectedClient) {
    [selectedClient release];
    [client retain];
    selectedClient = client;
  }
}

- (void)setSelectedBicycle:(Bicycle *)bicycle {
  if (bicycle != selectedBicycle) {
    [selectedBicycle release];
    [bicycle retain];
    selectedBicycle = bicycle;
  }
}

- (void)setNewProject:(Project *)project {
  if (project != newProject) {
    [newProject release];
    [project retain];
    newProject = project;
  }
}

- (void)setRunningModal:(bool)modal {
  runningModal = modal;
}

@end
