//
//  PlayerF7.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerF7.h"

@implementation PlayerF7
@synthesize ratF7Pas,ratF7Pow,ratF7Rsh;

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + (int)t.league.baseYear;
        self.ratDur = dur;
        self.ratOvr = (pow*3 + rsh + pass)/5;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        self.ratF7Pow = pow;
        self.ratF7Rsh = rsh;
        self.ratF7Pas = pass;
        
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
        
        self.position = @"F7";
    }
    return self;
}

-(instancetype)initWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    self = [super init];
    if (self) {
        self.name = nm;
        self.year = yr;
        self.team = t;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + (int)t.league.baseYear;
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratF7Pow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratF7Rsh = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratF7Pas = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratF7Pow*3 + self.ratF7Rsh + self.ratF7Pas)/5;
        
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
        
        self.position = @"F7";
    }
    return self;
}

+(instancetype)newF7WithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass dur:(int)dur {
    return [[PlayerF7 alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow rush:rsh pass:pass dur:dur];
}

+(instancetype)newF7WithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerF7 alloc] initWithName:nm year:yr stars:stars team:t];
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratF7Pow += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratF7Rsh += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratF7Pas += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratF7Pow += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratF7Rsh += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratF7Pas += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratF7Pow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratF7Rsh += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratF7Pas += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratF7Pow += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratF7Rsh += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratF7Pas += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    
    self.ratOvr = (self.ratF7Pow*3 + self.ratF7Rsh + self.ratF7Pas)/5;
    self.ratImprovement = self.ratOvr - oldOvr;
    [super advanceSeason];
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.ratPot] forKey:@"f7Potential"];
    [stats setObject:[self getLetterGrade:self.ratF7Pow] forKey:@"f7Pow"];
    [stats setObject:[self getLetterGrade:self.ratF7Rsh] forKey:@"f7Run"];
    [stats setObject:[self getLetterGrade:self.ratF7Pas] forKey:@"f7Pass"];
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:self.ratF7Pow] forKey:@"f7Pow"];
    [stats setObject:[self getLetterGrade:self.ratF7Rsh] forKey:@"f7Run"];
    [stats setObject:[self getLetterGrade:self.ratF7Pas] forKey:@"f7Pass"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}
@end
