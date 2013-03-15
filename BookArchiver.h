//
//  BookArchiver.h
//  BicycleKitchenPOS
//
//  Created by moody on 12/20/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"
#import "Book.h"


@interface BookArchiver : FTSWAbstractSingleton {
  NSString *pathToBookArchive;
  NSString *pathToTodaysArchive;
  NSString *pathToLatexBuild;
}

+ (BookArchiver *)sharedInstance;

- (NSString *)pathToBookArchive;
- (void)setPathToBookArchive:(NSString *)path;
- (NSString *)pathToTodaysArchive;
- (void)setPathToTodaysArchive:(NSString *)path;
- (NSString *)pathToLatexBuild;
- (void)setPathToLatexBuild:(NSString *)path;
- (NSString *)archivePathForToday;
- (NSString *)pathToTexBuildFile;
- (NSString *)pathToTexBuildDir;
- (NSString *)pathToOldPdfFile;
- (NSString *)pathToNewPdfFile:(Book *)inv;
- (NSString *)pathToLispFile:(Book *)inv;

- (void)archiveBook:(Book *)inv andPrint:(bool)print;
- (void)printBook:(Book *)inv;
- (void)printFileAtPath:(NSString *)path;
- (NSData *)lispDataForBook:(Book *)inv;
- (NSData *)latexTemplateForBook:(Book *)inv;
- (NSTask *)makeLatexTaskInDirectory:(NSString *)dir usingPath:(NSString *)path;
- (NSString *)filenameForBook:(Book *)inv withExtension:(NSString *)ext;


- (NSData *)stringToData:(NSString *)str;
- (void)appendData:(NSMutableData *)md withData:(NSData *)d;
- (void)addString:(NSString *)str toData:(NSMutableData *)d;

- (bool)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;



@end
