//
//  PlayerK.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerK.h"
#import "Team.h"
#import "League.h"
#import "Record.h"

@implementation PlayerK
@synthesize ratKickAcc,ratKickFum,ratKickPow,statsFGAtt,statsXPAtt,statsFGMade,statsXPMade,careerStatsFGAtt,careerStatsXPAtt,careerStatsFGMade,careerStatsXPMade;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
            self.ratKickPow = [aDecoder decodeIntForKey:@"ratKickPow"];
            self.ratKickAcc = [aDecoder decodeIntForKey:@"ratKickAcc"];
            self.ratKickFum = [aDecoder decodeIntForKey:@"ratKickFum"];
        
            self.statsXPAtt = [aDecoder decodeIntForKey:@"statsXPAtt"];
            self.statsXPMade = [aDecoder decodeIntForKey:@"statsXPMade"];
            self.statsFGAtt = [aDecoder decodeIntForKey:@"statsFGAtt"];
            self.statsFGMade = [aDecoder decodeIntForKey:@"statsFGMade"];
        
            if ([aDecoder containsValueForKey:@"careerStatsXPAtt"]) {
                self.careerStatsXPAtt = [aDecoder decodeIntForKey:@"careerStatsXPAtt"];
            } else {
                self.careerStatsXPAtt = 0;
            }
        
            if ([aDecoder containsValueForKey:@"careerStatsXPMade"]) {
                self.careerStatsXPMade = [aDecoder decodeIntForKey:@"careerStatsXPMade"];
            } else {
                self.careerStatsXPMade = 0;
            }
        
            if ([aDecoder containsValueForKey:@"careerStatsFGAtt"]) {
                self.careerStatsFGAtt = [aDecoder decodeIntForKey:@"careerStatsFGAtt"];
            } else {
                self.careerStatsFGAtt = 0;
            }
        
            if ([aDecoder containsValueForKey:@"careerStatsFGMade"]) {
                self.careerStatsFGMade = [aDecoder decodeIntForKey:@"careerStatsFGMade"];
            } else {
                self.careerStatsFGMade = 0;
            }
        
            if ([aDecoder containsValueForKey:@"personalDetails"]) {
                    self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
                    if (self.personalDetails == nil) {
                            NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 190;
                            NSInteger inches = (int)([HBSharedUtils randomValue] * 2);
                            self.personalDetails = @{
                                                       @"home_state" : [HBSharedUtils randomState],
                                                       @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                                       @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                                       
                                                       };
                        }
                } else {
                        NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 190;
                        NSInteger inches = (int)([HBSharedUtils randomValue] * 2);
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
    
    [aCoder encodeInt:self.ratKickPow forKey:@"ratKickPow"];
    [aCoder encodeInt:self.ratKickAcc forKey:@"ratKickAcc"];
    [aCoder encodeInt:self.ratKickFum forKey:@"ratKickFum"];
    
    [aCoder encodeInt:self.statsFGMade forKey:@"statsFGMade"];
    [aCoder encodeInt:self.statsFGAtt forKey:@"statsFGAtt"];
    [aCoder encodeInt:self.statsXPMade forKey:@"statsXPMade"];
    [aCoder encodeInt:self.statsXPAtt forKey:@"statsXPAtt"];
    
    [aCoder encodeInt:self.careerStatsFGMade forKey:@"careerStatsFGMade"];
    [aCoder encodeInt:self.careerStatsFGAtt forKey:@"careerStatsFGAtt"];
    [aCoder encodeInt:self.careerStatsXPMade forKey:@"careerStatsXPMade"];
    [aCoder encodeInt:self.careerStatsXPAtt forKey:@"careerStatsXPAtt"];
    
    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}


-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc fum:(int)fum dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.startYear = (t != nil) ? (int)[t.league getCurrentYear] : (int)[[HBSharedUtils getLeague] getCurrentYear];
        self.ratDur = dur;
        self.ratOvr = (pow + acc)/2;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        self.ratKickPow = pow;
        self.ratKickAcc = acc;
        self.ratKickFum = fum;
        
        self.cost = (int)(powf((float)self.ratOvr/3.5,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 190;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 2);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        
        self.statsXPAtt = 0;
        self.statsXPMade = 0;
        self.statsFGAtt = 0;
        self.statsFGMade = 0;
        
        self.careerStatsXPAtt = 0;
        self.careerStatsXPMade = 0;
        self.careerStatsFGAtt = 0;
        self.careerStatsFGMade = 0;
        
        self.position = @"K";
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
        self.startYear = (t != nil) ? (int)[t.league getCurrentYear] : (int)[[HBSharedUtils getLeague] getCurrentYear];
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratKickPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratKickAcc = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratKickFum = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratKickPow + self.ratKickAcc)/2;
        
        self.cost = (int)((pow((float)self.ratOvr/3.5,2) + (int)([HBSharedUtils randomValue]*100) - 50) / 3);
        
        if (t == nil) {
            self.recruitStatus = CFCRecruitStatusUncommitted;
        } else {
            self.recruitStatus = CFCRecruitStatusCommitted;
        }
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 190;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 2);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
        self.fortyYardDashTime = [NSString stringWithFormat:@"%.2fs", [HBSharedUtils randomFloatBetween:4.70 and:4.90]];
        
        self.statsXPAtt = 0;
        self.statsXPMade = 0;
        self.statsFGAtt = 0;
        self.statsFGMade = 0;
        
        self.careerStatsXPAtt = 0;
        self.careerStatsXPMade = 0;
        self.careerStatsFGAtt = 0;
        self.careerStatsFGMade = 0;
        
        self.position = @"K";
    }
    return self;
}

+(instancetype)newKWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc fum:(int)fum dur:(int)dur {
    return [[PlayerK alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow accuracy:acc fum:fum dur:dur];
}

+(instancetype)newKWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerK alloc] initWithName:nm year:yr stars:stars team:t];
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratKickPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratKickAcc += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratKickFum += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratKickPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratKickAcc += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratKickFum += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratKickPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratKickAcc += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratKickFum += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratKickPow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratKickAcc += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratKickFum += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    self.ratOvr = (self.ratKickPow + self.ratKickAcc)/2;
    self.ratImprovement = self.ratOvr - oldOvr;
    
    self.statsXPAtt = 0;
    self.statsXPMade = 0;
    self.statsFGAtt = 0;
    self.statsFGMade = 0;
    [super advanceSeason];
}

-(int)getHeismanScore {
    return (int)((self.statsFGMade*5 + self.statsXPMade)*((double)self.statsFGMade/self.statsFGAtt)) + self.ratOvr;
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.statsXPMade] forKey:@"xpMade"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.statsXPAtt] forKey:@"xpAtt"];
    
    int xpPercent = 0;
    if (self.statsXPAtt > 0) {
        xpPercent = (int)(100.0*((double)self.statsXPMade/(double)self.statsXPAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",xpPercent] forKey:@"xpPercentage"];
    
    [stats setObject:[NSString stringWithFormat:@"%d",self.statsFGMade] forKey:@"fgMade"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.statsFGAtt] forKey:@"fgAtt"];
    
    int fgPercent = 0;
    if (self.statsFGAtt > 0) {
        fgPercent = (int)(100.0*((double)self.statsFGMade/(double)self.statsFGAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",fgPercent] forKey:@"fgPercentage"];
    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedCareerStats]];

    [stats setObject:[NSString stringWithFormat:@"%d",self.careerStatsXPMade] forKey:@"xpMade"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerStatsXPAtt] forKey:@"xpAtt"];
    
    int xpPercent = 0;
    if (self.careerStatsXPAtt > 0) {
        xpPercent = (int)(100.0*((double)self.careerStatsXPMade/(double)self.careerStatsXPAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",xpPercent] forKey:@"xpPercentage"];
    
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerStatsFGMade] forKey:@"fgMade"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerStatsFGAtt] forKey:@"fgAtt"];
    
    int fgPercent = 0;
    if (self.careerStatsFGAtt > 0) {
        fgPercent = (int)(100.0*((double)self.careerStatsFGMade/(double)self.careerStatsFGAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",fgPercent] forKey:@"fgPercentage"];
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    
    [stats setObject:[self getLetterGrade:self.ratKickPow] forKey:@"kickPower"];
    [stats setObject:[self getLetterGrade:self.ratKickAcc] forKey:@"kickAccuracy"];
    [stats setObject:[self getLetterGrade:self.ratKickFum] forKey:@"kickClumsiness"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

-(void)checkRecords {
    //XpMade
    if (self.statsXPMade > self.team.singleSeasonXpMadeRecord.statistic) {
        self.team.singleSeasonXpMadeRecord = [Record newRecord:@"XP Made" player:self stat:self.statsXPMade year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsXPMade > self.team.careerXpMadeRecord.statistic) {
        self.team.careerXpMadeRecord = [Record newRecord:@"XP Made" player:self stat:self.careerStatsXPMade year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsXPMade > self.team.league.singleSeasonXpMadeRecord.statistic) {
        self.team.league.singleSeasonXpMadeRecord = [Record newRecord:@"XP Made" player:self stat:self.statsXPMade year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsXPMade > self.team.league.careerXpMadeRecord.statistic) {
        self.team.league.careerXpMadeRecord = [Record newRecord:@"XP Made" player:self stat:self.careerStatsXPMade year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    //FGMade
    if (self.statsFGMade > self.team.singleSeasonFgMadeRecord.statistic) {
        self.team.singleSeasonFgMadeRecord = [Record newRecord:@"FG Made" player:self stat:self.statsFGMade year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsFGMade > self.team.careerFgMadeRecord.statistic) {
        self.team.careerFgMadeRecord = [Record newRecord:@"FG Made" player:self stat:self.careerStatsFGMade year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.statsFGMade > self.team.league.singleSeasonFgMadeRecord.statistic) {
        self.team.league.singleSeasonFgMadeRecord = [Record newRecord:@"FG Made" player:self stat:self.statsFGMade year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
    if (self.careerStatsFGMade > self.team.league.careerFgMadeRecord.statistic) {
        self.team.league.careerFgMadeRecord = [Record newRecord:@"FG Made" player:self stat:self.careerStatsFGMade year:(int)([HBSharedUtils getLeague].baseYear + self.team.league.leagueHistoryDictionary.count - 1)];
    }
    
}

@end
