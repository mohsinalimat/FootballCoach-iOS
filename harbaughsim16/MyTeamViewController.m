//
//  MyTeamViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "MyTeamViewController.h"
#import "SettingsViewController.h"
#import "Team.h"
#import "League.h"
#import "HBSharedUtils.h"
#import "TeamHistoryViewController.h"
#import "LeagueHistoryController.h"
#import "TeamStrategyViewController.h"
#import "IntroViewController.h"
#import "RankingsViewController.h"
#import "TeamRecordsViewController.h"
#import "LeagueRecordsViewController.h"
#import "ConferenceStandingsViewController.h"
#import "TeamStreaksViewController.h"
#import "RingOfHonorViewController.h"
#import "HallOfFameViewController.h"
#import "HeadCoachDetailViewController.h"

#import "HexColors.h"
#import "STPopup.h"

@interface MyTeamViewController () <UIViewControllerPreviewingDelegate>

@end

@implementation MyTeamViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIViewController *peekVC;
        
        if (indexPath.section == 1) {
            if ([HBSharedUtils currentLeague].currentWeek > 0) {
                if (indexPath.row == 0) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypePollScore];
                } else if (indexPath.row == 1) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeOffTalent];
                } else if (indexPath.row == 2) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeDefTalent];
                } else if (indexPath.row == 3) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeTeamPrestige];
                } else if (indexPath.row == 4) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeAllTimeWins];
                } else if (indexPath.row == 5) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeAllTimeCCGs];
                } else if (indexPath.row == 6) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeAllTimeNCGs];
                } else if (indexPath.row == 7) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeSOS];
                } else if (indexPath.row == 8) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypePPG];
                } else if (indexPath.row == 9) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppPPG];
                } else if (indexPath.row == 10) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeYPG];
                } else if (indexPath.row == 11) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppYPG];
                } else if (indexPath.row == 12) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypePYPG];
                } else if (indexPath.row == 13) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeRYPG];
                } else if (indexPath.row == 14) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppPYPG];
                } else if (indexPath.row == 15) {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeOppRYPG];
                } else {
                    peekVC = [[RankingsViewController alloc] initWithStatType:HBStatTypeTODiff];
                }
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                //league
                peekVC = [[LeagueHistoryController alloc] init];
            } else if (indexPath.row == 1) { //hallOfFame
                peekVC = [[HallOfFameViewController alloc] init];
            } else {
                //league records
                peekVC = [[LeagueRecordsViewController alloc] init];
            }
        } else if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                peekVC = [[HeadCoachDetailViewController alloc] initWithCoach:[userTeam getCurrentHC]];
            } else if (indexPath.row == 3) {
                peekVC = [[TeamHistoryViewController alloc] initWithTeam:userTeam];
            } else if (indexPath.row == 4) { //hallOfFame
                peekVC = [[RingOfHonorViewController alloc] initWithTeam:userTeam];
            } else if (indexPath.row == 5) { //teamRecords
                peekVC = [[TeamRecordsViewController alloc] initWithTeam:userTeam];
            } else { //team streaks
                peekVC = [[TeamStreaksViewController alloc] initWithTeam:userTeam];
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

-(void)presentIntro {
    UINavigationController *introNav = [[UINavigationController alloc] initWithRootViewController:[[IntroViewController alloc] init]];
    [introNav setNavigationBarHidden:YES];
    [self.navigationController.tabBarController presentViewController:introNav animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"My Team";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    [self setupTeamHeader];
    self.tableView.tableHeaderView = teamHeaderView;
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTeamHeader) name:@"endedSeason" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"playedWeek" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStats) name:@"changedStrategy" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentIntro) name:@"noSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"newSaveFile" object:nil];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"updatedStarters" object:nil];
    
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}


-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)saveUserTeam {
    [[HBSharedUtils currentLeague] save];
}

-(void)resetForNewSeason {
    [self setupTeamHeader];
    [self reloadStats];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)setupTeamHeader {
    userTeam = [HBSharedUtils currentLeague].userTeam;
    [[HBSharedUtils currentLeague] setTeamRanks];
    stats = [userTeam getTeamStatsArray];
    NSString *rank = @"";
    if ([HBSharedUtils currentLeague].currentWeek > 0 && userTeam.rankTeamPollScore < 26 && userTeam.rankTeamPollScore > 0) {
        rank = [NSString stringWithFormat:@"#%d ",userTeam.rankTeamPollScore];
    }
    [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, userTeam.name]];
    
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)[HBSharedUtils currentLeague].leagueHistoryDictionary.count + [HBSharedUtils currentLeague].baseYear,(long)userTeam.wins,(long)userTeam.losses]];
    [teamHeaderView.teamPrestigeLabel setText:[NSString stringWithFormat:@"Prestige: %d",userTeam.teamPrestige]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)reloadStats {
    userTeam = [HBSharedUtils currentLeague].userTeam;
    [[HBSharedUtils currentLeague] setTeamRanks];
    stats = [userTeam getTeamStatsArray];
    [self.tableView reloadData];
}

-(void)openSettings {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped]] animated:YES completion:nil];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return @"History";
    } else if (section == 1) {
        return @"Statistics";
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 36;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 18;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else if (section == 2) {
        return 3;
    } else {
        return stats.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row < 3) {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"StratCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StratCell"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
                [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
            }
            
            NSString *title = @"";
            NSString *strat = @"";
            if (indexPath.row == 0) {
                title = @"Head Coach";
                strat = [[userTeam getCurrentHC] getInitialName];
            } else if (indexPath.row == 1) {
                title = @"Offensive Playbook";
                strat = userTeam.offensiveStrategy.stratName;
            } else {
                title = @"Defensive Playbook";
                strat = userTeam.defensiveStrategy.stratName;
            }
            
            [cell.textLabel setText:title];
            [cell.detailTextLabel setText:strat];
            return cell;
        } else {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"RecordCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecordCell"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
                [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
            }
            
            NSString *title = @"";
            
            if (indexPath.row == 3) {
                title = @"Team History";
            } else if (indexPath.row == 4) {
                title = @"Ring of Honor";
            } else if (indexPath.row == 5) {
                title = @"Team Records";
            } else {
                title = @"Team Streaks";
            }
            [cell.textLabel setText:title];
            
            return cell;

        }
        
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        
        NSString *title = @"";
        

        if (indexPath.row == 0) {
            title = @"League History";
        } else if (indexPath.row == 1) {
            title = @"Hall of Fame";
        } else {
            title = @"League Records";
        }
        [cell.textLabel setText:title];
        
        return cell;
    } else {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"StatCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StatCell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        NSArray *cellStat = stats[indexPath.row];
        
        NSString *stat = @"";
        if ([HBSharedUtils currentLeague].currentWeek > 0) {
            if (indexPath.row == 5 || indexPath.row == 6) {
                stat = cellStat[0];
            } else {
                stat = [NSString stringWithFormat:@"%@ (%@)", cellStat[0], cellStat[2]];
            }

            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        } else {
            stat = cellStat[0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell.textLabel setText:cellStat[1]];
        [cell.detailTextLabel setText:stat];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if ([HBSharedUtils currentLeague].currentWeek > 0) {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
            } else if (indexPath.row == 1) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOffTalent] animated:YES];
            } else if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeDefTalent] animated:YES];
            } else if (indexPath.row == 3) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeTeamPrestige] animated:YES];
            } else if (indexPath.row == 4) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeAllTimeWins] animated:YES];
            } else if (indexPath.row == 5) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeAllTimeCCGs] animated:YES];
            } else if (indexPath.row == 6) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeAllTimeNCGs] animated:YES];
            } else if (indexPath.row == 7) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeSOS] animated:YES];
            } else if (indexPath.row == 8) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePPG] animated:YES];
            } else if (indexPath.row == 9) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOppPPG] animated:YES];
            } else if (indexPath.row == 10) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeYPG] animated:YES];
            } else if (indexPath.row == 11) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOppYPG] animated:YES];
            } else if (indexPath.row == 12) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePYPG] animated:YES];
            } else if (indexPath.row == 13) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeRYPG] animated:YES];
            } else if (indexPath.row == 14) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOppPYPG] animated:YES];
            } else if (indexPath.row == 15) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOppRYPG] animated:YES];
            } else {
               [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeTODiff] animated:YES];
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //league
            [self.navigationController pushViewController:[[LeagueHistoryController alloc] init] animated:YES];
        } else if (indexPath.row == 1) { //hallOfFame
            [self.navigationController pushViewController:[[HallOfFameViewController alloc] init] animated:YES];
        } else {
            //league records
            [self.navigationController pushViewController:[[LeagueRecordsViewController alloc] init] animated:YES];
        }
    } else if (indexPath.section == 0) {
        if (indexPath.row == 0) { //coach
            [self.navigationController pushViewController:[[HeadCoachDetailViewController alloc] initWithCoach:[userTeam getCurrentHC]] animated:YES];
        } else if (indexPath.row == 1) { //offensive
            popupController = [[STPopupController alloc] initWithRootViewController:[[TeamStrategyViewController alloc] initWithType:TRUE options:[[HBSharedUtils currentLeague].userTeam getOffensiveTeamStrategies]]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            popupController.safeAreaInsets = UIEdgeInsetsZero;
            [popupController presentInViewController:self];
        } else if (indexPath.row == 2) { //defensive
            popupController = [[STPopupController alloc] initWithRootViewController:[[TeamStrategyViewController alloc] initWithType:FALSE options:[[HBSharedUtils currentLeague].userTeam getDefensiveTeamStrategies]]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            popupController.safeAreaInsets = UIEdgeInsetsZero;
            [popupController presentInViewController:self];
        } else if (indexPath.row == 3) {
            [self.navigationController pushViewController:[[TeamHistoryViewController alloc] initWithTeam:userTeam] animated:YES];
        } else if (indexPath.row == 4) { //hallOfFame
            [self.navigationController pushViewController:[[RingOfHonorViewController alloc] initWithTeam:userTeam] animated:YES];
        } else if (indexPath.row == 5) { //teamRecords
            [self.navigationController pushViewController:[[TeamRecordsViewController alloc] initWithTeam:userTeam] animated:YES];
        } else { //team streaks
            [self.navigationController pushViewController:[[TeamStreaksViewController alloc] initWithTeam:userTeam] animated:YES];
        }
    }
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

@end
