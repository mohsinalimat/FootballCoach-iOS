//
//  RecruitingPeriodViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/28/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "RecruitingPeriodViewController.h"
#import "League.h"
#import "Team.h"
#import "TeamRosterViewController.h"

#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerDL.h"
#import "PlayerTE.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "CFCRecruitCell.h"

#import "STPopup.h"
#import "HexColors.h"
@import ScrollableSegmentedControl;
#import "MBProgressHUD.h"

@interface RecruitingPeriodViewController ()
{
    ScrollableSegmentedControl *positionSelectionControl;
    NSMutableArray *totalRecruits;
    NSMutableArray *currentRecruits;
    NSMutableArray *progressedRecruits;
    
    NSMutableArray<Player*>* availQBs;
    NSMutableArray<Player*>* availRBs;
    NSMutableArray<Player*>* availWRs;
    NSMutableArray<Player*>* availTEs;
    NSMutableArray<Player*>* availOLs;
    NSMutableArray<Player*>* availKs;
    NSMutableArray<Player*>* availSs;
    NSMutableArray<Player*>* availCBs;
    NSMutableArray<Player*>* availLBs;
    NSMutableArray<Player*>* availDLs;
    
    NSInteger needQBs;
    NSInteger needRBs;
    NSInteger needWRs;
    NSInteger needTEs;
    NSInteger needOLs;
    NSInteger needKs;
    NSInteger needsS;
    NSInteger needCBs;
    NSInteger needLBs;
    NSInteger needDLs;
    
    int recruitingPoints;
}
@end

@implementation RecruitingPeriodViewController

-(void)reloadRecruits {
    [totalRecruits removeAllObjects];
    
    [availQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    
    [availRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    [availWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    [availTEs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    [availOLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    [availDLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    
    [availLBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    
    [availCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    [availSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    [availKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    
    [totalRecruits addObjectsFromArray:availQBs];
    [totalRecruits addObjectsFromArray:availRBs];
    [totalRecruits addObjectsFromArray:availWRs];
    [totalRecruits addObjectsFromArray:availTEs];
    [totalRecruits addObjectsFromArray:availOLs];
    [totalRecruits addObjectsFromArray:availDLs];
    [totalRecruits addObjectsFromArray:availLBs];
    [totalRecruits addObjectsFromArray:availCBs];
    [totalRecruits addObjectsFromArray:availSs];
    [totalRecruits addObjectsFromArray:availKs];
    
    [totalRecruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    
//    if (_filteredByCost) {
//        [self filterByCost];
//    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
//
//
//    self.title = [NSString stringWithFormat:@"Budget: $%d",recruitingBudget];
}


-(void)selectPosition:(ScrollableSegmentedControl *)sender {
    NSLog(@"POSITION %lu SELECTED", sender.selectedSegmentIndex);
    switch (sender.selectedSegmentIndex) {
        case 0:
            currentRecruits = totalRecruits;
            break;
        case 1:
            currentRecruits = availQBs;
            break;
        case 2:
            currentRecruits = availRBs;
            break;
        case 3:
            currentRecruits = availWRs;
            break;
        case 4:
            currentRecruits = availTEs;
            break;
        case 5:
            currentRecruits = availOLs;
            break;
        case 6:
            currentRecruits = availDLs;
            break;
        case 7:
            currentRecruits = availLBs;
            break;
        case 8:
            currentRecruits = availCBs;
            break;
        case 9:
            currentRecruits = availSs;
            break;
        case 10:
            currentRecruits = availKs;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    positionSelectionControl = [[ScrollableSegmentedControl alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    positionSelectionControl.segmentStyle = ScrollableSegmentedControlSegmentStyleTextOnly;
    positionSelectionControl.underlineSelected = YES;
    positionSelectionControl.selectedSegmentContentColor = [HBSharedUtils styleColor];
    positionSelectionControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FFFFFF" alpha:0.85];
    [positionSelectionControl insertSegmentWithTitle:@"ALL" at:0];
    [positionSelectionControl insertSegmentWithTitle:@"QB" at:1];
    [positionSelectionControl insertSegmentWithTitle:@"RB" at:2];
    [positionSelectionControl insertSegmentWithTitle:@"WR" at:3];
    [positionSelectionControl insertSegmentWithTitle:@"TE" at:4];
    [positionSelectionControl insertSegmentWithTitle:@"OL" at:5];
    [positionSelectionControl insertSegmentWithTitle:@"DL" at:6];
    [positionSelectionControl insertSegmentWithTitle:@"LB" at:7];
    [positionSelectionControl insertSegmentWithTitle:@"CB" at:8];
    [positionSelectionControl insertSegmentWithTitle:@"S" at:9];
    [positionSelectionControl insertSegmentWithTitle:@"K" at:10];
    [positionSelectionControl addTarget:self action:@selector(selectPosition:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.view addSubview:positionSelectionControl];
    [self.tableView setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];

    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = 140;
    [self.tableView registerNib:[UINib nibWithNibName:@"CFCRecruitCell" bundle:nil] forCellReuseIdentifier:@"CFCRecruitCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Advance" style:UIBarButtonItemStylePlain target:self action:@selector(advancePeriods)];
    
    // calculate recruiting points, but never show number - just show as usage as "% effort extended"
    recruitingPoints = ([HBSharedUtils getLeague].isHardMode) ? [HBSharedUtils getLeague].userTeam.teamPrestige * 20 : [HBSharedUtils getLeague].userTeam.teamPrestige * 25;

    NSInteger recruitingBonus = (20 * (48 - [[HBSharedUtils getLeague].userTeam getTeamSize]));
    if (recruitingBonus > 0) {
        recruitingPoints += recruitingBonus;
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"Budget: %d pts", recruitingPoints];
    
    // note bonus
    currentRecruits = [NSMutableArray array];
    progressedRecruits = [NSMutableArray array];
    
    totalRecruits = [NSMutableArray array];
    availQBs = [NSMutableArray array];
    availRBs = [NSMutableArray array];
    availWRs = [NSMutableArray array];
    availTEs = [NSMutableArray array];
    availOLs = [NSMutableArray array];
    availKs = [NSMutableArray array];
    availSs = [NSMutableArray array];
    availCBs = [NSMutableArray array];
    availDLs = [NSMutableArray array];
    availLBs = [NSMutableArray array];

    // generate recruits the same way as before
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud.label setText:@"Generating recruits..."];
    int position = 0;
    for (int i = 0; i < 24; i++) {
        position = (int)([HBSharedUtils randomValue] * 10);
        if (position < 0) {
            position = 0;
        }
        
        if (position > 9) {
            position = 9;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        }
    }
    
    for (int i = 0; i < 120; i++) {
        position = (int)([HBSharedUtils randomValue] * 10) - 1;
        if (position < 0) {
            position = 0;
        }
        
        if (position > 9) {
            position = 9;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        }
    }
    
    for (int i = 0; i < 120; i++) {
        position = (int)([HBSharedUtils randomValue] * 10) - 1;
        if (position < 0) {
            position = 0;
        }
        
        if (position > 9) {
            position = 9;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    for (int i = 0; i < 42; i++) {
        position = (int)([HBSharedUtils randomValue] * 10) - 1;
        if (position < 0) {
            position = 0;
        }
        
        if (position > 9) {
            position = 9;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        }
    }
    
    for (int i = 0; i < 9; i++) {
        position = (int)([HBSharedUtils randomValue] * 10) - 1;
        if (position < 0) {
            position = 0;
        }
        
        if (position > 9) {
            position = 9;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        }
    }
    
    if (availQBs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availRBs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availWRs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availTEs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availOLs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availDLs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availLBs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availCBs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availSs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availKs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    [totalRecruits addObjectsFromArray:availQBs];
    [totalRecruits addObjectsFromArray:availRBs];
    [totalRecruits addObjectsFromArray:availWRs];
    [totalRecruits addObjectsFromArray:availTEs];
    [totalRecruits addObjectsFromArray:availOLs];
    [totalRecruits addObjectsFromArray:availDLs];
    [totalRecruits addObjectsFromArray:availLBs];
    [totalRecruits addObjectsFromArray:availCBs];
    [totalRecruits addObjectsFromArray:availSs];
    [totalRecruits addObjectsFromArray:availKs];
    
    [totalRecruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    
    [hud.label setText:@"Generating offers from other teams..."];
    __block NSArray *teamList = [HBSharedUtils getLeague].teamList;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableDictionary *teamNeeds = [NSMutableDictionary dictionary];
        for (Team *t in teamList) {
            if (!t.isUserControlled) {
                [teamNeeds setObject:@(48 - [t getTeamSize]) forKey:t.abbreviation];
            }
        }
        
        
        // generate offers from other teams
        for (Player *p in totalRecruits) {
            NSMutableDictionary *prelimOffers = [NSMutableDictionary dictionary];
            for (Team *t in teamList) {
                if (!t.isUserControlled) {
                    int interest = [p calculateInterestInTeam:t];
                    [prelimOffers setObject:@(interest) forKey:t.abbreviation];
                }
            }
            
            NSArray *sortedOffers = [prelimOffers keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj2 compare:obj1];
            }];
            
            NSMutableDictionary *highestOffers  = [NSMutableDictionary dictionary];
            int offers = 0;
            int i = 0;
            while (offers < 3) {
                NSString *abbrev = sortedOffers[i];
                NSNumber *teamOffers = teamNeeds[abbrev];
                if (teamOffers > 0) {
                    [highestOffers setObject:prelimOffers[abbrev] forKey:abbrev];
                    [teamNeeds setObject:[NSNumber numberWithInt:teamOffers.intValue - 1] forKey:sortedOffers[i]];
                    offers++;
                } else {
                    NSLog(@"%@ has hit offer cap, can not send more offers", abbrev);
                }
                i++;
            }
            
            p.offers = highestOffers;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [positionSelectionControl setSelectedSegmentIndex:0];
            [self.tableView reloadData];
        });
    });
}

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)advancePeriods {
    // Basically advancing to results
    // need to run recruiting for other teams:
    //      1. from offers for recruit, calculate interest and sign with highest-interest team
    //      2. if highest-interest team is user team, then:
    //          * color name
    //          * change status to committed
    //      3. if highest-interest team is NOT user team. then:
    //          * if interest was mild or medium, then:
    //              * offer to flip (for large amount of recruiting points)
    //          * else:
    //              * fade name
    
}

-(NSString *)generateOfferString:(NSDictionary *)offers {
    NSMutableString *offerString = [NSMutableString string];
    NSArray *sortedOffers = [offers keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    for (NSString *offer in sortedOffers) {
        [offerString appendFormat:@"%@, ",offer];
    }
    offerString = [NSMutableString stringWithString:[[offerString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]]];
    
    return offerString;
}

-(NSDictionary *)generateInterestMetadata:(int)interestVal otherOffers:(NSDictionary *)offers {
    NSMutableDictionary *totalOffers = [NSMutableDictionary dictionaryWithDictionary:offers];
    [totalOffers setObject:@(interestVal) forKey:[HBSharedUtils getLeague].userTeam.abbreviation];
    NSArray *sortedOffers = [totalOffers keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    NSInteger offIdx = [sortedOffers indexOfObject:[HBSharedUtils getLeague].userTeam.abbreviation];
    
    UIColor *letterColor = [UIColor lightGrayColor];
    NSString *interestString = @"LOW";
    if (offIdx == 0) {
        letterColor = [HBSharedUtils successColor];
        interestString = @"LOCK";
    } else if (offIdx == 1) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
        interestString = @"HIGH";
    } else if (offIdx == 2) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
        interestString = @"MEDIUM";
    } else {
        letterColor = [UIColor lightGrayColor];
        interestString = @"LOW";
    }

    return @{@"color" : letterColor, @"interest" : interestString};
    
}

-(NSString *)convertStarsToUIImageName:(int)stars {
    switch (stars) {
        case 2:
            return @"2stars";
            break;
        case 3:
            return @"3stars";
            break;
        case 4:
            return @"4stars";
            break;
        case 5:
            return @"5stars";
            break;
        default:
            return @"1star";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self setToolbarItems:@[
                            [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"roster"] style:UIBarButtonItemStylePlain target:self action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithTitle:@"View Needs" style:UIBarButtonItemStylePlain target:self action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:nil]
                            ]
     ];
    self.navigationController.toolbarHidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentRecruits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CFCRecruitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFCRecruitCell"];
    Player *p = currentRecruits[indexPath.row];
    int interest = [p calculateInterestInTeam:[HBSharedUtils getLeague].userTeam];
    int stars = p.stars;
    //NSLog(@"%@'s OVR: %d stars: %d interest: %d offers: %@", p.name, p.ratOvr, stars, interest, p.offers);
    NSString *name = p.name;
    NSString *position = p.position;
    NSString *state = p.personalDetails[@"home_state"];
    NSString *height = p.personalDetails[@"height"];
    NSString *weight = p.personalDetails[@"weight"];
    NSString *fortyTime = p.fortyYardDashTime;
    NSString *overall;
    if (positionSelectionControl.selectedSegmentIndex == 0) {
        overall = [NSString stringWithFormat:@"#%lu overall", (indexPath.row + 1)];
    } else {
        overall = [NSString stringWithFormat:@"#%lu %@", (indexPath.row + 1), position];
    }
    
    NSDictionary *interestMetadata = [self generateInterestMetadata:interest otherOffers:p.offers];
    
    
    // Valid cell data formatting code
    NSMutableAttributedString *interestString = [[NSMutableAttributedString alloc] initWithString:@"Interest: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [interestString appendAttributedString:[[NSAttributedString alloc] initWithString:interestMetadata[@"interest"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : interestMetadata[@"color"]}]];
    [cell.interestLabel setAttributedText:interestString];
    [cell.starImageView setImage:[UIImage imageNamed:[self convertStarsToUIImageName:stars]]];
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", position] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    [nameString appendAttributedString:[[NSAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}]];
    [cell.nameLabel setAttributedText:nameString];
    
    [cell.stateLabel setText:state];
    
    NSMutableAttributedString *heightString = [[NSMutableAttributedString alloc] initWithString:@"Height: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [heightString appendAttributedString:[[NSAttributedString alloc] initWithString:height attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.heightLabel setAttributedText:heightString];
    
    NSMutableAttributedString *weightString = [[NSMutableAttributedString alloc] initWithString:@"Weight: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [weightString appendAttributedString:[[NSAttributedString alloc] initWithString:weight attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.weightLabel setAttributedText:weightString];
    
    NSMutableAttributedString *dashString = [[NSMutableAttributedString alloc] initWithString:@"40-yd dash: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [dashString appendAttributedString:[[NSAttributedString alloc] initWithString:fortyTime attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.fortyYdDashLabel setAttributedText:dashString];
    
    [cell.rankLabel setText:overall];

    NSMutableAttributedString *offerString = [[NSMutableAttributedString alloc] initWithString:@"Other Offers: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:[self generateOfferString:p.offers] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.otherOffersLabel setAttributedText:offerString];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // navigate to page where you can view recruit details and have options to recruit him:
    //          1. extend offer - sends LOI to recruit; can only give out maxTeamSize - currentTeamSize of these
    //          2. extend official visit/OV - spend small amount of recruiting points (smaller amount than in-home) to court player on campus; increases interest by 10pts.
    //          3. visit recruit at home - spend large amount of recruiting points to court player at home; increases interest by 20pts.
    //          4. also provide option to cancel each of these -- basically we are building a recruiting process for each recruit that we think will be best to sign him
    // if committed to user team, show options:
    //          1. redshirt player
    // if committed, but NOT to user team, show options:
    //          1. if interest in that team was mild or medium, then:
    //              * offer and flip (for large amount of recruiting points) -- increases interest in user team by 20 pts.
    // also display recruiting process for this recruit: OV -> offer -> commit or offer -> commit or OV -> home visit -> offer -> commit
}

@end
