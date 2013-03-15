//
//  PeopleManagerLoginController.h
//  BicycleKitchenPOS
//
//  Created by moody on 7/23/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PeopleController.h"

@interface PeopleManagerLoginController : NSWindowController {
  // Product Manager Authentication
  NSString *peopleManagerPassword;
  IBOutlet NSButton *peopleManagerLoginButton;
  IBOutlet NSButton *peopleManagerCancelButton;
  IBOutlet NSSecureTextField *peopleManagerLoginTextField;
  IBOutlet NSTextField *peopleManagerLoginFailedTextField;
  
  // pointer to main application window
  NSWindow *mainApplicationWindow;
  // pointer to productController in AppController
  PeopleController *peopleController;
}

- (NSWindow *)mainApplicationWindow;
- (void)setMainApplicationWindow:(NSWindow *)mainWindow;
- (void)setPeopleController:(PeopleController *)pc;


  // Authentication
- (IBAction)cancelLoginAttempt:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (void)runPeopleManagerLoginModal;

@end