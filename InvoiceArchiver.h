//
//  InvoiceArchiver.h
//  BicycleKitchenPOS
//
//  Created by moody on 11/26/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FTSWAbstractSingleton.h"
#import "Invoice.h"


@interface InvoiceArchiver : FTSWAbstractSingleton {
  NSString *pathToInvoiceArchive;
  NSString *pathToTodaysArchive;
  NSString *pathToLatexBuild;
}

+ (InvoiceArchiver *)sharedInstance;

- (NSString *)pathToInvoiceArchive;
- (void)setPathToInvoiceArchive:(NSString *)path;
- (NSString *)pathToTodaysArchive;
- (void)setPathToTodaysArchive:(NSString *)path;
- (NSString *)pathToLatexBuild;
- (void)setPathToLatexBuild:(NSString *)path;
- (NSString *)archivePathForToday;
- (NSString *)pathToTexBuildFile;
- (NSString *)pathToTexBuildDir;
- (NSString *)pathToOldPdfFile;
- (NSString *)pathToNewPdfFile:(Invoice *)inv;
- (NSString *)pathToLispFile:(Invoice *)inv;

- (void)archiveInvoice:(Invoice *)inv andPrint:(bool)print;
- (void)printInvoice:(Invoice *)inv;
- (void)printFileAtPath:(NSString *)path;
- (NSData *)lispDataForInvoice:(Invoice *)inv;
- (NSData *)latexTemplateForInvoice:(Invoice *)inv;
- (NSTask *)makeLatexTaskInDirectory:(NSString *)dir usingPath:(NSString *)path;
- (NSString *)filenameForInvoice:(Invoice *)inv withExtension:(NSString *)ext;
- (NSString *)invoiceStatus:(Invoice *)inv;

- (NSData *)stringToData:(NSString *)str;
- (void)appendData:(NSMutableData *)md withData:(NSData *)d;
- (void)addString:(NSString *)str toData:(NSMutableData *)d;

- (bool)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;



@end
