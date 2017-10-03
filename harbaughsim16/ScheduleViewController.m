//
//  ScheduleViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Team.h"
#import "HBScheduleCell.h"
#import "GameDetailViewController.h"
#import "RecruitingViewController.h"
#import "MockDraftViewController.h"
#import "GraduatingPlayersViewController.h"

#import "HexColors.h"
#import "CSNotificationView.h"

@interface ScheduleViewController ()
{
    NSArray *schedule;
    Team *userTeam;
}
@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userTeam = [HBSharedUtils getLeague].userTeam;
    schedule = [[HBSharedUtils getLeague].userTeam.gameSchedule copy];
    self.title = @"Schedule";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScheduleCell" bundle:nil] forCellReuseIdentifier:@"HBScheduleCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSchedule) name:@"playedWeek" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSchedule) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSimButton) name:@"hideSimButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSaveFile" object:nil];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2016 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
    if ([HBSharedUtils getLeague].currentWeek < 15) {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)resetSimButton {
    if ([HBSharedUtils getLeague].recruitingStage == 0) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2016 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
}

-(void)hideSimButton {
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

-(void)reloadAll {
    [self reloadSchedule];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

-(void)reloadSchedule {
    userTeam = [HBSharedUtils getLeague].userTeam;
    schedule = [[HBSharedUtils getLeague].userTeam.gameSchedule copy];
    [self.tableView reloadData];
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
            [cell.gameScoreLabel setTextColor:[HBSharedUtils successColor]];
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
