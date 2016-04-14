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


-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ratKickPow = [aDecoder decodeIntForKey:@"ratKickPow"];
        _ratKickAcc = [aDecoder decodeIntForKey:@"ratKickAcc"];
        _ratKickFum = [aDecoder decodeIntForKey:@"ratKickFum"];
        
        _statsXPAtt = [aDecoder decodeIntForKey:@"statsXPAtt"];
        _statsXPMade = [aDecoder decodeIntForKey:@"statsXPMade"];
        _statsFGAtt = [aDecoder decodeIntForKey:@"statsFGAtt"];
        _statsFGMade = [aDecoder decodeIntForKey:@"statsFGMade"];
        
        if ([aDecoder containsValueForKey:@"careerStatsXPAtt"]) {
            _careerStatsXPAtt = [aDecoder decodeIntForKey:@"careerStatsXPAtt"];
        } else {
            _careerStatsXPAtt = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerStatsXPMade"]) {
            _careerStatsXPMade = [aDecoder decodeIntForKey:@"careerStatsXPMade"];
        } else {
            _careerStatsXPMade = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerStatsFGAtt"]) {
            _careerStatsFGAtt = [aDecoder decodeIntForKey:@"careerStatsFGAtt"];
        } else {
            _careerStatsFGAtt = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerStatsFGMade"]) {
            _careerStatsFGMade = [aDecoder decodeIntForKey:@"careerStatsFGMade"];
        } else {
            _careerStatsFGMade = 0;
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:_ratKickPow forKey:@"ratKickPow"];
    [aCoder encodeInt:_ratKickAcc forKey:@"ratKickAcc"];
    [aCoder encodeInt:_ratKickFum forKey:@"ratKickFum"];
    
    [aCoder encodeInt:_statsFGMade forKey:@"statsFGMade"];
    [aCoder encodeInt:_statsFGAtt forKey:@"statsFGAtt"];
    [aCoder encodeInt:_statsXPMade forKey:@"statsXPMade"];
    [aCoder encodeInt:_statsXPAtt forKey:@"statsXPAtt"];
    
    [aCoder encodeInt:_careerStatsFGMade forKey:@"careerStatsFGMade"];
    [aCoder encodeInt:_careerStatsFGAtt forKey:@"careerStatsFGAtt"];
    [aCoder encodeInt:_careerStatsXPMade forKey:@"careerStatsXPMade"];
    [aCoder encodeInt:_careerStatsXPAtt forKey:@"careerStatsXPAtt"];
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc fum:(int)fum {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.ratOvr = (pow + acc)/2;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratKickPow = pow;
        _ratKickAcc = acc;
        _ratKickFum = fum;
        
        self.cost = (int)(powf((float)self.ratOvr/3.5,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratKickPow)];
        [self.ratingsVector addObject:@(self.ratKickAcc)];
        [self.ratingsVector addObject:@(self.ratKickFum)];
        
        _statsXPAtt = 0;
        _statsXPMade = 0;
        _statsFGAtt = 0;
        _statsFGMade = 0;
        
        _careerStatsXPAtt = 0;
        _careerStatsXPMade = 0;
        _careerStatsFGAtt = 0;
        _careerStatsFGMade = 0;
        
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
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        _ratKickPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratKickAcc = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratKickFum = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (_ratKickPow + _ratKickAcc)/2;
        
        self.cost = (int)((pow((float)self.ratOvr/3.5,2) + (int)([HBSharedUtils randomValue]*100) - 50) / 3);
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratKickPow)];
        [self.ratingsVector addObject:@(self.ratKickAcc)];
        [self.ratingsVector addObject:@(self.ratKickFum)];
        
        _statsXPAtt = 0;
        _statsXPMade = 0;
        _statsFGAtt = 0;
        _statsFGMade = 0;
        
        _careerStatsXPAtt = 0;
        _careerStatsXPMade = 0;
        _careerStatsFGAtt = 0;
        _careerStatsFGMade = 0;
        
        self.position = @"K";
    }
    return self;
}

+(instancetype)newKWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow accuracy:(int)acc fum:(int)fum {
    return [[PlayerK alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow accuracy:acc fum:fum];
}

+(instancetype)newKWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerK alloc] initWithName:nm year:yr stars:stars team:t];
}

-(NSMutableArray*)getStatsVector {
    NSMutableArray* v = [NSMutableArray array];
    [v addObject:@(self.statsXPMade)];
    [v addObject:@(self.statsXPAtt)];
    [v addObject:@((float)((int)((float)self.statsXPMade/self.statsXPAtt*1000))/10)];
    [v addObject:@(self.statsFGMade)];
    [v addObject:@(self.statsFGAtt)];
    [v addObject:@((float)((int)((float)self.statsFGMade/self.statsFGAtt*100))/100)];
    return v;
}


-(NSMutableArray*)getRatingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratKickPow)];
    [self.ratingsVector addObject:@(self.ratKickAcc)];
    [self.ratingsVector addObject:@(self.ratKickFum)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratKickPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratKickAcc += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratKickFum += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        _ratKickPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        _ratKickAcc += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        _ratKickFum += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
    }
    self.ratOvr = (_ratKickPow + _ratKickAcc)/2;
    self.ratImprovement = self.ratOvr - oldOvr;
    
    //self.careerStatsXPAtt += _statsXPAtt;
    //self.careerStatsXPMade += _statsXPMade;
    //self.careerStatsFGAtt += _statsFGAtt;
    //self.careerStatsFGMade += _statsFGMade;
    
    _statsXPAtt = 0;
    _statsXPMade = 0;
    _statsFGAtt = 0;
    _statsFGMade = 0;
    [super advanceSeason];
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",_statsXPMade] forKey:@"xpMade"];
    [stats setObject:[NSString stringWithFormat:@"%d",_statsXPAtt] forKey:@"xpAtt"];
    
    int xpPercent = 0;
    if (_statsXPAtt > 0) {
        xpPercent = (int)(100.0*((double)_statsXPMade/(double)_statsXPAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",xpPercent] forKey:@"xpPercentage"];
    
    [stats setObject:[NSString stringWithFormat:@"%d",_statsFGMade] forKey:@"fgMade"];
    [stats setObject:[NSString stringWithFormat:@"%d",_statsFGAtt] forKey:@"fgAtt"];
    
    int fgPercent = 0;
    if (_statsFGAtt > 0) {
        fgPercent = (int)(100.0*((double)_statsFGMade/(double)_statsFGAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",fgPercent] forKey:@"fgPercentage"];
    return [stats copy];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",_careerStatsXPMade] forKey:@"xpMade"];
    [stats setObject:[NSString stringWithFormat:@"%d",_careerStatsXPAtt] forKey:@"xpAtt"];
    
    int xpPercent = 0;
    if (_careerStatsXPAtt > 0) {
        xpPercent = (int)(100.0*((double)_careerStatsXPMade/(double)_careerStatsXPAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",xpPercent] forKey:@"xpPercentage"];
    
    [stats setObject:[NSString stringWithFormat:@"%d",_careerStatsFGMade] forKey:@"fgMade"];
    [stats setObject:[NSString stringWithFormat:@"%d",_careerStatsFGAtt] forKey:@"fgAtt"];
    
    int fgPercent = 0;
    if (_careerStatsFGAtt > 0) {
        fgPercent = (int)(100.0*((double)_careerStatsFGMade/(double)_careerStatsFGAtt));
    }
    [stats setObject:[NSString stringWithFormat:@"%d%%",fgPercent] forKey:@"fgPercentage"];
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    
    [stats setObject:[self getLetterGrade:_ratKickPow] forKey:@"kickPower"];
    [stats setObject:[self getLetterGrade:_ratKickAcc] forKey:@"kickAccuracy"];
    [stats setObject:[self getLetterGrade:_ratKickFum] forKey:@"kickClumsiness"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

-(void)checkRecords {
    //XpMade
    if (self.statsXPMade > self.team.singleSeasonXpMadeRecord.statistic) {
        self.team.singleSeasonXpMadeRecord = [Record newRecord:@"XP Made" player:self stat:self.statsXPMade year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsXPMade > self.team.careerXpMadeRecord.statistic) {
        self.team.careerXpMadeRecord = [Record newRecord:@"XP Made" player:self stat:self.careerStatsXPMade year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.statsXPMade > self.team.league.singleSeasonXpMadeRecord.statistic) {
        self.team.league.singleSeasonXpMadeRecord = [Record newRecord:@"XP Made" player:self stat:self.statsXPMade year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsXPMade > self.team.league.careerXpMadeRecord.statistic) {
        self.team.league.careerXpMadeRecord = [Record newRecord:@"XP Made" player:self stat:self.careerStatsXPMade year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    //FGMade
    if (self.statsFGMade > self.team.singleSeasonFgMadeRecord.statistic) {
        self.team.singleSeasonFgMadeRecord = [Record newRecord:@"FG Made" player:self stat:self.statsFGMade year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsFGMade > self.team.careerFgMadeRecord.statistic) {
        self.team.careerFgMadeRecord = [Record newRecord:@"FG Made" player:self stat:self.careerStatsFGMade year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.statsFGMade > self.team.league.singleSeasonFgMadeRecord.statistic) {
        self.team.league.singleSeasonFgMadeRecord = [Record newRecord:@"FG Made" player:self stat:self.statsFGMade year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
    if (self.careerStatsFGMade > self.team.league.careerFgMadeRecord.statistic) {
        self.team.league.careerFgMadeRecord = [Record newRecord:@"FG Made" player:self stat:self.careerStatsFGMade year:(int)(2016 + self.team.league.leagueHistory.count - 1)];
    }
    
}

@end
