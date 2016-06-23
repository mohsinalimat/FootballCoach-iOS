//
//  PlayerCB.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerCB.h"

@implementation PlayerCB

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ratCBCov = [aDecoder decodeIntForKey:@"ratCBCov"];
        _ratCBSpd = [aDecoder decodeIntForKey:@"ratCBSpd"];
        _ratCBTkl = [aDecoder decodeIntForKey:@"ratCBTkl"];
        
        if ([aDecoder containsValueForKey:@"personalDetails"]) {
            self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
            if (self.personalDetails == nil) {
                NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 170;
                NSInteger inches = (int)([HBSharedUtils randomValue] * 3);
                self.personalDetails = @{
                                         @"home_state" : [HBSharedUtils randomState],
                                         @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                         @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                         };
            }
        } else {
            NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 170;
            NSInteger inches = (int)([HBSharedUtils randomValue] * 3);
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
    
    [aCoder encodeInt:_ratCBCov forKey:@"ratCBCov"];
    [aCoder encodeInt:_ratCBSpd forKey:@"ratCBSpd"];
    [aCoder encodeInt:_ratCBTkl forKey:@"ratCBTkl"];
    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}

-(instancetype)initWithName:(NSString*)name team:(Team*)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = team;
        self.name = name;
        self.year = year;
        self.startYear = (int)team.league.leagueHistoryDictionary.count + 2016;
        self.ratDur = dur;
        self.ratOvr = (coverage * 2 + speed + tackling) / 4;
        self.ratPot = potential;
        self.ratFootIQ = iq;
        self.ratCBCov = coverage;
        self.ratCBSpd = speed;
        self.ratCBTkl = tackling;
        self.position = @"CB";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 170;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 3);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
    }
    return self;
}

+(instancetype)newCBWithName:(NSString *)name team:(Team *)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling dur:(int)dur {
    return [[PlayerCB alloc] initWithName:name team:team year:year potential:potential iq:iq coverage:coverage speed:speed tackling:tackling dur:dur];
}

+(instancetype)newCBWithName:(NSString *)name year:(int)year stars:(int)stars team:(Team*)t {
    return [[PlayerCB alloc] initWithName:name year:year stars:stars team:t];
}

-(instancetype)initWithName:(NSString*)name year:(int)year stars:(int)stars team:(Team*)t {
    self = [super init];
    if(self) {
        self.team = t;
        self.name = name;
        self.year = year;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + 2016;
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int)([HBSharedUtils randomValue]*50 + 50);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratCBCov = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratCBSpd = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratCBTkl = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratCBCov*2 + self.ratCBSpd + self.ratCBTkl)/4;
        self.position = @"CB";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 170;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 3);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
    }
    return self;
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        _ratCBCov += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        _ratCBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        _ratCBSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            _ratCBCov += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            _ratCBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            _ratCBSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        _ratCBCov += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        _ratCBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        _ratCBSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            _ratCBCov += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            _ratCBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            _ratCBSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    self.ratOvr = (self.ratCBCov * 2 + self.ratCBSpd + self.ratCBTkl) / 4;
    self.ratImprovement = self.ratOvr - oldOvr;
    [super advanceSeason];
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.ratPot] forKey:@"cbPotential"];
    [stats setObject:[self getLetterGrade:_ratCBCov] forKey:@"cbCoverage"];
    [stats setObject:[self getLetterGrade:_ratCBSpd] forKey:@"cbSpeed"];
    [stats setObject:[self getLetterGrade:_ratCBTkl] forKey:@"cbTackling"];
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:_ratCBCov] forKey:@"cbCoverage"];
    [stats setObject:[self getLetterGrade:_ratCBSpd] forKey:@"cbSpeed"];
    [stats setObject:[self getLetterGrade:_ratCBTkl] forKey:@"cbTackling"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

@end
