//
//  PlayerDefender.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/11/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "Player.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlayerDefender : Player
@property (nonatomic) int statsTkl;
@property (nonatomic) int statsForcedFum;
@property (nonatomic) int statsPassDef;
@property (nonatomic) int statsInt;
@property (nonatomic) int statsSacks;

@property (nonatomic) int careerStatsTkl;
@property (nonatomic) int careerStatsForcedFum;
@property (nonatomic) int careerStatsPassDef;
@property (nonatomic) int careerStatsInt;
@property (nonatomic) int careerStatsSacks;
@end

NS_ASSUME_NONNULL_END
