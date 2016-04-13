//
//  PlayerS.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerS.h"

@implementation PlayerS

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ratSCov = [aDecoder decodeIntForKey:@"ratSCov"];
        _ratSSpd = [aDecoder decodeIntForKey:@"ratSSpd"];
        _ratSTkl = [aDecoder decodeIntForKey:@"ratSTkl"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:_ratSCov forKey:@"ratSCov"];
    [aCoder encodeInt:_ratSSpd forKey:@"ratSSpd"];
    [aCoder encodeInt:_ratSTkl forKey:@"ratSTkl"];
}

-(instancetype)initWithName:(NSString*)name team:(Team*)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling {
    self = [super init];
    if (self) {
        self.team = team;
        self.name = name;
        self.year = year;
        self.ratOvr = (coverage * 2 + speed + tackling) / 4;
        self.ratPot = potential;
        self.ratFootIQ = iq;
        self.ratSCov = coverage;
        self.ratSSpd = speed;
        self.ratSTkl = tackling;
        self.position = @"S";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)", name, [self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratSCov)];
        [self.ratingsVector addObject:@(self.ratSSpd)];
        [self.ratingsVector addObject:@(self.ratSTkl)];
    }
    return self;
}

+(instancetype)newSWithName:(NSString *)name team:(Team *)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling {
    return [[PlayerS alloc] initWithName:name team:team year:year potential:potential iq:iq coverage:coverage speed:speed tackling:tackling];
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
        self.ratPot = (int)([HBSharedUtils randomValue]*50 + 50);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratSCov = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratSSpd = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratSTkl = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratSCov*2 + self.ratSSpd + self.ratSTkl)/4;
        self.position = @"S";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)", name, [self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratSCov)];
        [self.ratingsVector addObject:@(self.ratSSpd)];
        [self.ratingsVector addObject:@(self.ratSTkl)];
    }
    return self;
}

-(NSMutableArray*)getRatingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)", self.name, [self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratSCov)];
    [self.ratingsVector addObject:@(self.ratSSpd)];
    [self.ratingsVector addObject:@(self.ratSTkl)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratSCov += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratSSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratSTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        self.ratSCov += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        self.ratSSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        self.ratSTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
    }
    self.ratOvr = (self.ratSCov * 2 + self.ratSSpd + self.ratSTkl) / 4;
    self.ratImprovement = self.ratOvr - oldOvr;
    [super advanceSeason];
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.ratPot] forKey:@"sPotential"];
    [stats setObject:[self getLetterGrade:_ratSCov] forKey:@"sCoverage"];
    [stats setObject:[self getLetterGrade:_ratSSpd] forKey:@"sSpeed"];
    [stats setObject:[self getLetterGrade:_ratSTkl] forKey:@"sTackling"];
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[self getLetterGrade:_ratSCov] forKey:@"sCoverage"];
    [stats setObject:[self getLetterGrade:_ratSSpd] forKey:@"sSpeed"];
    [stats setObject:[self getLetterGrade:_ratSTkl] forKey:@"sTackling"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}


@end
