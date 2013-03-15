//
//  ProductManagerLoginController.h
//  BicycleKitchenPOS
//
//  Created by moody on 7/21/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProductController.h"

@interface ProductManagerLoginController : NSWindowController {
  // Product Manager Authentication
  NSString *productManagerPassword;
  IBOutlet NSButton *productManagerLoginButton;
  IBOutlet NSButton *productManagerCancelButton;
  IBOutlet NSSecureTextField *productManagerLoginTextField;
  IBOutlet NSTextField *productManagerLoginFailedTextField;
  
  // pointer to main application window
  NSWindow *mainApplicationWindow;
  // pointer to productController in AppController
  ProductController *productController;
}

- (NSWindow *)mainApplicationWindow;
- (void)setMainApplicationWindow:(NSWindow *)mainWindow;
- (void)setProductController:(ProductController *)pc;


  // Authentication
- (IBAction)cancelLoginAttempt:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (void)runProductManagerLoginModal;

@end
