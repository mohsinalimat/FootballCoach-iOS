//
//  PlayerQB.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerQB : Player
@property (nonatomic) NSInteger ratPassPow;
//PassAcc affects how accurate his passes are
@property (nonatomic) NSInteger ratPassAcc;
//PassEva (evasiveness) affects how easily he can dodge sacks
@property (nonatomic) NSInteger ratPassEva;

//Stats
@property (nonatomic) NSInteger statsPassAtt;
@property (nonatomic) NSInteger statsPassComp;
@property (nonatomic) NSInteger statsTD;
@property (nonatomic) NSInteger statsInt;
@property (nonatomic) NSInteger statsPassYards;
@property (nonatomic) NSInteger statsSacked;

+(instancetype)newQBWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow accuracy:(NSInteger)acc eva:(NSInteger)eva;
+(instancetype)newQBWithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t;
-(NSMutableArray*)getStatsVector;
@end
