//
//  InvoiceArchiver.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/26/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "InvoiceArchiver.h"
#import "FTSWAbstractSingleton.h"
#import "Invoice.h"
#import "Invoices.h"
#import "Person.h"
#import "People.h"
#import "Product.h"
#import "PreferenceController.h"


@implementation InvoiceArchiver

+ (InvoiceArchiver *)sharedInstance {
  static InvoiceArchiver *s_MySingleton = nil;
  
  @synchronized([InvoiceArchiver class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
    }
  }
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}

- (id)initSingleton {
  if (self = [super initSingleton]) {
    [self setPathToLatexBuild:@"/Library/Application Support/BicycleKitchenPOS/ArchivedInvoices/latex-build"];
    [self setPathToInvoiceArchive:@"/Library/Application Support/BicycleKitchenPOS/ArchivedInvoices"];
  }
  return self;
}

- (void) dealloc {
  [pathToInvoiceArchive release];
  [pathToTodaysArchive release];
  [pathToLatexBuild release];
  [super dealloc];
}

- (void)archiveInvoice:(Invoice *)inv andPrint:(bool)print {
  // write for text output
  NSFileManager *nsfm = [NSFileManager defaultManager];
  [self setPathToTodaysArchive:[self archivePathForToday]];
  [nsfm createDirectoryAtPath:pathToTodaysArchive attributes:nil];
  
  NSString *texPath = [self pathToTexBuildFile];
  NSString *buildDir = [self pathToTexBuildDir];
  NSString *oldPdfPath =  [self pathToOldPdfFile];
  NSString *newPdfPath = [self pathToNewPdfFile:inv];
 
  
  //NSLog(@"newPdfPath %@", newPdfPath);
  // may not be necessary
  if ([nsfm fileExistsAtPath:texPath])  [nsfm removeFileAtPath:texPath handler:self];
    
  NSData *latexData = [self latexTemplateForInvoice:inv];
  
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
    NSTask *lpr = [[NSTask alloc] init];
    [lpr setLaunchPath:@"/usr/bin/lpr"];
    [lpr setArguments:[NSArray arrayWithObject:newPdfPath]];
    [lpr launch];
    [lpr waitUntilExit];
    [lpr release];
  }
  
  [inv setPathToPdf:newPdfPath];
  [[Invoices sharedInstance] saveToDisk];
}

- (void)printInvoice:(Invoice *)inv {
  // just like archiving and print, but without the archiving
  
  
  NSFileManager *nsfm = [NSFileManager defaultManager]; 
  
  NSString *oldPdfPath = [inv pathToPdf];
  
  if (![nsfm fileExistsAtPath:oldPdfPath]) {
    
    NSString *texPath = [self pathToTexBuildFile];
    NSString *buildDir = [self pathToTexBuildDir];
    oldPdfPath =  [self pathToOldPdfFile];
    
    //NSLog(@"oldPdfPath %@", oldPdfPath);
    // may not be necessary
    if ([nsfm fileExistsAtPath:texPath])  [nsfm removeFileAtPath:texPath handler:self];
    
    NSData *latexData = [self latexTemplateForInvoice:inv];
    
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
  }
  
  NSTask *lpr = [[NSTask alloc] init];
  [lpr setLaunchPath:@"/usr/bin/lpr"];
  [lpr setArguments:[NSArray arrayWithObject:oldPdfPath]];
  [lpr launch];  
  [lpr waitUntilExit];
  [lpr release];
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

- (NSData *)lispDataForInvoice:(Invoice *)inv {
  NSMutableData *tmp = [[NSMutableData alloc] init];
//  // invoicePaid, roundedTotal, trueTotal, totalTaxableAmount, totalNonTaxableAmount, taxOwed
//  // date, paidDate, customerUid, customerName* s.t. date => creation date
//  // totalAmountReceived, amountReceivedCash, amountTakenFromCredits, amountRecievedCredit,
//  //   amountReceivedDebit, amountReceivedCheck, changeDue, gaveChangeAsDonation
//  // checkNumber
//  // debitOrCredit*, cardType, expirationDate, lastFourDigits
//  // standTime, donationAmount, donationAsProduct, donationAmountFromChange
//  // totalDiscounts, discountsFromMembership, discountsFromOther
//  // items
//  // uid, code, name, price, quanity, discount, totalPrice
//  [self addString:@";;; * => computed and not directly stored in the invoice object\n" toData:tmp];
//  [self addString:@";;; invoicePaid roundedTotal trueTotal totalTaxableAmount totalNonTaxableAmount taxOwed\n"
//           toData:tmp];
//  [self addString:[NSString stringWithFormat:@"(%d %1.2f %1.2f %1.2f %1.2f %1.2f)\n",
//    [inv invoicePaid], [inv invoiceTotal], [inv invoiceTotal],
//    [inv totalTaxableAmount], [inv totalNonTaxableAmount], [inv taxOwed]] toData:tmp];
//  
//  [self addString:@";;; date paidDate customerUid customerName* s.t. data => creation date\n" toData:tmp];
//  [self addString:[NSString stringWithFormat:@"(\"%@\" \"%@\" %@ \"%@\")\n",
//    [[inv date] descriptionWithCalendarFormat:@"%Y-%m-%d-%H"],
//    [[inv paidDate] descriptionWithCalendarFormat:@"%Y-%m-%d-%H"],
//    [inv personUid],
//    [inv personName]] toData:tmp];
//  
//  [self addString:@";;; totalAmountReceived amountReceivedCash amountTakenFromCredits amountRecievedCredit amountReceivedDebit amountReceivedCheck changeGiven gaveChangeAsDonation\n" toData:tmp];     
//
//  [self addString:[NSString stringWithFormat:@"(%1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f)\n",
//    [inv totalAmountReceived], [inv amountReceivedCash],
//    [inv amountTakenFromCredits], [inv amountReceivedCredit],
//    [inv amountReceivedDebit], [inv amountReceivedCheck],
//    [inv changeGiven], [inv acceptedChangeAsDonation]] toData:tmp];
//  
//  [self addString:@";;; checkNumber\n" toData:tmp];
//  [self addString:[NSString stringWithFormat:@"(%d)\n", [inv checkNumber]] toData:tmp];
//  
//  [self addString:@";;; debitOrCredit* cardType expirationDate lastFourDigits\n" toData:tmp];
//  NSString *debitOrCredit;
//  if (([inv amountReceivedCredit] == 0.0) && ([inv amountReceivedDebit] == 0.0)) {
//    debitOrCredit = [NSString stringWithFormat:@"no"];
//  } else if ([inv amountReceivedCredit] == 0.0) {
//    debitOrCredit = [NSString stringWithFormat:@"debit"];
//  } else {
//    debitOrCredit = [NSString stringWithFormat:@"credit"];
//  }
//  [self addString:[NSString stringWithFormat:@"(\"%@\" \"%@\" \"%@\" \"%@\")\n",
//    debitOrCredit, [inv cardType],
//    [[inv expirationDate] descriptionWithCalendarFormat:@"%Y-%m-%d"],
//    [inv lastFourDigits]] toData:tmp];
//  
//  [self addString:@";;; standTime donationAmount donationAsProduct donationAmountFromChange\n" toData:tmp];
//  double donationFromChange = [inv donationFromChange];
//  double donationAsProduct = [inv donationInInvoiceAmount];
//  double standTime = 0.0;
//  Product *stand;
//  bool standFound = NO;
//  NSEnumerator *e = [[inv items] objectEnumerator];
//  Product *value;
//  while (value = (Product *)[e nextObject]) {
//    NSString *code = [value productCode];
//    if ([code isEqualToString:@"stand"]) {
//      stand = value;
//      standFound = YES;
//    }
//  }
//  if (standFound) {
//    double priceOfStandTime = [[[Products sharedInstance] productForCode:@"stand"] productPrice];
//    standTime = [stand productPrice] / priceOfStandTime;
//  }
//  [self addString:[NSString stringWithFormat:@"(%1.2f %1.2f %1.2f %1.2f)\n",
//    standTime, [inv donationGiven], donationAsProduct, donationFromChange] toData:tmp];
//  
//  double discountsFromOther = [inv amountOfNonMemberDiscountGiven];
//  double discountsFromMembership = [inv totalDiscounts] - discountsFromOther;
//    
//  // totalDiscounts, discountsFromMembership, discountsFromOther
//  [self addString:@";;; totalDiscounts discountsFromMembership discountsFromOther\n" toData:tmp];
//  [self addString:[NSString stringWithFormat:@"(%1.2f %1.2f %1.2f)\n",
//    [inv totalDiscounts], discountsFromMembership, discountsFromOther] toData:tmp];
//  
//  [self addString:@";;; items\n" toData:tmp];
//  [self addString:@";;; uid, code, name, price, quanity, discount, totalPrice\n" toData:tmp];
//  
//  e = [[inv items] objectEnumerator];
//  while (value = (Product *)[e nextObject]) {
//    [self addString:[NSString stringWithFormat:@"(%@ \"%@\" \"%@\" %1.2f %d %1.2f %1.2f)\n",
//      [value uid], [value productCode], [value productName],
//      [value productPrice], [value productQuantity], [value productDiscount],
//      [value productTotal]]
//             toData:tmp];
//  }
  NSData *returnVal = [NSData dataWithData:tmp];
  [tmp release];
  return returnVal;
  
}


- (NSData *)latexTemplateForInvoice:(Invoice *)inv {
  NSMutableData *tmp = [[NSMutableData alloc] init];
  
  [self addString:[NSString stringWithFormat:@"\\input kitcheninvoice\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\begin{document}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\fancyhead{}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\fancyhead[L]{\\makeheader}\n"] toData:tmp];
  Person *p = [[People sharedInstance] personForUid:[inv personUid]];
  NSString *name = [p personName];
  double totalDue = [inv invoiceTotal];
  NSString *status = [self invoiceStatus:inv];
  
  [self addString:[NSString stringWithFormat:@"\\dateandname{%@}{%@}{\\$%1.2f}{%@}\n",
    [[inv paidDate] descriptionWithCalendarFormat:@"%m/%d/%Y"],
    name, totalDue, status]
           toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\vspace*{10pt}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\begin{center}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\rowcolors{2}{lightgray!40}{}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\setlength\\LTleft{0pt}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\setlength\\LTright{0pt}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\begin{longtable}{llrcrr}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"Code & Name & Price & Qty & Disc & Total \\\\\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\endfirsthead\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\hline\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"Code & Name & Price & Qty & Disc & Total \\\\\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\endhead\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\hline \\hline\n"] toData:tmp];
  NSEnumerator *e = [[inv items] objectEnumerator];
  Product *val;
  while (val = (Product *)[e nextObject]) {
    NSString *name = [val productName];
    int len = [name length];
    if (len > 40) {
      name = [[name substringToIndex:39] stringByAppendingString:@"..."];
    }
    
    [self addString:[NSString stringWithFormat:@"\\invoicerow{%@}{%@}{\\$%1.2f}{%d}{\\$%1.2f}{\\$%1.2f}\n",
      [val productCode], name, [val productPrice], [val productQuantity], [val productDiscount],
      [val productTotal]] toData:tmp];
  }
  [self addString:[NSString stringWithFormat:@"\\invoicetotals{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}{\\$%1.2f}\n",
    [inv invoiceTotal], [inv invoiceTotal], [inv totalAmountReceived], [inv amountOfChangeGiven]]
           toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\end{longtable}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\end{center}\n"] toData:tmp];
  [self addString:[NSString stringWithFormat:@"\\end{document}\n"] toData:tmp];
  
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

- (NSString *)invoiceStatus:(Invoice *)inv {
  if ([inv invoicePaid]) {
    return [NSString stringWithFormat:@"paid"];
  } else {
    return [NSString stringWithFormat:@"unpaid"];
  }
}

- (NSString *)filenameForInvoice:(Invoice *)inv withExtension:(NSString *)ext {
  return [NSString stringWithFormat:@"invoice-%@.%@", [inv uid], ext];
}

- (NSString *)pathToTexBuildFile {
  return [[NSString stringWithFormat:@"%@/invoice.tex", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToTexBuildDir {
  return [[NSString stringWithFormat:@"%@/", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToOldPdfFile {
  return [[NSString stringWithFormat:@"%@/invoice.pdf", [self pathToLatexBuild]]
    stringByStandardizingPath];
}

- (NSString *)pathToNewPdfFile:(Invoice *)inv {
  return [[NSString stringWithFormat:@"%@/%@",
    [self pathToTodaysArchive], [self filenameForInvoice:inv withExtension:@"pdf"]]
    stringByStandardizingPath];
}

- (NSString *)pathToLispFile:(Invoice *)inv {
  return [[NSString stringWithFormat:@"%@/%@",
    [self pathToTodaysArchive], [self filenameForInvoice:inv withExtension:@"lisp"]]
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
  NSString *path = [NSString stringWithFormat:@"%@%@", [self pathToInvoiceArchive], dateStr];
  
  
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
  //NSLog(@"path: %@", path);
  return path;
}

- (NSString *)pathToInvoiceArchive {
  return pathToInvoiceArchive;
}

- (void)setPathToInvoiceArchive:(NSString *)path {
  path = [path copy];
  [pathToInvoiceArchive release];
  pathToInvoiceArchive = path;
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
