//
//  PlayerK.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerK : Player
@property (nonatomic) NSInteger ratKickPow;
@property (nonatomic) NSInteger ratKickAcc;
@property (nonatomic) NSInteger ratKickFum;
@property (nonatomic) NSInteger statsXPAtt;
@property (nonatomic) NSInteger statsXPMade;
@property (nonatomic) NSInteger statsFGAtt;
@property (nonatomic) NSInteger statsFGMade;
-(NSMutableArray*)getStatsVector;

+(instancetype)newKWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow accuracy:(NSInteger)acc fum:(NSInteger)fum;
+(instancetype)newKWithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t;
@end
