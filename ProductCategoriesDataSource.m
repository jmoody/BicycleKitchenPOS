//
//  ProductCategoriesDataSource.m
//  BicycleKitchenPOS
//
//  Created by moody on 11/18/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "ProductCategoriesDataSource.h"


@implementation ProductCategoriesDataSource

- (id) init {
  self = [super init];
  if (self != nil) {
    [self makeData];
    previousSearchStringLength = 0;
  }
  return self;
}

- (void) dealloc {
  NSEnumerator *e = [data objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    [value release];
  }
  [data release];
  [super dealloc];
}


- (NSArray *)data {
  return data;
}

- (void)setData:(NSArray *)newData {
  if (newData != data) {
    [data release];  
    data = [newData mutableCopy];
  }
}

- (int)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
  return [data count];
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(int)index {
  return [data objectAtIndex:index];
}

- (NSString *)categoryAtIndex:(int)index {
  return [data objectAtIndex:index];
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)uncompletedString {
  ////NSLog(@"in string completion");
  NSString *searchString = [uncompletedString lowercaseString];
  ////NSLog(@"searchString: %@", searchString);
  NSEnumerator *e = [data objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    NSRange codeRange = [[value lowercaseString] rangeOfString:searchString options:NSAnchoredSearch];
    if ((codeRange.length) > 0) {
      return value;
    }
  }
  return searchString;
}

- (bool)validCategory:(NSString *)category {
  NSEnumerator *e = [data objectEnumerator];
  id value;
  while (value = [e nextObject]) {
    if ([value isEqualToString:category]) {
      return YES;
    }
  }
  NSString *project = [NSString stringWithFormat:@"Project"];
  NSString *stand = [NSString stringWithFormat:@"Stand time"];
  if ([category isEqualToString:project] || [category isEqualToString:stand]) {
    return YES;
  }
  return NO;
}

- (void)makeData {
  NSMutableArray *tmp = [[NSMutableArray alloc] init];
  int counter = 0;
  NSString *axles = [NSString stringWithFormat:@"Axles"];
  [tmp insertObject:axles atIndex:counter];
  counter++;
  NSString *bottom_brackets = [NSString stringWithFormat:@"Bottom brackets"];
  [tmp insertObject:bottom_brackets atIndex:counter];
  counter++;
  NSString *brakes = [NSString stringWithFormat:@"Brakes"];
  [tmp insertObject:brakes atIndex:counter];
  counter++;
  NSString *cable_housing = [NSString stringWithFormat:@"Cable/Housing"];
  [tmp insertObject:cable_housing atIndex:counter];
  counter++;
  NSString *cassettes = [NSString stringWithFormat:@"Cassettes"];
  [tmp insertObject:cassettes atIndex:counter];
  counter++;
  NSString *chains = [NSString stringWithFormat:@"Chains"];
  [tmp insertObject:chains atIndex:counter];
  counter++;
  NSString *chain_rings = [NSString stringWithFormat:@"Chain rings"];
  [tmp insertObject:chain_rings atIndex:counter];
  counter++;
  NSString *chain_ring_bolts = [NSString stringWithFormat:@"Chain ring bolts"];
  [tmp insertObject:chain_ring_bolts atIndex:counter];
  counter++;
	NSString *clothing_apparel = [NSString stringWithFormat:@"Clothing/Apparel"];
  [tmp insertObject:clothing_apparel atIndex:counter];
  counter++;
  NSString *cogs = [NSString stringWithFormat:@"Cogs"];
  [tmp insertObject:cogs atIndex:counter];
  counter++;
  NSString *cranks = [NSString stringWithFormat:@"Cranks"];
  [tmp insertObject:cranks atIndex:counter];
  counter++;
  NSString *crank_bolts = [NSString stringWithFormat:@"Crank bolts"];
  [tmp insertObject:crank_bolts atIndex:counter];
  counter++;
	NSString *derailleurs = [NSString stringWithFormat:@"Derailleurs"];
  [tmp insertObject:derailleurs atIndex:counter];
  counter++;
  NSString *forks = [NSString stringWithFormat:@"Forks"];
  [tmp insertObject:forks atIndex:counter];
  counter++;
  NSString *freewheels = [NSString stringWithFormat:@"Freewheels"];
  [tmp insertObject:freewheels atIndex:counter];
  counter++;
  NSString *grips_bar_tapes = [NSString stringWithFormat:@"Grips/Bar Tapes"];
  [tmp insertObject:grips_bar_tapes atIndex:counter];
  counter++;
  NSString *handlebars = [NSString stringWithFormat:@"Handlebars"];
  [tmp insertObject:handlebars atIndex:counter];
  counter++;
  NSString *headsets = [NSString stringWithFormat:@"Headsets"];
  [tmp insertObject:headsets atIndex:counter];
  counter++;
	NSString *helmets = [NSString stringWithFormat:@"Helmets"];
	[tmp insertObject:helmets atIndex:counter];
	counter++;
  NSString *locks = [NSString stringWithFormat:@"Locks"];
  [tmp insertObject:locks atIndex:counter];
  counter++;
  NSString *lights = [NSString stringWithFormat:@"Lights"];
  [tmp insertObject:lights atIndex:counter];
  counter++;
  NSString *lube = [NSString stringWithFormat:@"Lube"];
  [tmp insertObject:lube atIndex:counter];
  counter++;
  NSString *memberships = [NSString stringWithFormat:@"Memberships"];
  [tmp insertObject:memberships atIndex:counter];
  counter++;
  NSString *patch_kits = [NSString stringWithFormat:@"Patch Kits"];
  [tmp insertObject:patch_kits atIndex:counter];
  counter++;
  NSString *pedals = [NSString stringWithFormat:@"Pedals"];
  [tmp insertObject:pedals atIndex:counter];
  counter++;
  NSString *pumps = [NSString stringWithFormat:@"Pumps"];
  [tmp insertObject:pumps atIndex:counter];
  counter++;
  NSString *rims = [NSString stringWithFormat:@"Rims"];
  [tmp insertObject:rims atIndex:counter];
  counter++;
  NSString *rim_tapes = [NSString stringWithFormat:@"Rim Tapes"];
  [tmp insertObject:rim_tapes atIndex:counter];
  counter++;
  NSString *saddles = [NSString stringWithFormat:@"Saddles"];
  [tmp insertObject:saddles atIndex:counter];
  counter++;
  NSString *seatposts = [NSString stringWithFormat:@"Seatposts"];
  [tmp insertObject:seatposts atIndex:counter];
  counter++;
  NSString *shifters = [NSString stringWithFormat:@"Shifters"];
  [tmp insertObject:shifters atIndex:counter];
  counter++;
	NSString *stem = [NSString stringWithFormat:@"Stem"];
  [tmp insertObject:stem atIndex:counter];
  counter++;
	NSString *tires = [NSString stringWithFormat:@"Tires"];
  [tmp insertObject:tires atIndex:counter];
  counter++;
  NSString *tire_levers = [NSString stringWithFormat:@"Tire Levers"];
  [tmp insertObject:tire_levers atIndex:counter];
  counter++;
  NSString *toe_straps = [NSString stringWithFormat:@"Toe Straps"];
  [tmp insertObject:toe_straps atIndex:counter];
  counter++;
  NSString *tools = [NSString stringWithFormat:@"Tools"];
  [tmp insertObject:tools atIndex:counter];
  counter++;
  NSString *tubes = [NSString stringWithFormat:@"Tubes"];
  [tmp insertObject:tubes atIndex:counter];
  counter++;
  NSString *valve_adapters = [NSString stringWithFormat:@"Valve Adapters"];
  [tmp insertObject:valve_adapters atIndex:counter];
  counter++;
  NSString *wheels = [NSString stringWithFormat:@"Wheels"];
  [tmp insertObject:wheels atIndex:counter];
  counter++;
  NSString *workshops = [NSString stringWithFormat:@"Workshops"];
  [tmp insertObject:workshops atIndex:counter];
  counter++;  
  NSString *other = [NSString stringWithFormat:@"Other"];
  [tmp insertObject:other atIndex:counter];
  counter++;  
  [self setData:tmp];
  [tmp release];
  
}

@end
