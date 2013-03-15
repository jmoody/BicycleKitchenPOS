//
//  ObjectWithComment.h
//  AnotherApp
//
//  Created by moody on 6/5/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ObjectWithDate.h"

@interface ObjectWithComment : ObjectWithDate {

  NSString *commentAuthorName;
  NSString *commentSubject;
  NSString *commentText;
}

- (NSString *)commentAuthorName;
- (NSString *)commentSubject;
- (NSString *)commentText;

- (void)setCommentAuthorName:(NSString *)name;
- (void)setCommentSubject:(NSString *)subject;
- (void)setCommentText:(NSString *)text;


@end
