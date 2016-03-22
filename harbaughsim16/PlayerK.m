//
//  PlayerK.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerK.h"

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
        self.ratFootIQ = (int) (50 + stars*4 + 30* [HBSharedUtils randomValue]);
        _ratKickPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratKickAcc = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratKickFum = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (_ratKickPow + _ratKickAcc)/2;
        
        self.cost = (int)pow((float)self.ratOvr/3.5,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
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
    self.year++;
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
    //reset stats (keep career stats?)
    _statsXPAtt = 0;
    _statsXPMade = 0;
    _statsFGAtt = 0;
    _statsFGMade = 0;
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

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    
    [stats setObject:[self getLetterGrade:_ratKickPow] forKey:@"kickPower"];
    [stats setObject:[self getLetterGrade:_ratKickAcc] forKey:@"kickAccuracy"];
    [stats setObject:[self getLetterGrade:_ratKickFum] forKey:@"kickClumsiness"];
    
    return [stats copy];
}


@end
