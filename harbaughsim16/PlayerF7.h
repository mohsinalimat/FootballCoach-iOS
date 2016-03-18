//
//  PlayerF7.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerF7 : Player
@property (nonatomic) NSInteger ratF7Pow;
@property (nonatomic) NSInteger ratF7Rsh;
@property (nonatomic) NSInteger ratF7Pas;

+(instancetype)newF7WithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow rush:(NSInteger)rsh pass:(NSInteger)pass;
+(instancetype)newF7WithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t;
@end
