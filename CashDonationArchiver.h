//
//  CashDonationArchiver.h
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"
#import "CashDonationArchiver.h"
#import "Donation.h"

@interface CashDonationArchiver : FTSWAbstractSingleton {
  NSString *pathToDonationArchive;
  NSString *pathToTodaysArchive;
  NSString *pathToLatexBuild;
}

+ (CashDonationArchiver *)sharedInstance;

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
- (NSString *)pathToNewPdfFile:(Donation *)don;

- (void)archiveDonation:(Donation *)don andPrint:(bool)print;
- (void)printInKindDonation:(Donation *)don;
- (void)printFileAtPath:(NSString *)path;
- (NSData *)latexTemplateForDonation:(Donation *)don;
- (NSTask *)makeLatexTaskInDirectory:(NSString *)dir usingPath:(NSString *)path;
- (NSString *)filenameForDonation:(Donation *)don withExtension:(NSString *)ext;


- (NSData *)stringToData:(NSString *)str;
- (void)appendData:(NSMutableData *)md withData:(NSData *)d;
- (void)addString:(NSString *)str toData:(NSMutableData *)d;

- (bool)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;

@end
