//
//  PlayerS.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerS : Player <NSCoding>
@property (nonatomic) int ratSCov;
//CBSpd affects how good he is at not letting up deep passes
@property (nonatomic) int ratSSpd;
//CBTkl affects how good he is at tackling
@property (nonatomic) int ratSTkl;

@property (nonatomic) int statsTkl;
@property (nonatomic) int statsForcedFum;
@property (nonatomic) int statsPassDef;
@property (nonatomic) int statsInt;
@property (nonatomic) int statsSacks;

@property (nonatomic) int careerStatsTkl;
@property (nonatomic) int careerStatsForcedFum;
@property (nonatomic) int careerStatsPassDef;
@property (nonatomic) int careerStatsInt;
@property (nonatomic) int careerStatsSacks;

+(instancetype)newSWithName:(NSString*)name team:(Team*)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling dur:(int)dur;
+(instancetype)newSWithName:(NSString*)name year:(int)year stars:(int)stars team:(Team*)t;
@end
