#import "BugReportController.h"

@implementation BugReportController
- (id) init {
  self = [super init];
  if (self != nil) {
    self =  [super initWithWindowNibName:@"BugReportWindow"];
  }
  return self;
}

- (void) dealloc {

  [super dealloc];
}

- (void)setupForNonModal {
  [super setupForNonModal];
  [self clearTextField:cookTextField];
  [self clearTextField:subjectTextField];
  [self clearTextView:bodyTextView];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
  [submitButton setEnabled:NO];
}

- (void)setupForModal {
  [super setupForModal];
  [self clearTextField:cookTextField];
  [self clearTextField:subjectTextField];
  [self clearTextView:bodyTextView];
  [datePicker setDateValue:[NSCalendarDate calendarDate]];
  [submitButton setEnabled:NO];
}

- (void)runNonModal:(id)sender {
  [super runNonModal:sender];
}

- (IBAction)cancelButtonClicked:(id)sender {
  ////NSLog(@"cancelButtonClicked");
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}

- (IBAction)datePickerClicked:(id)sender {
  ////NSLog(@"datePickerClicked");
  
}

- (IBAction)submitButtonClicked:(id)sender {
  //cat < foo | mail -s "well" moody@isi.edu
 // //NSLog(@"submitButtonClicked");
  NSString *cook = [cookTextField stringValue];
  NSString *subject = [subjectTextField stringValue];
  NSString *body = [bodyTextView string];
  NSString *pathToEmail = @"/Library/Application Support/BicycleKitchenPOS/mail/bugs";
  NSCalendarDate *date = [self calendarDateFromDatePicker:datePicker];
  NSString *dateStr = [date descriptionWithCalendarFormat:@"%Y%m%d%I%M%S"];
  NSString *filename = [NSString stringWithFormat:@"%@-%@", dateStr, cook];
  pathToEmail = [[NSString stringWithFormat:@"%@/%@", pathToEmail, filename] stringByStandardizingPath];

  
  NSFileManager *nsfm = [NSFileManager defaultManager];
  [nsfm createFileAtPath:pathToEmail
                contents:[body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]
              attributes:nil];
  
  NSCalendarDate *twoSeconds = [date dateByAddingYears:0
                                                months:0 
                                                  days:0 
                                                 hours:0
                                               minutes:0 
                                               seconds:2];
  while (![nsfm fileExistsAtPath:pathToEmail]) {
    ////NSLog(@"in while");
    [NSThread sleepUntilDate:twoSeconds];
  }  
  
  NSTask *mail = [[NSTask alloc] init];
  
  [mail setLaunchPath:@"/bin/sh"];
	NSString *carg = [NSString stringWithFormat:@"-c"];
	NSString *catArg = [NSString stringWithFormat:@"cat < /Library/Application\\ Support/BicycleKitchenPOS/mail/bugs/%@ | mail -s \"[Bug] %@: %@\" moody@isi.edu",
		filename, cook, subject];
		
  NSArray *args = [NSArray arrayWithObjects:carg, catArg, nil];
	[mail setArguments:args];
  
  [mail launch];
  
  [mail release];
  if (runningModal) {
    [self stopModalAndCloseWindow];
  } else {
    [[self window] close];
  }
}


- (void)handleTextFieldChanges:(NSNotification *)note {
//  //NSLog(@"handleTextFieldChanges");
//  NSString *cook = [cookTextField stringValue];
//  NSString *subject = [subjectTextField stringValue];
//  NSString *body = [bodyTextView string];
//  //NSLog(@"cook: %@", cook);
//  //NSLog(@"subject: %@", subject);
//  //NSLog(@"body: %@", body);
  
  if ([[self window] isMainWindow] || [[self window] isKeyWindow]) {
    // enable the submit button if the fields are valid.
    if ([self textFieldIsEmpty:cookTextField] ||
        [self textFieldIsEmpty:subjectTextField] ||
        [self textViewIsEmpty:bodyTextView]) {
      [submitButton setEnabled:NO];
    } else {
      [submitButton setEnabled:YES];
    }
  }
}


- (void) textDidChange: (NSNotification *)notifications {
  //NSLog(@"in textDidChange");
  if ([notifications object] == bodyTextView) {
    [self handleTextFieldChanges:notifications];
  } 
}

- (void)setupNotificationObservers {
  // NSComboBoxSelectionDidChangeNotification
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  
  // information  
  [nc addObserver:self 
         selector:@selector(handleTextFieldChanges:)
             name:NSControlTextDidChangeNotification
           object:subjectTextField];
  
  [nc addObserver:self 
         selector:@selector(handleTextFieldChanges:)
             name:NSControlTextDidChangeNotification
           object:cookTextField];

  [nc addObserver:self 
         selector:@selector(handleTextFieldChanges:)
             name:NSControlTextDidChangeNotification
           object:bodyTextView];
  
  
}

@end
