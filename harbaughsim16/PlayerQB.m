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


-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc eva:(int)eva dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + 2017;
        self.ratOvr = (pow*3 + acc*4 + eva)/8;
        self.ratDur = dur;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratPassPow = pow;
        _ratPassAcc = acc;
        _ratPassEva = eva;

        self.cost = (int)(powf((float)self.ratOvr/3.5,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        self.ratSpeed = (int) (47 + self.year*5 + [HBSharedUtils randomValue]*5 - 25 * [HBSharedUtils randomValue]);
        NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 190;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 2;
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };

        _careerStatsPassAtt = 0;
        _careerStatsPassComp = 0;
        _careerStatsTD = 0;
        _careerStatsInt = 0;
        _careerStatsPassYards = 0;
        _careerStatsSacked = 0;

        _statsPassAtt = 0;
        _statsPassComp = 0;
        _statsTD = 0;
        _statsInt = 0;
        _statsPassYards = 0;
        _statsSacked = 0;
        
        _statsRushAtt = 0;
        _statsRushYards = 0;
        _statsRushTD = 0;
        _statsFumbles = 0;
        
        _careerStatsRushAtt = 0;
        _careerStatsRushYards = 0;
        _careerStatsRushTD = 0;
        _careerStatsFumbles = 0;

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
        self.startYear = (int)t.league.leagueHistoryDictionary.count + 2017;
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratDur = (int) (50 + 50 * [HBSharedUtils randomValue]);
        _ratPassPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratPassAcc = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratPassEva = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (_ratPassPow*3 + _ratPassAcc*4 + _ratPassEva)/8;

        self.cost = (int)pow((float)self.ratOvr/3.5,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        self.ratSpeed = (int) (47 + self.year*5 + [HBSharedUtils randomValue]*5 - 25*[HBSharedUtils randomValue]);
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 190;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5) + 2;
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };

        _statsPassAtt = 0;
        _statsPassComp = 0;
        _statsTD = 0;
        _statsInt = 0;
        _statsPassYards = 0;
        _statsSacked = 0;

        _careerStatsPassAtt = 0;
        _careerStatsPassComp = 0;
        _careerStatsTD = 0;
        _careerStatsInt = 0;
        _careerStatsPassYards = 0;
        _careerStatsSacked = 0;
        
        _statsRushAtt = 0;
        _statsRushYards = 0;
        _statsRushTD = 0;
        _statsFumbles = 0;
        
        _careerStatsRushAtt = 0;
        _careerStatsRushYards = 0;
        _careerStatsRushTD = 0;
        _careerStatsFumbles = 0;

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
        _ratPassPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        _ratPassAcc += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        _ratPassEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        _ratSpeed += (int) ([HBSharedUtils randomValue] * (self.ratPot - 25)) / 10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            _ratPassPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 20))/10;
            _ratPassAcc += (int)([HBSharedUtils randomValue]*(self.ratPot - 20))/10;
            _ratPassEva += (int)([HBSharedUtils randomValue]*(self.ratPot - 20))/10;
            _ratSpeed += (int) ([HBSharedUtils randomValue] * (self.ratPot - 20)) / 10;
            
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        _ratPassPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        _ratPassAcc += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        _ratPassEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        _ratSpeed += (int) ([HBSharedUtils randomValue] * (self.ratPot + self.gamesPlayedSeason - 40)) / 10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            _ratPassPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
            _ratPassAcc += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
            _ratPassEva += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
            _ratSpeed += (int) ([HBSharedUtils randomValue] * (self.ratPot + self.gamesPlayedSeason - 35)) / 10;
        }
    }

    self.ratOvr = (_ratPassPow*3 + _ratPassAcc*4 + _ratPassEva)/8;
    self.ratImprovement = self.ratOvr - oldOvr;

    self.statsPassAtt = 0;
    self.statsPassComp = 0;
    self.statsTD = 0;
    self.statsInt = 0;
    self.statsPassYards = 0;
    self.statsSacked = 0;
    
    _statsRushAtt = 0;
    _statsRushYards = 0;
    _statsRushTD = 0;
    _statsFumbles = 0;
    
    [super advanceSeason];
}

-(int)getHeismanScore {
    return self.statsTD * 140 - self.statsInt * 250 + self.statsPassYards;
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];

    [stats setObject:[NSString stringWithFormat:@"%d",_statsPassComp] forKey:@"completions"];
    [stats setObject:[NSString stringWithFormat:@"%d",_statsPassAtt] forKey:@"attempts"];
    [stats setObject:[NSString stringWithFormat:@"%d yds",_statsPassYards] forKey:@"passYards"];

    int compPercent = 0;
    if (_statsPassAtt > 0) {
        compPercent = (int)ceil(100.0*((double)_statsPassComp/(double)_statsPassAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",compPercent] forKey:@"completionPercentage"];

    int ypa = 0;
    if (_statsPassAtt > 0) {
        ypa = (int)ceil((double)_statsPassYards/(double)_statsPassAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yards/att",ypa] forKey:@"yardsPerAttempt"];

    int ypg = 0;
    if (games > 0) {
        ypg = (int)ceil((double)_statsPassYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yards/gm",ypg] forKey:@"yardsPerGame"];

    [stats setObject:[NSString stringWithFormat:@"%d TDs",_statsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d INTs",_statsInt] forKey:@"interceptions"];

    [stats setObject:[NSString stringWithFormat:@"%d TDs",_statsRushTD] forKey:@"rushTouchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",_statsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d carries",_statsRushAtt] forKey:@"carries"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",_statsRushYards] forKey:@"rushYards"];
    
    int ypc = 0;
    if (_statsRushAtt > 0) {
        ypc = (int)ceil((double)_statsRushYards/(double)_statsRushAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/carry",ypc] forKey:@"yardsPerCarry"];
    
    int rypg = 0;
    if (games > 0) {
        rypg = (int)ceil((double)_statsRushYards/(double)games);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",rypg] forKey:@"rushYardsPerGame"];
    

    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedCareerStats]];

    [stats setObject:[NSString stringWithFormat:@"%d",_careerStatsPassComp] forKey:@"completions"];
    [stats setObject:[NSString stringWithFormat:@"%d",_careerStatsPassAtt] forKey:@"attempts"];
    [stats setObject:[NSString stringWithFormat:@"%d yds",_careerStatsPassYards] forKey:@"passYards"];

    int compPercent = 0;
    if (_careerStatsPassAtt > 0) {
        compPercent = (int)ceil(100.0*((double)_careerStatsPassComp/(double)_careerStatsPassAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",compPercent] forKey:@"completionPercentage"];

    int ypa = 0;
    if (_careerStatsPassAtt > 0) {
        ypa = (int)ceil((double)_careerStatsPassYards/(double)_careerStatsPassAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yards/att",ypa] forKey:@"yardsPerAttempt"];

    int ypg = 0;
    if (self.gamesPlayed > 0) {
        ypg = (int)ceil((double)_careerStatsPassYards/(double)self.gamesPlayed);
    }
    
    [stats setObject:[NSString stringWithFormat:@"%d yards/gm",ypg] forKey:@"yardsPerGame"];

    [stats setObject:[NSString stringWithFormat:@"%d TDs",_careerStatsTD] forKey:@"touchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d INTs",_careerStatsInt] forKey:@"interceptions"];
    
    [stats setObject:[NSString stringWithFormat:@"%d TDs",_careerStatsRushTD] forKey:@"rushTouchdowns"];
    [stats setObject:[NSString stringWithFormat:@"%d Fum",_careerStatsFumbles] forKey:@"fumbles"];
    
    [stats setObject:[NSString stringWithFormat:@"%d carries",_careerStatsRushAtt] forKey:@"carries"];
    [stats setObject:[NSString stringWithFormat:@"%d yards",_careerStatsRushYards] forKey:@"rushYards"];
    
    int ypc = 0;
    if (_careerStatsRushAtt > 0) {
        ypc = (int)ceil((double)_careerStatsRushYards/(double)_careerStatsRushAtt);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/carry",ypc] forKey:@"yardsPerCarry"];
    
    int rypg = 0;
    if (self.gamesPlayed > 0) {
        rypg = (int)ceil((double)_careerStatsRushYards/(double)self.gamesPlayed);
    }
    [stats setObject:[NSString stringWithFormat:@"%d yds/gm",rypg] forKey:@"rushYardsPerGame"];
    

    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:_ratPassPow] forKey:@"passPower"];
    [stats setObject:[self getLetterGrade:_ratPassAcc] forKey:@"passAccuracy"];
    [stats setObject:[self getLetterGrade:_ratPassEva] forKey:@"passEvasion"];
    [stats setObject:[self getLetterGrade:_ratSpeed] forKey:@"rushSpeed"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];

    return [stats copy];
}

-(void)checkRecords {
    //completions
    if (self.statsPassComp > self.team.singleSeasonCompletionsRecord.statistic) {
        self.team.singleSeasonCompletionsRecord = [Record newRecord:@"Completions" player:self stat:self.statsPassComp year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsPassComp > self.team.careerCompletionsRecord.statistic) {
        self.team.careerCompletionsRecord = [Record newRecord:@"Completions" player:self stat:self.careerStatsPassComp year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.statsPassComp > self.team.league.singleSeasonCompletionsRecord.statistic) {
        self.team.league.singleSeasonCompletionsRecord = [Record newRecord:@"Completions" player:self stat:self.statsPassComp year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsPassComp > self.team.league.careerCompletionsRecord.statistic) {
        self.team.league.careerCompletionsRecord = [Record newRecord:@"Completions" player:self stat:self.careerStatsPassComp year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    //TD
    if (self.statsTD > self.team.singleSeasonPassTDsRecord.statistic) {
        self.team.singleSeasonPassTDsRecord = [Record newRecord:@"Pass TDs" player:self stat:self.statsTD year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsTD > self.team.careerPassTDsRecord.statistic) {
        self.team.careerPassTDsRecord = [Record newRecord:@"Pass TDs" player:self stat:self.careerStatsTD year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.statsTD > self.team.league.singleSeasonPassTDsRecord.statistic) {
        self.team.league.singleSeasonPassTDsRecord = [Record newRecord:@"Pass TDs" player:self stat:self.statsTD year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsTD > self.team.league.careerPassTDsRecord.statistic) {
        self.team.league.careerPassTDsRecord = [Record newRecord:@"Pass TDs" player:self stat:self.careerStatsTD year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    //Pass Yards
    if (self.statsPassYards > self.team.singleSeasonPassYardsRecord.statistic) {
        self.team.singleSeasonPassYardsRecord = [Record newRecord:@"Pass Yards" player:self stat:self.statsPassYards year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsPassYards > self.team.careerPassYardsRecord.statistic) {
        self.team.careerPassYardsRecord = [Record newRecord:@"Pass Yards" player:self stat:self.careerStatsPassYards year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.statsPassYards > self.team.league.singleSeasonPassYardsRecord.statistic) {
        self.team.league.singleSeasonPassYardsRecord = [Record newRecord:@"Pass Yards" player:self stat:self.statsPassYards year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsPassYards > self.team.league.careerPassYardsRecord.statistic) {
        self.team.league.careerPassYardsRecord = [Record newRecord:@"Pass Yards" player:self stat:self.careerStatsPassYards year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    //interceptions
    if (self.statsInt > self.team.singleSeasonInterceptionsRecord.statistic) {
        self.team.singleSeasonInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.statsInt year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsInt > self.team.careerInterceptionsRecord.statistic) {
        self.team.careerInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.careerStatsInt year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.statsInt > self.team.league.singleSeasonInterceptionsRecord.statistic) {
        self.team.league.singleSeasonInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.statsInt year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }

    if (self.careerStatsInt > self.team.league.careerInterceptionsRecord.statistic) {
        self.team.league.careerInterceptionsRecord = [Record newRecord:@"Interceptions" player:self stat:self.careerStatsInt year:(int)(2017 + self.team.league.leagueHistoryDictionary.count - 1)];
    }
}

@end
