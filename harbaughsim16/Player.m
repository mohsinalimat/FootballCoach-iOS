//
//  Player.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"
#import "HBSharedUtils.h"

@implementation Player

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _position = [aDecoder decodeObjectForKey:@"position"];
        _ratOvr = [aDecoder decodeIntForKey:@"ratOvr"];
        _ratPot = [aDecoder decodeIntForKey:@"ratPot"];
        _ratImprovement = [aDecoder decodeIntForKey:@"ratImprovement"];
        _year = [aDecoder decodeIntForKey:@"year"];
        _ratFootIQ = [aDecoder decodeIntForKey:@"ratFootIQ"];
        _cost = [aDecoder decodeIntForKey:@"cost"];
        _gamesPlayed = [aDecoder decodeIntForKey:@"gamesPlayed"];
        _injury = [aDecoder decodeObjectForKey:@"injury"];
        _team = [aDecoder decodeObjectForKey:@"team"];
        
        if ([aDecoder containsValueForKey:@"draftPosition"]) {
            _draftPosition = [aDecoder decodeObjectForKey:@"draftPosition"];
        } else {
            _draftPosition = nil;
        }
        
        if ([aDecoder containsValueForKey:@"hasRedshirt"]) {
            _hasRedshirt = [aDecoder decodeBoolForKey:@"hasRedshirt"];
        } else {
            _hasRedshirt = NO;
        }
        
        if ([aDecoder containsValueForKey:@"wasRedshirted"]) {
            _wasRedshirted = [aDecoder decodeBoolForKey:@"wasRedshirted"];
        } else {
            _wasRedshirted = NO;
        }
        
        if ([aDecoder containsValueForKey:@"isHeisman"]) {
            _isHeisman = [aDecoder decodeBoolForKey:@"isHeisman"];
        } else {
            _isHeisman = NO;
        }
        
        if ([aDecoder containsValueForKey:@"isAllAmerican"]) {
            _isAllAmerican = [aDecoder decodeBoolForKey:@"isAllAmerican"];
        } else {
            _isAllAmerican = NO;
        }
        
        if ([aDecoder containsValueForKey:@"isAllConference"]) {
            _isAllConference = [aDecoder decodeBoolForKey:@"isAllConference"];
        } else {
            _isAllConference = NO;
        }
        
        if ([aDecoder containsValueForKey:@"ratDur"]) {
            _ratDur = [aDecoder decodeIntForKey:@"ratDur"];
        } else {
            _ratDur = (int) (50 + 50 * [HBSharedUtils randomValue]);
        }
        
        if ([aDecoder containsValueForKey:@"careerHeismans"]) {
            _careerHeismans = [aDecoder decodeIntForKey:@"careerHeismans"];
        } else {
            _careerHeismans = 0;
        }
        
        if ([aDecoder containsValueForKey:@"careerAllAmericans"]) {
            _careerAllAmericans = [aDecoder decodeIntForKey:@"careerAllAmericans"];
        } else {
            _careerAllAmericans = 0;
        }
        
        if ([aDecoder containsValueForKey:@"startYear"]) {
            _startYear = [aDecoder decodeIntForKey:@"startYear"];
        } else {
            NSInteger curYear = _team.league.leagueHistory.count + 2016;
            _startYear = (int)(curYear - _year - 1);
        }
        
        if ([aDecoder containsValueForKey:@"endYear"]) {
            _endYear = [aDecoder decodeIntForKey:@"endYear"];
        } else {
            _endYear = 0;
        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_team forKey:@"team"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_position forKey:@"position"];
    [aCoder encodeInt:_ratOvr forKey:@"ratOvr"];
    [aCoder encodeInt:_year forKey:@"year"];
    [aCoder encodeInt:_ratPot forKey:@"ratPot"];
    [aCoder encodeInt:_ratDur forKey:@"ratDur"];
    [aCoder encodeInt:_ratFootIQ forKey:@"ratFootIQ"];
    [aCoder encodeInt:_ratImprovement forKey:@"ratImprovement"];
    [aCoder encodeInt:_cost forKey:@"cost"];
    [aCoder encodeInt:_gamesPlayed forKey:@"gamesPlayed"];
    [aCoder encodeObject:_injury forKey:@"injury"];
    [aCoder encodeBool:_wasRedshirted forKey:@"wasRedshirted"];
    [aCoder encodeBool:_hasRedshirt forKey:@"hasRedshirt"];
    [aCoder encodeBool:_isHeisman forKey:@"isHeisman"];
    [aCoder encodeBool:_isAllAmerican forKey:@"isAllAmerican"];
    [aCoder encodeBool:_isAllConference forKey:@"isAllConference"];
    [aCoder encodeObject:_draftPosition forKey:@"draftPosition"];
    [aCoder encodeInt:_careerHeismans forKey:@"careerHeismans"];
    [aCoder encodeInt:_careerAllConferences forKey:@"careerAllConferences"];
    [aCoder encodeInt:_careerAllAmericans forKey:@"careerAllAmericans"];
    [aCoder encodeInt:_startYear forKey:@"startYear"];
    [aCoder encodeInt:_endYear forKey:@"endYear"];
    
}

- (NSComparisonResult)compare:(id)other
{
    Player *player = (Player*)other;
    if (!self.hasRedshirt && !player.hasRedshirt) {
        if (self.ratOvr > player.ratOvr) {
            return -1;
        } else if (self.ratOvr < player.ratOvr) {
            return 1;
        } else {
            if (self.ratPot > player.ratPot) {
                return -1;
            } else if (self.ratPot < player.ratPot) {
                return 1;
            } else {
                return 0;
            }
        }
    } else if (self.hasRedshirt) {
        return 1;
    } else if (player.hasRedshirt) {
        return -1;
    } else {
        if (self.ratOvr > player.ratOvr) {
            return -1;
        } else if (self.ratOvr < player.ratOvr) {
            return 1;
        } else {
            if (self.ratPot > player.ratPot) {
                return -1;
            } else if (self.ratPot < player.ratPot) {
                return 1;
            } else {
                return 0;
            }
        }
    }
}

+ (NSArray *)letterGrades
{
    static NSArray *letterGrades;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        letterGrades = @[@"F", @"F+", @"D", @"D+", @"C", @"C+", @"B", @"B+", @"A", @"A+"];

    });
    return letterGrades;
}

-(NSString*)getYearString {
    if (_wasRedshirted || _hasRedshirt) {
        if (_year == 0) {
            return @"RS";
        } else if (_year == 1) {
            return @"RS Fr";
        } else if (_year == 2) {
            return @"RS So";
        } else if (_year == 3) {
            return @"RS Jr";
        } else if (_year == 4) {
            return @"RS Sr";
        }
    } else {
        if (_year == 0) {
            return @"HS";
        } else if (_year == 1) {
            return @"Fr";
        } else if (_year == 2) {
            return @"So";
        } else if (_year == 3) {
            return @"Jr";
        } else if (_year == 4) {
            return @"Sr";
        }
    }
    
    if (_draftPosition) {
        return [NSString stringWithFormat:@"Rd %@, Pk %@", _draftPosition[@"round"],_draftPosition[@"pick"]];
    } else {
        return @"ERROR";
    }
}

-(NSString*)getFullYearString {
    if (_wasRedshirted || _hasRedshirt) {
        if (_year == 0) {
            return @"Redshirt";
        } else if (_year == 1) {
            return @"Freshman (RS)";
        } else if (_year == 2) {
            return @"Sophomore (RS)";
        } else if (_year == 3) {
            return @"Junior (RS)";
        } else if (_year == 4) {
            return @"Senior (RS)";
        }
    } else {
        if (_year == 0) {
            return @"High School";
        } else if (_year == 1) {
            return @"Freshman";
        } else if (_year == 2) {
            return @"Sophomore";
        } else if (_year == 3) {
            return @"Junior";
        } else if (_year == 4) {
            return @"Senior";
        }
    }
    
    if (_draftPosition) {
        return [NSString stringWithFormat:@"Round %@, Pick %@", _draftPosition[@"round"],_draftPosition[@"pick"]];
    } else {
        return @"ERROR";
    }
}

-(BOOL)isInjured {
    return (self.injury != nil);
}

-(void)advanceSeason {
    self.year++;
    self.isHeisman = NO;
    self.isAllAmerican = NO;
    self.isAllConference = NO;
    self.injury = nil;
    if (self.hasRedshirt) {
        self.hasRedshirt = NO;
        self.wasRedshirted = YES;
    }
}

-(int)getHeismanScore {
    int adjGames = _gamesPlayed;
    if (adjGames > 10) adjGames = 10;
    return _ratOvr * adjGames;
}

-(NSString*)getInitialName {
    NSArray *names = [_name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstName = names[0];
    return [NSString stringWithFormat:@"%@. %@", [firstName substringWithRange:NSMakeRange(0, 1)], names[1]];
}

-(NSString*)getPosNameYrOvrPot_Str {
    return [NSString stringWithFormat:@"%@ %@ [%@] (OVR: %ld)\n", _position, _name, [self getYearString], (long)_ratOvr];
}

-(NSString*)getPosNameYrOvrPot_OneLine {
    return [NSString stringWithFormat:@"%@ %@ [%@] (OVR: %ld)\n", _position, [self getInitialName], [self getYearString], (long)_ratOvr];
}

-(NSString*)getLetterGradeWithString:(NSString*)num {
    int ind = ([num intValue] - 50)/5;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGradePotWithString:(NSString*)num {
    int ind = ([num intValue]) / 10;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGrade:(int)num {
    int ind = (num - 50)/5;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGradePot:(int)num {
    int ind = num / 10;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSDictionary*)detailedStats:(int)games {
    return [NSDictionary dictionary];
}

-(NSDictionary*)detailedCareerStats {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    
    [stats setObject:[NSString stringWithFormat:@"%d",_careerAllConferences] forKey:@"allConferences"];
    [stats setObject:[NSString stringWithFormat:@"%d",_careerAllAmericans] forKey:@"allAmericans"];
    [stats setObject:[NSString stringWithFormat:@"%d",_careerHeismans] forKey:@"heismans"];
    return stats;
}

-(NSDictionary*)detailedRatings {
    return @{@"potential" : [self getLetterGrade:_ratPot], @"durability" : [self getLetterGrade:_ratDur]};
}

-(void)checkRecords {
    
}

-(NSString *)simpleAwardReport {
    NSMutableString *awards = [NSMutableString string];
    int parts = 0;
    if (_careerHeismans > 0) {
        [awards appendFormat:@"%lix POTY",(long)_careerHeismans];
        parts++;
    }
    
    if (_careerAllAmericans > 0) {
        [awards appendFormat:@"?%lix All-League",(long)_careerAllAmericans];
        parts++;
    }
    
    if (_careerAllConferences > 0) {
        [awards appendFormat:@"?%lix All-Conference",(long)_careerAllConferences];
        parts++;
    }
    
    if (parts > 1) {
        [awards replaceOccurrencesOfString:@"?" withString:@", " options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    } else {
        [awards replaceOccurrencesOfString:@"?" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, awards.length)];
    }
    
    
    
    awards = [NSMutableString stringWithString:[[awards stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return awards;
}
@end
