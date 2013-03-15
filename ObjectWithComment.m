//
//  ObjectWithComment.m
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "ObjectWithComment.h"
#import "OWCClassDescription.h"

@implementation ObjectWithComment

+ (void) initialize {
  if ( self == [ObjectWithComment class] ) {
    id superDescription = [[self superclass] classDescription];
    NSArray *attributeKeys = [superDescription attributeKeys];
    NSDictionary *typeForKey = [superDescription typeForKey];
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:attributeKeys];
    NSMutableDictionary *superTypes = [NSMutableDictionary dictionaryWithDictionary:typeForKey];
    OWCClassDescription *cd = [[OWCClassDescription alloc] init];
    [superAttributes addObjectsFromArray:[NSArray arrayWithObjects:@"commentAuthorName",@"commentSubject",@"commentText",nil]];
    [superTypes setObject:LjStringType forKey:@"commentAuthorName"];
    [superTypes setObject:LjStringType forKey:@"commentSubject"];
    [superTypes setObject:LjStringType forKey:@"commentText"];
    [cd setAttributeKeys:superAttributes];
    [cd setTypeForKey:superTypes];
    [NSClassDescription registerClassDescription:cd forClass:[self class]];
    [cd release];
  }
}

- (id) init {
  self = [super init];
  if (self != nil) {
    // hmm
    [self setCommentAuthorName:@""];
    [self setCommentSubject:@""];
    [self setCommentText:@""];
  }
  return self;
}


//******************************************************************************
// dealloc
//******************************************************************************
- (void)dealloc {
  [commentSubject release];
  [commentAuthorName release];
  [commentText release];
  [super dealloc];
}

//******************************************************************************
// encode
//******************************************************************************

- (void)encodeWithCoder:(NSCoder *)coder {
  [super encodeWithCoder:coder];
  [coder encodeObject:commentAuthorName forKey:@"commentAuthorName"];
  [coder encodeObject:commentSubject forKey:@"commentSubject"];
  [coder encodeObject:commentText forKey:@"commentText"];
}

//******************************************************************************
// decode
//******************************************************************************

- (id)initWithCoder:(NSCoder *)coder {
  [super initWithCoder:coder];
  [self setCommentAuthorName:[coder decodeObjectForKey:@"commentAuthorName"]];
  [self setCommentSubject:[coder decodeObjectForKey:@"commentSubject"]];
  [self setCommentText:[coder decodeObjectForKey:@"commentText"]];
  return self;
}

//******************************************************************************
// accessors
//******************************************************************************

- (NSString *)commentAuthorName {
  return commentAuthorName;
}

- (NSString *)commentSubject {
  return commentSubject;
}

- (NSString *)commentText {
  return commentText;
}

//******************************************************************************
// setters
//******************************************************************************

- (void)setCommentAuthorName:(NSString *)authorName {
  authorName = [authorName copy];
  [commentAuthorName release];
  commentAuthorName = authorName;
}

- (void)setCommentSubject:(NSString *)subject {
  subject = [subject copy];
  [commentSubject release];
  commentSubject = subject;
}

- (void)setCommentText:(NSString *)text {
  text = [text copy];
  [commentText release];
  commentText = text;
}

@end
