//
//  PlayerOL.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerOL : Player <NSCoding>
@property (nonatomic) int ratOLPow;
//OLBkR affects how well he blocks for running plays
@property (nonatomic) int ratOLBkR;
//OLBkP affects how well he blocks for passing plays
@property (nonatomic) int ratOLBkP;
+(instancetype)newOLWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass dur:(int)dur;
+(instancetype)newOLWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
