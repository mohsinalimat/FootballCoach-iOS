//
//  TeamStrategy.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamStrategy.h"

@implementation TeamStrategy
@synthesize runPref,runUsage,rushAgBonus,rushYdBonus,runPotential,runProtection,passPref,passUsage,passAgBonus,passYdBonus,passPotential,passProtection;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.stratName = [aDecoder decodeObjectForKey:@"stratName"];
        self.stratDescription = [aDecoder decodeObjectForKey:@"stratDescription"];

        self.rushYdBonus = [aDecoder decodeIntForKey:@"rushYdBonus"];
        self.rushAgBonus = [aDecoder decodeIntForKey:@"rushAgBonus"];
        self.passYdBonus = [aDecoder decodeIntForKey:@"passYdBonus"];
        self.passAgBonus = [aDecoder decodeIntForKey:@"passAgBonus"];

        if ([aDecoder containsValueForKey:@"runPref"]) {
            self.runPref = [aDecoder decodeIntForKey:@"runPref"];
        } else {
            self.runPref = 1;
        }

        if ([aDecoder containsValueForKey:@"passPref"]) {
            self.passPref = [aDecoder decodeIntForKey:@"passPref"];
        } else {
            self.passPref = 1;
        }

        if ([aDecoder containsValueForKey:@"runPotential"]) {
            self.runPotential = [aDecoder decodeIntForKey:@"runPotential"];
        } else {
            self.runPotential = 0;
        }

        if ([aDecoder containsValueForKey:@"runProtection"]) {
            self.runProtection = [aDecoder decodeIntForKey:@"runProtection"];
        } else {
            self.runProtection = 0;
        }

        if ([aDecoder containsValueForKey:@"passPotential"]) {
            self.passPotential = [aDecoder decodeIntForKey:@"passPotential"];
        } else {
            self.passPotential = 0;
        }

        if ([aDecoder containsValueForKey:@"passProtection"]) {
            self.passProtection = [aDecoder decodeIntForKey:@"passProtection"];
        } else {
            self.passProtection = 0;
        }
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.rushYdBonus forKey:@"rushYdBonus"];
    [aCoder encodeInt:self.rushAgBonus forKey:@"rushAgBonus"];
    [aCoder encodeInt:self.passAgBonus forKey:@"passAgBonus"];
    [aCoder encodeInt:self.passYdBonus forKey:@"passYdBonus"];

    [aCoder encodeInt:self.runPref forKey:@"runPref"];
    [aCoder encodeInt:self.passPref forKey:@"passPref"];

    [aCoder encodeInt:self.runProtection forKey:@"runProtection"];
    [aCoder encodeInt:self.runPotential forKey:@"runPotential"];
    [aCoder encodeInt:self.passProtection forKey:@"passProtection"];
    [aCoder encodeInt:self.passPotential forKey:@"passPotential"];

    [aCoder encodeObject:self.stratDescription forKey:@"stratDescription"];
    [aCoder encodeObject:self.stratName forKey:@"stratName"];
}

+(instancetype)newStrategyWithName:(NSString*)name description:(NSString*)description rPref:(int)rPref runProt:(int)runProt runPot:(int)runPot rUsg:(int)rUsg pPref:(int)pPref passProt:(int)passProt passPot:(int)passPot pUsg:(int)pUsg {
    return [[TeamStrategy alloc] initWithName:name description:description rPref:rPref pPref:pPref runPot:runPot passPot:passPot runProt:runProt passProt:passProt rUsg:rUsg pUsg:pUsg];
}

+(instancetype)newStrategy {
    return [[TeamStrategy alloc] initWithName:@"Pro-Style" description:@"Play a standard pro-style offense with equal emphasis on passing and running. (default)\n\nArchetypes Needed:\nAny" rPref:1 pPref:1 runPot:0 passPot:0 runProt:0 passProt:0 rUsg:1 pUsg:1];
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

-(instancetype)initWithName:(NSString *)name description:(NSString *)description rPref:(int)rPref pPref:(int)pPref runPot:(int)runPot passPot:(int)passPot runProt:(int)runProt passProt:(int)passProt rUsg:(int)rUsg pUsg:(int)pUsg {
    self = [super init];
    if (self) {
        self.stratName = name;
        self.stratDescription = description;
        
        self.runPref = rPref;
        self.runUsage = rUsg;
        self.rushYdBonus = runPot;
        self.rushAgBonus = runProt;
        self.runPotential = runPot;
        self.runProtection = runProt;
        
        self.passPref = pPref;
        self.passUsage = pUsg;
        self.passYdBonus = passPot;
        self.passAgBonus = passProt;
        self.passPotential = passPot;
        self.passProtection = passProt;
    }
    return self;
}

@end
