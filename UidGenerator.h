//
//  UidGenerator.h
//  UidGeneratorTest
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UidGenerator : NSObject {
  int uidCount;
}

-(int) uidCount;

-(void) setUidCount:(int)newCount;

-(NSString *) generateUid;

+(id)sharedInstance;


@end
