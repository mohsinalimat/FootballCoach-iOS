//
//  PlayerWR.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerWR : Player <NSCoding>
@property (nonatomic) int ratRecCat;
//RecSpd affects how long his passes are
@property (nonatomic) int ratRecSpd;
//RecEva affects how easily he can dodge tackles
@property (nonatomic) int ratRecEva;

//public Vector ratingsVector;

//Stats
@property (nonatomic) int statsTargets;
@property (nonatomic) int statsReceptions;
@property (nonatomic) int statsRecYards;
@property (nonatomic) int statsTD;
@property (nonatomic) int statsDrops;
@property (nonatomic) int statsFumbles;

//Career Stats
@property (nonatomic) int careerStatsTargets;
@property (nonatomic) int careerStatsReceptions;
@property (nonatomic) int careerStatsRecYards;
@property (nonatomic) int careerStatsTD;
@property (nonatomic) int careerStatsDrops;
@property (nonatomic) int careerStatsFumbles;

+(instancetype)newWRWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq catch:(int)cat speed:(int)spd eva:(int)eva;
+(instancetype)newWRWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
