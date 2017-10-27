//
//  PlayerTE.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 10/27/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "PlayerWR.h"

@interface PlayerTE : PlayerWR
@property (nonatomic) int ratTERunBlk;
+(instancetype)newTEWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq runBlk:(int)runBlk catch:(int)cat speed:(int)spd eva:(int)eva dur:(int)dur;
+(instancetype)newTEWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t;
@end
