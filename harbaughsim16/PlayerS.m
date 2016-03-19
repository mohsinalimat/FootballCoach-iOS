//
//  PlayerS.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerS.h"

@implementation PlayerS
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
        self.cost = pow(self.ratOvr / 6, 2) + (arc4random() % 100) - 50;
        
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

+(instancetype)newSWithName:(NSString *)name year:(int)year stars:(int)stars {
    return [[PlayerS alloc] initWithName:name year:year stars:stars];
}

-(instancetype)initWithName:(NSString*)name year:(int)year stars:(int)stars {
    self = [super init];
    if(self) {
        self.name = name;
        self.year = year;
        self.ratPot = (int)(arc4random()%50 + 50);
        self.ratFootIQ = (int) (50 + stars*4 + 30*arc4random());
        self.ratSCov = (int) (60 + year*5 + stars*5 - 25*arc4random());
        self.ratSSpd = (int) (60 + year*5 + stars*5 - 25*arc4random());
        self.ratSTkl = (int) (60 + year*5 + stars*5 - 25*arc4random());
        self.position = @"S";
        self.cost = pow(self.ratOvr / 6, 2) + (arc4random() % 100) - 50;
        
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
    self.year++;
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)(arc4random()%(self.ratPot - 25))/10;
    self.ratSCov += (int)(arc4random()%(self.ratPot - 25))/10;
    self.ratSSpd += (int)(arc4random()%(self.ratPot - 25))/10;
    self.ratSTkl += (int)(arc4random()%(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        self.ratSCov += (int)(arc4random()%(self.ratPot - 30))/10;
        self.ratSSpd += (int)(arc4random()%(self.ratPot - 30))/10;
        self.ratSTkl += (int)(arc4random()%(self.ratPot - 30))/10;
    }
    self.ratOvr = (self.ratSCov * 2 + self.ratSSpd + self.ratSTkl) / 4;
    self.ratImprovement = self.ratOvr - oldOvr;
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
    
    return [stats copy];
}


@end
