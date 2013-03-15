//
//  ProductManagerLoginController.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/21/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ProductManagerLoginController.h"


@implementation ProductManagerLoginController

- (id)init {
  self = [super init];
  if (self != nil) {
    self =  [super initWithWindowNibName:@"ProductManagerLogin"];
    productManagerPassword = @"bici";
  }
  return self;
}

//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [mainApplicationWindow release];
  [productController release];
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

- (void)setProductController:(ProductController *)pc {
  [pc retain];
  [productController release];
  productController = pc;
}

//******************************************************************************
// authentication
//******************************************************************************

- (void)runProductManagerLoginModal {
  
  [NSApp beginSheet:[self window]
     modalForWindow:mainApplicationWindow
      modalDelegate:nil
     didEndSelector:nil
        contextInfo:nil];
  
  [NSApp runModalForWindow:[self window]];
  
  [NSApp endSheet:[self window]];
  [[self window] orderOut:self];
  if ([productManagerLoginTextField acceptsFirstResponder]) {
    [[self window] makeFirstResponder:productManagerLoginTextField];
  }
}

- (IBAction)cancelLoginAttempt:(id)sender {
  NSString *emptyString = [NSString stringWithFormat:@""];
  [productManagerLoginTextField setStringValue:emptyString];
  [NSApp stopModal];
}

- (IBAction)loginButtonPressed:(id)sender {
  NSString *emptyString = [NSString stringWithFormat:@""];
  NSString *passwordEntered = [productManagerLoginTextField stringValue];
  [productManagerLoginTextField setStringValue:emptyString];
  [NSApp stopModal];
  if ([productManagerPassword isEqualToString:passwordEntered]) {
    if (!productController) {
      ProductController *tmp = [[ProductController alloc] init];
      [self setProductController:tmp];
      [tmp release];
    }
    [productManagerLoginFailedTextField setStringValue:emptyString];
    [productController setupForNonModal];
    [productController showWindow:self];
  } else {
    [productManagerLoginFailedTextField setStringValue:@"Login failed"];
    NSString *message = [NSString stringWithFormat:@"Login failed."];
    int choice = NSRunAlertPanel(@"Authorization failed",
                                 message,@"Try Again",@"Cancel Login Attempt",
                                 nil);
    if (choice == 1) {
      if ([productManagerLoginTextField acceptsFirstResponder]) {
        [[self window] makeFirstResponder:productManagerLoginTextField];
      }
      [self runProductManagerLoginModal];
    } else {
      [productManagerLoginFailedTextField setStringValue:emptyString];
    }   
  }
}

@end
