//
//  Products.m
//  BicycleKitchenPOS
//
//  Created by moody on 7/17/06.
//  Copyright 2006 The Little Joy. All rights reserved.
//

#import "Products.h"
#import "Product.h"


@implementation Products

+ (Products *)sharedInstance {
  ////NSLog(@"in sharedInstance Products");
  static Products *s_MySingleton = nil;
  
  @synchronized([Products class]) {
    if (s_MySingleton == nil) {
      s_MySingleton = [self singleton];
      //[s_MySingleton retain];
    }
  }
  
  // or you could not use the static var above and just do "return [self singleton];"
  return s_MySingleton;
}


- (id)initSingleton { 

  if (self = [super initSingleton]) {
   // //NSLog(@"in products initSingleton");
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/products.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"ProductsChanged"];
    //[self setDictionary:[[NSMutableDictionary alloc] init]];
    //[self makeProducts];
  }
  return self;
}

- (void) dealloc {
  [super dealloc];
}


- (void)saveToDisk {
  // post a notification that contacts has changed.
  NSNotificationCenter *nc;
  nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:notificationChangeString object:self];  
  [super saveToDisk];
}


//******************************************************************************
// description
//******************************************************************************

- (NSString *)description {
  return [NSString stringWithFormat:@"<Products: %@>", dictionary];
   
}


- (Product *)productForProductUid:(NSString *)uid {
  return [dictionary objectForKey:uid];
}

- (Product *)productForProductCode:(NSString *)code {
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    if ([[value productCode] isEqualToString:code]) {
      return (Product *)value;
    }
  }
  return nil;
}


- (Product *)productForProductName:(NSString *)name {
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    if ([[value productName] isEqualToString:name]) {
      return (Product *)value;
    }
  }
  return nil;  
}


- (void)makeProducts {
Product *BR1180 = [[Product alloc] initWithCode:@"br1180"
                                           name:@"tektro l-pull brake shoes black"
                                       category:@"Brakes"
                                          price:4.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR1180 forKey:[BR1180 uid]];
Product *BR1215 = [[Product alloc] initWithCode:@"br1215"
                                           name:@"dimension alloy cable hanger front 1-1/8 black"
                                       category:@"Brakes"
                                          price:5.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR1215 forKey:[BR1215 uid]];
Product *BR1431 = [[Product alloc] initWithCode:@"br1431"
                                           name:@"jag road molded brake shoes"
                                       category:@"Brakes"
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR1431 forKey:[BR1431 uid]];
Product *BR2783 = [[Product alloc] initWithCode:@"br2783"
                                           name:@"shimano v-brake noodle inner guide tube 90deg"
                                       category:@"Brakes"
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR2783 forKey:[BR2783 uid]];
Product *BR2784 = [[Product alloc] initWithCode:@"br2784"
                                           name:@"shimano v-brake noodle inner guide tube 135deg"
                                       category:@"Brakes"
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR2784 forKey:[BR2784 uid]];
Product *BR4080 = [[Product alloc] initWithCode:@"br4080"
                                           name:@"jag pre-crimped cable ferrules 5mm bottle 200pc"
                                       category:@"Cable/Housing"
                                          price:21.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR4080 forKey:[BR4080 uid]];
Product *BR4087 = [[Product alloc] initWithCode:@"br4087"
                                           name:@"jag chrome cable crimps 5mm bottle 200pc"
                                       category:@"Cable/Housing"
                                          price:36.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR4087 forKey:[BR4087 uid]];
Product *BR7179 = [[Product alloc] initWithCode:@"br7179"
                                           name:@"tektro 520a road caliper front and rear 47-57mm recessed bolt"
                                       category:@"Brakes"
                                          price:17.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR7179 forKey:[BR7179 uid]];
Product *BR7201 = [[Product alloc] initWithCode:@"br7201"
                                           name:@"tektro 221a road brake levers silver"
                                       category:@"Brakes"
                                          price:16.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR7201 forKey:[BR7201 uid]];
Product *BR7305 = [[Product alloc] initWithCode:@"br7305"
                                           name:@"tektro rx40 road calipers front rear set black"
                                       category:@"Brakes"
                                          price:68.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR7305 forKey:[BR7305 uid]];
Product *BR7419 = [[Product alloc] initWithCode:@"br7419"
                                           name:@"tektro tenera lp brake levers black/silver rapidfire"
                                       category:@"Brakes"
                                          price:14.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:BR7419 forKey:[BR7419 uid]];
Product *CA1096 = [[Product alloc] initWithCode:@"ca1096"
                                           name:@"qbp mountain brake cable 1.5x1700mm"
                                       category:@"Cable/Housing"
                                          price:4.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CA1096 forKey:[CA1096 uid]];
Product *CA1097 = [[Product alloc] initWithCode:@"ca1097"
                                           name:@"qbp road brake cable 1.5x1700mm"
                                       category:@"Cable/Housing"
                                          price:4.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CA1097 forKey:[CA1097 uid]];
Product *CA2520 = [[Product alloc] initWithCode:@"ca2520"
                                           name:@"qbp derailleur housing 1ft black"
                                       category:@"Cable/Housing"
                                          price:12.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CA2520 forKey:[CA2520 uid]];
Product *CA2716 = [[Product alloc] initWithCode:@"ca2716"
                                           name:@"qbp brake housing 1ft black"
                                       category:@"Cable/Housing"
                                          price:4.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CA2716 forKey:[CA2716 uid]];
Product *CA4105 = [[Product alloc] initWithCode:@"ca4105"
                                           name:@"cable end crimps 1.8mm bottle 500pc"
                                       category:@"Cable/Housing"
                                          price:21.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CA4105 forKey:[CA4105 uid]];
Product *CH4077 = [[Product alloc] initWithCode:@"ch4077"
                                           name:@"kmc z-51 7.1mm 6-7-8spd chain brown"
                                       category:@"Chains"
                                          price:9.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CH4077 forKey:[CH4077 uid]];
Product *CH4084 = [[Product alloc] initWithCode:@"ch4084"
                                           name:@"kmc z410b 1/8in chain brown"
                                       category:@"Chains"
                                          price:5.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CH4084 forKey:[CH4084 uid]];
Product *CH4091 = [[Product alloc] initWithCode:@"ch4091"
                                           name:@"kmc z9000 6.6mm chain silver/brown chain"
                                       category:@"Chains"
                                          price:16.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CH4091 forKey:[CH4091 uid]];
Product *CH4095 = [[Product alloc] initWithCode:@"ch4095"
                                           name:@"kmc z-50 7.3 5-6-7spd chain black"
                                       category:@"Chains"
                                          price:6.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CH4095 forKey:[CH4095 uid]];
Product *CH4102 = [[Product alloc] initWithCode:@"ch4102"
                                           name:@"kmc half link for 1/8in chains"
                                       category:@"Chains "
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CH4102 forKey:[CH4102 uid]];
Product *CR1200 = [[Product alloc] initWithCode:@"cr1200"
                                           name:@"sugino single chainring bolt set 5pc"
                                       category:@"Chain ring bolts "
                                          price:8.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR1200 forKey:[CR1200 uid]];
Product *CR2194 = [[Product alloc] initWithCode:@"cr2194"
                                           name:@"tv m8 capless steel crank bolts"
                                       category:@"Crank bolts"
                                          price:5.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR2194 forKey:[CR2194 uid]];
Product *CR2388 = [[Product alloc] initWithCode:@"cr2388"
                                           name:@"dmn cross 170mm crank arms 110/74bcd black"
                                       category:@"Chain rings "
                                          price:42.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR2388 forKey:[CR2388 uid]];
Product *CR4051 = [[Product alloc] initWithCode:@"cr4051"
                                           name:@"3s-b bolt type crmo spindle 68x121.5mm"
                                       category:@"Bottom brackets"
                                          price:10.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR4051 forKey:[CR4051 uid]];
Product *CR4201 = [[Product alloc] initWithCode:@"cr4201"
                                           name:@"3nn-b bolt type spindle 68x124"
                                       category:@"Bottom brackets"
                                          price:10.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR4201 forKey:[CR4201 uid]];
Product *CR4958 = [[Product alloc] initWithCode:@"cr4958"
                                           name:@"shimano un53 68x107mm bottom bracket square taper"
                                       category:@"Bottom brackets"
                                          price:24.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR4958 forKey:[CR4958 uid]];
Product *CR4959 = [[Product alloc] initWithCode:@"cr4959"
                                           name:@"shimano un53 68x110mm bottom bracket square taper"
                                       category:@"Bottom brackets"
                                          price:24.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR4959 forKey:[CR4959 uid]];
Product *CR4961 = [[Product alloc] initWithCode:@"cr4961"
                                           name:@"shimano un53 68x115mm bottom bracket square taper"
                                       category:@"Bottom brackets"
                                          price:25.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR4961 forKey:[CR4961 uid]];
Product *CR6001 = [[Product alloc] initWithCode:@"cr6001"
                                           name:@"cotter pin 9.0mm medium bevel"
                                       category:@"Other"
                                          price:1.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR6001 forKey:[CR6001 uid]];
Product *CR6003 = [[Product alloc] initWithCode:@"cr6003"
                                           name:@"cotter pin 9.5mm medium bevel"
                                       category:@"Other"
                                          price:1.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR6003 forKey:[CR6003 uid]];
Product *CR7296 = [[Product alloc] initWithCode:@"cr7296"
                                           name:@"dmn bmx 46t chain ring 110mm black"
                                       category:@"Chain rings"
                                          price:18.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:CR7296 forKey:[CR7296 uid]];
Product *FW1202 = [[Product alloc] initWithCode:@"fw1202"
                                           name:@"dicta 16t 3/32 bmx freewheel"
                                       category:@"Freewheels"
                                          price:8.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:FW1202 forKey:[FW1202 uid]];
Product *FW1203 = [[Product alloc] initWithCode:@"fw1203"
                                           name:@"dicta 17t 3/32 bmx freewheel"
                                       category:@"Freewheels"
                                          price:8.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:FW1203 forKey:[FW1203 uid]];
Product *FW1204 = [[Product alloc] initWithCode:@"fw1204"
                                           name:@"dicta 18t 3/32 bmx freewheel"
                                       category:@"Freewheels"
                                          price:8.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:FW1204 forKey:[FW1204 uid]];
Product *FW6879 = [[Product alloc] initWithCode:@"fw6879"
                                           name:@"shimano dura-ace track hub lockring"
                                       category:@"Cogs"
                                          price:11.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:FW6879 forKey:[FW6879 uid]];
Product *FW6885 = [[Product alloc] initWithCode:@"fw6885"
                                           name:@"dura-ace 13t 1/8 track cog black"
                                       category:@"Cogs "
                                          price:22.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:FW6885 forKey:[FW6885 uid]];
Product *FW6886 = [[Product alloc] initWithCode:@"fw6886"
                                           name:@"dura-ace 14t 1/8 track cog black"
                                       category:@"Cogs "
                                          price:22.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:FW6886 forKey:[FW6886 uid]];
Product *FW6887 = [[Product alloc] initWithCode:@"fw6887"
                                           name:@"dura-ace 15t 1/8 track cog black"
                                       category:@"Cogs"
                                          price:22.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:FW6887 forKey:[FW6887 uid]];
Product *FW6888 = [[Product alloc] initWithCode:@"fw6888"
                                           name:@"dura-ace 16t 1/8 track cog black "
                                       category:@"Cogs"
                                          price:22.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:FW6888 forKey:[FW6888 uid]];
Product *HB1011 = [[Product alloc] initWithCode:@"hb1011"
                                           name:@"nitto mustache 25.4mm clamp alloy bar"
                                       category:@"Handlebars "
                                          price:74.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HB1011 forKey:[HB1011 uid]];
Product *HD2111 = [[Product alloc] initWithCode:@"hd2111"
                                           name:@"starnut 1in steel or 1-1/8in aluminum starnut"
                                       category:@"Headsets"
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HD2111 forKey:[HD2111 uid]];
Product *HD3150 = [[Product alloc] initWithCode:@"hd3150"
                                           name:@"headset spacers 1in"
                                       category:@"Headsets"
                                          price:1.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HD3150 forKey:[HD3150 uid]];
Product *HD3161 = [[Product alloc] initWithCode:@"hd3161"
                                           name:@"headset spacers 1.5mm 1in silver"
                                       category:@"Headsets"
                                          price:1.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HD3161 forKey:[HD3161 uid]];
Product *HD3163 = [[Product alloc] initWithCode:@"hd3163"
                                           name:@"headset spacers 5mm 1in silver"
                                       category:@"Headsets"
                                          price:1.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HD3163 forKey:[HD3163 uid]];
Product *HD3175 = [[Product alloc] initWithCode:@"hd3175"
                                           name:@"headset spacers 2.5mm 1-1/8in"
                                       category:@"Headsets"
                                          price:1.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HD3175 forKey:[HD3175 uid]];
Product *HD3200 = [[Product alloc] initWithCode:@"hd3200"
                                           name:@"ritchey logic 1in threaded silver headset"
                                       category:@"Headsets"
                                          price:19.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HD3200 forKey:[HD3200 uid]];
Product *HD3225 = [[Product alloc] initWithCode:@"hd3225"
                                           name:@"ritchey logic 1in threadless headset black/silver"
                                       category:@"Headsets"
                                          price:20.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HD3225 forKey:[HD3225 uid]];
Product *HD3226 = [[Product alloc] initWithCode:@"hd3226"
                                           name:@"ritchey logic 1-1/8in threadless headset black"
                                       category:@"Headsets"
                                          price:20.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HD3226 forKey:[HD3226 uid]];
Product *HT1304 = [[Product alloc] initWithCode:@"ht1304"
                                           name:@"dmn handstitched leather grip brown"
                                       category:@"Grips/Bar Tapes"
                                          price:15.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT1304 forKey:[HT1304 uid]];
Product *HT1306 = [[Product alloc] initWithCode:@"ht1306"
                                           name:@"dmn handstitched leather grip black w/white"
                                       category:@"Grips/Bar Tapes"
                                          price:15.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT1306 forKey:[HT1306 uid]];
Product *HT1307 = [[Product alloc] initWithCode:@"ht1307"
                                           name:@"dmn cork mountain grips black with cork flecks"
                                       category:@"Grips/Bar Tapes"
                                          price:6.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT1307 forKey:[HT1307 uid]];
Product *HT1999 = [[Product alloc] initWithCode:@"ht1999"
                                           name:@"tressostar cloth tape black"
                                       category:@"Grips/Bar Tapes"
                                          price:4.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT1999 forKey:[HT1999 uid]];
Product *HT3808 = [[Product alloc] initWithCode:@"ht3808"
                                           name:@"bike ribbon cork bartape black"
                                       category:@"Grips/Bar Tapes"
                                          price:9.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT3808 forKey:[HT3808 uid]];
Product *HT3810 = [[Product alloc] initWithCode:@"ht3810"
                                           name:@"bike ribbon cork bartape natural"
                                       category:@"Grips/Bar Tapes"
                                          price:9.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT3810 forKey:[HT3810 uid]];
Product *HT3811 = [[Product alloc] initWithCode:@"ht3811"
                                           name:@"bike ribbon cork bartape royal blue"
                                       category:@"Grips/Bar Tapes"
                                          price:10.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT3811 forKey:[HT3811 uid]];
Product *HT3812 = [[Product alloc] initWithCode:@"ht3812"
                                           name:@"bike ribbon cork bartape red"
                                       category:@"Grips/Bar Tapes"
                                          price:9.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT3812 forKey:[HT3812 uid]];
Product *HT3813 = [[Product alloc] initWithCode:@"ht3813"
                                           name:@"bike ribbon cork bartape yellow"
                                       category:@"Grips/Bar Tapes"
                                          price:10.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT3813 forKey:[HT3813 uid]];
Product *HT3822 = [[Product alloc] initWithCode:@"ht3822"
                                           name:@"bike ribbon cork bartape dark blue"
                                       category:@"Grips/Bar Tapes"
                                          price:9.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:HT3822 forKey:[HT3822 uid]];
Product *LK4102 = [[Product alloc] initWithCode:@"lk4102"
                                           name:@"kryptonite ls u-lock 4x11.5in"
                                       category:@"Locks"
                                          price:31.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LK4102 forKey:[LK4102 uid]];
Product *LK4118 = [[Product alloc] initWithCode:@"lk4118"
                                           name:@"kryptonite evolution mini u-lock 3x5.5in"
                                       category:@"Locks"
                                          price:56.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LK4118 forKey:[LK4118 uid]];
Product *LK5010 = [[Product alloc] initWithCode:@"lk5010"
                                           name:@"on guard bulldog u-lock 4.5x9in"
                                       category:@"Locks"
                                          price:30.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LK5010 forKey:[LK5010 uid]];
Product *LK5033 = [[Product alloc] initWithCode:@"lk5033"
                                           name:@"on guard bulldog mini tc u-lock 3.5x5.5in"
                                       category:@"Locks"
                                          price:29.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LK5033 forKey:[LK5033 uid]];
Product *LT4066 = [[Product alloc] initWithCode:@"lt4066"
                                           name:@"cat eye tl-ld600-brr tail light 5led"
                                       category:@"Lights"
                                          price:18.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LT4066 forKey:[LT4066 uid]];
Product *LT4067 = [[Product alloc] initWithCode:@"lt4067"
                                           name:@"cat eye ld120 red tail light 3 led"
                                       category:@"Lights"
                                          price:8.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LT4067 forKey:[LT4067 uid]];
Product *LT4110 = [[Product alloc] initWithCode:@"lt4110"
                                           name:@"cat eye el120/ld170-r light set w/ batteries"
                                       category:@"Lights"
                                          price:27.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LT4110 forKey:[LT4110 uid]];
Product *LT7323 = [[Product alloc] initWithCode:@"lt7323"
                                           name:@"planet bike dual spot light w/batteries"
                                       category:@"Lights"
                                          price:22.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LT7323 forKey:[LT7323 uid]];
Product *LT7366 = [[Product alloc] initWithCode:@"lt7366"
                                           name:@"planet bike 1200x light set"
                                       category:@"Lights"
                                          price:18.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LT7366 forKey:[LT7366 uid]];
Product *LU2123 = [[Product alloc] initWithCode:@"lu2123"
                                           name:@"triflow 1 gallon"
                                       category:@"Lube"
                                          price:93.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LU2123 forKey:[LU2123 uid]];
Product *LU7016 = [[Product alloc] initWithCode:@"lu7016"
                                           name:@"park polylube 1000 16oz grease"
                                       category:@"Lubes"
                                          price:10.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:LU7016 forKey:[LU7016 uid]];
Product *PD1080 = [[Product alloc] initWithCode:@"pd1080"
                                           name:@"dimension sport pedals black/black 9/16in"
                                       category:@"Pedals"
                                          price:13.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:PD1080 forKey:[PD1080 uid]];
Product *PD1081 = [[Product alloc] initWithCode:@"pd1081"
                                           name:@"dimension alloy touring pedals silver 9/16in "
                                       category:@"Pedals"
                                          price:15.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:PD1081 forKey:[PD1081 uid]];
Product *PD1084 = [[Product alloc] initWithCode:@"pd1084"
                                           name:@"dimension track pedals silver 9/16in"
                                       category:@"Pedals"
                                          price:17.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:PD1084 forKey:[PD1084 uid]];
Product *PD6432 = [[Product alloc] initWithCode:@"pd6432"
                                           name:@"shimano m324 clipless pedals silver"
                                       category:@"Pedals"
                                          price:71.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:PD6432 forKey:[PD6432 uid]];
Product *PK7057 = [[Product alloc] initWithCode:@"pk7057"
                                           name:@"park vp-1 vulcanizing patch kit"
                                       category:@"Patch Kits"
                                          price:4.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:PK7057 forKey:[PK7057 uid]];
Product *PU1732 = [[Product alloc] initWithCode:@"pu1732"
                                           name:@"topeak mountain morph mini pump"
                                       category:@"Pumps"
                                          price:31.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:PU1732 forKey:[PU1732 uid]];
Product *PU1734 = [[Product alloc] initWithCode:@"pu1734"
                                           name:@"topeak road morph with gauge"
                                       category:@"Pumps"
                                          price:37.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:PU1734 forKey:[PU1734 uid]];
Product *PU4007 = [[Product alloc] initWithCode:@"pu4007"
                                           name:@"brass pv adapters"
                                       category:@"Value Adapters"
                                          price:1.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:PU4007 forKey:[PU4007 uid]];
Product *RM4447 = [[Product alloc] initWithCode:@"rm4447"
                                           name:@"velocity razor 700c 32 hole black/silver rim"
                                       category:@"Rims"
                                          price:70.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:RM4447 forKey:[RM4447 uid]];
Product *RM7509 = [[Product alloc] initWithCode:@"rm7509"
                                           name:@"alex dm18 700c 36 hole silver road rim"
                                       category:@"Rims"
                                          price:22.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:RM7509 forKey:[RM7509 uid]];
Product *RM8366 = [[Product alloc] initWithCode:@"rm8366"
                                           name:@"sun cr-18 26in 36 hole mountain rim abt black w/silver sides"
                                       category:@"Rims"
                                          price:34.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:RM8366 forKey:[RM8366 uid]];
Product *RM8619 = [[Product alloc] initWithCode:@"rm8619"
                                           name:@"salsa gordo 26in 36 hole mountain rim black"
                                       category:@"Rims"
                                          price:48.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:RM8619 forKey:[RM8619 uid]];
Product *RT1006 = [[Product alloc] initWithCode:@"rt1006"
                                           name:@"velox 22mm rim tape 1 wheel"
                                       category:@"Rim Tapes"
                                          price:4.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:RT1006 forKey:[RT1006 uid]];
Product *SA1212 = [[Product alloc] initWithCode:@"sa1212"
                                           name:@"brooks b17 saddle standard black/black rail"
                                       category:@"Saddles"
                                          price:77.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:SA1212 forKey:[SA1212 uid]];
Product *SA1214 = [[Product alloc] initWithCode:@"sa1214"
                                           name:@"brooks b17 saddle special honey copper rail"
                                       category:@"Saddles"
                                          price:92.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:SA1214 forKey:[SA1214 uid]];
Product *SA1265 = [[Product alloc] initWithCode:@"sa1265"
                                           name:@"brooks team pro saddle black copper rails"
                                       category:@"Saddles"
                                          price:152.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:SA1265 forKey:[SA1265 uid]];
Product *SM2020 = [[Product alloc] initWithCode:@"sm2020"
                                           name:@"kalloy stem 40mm 230mm 115deg silver 1in quill"
                                       category:@"Stems"
                                          price:15.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:SM2020 forKey:[SM2020 uid]];
Product *ST1560 = [[Product alloc] initWithCode:@"st1560"
                                           name:@"kalloy seatpost 26.0mmx350mm silver"
                                       category:@"Seatposts"
                                          price:16.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:ST1560 forKey:[ST1560 uid]];
Product *ST5011 = [[Product alloc] initWithCode:@"st5011"
                                           name:@"kalloy seatbinder 27mm hex key"
                                       category:@"Seatposts"
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:ST5011 forKey:[ST5011 uid]];
Product *ST5017 = [[Product alloc] initWithCode:@"st5017"
                                           name:@"kalloy seatbinder 19mm hex key"
                                       category:@"Seatposts "
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:ST5017 forKey:[ST5017 uid]];
Product *ST5018 = [[Product alloc] initWithCode:@"st5018"
                                           name:@"kalloy seatbinder 22mm hex key"
                                       category:@"Seatposts "
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:ST5018 forKey:[ST5018 uid]];
Product *ST5202 = [[Product alloc] initWithCode:@"st5202"
                                           name:@"seatbinder hex nut 8x35mm"
                                       category:@"Seatposts"
                                          price:2.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:ST5202 forKey:[ST5202 uid]];
Product *TL0582 = [[Product alloc] initWithCode:@"tl0582"
                                           name:@"pedro's campy bottom bracket & cassette socket"
                                       category:@"Tools"
                                          price:19.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL0582 forKey:[TL0582 uid]];
Product *TL2401 = [[Product alloc] initWithCode:@"tl2401"
                                           name:@"hozan bottom bracket and headset lockring tool"
                                       category:@"Tools "
                                          price:28.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL2401 forKey:[TL2401 uid]];
Product *TL7005 = [[Product alloc] initWithCode:@"tl7005"
                                           name:@"park bt-2 fourth hand tool"
                                       category:@"Tools"
                                          price:43.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7005 forKey:[TL7005 uid]];
Product *TL7015 = [[Product alloc] initWithCode:@"tl7015"
                                           name:@"park ccp-4 crank puller splined bottom bracket"
                                       category:@"Tools"
                                          price:16.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7015 forKey:[TL7015 uid]];
Product *TL7058 = [[Product alloc] initWithCode:@"tl7058"
                                           name:@"dag-1 derailleur alignment gauge"
                                       category:@"Tools"
                                          price:75.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7058 forKey:[TL7058 uid]];
Product *TL7134 = [[Product alloc] initWithCode:@"tl7134"
                                           name:@"park crs-1 crown race setter"
                                       category:@"Tools"
                                          price:94.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7134 forKey:[TL7134 uid]];
Product *TL7142 = [[Product alloc] initWithCode:@"tl7142"
                                           name:@"park tool ccw-5c crank bolt wrench"
                                       category:@"Tools"
                                          price:12.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7142 forKey:[TL7142 uid]];
Product *TL7206 = [[Product alloc] initWithCode:@"tl7206"
                                           name:@"park fr-4 atom freewheel remover"
                                       category:@"Tools"
                                          price:7.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7206 forKey:[TL7206 uid]];
Product *TL7217 = [[Product alloc] initWithCode:@"tl7217"
                                           name:@"park tire levers"
                                       category:@"Tools"
                                          price:3.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7217 forKey:[TL7217 uid]];
Product *TL7248 = [[Product alloc] initWithCode:@"tl7248"
                                           name:@"park ct-3 chain tool"
                                       category:@"Tools"
                                          price:34.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7248 forKey:[TL7248 uid]];
Product *TL7251 = [[Product alloc] initWithCode:@"tl7251"
                                           name:@"park ct-7 chain tool for 3/16in & 1/8in bmx chains"
                                       category:@"Tools"
                                          price:43.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7251 forKey:[TL7251 uid]];
Product *TL7292 = [[Product alloc] initWithCode:@"tl7292"
                                           name:@"park tool sw-40c four sided black spoke wrench"
                                       category:@"Tools"
                                          price:8.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7292 forKey:[TL7292 uid]];
Product *TL7294 = [[Product alloc] initWithCode:@"tl7294"
                                           name:@"park tool sw-42c four sided red spoke wrench"
                                       category:@"Tools"
                                          price:8.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7294 forKey:[TL7294 uid]];
Product *TL7311 = [[Product alloc] initWithCode:@"tl7311"
                                           name:@"park aws-10 folding hex set"
                                       category:@"Tools"
                                          price:8.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7311 forKey:[TL7311 uid]];
Product *TL7435 = [[Product alloc] initWithCode:@"tl7435"
                                           name:@"park sr-2 sprocket remover chain whip"
                                       category:@"Tools"
                                          price:39.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL7435 forKey:[TL7435 uid]];
Product *TL9804 = [[Product alloc] initWithCode:@"tl9804"
                                           name:@"campy ac-h/sc-s bottom bracket tool"
                                       category:@"Tools"
                                          price:88.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TL9804 forKey:[TL9804 uid]];
Product *TR3179 = [[Product alloc] initWithCode:@"tr3179"
                                           name:@"ritchey tom slick tire 26x1.4in steel bead black"
                                       category:@"Tires"
                                          price:17.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR3179 forKey:[TR3179 uid]];
Product *TR3444 = [[Product alloc] initWithCode:@"tr3444"
                                           name:@"vittoria zaffiro tire 700x23c"
                                       category:@"Tires"
                                          price:15.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR3444 forKey:[TR3444 uid]];
Product *TR3445 = [[Product alloc] initWithCode:@"tr3445"
                                           name:@"vittoria zaffiro tire 700x25c"
                                       category:@"Tires"
                                          price:15.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR3445 forKey:[TR3445 uid]];
Product *TR3446 = [[Product alloc] initWithCode:@"tr3446"
                                           name:@"vittoria zaffiro tire 700x28c"
                                       category:@"Tires"
                                          price:16.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR3446 forKey:[TR3446 uid]];
Product *TR5108 = [[Product alloc] initWithCode:@"tr5108"
                                           name:@"kenda street tire k40 24x1-3/8in steel bead black/tan"
                                       category:@"Tires"
                                          price:9.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR5108 forKey:[TR5108 uid]];
Product *TR5120 = [[Product alloc] initWithCode:@"tr5120"
                                           name:@"kenda street tire k35 27x1-1/4in steel bead black/tan"
                                       category:@"Tires"
                                          price:10.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR5120 forKey:[TR5120 uid]];
Product *TR6102 = [[Product alloc] initWithCode:@"tr6102"
                                           name:@"pana pasela tire 24x1in steel bead black/black"
                                       category:@"Tires"
                                          price:18.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR6102 forKey:[TR6102 uid]];
Product *TR9218 = [[Product alloc] initWithCode:@"tr9218"
                                           name:@"conti ultra sport tire 27x1-1/8in black"
                                       category:@"Tires"
                                          price:16.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR9218 forKey:[TR9218 uid]];
Product *TR9231 = [[Product alloc] initWithCode:@"tr9231"
                                           name:@"conti ultra gatorskin tire 700x23c"
                                       category:@"Tires"
                                          price:37.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR9231 forKey:[TR9231 uid]];
Product *TR9232 = [[Product alloc] initWithCode:@"tr9232"
                                           name:@"conti ultra gatorskin tire 700x25c"
                                       category:@"Tires"
                                          price:37.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR9232 forKey:[TR9232 uid]];
Product *TR9233 = [[Product alloc] initWithCode:@"tr9233"
                                           name:@"conti ultra gatorskin tire 700x28c"
                                       category:@"Tires"
                                          price:37.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR9233 forKey:[TR9233 uid]];
Product *TR9234 = [[Product alloc] initWithCode:@"tr9234"
                                           name:@"conti ultra gatorskin tire 700x23c folding"
                                       category:@"Tires"
                                          price:48.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR9234 forKey:[TR9234 uid]];
Product *TR9319 = [[Product alloc] initWithCode:@"tr9319"
                                           name:@"conti sport contact tire 26x1.3in black"
                                       category:@"Tires"
                                          price:28.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR9319 forKey:[TR9319 uid]];
Product *TR9321 = [[Product alloc] initWithCode:@"tr9321"
                                           name:@"conti sport contact tire 26x1.6in black"
                                       category:@"Tires"
                                          price:28.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TR9321 forKey:[TR9321 uid]];
Product *TS1110 = [[Product alloc] initWithCode:@"ts1110"
                                           name:@"dimension basic nylon toe strap 12x450mm black"
                                       category:@"Toe Straps"
                                          price:4.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TS1110 forKey:[TS1110 uid]];
Product *TS1112 = [[Product alloc] initWithCode:@"ts1112"
                                           name:@"dimension leather toe strap 380mm"
                                       category:@"Toe Straps"
                                          price:6.0
                                       quantity:1
                                        taxable:YES
                                         active:YES];
[dictionary setObject:TS1112 forKey:[TS1112 uid]];
Product *us0000 = [[Product alloc] initWithCode:@"us0000"
                                           name:@"used axles"
                                       category:@"Axles"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0000 forKey:[us0000 uid]];
Product *us0001 = [[Product alloc] initWithCode:@"us0001"
                                           name:@"used bottom brackets"
                                       category:@"Bottom brackets"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0001 forKey:[us0001 uid]];
Product *us0002 = [[Product alloc] initWithCode:@"us0002"
                                           name:@"used brakes"
                                       category:@"Brakes"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0002 forKey:[us0002 uid]];
Product *us0003 = [[Product alloc] initWithCode:@"us0003"
                                           name:@"used cable/housing"
                                       category:@"Cable/Housing"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0003 forKey:[us0003 uid]];
Product *us0004 = [[Product alloc] initWithCode:@"us0004"
                                           name:@"used cassettes"
                                       category:@"Cassettes"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0004 forKey:[us0004 uid]];
Product *us0005 = [[Product alloc] initWithCode:@"us0005"
                                           name:@"used chains"
                                       category:@"Chains"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0005 forKey:[us0005 uid]];
Product *us0006 = [[Product alloc] initWithCode:@"us0006"
                                           name:@"used chain rings"
                                       category:@"Chain rings"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0006 forKey:[us0006 uid]];
Product *us0007 = [[Product alloc] initWithCode:@"us0007"
                                           name:@"used chain ring bolts"
                                       category:@"Chain ring bolts"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0007 forKey:[us0007 uid]];
Product *us0008 = [[Product alloc] initWithCode:@"us0008"
                                           name:@"used cogs"
                                       category:@"Cogs"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0008 forKey:[us0008 uid]];
Product *us0009 = [[Product alloc] initWithCode:@"us0009"
                                           name:@"used cranks"
                                       category:@"Cranks"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0009 forKey:[us0009 uid]];
Product *us0010 = [[Product alloc] initWithCode:@"us0010"
                                           name:@"used crank bolts"
                                       category:@"Crank bolts"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0010 forKey:[us0010 uid]];
Product *us0011 = [[Product alloc] initWithCode:@"us0011"
                                           name:@"used freewheels"
                                       category:@"Freewheels"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0011 forKey:[us0011 uid]];
Product *us0012 = [[Product alloc] initWithCode:@"us0012"
                                           name:@"used grips/bar tapes"
                                       category:@"Grips/Bar Tapes"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0012 forKey:[us0012 uid]];
Product *us0013 = [[Product alloc] initWithCode:@"us0013"
                                           name:@"used handlebars"
                                       category:@"Handlebars"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0013 forKey:[us0013 uid]];
Product *us0014 = [[Product alloc] initWithCode:@"us0014"
                                           name:@"used headsets"
                                       category:@"Headsets"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0014 forKey:[us0014 uid]];
Product *us0015 = [[Product alloc] initWithCode:@"us0015"
                                           name:@"used locks"
                                       category:@"Locks"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0015 forKey:[us0015 uid]];
Product *us0016 = [[Product alloc] initWithCode:@"us0016"
                                           name:@"used lights"
                                       category:@"Lights"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0016 forKey:[us0016 uid]];
Product *us0017 = [[Product alloc] initWithCode:@"us0017"
                                           name:@"used pedals"
                                       category:@"Pedals"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0017 forKey:[us0017 uid]];
Product *us0018 = [[Product alloc] initWithCode:@"us0018"
                                           name:@"used pumps"
                                       category:@"Pumps"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0018 forKey:[us0018 uid]];
Product *us0019 = [[Product alloc] initWithCode:@"us0019"
                                           name:@"used rims"
                                       category:@"Rims"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0019 forKey:[us0019 uid]];
Product *us0020 = [[Product alloc] initWithCode:@"us0020"
                                           name:@"used rim tapes"
                                       category:@"Rim Tapes"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0020 forKey:[us0020 uid]];
Product *us0021 = [[Product alloc] initWithCode:@"us0021"
                                           name:@"used saddles"
                                       category:@"Saddles"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0021 forKey:[us0021 uid]];
Product *us0022 = [[Product alloc] initWithCode:@"us0022"
                                           name:@"used seatposts"
                                       category:@"Seatposts"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0022 forKey:[us0022 uid]];
Product *us0023 = [[Product alloc] initWithCode:@"us0023"
                                           name:@"used tires"
                                       category:@"Tires"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0023 forKey:[us0023 uid]];
Product *us0024 = [[Product alloc] initWithCode:@"us0024"
                                           name:@"used tire levers"
                                       category:@"Tire Levers"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0024 forKey:[us0024 uid]];
Product *us0025 = [[Product alloc] initWithCode:@"us0025"
                                           name:@"used toe straps"
                                       category:@"Toe Straps"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0025 forKey:[us0025 uid]];
Product *us0026 = [[Product alloc] initWithCode:@"us0026"
                                           name:@"used tools"
                                       category:@"Tools"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0026 forKey:[us0026 uid]];
Product *us0027 = [[Product alloc] initWithCode:@"us0027"
                                           name:@"used valve adapters"
                                       category:@"Valve Adapters"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0027 forKey:[us0027 uid]];
Product *us0028 = [[Product alloc] initWithCode:@"us0028"
                                           name:@"used wheels"
                                       category:@"Wheels"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0028 forKey:[us0028 uid]];
Product *us0029 = [[Product alloc] initWithCode:@"us0029"
                                           name:@"used other"
                                       category:@"Other"
                                          price:5.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:us0029 forKey:[us0029 uid]];
Product *mem000 = [[Product alloc] initWithCode:@"mem000"
                                           name:@"regular membership"
                                       category:@"Membership"
                                          price:70.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:mem000 forKey:[mem000 uid]];
Product *mem001 = [[Product alloc] initWithCode:@"mem001"
                                           name:@"deluxe membership"
                                       category:@"Membership"
                                          price:100.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:mem001 forKey:[mem001 uid]];
Product *mem002 = [[Product alloc] initWithCode:@"mem002"
                                           name:@"lifetime membership"
                                       category:@"Membership"
                                          price:1.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:mem002 forKey:[mem002 uid]];
Product *stand = [[Product alloc] initWithCode:@"stand"
                                           name:@"stand time"
                                       category:@"Stand time"
                                          price:7.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:stand forKey:[stand uid]];
Product *projec = [[Product alloc] initWithCode:@"projec"
                                           name:@"a project"
                                       category:@"Project"
                                          price:60.0
                                       quantity:999999
                                        taxable:NO
                                         active:YES];
[dictionary setObject:projec forKey:[projec uid]];


[NSKeyedArchiver archiveRootObject:dictionary toFile:pathToArchive];

}

// [NSKeyedArchiver archiveRootObject:dictionary toFile:pathToProductsArchive];

@end
