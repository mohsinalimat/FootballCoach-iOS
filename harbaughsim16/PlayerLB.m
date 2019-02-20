//
//  PlayerLB.m
//  profootballcoach
//
//  Created by Akshay Easwaran on 6/24/16.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "PlayerLB.h"
#import "Record.h"

@implementation PlayerLB
@synthesize ratLBPas,ratLBRsh,ratLBTkl;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.ratLBTkl = [aDecoder decodeIntForKey:@"ratLBTkl"];
        self.ratLBRsh = [aDecoder decodeIntForKey:@"ratLBRsh"];
        self.ratLBPas = [aDecoder decodeIntForKey:@"ratLBPas"];
        
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
    [aCoder encodeInt:self.ratLBTkl forKey:@"ratLBTkl"];
    [aCoder encodeInt:self.ratLBRsh forKey:@"ratLBRsh"];
    [aCoder encodeInt:self.ratLBPas forKey:@"ratLBPas"];
    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}

-(instancetype)initWithName:(NSString*)name team:(Team*)team year:(int)year potential:(int)potential iq:(int)iq tkl:(int)tkl pass:(int)pass rush:(int)rush dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = team;
        self.name = name;
        self.year = year;
        self.startYear = (int)team.league.leagueHistoryDictionary.count + (int)team.league.baseYear;
        self.ratDur = dur;
        self.ratOvr = (self.ratLBTkl*3 + self.ratLBRsh + self.ratLBPas)/5;
        self.ratPot = potential;
        self.ratFootIQ = iq;
        self.ratLBRsh = rush;
        self.ratLBPas = pass;
        self.ratLBTkl = tkl;
        self.position = @"LB";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 200;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
    }
    return self;
}

+(instancetype)newLBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq tkl:(int)tkl rush:(int)rsh pass:(int)pass dur:(int)dur {
    return [[PlayerLB alloc] initWithName:nm team:t year:yr potential:pot iq:iq tkl:tkl pass:pass rush:rsh dur:dur];
}

+(instancetype)newLBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerLB alloc] initWithName:nm year:yr stars:stars team:t];
}

-(instancetype)initWithName:(NSString*)name year:(int)year stars:(int)stars team:(Team*)t {
    self = [super init];
    if(self) {
        self.team = t;
        self.name = name;
        self.year = year;
        self.stars = stars;
        self.startYear = (t != nil) ? (int)[t.league getCurrentYear] : (int)[[HBSharedUtils currentLeague] getCurrentYear];
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int)([HBSharedUtils randomValue]*50 + 50);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratLBTkl = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratLBRsh = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratLBPas = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratLBTkl*3 + self.ratLBRsh + self.ratLBPas)/5;
        self.position = @"LB";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        if (t == nil) {
            self.recruitStatus = CFCRecruitStatusUncommitted;
        } else {
            self.recruitStatus = CFCRecruitStatusCommitted;
        }
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 200;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        self.fortyYardDashTime = [NSString stringWithFormat:@"%.2fs", [HBSharedUtils randomFloatBetween:4.47 and:5.1]];
    }
    return self;
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratLBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratLBRsh += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratLBPas += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            ratLBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            ratLBRsh += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            ratLBPas += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratLBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratLBRsh += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratLBPas += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            ratLBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            ratLBRsh += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            ratLBPas += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    
    self.ratOvr = (ratLBTkl*3 + ratLBRsh + ratLBPas)/5;
    self.ratImprovement = self.ratOvr - oldOvr;
    [super advanceSeason];
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d Tkls",self.statsTkl] forKey:@"tackles"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.statsForcedFum] forKey:@"forcedFumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d passes def",self.statsPassDef] forKey:@"passesDefended"];
    [stats setObject:[NSString stringWithFormat:@"%d sacks",self.statsSacks] forKey:@"sacks"];
    [stats setObject:[NSString stringWithFormat:@"%d INT",self.statsInt] forKey:@"interceptions"];
    
    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d Tkls",self.careerStatsTkl] forKey:@"tackles"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.careerStatsForcedFum] forKey:@"forcedFumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d passes def",self.careerStatsPassDef] forKey:@"passesDefended"];
    [stats setObject:[NSString stringWithFormat:@"%d sacks",self.careerStatsSacks] forKey:@"sacks"];
    [stats setObject:[NSString stringWithFormat:@"%d INT",self.careerStatsInt] forKey:@"interceptions"];
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:ratLBTkl] forKey:@"lbTkl"];
    [stats setObject:[self getLetterGrade:ratLBRsh] forKey:@"lbRun"];
    [stats setObject:[self getLetterGrade:ratLBPas] forKey:@"lbPass"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

-(int)getHeismanScore {
    return _statsTkl * 25 + _statsSacks * 425 + _statsForcedFum * 425 + _statsInt * 425;
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
