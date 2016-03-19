//
//  PlayerK.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerK : Player
@property (nonatomic) int ratKickPow;
@property (nonatomic) int ratKickAcc;
@property (nonatomic) int ratKickFum;
@property (nonatomic) int statsXPAtt;
@property (nonatomic) int statsXPMade;
@property (nonatomic) int statsFGAtt;
@property (nonatomic) int statsFGMade;
-(NSMutableArray*)getStatsVector;

+(instancetype)newKWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc fum:(int)fum;
+(instancetype)newKWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
