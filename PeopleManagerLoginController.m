//
//  PeopleManagerLoginController.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/23/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PeopleManagerLoginController.h"

@implementation PeopleManagerLoginController

- (id)init {
  self = [super init];
  if (self != nil) {
    self =  [super initWithWindowNibName:@"CustomeManagerLogin"];
    peopleManagerPassword = @"bici";
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [mainApplicationWindow release];
  [peopleController release];
  [super dealloc];
}

//******************************************************************************
// awakeFromNib
//******************************************************************************

- (void)awakeFromNib {
  
}

//******************************************************************************
// accessors
//******************************************************************************

- (NSWindow *)mainApplicationWindow {
  return mainApplicationWindow;
}

//******************************************************************************
// setters
//******************************************************************************

- (void)setMainApplicationWindow:(NSWindow *)mainWindow {
  [mainWindow retain];
  [mainApplicationWindow release];
  mainApplicationWindow = mainWindow;
}

- (void)setPeopleController:(PeopleController *)pc {
  [pc retain];
  [peopleController release];
  peopleController = pc;
}

//******************************************************************************
// authentication
//******************************************************************************

- (void)runPeopleManagerLoginModal {
  [NSApp beginSheet:[self window]
     modalForWindow:mainApplicationWindow
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];
  
  [NSApp runModalForWindow:[self window]];
  
  [NSApp endSheet:[self window]];
  [[self window] orderOut:self];
  if ([peopleManagerLoginTextField acceptsFirstResponder]) {
    [[self window] makeFirstResponder:peopleManagerLoginTextField];
  }
}

- (IBAction)cancelLoginAttempt:(id)sender {
  NSString *emptyString = [NSString stringWithFormat:@""];
  [peopleManagerLoginTextField setStringValue:emptyString];
  [NSApp stopModal];
}

- (IBAction)loginButtonPressed:(id)sender {
  NSString *emptyString = [NSString stringWithFormat:@""];
  NSString *passwordEntered = [peopleManagerLoginTextField stringValue];
  [peopleManagerLoginTextField setStringValue:emptyString];
  [NSApp stopModal];
  if ([peopleManagerPassword isEqualToString:passwordEntered]) {
    if (!peopleController) {
      PeopleController *tmp = [[PeopleController alloc] init];
      [self setPeopleController:tmp];
      [tmp release];
    }
    [peopleManagerLoginFailedTextField setStringValue:emptyString];
    //NSLog(@"before setupForNonModal");
    //[peopleController awakeFromNib];
    [peopleController showWindow:self];
    [peopleController setupForNonModal];
  
  } else {
    [peopleManagerLoginFailedTextField setStringValue:@"Login failed"];
    NSString *message = [NSString stringWithFormat:@"Login failed."];
    int choice = NSRunAlertPanel(@"Authorization failed",
                                 message,@"Try Again",@"Cancel Login Attempt",
                                 nil);
    if (choice == 1) {
      if ([peopleManagerLoginTextField acceptsFirstResponder]) {
        [[self window] makeFirstResponder:peopleManagerLoginTextField];
      }
      [self runPeopleManagerLoginModal];
    } else {
      [peopleManagerLoginFailedTextField setStringValue:emptyString];
    }   
  }
}
@end
