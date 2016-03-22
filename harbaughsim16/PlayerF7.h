//
//  PlayerF7.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerF7 : Player <NSCoding>
@property (nonatomic) int ratF7Pow;
@property (nonatomic) int ratF7Rsh;
@property (nonatomic) int ratF7Pas;

+(instancetype)newF7WithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass;
+(instancetype)newF7WithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
