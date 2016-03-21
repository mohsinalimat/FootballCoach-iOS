//
//  TeamStrategy.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamStrategy.h"

@implementation TeamStrategy

+(instancetype)newStrategy {
    return [[TeamStrategy alloc] initWithName:@"No Preference" description:@"Will play a normal O/D with no bonus either way, but no penalties either." rYB:0 rAB:0 pYB:0 pAB:0];
}

+(instancetype)newStrategyWithName:(NSString *)name description:(NSString *)description rYB:(int)rYB rAB:(int)rAB pYB:(int)pYB pAB:(int)pAB {
    return [[TeamStrategy alloc] initWithName:name description:description rYB:rYB rAB:rAB pYB:pYB pAB:pAB];
}

-(instancetype)initWithName:(NSString *)name description:(NSString *)description rYB:(int)rYB rAB:(int)rAB pYB:(int)pYB pAB:(int)pAB {
    self = [super init];
    if (self) {
        self.stratName = name;
        self.stratDescription = description;
        self.rushYdBonus = rYB;
        self.rushAgBonus = rAB;
        self.passYdBonus = pYB;
        self.passAgBonus = pAB;
    }
    return self;
}
@end
