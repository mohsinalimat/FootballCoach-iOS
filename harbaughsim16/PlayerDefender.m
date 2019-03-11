//
//  PlayerDefender.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/11/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "PlayerDefender.h"

@implementation PlayerDefender
@synthesize statsTkl,statsForcedFum,statsPassDef,statsSacks,statsInt,careerStatsInt,careerStatsTkl,careerStatsSacks,careerStatsPassDef,careerStatsForcedFum;

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.statsTkl = [aDecoder decodeIntForKey:@"statsTkl"];
        self.statsForcedFum = [aDecoder decodeIntForKey:@"statsForcedFum"];
        self.statsPassDef = [aDecoder decodeIntForKey:@"statsPassDef"];
        self.statsSacks = [aDecoder decodeIntForKey:@"statsSacks"];
        self.statsInt = [aDecoder decodeIntForKey:@"statsInt"];
        
        self.careerStatsTkl = [aDecoder decodeIntForKey:@"careerStatsTkl"];
        self.careerStatsSacks = [aDecoder decodeIntForKey:@"careerStatsSacks"];
        self.careerStatsPassDef = [aDecoder decodeIntForKey:@"careerStatsPassDef"];
        self.careerStatsForcedFum = [aDecoder decodeIntForKey:@"careerStatsForcedFum"];
        self.careerStatsInt = [aDecoder decodeIntForKey:@"careerStatsInt"];
        
//        if ([aDecoder containsValueForKey:@"personalDetails"]) {
//            self.personalDetails = [aDecoder decodeObjectForKey:@"personalDetails"];
//            if (self.personalDetails == nil) {
//                NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 170;
//                NSInteger inches = (int)([HBSharedUtils randomValue] * 3);
//                self.personalDetails = @{
//                                         @"home_state" : [HBSharedUtils randomState],
//                                         @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
//                                         @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
//                                         };
//            }
//        } else {
//            NSInteger weight = (int)([HBSharedUtils randomValue] * 25) + 170;
//            NSInteger inches = (int)([HBSharedUtils randomValue] * 3);
//            self.personalDetails = @{
//                                     @"home_state" : [HBSharedUtils randomState],
//                                     @"height" : [NSString stringWithFormat:@"6\'%ld\"",(long)inches],
//                                     @"weight" : [NSString stringWithFormat:@"%ld lbs", (long)weight]
//                                     };
//        }
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeInt:self.statsTkl forKey:@"statsTkl"];
    [aCoder encodeInt:self.statsForcedFum forKey:@"statsForcedFum"];
    [aCoder encodeInt:self.statsPassDef forKey:@"statsPassDef"];
    [aCoder encodeInt:self.statsSacks forKey:@"statsSacks"];
    [aCoder encodeInt:self.statsInt forKey:@"statsInt"];
    
    [aCoder encodeInt:self.careerStatsForcedFum forKey:@"careerStatsForcedFum"];
    [aCoder encodeInt:self.careerStatsPassDef forKey:@"careerStatsPassDef"];
    [aCoder encodeInt:self.careerStatsSacks forKey:@"careerStatsSacks"];
    [aCoder encodeInt:self.careerStatsInt forKey:@"careerStatsInt"];
    [aCoder encodeInt:self.careerStatsTkl forKey:@"careerStatsTkl"];
    
//    [aCoder encodeObject:self.personalDetails forKey:@"personalDetails"];
}


-(int)getHeismanScore {
    return (self.statsTkl * 25 + self.statsSacks * 425 + self.statsForcedFum * 425 + self.statsInt * 425) * 0.65; // lower bc defenders don't win awards :/
}
@end
