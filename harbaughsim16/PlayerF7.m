//
//  PlayerF7.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerF7.h"

@implementation PlayerF7

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.ratOvr = (pow*3 + rsh + pass)/5;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratF7Pow = pow;
        _ratF7Rsh = rsh;
        _ratF7Pas = pass;
        
        self.cost = (int)(powf((float)self.ratOvr/6,2.0)) + (int)(arc4random()%100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratF7Pow)];
        [self.ratingsVector addObject:@(self.ratF7Rsh)];
        [self.ratingsVector addObject:@(self.ratF7Pas)];
        

        
        self.position = @"F7";
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
        _ratF7Pow = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratF7Rsh = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratF7Pas = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        self.ratOvr = (_ratF7Pow*3 + _ratF7Rsh + _ratF7Pas)/5;
        
        self.cost = (int)pow((float)self.ratOvr/6,2) + (int)(arc4random()%100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratF7Pow)];
        [self.ratingsVector addObject:@(self.ratF7Rsh)];
        [self.ratingsVector addObject:@(self.ratF7Pas)];
        
        
        self.position = @"F7";
    }
    return self;
}

+(instancetype)newF7WithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass {
    return [[PlayerF7 alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow rush:rsh pass:pass];
}

+(instancetype)newF7WithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerF7 alloc] initWithName:nm year:yr stars:stars team:t];
}

-(NSMutableArray*)getRatingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratF7Pow)];
    [self.ratingsVector addObject:@(self.ratF7Rsh)];
    [self.ratingsVector addObject:@(self.ratF7Pas)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    self.year++;
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratF7Pow += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratF7Rsh += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratF7Pas += (int)(arc4random()%(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        _ratF7Pow += (int)(arc4random()%(self.ratPot - 30))/10;
        _ratF7Rsh += (int)(arc4random()%(self.ratPot - 30))/10;
        _ratF7Pas += (int)(arc4random()%(self.ratPot - 30))/10;
    }
    
    self.ratOvr = (_ratF7Pow*3 + _ratF7Rsh + _ratF7Pas)/5;
    self.ratImprovement = self.ratOvr - oldOvr;
}

-(NSArray*)getDetailStatsList:(int)games {
    NSMutableArray *pStats = [NSMutableArray array];
    [pStats addObject:[NSString stringWithFormat:@"Potential: %dyds/gm\nStrength: %@",self.ratPot,[self getLetterGrade:_ratF7Pow]]];
    [pStats addObject:[NSString stringWithFormat:@"Run Stop: %@\nPass Pressure: %@",[self getLetterGrade:_ratF7Rsh],[self getLetterGrade:_ratF7Pas]]];
    return [pStats copy];
}
@end
