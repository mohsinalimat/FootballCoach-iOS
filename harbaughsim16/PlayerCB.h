//
//  PlayerCB.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerCB : Player
@property (nonatomic) int ratCBCov;
@property (nonatomic) int ratCBSpd;
@property (nonatomic) int ratCBTkl;
+(instancetype)newCBWithName:(NSString*)name team:(Team*)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling;
+(instancetype)newCBWithName:(NSString*)name year:(int)year stars:(int)stars;
-(void)advanceSeason;
-(NSArray*)getDetailedStatsList:(int)games;
@end
