//
//  Injury.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 6/6/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "Injury.h"
#import "HBSharedUtils.h"
#import "Player.h"

@implementation Injury

+ (instancetype)newInjury {
    return [[Injury alloc] init];
}

- (id)init {
    if (self = [super init]) {
        int t = (int)([HBSharedUtils randomValue] * 100.0);
        if (t < 8) {
            _type = FCInjuryTypeConcussion;
        } else if (t < 12) {
            _type = FCInjuryTypeHead;
        } else if (t < 29) {
            _type = FCInjuryTypeUpperBody;
        } else if (t < 41) {
            _type = FCInjuryTypeTorso;
        } else if (t < 91) {
            _type = FCInjuryTypeLowerBody;
        } else {
            _type = FCInjuryTypeIllness;
        }
        
        if (_type == FCInjuryTypeIllness) {
            _severity = FCInjurySeverityLow;
            _duration = 1;
        } else {
            int s = (int)([HBSharedUtils randomValue] * 100.0);
            if (s < 49) {
                _severity = FCInjurySeverityLow;
                _duration = 1;
            } else if (s < 80) {
                _severity = FCInjurySeveritySevere;
                _duration = ((int)([HBSharedUtils randomValue] * 2)) + 1;
            } else {
                _severity = FCInjurySeveritySevere;
                _duration = ((int)([HBSharedUtils randomValue] * 12)) + 3;
            }
        }
        
    }
    return self;
}

- (NSString *)injuryDescription {
    if (_duration > 1) {
        if (_duration + [HBSharedUtils getLeague].currentWeek > 15) {
            if (_type != FCInjuryTypeConcussion && _type != FCInjuryTypeIllness) {
                return [NSString stringWithFormat:@"%@ %@ injury - out for season",[Injury stringForInjurySeverity:_severity], [Injury stringForInjuryType:_type]];
            } else {
                return [NSString stringWithFormat:@"%@ %@ - out for season",[Injury stringForInjurySeverity:_severity], [Injury stringForInjuryType:_type]];
            }
        } else {
            if (_type != FCInjuryTypeConcussion && _type != FCInjuryTypeIllness) {
                return [NSString stringWithFormat:@"%@ %@ injury - out %li weeks",[Injury stringForInjurySeverity:_severity], [Injury stringForInjuryType:_type], (long)_duration];
            } else {
                return [NSString stringWithFormat:@"%@ %@ - out %li weeks",[Injury stringForInjurySeverity:_severity], [Injury stringForInjuryType:_type], (long)_duration];
            }
        }
    } else {
        if (_type != FCInjuryTypeConcussion && _type != FCInjuryTypeIllness) {
            return [NSString stringWithFormat:@"%@ %@ injury - out 1 week",[Injury stringForInjurySeverity:_severity], [Injury stringForInjuryType:_type]];
        } else {
            return [NSString stringWithFormat:@"%@ %@ - out 1 week",[Injury stringForInjurySeverity:_severity], [Injury stringForInjuryType:_type]];
        }
    }
}

+ (NSString *)stringForInjuryType:(FCInjuryType)t {
    NSString *result;
    int i = [HBSharedUtils randomValue] * 10;
    switch (t) {
        case FCInjuryTypeConcussion:
            result = @"concussion";
            break;
        case FCInjuryTypeHead:
            if (i < 5) {
                result = @"head";
            } else {
                result = @"neck";
            }
            break;
        case FCInjuryTypeTorso:
            if (i < 4) {
                result = @"torso";
            } else if (i < 7) {
                result = @"pelvis";
            } else {
                result = @"back";
            }
            break;
        case FCInjuryTypeLowerBody:
            if (i < 1) {
                result = @"Achilles";
            } else if (i < 3) {
                result = @"leg";
            } else if (i < 5) {
                result = @"ankle";
            } else {
                result = @"knee";
            }
            break;
        case FCInjuryTypeIllness:
            result = @"illness";
            break;
        case FCInjuryTypeUpperBody:
            if (i < 1) {
                result = @"wrist";
            } else if (i < 3) {
                result = @"hand";
            } else if (i < 5) {
                result = @"arm";
            } else {
                result = @"shoulder";
            }
            break;
        default:
            break;
    }
    return result;
}

+ (NSString *)stringForInjurySeverity:(FCInjurySeverity)s {
    NSString *result;
    switch (s) {
        case FCInjurySeverityLow:
            result = @"Minor";
            break;
        case FCInjurySeverityMild:
            result = @"Mild";
            break;
        case FCInjurySeveritySevere:
            result = @"Severe";
            break;
        default:
            break;
    }
    return result;
}

- (void)advanceWeek {
    int curWeek = [HBSharedUtils getLeague].currentWeek;
    if (curWeek <= 13) {
        _duration--;
    } else if (curWeek == 14) {
        _duration = _duration - 2;
    } else {
        _duration--;
    }
}

@end
