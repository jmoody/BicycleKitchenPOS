//
//  InKindDonationArchiver.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"
#import "InKindDonation.h"

@interface InKindDonationArchiver : FTSWAbstractSingleton {
  NSString *pathToDonationArchive;
  NSString *pathToTodaysArchive;
  NSString *pathToLatexBuild;
}

+ (InKindDonationArchiver *)sharedInstance;

- (NSString *)pathToDonationArchive;
- (void)setPathToDonationArchive:(NSString *)path;
- (NSString *)pathToTodaysArchive;
- (void)setPathToTodaysArchive:(NSString *)path;
- (NSString *)pathToLatexBuild;
- (void)setPathToLatexBuild:(NSString *)path;
- (NSString *)archivePathForToday;
- (NSString *)pathToTexBuildFile;
- (NSString *)pathToTexBuildDir;
- (NSString *)pathToOldPdfFile;
- (NSString *)pathToNewPdfFile:(InKindDonation *)don;

- (void)archiveDonation:(InKindDonation *)don andPrint:(bool)print;
- (void)printInKindDonation:(InKindDonation *)don;
- (void)printFileAtPath:(NSString *)path;
- (NSData *)latexTemplateForDonation:(InKindDonation *)don;
- (NSTask *)makeLatexTaskInDirectory:(NSString *)dir usingPath:(NSString *)path;
- (NSString *)filenameForInKindDonation:(InKindDonation *)don withExtension:(NSString *)ext;


- (NSData *)stringToData:(NSString *)str;
- (void)appendData:(NSMutableData *)md withData:(NSData *)d;
- (void)addString:(NSString *)str toData:(NSMutableData *)d;

- (bool)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;

@end
