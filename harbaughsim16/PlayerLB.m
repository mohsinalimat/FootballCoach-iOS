//
//  PlayerLB.m
//  profootballcoach
//
//  Created by Akshay Easwaran on 6/24/16.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "PlayerLB.h"
#import "Record.h"

@implementation PlayerLB
@synthesize ratLBPas,ratLBRsh,ratLBTkl;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.ratLBTkl = [aDecoder decodeIntForKey:@"ratLBTkl"];
        self.ratLBRsh = [aDecoder decodeIntForKey:@"ratLBRsh"];
        self.ratLBPas = [aDecoder decodeIntForKey:@"ratLBPas"];
        
        if ([aDecoder containsValueForKey:@"personalDetails"]) {
            self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
            if (self.personalDetails == nil) {
                NSInteger weight = (int)([HBSharedUtils randomValue] * 125) + 225;
                NSInteger inches = (int)([HBSharedUtils randomValue] * 3) + 2;
                self.personalDetails = @{@"home_state" : [HBSharedUtils randomState],
                                         @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                         @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                         };
            }
        } else {
            NSInteger weight = (int)([HBSharedUtils randomValue] * 125) + 225;
            NSInteger inches = (int)([HBSharedUtils randomValue] * 3) + 2;
            self.personalDetails = @{@"home_state" : [HBSharedUtils randomState],
                                     @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
                                     @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
                                     };
        }
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInt:self.ratLBTkl forKey:@"ratLBTkl"];
    [aCoder encodeInt:self.ratLBRsh forKey:@"ratLBRsh"];
    [aCoder encodeInt:self.ratLBPas forKey:@"ratLBPas"];
    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}

-(instancetype)initWithName:(NSString*)name team:(Team*)team year:(int)year potential:(int)potential iq:(int)iq tkl:(int)tkl pass:(int)pass rush:(int)rush dur:(int)dur {
    self = [super init];
    if (self) {
        self.team = team;
        self.name = name;
        self.year = year;
        self.startYear = (int)team.league.leagueHistoryDictionary.count + (int)team.league.baseYear;
        self.ratDur = dur;
        self.ratOvr = (self.ratLBTkl*3 + self.ratLBRsh + self.ratLBPas)/5;
        self.ratPot = potential;
        self.ratFootIQ = iq;
        self.ratLBRsh = rush;
        self.ratLBPas = pass;
        self.ratLBTkl = tkl;
        self.position = @"LB";
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

+(instancetype)newLBWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq tkl:(int)tkl rush:(int)rsh pass:(int)pass dur:(int)dur {
    return [[PlayerLB alloc] initWithName:nm team:t year:yr potential:pot iq:iq tkl:tkl pass:pass rush:rsh dur:dur];
}

+(instancetype)newLBWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerLB alloc] initWithName:nm year:yr stars:stars team:t];
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
        self.ratLBTkl = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratLBRsh = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratLBPas = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratLBTkl*3 + self.ratLBRsh + self.ratLBPas)/5;
        self.position = @"LB";
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

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    if (self.hasRedshirt) {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratLBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratLBRsh += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        ratLBPas += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            ratLBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            ratLBRsh += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
            ratLBPas += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        }
    } else {
        self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratLBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratLBRsh += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        ratLBPas += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 35))/10;
        if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
            //breakthrough
            ratLBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            ratLBRsh += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
            ratLBPas += (int)([HBSharedUtils randomValue]*(self.ratPot + self.gamesPlayedSeason - 40))/10;
        }
    }
    
    self.ratOvr = (ratLBTkl*3 + ratLBRsh + ratLBPas)/5;
    self.ratImprovement = self.ratOvr - oldOvr;
    [super advanceSeason];
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.ratPot] forKey:@"lbPotential"];
    [stats setObject:[self getLetterGrade:ratLBTkl] forKey:@"lbTkl"];
    [stats setObject:[self getLetterGrade:ratLBRsh] forKey:@"lbRun"];
    [stats setObject:[self getLetterGrade:ratLBPas] forKey:@"lbPass"];
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionaryWithDictionary:[super detailedRatings]];
    [stats setObject:[self getLetterGrade:ratLBTkl] forKey:@"lbTkl"];
    [stats setObject:[self getLetterGrade:ratLBRsh] forKey:@"lbRun"];
    [stats setObject:[self getLetterGrade:ratLBPas] forKey:@"lbPass"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

@end
