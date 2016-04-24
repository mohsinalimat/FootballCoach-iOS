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
        _ratingsVector = [aDecoder decodeObjectForKey:@"ratingsVector"];
        _team = [aDecoder decodeObjectForKey:@"team"];
        
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
    [aCoder encodeInt:_ratFootIQ forKey:@"ratFootIQ"];
    [aCoder encodeInt:_ratImprovement forKey:@"ratImprovement"];
    [aCoder encodeInt:_cost forKey:@"cost"];
    [aCoder encodeInt:_gamesPlayed forKey:@"gamesPlayed"];
    [aCoder encodeObject:_ratingsVector forKey:@"ratingsVector"];
    [aCoder encodeBool:_wasRedshirted forKey:@"wasRedshirted"];
    [aCoder encodeBool:_hasRedshirt forKey:@"hasRedshirt"];
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
        } else if (_year == 1 ) {
            return @"RS Fr";
        } else if (_year == 2 ) {
            return @"RS So";
        } else if (_year == 3 ) {
            return @"RS Jr";
        } else if (_year == 4 ) {
            return @"RS Sr";
        }
    } else {
        if (_year == 0) {
            return @"HS";
        } else if (_year == 1 ) {
            return @"Fr";
        } else if (_year == 2 ) {
            return @"So";
        } else if (_year == 3 ) {
            return @"Jr";
        } else if (_year == 4 ) {
            return @"Sr";
        }
    }
    return @"ERROR";
}

-(NSString*)getFullYearString {
    if (_wasRedshirted || _hasRedshirt) {
        if (_year == 0) {
            return @"Redshirt";
        } else if (_year == 1 ) {
            return @"Freshman (RS)";
        } else if (_year == 2 ) {
            return @"Sophomore (RS)";
        } else if (_year == 3 ) {
            return @"Junior (RS)";
        } else if (_year == 4 ) {
            return @"Senior (RS)";
        }
    } else {
        if (_year == 0) {
            return @"High School";
        } else if (_year == 1 ) {
            return @"Freshman";
        } else if (_year == 2 ) {
            return @"Sophomore";
        } else if (_year == 3 ) {
            return @"Junior";
        } else if (_year == 4 ) {
            return @"Senior";
        }
    }
    return @"ERROR";
}

-(void)advanceSeason {
    self.year++;
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
    return [NSDictionary dictionary];
}

-(NSDictionary*)detailedRatings {
    return @{@"potential" : [self getLetterGrade:_ratPot]};
}

-(void)checkRecords {
    
}
@end
