//
//  RecruitingPeriodViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/28/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"

#import "RecruitingActionsViewController.h"

@interface RecruitingPeriodViewController : FCTableViewController <RecruitingActionsDelegate>
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *signedRecruitRanks;
@property (strong, nonatomic) NSMutableArray<Player *>* progressedRecruits;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *recruitActivities;
@property (nonatomic) int recruitingPoints;
@property (nonatomic) int usedRecruitingPoints;
@end

