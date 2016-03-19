//
//  PlayerQB.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerQB : Player
@property (nonatomic) int ratPassPow;
//PassAcc affects how accurate his passes are
@property (nonatomic) int ratPassAcc;
//PassEva (evasiveness) affects how easily he can dodge sacks
@property (nonatomic) int ratPassEva;

//Stats
@property (nonatomic) int statsPassAtt;
@property (nonatomic) int statsPassComp;
@property (nonatomic) int statsTD;
@property (nonatomic) int statsInt;
@property (nonatomic) int statsPassYards;
@property (nonatomic) int statsSacked;

+(instancetype)newQBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc eva:(int)eva;
+(instancetype)newQBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
-(NSMutableArray*)getStatsVector;
@end
