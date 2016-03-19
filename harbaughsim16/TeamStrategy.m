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
    TeamStrategy *strat  = [super init];
    if (self) {
        strat.stratName = @"No Preference";
        strat.stratDescription = @"Will play a normal O/D with no bonus either way, but no penalties either.";
        strat.rushYdBonus = 0;
        strat.rushAgBonus = 0;
        strat.passYdBonus = 0;
        strat.passAgBonus = 0;
    }
    return strat;
}

+(instancetype)newStrategyWithName:(NSString *)name description:(NSString *)description rYB:(int)rYB rAB:(int)rAB pYB:(int)pYB pAB:(int)pAB {
    TeamStrategy *strat = [[self class] newStrategy];
    if (self) {
        strat.stratName = name;
        strat.stratDescription = description;
        strat.rushYdBonus = rYB;
        strat.rushAgBonus = rAB;
        strat.passYdBonus = pYB;
        strat.passAgBonus = pAB;
    }
    return strat;
}
@end
