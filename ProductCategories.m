//
//  ProductCategories.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/18/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ProductCategories.h"
#import "ProductCategory.h"
#import "ProductBrowserNode.h"
#import "Product.h"

@implementation ProductCategories

+ (ProductCategories *)sharedInstance {
 // //NSLog(@"in sharedInstance ProductCategories");
  static ProductCategories *s_MySingleton = nil;
  
  @synchronized([ProductCategories class]) {
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
    ////NSLog(@"in product categories initSingleton");
    NSString *pathString = @"/Library/Application Support/BicycleKitchenPOS/productCategories.db";
    [self setPathToArchive:[pathString stringByStandardizingPath]];
    [self setDictionary:[NSKeyedUnarchiver unarchiveObjectWithFile:pathToArchive]];
    [self setNotificationChangeString:@"ProductCategories"];
    // run this to initialize categories
    //[self makeProductCategories];

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
  return [NSString stringWithFormat:@"<ProductCategories: %@>", dictionary];
  
}


- (void)incfCategoryTimesViewedForProduct:(Product *)p {
  NSString *pcat = [p productCategory];
  ProductCategory *pc = [dictionary objectForKey:pcat];
  if (pc != nil) {
    [pc incfTimesViewed];
    [self saveToDisk];
  }
}

- (ProductCategory *)productCategoryForProduct:(Product *)p {
  NSString *pcat = [p productCategory];
  ProductCategory *pc = [dictionary objectForKey:pcat];
  return pc;
}

- (ProductCategory *)productCategoryForCategoryName:(NSString *)name {
  NSEnumerator *e = [dictionary objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    NSString *dn = [value displayName];
    if ([dn isEqualToString:name]) {
      return value;
    }
  }
  return nil;
}

//******************************************************************************
// array from singleton
//******************************************************************************

- (NSArray *)arrayFromCategoriesInSingleton {
  NSEnumerator *enumerator;
  NSMutableArray *categoriesArray = [[NSMutableArray alloc] initWithCapacity:[dictionary count]];
  id value;
  int counter = 0;
  enumerator = [dictionary objectEnumerator];
  while ((value = [enumerator nextObject])) {
    [categoriesArray insertObject:value atIndex:counter++];
  }
  
//  NSSortDescriptor *timesViewedDescriptor;
//  
//  timesViewedDescriptor = 
//    [[[NSSortDescriptor alloc] initWithKey:@"timesViewed" 
//                                 ascending:NO
//                                  selector:@selector(compare:)] autorelease];
  NSSortDescriptor *displayNameDescriptor;
  
  displayNameDescriptor = 
    [[NSSortDescriptor alloc] initWithKey:@"displayName" 
                                 ascending:YES
                                  selector:@selector(caseInsensitiveCompare:)];
  
  NSArray *sortDescriptors;
  
//  sortDescriptors = 
//    [NSArray arrayWithObjects:timesViewedDescriptor, displayNameDescriptor,nil];
  

  sortDescriptors = 
    [NSArray arrayWithObjects:displayNameDescriptor,nil];

  NSArray *sortedArray;
  
  sortedArray = [categoriesArray sortedArrayUsingDescriptors:sortDescriptors];
  
  [categoriesArray release];
  [displayNameDescriptor release];
  return sortedArray;
}

- (NSArray *)arrayForBrowserFromProducts:(NSMutableDictionary *)products {
  
  NSArray *sortedArray = [self arrayFromCategoriesInSingleton];
  
  unsigned int i, count = [sortedArray count];
  for (i = 0; i < count; i++) {
    ProductCategory *cat = [sortedArray objectAtIndex:i];
    NSString *displayName = [cat displayName];
    NSArray *tmp = [self sortedProducts:products forCatagory:displayName];
    [cat setContents:tmp];
  }
  ////NSLog(@"sortedArray: %@", sortedArray);
  return sortedArray;
}


- (NSArray *)sortedProducts:(NSMutableDictionary *)products
                forCatagory:(NSString *)category {
  NSMutableArray *result = [[NSMutableArray alloc] init];
  
  NSEnumerator *enumerator = [products objectEnumerator];
  id value;
  while ((value = [enumerator nextObject])) {
    NSString *pc = [value productCategory];
    if ([pc isEqualToString:category]) {
      [result addObject:value];
    }
  }
  
  ////NSLog(@"category: %@ result: %@", category, result);
  
//  NSSortDescriptor *timesViewedDescriptor;
//  
//  timesViewedDescriptor = 
//    [[[NSSortDescriptor alloc] initWithKey:@"timesViewed" 
//                                 ascending:NO
//                                  selector:@selector(compare:)] autorelease];
  NSSortDescriptor *displayNameDescriptor;
  
  displayNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName" 
                                                      ascending:YES
                                                       selector:@selector(caseInsensitiveCompare:)];
  
  
  NSArray *sortDescriptors;
  
//  sortDescriptors = 
//    [NSArray arrayWithObjects:timesViewedDescriptor, displayNameDescriptor,nil];
  
  sortDescriptors = [NSArray arrayWithObjects:displayNameDescriptor,nil];

  
  NSArray *sortedArray = [result sortedArrayUsingDescriptors:sortDescriptors];

  [result release];
  [displayNameDescriptor release];
  
  return sortedArray;
  
}

- (void)makeProductCategories {
  ProductCategory *axles = [[ProductCategory alloc] initWithDisplayName:@"Axles"];
  [dictionary setObject:axles forKey:[axles uid]];
  [axles release];
  ProductCategory *bottom_brackets = [[ProductCategory alloc] initWithDisplayName:@"Bottom brackets"];
  [dictionary setObject:bottom_brackets forKey:[bottom_brackets uid]];
  [bottom_brackets release];
  ProductCategory *brakes = [[ProductCategory alloc] initWithDisplayName:@"Brakes"];
  [dictionary setObject:brakes forKey:[brakes uid]];
  [brakes release];
  ProductCategory *cable_housing = [[ProductCategory alloc] initWithDisplayName:@"Cable/Housing"];
  [dictionary setObject:cable_housing forKey:[cable_housing uid]];
  [cable_housing release];
  ProductCategory *cassettes = [[ProductCategory alloc] initWithDisplayName:@"Cassettes"];
  [dictionary setObject:cassettes forKey:[cassettes uid]];
  [cassettes release];
  ProductCategory *chains = [[ProductCategory alloc] initWithDisplayName:@"Chains"];
  [dictionary setObject:chains forKey:[chains uid]];
  [chains release];
  ProductCategory *chain_rings = [[ProductCategory alloc] initWithDisplayName:@"Chain rings"];
  [dictionary setObject:chain_rings forKey:[chain_rings uid]];
  [chain_rings release];
  ProductCategory *chain_ring_bolts = [[ProductCategory alloc] initWithDisplayName:@"Chain ring bolts"];
  [dictionary setObject:chain_ring_bolts forKey:[chain_ring_bolts uid]];
  [chain_ring_bolts release];
  ProductCategory *classes = [[ProductCategory alloc] initWithDisplayName:@"Classes"];
  [dictionary setObject:classes forKey:[classes uid]];
  [classes release];
  ProductCategory *cogs = [[ProductCategory alloc] initWithDisplayName:@"Cogs"];
  [dictionary setObject:cogs forKey:[cogs uid]];
  [cogs release];
  ProductCategory *cranks = [[ProductCategory alloc] initWithDisplayName:@"Cranks"];
  [dictionary setObject:cranks forKey:[cranks uid]];
  [cranks release];
  ProductCategory *crank_bolts = [[ProductCategory alloc] initWithDisplayName:@"Crank bolts"];
  [dictionary setObject:crank_bolts forKey:[crank_bolts uid]];
  [crank_bolts release];
  ProductCategory *freewheels = [[ProductCategory alloc] initWithDisplayName:@"Freewheels"];
  [dictionary setObject:freewheels forKey:[freewheels uid]];
  [freewheels release];
  ProductCategory *grips_bar_tapes = [[ProductCategory alloc] initWithDisplayName:@"Grips/Bar Tapes"];
  [dictionary setObject:grips_bar_tapes forKey:[grips_bar_tapes uid]];
  [grips_bar_tapes release];
  ProductCategory *handlebars = [[ProductCategory alloc] initWithDisplayName:@"Handlebars"];
  [dictionary setObject:handlebars forKey:[handlebars uid]];
  [handlebars release];
  ProductCategory *headsets = [[ProductCategory alloc] initWithDisplayName:@"Headsets"];
  [dictionary setObject:headsets forKey:[headsets uid]];
  [headsets release];
	ProductCategory *helmets = [[ProductCategory alloc] initWithDisplayName:@"Helmets"];
  [dictionary setObject:helmets forKey:[helmets uid]];
  [helmets release];
  ProductCategory *locks = [[ProductCategory alloc] initWithDisplayName:@"Locks"];
  [dictionary setObject:locks forKey:[locks uid]];
  [locks release];
  ProductCategory *lights = [[ProductCategory alloc] initWithDisplayName:@"Lights"];
  [dictionary setObject:lights forKey:[lights uid]];
  [lights release];
  ProductCategory *lube = [[ProductCategory alloc] initWithDisplayName:@"Lube"];
  [dictionary setObject:lube forKey:[lube uid]];
  [lube release];
  ProductCategory *memberships = [[ProductCategory alloc] initWithDisplayName:@"Memberships"];
  [dictionary setObject:memberships forKey:[memberships uid]];
  [memberships release];
  ProductCategory *patch_kits = [[ProductCategory alloc] initWithDisplayName:@"Patch Kits"];
  [dictionary setObject:patch_kits forKey:[patch_kits uid]];
  [patch_kits release];
  ProductCategory *pedals = [[ProductCategory alloc] initWithDisplayName:@"Pedals"];
  [dictionary setObject:pedals forKey:[pedals uid]];
  [pedals release];
  ProductCategory *pumps = [[ProductCategory alloc] initWithDisplayName:@"Pumps"];
  [dictionary setObject:pumps forKey:[pumps uid]];
  [pumps release];
  ProductCategory *rims = [[ProductCategory alloc] initWithDisplayName:@"Rims"];
  [dictionary setObject:rims forKey:[rims uid]];
  [rims release];
  ProductCategory *rim_tapes = [[ProductCategory alloc] initWithDisplayName:@"Rim Tapes"];
  [dictionary setObject:rim_tapes forKey:[rim_tapes uid]];
  [rim_tapes release];
  ProductCategory *saddles = [[ProductCategory alloc] initWithDisplayName:@"Saddles"];
  [dictionary setObject:saddles forKey:[saddles uid]];
  [saddles release];
  ProductCategory *seatposts = [[ProductCategory alloc] initWithDisplayName:@"Seatposts"];
  [dictionary setObject:seatposts forKey:[seatposts uid]];
  [seatposts release];
  ProductCategory *tires = [[ProductCategory alloc] initWithDisplayName:@"Tires"];
  [dictionary setObject:tires forKey:[tires uid]];
  [tires release];
  ProductCategory *tire_levers = [[ProductCategory alloc] initWithDisplayName:@"Tire Levers"];
  [dictionary setObject:tire_levers forKey:[tire_levers uid]];
  [tire_levers release];
  ProductCategory *toe_straps = [[ProductCategory alloc] initWithDisplayName:@"Toe Straps"];
  [dictionary setObject:toe_straps forKey:[toe_straps uid]];
  [toe_straps release];
  ProductCategory *tools = [[ProductCategory alloc] initWithDisplayName:@"Tools"];
  [dictionary setObject:tools forKey:[tools uid]];
  [tools release];
  ProductCategory *tubes = [[ProductCategory alloc] initWithDisplayName:@"Tubes"];
  [dictionary setObject:tubes forKey:[tubes uid]];
  [tubes release];
  ProductCategory *valve_adapters = [[ProductCategory alloc] initWithDisplayName:@"Valve Adapters"];
  [dictionary setObject:valve_adapters forKey:[valve_adapters uid]];
  [valve_adapters release];
  ProductCategory *wheels = [[ProductCategory alloc] initWithDisplayName:@"Wheels"];
  [dictionary setObject:wheels forKey:[wheels uid]];
  [wheels release];
  ProductCategory *other = [[ProductCategory alloc] initWithDisplayName:@"Other"];
  [dictionary setObject:other forKey:[other uid]];
  [other release];
  [NSKeyedArchiver archiveRootObject:dictionary toFile:pathToArchive];
  
}

@end
