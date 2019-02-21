//
//  PlayerDL.m
//  profootballcoach
//
//  Created by Akshay Easwaran on 6/24/16.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "PlayerDL.h"
#import "Record.h"

@implementation PlayerDL
@synthesize ratDLPas,ratDLPow,ratDLRsh;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.ratDLPow = [aDecoder decodeIntForKey:@"ratDLPow"];
        self.ratDLRsh = [aDecoder decodeIntForKey:@"ratDLRsh"];
        self.ratDLPas = [aDecoder decodeIntForKey:@"ratDLPas"];
        
        if ([aDecoder containsValueForKey:@"personalDetails"]) {
            self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
            if (self.personalDetails == nil) {
                NSInteger weight = (int)([HBSharedUtils randomValue] * 125) + 225;
                NSInteger inches = (int)([HBSharedUtils randomValue] * 3) + 2;
                self.personalDetails = @{@"home_state" : [HBSharedUtils randomState],
                                         @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                         @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                         };
            }
        } else {
            NSInteger weight = (int)([HBSharedUtils randomValue] * 125) + 225;
            NSInteger inches = (int)([HBSharedUtils randomValue] * 3) + 2;
            self.personalDetails = @{@"home_state" : [HBSharedUtils randomState],
                                     @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                     @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                     };
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInt:self.ratDLPow forKey:@"ratDLPow"];
    [aCoder encodeInt:self.ratDLRsh forKey:@"ratDLRsh"];
    [aCoder encodeInt:self.ratDLPas forKey:@"ratDLPas"];
    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}

+(instancetype)newDLWithF7:(PlayerF7 *)f7 {
    return [[PlayerDL alloc] initWithF7:f7];
}

-(instancetype)initWithF7:(PlayerF7*)f7 {
    self = [super init];
    if (self) {
        self.team = f7.team;
        self.name = f7.name;
        self.year = f7.year;
        self.startYear = f7.startYear;
        self.ratDur = f7.ratDur;
        self.ratOvr = f7.ratOvr;
        self.ratPot = f7.ratPot;
        self.ratFootIQ = f7.ratFootIQ;
        ratDLPow = f7.ratF7Pow;
        ratDLRsh = f7.ratF7Rsh;
        ratDLPas = f7.ratF7Pas;
        
        self.cost = (int)(powf((float)self.ratOvr/6,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        self.personalDetails = f7.personalDetails;
        
        if (self.cost < 50) {
            self.cost = 50;
        }
        
        self.position = @"DL";
    }
    return self;
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.startYear = (int)t.league.leagueHistoryDictionary.count  + (int)t.league.baseYear;
        self.ratDur = dur;
        self.ratOvr = (pow*3 + rsh + pass)/5;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        ratDLPow = pow;
        ratDLRsh = rsh;
        ratDLPas = pass;
        
        self.cost = (int)(powf((float)self.ratOvr/6,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 125) + 225;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 3) + 2;
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        
        
        if (self.cost < 50) {
            self.cost = 50;
        }
        
        self.position = @"DL";
    }
    return self;
}

-(instancetype)initWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    self = [super init];
    if (self) {
        self.name = nm;
        self.year = yr;
        self.team = t;
        self.stars = stars;
        self.startYear = (int)t.league.leagueHistoryDictionary.count  + (int)t.league.baseYear;
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        ratDLPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        ratDLRsh = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        ratDLPas = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (ratDLPow*3 + ratDLRsh + ratDLPas)/5;
        
        self.cost = (int)pow((float)self.ratOvr/6,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        if (t == nil) {
            self.recruitStatus = CFCRecruitStatusUncommitted;
        } else {
            self.recruitStatus = CFCRecruitStatusCommitted;
        }
        
        CGFloat inMin = 0.0;
        CGFloat inMax = 100.0;
        
        CGFloat outMin = 5.4;
        CGFloat outMax = 4.6;
        
        CGFloat input = (CGFloat) self.ratDLPow;
        CGFloat fortyTime = (outMin + (outMax - outMin) * (input - inMin) / (inMax - inMin));
        self.fortyYardDashTime = [NSString stringWithFormat:@"%.2fs", fortyTime];
        
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 125) + 225;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 3) + 2;
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        
        
        if (self.cost < 50) {
            self.cost = 50;
        }
        
        self.position = @"DL";
    }
    return self;
}

+(instancetype)newDLWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass dur:(int)dur {
    return [[PlayerDL alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow rush:rsh pass:pass dur:dur];
}

+(instancetype)newDLWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerDL alloc] initWithName:nm year:yr stars:stars team:t];
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratDLPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratDLRsh += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratDLPas += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            ratDLPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            ratDLRsh += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            ratDLPas += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratDLPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratDLRsh += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratDLPas += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            ratDLPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            ratDLRsh += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            ratDLPas += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    
    self.ratOvr = (ratDLPow*3 + ratDLRsh + ratDLPas)/5;
    self.ratImprovement = self.ratOvr - oldOvr;
    [super advanceSeason];
}

-(int)getHeismanScore {
    return _statsTkl * 25 + _statsSacks * 425 + _statsForcedFum * 425 + _statsInt * 425;
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d Tkls",self.statsTkl] forKey:@"tackles"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.statsForcedFum] forKey:@"forcedFumbles"];
    [stats setObject:[NSString stringWithFormat:@"%d sacks",self.statsSacks] forKey:@"sacks"];
    [stats setObject:[NSString stringWithFormat:@"%d INT",self.statsInt] forKey:@"interceptions"];
    [stats setObject:[NSString stringWithFormat:@"%d passes def",self.statsPassDef] forKey:@"passesDefended"];
    
    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedCareerStats]];
    [stats setObject:[NSString stringWithFormat:@"%d Tkls",self.careerStatsTkl] forKey:@"tackles"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.careerStatsForcedFum] forKey:@"forcedFumbles"];
    [stats setObject:[NSString stringWithFormat:@"%d sacks",self.careerStatsSacks] forKey:@"sacks"];
    [stats setObject:[NSString stringWithFormat:@"%d INT",self.careerStatsInt] forKey:@"interceptions"];
    [stats setObject:[NSString stringWithFormat:@"%d passes def",self.careerStatsPassDef] forKey:@"passesDefended"];
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:ratDLPow] forKey:@"dlPow"];
    [stats setObject:[self getLetterGrade:ratDLRsh] forKey:@"dlRun"];
    [stats setObject:[self getLetterGrade:ratDLPas] forKey:@"dlPass"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

-(void)checkRecords {
    // sacks
    if (self.statsSacks > self.team.singleSeasonSacksRecord.statistic) {
        self.team.singleSeasonSacksRecord = [Record newRecord:@"Sacks" player:self stat:self.statsSacks year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsSacks > self.team.careerSacksRecord.statistic) {
        self.team.careerSacksRecord = [Record newRecord:@"Sacks" player:self stat:self.careerStatsSacks year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsSacks > self.team.league.singleSeasonSacksRecord.statistic) {
        self.team.league.singleSeasonSacksRecord = [Record newRecord:@"Sacks" player:self stat:self.statsSacks year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsSacks > self.team.league.careerSacksRecord.statistic) {
        self.team.league.careerSacksRecord = [Record newRecord:@"Sacks" player:self stat:self.careerStatsSacks year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    // tackles
    if (self.statsTkl > self.team.singleSeasonTacklesRecord.statistic) {
        self.team.singleSeasonTacklesRecord = [Record newRecord:@"Tackles" player:self stat:self.statsTkl year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsTkl > self.team.careerTacklesRecord.statistic) {
        self.team.careerTacklesRecord = [Record newRecord:@"Tackles" player:self stat:self.careerStatsTkl year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsTkl > self.team.league.singleSeasonTacklesRecord.statistic) {
        self.team.league.singleSeasonTacklesRecord = [Record newRecord:@"Tackles" player:self stat:self.statsTkl year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsTkl > self.team.league.careerTacklesRecord.statistic) {
        self.team.league.careerTacklesRecord = [Record newRecord:@"Tackles" player:self stat:self.careerStatsTkl year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //forced fum
    if (self.statsForcedFum > self.team.singleSeasonForcedFumRecord.statistic) {
        self.team.singleSeasonForcedFumRecord = [Record newRecord:@"Forced Fumbles" player:self stat:self.statsForcedFum year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsForcedFum > self.team.careerForcedFumRecord.statistic) {
        self.team.careerForcedFumRecord = [Record newRecord:@"Forced Fumbles" player:self stat:self.careerStatsForcedFum year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsForcedFum > self.team.league.singleSeasonForcedFumRecord.statistic) {
        self.team.league.singleSeasonForcedFumRecord = [Record newRecord:@"Forced Fumbles" player:self stat:self.statsForcedFum year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsForcedFum > self.team.league.careerForcedFumRecord.statistic) {
        self.team.league.careerForcedFumRecord = [Record newRecord:@"Forced Fumbles" player:self stat:self.careerStatsForcedFum year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    // passes def
    if (self.statsPassDef > self.team.singleSeasonPassDefRecord.statistic) {
        self.team.singleSeasonPassDefRecord = [Record newRecord:@"Passes Defended" player:self stat:self.statsPassDef year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsPassDef > self.team.careerPassDefRecord.statistic) {
        self.team.careerPassDefRecord = [Record newRecord:@"Passes Defended" player:self stat:self.careerStatsPassDef year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsPassDef > self.team.league.singleSeasonPassDefRecord.statistic) {
        self.team.league.singleSeasonPassDefRecord = [Record newRecord:@"Passes Defended" player:self stat:self.statsPassDef year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsPassDef > self.team.league.careerPassDefRecord.statistic) {
        self.team.league.careerPassDefRecord = [Record newRecord:@"Passes Defended" player:self stat:self.careerStatsPassDef year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //interceptions
    if (self.statsInt > self.team.singleSeasonDefInterceptionsRecord.statistic) {
        self.team.singleSeasonDefInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.statsInt year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsInt > self.team.careerDefInterceptionsRecord.statistic) {
        self.team.careerDefInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.careerStatsInt year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsInt > self.team.league.singleSeasonDefInterceptionsRecord.statistic) {
        self.team.league.singleSeasonDefInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.statsInt year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsInt > self.team.league.careerDefInterceptionsRecord.statistic) {
        self.team.league.careerDefInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.careerStatsInt year:(int)([HBSharedUtils currentLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
}

@end
