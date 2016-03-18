//
//  PlayerS.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerS : Player
@property (nonatomic) NSInteger ratSCov;
//CBSpd affects how good he is at not letting up deep passes
@property (nonatomic) NSInteger ratSSpd;
//CBTkl affects how good he is at tackling
@property (nonatomic) NSInteger ratSTkl;
+(instancetype)newSWithName:(NSString*)name team:(Team*)team year:(NSInteger)year potential:(NSInteger)potential iq:(NSInteger)iq coverage:(NSInteger)coverage speed:(NSInteger)speed tackling:(NSInteger)tackling;
+(instancetype)newSWithName:(NSString*)name year:(NSInteger)year stars:(NSInteger)stars;
@end
