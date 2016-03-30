//
//  TeamRecordsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/30/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamRecordsViewController.h"
#import "Team.h"
@interface TeamRecordsViewController ()
{
    Team *selectedTeam;
}
@end

@implementation TeamRecordsViewController
-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithTeam:(Team*)team {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        selectedTeam = team;
    }
    return self;
}

- (void)viewDidLoad {
    self.title = [NSString stringWithFormat:@"%@ Records",selectedTeam.abbreviation];
    [super viewDidLoad];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 13;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Single Season";
    } else {
        return @"Career";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"Completions"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearCompletions,(long)selectedTeam.teamRecordCompletions]];
    } else if (indexPath.row == 1) {
        [cell.textLabel setText:@"Passing Yards"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld yds", (long)selectedTeam.teamRecordYearPassYards,(long)selectedTeam.teamRecordPassYards]];
    } else if (indexPath.row == 2) {
        [cell.textLabel setText:@"Passing Touchdowns"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearPassTDs,(long)selectedTeam.teamRecordPassTDs]];
    } else if (indexPath.row == 3) {
        [cell.textLabel setText:@"Interceptions"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearInt,(long)selectedTeam.teamRecordInt]];
    } else if (indexPath.row == 4) {
        [cell.textLabel setText:@"Carries"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearRushAtt,(long)selectedTeam.teamRecordRushAtt]];
    } else if (indexPath.row == 5) {
        [cell.textLabel setText:@"Rushing Yards"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld yds", (long)selectedTeam.teamRecordYearRushYards,(long)selectedTeam.teamRecordRushYards]];
    } else if (indexPath.row == 6) {
        [cell.textLabel setText:@"Rushing Touchdowns"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearRushTDs,(long)selectedTeam.teamRecordRushTDs]];
    } else if (indexPath.row == 7) {
        [cell.textLabel setText:@"Fumbles"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearFum,(long)selectedTeam.teamRecordFum]];
    } else if (indexPath.row == 8) {
        [cell.textLabel setText:@"Receptions"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearReceptions,(long)selectedTeam.teamRecordReceptions]];
    } else if (indexPath.row == 9) {
        [cell.textLabel setText:@"Receiving Yards"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld yds", (long)selectedTeam.teamRecordYearRecYards,(long)selectedTeam.teamRecordRecYards]];
    } else if (indexPath.row == 10) {
        [cell.textLabel setText:@"Receiving Touchdowns"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearRecTDs,(long)selectedTeam.teamRecordRecTDs]];
    } else if (indexPath.row == 11) {
        [cell.textLabel setText:@"Extra Points Made"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearXPMade,(long)selectedTeam.teamRecordXPMade]];
    } else {
        [cell.textLabel setText:@"Field Goals Made"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)selectedTeam.teamRecordYearFGMade,(long)selectedTeam.teamRecordFGMade]];
    }
    
    return cell;
}

@end
