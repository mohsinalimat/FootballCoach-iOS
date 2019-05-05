//
//  PlayerStatsViewController.h
//  profootballcoach
//
//  Created by Akshay Easwaran on 3/17/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"
typedef NS_ENUM(NSUInteger, HBStatPosition) {
    HBStatPositionQB,
    HBStatPositionRB,
    HBStatPositionWR,
    HBStatPositionDEF,
    HBStatPositionK,
    HBStatPositionHC
};

typedef NS_ENUM(NSUInteger, FCHeadCoachStat) {
    FCHeadCoachStatNatlChamps,
    FCHeadCoachStatConfChamps,
    FCHeadCoachStatBowlWins,
    FCHeadCoachStatRivalryWins,
    FCHeadCoachStatTotalWins,
    FCHeadCoachStatCOTYs,
    FCHeadCoachStatConfCOTYs,
    FCHeadCoachStatPlayersDrafted,
    FCHeadCoachStatAllConfPlayersCoached,
    FCHeadCoachStatAllLeaguePlayersCoached,
    FCHeadCoachStatPOTYsCoached,
    FCHeadCoachStatROTYsCoached
};

@interface PlayerStatsViewController : FCTableViewController
-(instancetype)initWithStatType:(HBStatPosition)type;
@end
