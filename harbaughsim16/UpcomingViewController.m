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
#import "LeagueUpdater.h"

#import "HeismanLeadersViewController.h"
#import "BowlProjectionViewController.h"
#import "RankingsViewController.h"
#import "AllLeagueTeamViewController.h"
#import "ConferenceStandingsSelectorViewController.h"
#import "ConferenceStandingsViewController.h"
#import "AllConferenceTeamConferenceSelectorViewController.h"
#import "AllConferenceTeamViewController.h"
#import "HBTeamPlayView.h"
#import "GameDetailViewController.h"
#import "PlayerStatsViewController.h"
#import "ROTYLeadersViewController.h"
#import "COTYLeadersViewController.h"
#import "MockDraftViewController.h"

#import "RecruitingPeriodViewController.h"

#import "HexColors.h"
#import "STPopup.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ZMJTipView.h"

#define FCTutorialSimulateSeason 1000
#define FCTutorialViewLeaderboards 1001
#define FCTutorialTabBarOptions 1002
#define FCTutorialScrollToNews 1003
#define FCTutorialSimWeek 1004
#define FCTutorialTabBarOptionsSchedule 1005
#define FCTutorialTabBarOptionsDepthChart 1006
#define FCTutorialTabBarOptionsSearch 1007
#define FCTutorialTabBarOptionsCareer 1008
#define FCTutorialTabBarOptionsTeam 1009


@interface UpcomingViewController () <UIViewControllerPreviewingDelegate, ZMJTipViewDelegate>
{
    PlayerQB *passLeader;
    Player *rushLeader;
    Player *recLeader;
    Player *defLeader;
    PlayerK *kickLeader;
    Team *userTeam;
    IBOutlet HBTeamPlayView *teamHeaderView;
    STPopupController *popupController;
    Game *lastGame;
    Game *nextGame;
    
    NSMutableArray *news;
    NSInteger curNewsWeek;
}
@end

@implementation UpcomingViewController

//MARK: ZMJTipViewDelegate
- (void)tipViewDidDimiss:(ZMJTipView *)tipView {
    // show new tips based on last shown tipview
    if (tipView.tag == FCTutorialSimulateSeason) {
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:@"Tap here to view various statistics and rankings during the season." preferences:nil delegate:self];
        editTip.tag = FCTutorialViewLeaderboards;
        [editTip showAnimated:YES forItem:self.navigationItem.rightBarButtonItem withinSuperview:self.navigationController.view];
    } else if (tipView.tag == FCTutorialViewLeaderboards) {
        ZMJPreferences *prefs = [ZMJTipView globalPreferences];
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:@"Scroll down to view statistical leaders and news stories as the season progresses." preferences:prefs delegate:self];
        editTip.tag = FCTutorialScrollToNews;
        if (self.tableView.numberOfSections > 0) {
            [editTip showAnimated:YES forView:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] withinSuperview:self.navigationController.view];
        }
    } else if (tipView.tag == FCTutorialScrollToNews) {
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:@"Tap here to view your schedule for this season." preferences:nil delegate:self];
        editTip.tag = FCTutorialTabBarOptionsSchedule;
        [editTip showAnimated:YES forItem:self.navigationController.tabBarController.tabBar.items[1] withinSuperview:self.view.window];
    } else if (tipView.tag == FCTutorialTabBarOptionsSchedule) {
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:@"Tap here to view and edit your school's depth chart." preferences:nil delegate:self];
        editTip.tag = FCTutorialTabBarOptionsDepthChart;
        [editTip showAnimated:YES forItem:self.navigationController.tabBarController.tabBar.items[2] withinSuperview:self.view.window];
    } else if (tipView.tag == FCTutorialTabBarOptionsDepthChart) {
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:@"Tap here to search through other in the league and view their details." preferences:nil delegate:self];
        editTip.tag = FCTutorialTabBarOptionsSearch;
        [editTip showAnimated:YES forItem:self.navigationController.tabBarController.tabBar.items[3] withinSuperview:self.view.window];
    } else if (tipView.tag == FCTutorialTabBarOptionsSearch) {
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:@"" preferences:nil delegate:self];
        if ([HBSharedUtils currentLeague].isCareerMode) {
            editTip.tag = FCTutorialTabBarOptionsCareer;
            editTip.text = @"Tap here to view details about your coaching career.";
        } else {
            editTip.tag = FCTutorialTabBarOptionsTeam;
            editTip.text = @"Tap here to view details about your team.";
        }
        [editTip showAnimated:YES forItem:self.navigationController.tabBarController.tabBar.items[4] withinSuperview:self.view.window];
    } else if (tipView.tag == FCTutorialTabBarOptionsTeam || tipView.tag == FCTutorialTabBarOptionsCareer) {
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:@"Tap here to simulate the next week of the season." preferences:nil delegate:self];
        editTip.tag = FCTutorialSimWeek;
        [editTip showAnimated:YES forView:teamHeaderView.playButton withinSuperview:self.navigationController.view];
    } else if (tipView.tag == FCTutorialSimWeek) {
        [teamHeaderView.playButton setEnabled:YES];
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    }
}

- (void)tipViewDidSelected:(ZMJTipView *)tipView {
    // do nothing
}

-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

-(UIViewController*)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIViewController *peekVC;
    if (indexPath != nil) {
        if ([HBSharedUtils currentLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils currentLeague].userTeam.gameSchedule.count >= [HBSharedUtils currentLeague].currentWeek) {
            if (indexPath.section == 0) {
                if (indexPath.row == 2) {
                    peekVC = [[GameDetailViewController alloc] initWithGame:lastGame];
                }
            } else if (indexPath.section == 1) {
                if (indexPath.row == 2) {
                    peekVC = [[GameDetailViewController alloc] initWithGame:nextGame];
                }
            } else if (indexPath.section == 2) {
                //return @"League Leaders";
                if (indexPath.row == 0) { //QB
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionQB];
                } else if (indexPath.row == 1) { //RB
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionRB];
                } else if (indexPath.row == 2) { //WR
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionWR];
                } else if (indexPath.row == 3) { //DEF
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionDEF];
                } else { //K
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionK];
                }
            }
        } else if ([HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
            if (indexPath.section == 0) {
                if (indexPath.row == 2) {
                    peekVC = [[GameDetailViewController alloc] initWithGame:lastGame];
                }
            } else if (indexPath.section == 1) {
                //return @"League Leaders";
                if (indexPath.row == 0) { //QB
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionQB];
                } else if (indexPath.row == 1) { //RB
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionRB];
                } else if (indexPath.row == 2) { //WR
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionWR];
                } else if (indexPath.row == 3) { //DEF
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionDEF];
                } else { //K
                    peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionK];
                }
            }
        } else {
            if (indexPath.section == 0) {
                if (indexPath.row == 2) {
                    peekVC = [[GameDetailViewController alloc] initWithGame:nextGame];
                }
            }
        }
        
        if (peekVC != nil) {
            peekVC.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
            previewingContext.sourceRect = cell.frame;
            return peekVC;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(void)backgroundViewDidTap {
    [self->popupController dismiss];
}

-(void)runOnSaveInProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->teamHeaderView.playButton setEnabled:NO];
    });
}

-(void)runOnSaveFinished {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->teamHeaderView.playButton setEnabled:YES];
    });
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
            int curWeek = [HBSharedUtils currentLeague].currentWeek;
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
        if ([HBSharedUtils currentLeague].currentWeek <= 15) {
            [self.tableView reloadData];
        }
        [self setupTeamHeader];
        [self refreshNews];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
    }];
}

-(void)resetSimButton {
    if ([HBSharedUtils currentLeague].currentWeek < 15) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)([HBSharedUtils currentLeague].baseYear + [HBSharedUtils currentLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
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
        [self setupTeamHeader];
        [self refreshNews];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
    }];
}

-(void)viewResultsOptions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"News Options" message:@"What would you like to view?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([HBSharedUtils currentLeague].currentWeek < 1 && [HBSharedUtils currentLeague].baseYear != [[HBSharedUtils currentLeague] getCurrentYear] && ![LeagueUpdater needsUpdateFromVersion:[HBSharedUtils currentLeague].leagueVersion toVersion:@"2.0"]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Recruiting Composite Rankings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeRecruitingScore] animated:YES];
        }]];
    }
    
    if ([HBSharedUtils currentLeague].currentWeek == 15) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Final Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTY Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"ROTY Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[ROTYLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"COTY Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[COTYLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [self->popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [self->popupController.navigationBar setDraggable:YES];
            self->popupController.style = STPopupStyleBottomSheet;
            self->popupController.safeAreaInsets = UIEdgeInsetsZero;
            [self->popupController presentInViewController:self];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Pro Draft Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MockDraftViewController alloc] init]] animated:YES completion:nil];
            });
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"All-League Team" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[AllLeagueTeamViewController alloc] init] animated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"All-Conference Teams" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->popupController = [[STPopupController alloc] initWithRootViewController:[[AllConferenceTeamConferenceSelectorViewController alloc] init]];
            [self->popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [self->popupController.navigationBar setDraggable:YES];
            self->popupController.style = STPopupStyleBottomSheet;
            self->popupController.safeAreaInsets = UIEdgeInsetsZero;
            [self->popupController presentInViewController:self];
        }]];

    } else if ([HBSharedUtils currentLeague].currentWeek == 14) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Current Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTY Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"ROTY Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[ROTYLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"COTY Results" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[COTYLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [self->popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [self->popupController.navigationBar setDraggable:YES];
            self->popupController.style = STPopupStyleBottomSheet;
            self->popupController.safeAreaInsets = UIEdgeInsetsZero;
            [self->popupController presentInViewController:self];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"All-League Team" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[AllLeagueTeamViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"All-Conference Teams" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->popupController = [[STPopupController alloc] initWithRootViewController:[[AllConferenceTeamConferenceSelectorViewController alloc] init]];
            [self->popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [self->popupController.navigationBar setDraggable:YES];
            self->popupController.style = STPopupStyleBottomSheet;
            self->popupController.safeAreaInsets = UIEdgeInsetsZero;
            [self->popupController presentInViewController:self];
        }]];
    } else if ([HBSharedUtils currentLeague].currentWeek == 13) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Current Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Schedule" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTY Leaders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"ROTY Leaders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[ROTYLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"COTY Leaders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[COTYLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [self->popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [self->popupController.navigationBar setDraggable:YES];
            self->popupController.style = STPopupStyleBottomSheet;
            self->popupController.safeAreaInsets = UIEdgeInsetsZero;
            [self->popupController presentInViewController:self];
        }]];
        
    } else if ([HBSharedUtils currentLeague].currentWeek > 6) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Current Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Projections" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"POTY Leaders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"ROTY Leaders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[ROTYLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"COTY Leaders" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController pushViewController:[[COTYLeadersViewController alloc] init] animated:YES];
        }]];
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [self->popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [self->popupController.navigationBar setDraggable:YES];
            self->popupController.style = STPopupStyleBottomSheet;
            self->popupController.safeAreaInsets = UIEdgeInsetsZero;
            [self->popupController presentInViewController:self];
        }]];
        
    } else {
        [alertController addAction:[UIAlertAction actionWithTitle:@"Current Polls" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Standings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
            [self->popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [self->popupController.navigationBar setDraggable:YES];
            self->popupController.style = STPopupStyleBottomSheet;
            self->popupController.safeAreaInsets = UIEdgeInsetsZero;
            [self->popupController presentInViewController:self];
        }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)pushToConfTeam:(NSNotification*)confNotification {
    Conference *conf = (Conference*)[confNotification object];
    //delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[[AllConferenceTeamViewController alloc] initWithConference:conf] animated:YES];
    });
}

-(void)pushToConfStandings:(NSNotification*)confNotification {
    Conference *conf = (Conference*)[confNotification object];
    //delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[[ConferenceStandingsViewController alloc] initWithConference:conf] animated:YES];
    });
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self setupTeamHeader];
    [self refreshNews];
}

-(void)refreshNews {
    int curWeek = [HBSharedUtils currentLeague].currentWeek;
    if (curWeek <= 15) {
        [self reloadNews:curWeek];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTeamHeader {
    if (!userTeam) {
        [teamHeaderView.teamRankLabel setText:@" "];
        userTeam = [HBSharedUtils currentLeague].userTeam;
    }
    userTeam = [HBSharedUtils currentLeague].userTeam;
    if (userTeam) {
        NSString *rank = @"";
        if ([HBSharedUtils currentLeague].currentWeek > 0 && userTeam.rankTeamPollScore < 26 && userTeam.rankTeamPollScore > 0) {
            rank = [NSString stringWithFormat:@"#%ld ",(long)userTeam.rankTeamPollScore];
        }
        [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, userTeam.name]];
        [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)([HBSharedUtils currentLeague].baseYear + userTeam.teamHistoryDictionary.count),(long)userTeam.wins,(long)userTeam.losses]];
    } else {
        [teamHeaderView.teamRankLabel setText:@""];
        [teamHeaderView.teamRecordLabel setText:@"0-0"];
    }
    [teamHeaderView.playButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    
    
    League *simLeague = [HBSharedUtils currentLeague];
    if (simLeague.currentWeek < 12) {
        [HBSharedUtils currentLeague].canRebrandTeam = NO;
        [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 12) {
        [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 13) {
        [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 14) {
        [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
    } else {
        [HBSharedUtils currentLeague].canRebrandTeam = YES;
        [teamHeaderView.playButton setTitle:@" Start Offseason" forState:UIControlStateNormal];
    }
    
    if (simLeague.userTeam.gameWLSchedule.count > 0 && !simLeague.userTeam.gameSchedule.lastObject.hasPlayed && simLeague.userTeam.gameSchedule.count >= simLeague.currentWeek) {
        if (simLeague.currentWeek > 12) {
            nextGame = [userTeam.gameSchedule lastObject];
            lastGame = userTeam.gameSchedule[userTeam.gameSchedule.count - 2];
        } else {
            lastGame = userTeam.gameSchedule[simLeague.currentWeek - 1];
            nextGame = userTeam.gameSchedule[simLeague.currentWeek];
        }
    } else if (userTeam.gameSchedule.lastObject.hasPlayed) {
        lastGame = (simLeague.currentWeek > 12 ? userTeam.gameSchedule.lastObject : userTeam.gameSchedule[simLeague.currentWeek - 1]);
        nextGame = nil;
        //NSLog(@"Last game only");
    } else {
        lastGame = nil;
        nextGame = userTeam.gameSchedule[simLeague.currentWeek];
        //NSLog(@"Next game only");
    }

    
    NSMutableArray *qbs = [NSMutableArray array];
    NSMutableArray *ks = [NSMutableArray array];
    NSMutableArray *rushers = [NSMutableArray array];
    NSMutableArray *wrs = [NSMutableArray array];
    for (Team *t in simLeague.teamList) {
        [qbs addObjectsFromArray:t.teamQBs];
        [rushers addObjectsFromArray:t.teamRBs];
        [rushers addObjectsFromArray:t.teamQBs];
        [wrs addObjectsFromArray:t.teamWRs];
        [wrs addObjectsFromArray:t.teamTEs];
        [ks addObjectsFromArray:t.teamKs];
    }
    
    [qbs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        PlayerQB *a = (PlayerQB*)obj1;
        PlayerQB *b = (PlayerQB*)obj2;
        return (a.statsPassYards > b.statsPassYards) ? -1 : ((a.statsPassYards == b.statsPassYards) ? [a.name compare:b.name] : 1);
    }];
    [rushers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
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
    
// Old Defense Leader:
//    NSMutableArray *teams = [[HBSharedUtils currentLeague].teamList mutableCopy];
//    [teams sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return [HBSharedUtils compareOppYPG:obj1 toObj2:obj2];
//    }];
    
    // New Defense Leader:
    NSMutableArray *defenders = [NSMutableArray array];
    for (Team *t in simLeague.teamList) {
        [defenders addObjectsFromArray:t.teamDLs];
        [defenders addObjectsFromArray:t.teamLBs];
        [defenders addObjectsFromArray:t.teamCBs];
        [defenders addObjectsFromArray:t.teamSs];
    }
    [defenders sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return ([a getHeismanScore] > [b getHeismanScore]) ? -1 : (([a getHeismanScore] == [b getHeismanScore]) ? [a.name compare:b.name] : 1);
    }];
    
    
    passLeader = [qbs firstObject];
    rushLeader = [rushers firstObject];
    recLeader = [wrs firstObject];
    kickLeader = [ks firstObject];
    defLeader = [defenders firstObject];
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    news = [NSMutableArray array];
    [self reloadNews:[HBSharedUtils currentLeague].currentWeek];
    self.view.backgroundColor = [HBSharedUtils styleColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScoreCell" bundle:nil] forCellReuseIdentifier:@"HBScoreCell"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"triline"] style:UIBarButtonItemStylePlain target:self action:@selector(viewResultsOptions)];
    
    self.navigationItem.title = @"Latest News";
  
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    self.tableView.tableHeaderView = teamHeaderView;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)([HBSharedUtils currentLeague].baseYear + [HBSharedUtils currentLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
    if ([HBSharedUtils currentLeague].currentWeek < 15) {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"newNewsStory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNews) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSimButton) name:@"hideSimButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSaveFile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"saveFileUpdate" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reincarnateCoach" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToConfTeam:) name:@"pushToConfTeam" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToConfStandings:) name:@"pushToConfStandings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runOnSaveInProgress) name:@"saveInProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runOnSaveFinished) name:@"saveFinished" object:nil];
    
    if ([HBSharedUtils currentLeague].currentWeek != 16) {
        if ([HBSharedUtils currentLeague].userTeam.injuredPlayers.count > 0) {
            [self.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%lu", (long)[HBSharedUtils currentLeague].userTeam.injuredPlayers.count];
        } else {
            [self.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
        }
    }
    
    BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_UPCOMING_TUTORIAL_SHOWN_KEY];
    if (!tutorialShown) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_UPCOMING_TUTORIAL_SHOWN_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *tipText = @"Tap here to simulate up to various points in the season.";
            [self->teamHeaderView.playButton setEnabled:NO];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
            [self.navigationItem.leftBarButtonItem setEnabled:NO];
            ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:tipText preferences:nil delegate:self];
            editTip.tag = FCTutorialSimulateSeason;
            [editTip showAnimated:YES forItem:self.navigationItem.leftBarButtonItem withinSuperview:self.navigationController.view];
        });
    }
}

-(void)refreshView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)reloadNews:(int)curWeek {
    if (curWeek > 15) {
        curWeek = 15;
    }
    
    curNewsWeek = curWeek;
    news = [HBSharedUtils currentLeague].newsStories[curWeek];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 0;
    if (![HBSharedUtils currentLeague].userTeam.gameSchedule.firstObject.hasPlayed) {
        sections = 1;
    } else if ([HBSharedUtils currentLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        sections = 3;
    } else {
        sections = 2;
    }
    
    if ([HBSharedUtils currentLeague].newsStories != nil && news.count > 0) {
        sections += 1;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![HBSharedUtils currentLeague].userTeam.gameSchedule.firstObject.hasPlayed) {
        if (section == 0) {
            return 3;
        } else {
            return news.count;
        }
    } else if ([HBSharedUtils currentLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils currentLeague].userTeam.gameSchedule.count >= [HBSharedUtils currentLeague].currentWeek) {
        if (section == 0) {
            return 3;
        } else if (section == 1) {
            return 3;
        } else if (section == 2) {
            return 5;
        } else {
            return news.count;
        }
    } else if ([HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (section == 0) {
            return 3;
        } else if (section == 1) {
            return 5;
        } else {
            return news.count;
        }
    } else {
        if (section == 0) {
            return 3;
        } else if (section == 1) {
            return 5;
        } else {
            return news.count;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (![HBSharedUtils currentLeague].userTeam.gameSchedule.firstObject.hasPlayed) {
        if (section == 0) {
            return @"Next Game";
        } else {
            return @"News";
        }
    } else if ([HBSharedUtils currentLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils currentLeague].userTeam.gameSchedule.count >= [HBSharedUtils currentLeague].currentWeek) {
        if (section == 0) {
            return @"Last Game";
        } else if (section == 1) {
            return @"Next Game";
        } else if (section == 2) {
            return @"League Leaders";
        } else {
            return @"News";
        }
    } else if ([HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (section == 0) {
            return @"Last Game";
        } else if (section == 1) {
            return @"League Leaders";
        } else {
            return @"News";
        }
    } else {
        if (section == 0) {
            return @"Next Game";
        } else if (section == 1) {
            return @"League Leaders";
        } else {
            return @"News";
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (![HBSharedUtils currentLeague].userTeam.gameSchedule.firstObject.hasPlayed) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        } else {
            return 75;
        }
    } else if ([HBSharedUtils currentLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (indexPath.section == 2) {
            return 50;
        } else if (indexPath.section < 2) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        } else {
            return 75;
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        } else if (indexPath.section == 1) {
            return 50;
        } else {
            return 75;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![HBSharedUtils currentLeague].userTeam.gameSchedule.firstObject.hasPlayed) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        } else {
            return UITableViewAutomaticDimension;
        }
    } else if ([HBSharedUtils currentLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (indexPath.section == 2) {
            return 50;
        } else if (indexPath.section < 2) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        } else {
            return UITableViewAutomaticDimension;
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        } else if (indexPath.section == 1) {
            return 50;
        } else {
            return UITableViewAutomaticDimension;
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
    if ([HBSharedUtils currentLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils currentLeague].userTeam.gameSchedule.count >= [HBSharedUtils currentLeague].currentWeek) {
        if (indexPath.section == 0) {
            Game *bowl = lastGame;
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,bowl.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
                    if (bowl.homeScore < bowl.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([bowl.awayTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
                            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                            [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                        } else {
                            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                            [cell.scoreLabel setTextColor:[UIColor blackColor]];
                        }
                    }
                } else {
                    NSString *homeRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank, bowl.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
                    if (bowl.homeScore > bowl.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([bowl.homeTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
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
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank, bowl.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
                    if ([bowl.awayTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                    } else {
                        [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                        [cell.scoreLabel setTextColor:[UIColor blackColor]];
                    }
                } else {
                    NSString *homeRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,bowl.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
                    if ([bowl.homeTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
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
        } else if (indexPath.section == 2) {
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
                if (passLeader.isHeisman || passLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Rushing";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", rushLeader.team.abbreviation, rushLeader.position, [rushLeader getInitialName]]];
                if (rushLeader.isHeisman || rushLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Receiving";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", recLeader.team.abbreviation, recLeader.position, [recLeader getInitialName]]];
                if (recLeader.isHeisman || recLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"Defense";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", defLeader.team.abbreviation, defLeader.position, [defLeader getInitialName]]];
                if (defLeader.isHeisman || defLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            } else {
                cell.textLabel.text = @"Kicking";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ K %@", kickLeader.team.abbreviation, [kickLeader getInitialName]]];
                if (kickLeader.isHeisman || kickLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            }
            
            return cell;
        } else {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
                [cell.textLabel setNumberOfLines:0];
                [cell setBackgroundColor:[UIColor whiteColor]];
                [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
            }
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:news[indexPath.row] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
            NSRange firstLine = [attString.string rangeOfString:@"\n"];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium] range:NSMakeRange(0, firstLine.location)];
            if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [attString.string containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
                [attString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, firstLine.location)];
            } else {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, firstLine.location)];
            }
            
            [cell.textLabel setAttributedText:attString];
            [cell.textLabel sizeToFit];
            if (curNewsWeek > 0 && curNewsWeek <= 12) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"Week %ld", (long)(curNewsWeek)]];
            } else if (curNewsWeek == 0) {
                [cell.detailTextLabel setText:@"Preseason"];
            } else if (curNewsWeek == 13) {
                [cell.detailTextLabel setText:@"Conference Championships"];
            } else if (curNewsWeek == 14) {
                [cell.detailTextLabel setText:@"Bowls"];
            } else if (curNewsWeek == 15) {
                [cell.detailTextLabel setText:@"National Championship"];
            } else  {
                [cell.detailTextLabel setText:@"Offseason"];
            }
            
            
            return cell;
        }
    } else if ([HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (indexPath.section == 0) {
            Game *bowl = lastGame;
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,bowl.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
                    if (bowl.homeScore < bowl.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([bowl.awayTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
                            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                            [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                        } else {
                            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                            [cell.scoreLabel setTextColor:[UIColor blackColor]];
                        }
                    }
                } else {
                    NSString *homeRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,bowl.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
                    if (bowl.homeScore > bowl.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([bowl.homeTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
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
                if (passLeader.isHeisman || passLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            } else if (indexPath.row == 1) {
                cell.textLabel.text = @"Rushing";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", rushLeader.team.abbreviation,rushLeader.position, [rushLeader getInitialName]]];
                if (rushLeader.isHeisman || rushLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"Receiving";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", recLeader.team.abbreviation,recLeader.position, [recLeader getInitialName]]];
                if (recLeader.isHeisman || recLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            } else if (indexPath.row == 3) {
                cell.textLabel.text = @"Defense";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ %@ %@", defLeader.team.abbreviation, defLeader.position, [defLeader getInitialName]]];
                if (defLeader.isHeisman || defLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            } else {
                cell.textLabel.text = @"Kicking";
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@ K %@", kickLeader.team.abbreviation, [kickLeader getInitialName]]];
                if (kickLeader.isHeisman || kickLeader.isROTY) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils champColor]];
                } else if ([cell.detailTextLabel.text containsString:userTeam.abbreviation]) {
                    [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                }
            }
            
            return cell;
        } else {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
                [cell.textLabel setNumberOfLines:0];
                [cell setBackgroundColor:[UIColor whiteColor]];
                [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
            }
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:news[indexPath.row] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
            NSRange firstLine = [attString.string rangeOfString:@"\n"];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium] range:NSMakeRange(0, firstLine.location)];
            if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [attString.string containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
                [attString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, firstLine.location)];
            } else {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, firstLine.location)];
            }
            
            [cell.textLabel setAttributedText:attString];
            [cell.textLabel sizeToFit];
            if (curNewsWeek > 0 && curNewsWeek <= 12) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"Week %ld", (long)(curNewsWeek)]];
            } else if (curNewsWeek == 0) {
                [cell.detailTextLabel setText:@"Preseason"];
            } else if (curNewsWeek == 13) {
                [cell.detailTextLabel setText:@"Conference Championships"];
            } else if (curNewsWeek == 14) {
                [cell.detailTextLabel setText:@"Bowls"];
            } else if (curNewsWeek == 15) {
                [cell.detailTextLabel setText:@"National Championship"];
            } else  {
                [cell.detailTextLabel setText:@"Offseason"];
            }
            
            
            return cell;
        }
    } else {
        if (indexPath.section == 0) {
            Game *bowl = nextGame;
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,bowl.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
                    if ([bowl.awayTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                    } else {
                        [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                        [cell.scoreLabel setTextColor:[UIColor blackColor]];
                    }
                } else {
                    NSString *homeRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,bowl.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
                    if ([bowl.homeTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
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
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
                [cell.textLabel setNumberOfLines:0];
                [cell setBackgroundColor:[UIColor whiteColor]];
                [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
            }
            
            NSString *newsStory = @"";
            if (indexPath.row < news.count) {
                newsStory = news[indexPath.row];
            }
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:newsStory attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
            NSRange firstLine = [attString.string rangeOfString:@"\n"];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium] range:NSMakeRange(0, firstLine.location)];
            if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [attString.string containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
                [attString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, firstLine.location)];
            } else {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, firstLine.location)];
            }
            
            [cell.textLabel setAttributedText:attString];
            [cell.textLabel sizeToFit];
            if (curNewsWeek > 0 && curNewsWeek <= 12) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"Week %ld", (long)(curNewsWeek)]];
            } else if (curNewsWeek == 0) {
                [cell.detailTextLabel setText:@"Preseason"];
            } else if (curNewsWeek == 13) {
                [cell.detailTextLabel setText:@"Conference Championships"];
            } else if (curNewsWeek == 14) {
                [cell.detailTextLabel setText:@"Bowls"];
            } else if (curNewsWeek == 15) {
                [cell.detailTextLabel setText:@"National Championship"];
            } else  {
                [cell.detailTextLabel setText:@"Offseason"];
            }
            
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([HBSharedUtils currentLeague].userTeam.gameWLSchedule.count > 0 && ![HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed && [HBSharedUtils currentLeague].userTeam.gameSchedule.count >= [HBSharedUtils currentLeague].currentWeek) {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:lastGame] animated:YES];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:nextGame] animated:YES];
            }
        } else if (indexPath.section == 2) {
            //return @"League Leaders";
            if (indexPath.row == 0) { //QB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionQB] animated:YES];
            } else if (indexPath.row == 1) { //RB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionRB] animated:YES];
            } else if (indexPath.row == 2) { //WR
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionWR] animated:YES];
            } else if (indexPath.row == 3) { //DEF
//                RankingsViewController *def = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppYPG];
//                def.title = @"Defense";
//                [self.navigationController pushViewController:def animated:YES];
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionDEF] animated:YES];
            } else { //K
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionK] animated:YES];
            }
        }
    } else if ([HBSharedUtils currentLeague].userTeam.gameSchedule.lastObject.hasPlayed) {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:lastGame] animated:YES];
            }
        } else if (indexPath.section == 1) {
            //return @"League Leaders";
            if (indexPath.row == 0) { //QB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionQB] animated:YES];
            } else if (indexPath.row == 1) { //RB
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionRB] animated:YES];
            } else if (indexPath.row == 2) { //WR
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionWR] animated:YES];
            } else if (indexPath.row == 3) { //DEF
//                RankingsViewController *def = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppYPG];
//                def.title = @"Defense";
//                [self.navigationController pushViewController:def animated:YES];
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionDEF] animated:YES];
            } else { //K
                [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionK] animated:YES];
            }
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:nextGame] animated:YES];
            }
        }
    }
}


@end
