//
//  PlayerStatsViewController.m
//  profootballcoach
//
//  Created by Akshay Easwaran on 3/17/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "PlayerStatsViewController.h"
#import "HBPlayerCell.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerDL.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerS.h"
#import "HeadCoach.h"
#import "PlayerDefender.h"
#import "Team.h"
#import "PlayerQBDetailViewController.h"
#import "PlayerRBDetailViewController.h"
#import "PlayerWRDetailViewController.h"
#import "PlayerTEDetailViewController.h"
#import "PlayerOLDetailViewController.h"
#import "PlayerKDetailViewController.h"
#import "PlayerDLDetailViewController.h"
#import "PlayerLBDetailViewController.h"
#import "PlayerCBDetailViewController.h"
#import "PlayerSDetailViewController.h"
#import "PlayerDetailViewController.h"
#import "HeadCoachDetailViewController.h"

@interface PlayerStatsViewController () <UIViewControllerPreviewingDelegate>
{
    NSMutableArray *players;
    HBStatPosition position;
    Player *heisman;
    Player *roty;
    HeadCoach *coty;
    FCHeadCoachStat hcStatType;
}
@end

@implementation PlayerStatsViewController
-(instancetype)initWithStatType:(HBStatPosition)type {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        position = type;
        if (type == HBStatPositionHC) {
            self->hcStatType = FCHeadCoachStatTotalWins;
        }
    }
    return self;
}

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        HBPlayerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        id obj = players[indexPath.row];
        if ([obj isKindOfClass:[Player class]]) {
            Player *p = (Player *)obj;
            PlayerDetailViewController *playerDetail;
            if ([p.position isEqualToString:@"QB"]) {
                playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"RB"]) {
                playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"WR"]) {
                playerDetail = [[PlayerWRDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"TE"]) {
                playerDetail = [[PlayerTEDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"OL"]) {
                playerDetail = [[PlayerOLDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"DL"]) {
                playerDetail = [[PlayerDLDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"LB"]) {
                playerDetail = [[PlayerLBDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"CB"]) {
                playerDetail = [[PlayerCBDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"S"]) {
                playerDetail = [[PlayerSDetailViewController alloc] initWithPlayer:p];
            } else if ([p.position isEqualToString:@"K"]) {
                playerDetail = [[PlayerKDetailViewController alloc] initWithPlayer:p];
            } else {
                playerDetail = [[PlayerDetailViewController alloc] initWithPlayer:p];
            }
            playerDetail.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
            previewingContext.sourceRect = cell.frame;
            return playerDetail;
        } else {
            HeadCoach *hc = (HeadCoach *)obj;
            HeadCoachDetailViewController *hcDetail = [[HeadCoachDetailViewController alloc] initWithCoach:hc];
            hcDetail.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
            previewingContext.sourceRect = cell.frame;
            return hcDetail;
        }
    } else {
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    heisman = [[HBSharedUtils currentLeague] heisman];
    roty = [[HBSharedUtils currentLeague] roty];
    coty = [[HBSharedUtils currentLeague] cotyWinner];

    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }

    self.tableView.rowHeight = 60;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"HBPlayerCell" bundle:nil] forCellReuseIdentifier:@"HBPlayerCell"];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    self.tableView.tableFooterView = [UIView new];

    players = [NSMutableArray array];

    if (position == HBStatPositionQB) {
        self.title = @"Passing Leaders";
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
            [players addObjectsFromArray:t.teamQBs];
        }
        [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            PlayerQB *a = (PlayerQB*)obj1;
            PlayerQB *b = (PlayerQB*)obj2;
            return (a.statsPassYards > b.statsPassYards) ? -1 : ((a.statsPassYards == b.statsPassYards) ? [a.name compare:b.name] : 1);
        }];
    } else if (position == HBStatPositionRB) {
        self.title = @"Rushing Leaders";
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
            [players addObjectsFromArray:t.teamRBs];
            [players addObjectsFromArray:t.teamQBs];
        }

        [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            PlayerRB *a = (PlayerRB*)obj1;
            PlayerRB *b = (PlayerRB*)obj2;
            return (a.statsRushYards > b.statsRushYards) ? -1 : ((a.statsRushYards == b.statsRushYards) ? [a.name compare:b.name] : 1);
        }];

    } else if (position == HBStatPositionWR) {
        self.title = @"Receiving Leaders";
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
            [players addObjectsFromArray:t.teamWRs];
            [players addObjectsFromArray:t.teamTEs];
        }

        [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            PlayerWR *a = (PlayerWR*)obj1;
            PlayerWR *b = (PlayerWR*)obj2;
            return (a.statsRecYards > b.statsRecYards) ? -1 : ((a.statsRecYards == b.statsRecYards) ? [a.name compare:b.name] : 1);
        }];
    } else if (position == HBStatPositionK) {
        self.title = @"Kicking Leaders";
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
            [players addObjectsFromArray:t.teamKs];
        }
        [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            PlayerK *a = (PlayerK*)obj1;
            PlayerK *b = (PlayerK*)obj2;
            return ([a getHeismanScore] > [b getHeismanScore]) ? -1 : (([a getHeismanScore] == [b getHeismanScore]) ? [a.name compare:b.name] : 1);
        }];
    } else if (position == HBStatPositionDEF) { // all defenders
        self.title = @"Defensive Leaders";
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
            [players addObjectsFromArray:t.teamDLs];
            [players addObjectsFromArray:t.teamLBs];
            [players addObjectsFromArray:t.teamCBs];
            [players addObjectsFromArray:t.teamSs];
        }
        [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            PlayerDefender *a = (PlayerDefender*)obj1;
            PlayerDefender *b = (PlayerDefender*)obj2;
            return (a.statsTkl > b.statsTkl) ? -1 : ((a.statsTkl == b.statsTkl) ? [a.name compare:b.name] : 1);
        }];
    } else if (position == HBStatPositionHC) {
        self.title = @"Coaching Leaders";
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
            for (HeadCoach *c in t.coaches) {
                if (![self->players containsObject:c]) {
                    [players addObject:c];
                }
            }
        }
        [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            HeadCoach *a = (HeadCoach*)obj1;
            HeadCoach *b = (HeadCoach*)obj2;
            return (a.totalWins > b.totalWins) ? -1 : ((a.totalWins == b.totalWins) ? [a.name compare:b.name] : 1);
        }];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortStat)];
}

-(void)sortStat {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Stat Sort Options" message:@"What statistic would you like to sort by?" preferredStyle:UIAlertControllerStyleActionSheet];
    if (position == HBStatPositionQB) { //Yds, Comp/Att, YPG, TD, Int
        [alertController addAction:[UIAlertAction actionWithTitle:@"Passing Yards" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerQB *a = (PlayerQB*)obj1;
                PlayerQB *b = (PlayerQB*)obj2;
                return (a.statsPassYards > b.statsPassYards) ? -1 : ((a.statsPassYards == b.statsPassYards) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Completion Percentage" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerQB *a = (PlayerQB*)obj1;
                PlayerQB *b = (PlayerQB*)obj2;
                int aCompPercent = 0;
                if (a.statsPassAtt > 0) {
                    aCompPercent = (int)ceil(100.0*((double)a.statsPassComp/(double)a.statsPassAtt));
                }

                int bCompPercent = 0;
                if (b.statsPassAtt > 0) {
                    bCompPercent = (int)ceil(100.0*((double)b.statsPassComp/(double)b.statsPassAtt));
                }

                return (aCompPercent > bCompPercent) ? -1 : ((aCompPercent == bCompPercent) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Yards per Game" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerQB *a = (PlayerQB*)obj1;
                PlayerQB *b = (PlayerQB*)obj2;
                int aYPG = 0;
                if (a.gamesPlayed > 0) {
                    aYPG = (int)ceil((double)a.statsPassYards/(double)a.gamesPlayed);
                }

                int bYPG = 0;
                if (b.gamesPlayed > 0) {
                    bYPG = (int)ceil((double)b.statsPassYards/(double)b.gamesPlayed);
                }

                return (aYPG > bYPG) ? -1 : ((aYPG == bYPG) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Touchdowns" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerQB *a = (PlayerQB*)obj1;
                PlayerQB *b = (PlayerQB*)obj2;
                return (a.statsTD > b.statsTD) ? -1 : ((a.statsTD == b.statsTD) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Interceptions" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerQB *a = (PlayerQB*)obj1;
                PlayerQB *b = (PlayerQB*)obj2;
                return (a.statsInt > b.statsInt) ? -1 : ((a.statsInt == b.statsInt) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];
    } else if (position == HBStatPositionRB) { //Yds, att, YPG, TD, Fum
        [alertController addAction:[UIAlertAction actionWithTitle:@"Rushing Yards" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                Player *a = (Player*)obj1;
                Player *b = (Player*)obj2;
                if (([a isKindOfClass:[PlayerQB class]] || [a isKindOfClass:[PlayerRB class]]) && ([b isKindOfClass:[PlayerQB class]] || [b isKindOfClass:[PlayerRB class]])) {
                    int aYards;
                    int bYards;
                    if ([a isKindOfClass:[PlayerQB class]]) {
                        aYards = ((PlayerQB*)a).statsRushYards;
                    } else if ([a isKindOfClass:[PlayerRB class]]) {
                        aYards = ((PlayerRB*)a).statsRushYards;
                    } else {
                        aYards = 0;
                    }

                    if ([b isKindOfClass:[PlayerQB class]]) {
                        bYards = ((PlayerQB*)b).statsRushYards;
                    } else if ([b isKindOfClass:[PlayerRB class]]) {
                        bYards = ((PlayerRB*)b).statsRushYards;
                    } else {
                        bYards = 0;
                    }

                    return (aYards > bYards) ? -1 : ((aYards == bYards) ? [a.name compare:b.name] : 1);
                } else {
                    return [a.name compare:b.name];
                }
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Yards per Attempt" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                int aYPA = 0;
                int bYPA = 0;

                Player *a = (Player*)obj1;
                Player *b = (Player*)obj2;
                if (([a isKindOfClass:[PlayerQB class]] || [a isKindOfClass:[PlayerRB class]]) && ([b isKindOfClass:[PlayerQB class]] || [b isKindOfClass:[PlayerRB class]])) {
                    if ([a isKindOfClass:[PlayerQB class]]) {
                        if (((PlayerQB*)a).statsRushAtt > 0) {
                            aYPA = (int)ceil((double) ((PlayerRB*)a).statsRushYards/(double) ((PlayerRB*)a).statsRushAtt);
                        }
                    } else if ([a isKindOfClass:[PlayerRB class]]) {
                        if (((PlayerRB*)a).statsRushAtt > 0) {
                            aYPA = (int)ceil((double) ((PlayerRB*)a).statsRushYards/(double) ((PlayerRB*)a).statsRushAtt);
                        }
                    } else {
                        aYPA = 0;
                    }

                    if ([b isKindOfClass:[PlayerQB class]]) {
                        if (((PlayerQB*)b).statsRushAtt > 0) {
                            bYPA = (int)ceil((double) ((PlayerRB*)b).statsRushYards/(double) ((PlayerRB*)b).statsRushAtt);
                        }
                    } else if ([b isKindOfClass:[PlayerRB class]]) {
                        if (((PlayerRB*)b).statsRushAtt > 0) {
                            bYPA = (int)ceil((double) ((PlayerRB*)b).statsRushYards/(double) ((PlayerRB*)b).statsRushAtt);
                        }
                    } else {
                        bYPA = 0;
                    }


                    return (aYPA > bYPA) ? -1 : ((aYPA == bYPA) ? [a.name compare:b.name] : 1);
                } else {
                    return [a.name compare:b.name];
                }
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Yards per Game" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                int aYPG = 0;
                int bYPG = 0;

                Player *a = (Player*)obj1;
                Player *b = (Player*)obj2;
                if (([a isKindOfClass:[PlayerQB class]] || [a isKindOfClass:[PlayerRB class]]) && ([b isKindOfClass:[PlayerQB class]] || [b isKindOfClass:[PlayerRB class]])) {
                    if ([a isKindOfClass:[PlayerQB class]]) {
                        if (((PlayerQB*)a).gamesPlayed > 0) {
                            aYPG = (int)ceil((double) ((PlayerRB*)a).statsRushYards/(double) ((PlayerRB*)a).gamesPlayed);
                        }
                    } else if ([a isKindOfClass:[PlayerRB class]]) {
                        if (((PlayerRB*)a).gamesPlayed > 0) {
                            aYPG = (int)ceil((double) ((PlayerRB*)a).statsRushYards/(double) ((PlayerRB*)a).gamesPlayed);
                        }
                    } else {
                        aYPG = 0;
                    }

                    if ([b isKindOfClass:[PlayerQB class]]) {
                        if (((PlayerQB*)b).gamesPlayed > 0) {
                            bYPG = (int)ceil((double) ((PlayerRB*)b).statsRushYards/(double) ((PlayerRB*)b).gamesPlayed);
                        }
                    } else if ([b isKindOfClass:[PlayerRB class]]) {
                        if (((PlayerRB*)b).gamesPlayed > 0) {
                            bYPG = (int)ceil((double) ((PlayerRB*)b).statsRushYards/(double) ((PlayerRB*)b).gamesPlayed);
                        }
                    } else {
                        bYPG = 0;
                    }


                    return (aYPG > bYPG) ? -1 : ((aYPG == bYPG) ? [a.name compare:b.name] : 1);
                } else {
                    return [a.name compare:b.name];
                }
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Touchdowns" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                Player *a = (Player*)obj1;
                Player *b = (Player*)obj2;
                if (([a isKindOfClass:[PlayerQB class]] || [a isKindOfClass:[PlayerRB class]]) && ([b isKindOfClass:[PlayerQB class]] || [b isKindOfClass:[PlayerRB class]])) {
                    int aTD = 0;
                    int bTD = 0;

                    if ([a isKindOfClass:[PlayerQB class]]) {
                        aTD = ((PlayerQB*)a).statsRushTD;
                    } else if ([a isKindOfClass:[PlayerRB class]]) {
                        aTD = ((PlayerRB*)a).statsTD;
                    } else {
                        aTD = 0;
                    }

                    if ([b isKindOfClass:[PlayerQB class]]) {
                        bTD = ((PlayerQB*)b).statsRushTD;
                    } else if ([b isKindOfClass:[PlayerRB class]]) {
                        bTD = ((PlayerRB*)b).statsTD;
                    } else {
                        bTD = 0;
                    }

                    return (aTD > bTD) ? -1 : ((aTD == bTD) ? [a.name compare:b.name] : 1);
                } else {
                    return [a.name compare:b.name];
                }
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Fumbles" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                Player *a = (Player*)obj1;
                Player *b = (Player*)obj2;
                if (([a isKindOfClass:[PlayerQB class]] || [a isKindOfClass:[PlayerRB class]]) && ([b isKindOfClass:[PlayerQB class]] || [b isKindOfClass:[PlayerRB class]])) {
                    int aFumbles = 0;
                    int bFumbles = 0;
                    if ([a isKindOfClass:[PlayerQB class]]) {
                        aFumbles = ((PlayerQB*)a).statsFumbles;
                    } else if ([a isKindOfClass:[PlayerRB class]]) {
                        aFumbles = ((PlayerRB*)a).statsFumbles;
                    } else {
                        aFumbles = 0;
                    }

                    if ([b isKindOfClass:[PlayerQB class]]) {
                        bFumbles = ((PlayerQB*)b).statsFumbles;
                    } else if ([b isKindOfClass:[PlayerRB class]]) {
                        bFumbles = ((PlayerRB*)b).statsFumbles;
                    } else {
                        bFumbles = 0;
                    }

                    return (aFumbles > bFumbles) ? -1 : ((aFumbles == bFumbles) ? [a.name compare:b.name] : 1);
                } else {
                    return [a.name compare:b.name];
                }
            }];
            [self.tableView reloadData];
        }]];
    } else if (position == HBStatPositionWR) { //Yds, rec, YPG, TD, Fum
        [alertController addAction:[UIAlertAction actionWithTitle:@"Receiving Yards" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerWR *a = (PlayerWR*)obj1;
                PlayerWR *b = (PlayerWR*)obj2;
                return (a.statsRecYards > b.statsRecYards) ? -1 : ((a.statsRecYards == b.statsRecYards) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Receptions" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerWR *a = (PlayerWR*)obj1;
                PlayerWR *b = (PlayerWR*)obj2;
                return (a.statsReceptions > b.statsReceptions) ? -1 : ((a.statsReceptions == b.statsReceptions) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Yards per Catch" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerWR *a = (PlayerWR*)obj1;
                PlayerWR *b = (PlayerWR*)obj2;
                int aYPA = 0;
                if (a.statsReceptions > 0) {
                    aYPA = (int)ceil((double)a.statsRecYards/(double)a.statsReceptions);
                }

                int bYPA = 0;
                if (b.statsReceptions > 0) {
                    bYPA = (int)ceil((double)b.statsRecYards/(double)b.statsReceptions);
                }

                return (aYPA > bYPA) ? -1 : ((aYPA == bYPA) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Yards per Game" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerWR *a = (PlayerWR*)obj1;
                PlayerWR *b = (PlayerWR*)obj2;
                int aYPG = 0;
                if (a.gamesPlayed > 0) {
                    aYPG = (int)ceil((double)a.statsRecYards/(double)a.gamesPlayed);
                }

                int bYPG = 0;
                if (b.gamesPlayed > 0) {
                    bYPG = (int)ceil((double)b.statsRecYards/(double)b.gamesPlayed);
                }

                return (aYPG > bYPG) ? -1 : ((aYPG == bYPG) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Touchdowns" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerWR *a = (PlayerWR*)obj1;
                PlayerWR *b = (PlayerWR*)obj2;
                return (a.statsTD > b.statsTD) ? -1 : ((a.statsTD == b.statsTD) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Fumbles" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerWR *a = (PlayerWR*)obj1;
                PlayerWR *b = (PlayerWR*)obj2;
                return (a.statsFumbles > b.statsFumbles) ? -1 : ((a.statsFumbles == b.statsFumbles) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];
    } else if (position == HBStatPositionK) { //K - FG%, XP%
        [alertController addAction:[UIAlertAction actionWithTitle:@"Field Goal Percentage" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerK *a = (PlayerK *)obj1;
                PlayerK *b = (PlayerK *)obj2;

                int aFgPercent = 0;
                if (a.statsFGAtt > 0) {
                    aFgPercent = (int)(100.0*((double)a.statsFGMade/(double)a.statsFGAtt));
                }

                int bFgPercent = 0;
                if (b.statsFGAtt > 0) {
                    bFgPercent = (int)(100.0*((double)b.statsFGMade/(double)b.statsFGAtt));
                }

                return (aFgPercent > bFgPercent) ? -1 : ((aFgPercent == bFgPercent) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Extra Point Percentage" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerK *a = (PlayerK *)obj1;
                PlayerK *b = (PlayerK *)obj2;

                int aXpPercent = 0;
                if (a.statsXPAtt > 0) {
                    aXpPercent = (int)(100.0*((double)a.statsXPMade/(double)a.statsXPAtt));
                }

                int bXpPercent = 0;
                if (b.statsXPAtt > 0) {
                    bXpPercent = (int)(100.0*((double)b.statsXPMade/(double)b.statsXPAtt));
                }

                return (aXpPercent > bXpPercent) ? -1 : ((aXpPercent == bXpPercent) ? [a.name compare:b.name] : 1);
            }];
            [self.tableView reloadData];
        }]];

    } else if (position == HBStatPositionDEF) { //def --> tkl, pass def, INT, forced fum, sacks
        [alertController addAction:[UIAlertAction actionWithTitle:@"Tackles" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerDefender *a = (PlayerDefender *)obj1;
                PlayerDefender *b = (PlayerDefender *)obj2;
                
                return (a.statsTkl > b.statsTkl) ? -1 : ((a.statsTkl == b.statsTkl) ? 0 : 1);
            }];
            [self.tableView reloadData];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Passes Defended" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerDefender *a = (PlayerDefender *)obj1;
                PlayerDefender *b = (PlayerDefender *)obj2;
                
                return (a.statsPassDef > b.statsPassDef) ? -1 : ((a.statsPassDef == b.statsPassDef) ? 0 : 1);
            }];
            [self.tableView reloadData];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Interceptions" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerDefender *a = (PlayerDefender *)obj1;
                PlayerDefender *b = (PlayerDefender *)obj2;
                
                return (a.statsInt > b.statsInt) ? -1 : ((a.statsInt == b.statsInt) ? 0 : 1);
            }];
            [self.tableView reloadData];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Sacks" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerDefender *a = (PlayerDefender *)obj1;
                PlayerDefender *b = (PlayerDefender *)obj2;
                
                return (a.statsSacks > b.statsSacks) ? -1 : ((a.statsSacks == b.statsSacks) ? 0 : 1);
            }];
            [self.tableView reloadData];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Forced Fumbles" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                PlayerDefender *a = (PlayerDefender *)obj1;
                PlayerDefender *b = (PlayerDefender *)obj2;
                
                return (a.statsForcedFum > b.statsForcedFum) ? -1 : ((a.statsForcedFum == b.statsForcedFum) ? 0 : 1);
            }];
            [self.tableView reloadData];
        }]];
    } else { // HC - total wins, NCs, CCs, COTYs
        [alertController addAction:[UIAlertAction actionWithTitle:@"Career Wins" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalWins > b.totalWins) ? -1 : ((a.totalWins == b.totalWins) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatTotalWins;
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"National Championships" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalNCs > b.totalNCs) ? -1 : ((a.totalNCs == b.totalNCs) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatNatlChamps;
            self.title = @"National Championships Won";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Championships" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalCCs > b.totalCCs) ? -1 : ((a.totalCCs == b.totalCCs) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatConfChamps;
            self.title = @"Conference Championships Won";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Wins" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalBowls > b.totalBowls) ? -1 : ((a.totalBowls == b.totalBowls) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatBowlWins;
            self.title = @"Bowls Won";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Rivalry Wins" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalRivalryWins > b.totalRivalryWins) ? -1 : ((a.totalRivalryWins == b.totalRivalryWins) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatRivalryWins;
            self.title = @"Rivalry Games Won";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Coach of the Year Awards" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.careerCOTYs > b.careerCOTYs) ? -1 : ((a.careerCOTYs == b.careerCOTYs) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatCOTYs;
            self.title = @"Coach of the Year Awards Won";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conf Coach of the Year Awards" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.careerConfCOTYs > b.careerConfCOTYs) ? -1 : ((a.careerConfCOTYs == b.careerConfCOTYs) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatConfCOTYs;
            self.title = @"Conf COTY Awards Won";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Players Drafted" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.careerDraftPicks > b.careerDraftPicks) ? -1 : ((a.careerDraftPicks == b.careerDraftPicks) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatPlayersDrafted;
            self.title = @"Players Drafted";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTYs Coached" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalHeismans > b.totalHeismans) ? -1 : ((a.totalHeismans == b.totalHeismans) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatPOTYsCoached;
            self.title = @"POTYs Coached";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"All-League Players Coached" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalAllAmericans > b.totalAllAmericans) ? -1 : ((a.totalAllAmericans == b.totalAllAmericans) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatAllLeaguePlayersCoached;
            self.title = @"All-League Players Coached";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"All-Conference Players Coached" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalAllConferences > b.totalAllConferences) ? -1 : ((a.totalAllConferences == b.totalAllConferences) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatAllConfPlayersCoached;
            self.title = @"All-Conference Players Coached";
            [self.tableView reloadData];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"ROTYs Coached" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                HeadCoach *a = (HeadCoach *)obj1;
                HeadCoach *b = (HeadCoach *)obj2;
                
                return (a.totalROTYs > b.totalROTYs) ? -1 : ((a.totalROTYs == b.totalROTYs) ? 0 : 1);
            }];
            self->hcStatType = FCHeadCoachStatROTYsCoached;
            self.title = @"ROTYs Coached";
            [self.tableView reloadData];
        }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return MIN(players.count, 10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBPlayerCell *statsCell = (HBPlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"HBPlayerCell"];
    Player *plyr = players[indexPath.row];
    NSString *stat1 = @"";
    NSString *stat2 = @"";
    NSString *stat3 = @"";
    NSString *stat4 = @"";

    NSString *stat1Value = @"";
    NSString *stat2Value = @"";
    NSString *stat3Value = @"";
    NSString *stat4Value = @"";

    if (position == HBStatPositionQB) {
        stat1 = @"CMP%"; //comp/att, yds, td, int
        stat2 = @"Yds";
        stat3 = @"TDs";
        stat4 = @"INTs";
        int compPct = (((PlayerQB*)plyr).statsPassAtt > 0) ? (100 * ((PlayerQB*)plyr).statsPassComp/((PlayerQB*)plyr).statsPassAtt) : 0;

        stat1Value = [NSString stringWithFormat:@"%d%%",compPct];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsPassYards];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsTD];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsInt];
        //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:13.0]];
    } else if (position == HBStatPositionRB) {
        stat1 = @"Car";
        stat2 = @"Yds";
        stat3 = @"TD";
        stat4 = @"Fum";
        if ([plyr isKindOfClass:[PlayerQB class]]) {
            stat1Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsRushAtt];
            stat2Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsRushYards];
            stat3Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsRushTD];
            stat4Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsFumbles];
        } else {
            stat1Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsRushAtt];
            stat2Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsRushYards];
            stat3Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsTD];
            stat4Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsFumbles];
        }
        //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    } else if (position == HBStatPositionWR) {
        stat1 = @"Rec";
        stat2 = @"Yds";
        stat3 = @"TD";
        stat4 = @"Fum";
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsReceptions];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsRecYards];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsTD];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsFumbles];
        //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    } else if (position == HBStatPositionK)  { //PlayerK class
        stat1 = @"XPM";
        stat2 = @"XPA";
        stat3 = @"FGM";
        stat4 = @"FGA";

        stat1Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsXPMade];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsXPAtt];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsFGMade];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsFGAtt];
    } else if ([plyr isKindOfClass:[PlayerDefender class]]) { // any defender
        if ([plyr isKindOfClass:[PlayerDL class]]) {
            stat1 = @"Tkl";
            stat2 = @"Sck";
            stat3 = @"FFum";
            stat4 = @"PsDef";

            stat1Value = [NSString stringWithFormat:@"%d",((PlayerDL*)plyr).statsTkl];
            stat2Value = [NSString stringWithFormat:@"%d",((PlayerDL*)plyr).statsSacks];
            stat3Value = [NSString stringWithFormat:@"%d",((PlayerDL*)plyr).statsForcedFum];
            stat4Value = [NSString stringWithFormat:@"%d",((PlayerDL*)plyr).statsPassDef];
        } else if ([plyr isKindOfClass:[PlayerLB class]]) {
            stat1 = @"Tkl";
            stat2 = @"Sck";
            stat3 = @"FFum";
            stat4 = @"PsDef";

            stat1Value = [NSString stringWithFormat:@"%d",((PlayerLB*)plyr).statsTkl];
            stat2Value = [NSString stringWithFormat:@"%d",((PlayerLB*)plyr).statsSacks];
            stat3Value = [NSString stringWithFormat:@"%d",((PlayerLB*)plyr).statsForcedFum];
            stat4Value = [NSString stringWithFormat:@"%d",((PlayerLB*)plyr).statsPassDef];
        } else if ([plyr isKindOfClass:[PlayerCB class]]) {
            stat1 = @"Tkl";
            stat2 = @"INT";
            stat3 = @"FFum";
            stat4 = @"PsDef";

            stat1Value = [NSString stringWithFormat:@"%d",((PlayerCB*)plyr).statsTkl];
            stat2Value = [NSString stringWithFormat:@"%d",((PlayerCB*)plyr).statsInt];
            stat3Value = [NSString stringWithFormat:@"%d",((PlayerCB*)plyr).statsForcedFum];
            stat4Value = [NSString stringWithFormat:@"%d",((PlayerCB*)plyr).statsPassDef];
        } else if ([plyr isKindOfClass:[PlayerS class]]) {
            stat1 = @"Tkl";
            stat2 = @"INT";
            stat3 = @"FFum";
            stat4 = @"PsDef";

            stat1Value = [NSString stringWithFormat:@"%d",((PlayerS*)plyr).statsTkl];
            stat2Value = [NSString stringWithFormat:@"%d",((PlayerS*)plyr).statsInt];
            stat3Value = [NSString stringWithFormat:@"%d",((PlayerS*)plyr).statsForcedFum];
            stat4Value = [NSString stringWithFormat:@"%d",((PlayerS*)plyr).statsPassDef];
        }
    } else { //if ([plyr isKindOfClass:[HeadCoach Class]]) {
        stat3 = @"Age";
        stat4 = @"OVR";
        stat1 = @"";
        
        stat3Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).age];
        stat4Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).ratOvr];
        stat1Value = @""; //[NSString stringWithFormat:@"%d",((HeadCoach*)plyr).careerCOTYs];
        
        if (hcStatType == FCHeadCoachStatTotalWins) {
            stat2 = @"Wins"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalWins];
        } else if (hcStatType == FCHeadCoachStatNatlChamps) {
            stat2 = @"NCs"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalNCs];
        } else if (hcStatType == FCHeadCoachStatConfChamps) {
            stat2 = @"CCs"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalCCs];
        } else if (hcStatType == FCHeadCoachStatBowlWins) {
            stat2 = @"BWins"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalBowls];
        } else if (hcStatType == FCHeadCoachStatRivalryWins) {
            stat2 = @"RWins"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalRivalryWins];
        } else if (hcStatType == FCHeadCoachStatCOTYs) {
            stat2 = @"COTYs"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).careerCOTYs];
        } else if (hcStatType == FCHeadCoachStatConfCOTYs) {
            stat2 = @"COTYs"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).careerConfCOTYs];
        } else if (hcStatType == FCHeadCoachStatPOTYsCoached) {
            stat2 = @"POTYs"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalHeismans];
        } else if (hcStatType == FCHeadCoachStatAllLeaguePlayersCoached) {
            stat2 = @"ALL"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalAllAmericans];
        } else if (hcStatType == FCHeadCoachStatAllConfPlayersCoached) {
            stat2 = @"ALL"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalAllConferences];
        } else if (hcStatType == FCHeadCoachStatROTYsCoached) {
            stat2 = @"ROTYs"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).totalROTYs];
        } else if (hcStatType == FCHeadCoachStatPlayersDrafted) {
            stat2 = @"DRFT"; //stat
            stat2Value = [NSString stringWithFormat:@"%d",((HeadCoach*)plyr).careerDraftPicks];
        } else {
            stat2 = @""; //stat
            stat2Value = @"";
        }
    }


    [statsCell.playerLabel setText:[plyr getInitialName]];
    if (position != HBStatPositionHC) {
        [statsCell.teamLabel setText:[NSString stringWithFormat:@"%@ %@", plyr.team.abbreviation, plyr.position]];
    } else {
        [statsCell.teamLabel setText:plyr.team.abbreviation];
    }

    if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [statsCell.teamLabel.text containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [statsCell.playerLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        if ([HBSharedUtils currentLeague].currentWeek > 14 && heisman != nil && roty != nil && coty != nil) {
            if ([heisman isEqual:plyr] || [roty isEqual:plyr] || [coty isEqual:plyr]) {
                [statsCell.playerLabel setTextColor:[HBSharedUtils champColor]];
            } else {
                [statsCell.playerLabel setTextColor:[UIColor blackColor]];
            }
        } else {
            [statsCell.playerLabel setTextColor:[UIColor blackColor]];
        }
    }

    [statsCell.stat1Label setText:stat1];
    [statsCell.stat1ValueLabel setText:stat1Value];
    [statsCell.stat2Label setText:stat2];
    [statsCell.stat2ValueLabel setText:stat2Value];
    [statsCell.stat3Label setText:stat3];
    [statsCell.stat3ValueLabel setText:stat3Value];
    [statsCell.stat4Label setText:stat4];
    [statsCell.stat4ValueLabel setText:stat4Value];

    return statsCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (position == HBStatPositionHC) {
        HeadCoach *p = players[indexPath.row];
        [self.navigationController pushViewController:[[HeadCoachDetailViewController alloc] initWithCoach:p] animated:YES];
    } else {
        Player *p = players[indexPath.row];
        if ([p.position isEqualToString:@"QB"]) {
            [self.navigationController pushViewController:[[PlayerQBDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"RB"]) {
            [self.navigationController pushViewController:[[PlayerRBDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"WR"]) {
            [self.navigationController pushViewController:[[PlayerWRDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"TE"]) {
            [self.navigationController pushViewController:[[PlayerTEDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"OL"]) {
            [self.navigationController pushViewController:[[PlayerOLDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"DL"]) {
            [self.navigationController pushViewController:[[PlayerDLDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"LB"]) {
            [self.navigationController pushViewController:[[PlayerLBDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"CB"]) {
            [self.navigationController pushViewController:[[PlayerCBDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"S"]) {
            [self.navigationController pushViewController:[[PlayerSDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else if ([p.position isEqualToString:@"K"]) {
            [self.navigationController pushViewController:[[PlayerKDetailViewController alloc] initWithPlayer:p] animated:YES];
        } else {
            [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:p] animated:YES];
        }
    }
}


@end
