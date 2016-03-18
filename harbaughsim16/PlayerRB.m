//
//  PlayerRB.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerRB.h"
#import "Team.h"

@implementation PlayerRB
-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow speed:(NSInteger)spd eva:(NSInteger)eva {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.ratOvr = (pow + spd + eva)/3;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratRushPow = pow;
        _ratRushSpd = spd;
        _ratRushEva = eva;
        
        self.cost = (NSInteger)(powf((float)self.ratOvr/4,2.0)) + (NSInteger)(arc4random()*100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratRushPow)];
        [self.ratingsVector addObject:@(self.ratRushSpd)];
        [self.ratingsVector addObject:@(self.ratRushEva)];
        
        
        
        _statsRushAtt = 0;
        _statsRushYards = 0;
        _statsTD = 0;
        _statsFumbles = 0;
        
        self.position = @"RB";
    }
    return self;
}

-(instancetype)initWithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t {
    self = [super init];
    if (self) {
        self.name = nm;
        self.year = yr;
        self.team = t;
        self.ratPot = (int) (50 + 50*arc4random());
        self.ratFootIQ = (int) (50 + stars*4 + 30*arc4random());
        _ratRushPow = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratRushSpd = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratRushEva = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        self.ratOvr = (_ratRushPow + _ratRushSpd + _ratRushEva)/3;
        
        self.cost = (int)pow((float)self.ratOvr/4,2) + (int)(arc4random()*100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratRushPow)];
        [self.ratingsVector addObject:@(self.ratRushSpd)];
        [self.ratingsVector addObject:@(self.ratRushEva)];
        
        _statsRushAtt = 0;
        _statsRushYards = 0;
        _statsTD = 0;
        _statsFumbles = 0;
        
        self.position = @"RB";
    }
    return self;
}

+(instancetype)newRBWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow speed:(NSInteger)spd eva:(NSInteger)eva {
    return [[PlayerRB alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow speed:spd eva:eva];
}

+(instancetype)newRBWithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t {
    return [[PlayerRB alloc] initWithName:nm year:yr stars:stars team:t];
}

-(NSMutableArray*)getStatsVector {
    NSMutableArray *v = [NSMutableArray array];
    [v addObject:@(_statsRushAtt)];
    [v addObject:@(_statsRushYards)];
    [v addObject:@(_statsTD)];
    [v addObject:@(_statsFumbles)];
    [v addObject:@((float)((int)((float)_statsRushYards/_statsRushAtt*100))/100)];
    return v;
}

-(NSMutableArray*)ratingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratRushPow)];
    [self.ratingsVector addObject:@(self.ratRushSpd)];
    [self.ratingsVector addObject:@(self.ratRushEva)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    self.year++;
    NSInteger oldOvr = self.ratOvr;
    self.ratFootIQ += (int)(arc4random()*(self.ratPot - 25))/10;
    self.ratRushPow += (int)(arc4random()*(self.ratPot - 25))/10;
    self.ratRushSpd += (int)(arc4random()*(self.ratPot - 25))/10;
    self.ratRushEva += (int)(arc4random()*(self.ratPot - 25))/10;
    if ( arc4random()*100 < self.ratPot ) {
        //breakthrough
        self.ratRushPow += (int)(arc4random()*(self.ratPot - 30))/10;
        self.ratRushSpd += (int)(arc4random()*(self.ratPot - 30))/10;
        self.ratRushEva += (int)(arc4random()*(self.ratPot - 30))/10;
    }
    self.ratOvr = (self.ratRushPow + self.ratRushSpd + self.ratRushEva)/3;
    self.ratImprovement = self.ratOvr - oldOvr;
    //reset stats (keep career stats?)
    self.statsRushAtt = 0;
    self.statsRushYards = 0;
    self.statsTD = 0;
    self.statsFumbles = 0;
}

-(NSInteger)getHeismanScore {
    return _statsTD * 100 - _statsFumbles * 100 + (int)(_statsRushYards * 2.25);
}

-(NSArray*)getDetailedStatsList:(NSInteger)games {
    NSMutableArray<NSString*> *pStats = [NSMutableArray array];
    [pStats addObject:[NSString stringWithFormat:@"TDs/Fum: %ld/%ld\nRush Att: %ld",(long)_statsTD,(long)_statsFumbles,(long)_statsRushAtt]];
    [pStats addObject:[NSString stringWithFormat:@"Rush Yards: %ld\nYards/Att: %f yds",(long)_statsRushYards,((double)(10*_statsRushYards/(_statsRushAtt+1))/10)]];
    [pStats addObject:[NSString stringWithFormat:@"Yds/Game: %ld yds/gm\nRush Power: %@", (_statsRushYards/games),[self getLetterGrade:_ratRushPow]]];
    [pStats addObject:[NSString stringWithFormat:@"Rush Speed: %@\nEvasion: %@",[self getLetterGrade:_ratRushSpd],[self getLetterGrade:_ratRushEva]]];
    return pStats;
}

@end
