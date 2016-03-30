//
//  PlayerRB.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerRB : Player <NSCoding>

@property (nonatomic) int ratRushPow;
//RushSpd affects how long he can run
@property (nonatomic) int ratRushSpd;
//RushEva affects how easily he can dodge tackles
@property (nonatomic) int ratRushEva;

//Stats
@property (nonatomic) int statsRushAtt;
@property (nonatomic) int statsRushYards;
@property (nonatomic) int statsTD;
@property (nonatomic) int statsFumbles;

//Career Stats
@property (nonatomic) int careerStatsRushAtt;
@property (nonatomic) int careerStatsRushYards;
@property (nonatomic) int careerStatsTD;
@property (nonatomic) int careerStatsFumbles;

-(NSMutableArray*)getStatsVector;
+(instancetype)newRBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow speed:(int)spd eva:(int)eva;
+(instancetype)newRBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;

@end
