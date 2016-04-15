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

@interface RankingsViewController ()
{
    NSArray *teams;
    HBStatType selectedStatType;
}
@end

@implementation RankingsViewController

-(instancetype)initWithStatType:(HBStatType)statType {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        selectedStatType = statType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    teams = [HBSharedUtils getLeague].teamList;
    if (selectedStatType == HBStatTypePollScore) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        if ([HBSharedUtils getLeague].currentWeek >= 15) {
            self.title = @"Final Polls";
        } else {
            self.title = @"Current Polls";
        }
    } else if (selectedStatType == HBStatTypeOffTalent) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOffTalent > b.teamOffTalent ? -1 : a.teamOffTalent == b.teamOffTalent ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Offensive Talent";
    } else if (selectedStatType == HBStatTypeDefTalent) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamDefTalent > b.teamDefTalent ? -1 : a.teamDefTalent == b.teamDefTalent ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Defensive Talent";
    } else if (selectedStatType == HBStatTypeTeamPrestige) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPrestige > b.teamPrestige ? -1 : a.teamPrestige == b.teamPrestige ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Prestige";
    } else if (selectedStatType == HBStatTypeSOS) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamStrengthOfWins > b.teamStrengthOfWins ? -1 : a.teamStrengthOfWins == b.teamStrengthOfWins ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Strength of Schedule";
    } else if (selectedStatType == HBStatTypePPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPoints > b.teamPoints ? -1 : a.teamPoints == b.teamPoints ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Points Per Game";
    } else if (selectedStatType == HBStatTypeYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamYards > b.teamYards ? -1 : a.teamYards == b.teamYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Yards Per Game";
    } else if (selectedStatType == HBStatTypePYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamPassYards > b.teamPassYards ? -1 : a.teamPassYards == b.teamPassYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Pass YPG";
    } else if (selectedStatType == HBStatTypeRYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamRushYards > b.teamRushYards ? -1 : a.teamRushYards == b.teamRushYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Rush YPG";
    } else if (selectedStatType == HBStatTypeOppPPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppPoints < b.teamOppPoints ? -1 : a.teamOppPoints == b.teamOppPoints ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Points Allowed Per Game";
    } else if (selectedStatType == HBStatTypeOppYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppYards < b.teamOppYards ? -1 : a.teamOppYards == b.teamOppYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Yards Allowed Per Game";
    } else if (selectedStatType == HBStatTypeOppPYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppPassYards < b.teamOppPassYards ? -1 : a.teamOppPassYards == b.teamOppPassYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Pass Yards Allowed Per Game";
    } else if (selectedStatType == HBStatTypeOppRYPG) {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamOppRushYards < b.teamOppRushYards ? -1 : a.teamOppRushYards == b.teamOppRushYards ? 0 : 1;
            
        }];
        [self.tableView reloadData];
        self.title = @"Rush Yards Allowed Per Game";
    } else {
        teams = [teams sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.teamTODiff > b.teamTODiff ? -1 : a.teamTODiff == b.teamTODiff ? 0 : 1;
        }];
        [self.tableView reloadData];
        self.title = @"Turnover Differential";
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
    if (selectedStatType == HBStatTypePollScore) {
        return 25;
    } else {
        return 30;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Team *t = teams[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"#%ld: %@ (%ld-%ld)", (long)(indexPath.row + 1), t.name,(long)t.wins,(long)t.losses]];
    
    if ([cell.textLabel.text containsString:[HBSharedUtils getLeague].userTeam.name]) {
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
    } else {
        NSString *turnoverDifferential = @"0";
        if (t.teamTODiff > 0) {
            turnoverDifferential = [NSString stringWithFormat:@"+%ld",(long)t.teamTODiff];
        } else if (t.teamTODiff == 0) {
            turnoverDifferential = @"0";
        } else {
            turnoverDifferential = [NSString stringWithFormat:@"%ld",(long)t.teamTODiff];
        }
        [cell.detailTextLabel setText:turnoverDifferential];

    }

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Team *t = teams[indexPath.row];
    [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:t] animated:YES];
}

@end
