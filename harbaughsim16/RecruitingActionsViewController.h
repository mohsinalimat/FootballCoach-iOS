//
//  RecruitingActionsViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/15/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"
@class Player;


@interface RecruitingActionsViewController : FCTableViewController
@property (nonatomic) id delegate;
-(instancetype)initWithRecruit:(Player *)p events:(NSArray *)events;

@end

@protocol RecruitingActionsDelegate
@required
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *signedRecruitRanks;
@property (strong, nonatomic) NSMutableArray<Player *>* progressedRecruits;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *recruitActivities;
@property (nonatomic) int recruitingPoints;
@property (nonatomic) int usedRecruitingPoints;
-(void)recruitingActionsController:(RecruitingActionsViewController *)actionsController didUpdateRecruit:(Player *)recruit withEvent:(CFCRecruitEvent)event;
@end

