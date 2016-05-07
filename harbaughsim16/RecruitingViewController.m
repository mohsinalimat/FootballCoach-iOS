//
//  RecruitingViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "RecruitingViewController.h"
#import "League.h"
#import "Team.h"
#import "HBRecruitCell.h"
#import "TeamRosterViewController.h"

#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "CSNotificationView.h"
#import "STPopup.h"
#import "HexColors.h"

@interface RecruitingViewController ()
{
    STPopupController *popupController;
    NSMutableArray<Player*>* playersRecruited;
    NSMutableArray<Player*>* teamPlayers; //all players
    
    NSMutableArray<Player*>* availQBs;
    NSMutableArray<Player*>* availRBs;
    NSMutableArray<Player*>* availWRs;
    NSMutableArray<Player*>* availOLs;
    NSMutableArray<Player*>* availKs;
    NSMutableArray<Player*>* availSs;
    NSMutableArray<Player*>* availCBs;
    NSMutableArray<Player*>* availF7s;
    NSMutableArray<Player*>* availAll;
    
    NSInteger needQBs;
    NSInteger needRBs;
    NSInteger needWRs;
    NSInteger needOLs;
    NSInteger needKs;
    NSInteger needsS;
    NSInteger needCBs;
    NSInteger needF7s;
    
    int recruitingBudget;
    
    NSMutableArray<Player*>* positions;
    NSMutableArray<Player*>* players;
    BOOL _viewingSignees;
    BOOL _filteredByCost;
}
@end


@implementation RecruitingViewController

-(void)reloadRecruits {
    [availAll removeAllObjects];
    
    [availQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }

    }];
    [availRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    [availWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    [availOLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    [availF7s sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    
    [availCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    [availSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    [availKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    [availAll addObjectsFromArray:availQBs];
    [availAll addObjectsFromArray:availRBs];
    [availAll addObjectsFromArray:availWRs];
    [availAll addObjectsFromArray:availOLs];
    [availAll addObjectsFromArray:availF7s];
    [availAll addObjectsFromArray:availCBs];
    [availAll addObjectsFromArray:availSs];
    [availAll addObjectsFromArray:availKs];
    
    [availAll sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    _viewingSignees = NO;
    if (_filteredByCost) {
        [self filterByCost];
    }
    
    [self.tableView reloadData];
    
    
    self.title = [NSString stringWithFormat:@"Budget: $%d",recruitingBudget];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setToolbarItems:@[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"roster"] style:UIBarButtonItemStylePlain target:self action:@selector(viewRoster)],[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc] initWithTitle:@"View Remaining Needs" style:UIBarButtonItemStylePlain target:self action:@selector(showRemainingNeeds)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(showRecruitCategories)]]];
    self.navigationController.toolbarHidden = NO;
}

-(void)viewRoster {
    TeamRosterViewController *roster = [[TeamRosterViewController alloc] initWithTeam:[HBSharedUtils getLeague].userTeam];
    roster.isPopup = YES;
    popupController = [[STPopupController alloc] initWithRootViewController:roster];
    [popupController.navigationBar setDraggable:YES];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 150;
    self.tableView.estimatedRowHeight = 150;
    recruitingBudget = [HBSharedUtils getLeague].userTeam.recruitingMoney;
    
    NSInteger teamSize = [HBSharedUtils getLeague].userTeam.teamQBs.count + [HBSharedUtils getLeague].userTeam.teamRBs.count + [HBSharedUtils getLeague].userTeam.teamWRs.count + [HBSharedUtils getLeague].userTeam.teamKs.count + [HBSharedUtils getLeague].userTeam.teamSs.count + [HBSharedUtils getLeague].userTeam.teamCBs.count + [HBSharedUtils getLeague].userTeam.teamF7s.count;
    
    playersRecruited = [NSMutableArray array];
    
    teamPlayers = [NSMutableArray array];
    availQBs = [NSMutableArray array];
    availRBs = [NSMutableArray array];
    availWRs = [NSMutableArray array];
    availOLs = [NSMutableArray array];
    availKs = [NSMutableArray array];
    availSs = [NSMutableArray array];
    availCBs = [NSMutableArray array];
    availF7s = [NSMutableArray array];
    availAll = [NSMutableArray array];
    
    //playersGraduating = [HBSharedUtils getLeague].userTeam.playersLeaving;
    recruitingBudget = [HBSharedUtils getLeague].userTeam.teamPrestige * 25;
    
    Team *userTeam = [HBSharedUtils getLeague].userTeam;
    if (userTeam.teamQBs.count < 2) {
        needQBs = 2 - userTeam.teamQBs.count;
    }
    
    if (userTeam.teamRBs.count < 4) {
        needRBs = 4 - userTeam.teamRBs.count;
    }
    
    if (userTeam.teamWRs.count < 6) {
        needWRs = 6 - userTeam.teamWRs.count;
    }
    
    if (userTeam.teamOLs.count < 10) {
        needOLs = 10 - userTeam.teamOLs.count;
    }
    
    if (userTeam.teamF7s.count < 14) {
       needF7s = 14 - userTeam.teamF7s.count;
    }
    
    if (userTeam.teamCBs.count < 6) {
        needCBs = 6 - userTeam.teamCBs.count;
    }
    
    if (userTeam.teamSs.count < 2) {
       needsS = 2 - userTeam.teamSs.count;
    }
    
    if (userTeam.teamKs.count < 2) {
        needKs = 2 - userTeam.teamKs.count;
    }
    
    if (needQBs > 2) {
        needQBs = 2;
    }
    
    if (needRBs > 4) {
        needRBs = 4;
    }
    
    if (needWRs > 6) {
        needWRs = 6;
    }
    
    if (needOLs > 10) {
        needOLs = 10;
    }
    
    if (needKs > 2) {
        needKs = 2;
    }
    
    if (needsS > 2) {
        needsS = 2;
    }
    
    if (needCBs > 6) {
        needCBs = 6;
    }
    
    if (needF7s > 14) {
        needF7s = 14;
    }
    
    //NSLog(@"NEED TO RECRUIT: %ld QBs, %ld RBs, %ld, WRs, %ld OLs, %ld F7s, %ld CBs, %ld Ss, %ld Ks",(long)needQBs,(long)needRBs,(long)needWRs,(long)needOLs,(long)needF7s,(long)needCBs,(long)needsS,(long)needKs);
    
    if (teamSize <= 33) {
        //adding bonus points if the offseason screwed you
        NSInteger recruitingBonus = (25 * (33 - teamSize));
        recruitingBudget += recruitingBonus;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils styleColor] message:[NSString stringWithFormat:@"You've been awarded %ld extra points because of your losses this offseason.",(long)recruitingBonus] onViewController:self];
        });
    }
    
    //recruiting star distribution from here: http://www.cbssports.com/collegefootball/eye-on-college-football/21641769
    // 5-star: 13/100 -> modified to 8/100 to make it harder
    // 4-star: 35/100 -> modified to 40/100 to make it harder
    // 3-star: 35/100 -> modified to 40/100 to make it harder
    // 2-star: 14/100
    // 1-star: 3/100
    // extend that to 200 recruits
    int position = 0;
    for (int i = 0; i < 16; i++) {
        position = (int)([HBSharedUtils randomValue] * 8);
        if (position < 0) {
            position = 0;
        }
        
        if (position > 7) {
            position = 7;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 3) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 4) {
            [availF7s addObject:[PlayerF7 newF7WithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 5) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 6) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:5 team:nil]];
        }
    }
    
    for (int i = 0; i < 80; i++) {
        position = (int)([HBSharedUtils randomValue] * 8) - 1;
        if (position < 0) {
            position = 0;
        }
        
        if (position > 7) {
            position = 7;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 3) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 4) {
            [availF7s addObject:[PlayerF7 newF7WithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 5) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 6) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:4 team:nil]];
        }
    }
    
    for (int i = 0; i < 80; i++) {
        position = (int)([HBSharedUtils randomValue] * 8) - 1;
        if (position < 0) {
            position = 0;
        }
        
        if (position > 7) {
            position = 7;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 3) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 4) {
            [availF7s addObject:[PlayerF7 newF7WithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 5) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 6) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    for (int i = 0; i < 28; i++) {
        position = (int)([HBSharedUtils randomValue] * 8) - 1;
        if (position < 0) {
            position = 0;
        }
        
        if (position > 7) {
            position = 7;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 3) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 4) {
            [availF7s addObject:[PlayerF7 newF7WithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 5) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 6) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:2 team:nil]];
        }
    }
    
    for (int i = 0; i < 6; i++) {
        position = (int)([HBSharedUtils randomValue] * 8) - 1;
        if (position < 0) {
            position = 0;
        }
        
        if (position > 7) {
            position = 7;
        }
        
        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 3) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 4) {
            [availF7s addObject:[PlayerF7 newF7WithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 5) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 6) {
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
    
    if (availOLs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }
    
    if (availF7s.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availF7s addObject:[PlayerF7 newF7WithName:[[HBSharedUtils getLeague] getRandName] year:1 stars:3 team:nil]];
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
    
    [self reloadRecruits];
    players = availAll;
    
    //display tutorial alert on first launch
    BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_RECRUITING_TUTORIAL_SHOWN];
    if (!tutorialShown) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_RECRUITING_TUTORIAL_SHOWN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //display intro screen
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Welcome to Recruiting Season, Coach!" message:@"At the end of each season, graduating seniors leave the program and spots open up. As coach, you are responsible for recruiting the next class of players that will lead your team to bigger and better wins. You recruit based on a budget of points, which is determined by your team's prestige. Better teams will have more points to work with, while worse teams will have to save points wherever they can.\n\nWhen you press \"Start Recruiting\" after the season, you can see who is leaving your program and give you a sense of how many players you will need to replace. Next, the Recruiting menu opens up (where you are now). You can view the Top 200 recruits from every position to see the best of the best. Each Recruit has their positional ratings as well as an Overall and Potential. The point cost of each recruit (insert Cam Newton and/or Ole Miss joke here) is determined by how good they are. Once you are done recruiting all the players you need or that you can afford press \"Done\" to advance to the next season." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishRecruiting)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    
    self.title = [NSString stringWithFormat:@"Budget: %d pts",recruitingBudget];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HBRecruitCell" bundle:nil] forCellReuseIdentifier:@"HBRecruitCell"];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)showRecruitCategories {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View a specific position" message:@"Which position would you like to see?" preferredStyle:UIAlertControllerStyleActionSheet];
    NSString *position = @"";
    if (playersRecruited.count > 0) {
        for (int i = 0; i < 11; i++) {
            if (i == 0) {
                position = @"All Players";
            } else if (i == 1) {
                position = @"Recruited Players";
            } else if (i == 2) {
                position = @"Players within Budget";
            } else if (i == 3) {
                position = @"QB";
            } else if (i == 4) {
                position = @"RB";
            } else if (i == 5) {
                position = @"WR";
            } else if (i == 6) {
                position = @"OL";
            } else if (i == 7) {
                position = @"F7";
            } else if (i == 8) {
                position = @"CB";
            } else if (i == 9) {
                position = @"S";
            } else {
                position = @"K";
            }
            [alertController addAction:[UIAlertAction actionWithTitle:position style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (i == 0) {
                    players = availAll;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                } else if (i == 1) {
                    players = playersRecruited;
                    _viewingSignees = YES;
                    _filteredByCost = NO;
                } else if (i == 2) {
                    [self filterByCost];
                    _filteredByCost = YES;
                    _viewingSignees = NO;
                } else if (i == 3) {
                    players = availQBs;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                } else if (i == 4) {
                    players = availRBs;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                } else if (i == 5) {
                    players = availWRs;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                } else if (i == 6) {
                    players = availOLs;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                } else if (i == 7) {
                    players = availF7s;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                } else if (i == 8) {
                    players = availCBs;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                } else if (i == 9) {
                    players = availSs;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                } else {
                    players = availKs;
                    _viewingSignees = NO;
                    _filteredByCost = NO;
                }
                
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
            }]];

        }
    } else {
        for (int i = 0; i < 10; i++) {
            if (i == 0) {
                position = @"All Players";
            } else if (i == 1) {
                position = @"Players within Budget";
            } else if (i == 2) {
                position = @"QB";
            } else if (i == 3) {
                position = @"RB";
            } else if (i == 4) {
                position = @"WR";
            } else if (i == 5) {
                position = @"OL";
            } else if (i == 6) {
                position = @"F7";
            } else if (i == 7) {
                position = @"CB";
            } else if (i == 8) {
                position = @"S";
            } else {
                position = @"K";
            }
            
            [alertController addAction:[UIAlertAction actionWithTitle:position style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (i == 0) {
                    players = availAll;
                    _filteredByCost = NO;
                } else if (i == 1) {
                    [self filterByCost];
                    _filteredByCost = YES;
                } else if (i == 2) {
                    players = availQBs;
                    _filteredByCost = NO;
                } else if (i == 3) {
                    players = availRBs;
                    _filteredByCost = NO;
                } else if (i == 4) {
                    players = availWRs;
                    _filteredByCost = NO;
                } else if (i == 5) {
                    players = availOLs;
                    _filteredByCost = NO;
                } else if (i == 6) {
                    players = availF7s;
                    _filteredByCost = NO;
                } else if (i == 7) {
                    players = availCBs;
                    _filteredByCost = NO;
                } else if (i == 8) {
                    players = availSs;
                    _filteredByCost = NO;
                } else {
                    players = availKs;
                    _filteredByCost = NO;
                }
                
                [self.tableView reloadData];
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
               
            }]];
        }
        
    }
    
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)filterByCost {
    players = [availAll mutableCopy];
    //remove the ones that cost too much
    NSMutableArray *playersCopy = [players mutableCopy];
    for (Player *p in players) {
        if (p.cost > recruitingBudget && [playersCopy containsObject:p]) {
            [playersCopy removeObject:p];
        }
    }
    
    players = playersCopy;
    
    //re-sort them by ovr
    [players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
}

-(void)showRemainingNeeds {
    NSMutableString *summary = [NSMutableString string];
    
    if (needQBs > 0) {
        if (needQBs > 1) {
            [summary appendFormat:@"Need %ld active QBs\n\n",(long)needQBs];
        } else {
            [summary appendFormat:@"Need %ld active QB\n\n",(long)needQBs];
        }
    }
    
    if (needRBs > 0) {
        if (needRBs > 1) {
            [summary appendFormat:@"Need %ld active RBs\n\n",(long)needRBs];
        } else {
            [summary appendFormat:@"Need %ld active RB\n\n",(long)needRBs];
        }
    }
    
    if (needWRs > 0) {
        if (needWRs > 1) {
            [summary appendFormat:@"Need %ld active WRs\n\n",(long)needWRs];
        } else {
            [summary appendFormat:@"Need %ld active WR\n\n",(long)needWRs];
        }
    }
    
    if (needOLs > 0) {
        if (needOLs > 1) {
            [summary appendFormat:@"Need %ld active OLs\n\n",(long)needOLs];
        } else {
            [summary appendFormat:@"Need %ld active OL\n\n",(long)needOLs];
        }
    }
    
    if (needF7s > 0) {
        if (needF7s > 1) {
            [summary appendFormat:@"Need %ld active F7s\n\n",(long)needF7s];
        } else {
            [summary appendFormat:@"Need %ld active F7\n\n",(long)needF7s];
        }
    }
    
    if (needCBs > 0) {
        if (needCBs > 1) {
            [summary appendFormat:@"Need %ld active CBs\n\n",(long)needCBs];
        } else {
            [summary appendFormat:@"Need %ld active CB\n\n",(long)needCBs];
        }
    }
    
    if (needsS > 0) {
        if (needsS > 1) {
            [summary appendFormat:@"Need %ld active Ss\n\n",(long)needsS];
        } else {
            [summary appendFormat:@"Need %ld active S\n\n",(long)needsS];
        }
    }
    
    if (needKs > 0) {
        if (needKs > 1) {
            [summary appendFormat:@"Need %ld active Ks",(long)needKs];
        } else {
            [summary appendFormat:@"Need %ld active K",(long)needKs];
        }
    }
    
    if (summary.length == 0 || [summary isEqualToString:@""]) {
        [summary appendString:@"All positional needs filled"];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Remaining Needs",[HBSharedUtils getLeague].userTeam.abbreviation] message:summary preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [alertController.view setNeedsLayout];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return players.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBRecruitCell *cell = (HBRecruitCell*)[tableView dequeueReusableCellWithIdentifier:@"HBRecruitCell"];
    Player *player = players[indexPath.row];
    [cell.nameLabel setText:player.name];
    [cell.positionLabel setText:player.position];
    [cell.ovrLabel setText:[NSString stringWithFormat:@"Ovr: %d",player.ratOvr]];
    [cell.recruitButton setTitle:[NSString stringWithFormat:@"Recruit Player (%d pts)", player.cost] forState:UIControlStateNormal];
    [cell.recruitButton addTarget:self action:@selector(recruitPlayer:) forControlEvents:UIControlEventTouchUpInside];
    [cell.recruitButton setTag:indexPath.row];
    NSString *stat2;
    NSString *stat3;
    NSString *stat4;
    NSString *stat2Val;
    NSString *stat3Val;
    NSString *stat4Val;
    
    UIColor *letterColor;
    
    NSMutableAttributedString *stat1Att = [[NSMutableAttributedString alloc] initWithString:@"Potential: " attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]}];
    NSString *stat1 = [player getLetterGrade:player.ratPot];
    if ([stat1 containsString:@"A"]) {
        letterColor = [HBSharedUtils successColor];
    } else if ([stat1 containsString:@"B"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
    } else if ([stat1 containsString:@"C"]) {
        letterColor = [HBSharedUtils champColor];
    } else if ([stat1 containsString:@"D"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
    } else if ([stat1 containsString:@"F"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
    } else {
        letterColor = [UIColor lightGrayColor];
    }
    
    [stat1Att appendAttributedString:[[NSAttributedString alloc] initWithString:stat1 attributes:@{NSForegroundColorAttributeName : letterColor}]];
    [cell.stat1ValueLabel setAttributedText:stat1Att];
    
    
    
    
    if ([player isKindOfClass:[PlayerQB class]]) {
        stat2 = @"Throw Power";
        stat2Val = [player getLetterGrade:((PlayerQB*)player).ratPassPow];
        stat3 = @"Throw Accy";
        stat3Val = [player getLetterGrade:((PlayerQB*)player).ratPassAcc];
        stat4 = @"Evasion";
        stat4Val = [player getLetterGrade:((PlayerQB*)player).ratPassEva];
    } else if ([player isKindOfClass:[PlayerRB class]]) {
        stat2 = @"Strength";
        stat2Val = [player getLetterGrade:((PlayerRB*)player).ratRushPow];
        stat3 = @"Speed";
        stat3Val = [player getLetterGrade:((PlayerRB*)player).ratRushSpd];
        stat4 = @"Evasion";
        stat4Val = [player getLetterGrade:((PlayerRB*)player).ratRushEva];
    } else if ([player isKindOfClass:[PlayerWR class]]) {
        stat2 = @"Catching";
        stat2Val = [player getLetterGrade:((PlayerWR*)player).ratRecCat];
        stat3 = @"Speed";
        stat3Val = [player getLetterGrade:((PlayerWR*)player).ratRecSpd];
        stat4 = @"Evasion";
        stat4Val = [player getLetterGrade:((PlayerWR*)player).ratRecEva];
    } else if ([player isKindOfClass:[PlayerOL class]]) {
        stat2 = @"Strength";
        stat2Val = [player getLetterGrade:((PlayerOL*)player).ratOLPow];
        stat3 = @"Pass Blocking";
        stat3Val = [player getLetterGrade:((PlayerOL*)player).ratOLBkP];
        stat4 = @"Run Blocking";
        stat4Val = [player getLetterGrade:((PlayerOL*)player).ratOLBkR];
    } else if ([player isKindOfClass:[PlayerF7 class]]) {
        stat2 = @"Strength";
        stat2Val = [player getLetterGrade:((PlayerF7*)player).ratF7Pow];
        stat3 = @"Pass Pressure";
        stat3Val = [player getLetterGrade:((PlayerF7*)player).ratF7Pas];
        stat4 = @"Run Stopping";
        stat4Val = [player getLetterGrade:((PlayerF7*)player).ratF7Rsh];
    } else if ([player isKindOfClass:[PlayerCB class]]) {
        stat2 = @"Coverage";
        stat2Val = [player getLetterGrade:((PlayerCB*)player).ratCBCov];
        stat3 = @"Speed";
        stat3Val = [player getLetterGrade:((PlayerCB*)player).ratCBSpd];
        stat4 = @"Tackling";
        stat4Val = [player getLetterGrade:((PlayerCB*)player).ratCBTkl];
    } else if ([player isKindOfClass:[PlayerS class]]) {
        stat2 = @"Coverage";
        stat2Val = [player getLetterGrade:((PlayerS*)player).ratSCov];
        stat3 = @"Speed";
        stat3Val = [player getLetterGrade:((PlayerS*)player).ratSSpd];
        stat4 = @"Tackling";
        stat4Val = [player getLetterGrade:((PlayerS*)player).ratSTkl];
    } else { // PlayerK class
        stat2 = @"Kick Power";
        stat2Val = [player getLetterGrade:((PlayerK*)player).ratKickPow];
        stat3 = @"Kick Accuracy";
        stat3Val = [player getLetterGrade:((PlayerK*)player).ratKickAcc];
        stat4 = @"Clumsiness";
        stat4Val = [player getLetterGrade:((PlayerK*)player).ratKickFum];
    }
    
    NSMutableAttributedString *stat2Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", stat2] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]}];
    if ([stat2Val containsString:@"A"]) {
        letterColor = [HBSharedUtils successColor];
    } else if ([stat2Val containsString:@"B"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
    } else if ([stat2Val containsString:@"C"]) {
        letterColor = [HBSharedUtils champColor];
    } else if ([stat2Val containsString:@"D"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
    } else if ([stat2Val containsString:@"F"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
    } else {
        letterColor = [UIColor lightGrayColor];
    }
    
    [stat2Att appendAttributedString:[[NSAttributedString alloc] initWithString:stat2Val attributes:@{NSForegroundColorAttributeName : letterColor}]];
    [cell.stat2ValueLabel setAttributedText:stat2Att];
    
    NSMutableAttributedString *stat3Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", stat3] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]}];
    if ([stat3Val containsString:@"A"]) {
        letterColor = [HBSharedUtils successColor];
    } else if ([stat3Val containsString:@"B"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
    } else if ([stat3Val containsString:@"C"]) {
        letterColor = [HBSharedUtils champColor];
    } else if ([stat3Val containsString:@"D"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
    } else if ([stat3Val containsString:@"F"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
    } else {
        letterColor = [UIColor lightGrayColor];
    }
    
    [stat3Att appendAttributedString:[[NSAttributedString alloc] initWithString:stat3Val attributes:@{NSForegroundColorAttributeName : letterColor}]];
    [cell.stat3ValueLabel setAttributedText:stat3Att];
    
    NSMutableAttributedString *stat4Att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@: ", stat4] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium]}];
    if ([stat4Val containsString:@"A"]) {
        letterColor = [HBSharedUtils successColor];
    } else if ([stat4Val containsString:@"B"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
    } else if ([stat4Val containsString:@"C"]) {
        letterColor = [HBSharedUtils champColor];
    } else if ([stat4Val containsString:@"D"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
    } else if ([stat4Val containsString:@"F"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
    } else {
        letterColor = [UIColor lightGrayColor];
    }
    
    [stat4Att appendAttributedString:[[NSAttributedString alloc] initWithString:stat4Val attributes:@{NSForegroundColorAttributeName : letterColor}]];
    [cell.stat4ValueLabel setAttributedText:stat4Att];
    
    if (player.cost > recruitingBudget || _viewingSignees) {
        [cell.recruitButton setEnabled:NO];
        [cell.recruitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    } else {
        [cell.recruitButton setEnabled:YES];
        [cell.recruitButton setTitleColor:[HBSharedUtils styleColor] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(void)recruitPlayer:(UIButton*)sender {
    Player *p = players[sender.tag];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Are you sure you want to sign %@ %@ to your team?", p.position,p.name] message:[NSString stringWithFormat:@"This will cost %ld points.",(long)p.cost] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Would you like to redshirt this player?" message:[NSString stringWithFormat:@"Doing this will cost you an extra %ld points and prevent him from playing for a season, but produce increased stat bonuses.", (long)(p.cost / 4)] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes, redshirt him." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self buyAndRedshirtRecruit:p];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No, just sign him." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self buyRecruit:p];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Don't sign him." style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)buyAndRedshirtRecruit:(Player*)player {
    int redshirtCost = player.cost / 4;
    int totalCost = (redshirtCost + player.cost);
    if (recruitingBudget >= totalCost) {
        recruitingBudget -= totalCost;
        [playersRecruited addObject:player];
        [player setTeam:[HBSharedUtils getLeague].userTeam];
        [player setHasRedshirt:YES];
        [player setYear:0];
        
        if ([players containsObject:player]) {
            [players removeObject:player];
        }
        
        if ([availAll containsObject:player]) {
            [availAll removeObject:player];
        }
        
        if ([player isKindOfClass:[PlayerQB class]]) {
            if ([availQBs containsObject:player]) {
                [availQBs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamQBs addObject:(PlayerQB*)player];
            //needQBs--;
        } else if ([player isKindOfClass:[PlayerRB class]]) {
            if ([availRBs containsObject:player]) {
                [availRBs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamRBs addObject:(PlayerRB*)player];
            //needRBs--;
        } else if ([player isKindOfClass:[PlayerWR class]]) {
            if ([availWRs containsObject:player]) {
                [availWRs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamWRs addObject:(PlayerWR*)player];
            //needWRs--;
        } else if ([player isKindOfClass:[PlayerOL class]]) {
            if ([availOLs containsObject:player]) {
                [availOLs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamOLs addObject:(PlayerOL*)player];
            //needOLs--;
        } else if ([player isKindOfClass:[PlayerF7 class]]) {
            if ([availF7s containsObject:player]) {
                [availF7s removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamF7s addObject:(PlayerF7*)player];
            //needF7s--;
        } else if ([player isKindOfClass:[PlayerCB class]]) {
            if ([availCBs containsObject:player]) {
                [availCBs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamCBs addObject:(PlayerCB*)player];
            //needCBs--;
        } else if ([player isKindOfClass:[PlayerS class]]) {
            if ([availSs containsObject:player]) {
                [availSs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamSs addObject:(PlayerS*)player];
            //needsS--;
        } else { // PlayerK class
            if ([availKs containsObject:player]) {
                [availKs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamKs addObject:(PlayerK*)player];
            //needKs--;
        }
        
        [[HBSharedUtils getLeague].userTeam sortPlayers];
        
        [self reloadRecruits];
        [self.tableView reloadData];
        
        [CSNotificationView showInViewController:self tintColor:[HBSharedUtils styleColor] image:nil message:[NSString stringWithFormat:@"Signed and redshirted %@ %@ (Ovr: %d) to %@!",player.position, player.name, player.ratOvr, [HBSharedUtils getLeague].userTeam.abbreviation] duration:0.5];
        self.title = [NSString stringWithFormat:@"Budget: %d pts",recruitingBudget];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Coach, you don't have enough points in your budget to sign this player! Try recruiting a cheaper one instead." preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)buyRecruit:(Player*)player { //Ole Mi$$
    int playerCost = player.cost;
    if (recruitingBudget >= playerCost) {
        recruitingBudget -= playerCost;
        [playersRecruited addObject:player];
        [player setTeam:[HBSharedUtils getLeague].userTeam];
        
        if ([players containsObject:player]) {
            [players removeObject:player];
        }
        
        if ([availAll containsObject:player]) {
            [availAll removeObject:player];
        }
        
        if ([player isKindOfClass:[PlayerQB class]]) {
            if ([availQBs containsObject:player]) {
                [availQBs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamQBs addObject:(PlayerQB*)player];
            needQBs--;
        } else if ([player isKindOfClass:[PlayerRB class]]) {
            if ([availRBs containsObject:player]) {
                [availRBs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamRBs addObject:(PlayerRB*)player];
            needRBs--;
        } else if ([player isKindOfClass:[PlayerWR class]]) {
            if ([availWRs containsObject:player]) {
                [availWRs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamWRs addObject:(PlayerWR*)player];
            needWRs--;
        } else if ([player isKindOfClass:[PlayerOL class]]) {
            if ([availOLs containsObject:player]) {
                [availOLs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamOLs addObject:(PlayerOL*)player];
            needOLs--;
        } else if ([player isKindOfClass:[PlayerF7 class]]) {
            if ([availF7s containsObject:player]) {
                [availF7s removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamF7s addObject:(PlayerF7*)player];
            needF7s--;
        } else if ([player isKindOfClass:[PlayerCB class]]) {
            if ([availCBs containsObject:player]) {
                [availCBs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamCBs addObject:(PlayerCB*)player];
            needCBs--;
        } else if ([player isKindOfClass:[PlayerS class]]) {
            if ([availSs containsObject:player]) {
                [availSs removeObject:player];
            }
            [[HBSharedUtils getLeague].userTeam.teamSs addObject:(PlayerS*)player];
            needsS--;
        } else { // PlayerK class
            if ([availKs containsObject:player]) {
                [availKs removeObject:player];
            }
           [[HBSharedUtils getLeague].userTeam.teamKs addObject:(PlayerK*)player];
            needKs--;
        }
        
        [[HBSharedUtils getLeague].userTeam sortPlayers];
        
        [self reloadRecruits];
        [self.tableView reloadData];
        
        [CSNotificationView showInViewController:self tintColor:[HBSharedUtils styleColor] image:nil message:[NSString stringWithFormat:@"Signed %@ %@ (Ovr: %d) to %@!",player.position, player.name, player.ratOvr, [HBSharedUtils getLeague].userTeam.abbreviation] duration:0.5];
        self.title = [NSString stringWithFormat:@"Budget: %d pts",recruitingBudget];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Coach, you don't have enough points in your budget to sign this player! Try recruiting a cheaper one instead." preferredStyle:UIAlertControllerStyleAlert];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)dismissVC {
    [self finishRecruiting];
}

-(void)finishRecruiting {
    NSMutableString *summary = [NSMutableString stringWithString:@"Any unfilled positions will be filled by walk-ons.\n\n"];
    
    if (needQBs > 0) {
        if (needQBs > 1) {
            [summary appendFormat:@"Need %ld active QBs\n\n",(long)needQBs];
        } else {
            [summary appendFormat:@"Need %ld active QB\n\n",(long)needQBs];
        }
    }
    
    if (needRBs > 0) {
        if (needRBs > 1) {
            [summary appendFormat:@"Need %ld active RBs\n\n",(long)needRBs];
        } else {
            [summary appendFormat:@"Need %ld active RB\n\n",(long)needRBs];
        }
    }
    
    if (needWRs > 0) {
        if (needWRs > 1) {
            [summary appendFormat:@"Need %ld active WRs\n\n",(long)needWRs];
        } else {
            [summary appendFormat:@"Need %ld active WR\n\n",(long)needWRs];
        }
    }
    
    if (needOLs > 0) {
        if (needOLs > 1) {
            [summary appendFormat:@"Need %ld active OLs\n\n",(long)needOLs];
        } else {
            [summary appendFormat:@"Need %ld active OL\n\n",(long)needOLs];
        }
    }
    
    if (needF7s > 0) {
        if (needF7s > 1) {
            [summary appendFormat:@"Need %ld active F7s\n\n",(long)needF7s];
        } else {
            [summary appendFormat:@"Need %ld active F7\n\n",(long)needF7s];
        }
    }
    
    if (needCBs > 0) {
        if (needCBs > 1) {
            [summary appendFormat:@"Need %ld active CBs\n\n",(long)needCBs];
        } else {
            [summary appendFormat:@"Need %ld active CB\n\n",(long)needCBs];
        }
    }
    
    if (needsS > 0) {
        if (needsS > 1) {
            [summary appendFormat:@"Need %ld active Ss\n\n",(long)needsS];
        } else {
            [summary appendFormat:@"Need %ld active S\n\n",(long)needsS];
        }
    }
    
    if (needKs > 0) {
        if (needKs > 1) {
            [summary appendFormat:@"Need %ld active Ks",(long)needKs];
        } else {
            [summary appendFormat:@"Need %ld active K",(long)needKs];
        }
    }
    
    [playersRecruited sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        if (!a.hasRedshirt && !b.hasRedshirt) {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        } else if (a.hasRedshirt) {
            return 1;
        } else if (b.hasRedshirt) {
            return -1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.ratPot > b.ratPot) {
                    return -1;
                } else if (a.ratPot < b.ratPot) {
                    return 1;
                } else {
                    return 0;
                }
            }
        }
    }];
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you are done recruiting?" message:summary preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
        //save game
        [[HBSharedUtils getLeague].userTeam recruitWalkOns:@[@(needQBs), @(needRBs), @(needWRs), @(needKs), @(needOLs), @(needsS), @(needCBs), @(needF7s)]];
        [HBSharedUtils getLeague].recruitingStage = 0;
        [[HBSharedUtils getLeague] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newSeasonStart" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"endedSeason" object:nil];
        
        if (playersRecruited.count > 0) {
            NSMutableString *recruitSummary = [NSMutableString string];
            
            for (Player *p in playersRecruited) {
                if (p.hasRedshirt) {
                    [recruitSummary appendFormat:@"%@ %@ (RS - Ovr: %d, Pot: %d)\n", p.position, p.name, p.ratOvr, p.ratPot];
                } else {
                    [recruitSummary appendFormat:@"%@ %@ (Ovr: %d, Pot: %d)\n", p.position, p.name, p.ratOvr, p.ratPot];
                }
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@'s %ld Recruiting Class",[HBSharedUtils getLeague].userTeam.abbreviation, (long)(2016 + [HBSharedUtils getLeague].leagueHistory.count)] message:recruitSummary preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self.presentingViewController presentViewController:alert animated:YES completion:nil];
            });
        }
    
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
