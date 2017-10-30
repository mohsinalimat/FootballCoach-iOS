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

+(int)getPosNumber:(NSString*)pos {
    if ([pos isEqualToString:@"QB"]) {
        return 0;
    } else if ([pos isEqualToString:@"RB"]) {
        return 1;
    } else if ([pos isEqualToString:@"WR"]) {
        return 2;
    } else if ([pos isEqualToString:@"OL"]) {
        return 3;
    } else if ([pos isEqualToString:@"TE"]) {
        return 4;
    } else if ([pos isEqualToString:@"K"]) {
        return 5;
    } else if ([pos isEqualToString:@"S"]) {
        return 6;
    } else if ([pos isEqualToString:@"CB"]) {
        return 7;
    } else if ([pos isEqualToString:@"DL"]) {
        return 8;
    } else if ([pos isEqualToString:@"LB"]) {
        return 9;
    } else {
        return 10;
    }
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
    if (self.wasRedshirted || self.hasRedshirt) {
        if (self.year == 0) {
            return @"RS";
        } else if (self.year == 1) {
            return @"RS Fr";
        } else if (self.year == 2) {
            return @"RS So";
        } else if (self.year == 3) {
            return @"RS Jr";
        } else if (self.year == 4) {
            return @"RS Sr";
        } else {
            if (self.draftPosition) {
                return [NSString stringWithFormat:@"Rd%@-Pk%@", self.draftPosition[@"round"],self.draftPosition[@"pick"]];
            } else if (self.draftPosition == nil && self.year > 4) {
                return [NSString stringWithFormat:@"GRAD%ld", (long)self.endYear];
            } else {
                return @"ERROR";
            }
        }
    } else {
        if (self.year == 0) {
            return @"HS";
        } else if (self.year == 1) {
            return @"Fr";
        } else if (self.year == 2) {
            return @"So";
        } else if (self.year == 3) {
            return @"Jr";
        } else if (self.year == 4) {
            return @"Sr";
        } else {
            if (self.draftPosition) {
                return [NSString stringWithFormat:@"Rd%@-Pk%@", self.draftPosition[@"round"],self.draftPosition[@"pick"]];
            } else if (self.draftPosition == nil && self.year > 4) {
                return [NSString stringWithFormat:@"GRAD%ld", (long)self.endYear];
            } else {
                return @"ERROR";
            }
        }
    }
    
    
}

-(NSString*)getFullYearString {
    if (self.wasRedshirted || self.hasRedshirt) {
        if (self.year == 0) {
            return @"Redshirt";
        } else if (self.year == 1) {
            return @"Freshman (RS)";
        } else if (self.year == 2) {
            return @"Sophomore (RS)";
        } else if (self.year == 3) {
            return @"Junior (RS)";
        } else if (self.year == 4) {
            return @"Senior (RS)";
        } else {
            if (self.draftPosition) {
                return [NSString stringWithFormat:@"Round %@, Pick %@", self.draftPosition[@"round"],self.draftPosition[@"pick"]];
            } else if (self.draftPosition == nil && self.year > 4) {
                return [NSString stringWithFormat:@"Graduted in %ld", (long)self.endYear];
            } else {
                return @"ERROR";
            }
        }
    } else {
        if (self.year == 0) {
            return @"High School";
        } else if (self.year == 1) {
            return @"Freshman";
        } else if (self.year == 2) {
            return @"Sophomore";
        } else if (self.year == 3) {
            return @"Junior";
        } else if (self.year == 4) {
            return @"Senior";
        } else {
            if (self.draftPosition) {
                return [NSString stringWithFormat:@"Round %@, Pick %@", self.draftPosition[@"round"],self.draftPosition[@"pick"]];
            } else if (self.draftPosition == nil && self.year > 4) {
                return [NSString stringWithFormat:@"Graduted in %ld", (long)self.endYear];
            } else {
                return @"ERROR";
            }
        }
    }
}

-(BOOL)isInjured {
    return (self.injury != nil);
}

-(void)advanceSeason {
    self.year++;
    self.gamesPlayedSeason = 0;
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
    int adjGames = self.gamesPlayed;
    if (adjGames > 10) adjGames = 10;
    return self.ratOvr * adjGames;
}

-(NSString*)getInitialName {
    NSArray *names = [self.name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstName = names[0];
    return [NSString stringWithFormat:@"%@. %@", [firstName substringWithRange:NSMakeRange(0, 1)], names[1]];
}

-(NSString*)getPosNameYrOvrPot_Str {
    return [NSString stringWithFormat:@"%@ %@ [%@] (OVR: %ld)\n", self.position, self.name, [self getYearString], (long)self.ratOvr];
}

-(NSString*)getPosNameYrOvrPot_OneLine {
    return [NSString stringWithFormat:@"%@ %@ [%@] (OVR: %ld)\n", self.position, [self getInitialName], [self getYearString], (long)self.ratOvr];
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
    
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerAllConferences] forKey:@"allConferences"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerAllAmericans] forKey:@"allAmericans"];
    [stats setObject:[NSString stringWithFormat:@"%d",self.careerHeismans] forKey:@"heismans"];
    return stats;
}

-(NSDictionary*)detailedRatings {
    return @{@"potential" : [self getLetterGrade:self.ratPot], @"durability" : [self getLetterGrade:self.ratDur]};
}

-(void)checkRecords {
    
}

-(NSString *)simpleAwardReport {
    NSMutableString *awards = [NSMutableString string];
    int parts = 0;
    if (self.careerHeismans > 0) {
        [awards appendFormat:@"%lix POTY",(long)self.careerHeismans];
        parts++;
    }
    
    if (self.careerAllAmericans > 0) {
        [awards appendFormat:@"?%lix All-League",(long)self.careerAllAmericans];
        parts++;
    }
    
    if (self.careerAllConferences > 0) {
        [awards appendFormat:@"?%lix All-Conference",(long)self.careerAllConferences];
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
