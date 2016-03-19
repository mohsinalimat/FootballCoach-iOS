//
//  PlayerCB.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerCB.h"

@implementation PlayerCB

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
        self.cost = pow(self.ratOvr / 6, 2) + (arc4random() % 100) - 50;
        
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

+(instancetype)newCBWithName:(NSString *)name team:(Team *)team year:(int)year potential:(int)potential iq:(int)iq coverage:(int)coverage speed:(int)speed tackling:(int)tackling {
    return [[PlayerCB alloc] initWithName:name team:team year:year potential:potential iq:iq coverage:coverage speed:speed tackling:tackling];
}

+(instancetype)newCBWithName:(NSString *)name year:(int)year stars:(int)stars {
    return [[PlayerCB alloc] initWithName:name year:year stars:stars];
}

-(instancetype)initWithName:(NSString*)name year:(int)year stars:(int)stars {
    self = [super init];
    if(self) {
        self.name = name;
        self.year = year;
        self.ratPot = (int)(arc4random()%50 + 50);
        self.ratFootIQ = (int) (50 + stars*4 + 30*arc4random());
        self.ratCBCov = (int) (60 + year*5 + stars*5 - 25*arc4random());
        self.ratCBSpd = (int) (60 + year*5 + stars*5 - 25*arc4random());
        self.ratCBTkl = (int) (60 + year*5 + stars*5 - 25*arc4random());
        self.position = @"CB";
        self.cost = pow(self.ratOvr / 6, 2) + (arc4random() % 100) - 50;
        
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
    self.year++;
    int oldOvr = self.ratOvr;
    self.ratFootIQ += (int)(arc4random()%(self.ratPot - 25))/10;
    self.ratCBCov += (int)(arc4random()%(self.ratPot - 25))/10;
    self.ratCBSpd += (int)(arc4random()%(self.ratPot - 25))/10;
    self.ratCBTkl += (int)(arc4random()%(self.ratPot - 25))/10;
    if ([HBSharedUtils randomValue]*100 < self.ratPot ) {
        //breakthrough
        self.ratCBCov += (int)(arc4random()%(self.ratPot - 30))/10;
        self.ratCBSpd += (int)(arc4random()%(self.ratPot - 30))/10;
        self.ratCBTkl += (int)(arc4random()%(self.ratPot - 30))/10;
    }
    self.ratOvr = (self.ratCBCov * 2 + self.ratCBSpd + self.ratCBTkl) / 4;
    self.ratImprovement = self.ratOvr - oldOvr;
}

-(NSArray*)getDetailedStatsList:(int)games {
    NSMutableArray *pStats = [NSMutableArray array];
    [pStats addObject:[NSString stringWithFormat:@"Potential: %ld>Coverage: %@",(long)self.ratPot,[self getLetterGrade:self.ratCBCov]]];
    [pStats addObject:[NSString stringWithFormat:@"Speed: %@>Tackling: %@",[self getLetterGrade:self.ratCBSpd],[self getLetterGrade:self.ratCBTkl]]];
    return [pStats copy];
}

@end
