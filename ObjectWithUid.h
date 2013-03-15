//
//  ObjectWithUid.h
//  UidGeneratorTest
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class UidGenerator;

@interface ObjectWithUid : NSObject <NSCoding> {
  NSString *uid;
}

- (NSString *)uid;
- (void)setUid:(NSString *)newUid;


- (bool)uid:(NSString *)uid1 isEqual:(NSString *)uid2;
- (bool)samep:(ObjectWithUid *)o2;
- (bool)object:(ObjectWithUid *)o1 isEqual:(ObjectWithUid *)o2;
- (bool)samep:(ObjectWithUid *)owu;
- (bool)array:(NSArray *)array containsUid:(NSString *)aUid;
- (bool)dictionary:(NSDictionary *)dict containsObjectForUid:(NSString *)aUid;
- (NSMutableArray *)newArrayByRemovingUid:(NSString *)aUid fromArray:(NSMutableArray *)array;
- (NSMutableArray *)newArrayByRemovingUids:(NSArray *)uids fromArray:(NSMutableArray *)array;
- (void)removeObjectWithUid:(NSString *)aUid fromArray:(NSMutableArray *)array;
- (void)removeObjectWithUid:(NSString *)aUid fromArrayOfUids:(NSMutableArray *)array;
- (int)indexOfObjectWithUid:(NSString *)aUid inArrayOfUids:(NSArray *) array;
- (int)indexOfObjectWithUid:(NSString *)aUid inArray:(NSArray *) array;

- (NSString *)toCsv;
+ (id)fromCsv:(NSString *)str;                                    

@end
