//
//  PlayerCB.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"
#import "PlayerDefender.h"

@interface PlayerCB : PlayerDefender <NSCoding>
@property (nonatomic) int ratCBCov;
@property (nonatomic) int ratCBSpd;
@property (nonatomic) int ratCBTkl;

//@property (nonatomic) int statsTkl;
//@property (nonatomic) int statsForcedFum;
//@property (nonatomic) int statsPassDef;
//@property (nonatomic) int statsInt;
//@property (nonatomic) int statsSacks;
//
//@property (nonatomic) int careerStatsTkl;
//@property (nonatomic) int careerStatsForcedFum;
//@property (nonatomic) int careerStatsPassDef;
//@property (nonatomic) int careerStatsInt;
//@property (nonatomic) int careerStatsSacks;

+(instancetype)newCBWithName:(NSString*)name team:(Team*)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling dur:(int)dur;
+(instancetype)newCBWithName:(NSString*)name year:(int)year stars:(int)stars team:(Team*)t;
@end
