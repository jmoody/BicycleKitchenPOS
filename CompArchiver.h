//
//  CompArchiver.h
//  BicycleKitchenPOS
//
//  Created by moody on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"
#import "Comp.h"


@interface CompArchiver : FTSWAbstractSingleton {
  NSString *pathToCompArchive;
  NSString *pathToTodaysArchive;
  NSString *pathToLatexBuild;
}

+ (CompArchiver *)sharedInstance;

- (NSString *)pathToCompArchive;
- (void)setPathToCompArchive:(NSString *)path;
- (NSString *)pathToTodaysArchive;
- (void)setPathToTodaysArchive:(NSString *)path;
- (NSString *)pathToLatexBuild;
- (void)setPathToLatexBuild:(NSString *)path;
- (NSString *)archivePathForToday;
- (NSString *)pathToTexBuildFile;
- (NSString *)pathToTexBuildDir;
- (NSString *)pathToOldPdfFile;
- (NSString *)pathToNewPdfFile:(Comp *)comp;
- (NSString *)pathToLispFile:(Comp *)comp;

- (void)archiveComp:(Comp *)comp andPrint:(bool)print;
- (void)printComp:(Comp *)comp;
- (void)printFileAtPath:(NSString *)path;
- (NSData *)lispDataForComp:(Comp *)comp;
- (NSData *)latexTemplateForComp:(Comp *)comp;
- (NSTask *)makeLatexTaskInDirectory:(NSString *)dir usingPath:(NSString *)path;
- (NSString *)filenameForComp:(Comp *)comp withExtension:(NSString *)ext;


- (NSData *)stringToData:(NSString *)str;
- (void)appendData:(NSMutableData *)md withData:(NSData *)d;
- (void)addString:(NSString *)str toData:(NSMutableData *)d;

- (bool)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;

@end