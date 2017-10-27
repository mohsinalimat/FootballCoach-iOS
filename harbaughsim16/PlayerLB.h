//
//  PlayerLB.h
//  profootballcoach
//
//  Created by Akshay Easwaran on 6/24/16.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@interface PlayerLB : Player <NSCopying>
@property (nonatomic) int ratLBTkl;
@property (nonatomic) int ratLBRsh;
@property (nonatomic) int ratLBPas;

+(instancetype)newLBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq tkl:(int)tkl rush:(int)rsh pass:(int)pass dur:(int)dur;
+(instancetype)newLBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
