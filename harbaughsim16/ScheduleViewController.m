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
-(void)simulateEntireSeason {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to sim this season?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[self simSeason:16]; - to offseason
            //[self simSeason:12]; - to ccg week
            //[self simSeason:13]; - to bowl week
            //[self simSeason:6]; - to mid season
            //[self playWeek:nil]; - next week
            int curWeek = [HBSharedUtils getLeague].currentWeek;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sim to a specific point" message:@"When in the season do you want to sim to?" preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Next Week" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [HBSharedUtils playWeek:self headerView:nil callback:^{
                    [self.tableView reloadData];
                    //[self setupTeamHeader];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
                }];
            }]];
            
            if (curWeek < 6) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Midseason" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self simSeason:(6 - curWeek)];
                }]];
            }
            
            if (curWeek < 12) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Conference Championship Week" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self simSeason:(12 - curWeek)];
                }]];
            }
            
            if (curWeek < 13) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Bowl Week" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self simSeason:(13 - curWeek)];
                }]];
            }
            
            if (curWeek < 16) {
                [alertController addAction:[UIAlertAction actionWithTitle:@"Offseason" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self simSeason:(16 - curWeek)];
                }]];
            }
            
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)simSeason:(NSInteger)weekTotal {
    [HBSharedUtils simulateEntireSeason:(int)weekTotal viewController:self headerView:nil callback:^{
        if ([HBSharedUtils getLeague].currentWeek <= 15) {
            [self.tableView reloadData];
        }
        //[self setupTeamHeader];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
    }];
}

-(void)resetSimButton {
    if ([HBSharedUtils getLeague].recruitingStage == 0) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2017 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
}

-(void)hideSimButton {
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    userTeam = [HBSharedUtils getLeague].userTeam;
    schedule = [[HBSharedUtils getLeague].userTeam.gameSchedule copy];
    self.title = @"Schedule";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScheduleCell" bundle:nil] forCellReuseIdentifier:@"HBScheduleCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSchedule) name:@"playedWeek" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSchedule) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSimButton) name:@"hideSimButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSaveFile" object:nil];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2017 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
    if ([HBSharedUtils getLeague].currentWeek < 15) {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
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
