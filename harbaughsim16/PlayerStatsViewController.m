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
#import "PlayerCB.h"
#import "PlayerS.h"
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

@interface PlayerStatsViewController () <UIViewControllerPreviewingDelegate>
{
    NSMutableArray *players;
    HBStatPosition position;
    Player *heisman;
    
}
@end

@implementation PlayerStatsViewController
-(instancetype)initWithStatType:(HBStatPosition)type {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        position = type;
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
        Player *p = players[indexPath.row];
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
        playerDetail.preferredContentSize = CGSizeMake(0.0, 600);
        previewingContext.sourceRect = cell.frame;
        return playerDetail;
    } else {
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    heisman = [[HBSharedUtils currentLeague] heisman];
    
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
    } else {
        self.title = @"Kicking Leaders";
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
            [players addObjectsFromArray:t.teamKs];
        }
        [self->players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            PlayerK *a = (PlayerK*)obj1;
            PlayerK *b = (PlayerK*)obj2;
            return ([a getHeismanScore] > [b getHeismanScore]) ? -1 : (([a getHeismanScore] == [b getHeismanScore]) ? [a.name compare:b.name] : 1);
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
    } else { //K - FG%, XP%
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
    return 10;
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
    } else { //PlayerK class
        stat1 = @"XPM";
        stat2 = @"XPA";
        stat3 = @"FGM";
        stat4 = @"FGA";
        
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsXPMade];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsXPAtt];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsFGMade];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsFGAtt];
    }
    
    
    [statsCell.playerLabel setText:[plyr getInitialName]];
    [statsCell.teamLabel setText:plyr.team.abbreviation];
    
    if ([statsCell.teamLabel.text containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [statsCell.playerLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        if ([HBSharedUtils currentLeague].currentWeek > 14 && heisman != nil) {
            if ([heisman isEqual:plyr]) {
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


@end
