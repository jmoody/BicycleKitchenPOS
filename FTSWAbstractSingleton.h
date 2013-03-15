//
//  FTSWAbstractSingleton.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/24/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FTSWAbstractSingleton : NSObject {

}

+ (id)singleton;
+ (id)singletonWithZone:(NSZone*)zone;

  //designated initializer, subclasses must implement and call supers implementation
- (id)initSingleton; 

@end
