// 
// OWUClassDescription.h
// Generated by auto-coder 1.0
// copyright 2007 The Little Joy.  All rights reserved
#import <Cocoa/Cocoa.h>

extern NSString *LjArrayType;
extern NSString *LjIntType;
extern NSString *LjDoubleType;
extern NSString *LjStringType;
extern NSString *LjDateType;
extern NSString *LjDateFormat;
extern NSString *LjCalendarDateType;
extern NSString *LjCalendarDateFormat;
extern NSString *LjBooleanType;
extern NSString *LjFloatType;
extern NSString *LjOwuType;
extern NSString *LjOwuArrayType;
extern NSString *LjNewlineSubstitute;

@interface OWUClassDescription : NSClassDescription {
  NSArray *attributeKeys;
  NSDictionary *typeForKey;
}


//******************************************************************************
// prototypes
//******************************************************************************

- (void)setAttributeKeys:(NSArray *)arg;
- (NSDictionary *)typeForKey;
- (void) setTypeForKey:(NSDictionary *)arg;

//******************************************************************************
// misc
//******************************************************************************


@end