//
//  Player.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

@implementation Player

- (NSComparisonResult)compare:(id)other
{
    Player *player = (Player*)other;
    return self.ratOvr > player.ratOvr ? -1 : self.ratOvr == player.ratOvr ? 0 : 1;
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
    return @"ERROR";
}

-(void)advanceSeason {
    _year ++;
}

-(NSInteger)getHeismanScore {
    return 0;
}

-(NSString*)getInitialName {
    NSArray *names = [_name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *firstName = names[0];
    return [NSString stringWithFormat:@"%@. %@", [firstName substringWithRange:NSMakeRange(0, 1)], names[1]];
}

-(NSString*)getPosNameYrOvrPot_Str {
    return [NSString stringWithFormat:@"%@ %@ [%@]> Ovr: %ld, Pot: %ld", _position, _name, [self getYearString], (long)_ratOvr, (long)_ratPot];
}

-(NSString*)getPosNameYrOvrPot_OneLine {
    return [NSString stringWithFormat:@"%@ %@ [%@]> Ovr: %ld, Pot: %ld", _position, [self getInitialName], [self getYearString], (long)_ratOvr, (long)_ratPot];
}

-(NSString*)getLetterGradeWithString:(NSString*)num {
    NSInteger ind = ([num integerValue] - 50)/5;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGradePotWithString:(NSString*)num {
    NSInteger ind = ([num integerValue]) / 10;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGrade:(NSInteger)num {
    NSInteger ind = (num - 50)/5;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSString*)getLetterGradePot:(NSInteger)num {
    NSInteger ind = num / 10;
    if (ind > 9) ind = 9;
    if (ind < 0) ind = 0;
    return [[self class] letterGrades][ind];
}

-(NSArray*)getDetailedStatsList:(NSInteger)games {
    return nil;
}

@end
