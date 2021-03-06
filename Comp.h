// 
// Comp.h
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import <Cocoa/Cocoa.h>
#import "ObjectWithComment.h"
#import "Invoice.h"
#import "Person.h"
#import "Book.h"
@interface Comp : ObjectWithComment {
NSString *personUid;
NSMutableArray *items;
NSString *bookUid;
NSString *pathToPdfArchive;
}


//******************************************************************************
// prototypes
//******************************************************************************
- (NSString *)personUid;
- (void)setPersonUid:(NSString *)arg;
- (NSMutableArray *)items;
- (void)setItems:(NSArray *)arg;
- (NSString *)bookUid;
- (void)setBookUid:(NSString *)arg;
- (NSString *)pathToPdfArchive;
- (void)setPathToPdfArchive:(NSString *)arg;

//******************************************************************************
// misc
//******************************************************************************
- (Person *)personForComp;
- (Book *)bookForComp;
- (NSString *)personName;
- (NSString *)personPhone;
- (NSString *)personEmail;
- (NSString *)personCompany;
- (NSString *)personAddress;
- (NSString *)personCity;
- (NSString *)personState;
- (NSString *)personZip;
- (NSString *)cookNameOrInitials;
- (NSString *)reason;
- (NSString *)note;
- (double)valueOfComp;
- (double)taxableValue;
- (double)untaxableValue;

@end