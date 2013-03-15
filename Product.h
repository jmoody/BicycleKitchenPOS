//
//  Product.h
//  AnotherApp
//
//  Created by moody on 6/4/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ProductBrowserNode.h"

@interface Product : ProductBrowserNode  {

  NSString *productCode;
  NSString *productName;
  NSString *productCategory;
  double productPrice;
  int productQuantity;
  bool taxable;
  bool active;

  // for invoices
  float productDiscount;
  float productTotal;

  
}

- (id) initWithCode:(NSString *)code 
               name:(NSString *)name 
           category:(NSString *)category 
              price:(double)price 
           quantity:(int)quantity 
            taxable:(bool)tax 
             active:(bool)act;

  
- (NSString *) productCode;
- (NSString *) productName;
- (NSString *) productCategory;
- (double) productPrice;
- (int)productQuantity;
- (double)productDiscount;
- (double)productTotal;

- (bool)taxable;
- (bool)active;
- (NSString *)activeYesOrNo;

- (void) setProductCode:(NSString *)code;
- (void) setProductName:(NSString *)name;
- (void) setProductCategory:(NSString *)category;
- (void) setProductPrice:(double)price;
- (void) setProductQuantity:(int)quantity;
- (void) setTaxable:(bool)isTaxable;
- (void) setActive:(bool)isActive;
- (void) setProductDiscount:(double)discount;
- (void) setProductTotal:(double)total;

- (bool) samep:(Product *)p;
- (NSString *)searchDescription;

@end
