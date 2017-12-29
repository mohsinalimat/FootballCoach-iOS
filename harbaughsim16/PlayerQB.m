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
#import "Record.h"

@implementation PlayerQB
@synthesize ratPassAcc,ratPassEva,ratPassPow,ratSpeed,statsPassAtt,statsTD,statsInt,statsRushTD,statsSacked,statsFumbles,statsRushAtt,careerStatsPassAtt,careerStatsRushAtt,careerStatsTD,careerStatsInt,careerStatsRushTD,careerStatsSacked,careerStatsFumbles,careerStatsPassComp,careerStatsPassYards,careerStatsRushYards,statsPassComp,statsPassYards,statsRushYards;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.ratPassPow = [aDecoder decodeIntForKey:@"ratPassPow"];
        self.ratPassAcc = [aDecoder decodeIntForKey:@"ratPassAcc"];
        self.ratPassEva = [aDecoder decodeIntForKey:@"ratPassEva"];
        
        self.statsPassAtt = [aDecoder decodeIntForKey:@"statsPassAtt"];
        self.statsPassComp = [aDecoder decodeIntForKey:@"statsPassComp"];
        self.statsTD = [aDecoder decodeIntForKey:@"statsTD"];
        self.statsInt = [aDecoder decodeIntForKey:@"statsInt"];
        self.statsPassYards = [aDecoder decodeIntForKey:@"statsPassYards"];
        self.statsSacked = [aDecoder decodeIntForKey:@"statsSacked"];

        self.careerStatsPassAtt = [aDecoder decodeIntForKey:@"careerStatsPassAtt"];
        self.careerStatsPassComp = [aDecoder decodeIntForKey:@"careerStatsPassComp"];
        self.careerStatsTD = [aDecoder decodeIntForKey:@"careerStatsTD"];
        self.careerStatsInt = [aDecoder decodeIntForKey:@"careerStatsInt"];
        self.careerStatsPassYards = [aDecoder decodeIntForKey:@"careerStatsPassYards"];
        self.careerStatsSacked = [aDecoder decodeIntForKey:@"careerStatsSacked"];
        
    
        if ([aDecoder containsValueForKey:@"personalDetails"]) {
            self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
            if (self.personalDetails == nil) {
                    NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 190;
                    NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 2;
                    self.personalDetails = @{
                                                                                       @"home_state" : [HBSharedUtils randomState],
                                                                                                                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                                                                                                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                                                                                                                 };
                }
            } else {
                NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 190;
                NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 2;
                self.personalDetails = @{
                                                                               @"home_state" : [HBSharedUtils randomState],
                                                                                                                     @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                                                                                                     @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                                                                                                     };
            }
        
        if ([aDecoder containsValueForKey:@"ratSpeed"]) { // this means all of these new things exist
            self.ratSpeed = [aDecoder decodeIntForKey:@"ratSpeed"];
            self.statsRushAtt = [aDecoder decodeIntForKey:@"statsRushAtt"];
            self.statsRushTD = [aDecoder decodeIntForKey:@"statsRushTD"];
            self.statsFumbles = [aDecoder decodeIntForKey:@"statsFumbles"];
            self.statsRushYards = [aDecoder decodeIntForKey:@"statsRushYards"];
            
            self.careerStatsRushAtt = [aDecoder decodeIntForKey:@"careerStatsRushAtt"];
            self.careerStatsRushTD = [aDecoder decodeIntForKey:@"careerStatsRushTD"];
            self.careerStatsFumbles = [aDecoder decodeIntForKey:@"careerStatsFumbles"];
            self.careerStatsRushYards = [aDecoder decodeIntForKey:@"careerStatsRushYards"];
        }
        
        }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];

    [aCoder encodeInt:self.ratPassPow forKey:@"ratPassPow"];
    [aCoder encodeInt:self.ratPassAcc forKey:@"ratPassAcc"];
    [aCoder encodeInt:self.ratPassEva forKey:@"ratPassEva"];
    [aCoder encodeInt:self.ratSpeed forKey:@"ratSpeed"];

    [aCoder encodeInt:self.statsPassComp forKey:@"statsPassComp"];
    [aCoder encodeInt:self.statsSacked forKey:@"statsSacked"];
    [aCoder encodeInt:self.statsPassYards forKey:@"statsPassYards"];
    [aCoder encodeInt:self.statsInt forKey:@"statsInt"];
    [aCoder encodeInt:self.statsTD forKey:@"statsTD"];
    [aCoder encodeInt:self.statsPassAtt forKey:@"statsPassAtt"];

    [aCoder encodeInt:self.careerStatsPassComp forKey:@"careerStatsPassComp"];
    [aCoder encodeInt:self.careerStatsSacked forKey:@"careerStatsSacked"];
    [aCoder encodeInt:self.careerStatsPassYards forKey:@"careerStatsPassYards"];
    [aCoder encodeInt:self.careerStatsInt forKey:@"careerStatsInt"];
    [aCoder encodeInt:self.careerStatsTD forKey:@"careerStatsTD"];
    [aCoder encodeInt:self.careerStatsPassAtt forKey:@"careerStatsPassAtt"];
    
    [aCoder encodeInt:self.statsRushYards forKey:@"statsRushYards"];
    [aCoder encodeInt:self.statsFumbles forKey:@"statsFumbles"];
    [aCoder encodeInt:self.statsRushTD forKey:@"statsRushTD"];
    [aCoder encodeInt:self.statsRushAtt forKey:@"statsRushAtt"];
    
    [aCoder encodeInt:self.careerStatsRushYards forKey:@"careerStatsRushYards"];
    [aCoder encodeInt:self.careerStatsFumbles forKey:@"careerStatsFumbles"];
    [aCoder encodeInt:self.careerStatsRushTD forKey:@"careerStatsRushTD"];
    [aCoder encodeInt:self.careerStatsRushAtt forKey:@"careerStatsRushAtt"];
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc eva:(int)eva dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + (int)t.league.baseYear;
        self.ratOvr = (pow*3 + acc*4 + eva)/8;
        self.ratDur = dur;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        self.ratPassPow = pow;
        self.ratPassAcc = acc;
        self.ratPassEva = eva;

        self.cost = (int)(powf((float)self.ratOvr/3.5,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        self.ratSpeed = (int) (67 + (self.year*5 * [HBSharedUtils randomValue]));
        NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 190;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 2;
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };

        self.careerStatsPassAtt = 0;
        self.careerStatsPassComp = 0;
        self.careerStatsTD = 0;
        self.careerStatsInt = 0;
        self.careerStatsPassYards = 0;
        self.careerStatsSacked = 0;

        self.statsPassAtt = 0;
        self.statsPassComp = 0;
        self.statsTD = 0;
        self.statsInt = 0;
        self.statsPassYards = 0;
        self.statsSacked = 0;
        
        self.statsRushAtt = 0;
        self.statsRushYards = 0;
        self.statsRushTD = 0;
        self.statsFumbles = 0;
        
        self.careerStatsRushAtt = 0;
        self.careerStatsRushYards = 0;
        self.careerStatsRushTD = 0;
        self.careerStatsFumbles = 0;

        self.position = @"QB";
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
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratDur = (int) (50 + 50 * [HBSharedUtils randomValue]);
        self.ratPassPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratPassAcc = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratPassEva = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratPassPow*3 + self.ratPassAcc*4 + self.ratPassEva)/8;

        self.cost = (int)pow((float)self.ratOvr/3.5,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        self.ratSpeed = (int)(67 + (self.year*5 * [HBSharedUtils randomValue]));
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 190;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 2;
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };

        self.statsPassAtt = 0;
        self.statsPassComp = 0;
        self.statsTD = 0;
        self.statsInt = 0;
        self.statsPassYards = 0;
        self.statsSacked = 0;

        self.careerStatsPassAtt = 0;
        self.careerStatsPassComp = 0;
        self.careerStatsTD = 0;
        self.careerStatsInt = 0;
        self.careerStatsPassYards = 0;
        self.careerStatsSacked = 0;
        
        self.statsRushAtt = 0;
        self.statsRushYards = 0;
        self.statsRushTD = 0;
        self.statsFumbles = 0;
        
        self.careerStatsRushAtt = 0;
        self.careerStatsRushYards = 0;
        self.careerStatsRushTD = 0;
        self.careerStatsFumbles = 0;

        self.position = @"QB";
    }
    return self;
}

+(instancetype)newQBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc eva:(int)eva dur:(int)dur {
    return [[PlayerQB alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow accuracy:acc eva:eva dur:dur];
}

+(instancetype)newQBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerQB alloc] initWithName:nm year:yr stars:stars team:t];
}

-(void)advanceSeason {
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratPassPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratPassAcc += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratPassEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratSpeed += (int) ([HBSharedUtils randomValue] * (self.ratPot - 25)) / 10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratPassPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 20))/10;
            self.ratPassAcc += (int)([HBSharedUtils randomValue]*(self.ratPot - 20))/10;
            self.ratPassEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 20))/10;
            self.ratSpeed += (int) ([HBSharedUtils randomValue] * (self.ratPot - 20)) / 10;
            
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        self.ratPassPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        self.ratPassAcc += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        self.ratPassEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        self.ratSpeed += (int) ([HBSharedUtils randomValue] * (self.ratPot + self.gamesPlayedSeason - 40)) / 10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratPassPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
            self.ratPassAcc += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
            self.ratPassEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
            self.ratSpeed += (int) ([HBSharedUtils randomValue] * (self.ratPot + self.gamesPlayedSeason - 35)) / 10;
        }
    }

    self.ratOvr = (self.ratPassPow*3 + self.ratPassAcc*4 + self.ratPassEva)/8;
    self.ratImprovement = self.ratOvr - oldOvr;

    self.statsPassAtt = 0;
    self.statsPassComp = 0;
    self.statsTD = 0;
    self.statsInt = 0;
    self.statsPassYards = 0;
    self.statsSacked = 0;
    
    self.statsRushAtt = 0;
    self.statsRushYards = 0;
    self.statsRushTD = 0;
    self.statsFumbles = 0;
    
    [super advanceSeason];
}

-(int)getHeismanScore {
    return self.statsTD * 140 - self.statsInt * 250 + self.statsPassYards;
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];

    [stats setObject:[NSString stringWithFormat:@"%d",self.statsPassComp] forKey:@"completions"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.statsPassAtt] forKey:@"attempts"];
    [stats setObject:[NSString stringWithFormat:@"%d yds",self.statsPassYards] forKey:@"passYards"];

    int compPercent = 0;
    if (self.statsPassAtt > 0) {
        compPercent = (int)ceil(100.0*((double)self.statsPassComp/(double)self.statsPassAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",compPercent] forKey:@"completionPercentage"];

    int ypa = 0;
    if (self.statsPassAtt > 0) {
        ypa = (int)ceil((double)self.statsPassYards/(double)self.statsPassAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yards/att",ypa] forKey:@"yardsPerAttempt"];

    int ypg = 0;
    if (games > 0) {
        ypg = (int)ceil((double)self.statsPassYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yards/gm",ypg] forKey:@"yardsPerGame"];

    [stats setObject:[NSString stringWithFormat:@"%d TDs",self.statsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d INTs",self.statsInt] forKey:@"interceptions"];

    [stats setObject:[NSString stringWithFormat:@"%d TDs",self.statsRushTD] forKey:@"rushTouchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.statsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d carries",self.statsRushAtt] forKey:@"carries"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",self.statsRushYards] forKey:@"rushYards"];
    
    int ypc = 0;
    if (self.statsRushAtt > 0) {
        ypc = (int)ceil((double)self.statsRushYards/(double)self.statsRushAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/carry",ypc] forKey:@"yardsPerCarry"];
    
    int rypg = 0;
    if (games > 0) {
        rypg = (int)ceil((double)self.statsRushYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",rypg] forKey:@"rushYardsPerGame"];
    

    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedCareerStats]];

    [stats setObject:[NSString stringWithFormat:@"%d",self.careerStatsPassComp] forKey:@"completions"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerStatsPassAtt] forKey:@"attempts"];
    [stats setObject:[NSString stringWithFormat:@"%d yds",self.careerStatsPassYards] forKey:@"passYards"];

    int compPercent = 0;
    if (self.careerStatsPassAtt > 0) {
        compPercent = (int)ceil(100.0*((double)self.careerStatsPassComp/(double)self.careerStatsPassAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",compPercent] forKey:@"completionPercentage"];

    int ypa = 0;
    if (self.careerStatsPassAtt > 0) {
        ypa = (int)ceil((double)self.careerStatsPassYards/(double)self.careerStatsPassAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yards/att",ypa] forKey:@"yardsPerAttempt"];

    int ypg = 0;
    if (self.gamesPlayed > 0) {
        ypg = (int)ceil((double)self.careerStatsPassYards/(double)self.gamesPlayed);
    }
    
    [stats setObject:[NSString stringWithFormat:@"%d yards/gm",ypg] forKey:@"yardsPerGame"];

    [stats setObject:[NSString stringWithFormat:@"%d TDs",self.careerStatsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d INTs",self.careerStatsInt] forKey:@"interceptions"];
    
    [stats setObject:[NSString stringWithFormat:@"%d TDs",self.careerStatsRushTD] forKey:@"rushTouchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",self.careerStatsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d carries",self.careerStatsRushAtt] forKey:@"carries"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",self.careerStatsRushYards] forKey:@"rushYards"];
    
    int ypc = 0;
    if (self.careerStatsRushAtt > 0) {
        ypc = (int)ceil((double)self.careerStatsRushYards/(double)self.careerStatsRushAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/carry",ypc] forKey:@"yardsPerCarry"];
    
    int rypg = 0;
    if (self.gamesPlayed > 0) {
        rypg = (int)ceil((double)self.careerStatsRushYards/(double)self.gamesPlayed);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",rypg] forKey:@"rushYardsPerGame"];
    

    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:self.ratPassPow] forKey:@"passPower"];
    [stats setObject:[self getLetterGrade:self.ratPassAcc] forKey:@"passAccuracy"];
    [stats setObject:[self getLetterGrade:self.ratPassEva] forKey:@"passEvasion"];
    [stats setObject:[self getLetterGrade:self.ratSpeed] forKey:@"rushSpeed"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];

    return [stats copy];
}

-(void)checkRecords {
    //completions
    if (self.statsPassComp > self.team.singleSeasonCompletionsRecord.statistic) {
        self.team.singleSeasonCompletionsRecord = [Record newRecord:@"Completions" player:self stat:self.statsPassComp year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsPassComp > self.team.careerCompletionsRecord.statistic) {
        self.team.careerCompletionsRecord = [Record newRecord:@"Completions" player:self stat:self.careerStatsPassComp year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.statsPassComp > self.team.league.singleSeasonCompletionsRecord.statistic) {
        self.team.league.singleSeasonCompletionsRecord = [Record newRecord:@"Completions" player:self stat:self.statsPassComp year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsPassComp > self.team.league.careerCompletionsRecord.statistic) {
        self.team.league.careerCompletionsRecord = [Record newRecord:@"Completions" player:self stat:self.careerStatsPassComp year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    //TD
    if (self.statsTD > self.team.singleSeasonPassTDsRecord.statistic) {
        self.team.singleSeasonPassTDsRecord = [Record newRecord:@"Pass TDs" player:self stat:self.statsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsTD > self.team.careerPassTDsRecord.statistic) {
        self.team.careerPassTDsRecord = [Record newRecord:@"Pass TDs" player:self stat:self.careerStatsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.statsTD > self.team.league.singleSeasonPassTDsRecord.statistic) {
        self.team.league.singleSeasonPassTDsRecord = [Record newRecord:@"Pass TDs" player:self stat:self.statsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsTD > self.team.league.careerPassTDsRecord.statistic) {
        self.team.league.careerPassTDsRecord = [Record newRecord:@"Pass TDs" player:self stat:self.careerStatsTD year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    //Pass Yards
    if (self.statsPassYards > self.team.singleSeasonPassYardsRecord.statistic) {
        self.team.singleSeasonPassYardsRecord = [Record newRecord:@"Pass Yards" player:self stat:self.statsPassYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsPassYards > self.team.careerPassYardsRecord.statistic) {
        self.team.careerPassYardsRecord = [Record newRecord:@"Pass Yards" player:self stat:self.careerStatsPassYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.statsPassYards > self.team.league.singleSeasonPassYardsRecord.statistic) {
        self.team.league.singleSeasonPassYardsRecord = [Record newRecord:@"Pass Yards" player:self stat:self.statsPassYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsPassYards > self.team.league.careerPassYardsRecord.statistic) {
        self.team.league.careerPassYardsRecord = [Record newRecord:@"Pass Yards" player:self stat:self.careerStatsPassYards year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    //interceptions
    if (self.statsInt > self.team.singleSeasonInterceptionsRecord.statistic) {
        self.team.singleSeasonInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.statsInt year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsInt > self.team.careerInterceptionsRecord.statistic) {
        self.team.careerInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.careerStatsInt year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.statsInt > self.team.league.singleSeasonInterceptionsRecord.statistic) {
        self.team.league.singleSeasonInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.statsInt year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsInt > self.team.league.careerInterceptionsRecord.statistic) {
        self.team.league.careerInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.careerStatsInt year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
}

@end
