//
//  TeamStrategy.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoCoding.h"

@interface TeamStrategy : NSObject <NSCoding>

@property (nonatomic) int rushYdBonus;
@property (nonatomic) int rushAgBonus;
@property (nonatomic) int passYdBonus;
@property (nonatomic) int passAgBonus;

@property (nonatomic) int runPref; // Offense/Defense: run play frequency
@property (nonatomic) int passPref; // Offense/Defense: pass frequency
@property (nonatomic) int runUsage; // Offense: using TE to run block / Defense: using the LB/S to man-cover the RB
@property (nonatomic) int passUsage; // Offense: using the TE more often in passing / Defense: blitzing with the LB/S
@property (nonatomic) int runPotential; // Offense: RB running potential - chance that holes open up / Defense: Big Run Stop Bonus
@property (nonatomic) int runProtection; // Offense: Blocking bonus / Defense: run stop at line bonus
@property (nonatomic) int passPotential; // Offense: Big Passing play potential / Defense: deep coverage ability bonus
@property (nonatomic) int passProtection; // Offense: Pass blocking and accuracy bonus / Defense: Pass rush bonus

@property (strong, nonatomic) NSString * stratName;
@property (strong, nonatomic) NSString * stratDescription;

+(instancetype)newStrategyWithName:(NSString*)name description:(NSString*)description rYB:(int)rYB rAB:(int)rAB pYB:(int)pYB pAB:(int)pAB;
+(instancetype)newStrategyWithName:(NSString*)name description:(NSString*)description rPref:(int)rPref runProt:(int)runProt runPot:(int)runPot rUsg:(int)rUsg pPref:(int)pPref passProt:(int)passProt passPot:(int)passPot pUsg:(int)pUsg;
+(instancetype)newStrategy;

@end
