//
//  RankingsViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"

typedef NS_ENUM(NSUInteger, HBStatType) {
    HBStatTypePollScore,
    HBStatTypeOffTalent,
    HBStatTypeDefTalent,
    HBStatTypeTeamPrestige,
    HBStatTypeSOS,
    HBStatTypePPG,
    HBStatTypeOppPPG,
    HBStatTypeYPG,
    HBStatTypeOppYPG,
    HBStatTypePYPG,
    HBStatTypeRYPG,
    HBStatTypeOppPYPG,
    HBStatTypeOppRYPG,
    HBStatTypeTODiff,
    HBStatTypeAllTimeWins,
    HBStatTypeRecruitingScore,
    HBStatTypeAllTimeNCGs,
    HBStatTypeAllTimeCCGs
};

@interface RankingsViewController : FCTableViewController
-(instancetype)initWithStatType:(HBStatType)statType;
@end
