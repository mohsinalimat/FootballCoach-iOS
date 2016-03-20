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
        
        self.cost = (int)(powf((float)self.ratOvr/5,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
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
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + stars*4 + 30* [HBSharedUtils randomValue]);
        _ratRecCat = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratRecSpd = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratRecEva = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (_ratRecCat*2 + _ratRecSpd + _ratRecEva)/4;
        
        self.cost = (int)pow((float)self.ratOvr/5,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
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
    self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        _ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        _ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        _ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
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

-(int)getHeismanScore {
    return _statsTD * 150 - _statsFumbles * 100 - _statsDrops * 50 + _statsRecYards * 2;
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d TDs",_statsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",_statsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d catches",_statsReceptions] forKey:@"catches"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",_statsRecYards] forKey:@"recYards"];
    
    int ypc = 0;
    if (_statsReceptions > 0) {
        _statsReceptions = (int)((double)_statsRecYards/(double)_statsReceptions);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/catch",ypc] forKey:@"yardsPerCatch"];
    
    int ypg = 0;
    if (games > 0) {
        ypg = (int)((double)_statsRecYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[self getLetterGrade:_ratRecCat] forKey:@"recCatch"];
    [stats setObject:[self getLetterGrade:_ratRecSpd] forKey:@"recSpeed"];
    [stats setObject:[self getLetterGrade:_ratRecEva] forKey:@"recEvasion"];
    
    return [stats copy];
}

@end
