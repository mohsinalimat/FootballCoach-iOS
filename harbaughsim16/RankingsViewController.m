//
//  RankingsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "RankingsViewController.h"
#import "Team.h"
#import "TeamViewController.h"
#import "League.h"

@interface RankingsViewController () <UIViewControllerPreviewingDelegate>
{
    NSArray *teams;
    HBStatType selectedStatType;
}
@end

@implementation RankingsViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        TeamViewController *teamDetail = [[TeamViewController alloc] initWithTeam:teams[indexPath.row]];
        teamDetail.preferredContentSize = CGSizeMake(0.0, 600);
        previewingContext.sourceRect = cell.frame;
        return teamDetail;
    } else {
        return nil;
    }
}

-(instancetype)initWithStatType:(HBStatType)statType {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        selectedStatType = statType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    teams = [HBSharedUtils currentLeague].teamList;
    
    if (selectedStatType == HBStatTypePollScore) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamPollScore < b.rankTeamPollScore ? -1 : a.rankTeamPollScore == b.rankTeamPollScore ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        if ([HBSharedUtils currentLeague].currentWeek >= 15) {
            self.title = @"Final Polls";
        } else {
            self.title = @"Current Polls";
        }
    } else if (selectedStatType == HBStatTypeOffTalent) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamOffTalent < b.rankTeamOffTalent ? -1 : a.rankTeamOffTalent == b.rankTeamOffTalent ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Offensive Talent";
    } else if (selectedStatType == HBStatTypeDefTalent) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamDefTalent < b.rankTeamDefTalent ? -1 : a.rankTeamDefTalent == b.rankTeamDefTalent ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Defensive Talent";
    } else if (selectedStatType == HBStatTypeTeamPrestige) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamPrestige < b.rankTeamPrestige ? -1 : a.rankTeamPrestige == b.rankTeamPrestige ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Prestige";
    } else if (selectedStatType == HBStatTypeSOS) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamStrengthOfWins < b.rankTeamStrengthOfWins ? -1 : a.rankTeamStrengthOfWins == b.rankTeamStrengthOfWins ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Strength of Schedule";
    } else if (selectedStatType == HBStatTypePPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamPoints < b.rankTeamPoints ? -1 : a.rankTeamPoints == b.rankTeamPoints ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Points Per Game";
    } else if (selectedStatType == HBStatTypeYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamYards < b.rankTeamYards ? -1 : a.rankTeamYards == b.rankTeamYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Yards Per Game";
    } else if (selectedStatType == HBStatTypePYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamPassYards < b.rankTeamPassYards ? -1 : a.rankTeamPassYards == b.rankTeamPassYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Pass YPG";
    } else if (selectedStatType == HBStatTypeRYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamRushYards < b.rankTeamRushYards ? -1 : a.rankTeamRushYards == b.rankTeamRushYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Rush YPG";
    } else if (selectedStatType == HBStatTypeOppPPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamOppPoints < b.rankTeamOppPoints ? -1 : a.rankTeamOppPoints == b.rankTeamOppPoints ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Points Allowed Per Game";
    } else if (selectedStatType == HBStatTypeOppYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamOppYards < b.rankTeamOppYards ? -1 : a.rankTeamOppYards == b.rankTeamOppYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Yards Allowed Per Game";
    } else if (selectedStatType == HBStatTypeOppPYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamOppPassYards < b.rankTeamOppPassYards ? -1 : a.rankTeamOppPassYards == b.rankTeamOppPassYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Pass Yards Allowed Per Game";
    } else if (selectedStatType == HBStatTypeOppRYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamOppRushYards < b.rankTeamOppRushYards ? -1 : a.rankTeamOppRushYards == b.rankTeamOppRushYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Rush Yards Allowed Per Game";
    } else if (selectedStatType == HBStatTypeTODiff) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamTODiff < b.rankTeamTODiff ? -1 : a.rankTeamTODiff == b.rankTeamTODiff ? 0 : 1;
        }];
        [self.tableView reloadData];
        self.title = @"Turnover Differential";
    } else if (selectedStatType == HBStatTypeAllTimeWins) { //HBStatTypeAllTimeWins
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamTotalWins < b.rankTeamTotalWins ? -1 : a.rankTeamTotalWins == b.rankTeamTotalWins ? 0 : 1;
        }];
        [self.tableView reloadData];
        self.title = @"All-Time Win Percentage";
    } else { //HBStatTypeRecruitingScore
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.rankTeamRecruitingClassScore < b.rankTeamRecruitingClassScore ? -1 : a.rankTeamRecruitingClassScore == b.rankTeamRecruitingClassScore ? 0 : 1;
        }];
        [self.tableView reloadData];
        self.title = @"Recruiting Composite Rankings";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    
    Team *t = teams[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"#%ld: %@ (%ld-%ld)", (long)(indexPath.row + 1), t.name,(long)t.wins,(long)t.losses]];
    
    if ([HBSharedUtils currentLeague].userTeam != nil && [HBSharedUtils currentLeague].userTeam.name != nil && [cell.textLabel.text containsString:[HBSharedUtils currentLeague].userTeam.name]) {
        [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    if (selectedStatType == HBStatTypePollScore) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld", (long)t.teamPollScore]];
    } else if (selectedStatType == HBStatTypeOffTalent) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld", (long)t.teamOffTalent]];
    } else if (selectedStatType == HBStatTypeDefTalent) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld", (long)t.teamDefTalent]];
    } else if (selectedStatType == HBStatTypeTeamPrestige) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld", (long)t.teamPrestige]];
    } else if (selectedStatType == HBStatTypeSOS) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld", (long)t.teamStrengthOfWins]];
    } else if (selectedStatType == HBStatTypePPG) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld pts/gm", ((long)t.teamPoints/(long)t.numGames)]];
    } else if (selectedStatType == HBStatTypeYPG) {
         [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld yds/gm", ((long)t.teamYards/(long)t.numGames)]];
    } else if (selectedStatType == HBStatTypePYPG) {
         [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld yds/gm", ((long)t.teamPassYards/(long)t.numGames)]];
    } else if (selectedStatType == HBStatTypeRYPG) {
         [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld yds/gm", ((long)t.teamRushYards/(long)t.numGames)]];
    } else if (selectedStatType == HBStatTypeOppPPG) {
         [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld pts/gm", ((long)t.teamOppPoints/(long)t.numGames)]];
    } else if (selectedStatType == HBStatTypeOppYPG) {
         [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld yds/gm", ((long)t.teamOppYards/(long)t.numGames)]];
    } else if (selectedStatType == HBStatTypeOppPYPG) {
         [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld yds/gm", ((long)t.teamOppPassYards/(long)t.numGames)]];
    } else if (selectedStatType == HBStatTypeOppRYPG) {
         [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld yds/gm", ((long)t.teamOppRushYards/(long)t.numGames)]];
    } else if (selectedStatType == HBStatTypeTODiff) {
        NSString *turnoverDifferential = @"0";
        if (t.teamTODiff > 0) {
            turnoverDifferential = [NSString stringWithFormat:@"+%ld",(long)t.teamTODiff];
        } else if (t.teamTODiff == 0) {
            turnoverDifferential = @"0";
        } else {
            turnoverDifferential = [NSString stringWithFormat:@"%ld",(long)t.teamTODiff];
        }
        [cell.detailTextLabel setText:turnoverDifferential];

    } else if (selectedStatType == HBStatTypeAllTimeWins)  { //HBStatTypeAllTimeWins
        int winPercent = (int)ceil(100 * ((double)t.totalWins) / (double)(t.totalWins + t.totalLosses));
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d-%d (%d%%)",t.totalWins,t.totalLosses,winPercent]];
    } else {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d pts", t.teamRecruitingClassScore]];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Team *t = teams[indexPath.row];
    [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:t] animated:YES];
}

@end
