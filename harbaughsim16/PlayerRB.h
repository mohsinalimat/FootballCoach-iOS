//
//  PlayerRB.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerRB : Player

@property (nonatomic) NSInteger ratRushPow;
//RushSpd affects how long he can run
@property (nonatomic) NSInteger ratRushSpd;
//RushEva affects how easily he can dodge tackles
@property (nonatomic) NSInteger ratRushEva;

//Stats
@property (nonatomic) NSInteger statsRushAtt;
@property (nonatomic) NSInteger statsRushYards;
@property (nonatomic) NSInteger statsTD;
@property (nonatomic) NSInteger statsFumbles;
-(NSMutableArray*)getStatsVector;
+(instancetype)newRBWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow speed:(NSInteger)spd eva:(NSInteger)eva;
+(instancetype)newRBWithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t;

@end
