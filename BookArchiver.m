//
//  BookArchiver.m
//  BicycleKitchenPOS
//
//  Created by moody on 12/20/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "BookArchiver.h"
#import "Books.h"
#import "Book.h"
#import "PreferenceController.h"
#import "Invoices.h"
#import "Invoice.h"
#import "Product.h"
#import "Check.h"
#import "Checks.h"
#import "DebitOrCredit.h"
#import "DebitsAndCredits.h"
#import "Credits.h"
#import "ShopCredit.h"
#import "PreferenceController.h"

@implementation BookArchiver

+ (BookArchiver *)sharedInstance {
  static BookArchiver *s_MySingleton = nil;
  
  @synchronized([BookArchiver class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  if (self = [super initSingleton]) {
    [self setPathToLatexBuild:@"/Library/Application Support/BicycleKitchenPOS/ArchivedBooks/latex-build"];
    [self setPathToBookArchive:@"/Library/Application Support/BicycleKitchenPOS/ArchivedBooks"];
  }
  return self;
}

- (void) dealloc {
  [pathToBookArchive release];
  [pathToTodaysArchive release];
  [pathToLatexBuild release];
  [super dealloc];
}

- (void)archiveBook:(Book *)book andPrint:(bool)print {
  // write for text output
  NSFileManager *nsfm = [NSFileManager defaultManager];
  [self setPathToTodaysArchive:[self archivePathForToday]];
  [nsfm createDirectoryAtPath:pathToTodaysArchive attributes:nil];
  
  NSString *texPath = [self pathToTexBuildFile];
  NSString *buildDir = [self pathToTexBuildDir];
  NSString *oldPdfPath =  [self pathToOldPdfFile];
  NSString *newPdfPath = [self pathToNewPdfFile:book];
  //NSString *lispPath = [self pathToLispFile:book];
  
  ////NSLog(@"newPdfPath %@", newPdfPath);
  // may not be necessary
  if ([nsfm fileExistsAtPath:texPath])  [nsfm removeFileAtPath:texPath handler:self];
  
  NSData *latexData = [self latexTemplateForBook:book];
  
  // write the .tex file
  [nsfm createFileAtPath:texPath contents:latexData attributes:nil];
  // make the .pdf
  NSTask *task1 =  [self makeLatexTaskInDirectory:buildDir usingPath:texPath];
  [task1 launch];
  
  // we'll multitask and write the Lisp file
  //NSData *lispData = [self lispDataForBook:book];
  // write the .lisp file
  //[nsfm createFileAtPath:lispPath contents:lispData attributes:nil];
  
  // wait for the pdf to build the first time
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
  
  [book setPathToPdfArchive:newPdfPath];

  [[Books sharedInstance] saveToDisk];
}

- (void)printBook:(Book *)book {

  NSFileManager *nsfm = [NSFileManager defaultManager];  

  NSString *pathToPdf = [book pathToPdfArchive];
  
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

- (NSData *)lispDataForBook:(Book *)book {
  NSMutableData *tmp = [[NSMutableData alloc] init];
  [self addString:@";;; * => computed and not directly stored in the invoice object\n" toData:tmp];
  NSData *returnVal = [NSData dataWithData:tmp];
  [tmp release];
  return returnVal;
}


- (NSData *)latexTemplateForBook:(Book *)book {
  NSMutableData *tmp = [[NSMutableData alloc] init];
  
  unsigned int i, count;

  // header  
  [self addString:@"\\input kitchenbook\n\n" toData:tmp];
  [self addString:@"\\begin{document}\n\n" toData:tmp];
  [self addString:@"\\fancyhead{}\n" toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\fancyhead[L]{\\dateandname{%@}{%@}}\n\n",
    [[book date] descriptionWithCalendarFormat:@"%m/%d/%Y %H:%M"],
    [book closerNameOrInitials]] toData:tmp];
  //Cook Hours & Number of Clients & Stand Time & Projects Completed & Donations
  
  [self addString:[NSString stringWithFormat:@"\\dailysummary{%d}{%d}{%1.2f}{%d}{\\$%1.2f}\n\n",
    [book volunteerHoursTotal], [book numberOfClients], [book standTimeTotal],
    [book projectsCompletedTotal], [book donationsTotal]] toData:tmp];
  
  [self addString:@"\\spanningline\n\n" toData:tmp];
  
  [self addString:@"\\rowcolors{2}{lightgray!40}{}\n" toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\noindent \\finacialsummary{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}\n",
    [book totalChecks], [book totalCards], [book totalCash], [book totalCredits],
    [book expectedTotal], [book actualTotal], [book variance]]  toData:tmp];
  [self addString:@"\\hspace*{20pt}\n" toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\taxsummary{\\$%1.2f}{\\$%1.2f}{%1.2f}{\\$%1.2f}\n",
    [book untaxableTotal],  [book taxableTotal], 
     [[[NSUserDefaults standardUserDefaults] objectForKey:TljBkPosSalesTaxRate] doubleValue],
    [book taxOwed]] toData:tmp];
  [self addString:@"\\hspace*{20pt}\n" toData:tmp];
  [self addString:@"\\rowcolors{2}{lightgray!40}{}\n" toData:tmp];
  [self addString:@"\\begin{tabular}{|l|l|r|}\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\textbf{Cash Summary} & & \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\cashrow{100}{%d}{\\$%1.2f}\n",
    [book hundreds],[book hundreds] * 100.0] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\cashrow{50}{%d}{\\$%1.2f}\n",
    [book fifties],[book fifties] * 50.0] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\cashrow{20}{%d}{\\$%1.2f}\n",
    [book twenties],[book twenties] * 20.0] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\cashrow{10}{%d}{\\$%1.2f}\n",
    [book tens],[book tens] * 10.0] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\cashrow{5}{%d}{\\$%1.2f}\n",
    [book fives], [book fives] * 5.0] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\cashrow{2}{%d}{\\$%1.2f}\n",
    [book twos],[book twos] * 2.0] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\cashrow{1}{%d}{\\$%1.2f}\n",
    [book ones],[book ones] * 1.0] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\cashrow{}{\\textbf{Total}}{\\textbf{\\$%1.2f}}\n",
    [book totalCash]] toData:tmp];
  [self addString:@"\\end{tabular}\n\n" toData:tmp];
  
  [self addString:@"\\spanningline\n\n" toData:tmp];
  
  [self addString:@"\\noindent\n" toData:tmp];
  [self addString:@"\\rowcolors{2}{lightgray!40}{}\n" toData:tmp];
  [self addString:@"\\begin{tabular}{|l|l|r|}\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\textbf{Checks} & & \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"Check Number & Name on Check & Total \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  NSArray *checks = [[Checks sharedInstance] objectsForUids:[book checkUids]];
  count = [checks count];
  for (i = 0; i < count; i++) {
    Check *ch = (Check *)[checks objectAtIndex:i];
    [self addString:[NSString stringWithFormat:@"\\checkrow{%d}{%@}{\\$%1.2f}\n",
      [ch checkNumber],[ch nameOnCheck],[ch checkAmount]] toData:tmp];
  }
  [self addString:[NSString stringWithFormat:@"\\checkrow{}{\\textbf{Total}}{\\textbf{\\$%1.2f}}\n",
    [book totalChecks]] toData:tmp];
  [self addString:@"\\end{tabular}\n" toData:tmp];
  [self addString:@"\\hspace*{50pt}\n" toData:tmp];
  [self addString:@"\\rowcolors{2}{lightgray!40}{}\n" toData:tmp];
  [self addString:@"\\begin{tabular}{|l|r|}\n" toData:tmp];
   [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"Shop Credits & \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"Name & Amount \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  NSArray *credits = [[Credits sharedInstance] objectsForUids:[book creditUids]];
  count = [credits count];
  for (i = 0; i < count; i++) {
    ShopCredit *ch = (ShopCredit *)[credits objectAtIndex:i];
    [self addString:[NSString stringWithFormat:@"\\creditrow{%@}{\\$%1.2f}\n",
      [ch personName], [ch creditAmount]] toData:tmp];
  }
  [self addString:[NSString stringWithFormat:@"\\creditrow{\\textbf{Total}}{\\textbf{\\$%1.2f}}\n",
    [book totalCredits]] toData:tmp];
  [self addString:@"\\end{tabular} \n\n" toData:tmp];
  
  [self addString:@"\\spanningline\n\n" toData:tmp];
  
  [self addString:@"\\rowcolors{2}{lightgray!40}{}\n" toData:tmp];
  [self addString:@"\\begin{longtable}{|l|l|r|}\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\textbf{Card Summary} & & \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"Last Four & Name on Card & Total \\\\\n" toData:tmp];
  [self addString:@"\\hline \n" toData:tmp];
  [self addString:@"\\endfirsthead\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\textbf{Card Summary} & & \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"Last Four & Name on Card & Total \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\endhead\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  NSArray *cards = [[DebitsAndCredits sharedInstance] objectsForUids:[book debitUids]];
  count = [cards count];
  for (i = 0; i < count; i++) {
    DebitOrCredit *db = (DebitOrCredit *)[cards objectAtIndex:i];
    [self addString:[NSString stringWithFormat:@"\\cardrow{%@}{%@}{\\$%1.2f}\n",
      [db lastFourDigits],[db nameOnDebit],[db debitAmount]] toData:tmp];
  }
  [self addString:[NSString stringWithFormat:@"\\cardrow{}{\\textbf{Total}}{\\textbf{\\$%1.2f}}\n",
    [book totalCards]] toData:tmp];
  [self addString:@"\\end{longtable}\n\n" toData:tmp];
  
  [self addString:@"\\spanningline\n\n" toData:tmp];

  [self addString:@"\\rowcolors{2}{lightgray!40}{}\n" toData:tmp];
  [self addString:@"\\begin{longtable}{|l|c|r|r|r|r|r|}\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\textbf{Invoices} & & & & & & \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@" Name &  Paid & Discount &  Untaxable & Taxable & Tax Owed & Total \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\endfirsthead\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\textbf{Invoices} & & & & & & \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@" Name &  Paid & Discount &  Untaxable & Taxable & Tax Owed & Total \\\\\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  [self addString:@"\\endhead\n" toData:tmp];
  [self addString:@"\\hline\n" toData:tmp];
  double discounts = 0.0;
  NSArray *invoices = [[Invoices sharedInstance] objectsForUids:[book invoiceUids]];
  count = [invoices count];
  for (i = 0; i < count; i++) {
    Invoice *inv = (Invoice *)[invoices objectAtIndex:i];
    discounts = discounts + [inv totalDiscounts];
    [self addString:[NSString stringWithFormat:@"\\invoicerow{%@}{%@}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}\n",
      [inv personName],[[inv paidDate] descriptionWithCalendarFormat:@"%m/%d/%Y %H:%M"],
      [inv totalDiscounts], [inv totalNonTaxableAmount], [inv totalTaxableAmount], [inv taxOwed], [inv invoiceTotal]]
             toData:tmp];
  }
  [self addString:[NSString stringWithFormat:@"\\invoicerow{}{\\textbf{Totals}}{\\textbf{\\$%1.2f}}{\\textbf{\\$%1.2f}}{\\textbf{\\$%1.2f}}{\\textbf{\\$%1.2f}}{\\textbf{\\$%1.2f}}\n",
    discounts, [book untaxableTotal], [book taxableTotal], [book taxOwed], [book actualTotal]]
           toData:tmp];
  [self addString:@"\\end{longtable}\n\n" toData:tmp];

  [self addString:@"\\fancyfoot{}\n" toData:tmp];
  [self addString:@"\\end{document}\n" toData:tmp];  
  NSData *returnVal = [NSData dataWithData:tmp];
  [tmp release];
  return returnVal;
}



- (NSTask *)makeLatexTaskInDirectory:(NSString *)dir usingPath:(NSString *)path {
  // release it later
  NSTask *latex = [[NSTask alloc] init];
  NSMutableArray *args = [[NSMutableArray alloc] init];
  //pdfetex [options] [& format ] [ file | \ commands ]
  [args insertObject:[NSString stringWithFormat:@"-output-directory"] atIndex:0];
  [args insertObject:dir atIndex:1];
  [args insertObject:[NSString stringWithFormat:@"-halt-on-error"] atIndex:2];
  [args insertObject:path atIndex:3];
  [latex setLaunchPath:[[NSUserDefaults standardUserDefaults] objectForKey:TljBkPosPathToLatexKey]];
  //[latex setLaunchPath:@"/usr/texbin/pdflatex"];
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


- (NSString *)filenameForBook:(Book *)book withExtension:(NSString *)ext {
  return [NSString stringWithFormat:@"book-%@.%@", [book uid], ext];
}

- (NSString *)pathToTexBuildFile {
  return [[NSString stringWithFormat:@"%@/book.tex", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToTexBuildDir {
  return [[NSString stringWithFormat:@"%@/", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToOldPdfFile {
  return [[NSString stringWithFormat:@"%@/book.pdf", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToNewPdfFile:(Book *)book {
  return [[NSString stringWithFormat:@"%@/%@",
    [self pathToTodaysArchive], [self filenameForBook:book withExtension:@"pdf"]]
    stringByStandardizingPath];
}

- (NSString *)pathToLispFile:(Book *)book {
  return [[NSString stringWithFormat:@"%@/%@",
    [self pathToTodaysArchive], [self filenameForBook:book withExtension:@"lisp"]]
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
  NSString *path = [NSString stringWithFormat:@"%@%@", [self pathToBookArchive], dateStr];
  
  
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

- (NSString *)pathToBookArchive {
  return pathToBookArchive;
}

- (void)setPathToBookArchive:(NSString *)path {
  path = [path copy];
  [pathToBookArchive release];
  pathToBookArchive = path;
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
