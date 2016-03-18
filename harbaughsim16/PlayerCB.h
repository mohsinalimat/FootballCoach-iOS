//
//  PlayerCB.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerCB : Player
@property (nonatomic) NSInteger ratCBCov;
@property (nonatomic) NSInteger ratCBSpd;
@property (nonatomic) NSInteger ratCBTkl;
+(instancetype)newCBWithName:(NSString*)name team:(Team*)team year:(NSInteger)year potential:(NSInteger)potential iq:(NSInteger)iq coverage:(NSInteger)coverage speed:(NSInteger)speed tackling:(NSInteger)tackling;
+(instancetype)newCBWithName:(NSString*)name year:(NSInteger)year stars:(NSInteger)stars;
-(NSMutableArray*)getRatingsVector;
-(void)advanceSeason;
-(NSArray*)getDetailedStatsList:(NSInteger)games;
@end
