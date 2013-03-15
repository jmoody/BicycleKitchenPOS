//
//  FormPrinter.h
//  BicycleKitchenPOS
//
//  Created by moody on 12/10/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"
extern NSString *TljBkPosLiabilityWaiverFormName;
extern NSString *TljBkPosInKindDonationFromName;

@interface FormPrinter : FTSWAbstractSingleton {

  NSString *pathToForms;
  
}
+ (FormPrinter *)sharedInstance;

- (NSString *)pathToForms;
- (void)setPathToForms:(NSString *)path;

- (bool)printFormWithName:(NSString *)formName;


@end
