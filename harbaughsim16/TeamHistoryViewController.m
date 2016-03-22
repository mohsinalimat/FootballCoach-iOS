//
//  TeamHistoryViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamHistoryViewController.h"
#import "Team.h"

@interface HBTeamCompiledHistoryView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamSeasonsLabel;
@end

@implementation HBTeamCompiledHistoryView
@end

@interface TeamHistoryViewController ()
{
    Team *userTeam;
    NSArray *history;
    IBOutlet HBTeamCompiledHistoryView *teamHeaderView;
}
@end

@implementation TeamHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userTeam = [HBSharedUtils getLeague].userTeam;
    history = [userTeam.teamHistory copy];
    self.title = [NSString stringWithFormat:@"%@ Team History", userTeam.abbreviation];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    [teamHeaderView.teamNameLabel setText:userTeam.name];
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%d-%d",userTeam.totalWins, userTeam.totalLosses]];
    if (history.count> 1 || history.count == 0) {
         [teamHeaderView.teamSeasonsLabel setText:[NSString stringWithFormat:@"Coaching for %ld seasons",history.count]];
    } else {
         [teamHeaderView.teamSeasonsLabel setText:@"Coaching for 1 season"];
    }
    [self.tableView setTableHeaderView:teamHeaderView];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    } else {
        return history.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Past Seasons";
    } else {
        return nil;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return @"Abbreviation Key:\nNCW - National Championship Win\nNCL - National Championship Loss\nSFW - Semifinal Win\nSFL - Semifinal Loss\nCC - Conference Champion\nBW - Bowl Win\nBL - Bowl Loss";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Seasons"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",history.count]];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Winning Percentage"];
            if ((userTeam.totalLosses + userTeam.totalWins) > 0) {
                int winPercent = (int)(100 * ((double)userTeam.totalWins) / ((double)(userTeam.totalWins + userTeam.totalLosses)));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%%",winPercent]];
            } else {
                [cell.detailTextLabel setText:@"0%"];
            }
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"Bowl Win Percentage"]; //XX% (W-L)
            if ((userTeam.totalBowlLosses + userTeam.totalBowls) > 0) {
                int winPercent = (int)(100 * ((double)userTeam.totalBowls) / ((double)(userTeam.totalBowls + userTeam.totalBowlLosses)));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,userTeam.totalBowls,userTeam.totalBowlLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 3) {
            [cell.textLabel setText:@"Conference Championships"];
            if ((userTeam.totalCCLosses + userTeam.totalCCs) > 0) {
                int winPercent = (int)(100 * ((double)userTeam.totalCCs) / ((double)(userTeam.totalCCs + userTeam.totalCCLosses)));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,userTeam.totalCCs,userTeam.totalCCLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else {
            [cell.textLabel setText:@"National Championships"];
            if ((userTeam.totalNCLosses + userTeam.totalNCs) > 0) {
                int winPercent = (int)(100 * ((double)userTeam.totalNCs) / ((double)(userTeam.totalNCs + userTeam.totalNCLosses)));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,userTeam.totalNCs,userTeam.totalNCLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        }
    } else {
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (2016 + indexPath.row)]];
        [cell.detailTextLabel setText:history[indexPath.row]];
    }
    
    return cell;
}


@end
