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

#import "HexColors.h"
#import "STPopup.h"

@interface HBTeamHistoryView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamPrestigeLabel;
@end

@implementation HBTeamHistoryView
@end

@interface MyTeamViewController ()
{
    IBOutlet HBTeamHistoryView *teamHeaderView;
    Team *userTeam;
    NSArray *stats;
}
@end

@implementation MyTeamViewController


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
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)saveUserTeam {
    [[HBSharedUtils getLeague] save];
}

-(void)resetForNewSeason {
    [self setupTeamHeader];
    [self reloadStats];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)setupTeamHeader {
    userTeam = [HBSharedUtils getLeague].userTeam;
    stats = [userTeam getTeamStatsArray];
    [teamHeaderView.teamRankLabel setText:userTeam.name];
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)[HBSharedUtils getLeague].leagueHistory.count + 2016,(long)userTeam.wins,(long)userTeam.losses]];
    [teamHeaderView.teamPrestigeLabel setText:[NSString stringWithFormat:@"Prestige: %d",userTeam.teamPrestige]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)reloadStats {
    userTeam = [HBSharedUtils getLeague].userTeam;
    stats = [userTeam getTeamStatsArray];
    [self.tableView reloadData];
}

-(void)openSettings {
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]] animated:YES completion:nil];
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 2) {
        return 3;
    } else {
        return stats.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row < 2) {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"StratCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StratCell"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            NSString *title = @"";
            NSString *strat = @"";
            if (indexPath.row == 0) {
                title = @"Offensive Strategy";
                strat = userTeam.offensiveStrategy.stratName;
            } else {
                title = @"Defensive Strategy";
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
            }
            
            [cell.textLabel setText:@"Team Records"];
            
            return cell;

        }
        
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        NSString *title = @"";
        

        if (indexPath.row == 0) {
            title = @"Team History";
        } else if (indexPath.row == 1) {
            title = @"League History";
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
        }
        NSArray *cellStat = stats[indexPath.row];
        
        NSString *stat = @"";
        if ([HBSharedUtils getLeague].currentWeek > 0) {
            stat = [NSString stringWithFormat:@"%@ (%@)", cellStat[0], cellStat[2]];
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
        if ([HBSharedUtils getLeague].currentWeek > 0) {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
            } else if (indexPath.row == 1) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOffTalent] animated:YES];
            } else if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeDefTalent] animated:YES];
            } else if (indexPath.row == 3) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeTeamPrestige] animated:YES];
            } else if (indexPath.row == 4) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeSOS] animated:YES];
            } else if (indexPath.row == 5) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePPG] animated:YES];
            } else if (indexPath.row == 6) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOppPPG] animated:YES];
            } else if (indexPath.row == 7) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeYPG] animated:YES];
            } else if (indexPath.row == 8) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOppYPG] animated:YES];
            } else if (indexPath.row == 9) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePYPG] animated:YES];
            } else if (indexPath.row == 10) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeRYPG] animated:YES];
            } else if (indexPath.row == 11) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOppPYPG] animated:YES];
            } else if (indexPath.row == 12) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeOppRYPG] animated:YES];
            } else {
               [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypeTODiff] animated:YES];
            }
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[TeamHistoryViewController alloc] initWithTeam:userTeam] animated:YES];
        } else if (indexPath.row == 1) {
            //league
            [self.navigationController pushViewController:[[LeagueHistoryController alloc] init] animated:YES];
        } else {
            //league records
            [self.navigationController pushViewController:[[LeagueRecordsViewController alloc] init] animated:YES];
        }
    } else if (indexPath.section == 0) {
        if (indexPath.row == 0) { //offensive
            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[[TeamStrategyViewController alloc] initWithType:TRUE options:[[HBSharedUtils getLeague].userTeam getOffensiveTeamStrategies]]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            [popupController presentInViewController:self];
        } else if (indexPath.row == 1) { //defensive
            STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:[[TeamStrategyViewController alloc] initWithType:FALSE options:[[HBSharedUtils getLeague].userTeam getDefensiveTeamStrategies]]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            [popupController presentInViewController:self];
        } else { //teamRecords
            [self.navigationController pushViewController:[[TeamRecordsViewController alloc] initWithTeam:userTeam] animated:YES];
        }
    } else {
       //do nothing
    }
}

@end
