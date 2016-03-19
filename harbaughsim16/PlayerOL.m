//
//  PlayerOL.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerOL.h"

@implementation PlayerOL
-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.ratOvr = (pow*3 + rsh + pass)/5;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratOLPow = pow;
        _ratOLBkR = rsh;
        _ratOLBkP = pass;
        
        self.cost = (int)(powf((float)self.ratOvr/6,2.0)) + (int)(arc4random()%100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratOLPow)];
        [self.ratingsVector addObject:@(self.ratOLBkR)];
        [self.ratingsVector addObject:@(self.ratOLBkP)];
        
        
        
        self.position = @"OL";
    }
    return self;
}

-(instancetype)initWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    self = [super init];
    if (self) {
        self.name = nm;
        self.year = yr;
        self.team = t;
        self.ratPot = (int) (50 + 50*arc4random());
        self.ratFootIQ = (int) (50 + stars*4 + 30*arc4random());
        _ratOLPow = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratOLBkR = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratOLBkP = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        self.ratOvr = (_ratOLPow*3 + _ratOLBkR + _ratOLBkP)/5;
        
        self.cost = (int)pow((float)self.ratOvr/6,2) + (int)(arc4random()%100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratOLPow)];
        [self.ratingsVector addObject:@(self.ratOLBkR)];
        [self.ratingsVector addObject:@(self.ratOLBkP)];
        
        
        self.position = @"OL";
    }
    return self;
}

+(instancetype)newOLWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass {
    return [[PlayerOL alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow rush:rsh pass:pass];
}

+(instancetype)newOLWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerOL alloc] initWithName:nm year:yr stars:stars team:t];
}

-(NSMutableArray*)getRatingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratOLPow)];
    [self.ratingsVector addObject:@(self.ratOLBkR)];
    [self.ratingsVector addObject:@(self.ratOLBkP)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    self.year++;
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratOLPow += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratOLBkR += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratOLBkP += (int)(arc4random()%(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        _ratOLPow += (int)(arc4random()%(self.ratPot - 30))/10;
        _ratOLBkR += (int)(arc4random()%(self.ratPot - 30))/10;
        _ratOLBkP += (int)(arc4random()%(self.ratPot - 30))/10;
    }
    
    self.ratOvr = (_ratOLPow*3 + _ratOLBkR + _ratOLBkP)/5;
    self.ratImprovement = self.ratOvr - oldOvr;
}

-(NSArray*)getDetailStatsList:(int)games {
    NSMutableArray *pStats = [NSMutableArray array];
    [pStats addObject:[NSString stringWithFormat:@"Potential: %ldyds/gm\nStrength: %@",self.ratPot,[self getLetterGrade:_ratOLPow]]];
    [pStats addObject:[NSString stringWithFormat:@"Run Block: %@\nPass Block: %@",[self getLetterGrade:_ratOLBkR],[self getLetterGrade:_ratOLBkP]]];
    return [pStats copy];
}
@end
