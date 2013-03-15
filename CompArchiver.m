//
//  CompArchiver.m
//  BicycleKitchenPOS
//
//  Created by moody on 2/25/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//


#import "CompArchiver.h"
#import "Comps.h"
#import "Comp.h"
#import "Product.h"
#import "PreferenceController.h"


@implementation CompArchiver

+ (CompArchiver *)sharedInstance {
  static CompArchiver *s_MySingleton = nil;
  
  @synchronized([CompArchiver class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  if (self = [super initSingleton]) {
    [self setPathToLatexBuild:@"/Library/Application Support/BicycleKitchenPOS/ArchivedComps/latex-build"];
    [self setPathToCompArchive:@"/Library/Application Support/BicycleKitchenPOS/ArchivedComps"];
  }
  return self;
}

- (void) dealloc {
  [pathToCompArchive release];
  [pathToTodaysArchive release];
  [pathToLatexBuild release];
  [super dealloc];
}

- (void)archiveComp:(Comp *)comp andPrint:(bool)print {
  // write for text output
  NSFileManager *nsfm = [NSFileManager defaultManager];
  [self setPathToTodaysArchive:[self archivePathForToday]];
  [nsfm createDirectoryAtPath:pathToTodaysArchive attributes:nil];
  
  NSString *texPath = [self pathToTexBuildFile];
  NSString *buildDir = [self pathToTexBuildDir];
  NSString *oldPdfPath =  [self pathToOldPdfFile];
  NSString *newPdfPath = [self pathToNewPdfFile:comp];
  //NSString *lispPath = [self pathToLispFile:Comp];
  
  ////NSLog(@"newPdfPath %@", newPdfPath);
  // may not be necessary
  if ([nsfm fileExistsAtPath:texPath])  [nsfm removeFileAtPath:texPath handler:self];
  
  NSData *latexData = [self latexTemplateForComp:comp];
  
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
  
  [comp setPathToPdfArchive:newPdfPath];
  
  [[Comps sharedInstance] saveToDisk];
}

- (void)printComp:(Comp *)comp {
  
  NSFileManager *nsfm = [NSFileManager defaultManager];  
  
  NSString *pathToPdf = [comp pathToPdfArchive];
  
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

- (NSData *)lispDataForComp:(Comp *)comp {
  NSMutableData *tmp = [[NSMutableData alloc] init];
  [self addString:@";;; * => computed and not directly stored in the invoice object\n" toData:tmp];
  
  return tmp;
}


- (NSData *)latexTemplateForComp:(Comp *)comp {
  NSMutableData *tmp = [[NSMutableData alloc] init];
  
  // header  
  [self addString:@"\\input kitchencomp\n\n" toData:tmp];
  [self addString:@"\\begin{document}\n\n" toData:tmp];
  [self addString:@"\\fancyhead{}\n\n" toData:tmp];
  [self addString:@"\\fancyhead[L]{\\makeheader}\n\n" toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\dateandname{%@}{%@}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}\n\n\n",
    [[comp date] descriptionWithCalendarFormat:@"%m/%d/%Y %H:%M"],
    [comp cookNameOrInitials], [comp valueOfComp],
    [comp taxableValue], [comp untaxableValue]] toData:tmp];
  [self addString:@"\\vspace*{10pt}\n\n" toData:tmp];
  [self addString:@"\\begin{center}\n" toData:tmp];
  [self addString:@"\\rowcolors{2}{lightgray!40}{}\n" toData:tmp];
  [self addString:@"\\setlength\\LTleft{0pt}\n" toData:tmp];
  [self addString:@"\\setlength\\LTright{0pt}\n" toData:tmp];
  [self addString:@"\\begin{longtable}{llrcrr}\n" toData:tmp];
  [self addString:@"Code & Name & Price & Qty & Disc & Total \\\\\n" toData:tmp];
  [self addString:@"\\endfirsthead\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];  [self addString:@"Code & Name & Price & Qty & Disc & Total \\\\\n" toData:tmp];
  [self addString:@"\\endfirsthead\n" toData:tmp];
  [self addString:@"\\hline \\hline\n" toData:tmp];
  NSArray *array = [comp items];
  unsigned int i, count = [array count];
  for (i = 0; i < count; i++) {
    Product *pr = (Product *)[array objectAtIndex:i];
    [self addString:[NSString stringWithFormat:@"\\comprow{%@}{%@}{\\$%1.2f}{%d}{\\$%1.2f}{\\$%1.2f}\n",
      [pr productCode], [pr productName], [pr productPrice], 
      [pr productQuantity], [pr productDiscount], [pr productTotal]] toData:tmp];
  }
  [self addString:@"\\end{longtable}\n" toData:tmp];
  [self addString:@"\\end{center}\n" toData:tmp];
  [self addString:@"\\fancyfoot{}\n" toData:tmp];
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
  [self appendData:d withData:[self stringToData:str]];
}


- (NSString *)filenameForComp:(Comp *)comp withExtension:(NSString *)ext {
  return [NSString stringWithFormat:@"comp-%@.%@", [comp uid], ext];
}

- (NSString *)pathToTexBuildFile {
  return [[NSString stringWithFormat:@"%@/comp.tex", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToTexBuildDir {
  return [[NSString stringWithFormat:@"%@/", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToOldPdfFile {
  return [[NSString stringWithFormat:@"%@/comp.pdf", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToNewPdfFile:(Comp *)comp {
  return [[NSString stringWithFormat:@"%@/%@",
    [self pathToTodaysArchive], [self filenameForComp:comp withExtension:@"pdf"]]
    stringByStandardizingPath];
}

- (NSString *)pathToLispFile:(Comp *)comp {
  return [[NSString stringWithFormat:@"%@/%@",
    [self pathToTodaysArchive], [self filenameForComp:comp withExtension:@"lisp"]]
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
  NSString *path = [NSString stringWithFormat:@"%@%@", [self pathToCompArchive], dateStr];
  
  
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

- (NSString *)pathToCompArchive {
  return pathToCompArchive;
}

- (void)setPathToCompArchive:(NSString *)path {
  path = [path copy];
  [pathToCompArchive release];
  pathToCompArchive = path;
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

