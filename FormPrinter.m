//
//  FormPrinter.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "FormPrinter.h"
NSString *TljBkPosLiabilityWaiverFormName = @"liability-waiver.pdf";
NSString *TljBkPosInKindDonationFromName = @"in-kind-donation-form.pdf";

@implementation FormPrinter

+ (FormPrinter *)sharedInstance {
  static FormPrinter *s_MySingleton = nil;
  
  @synchronized([FormPrinter class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  if (self = [super initSingleton]) {
    [self setPathToForms:@"/Library/Application Support/BicycleKitchenPOS/forms"];
  }
  return self;
}


- (void) dealloc {
  [pathToForms release];
  [super dealloc];
}

- (NSString *)pathToForms {
  return pathToForms;
}

- (void)setPathToForms:(NSString *)path {
  path = [path copy];
  [pathToForms release];
  pathToForms = path;
}

- (bool)printFormWithName:(NSString *)formName {
  NSString *pathString = [[NSString stringWithFormat:@"%@/%@", pathToForms, formName] stringByStandardizingPath];
  //NSLog(@"pathString: %@", pathString);
  
  NSFileManager *nsfm = [NSFileManager defaultManager];
  if ([nsfm fileExistsAtPath:pathString]) {
    NSTask *lpr = [[NSTask alloc] init];
    [lpr setLaunchPath:@"/usr/bin/lpr"];
    [lpr setArguments:[NSArray arrayWithObject:pathString]];
    [lpr launch];
    [lpr waitUntilExit];
    [lpr release];
    return YES;
  } else {
    return NO;
  }
}
 
@end
