//
//  PlayerWR.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerWR.h"

@implementation PlayerWR
-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq catch:(int)cat speed:(int)spd eva:(int)eva {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.ratOvr = (cat*2 + spd + eva)/4;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratRecCat = cat;
        _ratRecSpd = spd;
        _ratRecEva = eva;
        
        self.cost = (int)(powf((float)self.ratOvr/5,2.0)) + (int)(arc4random()%100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratRecCat)];
        [self.ratingsVector addObject:@(self.ratRecSpd)];
        [self.ratingsVector addObject:@(self.ratRecEva)];
        
        _statsReceptions = 0;
        _statsRecYards = 0;
        _statsTargets = 0;
        _statsDrops = 0;
        _statsFumbles = 0;
        _statsTD = 0;
        _statsFumbles = 0;
        
        self.position = @"WR";
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
        _ratRecCat = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratRecSpd = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratRecEva = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        self.ratOvr = (_ratRecCat*2 + _ratRecSpd + _ratRecEva)/4;
        
        self.cost = (int)pow((float)self.ratOvr/5,2) + (int)(arc4random()%100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratRecCat)];
        [self.ratingsVector addObject:@(self.ratRecSpd)];
        [self.ratingsVector addObject:@(self.ratRecEva)];
        
        _statsReceptions = 0;
        _statsRecYards = 0;
        _statsTargets = 0;
        _statsDrops = 0;
        _statsFumbles = 0;
        _statsTD = 0;
        _statsFumbles = 0;
        
        self.position = @"WR";
    }
    return self;
}

+(instancetype)newWRWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq catch:(int)cat speed:(int)spd eva:(int)eva {
    return [[PlayerWR alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq catch:cat speed:spd eva:eva];
}

+(instancetype)newWRWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerWR alloc] initWithName:nm year:yr stars:stars team:t];
}

-(NSMutableArray*)getStatsVector {
    NSMutableArray* v = [NSMutableArray array];
    [v addObject:@(self.statsReceptions)];
    [v addObject:@(self.statsTargets)];
    [v addObject:@(self.statsRecYards)];
    [v addObject:@(self.statsTD)];
    [v addObject:@(self.statsFumbles)];
    [v addObject:@(self.statsDrops)];
    [v addObject:@((float)((int)((float)self.statsRecYards/self.statsReceptions*100))/100)];
    
    return v;
}


-(NSMutableArray*)getRatingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratRecCat)];
    [self.ratingsVector addObject:@(self.ratRecSpd)];
    [self.ratingsVector addObject:@(self.ratRecEva)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    self.year++;
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratRecCat += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratRecSpd += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratRecEva += (int)(arc4random()%(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        _ratRecCat += (int)(arc4random()%(self.ratPot - 30))/10;
        _ratRecSpd += (int)(arc4random()%(self.ratPot - 30))/10;
        _ratRecEva += (int)(arc4random()%(self.ratPot - 30))/10;
    }
    self.ratOvr = (_ratRecCat*2 + _ratRecSpd + _ratRecEva)/4;
    self.ratImprovement = self.ratOvr - oldOvr;
    //reset stats (keep career stats?)
    _statsTargets = 0;
    _statsReceptions = 0;
    _statsRecYards = 0;
    _statsTD = 0;
    _statsDrops = 0;
    _statsFumbles = 0;
}

-(NSArray*)getDetailedStatsList:(int)games {
    NSMutableArray *pStats = [NSMutableArray array];
    [pStats addObject:[NSString stringWithFormat:@"TDs/Fumbles: %ld/%ld\nCatch Percent: %d%%\n",(long)self.ratPot,(long)self.statsFumbles,(100*_statsReceptions/(_statsTargets+1))]];
    [pStats addObject:[NSString stringWithFormat:@"Rec Yards: %ld yds\nYds/Tgt: %f yds\n",(long)self.statsRecYards,((double)(10*_statsRecYards/(_statsTargets+1))/10)]];
    if(games > 0) {
        [pStats addObject:[NSString stringWithFormat:@"Yards/Game: %d yds/gm\nCatching: %@\n",(_statsRecYards/games),[self getLetterGrade:_ratRecCat]]];
    }
    [pStats addObject:[NSString stringWithFormat:@"Rec Speed: %@\nEvasion: %@",[self getLetterGrade:_ratRecSpd],[self getLetterGrade:_ratRecEva]]];
    
    
    return [pStats copy];
}

-(int)getHeismanScore {
    return _statsTD * 150 - _statsFumbles * 100 - _statsDrops * 50 + _statsRecYards * 2;
}



@end
