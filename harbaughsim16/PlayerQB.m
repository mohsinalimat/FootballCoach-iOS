//
//  PlayerQB.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerQB.h"
#import "Player.h"
#import "Team.h"

@implementation PlayerQB
-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow accuracy:(NSInteger)acc eva:(NSInteger)eva {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.ratOvr = (pow*3 + acc*4 + eva)/8;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratPassPow = pow;
        _ratPassAcc = acc;
        _ratPassEva = eva;
        
        self.cost = (NSInteger)(powf((float)self.ratOvr/3.5,2.0)) + (NSInteger)(arc4random()*100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratPassPow)];
        [self.ratingsVector addObject:@(self.ratPassAcc)];
        [self.ratingsVector addObject:@(self.ratPassEva)];
        
        
        
        _statsPassAtt = 0;
        _statsPassComp = 0;
        _statsTD = 0;
        _statsInt = 0;
        _statsPassYards = 0;
        _statsSacked = 0;
        
        self.position = @"QB";
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
        _ratPassPow = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratPassAcc = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratPassEva = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        self.ratOvr = (_ratPassPow*3 + _ratPassAcc*4 + _ratPassEva)/8;
        
        self.cost = (int)pow((float)self.ratOvr/3.5,2) + (int)(arc4random()*100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratPassPow)];
        [self.ratingsVector addObject:@(self.ratPassAcc)];
        [self.ratingsVector addObject:@(self.ratPassEva)];
        
        _statsPassAtt = 0;
        _statsPassComp = 0;
        _statsTD = 0;
        _statsInt = 0;
        _statsPassYards = 0;
        _statsSacked = 0;
        
        self.position = @"QB";
    }
    return self;
}

+(instancetype)newQBWithName:(NSString *)nm team:(Team *)t year:(NSInteger)yr potential:(NSInteger)pot footballIQ:(NSInteger)iq power:(NSInteger)pow accuracy:(NSInteger)acc eva:(NSInteger)eva {
    return [[PlayerQB alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow accuracy:acc eva:eva];
}

+(instancetype)newQBWithName:(NSString*)nm year:(NSInteger)yr stars:(NSInteger)stars team:(Team*)t {
    return [[PlayerQB alloc] initWithName:nm year:yr stars:stars team:t];
}

-(NSMutableArray*)getStatsVector {
    NSMutableArray* v = [NSMutableArray array];
    [v addObject:@(self.statsPassComp)];
    [v addObject:@(self.statsPassAtt)];
    [v addObject:@((float)((int)((float)self.statsPassComp/self.statsPassAtt*1000))/10)];
    [v addObject:@(self.statsTD)];
    [v addObject:@(self.statsInt)];
    [v addObject:@(self.statsPassYards)];
    [v addObject:@(self.statsPassYards)];
    [v addObject:@((float)((int)((float)self.statsPassYards/self.statsPassAtt*100))/100)];
    [v addObject:@(self.statsSacked)];
    return v;
}

-(NSMutableArray*)getRatingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratPassPow)];
    [self.ratingsVector addObject:@(self.ratPassAcc)];
    [self.ratingsVector addObject:@(self.ratPassEva)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    self.year++;
    NSInteger oldOvr = self.ratOvr;
    self.ratFootIQ += (int)(arc4random()*(self.ratPot - 25))/10;
    _ratPassPow += (int)(arc4random()*(self.ratPot - 25))/10;
    _ratPassAcc += (int)(arc4random()*(self.ratPot - 25))/10;
    _ratPassEva += (int)(arc4random()*(self.ratPot - 25))/10;
    if ( arc4random()*100 < self.ratPot ) {
        //breakthrough
        _ratPassPow += (int)(arc4random()*(self.ratPot - 30))/10;
        _ratPassAcc += (int)(arc4random()*(self.ratPot - 30))/10;
        _ratPassEva += (int)(arc4random()*(self.ratPot - 30))/10;
    }
    
    self.ratOvr = (_ratPassPow*3 + _ratPassAcc*4 + _ratPassEva)/8;
    self.ratImprovement = self.ratOvr - oldOvr;
    //reset stats (keep career stats?)
    self.statsPassAtt = 0;
    self.statsPassComp = 0;
    self.statsTD = 0;
    self.statsInt = 0;
    self.statsPassYards = 0;
    self.statsSacked = 0;
}

-(NSInteger)getHeismanScore {
    return self.statsTD * 150 - self.statsInt * 250 + self.statsPassYards;
}

-(NSArray*)getDetailStatsList:(NSInteger)games {
    NSMutableArray *pStats = [NSMutableArray array];
    [pStats addObject:[NSString stringWithFormat:@"TD/Int: %ld/%ld\nComp Percent: %ld%%",(long)_statsTD,(long)_statsInt, (100*_statsPassComp/(_statsPassAtt+1))]];
    [pStats addObject:[NSString stringWithFormat:@"Pass Yards: %ldyds\nYards/Att: %fyds", (long)_statsPassYards ,((double)(10*_statsPassYards/(_statsPassAtt+1))/10)]];
    [pStats addObject:[NSString stringWithFormat:@"Yds/Game: %ldyds/gm\nPass Strength: %@",(_statsPassYards/games),[self getLetterGrade:_ratPassPow]]];
    [pStats addObject:[NSString stringWithFormat:@"Accuracy: %@\nEvasion: %@",[self getLetterGrade:_ratPassAcc],[self getLetterGrade:_ratPassEva]]];
    return [pStats copy];
}

@end
