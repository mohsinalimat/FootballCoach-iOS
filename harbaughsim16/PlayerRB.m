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


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ratRushPow = [aDecoder decodeIntForKey:@"ratRushPow"];
        _ratRushSpd = [aDecoder decodeIntForKey:@"ratRushSpd"];
        _ratRushEva = [aDecoder decodeIntForKey:@"ratRushEva"];
        _statsRushAtt = [aDecoder decodeIntForKey:@"statsRushAtt"];
        _statsTD = [aDecoder decodeIntForKey:@"statsTD"];
        _statsFumbles = [aDecoder decodeIntForKey:@"statsFumbles"];
        _statsRushYards = [aDecoder decodeIntForKey:@"statsRushYards"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:_ratRushPow forKey:@"ratRushPow"];
    [aCoder encodeInt:_ratRushSpd forKey:@"ratRushSpd"];
    [aCoder encodeInt:_ratRushEva forKey:@"ratRushEva"];
    [aCoder encodeInt:_statsRushYards forKey:@"statsRushYards"];
    [aCoder encodeInt:_statsFumbles forKey:@"statsFumbles"];
    [aCoder encodeInt:_statsTD forKey:@"statsTD"];
    [aCoder encodeInt:_statsRushAtt forKey:@"statsRushAtt"];
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow speed:(int)spd eva:(int)eva {
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
        
        self.cost = (int)(powf((float)self.ratOvr/4,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
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
        
        //_careerStatsRushAtt = 0;
        //_careerStatsRushYards = 0;
        //_careerStatsTD = 0;
        //_careerStatsFumbles = 0;
        
        self.position = @"RB";
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
        _ratRushPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratRushSpd = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratRushEva = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (_ratRushPow + _ratRushSpd + _ratRushEva)/3;
        
        self.cost = (int)pow((float)self.ratOvr/4,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
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
        
        //_careerStatsRushAtt = 0;
        //_careerStatsRushYards = 0;
        //_careerStatsTD = 0;
        //_careerStatsFumbles = 0;
        
        
        self.position = @"RB";
    }
    return self;
}

+(instancetype)newRBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow speed:(int)spd eva:(int)eva {
    return [[PlayerRB alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow speed:spd eva:eva];
}

+(instancetype)newRBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
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

-(NSMutableArray*)getRatingsVector {
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
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratRushPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratRushSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratRushEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        self.ratRushPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        self.ratRushSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        self.ratRushEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
    }
    self.ratOvr = (self.ratRushPow + self.ratRushSpd + self.ratRushEva)/3;
    self.ratImprovement = self.ratOvr - oldOvr;
    //reset stats (keep career stats?)
    
    //self.careerStatsRushAtt += self.statsRushAtt;
    //self.careerStatsTD += self.statsTD;
    //self.careerStatsRushYards += self.statsRushYards;
    //self.careerStatsFumbles += self.statsFumbles;
    
    
    self.statsRushAtt = 0;
    self.statsRushYards = 0;
    self.statsTD = 0;
    self.statsFumbles = 0;
}

-(int)getHeismanScore {
    return _statsTD * 100 - _statsFumbles * 80 + (int)(_statsRushYards * 2.35);
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d TDs",_statsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",_statsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d carries",_statsRushAtt] forKey:@"carries"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",_statsRushYards] forKey:@"rushYards"];
    
    int ypc = 0;
    if (_statsRushAtt > 0) {
        ypc = (int)((double)_statsRushYards/(double)_statsRushAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/carry",ypc] forKey:@"yardsPerCarry"];
    
    int ypg = 0;
    if (games > 0) {
        ypg = (int)((double)_statsRushYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[self getLetterGrade:_ratRushPow] forKey:@"rushPower"];
    [stats setObject:[self getLetterGrade:_ratRushSpd] forKey:@"rushSpeed"];
    [stats setObject:[self getLetterGrade:_ratRushEva] forKey:@"rushEvasion"];
    
    return [stats copy];
}

@end
