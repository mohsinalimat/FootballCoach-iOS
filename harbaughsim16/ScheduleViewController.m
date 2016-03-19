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

#import "HexColors.h"

@interface HBTeamView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRecordLabel;
@end

@implementation HBTeamView
@end

@interface ScheduleViewController ()
{
    NSArray *schedule;
    Team *userTeam;
    IBOutlet HBTeamView *teamHeaderView;
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
    self.tableView.tableHeaderView = teamHeaderView;
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScheduleCell" bundle:nil] forCellReuseIdentifier:@"HBScheduleCell"];
    [self setupTeamHeader];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTeamHeader) name:@"playedWeek" object:nil];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)setupTeamHeader {
    NSString *rank = @"";
    if (userTeam.rankTeamPollScore < 26) {
        rank = [NSString stringWithFormat:@"#%ld ",(long)userTeam.rankTeamPollScore];
    }
    [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, userTeam.name]];
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld-%ld",(long)userTeam.wins,(long)userTeam.losses]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)reloadSchedule {
    schedule = [[HBSharedUtils getLeague].userTeam.gameSchedule copy];
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return schedule.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBScheduleCell *cell = (HBScheduleCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScheduleCell"];
    //Game *game = schedule[indexPath.row];
    int index = [NSNumber numberWithInteger:indexPath.row].intValue;
    [cell.gameNameLabel setText:[userTeam getGameSummaryStrings:index][0]];
    [cell.gameScoreLabel setText:[userTeam getGameSummaryStrings:index][1]];
    [cell.gameSummaryLabel setText:[userTeam getGameSummaryStrings:index][2]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Game *game = schedule[indexPath.row];
    [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:game] animated:YES];
}

-(IBAction)playWeek:(id)sender {
    [[HBSharedUtils getLeague] playWeek];
    [self reloadSchedule];
    [self setupTeamHeader];
}

@end
