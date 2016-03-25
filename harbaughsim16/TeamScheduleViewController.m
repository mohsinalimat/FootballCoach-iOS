//
//  TeamScheduleViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamScheduleViewController.h"
#import "Team.h"
#import "Game.h"
#import "HBScheduleCell.h"
#import "GameDetailViewController.h"

#import "HexColors.h"

@interface TeamScheduleViewController ()
{
    Team *userTeam;
    NSArray *schedule;
}
@end

@implementation TeamScheduleViewController

-(instancetype)initWithTeam:(Team*)team {
    if (self = [super init]) {
        userTeam = team;
        schedule = [team.gameSchedule copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //userTeam = [HBSharedUtils getLeague].userTeam;
    //schedule = [[HBSharedUtils getLeague].userTeam.gameSchedule copy];
    self.title = [NSString stringWithFormat:@"%@ Schedule",userTeam.abbreviation];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScheduleCell" bundle:nil] forCellReuseIdentifier:@"HBScheduleCell"];

    
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return schedule.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBScheduleCell *cell = (HBScheduleCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScheduleCell"];
    //Game *game = schedule[indexPath.row];
    int index = [NSNumber numberWithInteger:indexPath.row].intValue;
    [cell.gameNameLabel setText:[userTeam getGameSummaryStrings:index][0]];
    [cell.gameScoreLabel setText:[userTeam getGameSummaryStrings:index][1]];
    [cell.gameSummaryLabel setText:[userTeam getGameSummaryStrings:index][2]];
    
    if (userTeam.gameWLSchedule.count > 0) {
        if ([cell.gameScoreLabel.text containsString:@"W"]) {
            [cell.gameScoreLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"#1a9641"]];
        } else if ([cell.gameScoreLabel.text containsString:@"L"]) {
            [cell.gameScoreLabel setTextColor:[HBSharedUtils errorColor]];
        } else {
            [cell.gameScoreLabel setTextColor:[UIColor blackColor]];
        }
    } else {
        [cell.gameScoreLabel setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Game *game = schedule[indexPath.row];
    [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:game] animated:YES];
}


@end
