//
//  PlayerQB.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerQB : Player <NSCoding>
@property (nonatomic) int ratPassPow;
//PassAcc affects how accurate his passes are
@property (nonatomic) int ratPassAcc;
//PassEva (evasiveness) affects how easily he can dodge sacks
@property (nonatomic) int ratPassEva;
//PassEva (evasiveness) affects how easily he can dodge sacks
@property (nonatomic) int ratSpeed;


//Stats
@property (nonatomic) int statsPassAtt;
@property (nonatomic) int statsPassComp;
@property (nonatomic) int statsTD;
@property (nonatomic) int statsInt;
@property (nonatomic) int statsPassYards;
@property (nonatomic) int statsSacked;

//Stats
@property (nonatomic) int statsRushAtt;
@property (nonatomic) int statsRushYards;
@property (nonatomic) int statsRushTD;
@property (nonatomic) int statsFumbles;

//Career Stats
@property (nonatomic) int careerStatsRushAtt;
@property (nonatomic) int careerStatsRushYards;
@property (nonatomic) int careerStatsRushTD;
@property (nonatomic) int careerStatsFumbles;

//career stats
@property (nonatomic) int careerStatsPassAtt;
@property (nonatomic) int careerStatsPassComp;
@property (nonatomic) int careerStatsTD;
@property (nonatomic) int careerStatsInt;
@property (nonatomic) int careerStatsPassYards;
@property (nonatomic) int careerStatsSacked;

+(instancetype)newQBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc eva:(int)eva dur:(int)dur;
+(instancetype)newQBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
