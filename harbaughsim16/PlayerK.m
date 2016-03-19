//
//  PlayerK.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerK.h"

@implementation PlayerK

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
        
        self.cost = (int)(powf((float)self.ratOvr/3.5,2.0)) + (int)(arc4random()%100) - 50;
        
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
        self.ratPot = (int) (50 + 50*arc4random());
        self.ratFootIQ = (int) (50 + stars*4 + 30*arc4random());
        _ratKickPow = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratKickAcc = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        _ratKickFum = (int) (60 + self.year*5 + stars*5 - 25*arc4random());
        self.ratOvr = (_ratKickPow + _ratKickAcc)/2;
        
        self.cost = (int)pow((float)self.ratOvr/3.5,2) + (int)(arc4random()%100) - 50;
        
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
    self.ratFootIQ += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratKickPow += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratKickAcc += (int)(arc4random()%(self.ratPot - 25))/10;
    _ratKickFum += (int)(arc4random()%(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        _ratKickPow += (int)(arc4random()%(self.ratPot - 30))/10;
        _ratKickAcc += (int)(arc4random()%(self.ratPot - 30))/10;
        _ratKickFum += (int)(arc4random()%(self.ratPot - 30))/10;
    }
    self.ratOvr = (_ratKickPow + _ratKickAcc)/2;
    self.ratImprovement = self.ratOvr - oldOvr;
    //reset stats (keep career stats?)
    _statsXPAtt = 0;
    _statsXPMade = 0;
    _statsFGAtt = 0;
    _statsFGMade = 0;
}

-(NSArray*)getDetailedStatsList:(int)games {
    NSMutableArray *pStats = [NSMutableArray array];
    if (_statsXPAtt > 0) {
        [pStats addObject:[NSString stringWithFormat:@"XP Made/Att: %ld/%ld\nXP Percentage: %d%%",(long)_statsXPMade,(long)_statsXPAtt, (100 * (_statsXPMade/_statsXPAtt))]];
    } else {
        [pStats addObject:@"XP Made/Att: 0/0\nXP Percentage: 0%%"];
    }
    
    if (_statsFGAtt > 0) {
        [pStats addObject:[NSString stringWithFormat:@"FG Made/Att: %ld/%ld\nFG Percentage: %d%%",(long)_statsFGMade,(long)_statsFGAtt, (100 * (_statsFGMade/_statsFGAtt))]];
    } else {
        [pStats addObject:@"FG Made/Att: 0/0\n FG Percentage: 0%%"];
    }
    
    [pStats addObject:[NSString stringWithFormat:@"Potential: %ld\nKick Strength: %@",(long)self.ratPot,[self getLetterGrade:_ratKickPow]]];
    [pStats addObject:[NSString stringWithFormat:@"Kick Accuracy: %@\nClumsiness: %@",[self getLetterGrade:_ratKickAcc],[self getLetterGrade:_ratKickFum]]];
    
    
    return [pStats copy];
}

@end
