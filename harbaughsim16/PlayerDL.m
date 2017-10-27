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
        ratDLPow = [aDecoder decodeIntForKey:@"ratDLPow"];
        ratDLRsh = [aDecoder decodeIntForKey:@"ratDLRsh"];
        ratDLPas = [aDecoder decodeIntForKey:@"ratDLPas"];
        
        if ([aDecoder containsValueForKey:@"personalDetails"]) {
            self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
            if (self.personalDetails == nil) {
                NSInteger weight = (int)([HBSharedUtils randomValue] * 125) + 225;
                NSInteger inches = (int)([HBSharedUtils randomValue] * 3) + 2;
                self.personalDetails = @{
                                         @"home_state" : [HBSharedUtils randomState],
                                         @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                         @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                         };
            }
        } else {
            NSInteger weight = (int)([HBSharedUtils randomValue] * 125) + 225;
            NSInteger inches = (int)([HBSharedUtils randomValue] * 3) + 2;
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
    
    [aCoder encodeInt:ratDLPow forKey:@"ratDLPow"];
    [aCoder encodeInt:ratDLRsh forKey:@"ratDLRsh"];
    [aCoder encodeInt:ratDLPas forKey:@"ratDLPas"];
    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + 2016;
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
        self.startYear = (int)t.league.leagueHistoryDictionary.count + 2016;
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        ratDLPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        ratDLRsh = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        ratDLPas = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (ratDLPow*3 + ratDLRsh + ratDLPas)/5;
        
        self.cost = (int)pow((float)self.ratOvr/6,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
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

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.ratPot] forKey:@"dlPotential"];
    [stats setObject:[self getLetterGrade:ratDLPow] forKey:@"dlPow"];
    [stats setObject:[self getLetterGrade:ratDLRsh] forKey:@"dlRun"];
    [stats setObject:[self getLetterGrade:ratDLPas] forKey:@"dlPass"];
    
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
@end
