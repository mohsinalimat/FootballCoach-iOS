//
//  PlayerS.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerS.h"

@implementation PlayerS
@synthesize ratSCov,ratSSpd,ratSTkl;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.ratSCov = [aDecoder decodeIntForKey:@"ratSCov"];
        self.ratSSpd = [aDecoder decodeIntForKey:@"ratSSpd"];
        self.ratSTkl = [aDecoder decodeIntForKey:@"ratSTkl"];
        
        if ([aDecoder containsValueForKey:@"personalDetails"]) {
            self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
            if (self.personalDetails == nil) {
                NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 200;
                NSInteger inches = (int)([HBSharedUtils randomValue] * 5);
                self.personalDetails = @{
                                         @"home_state" : [HBSharedUtils randomState],
                                         @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                         @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                         };
            }
        } else {
            NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 200;
            NSInteger inches = (int)([HBSharedUtils randomValue] * 5);
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
    
    [aCoder encodeInt:self.ratSCov forKey:@"ratSCov"];
    [aCoder encodeInt:self.ratSSpd forKey:@"ratSSpd"];
    [aCoder encodeInt:self.ratSTkl forKey:@"ratSTkl"];
    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}

-(instancetype)initWithName:(NSString*)name team:(Team*)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = team;
        self.name = name;
        self.year = year;
        self.startYear = (int)team.league.leagueHistoryDictionary.count + (int)team.league.baseYear;
        self.ratDur = dur;
        self.ratOvr = (coverage * 2 + speed + tackling) / 4;
        self.ratPot = potential;
        self.ratFootIQ = iq;
        self.ratSCov = coverage;
        self.ratSSpd = speed;
        self.ratSTkl = tackling;
        self.position = @"S";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 200;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5);
        self.personalDetails = @{
                                 @"home_state" : [HBSharedUtils randomState],
                                 @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                 @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                 };
    }
    return self;
}

+(instancetype)newSWithName:(NSString *)name team:(Team *)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling dur:(int)dur {
    return [[PlayerS alloc] initWithName:name team:team year:year potential:potential iq:iq coverage:coverage speed:speed tackling:tackling dur:dur];
}

+(instancetype)newSWithName:(NSString *)name year:(int)year stars:(int)stars team:(Team*)t {
    return [[PlayerS alloc] initWithName:name year:year stars:stars team:t];
}

-(instancetype)initWithName:(NSString*)name year:(int)year stars:(int)stars team:(Team*)t {
    self = [super init];
    if(self) {
        self.team = t;
        self.name = name;
        self.year = year;
        self.stars = stars;
        self.startYear = (int)t.league.leagueHistoryDictionary.count + (int)t.league.baseYear;
        self.ratDur = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratPot = (int)([HBSharedUtils randomValue]*50 + 50);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratSCov = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratSSpd = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratSTkl = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratSCov*2 + self.ratSSpd + self.ratSTkl)/4;
        self.position = @"S";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        CGFloat inMin = 0.0;
        CGFloat inMax = 100.0;
        
        CGFloat outMin = 4.80;
        CGFloat outMax = 4.34;
        
        CGFloat input = (CGFloat) self.ratSSpd;
        CGFloat fortyTime = (outMin + (outMax - outMin) * (input - inMin) / (inMax - inMin));
        self.fortyYardDashTime = [NSString stringWithFormat:@"%.2fs", fortyTime];
        
        NSInteger weight = (int)([HBSharedUtils randomValue] * 30) + 200;
        NSInteger inches = (int)([HBSharedUtils randomValue] * 5);
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
        self.ratSCov += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratSTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        self.ratSSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratSCov += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratSTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            self.ratSSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratSCov += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratSTkl += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        self.ratSSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            self.ratSCov += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratSTkl += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            self.ratSSpd += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    self.ratOvr = (self.ratSCov * 2 + self.ratSSpd + self.ratSTkl) / 4;
    self.ratImprovement = self.ratOvr - oldOvr;
    [super advanceSeason];
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.ratPot] forKey:@"sPotential"];
    [stats setObject:[self getLetterGrade:self.ratSCov] forKey:@"sCoverage"];
    [stats setObject:[self getLetterGrade:self.ratSSpd] forKey:@"sSpeed"];
    [stats setObject:[self getLetterGrade:self.ratSTkl] forKey:@"sTackling"];
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:self.ratSCov] forKey:@"sCoverage"];
    [stats setObject:[self getLetterGrade:self.ratSSpd] forKey:@"sSpeed"];
    [stats setObject:[self getLetterGrade:self.ratSTkl] forKey:@"sTackling"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}


@end
