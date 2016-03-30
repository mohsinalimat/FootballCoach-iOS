//
//  LeagueRecordsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/30/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "LeagueRecordsViewController.h"
#import "League.h"

@interface LeagueRecordsViewController ()
{
    League *curLeague;
}
@end

@implementation LeagueRecordsViewController
-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    curLeague = [HBSharedUtils getLeague];
    self.title = @"League Records";
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
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
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearCompletions,(long)curLeague.leagueRecordCompletions]];
    } else if (indexPath.row == 1) {
        [cell.textLabel setText:@"Passing Yards"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld yds", (long)curLeague.leagueRecordYearPassYards,(long)curLeague.leagueRecordPassYards]];
    } else if (indexPath.row == 2) {
        [cell.textLabel setText:@"Passing Touchdowns"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearPassTDs,(long)curLeague.leagueRecordPassTDs]];
    } else if (indexPath.row == 3) {
        [cell.textLabel setText:@"Interceptions"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearInt,(long)curLeague.leagueRecordInt]];
    } else if (indexPath.row == 4) {
        [cell.textLabel setText:@"Carries"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearRushAtt,(long)curLeague.leagueRecordRushAtt]];
    } else if (indexPath.row == 5) {
        [cell.textLabel setText:@"Rushing Yards"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld yds", (long)curLeague.leagueRecordYearRushYards,(long)curLeague.leagueRecordRushYards]];
    } else if (indexPath.row == 6) {
        [cell.textLabel setText:@"Rushing Touchdowns"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearRushTDs,(long)curLeague.leagueRecordRushTDs]];
    } else if (indexPath.row == 7) {
        [cell.textLabel setText:@"Fumbles"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearFum,(long)curLeague.leagueRecordFum]];
    } else if (indexPath.row == 8) {
        [cell.textLabel setText:@"Receptions"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearReceptions,(long)curLeague.leagueRecordReceptions]];
    } else if (indexPath.row == 9) {
        [cell.textLabel setText:@"Receiving Yards"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld yds", (long)curLeague.leagueRecordYearRecYards,(long)curLeague.leagueRecordRecYards]];
    } else if (indexPath.row == 10) {
        [cell.textLabel setText:@"Receiving Touchdowns"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearRecTDs,(long)curLeague.leagueRecordRecTDs]];
    } else if (indexPath.row == 11) {
        [cell.textLabel setText:@"Extra Points Made"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearXPMade,(long)curLeague.leagueRecordXPMade]];
    } else {
        [cell.textLabel setText:@"Field Goals Made"];
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld - %ld", (long)curLeague.leagueRecordYearFGMade,(long)curLeague.leagueRecordFGMade]];
    }
    
    return cell;
}


@end
