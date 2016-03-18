//
//  PlayerWR.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerWR : Player
@property (nonatomic) NSInteger ratRecCat;
//RecSpd affects how long his passes are
@property (nonatomic) NSInteger ratRecSpd;
//RecEva affects how easily he can dodge tackles
@property (nonatomic) NSInteger ratRecEva;

//public Vector ratingsVector;

//Stats
@property (nonatomic) NSInteger statsTargets;
@property (nonatomic) NSInteger statsReceptions;
@property (nonatomic) NSInteger statsRecYards;
@property (nonatomic) NSInteger statsTD;
@property (nonatomic) NSInteger statsDrops;
@property (nonatomic) NSInteger statsFumbles;
+(instancetype)newWRWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq catch:(NSInteger)cat speed:(NSInteger)spd eva:(NSInteger)eva;
+(instancetype)newWRWithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t;
@end
