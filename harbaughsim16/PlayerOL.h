//
//  PlayerOL.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerOL : Player
@property (nonatomic) NSInteger ratOLPow;
//OLBkR affects how well he blocks for running plays
@property (nonatomic) NSInteger ratOLBkR;
//OLBkP affects how well he blocks for passing plays
@property (nonatomic) NSInteger ratOLBkP;
+(instancetype)newOLWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow rush:(NSInteger)rsh pass:(NSInteger)pass;
+(instancetype)newOLWithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t;
@end
