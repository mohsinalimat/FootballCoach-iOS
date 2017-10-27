//
//  TeamStrategy.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamStrategy : NSObject <NSCoding>

// old metrics
@property (nonatomic) int rushYdBonus;
@property (nonatomic) int rushAgBonus;
@property (nonatomic) int passYdBonus;
@property (nonatomic) int passAgBonus;

// new metrics
@property (nonatomic) int runPref;
@property (nonatomic) int passPref;
@property (nonatomic) int runUsage;
@property (nonatomic) int passUsage;
@property (nonatomic) int runPotential; // rush yd bonus
@property (nonatomic) int runProtection; // rush ag bonus
@property (nonatomic) int passPotential; // pass yd bonus
@property (nonatomic) int passProtection; // pass ag bonus

@property (strong, nonatomic) NSString * stratName;
@property (strong, nonatomic) NSString * stratDescription;

+(instancetype)newStrategyWithName:(NSString*)name description:(NSString*)description rYB:(int)rYB rAB:(int)rAB pYB:(int)pYB pAB:(int)pAB;
+(instancetype)newStrategyWithName:(NSString*)name description:(NSString*)description rPref:(int)rPref runProt:(int)runProt runPot:(int)runPot rUsg:(int)rUsg pPref:(int)pPref passProt:(int)passProt passPot:(int)passPot pUsg:(int)pUsg;
+(instancetype)newStrategy;

@end
