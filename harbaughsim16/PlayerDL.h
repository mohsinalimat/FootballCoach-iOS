//
//  PlayerDL.h
//  profootballcoach
//
//  Created by Akshay Easwaran on 6/24/16.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "Player.h"
#import "PlayerF7.h"
#import "PlayerDefender.h"

@interface PlayerDL : PlayerDefender <NSCoding>

@property (nonatomic) int ratDLPow;
@property (nonatomic) int ratDLRsh;
@property (nonatomic) int ratDLPas;

//@property (nonatomic) int statsTkl;
//@property (nonatomic) int statsForcedFum;
//@property (nonatomic) int statsInt;
//@property (nonatomic) int statsSacks;
//@property (nonatomic) int statsPassDef;
//
//@property (nonatomic) int careerStatsTkl;
//@property (nonatomic) int careerStatsForcedFum;
//@property (nonatomic) int careerStatsInt;
//@property (nonatomic) int careerStatsSacks;
//@property (nonatomic) int careerStatsPassDef;

+(instancetype)newDLWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass dur:(int)dur;
+(instancetype)newDLWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
+(instancetype)newDLWithF7:(PlayerF7*)f7;
@end
