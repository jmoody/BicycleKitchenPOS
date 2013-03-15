/* BugReportController */

#import <Cocoa/Cocoa.h>
#import "BasicWindowController.h"

@interface BugReportController : BasicWindowController
{
    IBOutlet NSTextView *bodyTextView;
    IBOutlet NSButton *cancelButton;
    IBOutlet NSTextField *cookTextField;
    IBOutlet NSDatePicker *datePicker;
    IBOutlet NSTextField *subjectTextField;
    IBOutlet NSButton *submitButton;
}

- (void)handleTextFieldChanges:(NSNotification *)note;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)datePickerClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;
@end
