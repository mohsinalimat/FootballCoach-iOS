//
//  UpcomingViewController.m
//  profootballcoach
//
//  Created by Akshay Easwaran on 3/16/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "UpcomingViewController.h"

#import "HBSharedUtils.h"
#import "Team.h"
#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerCB.h"
#import "Game.h"
#import "HBScoreCell.h"
#import "Conference.h"

#import "HeismanLeadersViewController.h"
#import "BowlProjectionViewController.h"
#import "RankingsViewController.h"
#import "AllLeagueTeamViewController.h"
#import "ConferenceStandingsSelectorViewController.h"
#import "ConferenceStandingsViewController.h"
#import "HBTeamPlayView.h"
#import "GameDetailViewController.h"
#import "PlayerStatsViewController.h"

#import "CSNotificationView.h"
#import "HexColors.h"
#import "STPopup.h"
#import "UIScrollView+EmptyDataSet.h"

@interface UpcomingViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    PlayerQB *passLeader;
    PlayerRB *rushLeader;
    PlayerWR *recLeader;
    Team *defLeader;
    PlayerK *kickLeader;
    Team *userTeam;
    IBOutlet HBTeamPlayView *teamHeaderView;
    STPopupController *popupController;
    Game *lastGame;
    Game *nextGame;
}
@end

@implementation UpcomingViewController

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)runOnSaveInProgress {
    [teamHeaderView.playButton setEnabled:NO];
}

-(void)runOnSaveFinished {
    [teamHeaderView.playButton setEnabled:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupTeamHeader];
}


-(void)simulateEntireSeason {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to sim this season?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self simSeason:16]; - to offseason
            //[self simSeason:12]; - to ccg week
            //[self simSeason:13]; - to bowl week
            //[self simSeason:6]; - to mid season
            //[self playWeek:nil]; - next week
            int curWeek = [HBSharedUtils getLeague].currentWeek;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sim to a specific point" message:@"When in the season do you want to sim to?" preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Next Week" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self playWeek:nil];
            }]];
            
            if (curWeek < 6) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Midseason" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self simSeason:(6 - curWeek)];
                }]];
            }
            
            if (curWeek < 12) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Championship Week" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self simSeason:(12 - curWeek)];
                }]];
            }
            
            if (curWeek < 13) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Week" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self simSeason:(13 - curWeek)];
                }]];
            }
            
            if (curWeek < 16) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Offseason" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self simSeason:(16 - curWeek)];
                }]];
            }
            
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)simSeason:(NSInteger)weekTotal {
    [HBSharedUtils simulateEntireSeason:(int)weekTotal viewController:self headerView:teamHeaderView callback:^{
        if ([HBSharedUtils getLeague].currentWeek <= 15) {
            [self.tableView reloadData];
        }
        [self setupTeamHeader];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
    }];
}

-(void)resetSimButton {
    if ([HBSharedUtils getLeague].currentWeek < 16) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2017 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
}

-(void)hideSimButton {
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

-(IBAction)playWeek:(id)sender {
    [HBSharedUtils playWeek:self headerView:teamHeaderView callback:^{
        [self.tableView reloadData];
        [self setupTeamHeader];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
    }];
}

-(void)viewResultsOptions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"News Options" message:@"What would you like to view?" preferredStyle:UIAlertControllerStyleActionSheet];
    if ([HBSharedUtils getLeague].currentWeek == 15) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Final Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTY Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            [popupController presentInViewController:self];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"All-Pro Team" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[AllLeagueTeamViewController alloc] init] animated:YES];
        }]];
    } else if ([HBSharedUtils getLeague].currentWeek == 14) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Current Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTY Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            [popupController presentInViewController:self];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"All-American Team" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[AllLeagueTeamViewController alloc] init] animated:YES];
        }]];
    } else if ([HBSharedUtils getLeague].currentWeek == 13) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Current Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Schedule" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTY Leaders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            [popupController presentInViewController:self];
        }]];
        
    } else if ([HBSharedUtils getLeague].currentWeek > 6) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Current Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Projections" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTY Leaders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            [popupController presentInViewController:self];
        }]];
        
    } else {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Current Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            [popupController presentInViewController:self];
        }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)pushToConfStandings:(NSNotification*)confNotification {
    Conference *div = (Conference*)[confNotification object];
    //delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[[ConferenceStandingsViewController alloc] initWithConference:div] animated:YES];
    });
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self setupTeamHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTeamHeader {
    if (!userTeam) {
        [teamHeaderView.teamRankLabel setText:@" "];
        userTeam = [HBSharedUtils getLeague].userTeam;
    }
    userTeam = [HBSharedUtils getLeague].userTeam;
    if (userTeam) {
        NSString *rank = @"";
        if ([HBSharedUtils getLeague].currentWeek > 0 && userTeam.rankTeamPollScore < 26 && userTeam.rankTeamPollScore > 0) {
            rank = [NSString stringWithFormat:@"#%ld ",(long)userTeam.rankTeamPollScore];
        }
        [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, userTeam.name]];
        [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)(2017 + userTeam.teamHistoryDictionary.count),(long)userTeam.wins,(long)userTeam.losses]];
    } else {
        [teamHeaderView.teamRankLabel setText:@""];
        [teamHeaderView.teamRecordLabel setText:@"0-0"];
    }
    [teamHeaderView.playButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    
    
    League *simLeague = [HBSharedUtils getLeague];
    if (simLeague.currentWeek < 12) {
        [HBSharedUtils getLeague].canRebrandTeam = NO;
        [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 12) {
        [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 13) {
        [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 14) {
        [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
    } else {
        [HBSharedUtils getLeague].canRebrandTeam = YES;
        [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
    }
    
    if ([HBSharedUtils getLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils getLeague].userTeam.gameSchedule.count >= [HBSharedUtils getLeague].currentWeek) {
        if ([HBSharedUtils getLeague].currentWeek > 12) {
            //NSLog(@"checking for bye");
            nextGame = [userTeam.gameSchedule lastObject];
            lastGame = userTeam.gameSchedule[[HBSharedUtils getLeague].currentWeek - 1];
        } else {
            lastGame = userTeam.gameSchedule[[HBSharedUtils getLeague].currentWeek - 1];
            nextGame = userTeam.gameSchedule[[HBSharedUtils getLeague].currentWeek];
            //NSLog(@"Last game and next game normal");
        }
    } else if (userTeam.gameSchedule.lastObject.hasPlayed) {
        lastGame = ([HBSharedUtils getLeague].currentWeek > 12 ? userTeam.gameSchedule.lastObject : userTeam.gameSchedule[[HBSharedUtils getLeague].currentWeek - 1]);
        nextGame = nil;
        //NSLog(@"Last game only");
    } else {
        lastGame = nil;
        nextGame = userTeam.gameSchedule[[HBSharedUtils getLeague].currentWeek];
        //NSLog(@"Next game only");
    }
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        [self.navigationController.tabBarController.tabBar.items[1] setBadgeColor:[HBSharedUtils champColor]];
    }
    
    if (!nextGame) {
        [self.navigationController.tabBarController.tabBar.items[1] setBadgeValue:nil];
    }
//    } else if (!nextGame.hasPlayed) {
//        NSString *weekGameName = nextGame.gameName;
//        if ([weekGameName isEqualToString:@"Champs Bowl"]) {
//            [self.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"ChBwl"];
//        } else if ([weekGameName containsString:@"Div Rd"]) {
//            [self.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"Div"];
//        } else if ([weekGameName containsString:@"WC Rd"]) {
//            [self.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"WC"];
//        } else if ([weekGameName containsString:@"CCG"]) {
//            [self.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"CCG"];
//        }
//    } else if ([HBSharedUtils getLeague].currentWeek == 16) {
////        if (![[HBSharedUtils getLeague].playoffsAM containsObject:[HBSharedUtils getLeague].userTeam] && ![[HBSharedUtils getLeague].playoffsNA containsObject:[HBSharedUtils getLeague].userTeam]) {
////            [self.navigationController.tabBarController.tabBar.items[1] setBadgeValue:nil];
////        } else {
//            [self.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"Div"];
//        //}
//    }
    
    NSMutableArray *qbs = [NSMutableArray array];
    NSMutableArray *ks = [NSMutableArray array];
    NSMutableArray *rbs = [NSMutableArray array];
    NSMutableArray *wrs = [NSMutableArray array];
    for (Team *t in simLeague.teamList) {
        [qbs addObjectsFromArray:t.teamQBs];
        [rbs addObjectsFromArray:t.teamRBs];
        [wrs addObjectsFromArray:t.teamWRs];
        [ks addObjectsFromArray:t.teamKs];
    }
    
    [qbs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerQB *a = (PlayerQB*)obj1;
        PlayerQB *b = (PlayerQB*)obj2;
        return (a.statsPassYards > b.statsPassYards) ? -1 : ((a.statsPassYards == b.statsPassYards) ? [a.name compare:b.name] : 1);
    }];
    [rbs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerRB *a = (PlayerRB*)obj1;
        PlayerRB *b = (PlayerRB*)obj2;
        return (a.statsRushYards > b.statsRushYards) ? -1 : ((a.statsRushYards == b.statsRushYards) ? [a.name compare:b.name] : 1);
    }];
    [wrs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerWR *a = (PlayerWR*)obj1;
        PlayerWR *b = (PlayerWR*)obj2;
        return (a.statsRecYards > b.statsRecYards) ? -1 : ((a.statsRecYards == b.statsRecYards) ? [a.name compare:b.name] : 1);
    }];
    [ks sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerK *a = (PlayerK*)obj1;
        PlayerK *b = (PlayerK*)obj2;
        return ([a getHeismanScore] > [b getHeismanScore]) ? -1 : (([a getHeismanScore] == [b getHeismanScore]) ? [a.name compare:b.name] : 1);
    }];
    
    NSMutableArray *teams = [[HBSharedUtils getLeague].teamList mutableCopy];
    [teams sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareOppYPG:obj1 toObj2:obj2];
    }];
    
    
    passLeader = [qbs firstObject];
    rushLeader = [rbs firstObject];
    recLeader = [wrs firstObject];
    kickLeader = [ks firstObject];
    defLeader = [teams firstObject];
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScoreCell" bundle:nil] forCellReuseIdentifier:@"HBScoreCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"triline"] style:UIBarButtonItemStylePlain target:self action:@selector(viewResultsOptions)];
    
    self.navigationItem.title = @"Latest News";
  
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    self.tableView.tableHeaderView = teamHeaderView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2017 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
    if ([HBSharedUtils getLeague].currentWeek < 15) {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"newNewsStory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSimButton) name:@"hideSimButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSaveFile" object:nil];
    self.view.backgroundColor = [HBSharedUtils styleColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"flippedFromOnline" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToConfStandings:) name:@"pushToConfStandings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runOnSaveInProgress) name:@"saveInProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runOnSaveFinished) name:@"saveFinished" object:nil];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    if ([HBSharedUtils getLeague].currentWeek != 16) {
        if ([HBSharedUtils getLeague].userTeam.injuredPlayers.count > 0) {
            [self.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%lu", (long)[HBSharedUtils getLeague].userTeam.injuredPlayers.count];
        } else {
            [self.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
        }
    }
}

-(void)refreshView {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (![HBSharedUtils getLeague].userTeam.gameSchedule.firstObject.hasPlayed) {
        return 1;
    } else if ([HBSharedUtils getLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([HBSharedUtils getLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils getLeague].userTeam.gameSchedule.count >= [HBSharedUtils getLeague].currentWeek) {
        if (section == 0) {
            return 3;
        } else if (section == 1) {
            return 3;
        } else {
            return 5; //5;
        }
    } else {
        if (section == 0) {
            return 3;
        } else {
            return 5; //5;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([HBSharedUtils getLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils getLeague].userTeam.gameSchedule.count >= [HBSharedUtils getLeague].currentWeek) {
        if (section == 0) {
            return @"Last Game";
        } else if (section == 1) {
            return @"Next Game";
        } else {
            return @"League Leaders";
        }
    } else if ([HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (section == 0) {
            return @"Last Game";
        } else {
            return @"League Leaders";
        }
    } else {
        if (section == 0) {
            return @"Next Game";
        } else {
            return @"League Leaders";
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([HBSharedUtils getLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (indexPath.section == 2) {
            return 50;
        } else {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        } else {
            return 50;
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 48;
    } else {
        return 36;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([HBSharedUtils getLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils getLeague].userTeam.gameSchedule.count >= [HBSharedUtils getLeague].currentWeek) {
        if (indexPath.section == 0) {
            Game *bowl = lastGame;
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if ([HBSharedUtils getLeague].currentWeek > 0 && bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,bowl.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
                    if (bowl.homeScore < bowl.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([bowl.awayTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                            [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                        } else {
                            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                            [cell.scoreLabel setTextColor:[UIColor blackColor]];
                        }
                    }
                } else {
                    NSString *homeRank = @"";
                    if ([HBSharedUtils getLeague].currentWeek > 0 && bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank, bowl.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
                    if (bowl.homeScore > bowl.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([bowl.homeTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                            [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                        } else {
                            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                            [cell.scoreLabel setTextColor:[UIColor blackColor]];
                        }
                    }
                }
                return cell;
                
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
                    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                    [cell.textLabel setTextColor:self.view.tintColor];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
                }
                
                if (bowl.hasPlayed) {
                    [cell.textLabel setText:@"View Game"];
                } else {
                    [cell.textLabel setText:@"Preview Matchup"];
                }
                return cell;
            }
        } else if (indexPath.section == 1) {
            Game *bowl = nextGame;
            //handle case where next game isn't the next week
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if ([HBSharedUtils getLeague].currentWeek > 0 && bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank, bowl.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
                    if ([bowl.awayTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                    } else {
                        [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                        [cell.scoreLabel setTextColor:[UIColor blackColor]];
                    }
                } else {
                    NSString *homeRank = @"";
                    if ([HBSharedUtils getLeague].currentWeek > 0 && bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,bowl.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
                    if ([bowl.homeTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                    } else {
                        [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                        [cell.scoreLabel setTextColor:[UIColor blackColor]];
                    }
                }
                return cell;
                
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
                    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                    [cell.textLabel setTextColor:self.view.tintColor];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
                }
                
                if (bowl.hasPlayed) {
                    [cell.textLabel setText:@"View Game"];
                } else {
                    [cell.textLabel setText:@"Preview Matchup"];
                }
                return cell;
            }
        } else {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NewsCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
                
            }
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Passing";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ QB %@", passLeader.team.abbreviation, [passLeader getInitialName]]];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Rushing";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ RB %@", rushLeader.team.abbreviation, [rushLeader getInitialName]]];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Receiving";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ WR %@", recLeader.team.abbreviation, [recLeader getInitialName]]];
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"Defense";
                cell.detailTextLabel.text = defLeader.name;
            } else {
                cell.textLabel.text = @"Kicking";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ K %@", kickLeader.team.abbreviation, [kickLeader getInitialName]]];
            }
            
            if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            }
            
            return cell;
        }
    } else if ([HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (indexPath.section == 0) {
            Game *bowl = lastGame;
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if ([HBSharedUtils getLeague].currentWeek > 0 && bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,bowl.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
                    if (bowl.homeScore < bowl.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([bowl.awayTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                            [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                        } else {
                            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                            [cell.scoreLabel setTextColor:[UIColor blackColor]];
                        }
                    }
                } else {
                    NSString *homeRank = @"";
                    if ([HBSharedUtils getLeague].currentWeek > 0 && bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,bowl.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
                    if (bowl.homeScore > bowl.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([bowl.homeTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                            [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                        } else {
                            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                            [cell.scoreLabel setTextColor:[UIColor blackColor]];
                        }
                    }
                }
                return cell;
                
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
                    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                    [cell.textLabel setTextColor:self.view.tintColor];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
                }
                
                if (bowl.hasPlayed) {
                    [cell.textLabel setText:@"View Game"];
                } else {
                    [cell.textLabel setText:@"Preview Matchup"];
                }
                return cell;
            }
        } else {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"NewsCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
                
            }
            
            if (indexPath.row == 0) {
                cell.textLabel.text = @"Passing";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ QB %@", passLeader.team.abbreviation, [passLeader getInitialName]]];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Rushing";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ RB %@", rushLeader.team.abbreviation, [rushLeader getInitialName]]];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Receiving";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ WR %@", recLeader.team.abbreviation, [recLeader getInitialName]]];
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"Defense";
                cell.detailTextLabel.text = defLeader.name;
            } else {
                cell.textLabel.text = @"Kicking";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ K %@", kickLeader.team.abbreviation, [kickLeader getInitialName]]];
            }
            
            if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            }
            
            return cell;
        }
    } else {
        Game *bowl = nextGame;
        if (indexPath.row == 0 || indexPath.row == 1) {
            HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                NSString *awayRank = @"";
                if ([HBSharedUtils getLeague].currentWeek > 0 && bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                    awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
                }
                [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,bowl.awayTeam.name]];
                [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
                [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
                if ([bowl.awayTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                    [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                    [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                    [cell.scoreLabel setTextColor:[UIColor blackColor]];
                }
            } else {
                NSString *homeRank = @"";
                if ([HBSharedUtils getLeague].currentWeek > 0 && bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                    homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
                }
                [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,bowl.homeTeam.name]];
                [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
                [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
                if ([bowl.homeTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                    [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                    [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                    [cell.scoreLabel setTextColor:[UIColor blackColor]];
                }
            }
            return cell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setTextColor:self.view.tintColor];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
            }
            
            if (bowl.hasPlayed) {
                [cell.textLabel setText:@"View Game"];
            } else {
                [cell.textLabel setText:@"Preview Matchup"];
            }
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([HBSharedUtils getLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils getLeague].userTeam.gameSchedule.count >= [HBSharedUtils getLeague].currentWeek) {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:lastGame] animated:YES];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:nextGame] animated:YES];
            }
        } else {
            //return @"League Leaders";
            if (indexPath.row == 0) { //QB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionQB] animated:YES];
            } else if (indexPath.row == 1) { //RB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionRB] animated:YES];
            } else if (indexPath.row == 2) { //WR
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionWR] animated:YES];
            } else if (indexPath.row == 3) { //DEF
                RankingsViewController *def = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppYPG];
                def.title = @"Defense";
                [self.navigationController pushViewController:def animated:YES];
            } else { //K
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionK] animated:YES];
            }
        }
    } else if ([HBSharedUtils getLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:lastGame] animated:YES];
            }
        } else {
            //return @"League Leaders";
            if (indexPath.row == 0) { //QB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionQB] animated:YES];
            } else if (indexPath.row == 1) { //RB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionRB] animated:YES];
            } else if (indexPath.row == 2) { //WR
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionWR] animated:YES];
            } else if (indexPath.row == 3) { //DEF
                RankingsViewController *def = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppYPG];
                def.title = @"Defense";
                [self.navigationController pushViewController:def animated:YES];
            } else { //K
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionK] animated:YES];
            }
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:nextGame] animated:YES];
            }
        } else {
            //return @"League Leaders";
            if (indexPath.row == 0) { //QB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionQB] animated:YES];
            } else if (indexPath.row == 1) { //RB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionRB] animated:YES];
            } else if (indexPath.row == 2) { //WR
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionWR] animated:YES];
            } else if (indexPath.row == 3) { //DEF
                RankingsViewController *def = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppYPG];
                def.title = @"Defense";
                [self.navigationController pushViewController:def animated:YES];
            } else { //K
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionK] animated:YES];
            }
        }
    }
}


@end
