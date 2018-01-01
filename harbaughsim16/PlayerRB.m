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
@synthesize ratRushEva,ratRushPow,ratRushSpd,statsRushYards,statsRushAtt,statsFumbles,statsTD,careerStatsRushYards,careerStatsFumbles,careerStatsTD,careerStatsRushAtt;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
            self.ratRushPow = [aDecoder decodeIntForKey:@"ratRushPow"];
            self.ratRushSpd = [aDecoder decodeIntForKey:@"ratRushSpd"];
            self.ratRushEva = [aDecoder decodeIntForKey:@"ratRushEva"];
    
            self.statsRushAtt = [aDecoder decodeIntForKey:@"statsRushAtt"];
            self.statsTD = [aDecoder decodeIntForKey:@"statsTD"];
            self.statsFumbles = [aDecoder decodeIntForKey:@"statsFumbles"];
            self.statsRushYards = [aDecoder decodeIntForKey:@"statsRushYards"];
    
    
            self.careerStatsRushAtt = [aDecoder decodeIntForKey:@"careerStatsRushAtt"];
            self.careerStatsTD = [aDecoder decodeIntForKey:@"careerStatsTD"];
            self.careerStatsFumbles = [aDecoder decodeIntForKey:@"careerStatsFumbles"];
            self.careerStatsRushYards = [aDecoder decodeIntForKey:@"careerStatsRushYards"];
    
            if ([aDecoder containsValueForKey:@"personalDetails"]) {
                    self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
                    if (self.personalDetails == nil) {
                            NSInteger weight = (int)([HBSharedUtils randomValue] * 35) + 205;
                            NSInteger inches = (int)([HBSharedUtils randomValue] * 4);
                            self.personalDetails = @{
                                                                                               @"home_state" : [HBSharedUtils randomState],
                                                                                                                                         @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                                                                                                                         @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                                                                                                                         };
                        }
                } else {
                        NSInteger weight = (int)([HBSharedUtils randomValue] * 35) + 205;
                        NSInteger inches = (int)([HBSharedUtils randomValue] * 4);
                        self.personalDetails = @{
                                                                                       @"home_state" : [HBSharedUtils randomState],
                                                                                                                             @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                                                                                                             @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                                                                                                             };
                    }
        }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    [aCoder encodeInt:self.ratRushPow forKey:@"ratRushPow"];
    [aCoder encodeInt:self.ratRushSpd forKey:@"ratRushSpd"];
    [aCoder encodeInt:self.ratRushEva forKey:@"ratRushEva"];

    [aCoder encodeInt:self.statsRushYards forKey:@"statsRushYards"];
    [aCoder encodeInt:self.statsFumbles forKey:@"statsFumbles"];
    [aCoder encodeInt:self.statsTD forKey:@"statsTD"];
    [aCoder encodeInt:self.statsRushAtt forKey:@"statsRushAtt"];

    [aCoder encodeInt:self.careerStatsRushYards forKey:@"careerStatsRushYards"];
    [aCoder encodeInt:self.careerStatsFumbles forKey:@"careerStatsFumbles"];
    [aCoder encodeInt:self.careerStatsTD forKey:@"careerStatsTD"];
    [aCoder encodeInt:self.careerStatsRushAtt forKey:@"careerStatsRushAtt"];

    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow speed:(int)spd eva:(int)eva dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + (int)t.league.baseYear;
        self.ratOvr = (pow + spd + eva)/3;
        self.ratPot = pot;
        self.ratDur = dur;
        self.ratFootIQ = iq;
        self.ratRushPow = pow;
        self.ratRushSpd = spd;
        self.ratRushEva = eva;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 35) + 205;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 4);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        
        self.cost = (int)(powf((float)self.ratOvr/4,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        self.statsRushAtt = 0;
        self.statsRushYards = 0;
        self.statsTD = 0;
        self.statsFumbles = 0;
        
        self.careerStatsRushAtt = 0;
        self.careerStatsRushYards = 0;
        self.careerStatsTD = 0;
        self.careerStatsFumbles = 0;
        
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
        self.stars = stars;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + (int)t.league.baseYear;
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratRushPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratRushSpd = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratRushEva = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratRushPow + self.ratRushSpd + self.ratRushEva)/3;
        
        self.cost = (int)pow((float)self.ratOvr/4,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        if (t == nil) {
            self.recruitStatus = CFCRecruitStatusUncommitted;
        } else {
            self.recruitStatus = CFCRecruitStatusCommitted;
        }
        
        CGFloat inMin = 0.0;
        CGFloat inMax = 100.0;
        
        CGFloat outMin = 4.75;
        CGFloat outMax = 4.30;
        
        CGFloat input = (CGFloat) self.ratRushSpd;
        CGFloat fortyTime = (outMin + (outMax - outMin) * (input - inMin) / (inMax - inMin));
        self.fortyYardDashTime = [NSString stringWithFormat:@"%.2fs", fortyTime];
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 35) + 205;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 4);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        
        self.statsRushAtt = 0;
        self.statsRushYards = 0;
        self.statsTD = 0;
        self.statsFumbles = 0;
        
        self.careerStatsRushAtt = 0;
        self.careerStatsRushYards = 0;
        self.careerStatsTD = 0;
        self.careerStatsFumbles = 0;
        
        self.position = @"RB";
    }
    return self;
}

+(instancetype)newRBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow speed:(int)spd eva:(int)eva dur:(int)dur{
    return [[PlayerRB alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow speed:spd eva:eva dur:dur];
}

+(instancetype)newRBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerRB alloc] initWithName:nm year:yr stars:stars team:t];
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
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
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRushPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRushSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratRushEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratRushPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratRushSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratRushEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }

    self.ratOvr = (self.ratRushPow + self.ratRushSpd + self.ratRushEva)/3;
    self.ratImprovement = self.ratOvr - oldOvr;
    
    self.statsRushAtt = 0;
    self.statsRushYards = 0;
    self.statsTD = 0;
    self.statsFumbles = 0;
    [super advanceSeason];
}

-(int)getHeismanScore {
    return (self.statsTD * 100) - (self.statsFumbles * 80) + ((int)(self.statsRushYards * 2.35));
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d TDs",self.statsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.statsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d carries",self.statsRushAtt] forKey:@"carries"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",self.statsRushYards] forKey:@"rushYards"];
    
    int ypc = 0;
    if (self.statsRushAtt > 0) {
        ypc = (int)ceil((double)self.statsRushYards/(double)self.statsRushAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/carry",ypc] forKey:@"yardsPerCarry"];
    
    int ypg = 0;
    if (games > 0) {
        ypg = (int)ceil((double)self.statsRushYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedCareerStats]];
    [stats setObject:[NSString stringWithFormat:@"%d TDs",self.careerStatsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.careerStatsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d carries",self.careerStatsRushAtt] forKey:@"carries"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",self.careerStatsRushYards] forKey:@"rushYards"];
    
    int ypc = 0;
    if (self.careerStatsRushAtt > 0) {
        ypc = (int)ceil((double)self.careerStatsRushYards/(double)self.careerStatsRushAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/carry",ypc] forKey:@"yardsPerCarry"];
    
    int ypg = 0;
    if (self.gamesPlayed > 0) {
        ypg = (int)ceil((double)self.careerStatsRushYards/(double)self.gamesPlayed);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",ypg] forKey:@"yardsPerGame"];
    
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:self.ratRushPow] forKey:@"rushPower"];
    [stats setObject:[self getLetterGrade:self.ratRushSpd] forKey:@"rushSpeed"];
    [stats setObject:[self getLetterGrade:self.ratRushEva] forKey:@"rushEvasion"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

-(void)checkRecords {
    //Carries
    if (self.statsRushAtt > self.team.singleSeasonCarriesRecord.statistic) {
        self.team.singleSeasonCarriesRecord = [Record newRecord:@"Carries" player:self stat:self.statsRushAtt year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsRushAtt > self.team.careerCarriesRecord.statistic) {
        self.team.careerCarriesRecord = [Record newRecord:@"Carries" player:self stat:self.careerStatsRushAtt year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsRushAtt > self.team.league.singleSeasonCarriesRecord.statistic) {
        self.team.league.singleSeasonCarriesRecord = [Record newRecord:@"Carries" player:self stat:self.statsRushAtt year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsRushAtt > self.team.league.careerCarriesRecord.statistic) {
        self.team.league.careerCarriesRecord = [Record newRecord:@"Carries" player:self stat:self.careerStatsRushAtt year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //TD
    if (self.statsTD > self.team.singleSeasonRushTDsRecord.statistic) {
        self.team.singleSeasonRushTDsRecord = [Record newRecord:@"Rush TDs" player:self stat:self.statsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsTD > self.team.careerRushTDsRecord.statistic) {
        self.team.careerRushTDsRecord = [Record newRecord:@"Rush TDs" player:self stat:self.careerStatsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsTD > self.team.league.singleSeasonRushTDsRecord.statistic) {
        self.team.league.singleSeasonRushTDsRecord = [Record newRecord:@"Rush TDs" player:self stat:self.statsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsTD > self.team.league.careerRushTDsRecord.statistic) {
        self.team.league.careerRushTDsRecord = [Record newRecord:@"Rush TDs" player:self stat:self.careerStatsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //Rush Yards
    if (self.statsRushYards > self.team.singleSeasonRushYardsRecord.statistic) {
        self.team.singleSeasonRushYardsRecord = [Record newRecord:@"Rush Yards" player:self stat:self.statsRushYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsRushYards > self.team.careerRushYardsRecord.statistic) {
        self.team.careerRushYardsRecord = [Record newRecord:@"Rush Yards" player:self stat:self.careerStatsRushYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsRushYards > self.team.league.singleSeasonRushYardsRecord.statistic) {
        self.team.league.singleSeasonRushYardsRecord = [Record newRecord:@"Rush Yards" player:self stat:self.statsRushYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsRushYards > self.team.league.careerRushYardsRecord.statistic) {
        self.team.league.careerRushYardsRecord = [Record newRecord:@"Rush Yards" player:self stat:self.careerStatsRushYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //Fumbles
    if (self.statsFumbles > self.team.singleSeasonFumblesRecord.statistic) {
        self.team.singleSeasonFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.statsFumbles year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsFumbles > self.team.careerFumblesRecord.statistic) {
        self.team.careerFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.careerStatsFumbles year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsFumbles > self.team.league.singleSeasonFumblesRecord.statistic) {
        self.team.league.singleSeasonFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.statsFumbles year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsFumbles > self.team.league.careerFumblesRecord.statistic) {
        self.team.league.careerFumblesRecord = [Record newRecord:@"Fumbles" player:self stat:self.careerStatsFumbles year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
}

@end
