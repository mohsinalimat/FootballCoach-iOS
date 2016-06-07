//
//  Injury.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 6/6/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AutoCoding.h"

@class Player;

typedef enum { //percentages based on https://www.ncaa.org/sites/default/files/NCAA_Football_Injury_WEB.pdf
    FCInjuryTypeConcussion, //7.4% -> 8%
    FCInjuryTypeHead, //4.3% -> 4%
    FCInjuryTypeUpperBody, //16.9% -> 17%
    FCInjuryTypeTorso, //11.9% -> 12%
    FCInjuryTypeLowerBody, //50.4% -> 50%
    FCInjuryTypeIllness //9.1% -> 9%
} FCInjuryType;

typedef enum {
    FCInjurySeverityLow, //49% (1-6 days)
    FCInjurySeverityMild, //31.0% -> 31% (7-20 days)
    FCInjurySeveritySevere //19.5% -> 20% (21+ days)
} FCInjurySeverity;

@interface Injury : NSObject <NSCoding>
@property (nonatomic) FCInjuryType type;
@property (nonatomic) int duration; //number of weeks out
@property (nonatomic) FCInjurySeverity severity;
- (NSString *)injuryDescription;
- (void)advanceWeek;
+ (instancetype)newInjury;
@end
