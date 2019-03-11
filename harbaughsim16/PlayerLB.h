//
//  PlayerLB.h
//  profootballcoach
//
//  Created by Akshay Easwaran on 6/24/16.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "Player.h"
#import "PlayerDefender.h"

@interface PlayerLB : PlayerDefender <NSCoding>
@property (nonatomic) int ratLBTkl;
@property (nonatomic) int ratLBRsh;
@property (nonatomic) int ratLBPas;

//@property (nonatomic) int statsTkl;
//@property (nonatomic) int statsForcedFum;
//@property (nonatomic) int statsSacks;
//@property (nonatomic) int statsInt;
//@property (nonatomic) int statsPassDef;
//
//@property (nonatomic) int careerStatsTkl;
//@property (nonatomic) int careerStatsForcedFum;
//@property (nonatomic) int careerStatsInt;
//@property (nonatomic) int careerStatsSacks;
//@property (nonatomic) int careerStatsPassDef;

+(instancetype)newLBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq tkl:(int)tkl rush:(int)rsh pass:(int)pass dur:(int)dur;
+(instancetype)newLBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
