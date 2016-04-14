//
//  PlayerRB.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerRB.h"
#import "Team.h"
#import "League.h"
#import "Record.h"

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
        
        
        _careerStatsRushAtt = [aDecoder decodeIntForKey:@"careerStatsRushAtt"];
        _careerStatsTD = [aDecoder decodeIntForKey:@"careerStatsTD"];
        _careerStatsFumbles = [aDecoder decodeIntForKey:@"careerStatsFumbles"];
        _careerStatsRushYards = [aDecoder decodeIntForKey:@"careerStatsRushYards"];
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
    
    [aCoder encodeInt:_careerStatsRushYards forKey:@"careerStatsRushYards"];
    [aCoder encodeInt:_careerStatsFumbles forKey:@"careerStatsFumbles"];
    [aCoder encodeInt:_careerStatsTD forKey:@"careerStatsTD"];
    [aCoder encodeInt:_careerStatsRushAtt forKey:@"careerStatsRushAtt"];
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
        
        _careerStatsRushAtt = 0;
        _careerStatsRushYards = 0;
        _careerStatsTD = 0;
        _careerStatsFumbles = 0;
        
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
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
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
        
        _careerStatsRushAtt = 0;
        _careerStatsRushYards = 0;
        _careerStatsTD = 0;
        _careerStatsFumbles = 0;
        
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
    
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayed - 35))/10;
    self.ratRushPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayed - 35))/10;
    self.ratRushSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayed - 35))/10;
    self.ratRushEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayed - 35))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        self.ratRushPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayed - 40))/10;
        self.ratRushSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayed - 40))/10;
        self.ratRushEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayed - 40))/10;
    }
    self.ratOvr = (self.ratRushPow + self.ratRushSpd + self.ratRushEva)/3;
    self.ratImprovement = self.ratOvr - oldOvr;
    
    //self.careerStatsRushAtt += self.statsRushAtt;
    //self.careerStatsRushYards += self.statsRushYards;
    //self.careerStatsTD += self.statsTD;
    //self.careerStatsFumbles += self.statsFumbles;
    
    self.statsRushAtt = 0;
    self.statsRushYards = 0;
    self.statsTD = 0;
    self.statsFumbles = 0;
    [super advanceSeason];
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

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d TDs",_careerStatsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",_careerStatsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d carries",_careerStatsRushAtt] forKey:@"carries"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",_careerStatsRushYards] forKey:@"rushYards"];
    
    int ypc = 0;
    if (_careerStatsRushAtt > 0) {
        ypc = (int)((double)_careerStatsRushYards/(double)_careerStatsRushAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/carry",ypc] forKey:@"yardsPerCarry"];
    
    int ypg = 0;
    if (self.gamesPlayed > 0) {
        ypg = (int)((double)_careerStatsRushYards/(double)self.gamesPlayed);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:_ratRushPow] forKey:@"rushPower"];
    [stats setObject:[self getLetterGrade:_ratRushSpd] forKey:@"rushSpeed"];
    [stats setObject:[self getLetterGrade:_ratRushEva] forKey:@"rushEvasion"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

-(void)checkRecords {
    //Carries
    if (self.statsRushAtt > self.team.singleSeasonCarriesRecord.statistic) {
        self.team.singleSeasonCarriesRecord = [Record newRecord:@"Carries" player:self stat:self.statsRushAtt year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsRushAtt > self.team.careerCarriesRecord.statistic) {
        self.team.careerCarriesRecord = [Record newRecord:@"Carries" player:self stat:self.careerStatsRushAtt year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.statsRushAtt > self.team.league.singleSeasonCarriesRecord.statistic) {
        self.team.league.singleSeasonCarriesRecord = [Record newRecord:@"Carries" player:self stat:self.statsRushAtt year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsRushAtt > self.team.league.careerCarriesRecord.statistic) {
        self.team.league.careerCarriesRecord = [Record newRecord:@"Carries" player:self stat:self.careerStatsRushAtt year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    //TD
    if (self.statsTD > self.team.singleSeasonRushTDsRecord.statistic) {
        self.team.singleSeasonRushTDsRecord = [Record newRecord:@"Rush TDs" player:self stat:self.statsTD year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsTD > self.team.careerRushTDsRecord.statistic) {
        self.team.careerRushTDsRecord = [Record newRecord:@"Rush TDs" player:self stat:self.careerStatsTD year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.statsTD > self.team.league.singleSeasonRushTDsRecord.statistic) {
        self.team.league.singleSeasonRushTDsRecord = [Record newRecord:@"Rush TDs" player:self stat:self.statsTD year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsTD > self.team.league.careerRushTDsRecord.statistic) {
        self.team.league.careerRushTDsRecord = [Record newRecord:@"Rush TDs" player:self stat:self.careerStatsTD year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    //Rush Yards
    if (self.statsRushYards > self.team.singleSeasonRushYardsRecord.statistic) {
        self.team.singleSeasonRushYardsRecord = [Record newRecord:@"Rush Yards" player:self stat:self.statsRushYards year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsRushYards > self.team.careerRushYardsRecord.statistic) {
        self.team.careerRushYardsRecord = [Record newRecord:@"Rush Yards" player:self stat:self.careerStatsRushYards year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.statsRushYards > self.team.league.singleSeasonRushYardsRecord.statistic) {
        self.team.league.singleSeasonRushYardsRecord = [Record newRecord:@"Rush Yards" player:self stat:self.statsRushYards year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsRushYards > self.team.league.careerRushYardsRecord.statistic) {
        self.team.league.careerRushYardsRecord = [Record newRecord:@"Rush Yards" player:self stat:self.careerStatsRushYards year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    //Fumbles
    if (self.statsFumbles > self.team.singleSeasonFumblesRecord.statistic) {
        self.team.singleSeasonFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.statsFumbles year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsFumbles > self.team.careerFumblesRecord.statistic) {
        self.team.careerFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.careerStatsFumbles year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.statsFumbles > self.team.league.singleSeasonFumblesRecord.statistic) {
        self.team.league.singleSeasonFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.statsFumbles year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsFumbles > self.team.league.careerFumblesRecord.statistic) {
        self.team.league.careerFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.careerStatsFumbles year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
}

@end
