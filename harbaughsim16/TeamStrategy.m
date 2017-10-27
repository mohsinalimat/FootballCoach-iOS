//
//  TeamStrategy.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamStrategy.h"

@implementation TeamStrategy

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _stratName = [aDecoder decodeObjectForKey:@"stratName"];
        _stratDescription = [aDecoder decodeObjectForKey:@"stratDescription"];
        
        _rushYdBonus = [aDecoder decodeIntForKey:@"rushYdBonus"];
        _rushAgBonus = [aDecoder decodeIntForKey:@"rushAgBonus"];
        _passYdBonus = [aDecoder decodeIntForKey:@"passYdBonus"];
        _passAgBonus = [aDecoder decodeIntForKey:@"passAgBonus"];
        
        if ([aDecoder valueForKey:@"runPref"]) {
            _runPref = [aDecoder decodeIntForKey:@"runPref"];
        } else {
            _runPref = 1;
        }
        
        if ([aDecoder valueForKey:@"passPref"]) {
            _passPref = [aDecoder decodeIntForKey:@"passPref"];
        } else {
            _passPref = 1;
        }
        
        if ([aDecoder valueForKey:@"runPotential"]) {
            _runPotential = [aDecoder decodeIntForKey:@"runPotential"];
        } else {
            _runPotential = 0;
        }
        
        if ([aDecoder valueForKey:@"runProtection"]) {
            _runProtection = [aDecoder decodeIntForKey:@"runProtection"];
        } else {
            _runProtection = 0;
        }
        
        if ([aDecoder valueForKey:@"passPotential"]) {
            _passPotential = [aDecoder decodeIntForKey:@"passPotential"];
        } else {
            _passPotential = 0;
        }
        
        if ([aDecoder valueForKey:@"passProtection"]) {
            _passProtection = [aDecoder decodeIntForKey:@"passProtection"];
        } else {
            _passProtection = 0;
        }
        
        if ([aDecoder valueForKey:@"runUsage"]) {
            _runUsage = [aDecoder decodeIntForKey:@"runUsage"];
        } else {
            _runUsage = 1;
        }
        
        if ([aDecoder valueForKey:@"passUsage"]) {
            _passUsage = [aDecoder decodeIntForKey:@"passUsage"];
        } else {
            _passUsage = 1;
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:_rushYdBonus forKey:@"rushYdBonus"];
    [aCoder encodeInt:_rushAgBonus forKey:@"rushAgBonus"];
    [aCoder encodeInt:_passAgBonus forKey:@"passAgBonus"];
    [aCoder encodeInt:_passYdBonus forKey:@"passYdBonus"];
    
    [aCoder encodeInt:_runPref forKey:@"runPref"];
    [aCoder encodeInt:_passPref forKey:@"passPref"];
    
    [aCoder encodeInt:_runProtection forKey:@"runProtection"];
    [aCoder encodeInt:_runPotential forKey:@"runPotential"];
    [aCoder encodeInt:_passProtection forKey:@"passProtection"];
    [aCoder encodeInt:_passPotential forKey:@"passPotential"];
    
    [aCoder encodeObject:_stratDescription forKey:@"stratDescription"];
    [aCoder encodeObject:_stratName forKey:@"stratName"];
}

+(instancetype)newStrategyWithName:(NSString*)name description:(NSString*)description rPref:(int)rPref runProt:(int)runProt runPot:(int)runPot rUsg:(int)rUsg pPref:(int)pPref passProt:(int)passProt passPot:(int)passPot pUsg:(int)pUsg {
    return [[TeamStrategy alloc] initWithName:name description:description rPref:rPref pPref:pPref runPot:runPot passPot:passPot runProt:runProt passProt:passProt rUsg:rUsg pUsg:pUsg];
}

+(instancetype)newStrategy {
    return [[TeamStrategy alloc] initWithName:@"Balanced" description:@"Will play a normal O/D with no bonus either way, but no penalties either." rPref:1 pPref:1 runPot:0 passPot:0 runProt:0 passProt:0 rUsg:1 pUsg:1];
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
