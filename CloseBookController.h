//
//  CloseBookController.h
//  BicycleKitchenPOS
//
//  Created by moody on 12/18/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProgressiveWindowController.h"
#import "Book.h"

@interface CloseBookController : ProgressiveWindowController {

  //variables
  NSMutableArray *checksArray;
  NSMutableArray *cardsArray;
  NSMutableArray *creditsArray;
  
  NSMutableDictionary *formAndStepper;
  
  
  // variables
  IBOutlet NSTableView *checksTableView;
  IBOutlet NSArrayController *checksArrayController;
  IBOutlet NSTableView *cardsTableView;
  IBOutlet NSArrayController *cardsArrayController;
  IBOutlet NSForm *cashForm;
  IBOutlet NSStepper *hundredsStepper;
  IBOutlet NSStepper *fiftiesStepper;
  IBOutlet NSStepper *twentiesStepper;
  IBOutlet NSStepper *tensStepper;
  IBOutlet NSStepper *fivesStepper;
  IBOutlet NSStepper *twosStepper;
  IBOutlet NSStepper *onesStepper;
  IBOutlet NSTextField *hundredsTextField;
  IBOutlet NSTextField *fiftiesTextField;
  IBOutlet NSTextField *twentiesTextField;
  IBOutlet NSTextField *tensTextField;
  IBOutlet NSTextField *fivesTextField;
  IBOutlet NSTextField *twosTextField;
  IBOutlet NSTextField *onesTextField;
  IBOutlet NSForm *totalsForm;
  IBOutlet NSTextField *initialsTextField;
  IBOutlet NSButton *cancelButton;
  IBOutlet NSButton *printAndSaveButton;
  IBOutlet NSButton *pulledStartingBalanceButton;
  IBOutlet NSTextField *numCooksTextField;
  IBOutlet NSStepper *numCooksStepper;
  IBOutlet NSTextField *numHoursTextField;
  IBOutlet NSStepper *numHoursStepper;
  IBOutlet NSTextField *numVolunteerHours;
  IBOutlet NSTableView *creditsTableView;
  IBOutlet NSArrayController *creditsArrayController;
  IBOutlet NSTextField *cashTotalsTextField;
  
  IBOutlet NSTextField *numClientsTextField;
  IBOutlet NSStepper *clientsStepper;
  IBOutlet NSButton *verfiedChecksButton;
  IBOutlet NSButton *verfiedCardsButton;
  IBOutlet NSButton *verfiedCreditsButton;
  IBOutlet NSButton *clientsFiveButton;
  IBOutlet NSButton *clientsTenButton;
  IBOutlet NSButton *clientsTwentyButton;
  IBOutlet NSButton *clientsClearButton;
}  
  
  
//proto-types
- (NSMutableArray *)checksArray;
- (void)setChecksArray:(NSArray *)arg;
- (NSMutableArray *)cardsArray;
- (void)setCardsArray:(NSMutableArray *)arg;
- (NSMutableDictionary *)formAndStepper;
- (void)setFormAndStepper:(NSDictionary *)arg;
- (NSMutableArray *)creditsArray;
- (void)setCreditsArray:(NSArray *)arg;


// prototypes
- (IBAction)hundredsStepperClicked:(id)sender;
- (IBAction)fiftiesStepperClicked:(id)sender;
- (IBAction)twentiesStepperClicked:(id)sender;
- (IBAction)tensStepperClicked:(id)sender;
- (IBAction)fivesStepperClicked:(id)sender;
- (IBAction)twosStepperClicked:(id)sender;
- (IBAction)onesStepperClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)pulledStartingBalanceButtonClicked:(id)sender;
- (IBAction)numCooksStepperClicked:(id)sender;
- (IBAction)numHoursStepperClicked:(id)sender;
- (IBAction)printAndSaveButtonClicked:(id)sender;
- (IBAction)clientsStepperClicked:(id)sender;
- (IBAction)verfiedChecksButtonClicked:(id)sender;
- (IBAction)verfiedCardsButtonClicked:(id)sender;
- (IBAction)verfiedCreditsButtonClicked:(id)sender;
- (IBAction)clientsFiveButtonClicked:(id)sender;
- (IBAction)clientsTenButtonClicked:(id)sender;
- (IBAction)clientsTwentyButtonClicked:(id)sender;
- (IBAction)clientsClearButtonClicked:(id)sender;


// handlers
- (void)handleTextFieldChange:(NSNotification *)note;

- (void)doSetup;
- (void)setChecksCardsInvoicesAndTotals;
- (double)totalCash;
- (double)totalCheck;
- (double)totalCards;
- (double)totalCredits;
- (double)actualTotal;
- (double)expectedTotal;
- (double)variance;

- (NSArray *)arrayWithCell:(NSFormCell *)cell stepper:(NSStepper *)stepper 
                 textField:(NSTextField *) tf scalar:(NSNumber *)num;

- (void)initFormsAndSteppers;
- (void)resetFormsAndSteppers;
- (void)setupButtons;

- (void)clearTextFields;
- (void)stepperClicked;
- (void)enableNextButtonWhenAppropriate:(NSTabViewItem *)item;



@end
