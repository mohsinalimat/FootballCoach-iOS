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
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:_ratCBCov forKey:@"ratCBCov"];
    [aCoder encodeInt:_ratCBSpd forKey:@"ratCBSpd"];
    [aCoder encodeInt:_ratCBTkl forKey:@"ratCBTkl"];
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
        self.ratCBCov = coverage;
        self.ratCBSpd = speed;
        self.ratCBTkl = tackling;
        self.position = @"CB";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)", name, [self getYearString]]];
        //[self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratCBCov)];
        [self.ratingsVector addObject:@(self.ratCBSpd)];
        [self.ratingsVector addObject:@(self.ratCBTkl)];
    }
    return self;
}

+(instancetype)newCBWithName:(NSString *)name team:(Team *)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling {
    return [[PlayerCB alloc] initWithName:name team:team year:year potential:potential iq:iq coverage:coverage speed:speed tackling:tackling];
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
        self.ratPot = (int)([HBSharedUtils randomValue]*50 + 50);
        self.ratFootIQ = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratCBCov = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratCBSpd = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratCBTkl = (int) (60 + year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (self.ratCBCov*2 + self.ratCBSpd + self.ratCBTkl)/4;
        self.position = @"CB";
        self.cost = pow(self.ratOvr / 6, 2) + ([HBSharedUtils randomValue] * 100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)", name, [self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratCBCov)];
        [self.ratingsVector addObject:@(self.ratCBSpd)];
        [self.ratingsVector addObject:@(self.ratCBTkl)];
    }
    return self;
}

-(NSMutableArray*)getRatingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)", self.name, [self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratCBCov)];
    [self.ratingsVector addObject:@(self.ratCBSpd)];
    [self.ratingsVector addObject:@(self.ratCBTkl)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratCBCov += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratCBSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    self.ratCBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        self.ratCBCov += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        self.ratCBSpd += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        self.ratCBTkl += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
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
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[self getLetterGrade:_ratCBCov] forKey:@"cbCoverage"];
    [stats setObject:[self getLetterGrade:_ratCBSpd] forKey:@"cbSpeed"];
    [stats setObject:[self getLetterGrade:_ratCBTkl] forKey:@"cbTackling"];
    [stats setObject:[self getLetterGrade:self.ratFootIQ] forKey:@"footballIQ"];
    return [stats copy];
}

@end
