//
//  PlayerWR.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerWR.h"
#import "Team.h"
#import "Record.h"
#import "League.h"

@implementation PlayerWR

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ratRecCat = [aDecoder decodeIntForKey:@"ratRecCat"];
        _ratRecSpd = [aDecoder decodeIntForKey:@"ratRecSpd"];
        _ratRecEva = [aDecoder decodeIntForKey:@"ratRecEva"];
        _statsTargets = [aDecoder decodeIntForKey:@"statsTargets"];
        _statsReceptions = [aDecoder decodeIntForKey:@"statsReceptions"];
        _statsDrops = [aDecoder decodeIntForKey:@"statsDrops"];
        _statsTD = [aDecoder decodeIntForKey:@"statsTD"];
        _statsFumbles = [aDecoder decodeIntForKey:@"statsFumbles"];
        _statsRecYards = [aDecoder decodeIntForKey:@"statsRecYards"];
        
        
        if ([aDecoder containsValueForKey:@"careerStatsRecYards"]) {
            _careerStatsRecYards = [aDecoder decodeIntForKey:@"careerStatsRecYards"];
        } else {
            _careerStatsRecYards = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerStatsReceptions"]) {
            _careerStatsReceptions = [aDecoder decodeIntForKey:@"careerStatsReceptions"];
        } else {
            _careerStatsReceptions = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerStatsTD"]) {
            _careerStatsTD = [aDecoder decodeIntForKey:@"careerStatsTD"];
        } else {
            _careerStatsTD = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerStatsTargets"]) {
            _careerStatsTargets = [aDecoder decodeIntForKey:@"careerStatsTargets"];
        } else {
            _careerStatsTargets = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerStatsFumbles"]) {
            _careerStatsFumbles = [aDecoder decodeIntForKey:@"careerStatsFumbles"];
        } else {
            _careerStatsFumbles = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerStatsDrops"]) {
            _careerStatsDrops = [aDecoder decodeIntForKey:@"careerStatsDrops"];
        } else {
            _careerStatsDrops = 0;
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:_ratRecCat forKey:@"ratRecCat"];
    [aCoder encodeInt:_ratRecSpd forKey:@"ratRecSpd"];
    [aCoder encodeInt:_ratRecEva forKey:@"ratRecEva"];
    
    [aCoder encodeInt:_statsRecYards forKey:@"statsRecYards"];
    [aCoder encodeInt:_statsFumbles forKey:@"statsFumbles"];
    [aCoder encodeInt:_statsTD forKey:@"statsTD"];
    [aCoder encodeInt:_statsReceptions forKey:@"statsReceptions"];
    [aCoder encodeInt:_statsDrops forKey:@"statsDrops"];
    [aCoder encodeInt:_statsTargets forKey:@"statsTargets"];
    
    [aCoder encodeInt:_careerStatsRecYards forKey:@"careerStatsRecYards"];
    [aCoder encodeInt:_careerStatsReceptions forKey:@"careerStatsReceptions"];
    [aCoder encodeInt:_careerStatsTD forKey:@"careerStatsTD"];
    [aCoder encodeInt:_careerStatsTargets forKey:@"careerStatsTargets"];
    [aCoder encodeInt:_careerStatsFumbles forKey:@"careerStatsFumbles"];
    [aCoder encodeInt:_careerStatsDrops forKey:@"careerStatsDrops"];
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq catch:(int)cat speed:(int)spd eva:(int)eva dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.ratDur = dur;
        self.year = yr;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + 2016;
        self.ratOvr = (cat*2 + spd + eva)/4;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratRecCat = cat;
        _ratRecSpd = spd;
        _ratRecEva = eva;
        
        self.cost = (int)(powf((float)self.ratOvr/5,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        _statsReceptions = 0;
        _statsRecYards = 0;
        _statsTargets = 0;
        _statsDrops = 0;
        _statsFumbles = 0;
        _statsTD = 0;
        _statsFumbles = 0;
        
        _careerStatsReceptions = 0;
        _careerStatsRecYards = 0;
        _careerStatsTargets = 0;
        _careerStatsDrops = 0;
        _careerStatsFumbles = 0;
        _careerStatsTD = 0;
        _careerStatsFumbles = 0;
        
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
        self.startYear = (int)t.league.leagueHistoryDictionary.count + 2016;
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        _ratRecCat = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratRecSpd = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratRecEva = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (_ratRecCat*2 + _ratRecSpd + _ratRecEva)/4;
        
        self.cost = (int)pow((float)self.ratOvr/5,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        _careerStatsReceptions = 0;
        _careerStatsRecYards = 0;
        _careerStatsTargets = 0;
        _careerStatsDrops = 0;
        _careerStatsFumbles = 0;
        _careerStatsTD = 0;
        _careerStatsFumbles = 0;
        
        _statsTargets = 0;
        _statsReceptions = 0;
        _statsRecYards = 0;
        _statsTD = 0;
        _statsDrops = 0;
        _statsFumbles = 0;
        
        self.position = @"WR";
    }
    return self;
}

+(instancetype)newWRWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq catch:(int)cat speed:(int)spd eva:(int)eva dur:(int)dur {
    return [[PlayerWR alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq catch:cat speed:spd eva:eva dur:dur];
}

+(instancetype)newWRWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerWR alloc] initWithName:nm year:yr stars:stars team:t];
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
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
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        _ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        _ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        _ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            _ratRecCat += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            _ratRecSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            _ratRecEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    self.ratOvr = (_ratRecCat*2 + _ratRecSpd + _ratRecEva)/4;
    self.ratImprovement = self.ratOvr - oldOvr;
    
    _statsTargets = 0;
    _statsReceptions = 0;
    _statsRecYards = 0;
    _statsTD = 0;
    _statsDrops = 0;
    _statsFumbles = 0;
    [super advanceSeason];
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
        ypc = (int)((double)_statsRecYards/(double)_statsReceptions);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/catch",ypc] forKey:@"yardsPerCatch"];
    
    int ypg = 0;
    if (games > 0) {
        ypg = (int)((double)_statsRecYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedCareerStats]];
    [stats setObject:[NSString stringWithFormat:@"%d TDs",_careerStatsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",_careerStatsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d catches",_careerStatsReceptions] forKey:@"catches"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",_careerStatsRecYards] forKey:@"recYards"];
    
    int ypc = 0;
    if (_careerStatsReceptions > 0) {
        ypc = (int)((double)_careerStatsRecYards/(double)_careerStatsReceptions);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/catch",ypc] forKey:@"yardsPerCatch"];
    
    int ypg = 0;
    if (self.gamesPlayed > 0) {
        ypg = (int)((double)_careerStatsRecYards/(double)self.gamesPlayed);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:_ratRecCat] forKey:@"recCatch"];
    [stats setObject:[self getLetterGrade:_ratRecSpd] forKey:@"recSpeed"];
    [stats setObject:[self getLetterGrade:_ratRecEva] forKey:@"recEvasion"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

-(void)checkRecords {
    //Catches
    if (self.statsReceptions > self.team.singleSeasonCatchesRecord.statistic) {
        self.team.singleSeasonCatchesRecord = [Record newRecord:@"Catches" player:self stat:self.statsReceptions year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsReceptions > self.team.careerCatchesRecord.statistic) {
        self.team.careerCatchesRecord = [Record newRecord:@"Catches" player:self stat:self.careerStatsReceptions year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsReceptions > self.team.league.singleSeasonCatchesRecord.statistic) {
        self.team.league.singleSeasonCatchesRecord = [Record newRecord:@"Catches" player:self stat:self.statsReceptions year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsReceptions > self.team.league.careerCatchesRecord.statistic) {
        self.team.league.careerCatchesRecord = [Record newRecord:@"Catches" player:self stat:self.careerStatsReceptions year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //TD
    if (self.statsTD > self.team.singleSeasonRecTDsRecord.statistic) {
        self.team.singleSeasonRecTDsRecord = [Record newRecord:@"Rec TDs" player:self stat:self.statsTD year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsTD > self.team.careerRecTDsRecord.statistic) {
        self.team.careerRecTDsRecord = [Record newRecord:@"Rec TDs" player:self stat:self.careerStatsTD year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsTD > self.team.league.singleSeasonRecTDsRecord.statistic) {
        self.team.league.singleSeasonRecTDsRecord = [Record newRecord:@"Rec TDs" player:self stat:self.statsTD year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsTD > self.team.league.careerRecTDsRecord.statistic) {
        self.team.league.careerRecTDsRecord = [Record newRecord:@"Rec TDs" player:self stat:self.careerStatsTD year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //Rec Yards
    if (self.statsRecYards > self.team.singleSeasonRecYardsRecord.statistic) {
        self.team.singleSeasonRecYardsRecord = [Record newRecord:@"Rec Yards" player:self stat:self.statsRecYards year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsRecYards > self.team.careerRecYardsRecord.statistic) {
        self.team.careerRecYardsRecord = [Record newRecord:@"Rec Yards" player:self stat:self.careerStatsRecYards year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsRecYards > self.team.league.singleSeasonRecYardsRecord.statistic) {
        self.team.league.singleSeasonRecYardsRecord = [Record newRecord:@"Rec Yards" player:self stat:self.statsRecYards year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsRecYards > self.team.league.careerRecYardsRecord.statistic) {
        self.team.league.careerRecYardsRecord = [Record newRecord:@"Rec Yards" player:self stat:self.careerStatsRecYards year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //Fumbles
    if (self.statsFumbles > self.team.singleSeasonFumblesRecord.statistic) {
        self.team.singleSeasonFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.statsFumbles year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsFumbles > self.team.careerFumblesRecord.statistic) {
        self.team.careerFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.careerStatsFumbles year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsFumbles > self.team.league.singleSeasonFumblesRecord.statistic) {
        self.team.league.singleSeasonFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.statsFumbles year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsFumbles > self.team.league.careerFumblesRecord.statistic) {
        self.team.league.careerFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.careerStatsFumbles year:(int)(2016 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
}

@end
