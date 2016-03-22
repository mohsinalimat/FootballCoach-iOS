//
//  PlayerOL.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerOL.h"

@implementation PlayerOL

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _ratOLPow = [aDecoder decodeIntForKey:@"ratOLPow"];
        _ratOLBkR = [aDecoder decodeIntForKey:@"ratOLBkR"];
        _ratOLBkP = [aDecoder decodeIntForKey:@"ratOLBkP"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:_ratOLPow forKey:@"ratOLPow"];
    [aCoder encodeInt:_ratOLBkR forKey:@"ratOLBkR"];
    [aCoder encodeInt:_ratOLBkP forKey:@"ratOLBkP"];
}

-(instancetype)initWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass {
    self = [super init];
    if (self) {
        self.team = t;
        self.name = nm;
        self.year = yr;
        self.ratOvr = (pow*3 + rsh + pass)/5;
        self.ratPot = pot;
        self.ratFootIQ = iq;
        _ratOLPow = pow;
        _ratOLBkR = rsh;
        _ratOLBkP = pass;
        
        self.cost = (int)(powf((float)self.ratOvr/6,2.0)) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratOLPow)];
        [self.ratingsVector addObject:@(self.ratOLBkR)];
        [self.ratingsVector addObject:@(self.ratOLBkP)];
        
        
        
        self.position = @"OL";
    }
    return self;
}

-(instancetype)initWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    self = [super init];
    if (self) {
        self.name = nm;
        self.year = yr;
        self.team = t;
        self.ratPot = (int) (50 + 50* [HBSharedUtils randomValue]);
        self.ratFootIQ = (int) (50 + stars*4 + 30* [HBSharedUtils randomValue]);
        _ratOLPow = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratOLBkR = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        _ratOLBkP = (int) (60 + self.year*5 + stars*5 - 25* [HBSharedUtils randomValue]);
        self.ratOvr = (_ratOLPow*3 + _ratOLBkR + _ratOLBkP)/5;
        
        self.cost = (int)pow((float)self.ratOvr/6,2) + (int)([HBSharedUtils randomValue]*100) - 50;
        
        self.ratingsVector = [NSMutableArray array];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
        [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
        [self.ratingsVector addObject:@(self.ratPot)];
        [self.ratingsVector addObject:@(self.ratFootIQ)];
        [self.ratingsVector addObject:@(self.ratOLPow)];
        [self.ratingsVector addObject:@(self.ratOLBkR)];
        [self.ratingsVector addObject:@(self.ratOLBkP)];
        
        
        self.position = @"OL";
    }
    return self;
}

+(instancetype)newOLWithName:(NSString *)nm team:(Team *)t year:(int)yr potential:(int)pot footballIQ:(int)iq power:(int)pow rush:(int)rsh pass:(int)pass {
    return [[PlayerOL alloc] initWithName:nm team:t year:yr potential:pot footballIQ:iq power:pow rush:rsh pass:pass];
}

+(instancetype)newOLWithName:(NSString*)nm year:(int)yr stars:(int)stars team:(Team*)t {
    return [[PlayerOL alloc] initWithName:nm year:yr stars:stars team:t];
}

-(NSMutableArray*)getRatingsVector {
    self.ratingsVector = [NSMutableArray array];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%@ (%@)",self.name,[self getYearString]]];
    [self.ratingsVector addObject:[NSString stringWithFormat:@"%ld (%ld)",(long)self.ratOvr,(long)self.ratImprovement]];
    [self.ratingsVector addObject:@(self.ratPot)];
    [self.ratingsVector addObject:@(self.ratFootIQ)];
    [self.ratingsVector addObject:@(self.ratOLPow)];
    [self.ratingsVector addObject:@(self.ratOLBkR)];
    [self.ratingsVector addObject:@(self.ratOLBkP)];
    return self.ratingsVector;
}

-(void)advanceSeason {
    self.year++;
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratOLPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratOLBkR += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    _ratOLBkP += (int)([HBSharedUtils randomValue]*(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        _ratOLPow += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        _ratOLBkR += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
        _ratOLBkP += (int)([HBSharedUtils randomValue]*(self.ratPot - 30))/10;
    }
    
    self.ratOvr = (_ratOLPow*3 + _ratOLBkR + _ratOLBkP)/5;
    self.ratImprovement = self.ratOvr - oldOvr;
}

-(NSDictionary*)detailedStats:(int)games {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[NSString stringWithFormat:@"%d",self.ratPot] forKey:@"olPotential"];
    [stats setObject:[self getLetterGrade:_ratOLPow] forKey:@"olPower"];
    [stats setObject:[self getLetterGrade:_ratOLBkR] forKey:@"olRunBlock"];
    [stats setObject:[self getLetterGrade:_ratOLBkP] forKey:@"olPassBlock"];
    
    return [stats copy];
}

-(NSDictionary*)detailedRatings {
    NSMutableDictionary *stats = [NSMutableDictionary dictionary];
    [stats setObject:[self getLetterGrade:_ratOLPow] forKey:@"olPower"];
    [stats setObject:[self getLetterGrade:_ratOLBkR] forKey:@"olRunBlock"];
    [stats setObject:[self getLetterGrade:_ratOLBkP] forKey:@"olPassBlock"];
    
    return [stats copy];
}


@end
