//
//  CashDonationArchiver.m
//  BicycleKitchenPOS
//
//  Created by moody on 1/7/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "CashDonationArchiver.h"
#import "InKindDonations.h"
#import "InKindDonationItem.h"
#import "People.h"
#import "PreferenceController.h"


@implementation CashDonationArchiver

+ (CashDonationArchiver *)sharedInstance {
  static CashDonationArchiver *s_MySingleton = nil;
  
  @synchronized([CashDonationArchiver class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  if (self = [super initSingleton]) {
    [self setPathToLatexBuild:@"/Library/Application Support/BicycleKitchenPOS/ArchivedCashDonations/latex-build"];
    [self setPathToDonationArchive:@"/Library/Application Support/BicycleKitchenPOS/ArchivedCashDonations"];
  }
  return self;
}

- (void) dealloc {
  [pathToDonationArchive release];
  [pathToTodaysArchive release];
  [pathToLatexBuild release];
  [super dealloc];
}

- (void)archiveDonation:(Donation *)don andPrint:(bool)print {
  // write for text output
  NSFileManager *nsfm = [NSFileManager defaultManager];
  [self setPathToTodaysArchive:[self archivePathForToday]];
  [nsfm createDirectoryAtPath:pathToTodaysArchive attributes:nil];
  
  NSString *texPath = [self pathToTexBuildFile];
  NSString *buildDir = [self pathToTexBuildDir];
  NSString *oldPdfPath =  [self pathToOldPdfFile];
  NSString *newPdfPath = [self pathToNewPdfFile:don];
 
  ////NSLog(@"newPdfPath %@", newPdfPath);
  // may not be necessary
  if ([nsfm fileExistsAtPath:texPath])  [nsfm removeFileAtPath:texPath handler:self];
  
  NSData *latexData = [self latexTemplateForDonation:don];
  
  // write the .tex file
  [nsfm createFileAtPath:texPath contents:latexData attributes:nil];
  // make the .pdf
  NSTask *task1 =  [self makeLatexTaskInDirectory:buildDir usingPath:texPath];
  [task1 launch];
  [task1 waitUntilExit];
  [task1 release];
  // do the task again so the columns are aligned
  NSTask *task2 = [self makeLatexTaskInDirectory:buildDir usingPath:texPath];
  [task2 launch];
  [task2 waitUntilExit];
  [task2 release];
  
  // move the .pdf to the archive
  if ([nsfm fileExistsAtPath:oldPdfPath]) {
    [nsfm movePath:oldPdfPath toPath:newPdfPath handler:self];
  } else {
    NSRunAlertPanel(@"Pdf was not created",@"Press Bug to send a bug report",@"Bug",@"Cancel",nil);
  }
  
  if (print) {
    [self printFileAtPath:newPdfPath];
  }
  
  [don setPathToPdfArchive:newPdfPath];
  [[InKindDonations sharedInstance] saveToDisk];
}

- (void)printInKindDonation:(Donation *)don {
    
  NSFileManager *nsfm = [NSFileManager defaultManager];  
  
  NSString *pathToPdf = [don pathToPdfArchive];
  
  if ([nsfm fileExistsAtPath:pathToPdf]) {
    [self printFileAtPath:pathToPdf];
  } else {
    NSRunAlertPanel(@"Pdf does not exist.",@"Press Bug to send a bug report",@"Bug",@"Cancel",nil);
  }
}

- (void)printFileAtPath:(NSString *)path {
  path = [path stringByStandardizingPath];
  NSTask *lpr = [[NSTask alloc] init];
  [lpr setLaunchPath:@"/usr/bin/lpr"];
  [lpr setArguments:[NSArray arrayWithObject:path]];
  [lpr launch];
  [lpr waitUntilExit];
  [lpr release];
}



- (NSData *)latexTemplateForDonation:(Donation *)don {
  Person *p = [[People sharedInstance] objectForUid:[don donorUid]];
  NSMutableData *tmp = [[NSMutableData alloc] init];
  [self addString:@"\\input kitchenCashDonation\n" toData:tmp];
  [self addString:@"\\begin{document}\n" toData:tmp];
  [self addString:@"\\fancyhead[L]{\\makeheader}\n" toData:tmp];
  NSMutableString *email = [NSMutableString stringWithString:[p emailAddress]];
  NSRange range = NSMakeRange(0, [email length]);
  [email replaceOccurrencesOfString:@"_"
                         withString:@"\\_" 
                            options:NSCaseInsensitiveSearch 
                              range:range];
  NSLog(@"email: %@", email);
  [self addString:[NSString stringWithFormat:@"\\dateandname{%@}{%@}{%@}{%@}{%@}{%@}{%@}{%@}\n",
    [[don date] descriptionWithCalendarFormat:@"%m/%d/%Y"],
    [don personName], [don companyName], [don address],
    [NSString stringWithFormat:@"%@, %@ %@", [don city], [don addressState], [don zip]],
    [p phoneNumber], email, [don cookNameOrInitials]] toData:tmp];
  [self addString:@"\\vspace*{10pt}\n" toData:tmp];
  [self addString:@"\\begin{center}\n" toData:tmp];
  [self addString:@"\\rowcolors{2}{lightgray!40}{}\n" toData:tmp];
  [self addString:@"\\setlength\\LTleft{0pt}\n" toData:tmp];
  [self addString:@"\\setlength\\LTright{0pt}\n" toData:tmp];
  [self addString:@"\\begin{longtable}{l}\n" toData:tmp];
  [self addString:@"Item \\\\ \n" toData:tmp];
  [self addString:@"\\endfirsthead \n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"Item \\\\ \n" toData:tmp];
  [self addString:@"\\endhead\n" toData:tmp];
  [self addString:@"\\hline \\hline\n" toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\itemrow{\\$%1.2f Monetary Donation}\n", [don donationAmount]] toData:tmp];
  [self addString:@"\\end{longtable}\n" toData:tmp];
  [self addString:@"\\end{center}\n" toData:tmp];
  [self addString:@"\\fancyfoot[LOE]{\\thankyou}\n" toData:tmp];
  [self addString:@"\\end{document}\n" toData:tmp];
  NSData *returnVal = [NSData dataWithData:tmp];
  [tmp release];
  return returnVal;  
}

- (NSTask *)makeLatexTaskInDirectory:(NSString *)dir usingPath:(NSString *)path {
  NSTask *latex = [[NSTask alloc] init];
  NSMutableArray *args = [[NSMutableArray alloc] init];
  //pdfetex [options] [& format ] [ file | \ commands ]
  [args insertObject:[NSString stringWithFormat:@"-output-directory"] atIndex:0];
  [args insertObject:dir atIndex:1];
  [args insertObject:[NSString stringWithFormat:@"-halt-on-error"] atIndex:2];
  [args insertObject:path atIndex:3];
  [latex setLaunchPath:[[NSUserDefaults standardUserDefaults] objectForKey:TljBkPosPathToLatexKey]];
  [latex setArguments:args];
  [latex setCurrentDirectoryPath:dir];
  [args release];
  return latex;  
}

- (NSData *)stringToData:(NSString *)str {
  return [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
}

- (void)appendData:(NSMutableData *)md withData:(NSData *)d {
  [md appendData:d];
}

- (void)addString:(NSString *)str toData:(NSMutableData *)d {
  
 // NSCharacterSet *digits = [NSCharacterSet decimalDigitCharacterSet];
//  NSMutableString *originalWord = [NSMutableString 
//stringWithString:@"F1o2o3b4a5r"];
//  NSRange r = [originalWord rangeOfCharacterFromSet:digits];
//  while (r.location != NSNotFound) {
//    [originalWord deleteCharactersInRange:r];
//    r = [originalWord rangeOfCharacterFromSet:digits];
//  }
//  
  
  
  [self appendData:d withData:[self stringToData:str]];
}


- (NSString *)filenameForDonation:(Donation *)don withExtension:(NSString *)ext {
  return [NSString stringWithFormat:@"cash-donation-%@.%@", [don uid], ext];
}

- (NSString *)pathToTexBuildFile {
  return [[NSString stringWithFormat:@"%@/CashDonation.tex", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToTexBuildDir {
  return [[NSString stringWithFormat:@"%@/", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToOldPdfFile {
  return [[NSString stringWithFormat:@"%@/CashDonation.pdf", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToNewPdfFile:(Donation *)don {
  return [[NSString stringWithFormat:@"%@/%@",
    [self pathToTodaysArchive], [self filenameForDonation:don withExtension:@"pdf"]]
    stringByStandardizingPath];
}


- (bool)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo {
  int result;
  result = NSRunAlertPanel(@"Fuck all.  I hate ObjC", @"File  operation error: %@ with file: %@", 
                           @"Proceed", @"Stop",  NULL, 
                           [errorInfo objectForKey:@"Error"], 
                           [errorInfo objectForKey:@"Path"]);
  
  if (result == NSAlertDefaultReturn) {
    return YES;
  } else {
    return NO;
  }
}

- (NSString *)archivePathForToday {
  NSCalendarDate *today = [NSCalendarDate calendarDate];
  //  int year = [today yearOfCommonEra];
  //  int month = [today monthOfYear];
  //  int day = [today dayOfMonth];
  NSString *dateStr = [today descriptionWithCalendarFormat:@"/%Y"];
  NSString *path = [NSString stringWithFormat:@"%@%@", [self pathToDonationArchive], dateStr];
  
  
  NSFileManager *nsfm = [NSFileManager defaultManager];
  // check year
  [nsfm createDirectoryAtPath:path attributes:nil];
  // check month
  dateStr = [today descriptionWithCalendarFormat:@"/%m"];
  path = [NSString stringWithFormat:@"%@%@", path, dateStr];
  [nsfm createDirectoryAtPath:path attributes:nil];
  
  // check the day
  dateStr = [today descriptionWithCalendarFormat:@"/%d"];
  path = [NSString stringWithFormat:@"%@%@", path, dateStr];
  [nsfm createDirectoryAtPath:path attributes:nil];
  ////NSLog(@"path: %@", path);
  return path;
}

- (NSString *)pathToDonationArchive {
  return pathToDonationArchive;
}

- (void)setPathToDonationArchive:(NSString *)path {
  path = [path copy];
  [pathToDonationArchive release];
  pathToDonationArchive = path;
}

- (NSString *)pathToTodaysArchive {
  return pathToTodaysArchive;
}

- (void)setPathToTodaysArchive:(NSString *)path {
  path = [path copy];
  [pathToTodaysArchive release];
  pathToTodaysArchive = path;
}


- (NSString *)pathToLatexBuild {
  return pathToLatexBuild;
}

- (void)setPathToLatexBuild:(NSString *)path {
  path = [path copy];
  [pathToLatexBuild release];
  pathToLatexBuild = path;
}

@end
