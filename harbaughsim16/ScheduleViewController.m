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

#import "HexColors.h"
#import "CSNotificationView.h"

@interface HBTeamView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRecordLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSchedule) name:@"playedWeek" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSchedule) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newStyleColor" object:nil];

    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)reloadAll {
    [self reloadSchedule];
    [self setupTeamHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupTeamHeader];
}

-(void)setupTeamHeader {
    NSString *rank = @"";
    if (userTeam.rankTeamPollScore < 26 && userTeam.rankTeamPollScore > 0) {
        rank = [NSString stringWithFormat:@"#%ld ",(long)userTeam.rankTeamPollScore];
    }
    [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, userTeam.name]];
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)(2016 + userTeam.teamHistory.count),(long)userTeam.wins,(long)userTeam.losses]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    
    League *simLeague = [HBSharedUtils getLeague];
    if (simLeague.currentWeek < 12) {
        [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 12) {
        [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 13) {
        [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 14) {
        [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
    } else {
        [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
    }
}

-(void)reloadSchedule {
    userTeam = [HBSharedUtils getLeague].userTeam;
    schedule = [[HBSharedUtils getLeague].userTeam.gameSchedule copy];
    [self.tableView reloadData];
    [self setupTeamHeader];
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
            [cell.gameScoreLabel setTextColor:[UIColor hx_colorWithHexRGBAString:@"#d7191c"]];
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


-(IBAction)playWeek:(id)sender {
    
    League *simLeague = [HBSharedUtils getLeague];
    
    if (simLeague.recruitingStage == 0) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 1;
            [self startRecruiting];
        } else {
            NSInteger numGamesPlayed = userTeam.gameWLSchedule.count;
            [simLeague playWeek];
            if (simLeague.currentWeek == 15) {
                // Show NCG summary
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)(2016 + userTeam.teamHistory.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            } else if (userTeam.gameWLSchedule.count > numGamesPlayed) {
                // Played a game, show summary - show notification
                NSString *gameSummary = [userTeam weekSummaryString];
                if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                    //[CSNotificationView showInViewController:self tintColor:[UIColor hx_colorWithHexRGBAString:@"#d7191c"] image:nil message:[NSString stringWithFormat:@"Week %ld Update - %@", (long)simLeague.currentWeek, [userTeam weekSummaryString]] duration:0.5];
                    [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#d7191c"] message:[NSString stringWithFormat:@"Week %ld Update - %@", (long)simLeague.currentWeek, [userTeam weekSummaryString]] onViewController:self];
                } else {
                    //[CSNotificationView showInViewController:self tintColor:[HBSharedUtils styleColor] image:nil message:[NSString stringWithFormat:@"Week %ld Update - %@", (long)simLeague.currentWeek, [userTeam weekSummaryString]] duration:0.5];
                    [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"Week %ld Update - %@", (long)simLeague.currentWeek, [userTeam weekSummaryString]] onViewController:self];
                }
                
            }
            
            // Show notification for being invited/not invited to bowl or CCG
            if (simLeague.currentWeek >= 12) {
                Game *nextGame = userTeam.gameSchedule[userTeam.gameSchedule.count - 1];
                if (!nextGame.hasPlayed) {
                    NSString *weekGameName = nextGame.gameName;
                    if ([weekGameName isEqualToString:@"NCG"]) {
                        //[CSNotificationView showInViewController:self tintColor:[HBSharedUtils styleColor] image:nil message:[NSString stringWithFormat:@"%@ was invited to the National Championship Game!",userTeam.name] duration:0.5];
                        [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"%@ was invited to the National Championship Game!",userTeam.name] onViewController:self];
                    } else {
                        //[CSNotificationView showInViewController:self tintColor:[HBSharedUtils styleColor] image:nil message:[NSString stringWithFormat:@"%@ was invited to the %@!",userTeam.name, weekGameName] duration:0.5];
                        [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"%@ was invited to the %@!",userTeam.name, weekGameName] onViewController:self];
                    }
                } else if (simLeague.currentWeek == 12) {
                    //[CSNotificationView showInViewController:self tintColor:[UIColor hx_colorWithHexRGBAString:@"#d7191c"] image:nil message:[NSString stringWithFormat:@"%@ was not invited to the %@ CCG.",userTeam.name,userTeam.conference] duration:0.5];
                    [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#d7191c"] message:[NSString stringWithFormat:@"%@ was not invited to the %@ CCG.",userTeam.name,userTeam.conference] onViewController:self];
                } else if (simLeague.currentWeek == 13) {
                    //[CSNotificationView showInViewController:self tintColor:[UIColor hx_colorWithHexRGBAString:@"#d7191c"] image:nil message:[NSString stringWithFormat:@"%@ was not invited to a bowl game",userTeam.name] duration:0.5];
                    [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#d7191c"] message:[NSString stringWithFormat:@"%@ was not invited to a bowl game.",userTeam.name] onViewController:self];
                    
                }
            }
            
            if (simLeague.currentWeek < 12) {
                [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 12) {
                [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 13) {
                NSString *heismanString = [simLeague getHeismanCeremonyStr];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld's Player of the Year", (long)(2016 + userTeam.teamHistory.count)] message:heismanString preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 14) {
                [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
            } else {
                [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
            }
            
            [self reloadSchedule];
            [self setupTeamHeader];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
        }
    } else {
        [self startRecruiting];
    }
}

-(void)startRecruiting {
    //in process of recruiting
    //beginRecruiting();
    NSLog(@"Recruiting");
    
    //show grad players screen
    //on user confirm, advance season and save game file
    //nav to recruiting
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Players Leaving", userTeam.abbreviation] message:[userTeam getGraduatingPlayersString] preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Start Recruiting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"endedSeason" object:nil];
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]] animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sim Recruiting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to sim recruiting?" message:@"If you choose to do so, your team's recruiting will be done automatically and you will have no control over who assistant coaches bring to your program. Do you still want to quit, coach?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [[HBSharedUtils getLeague] updateLeagueHistory];
            [[HBSharedUtils getLeague] updateTeamHistories];
            [userTeam simulateRecruitingSeason];
            [[HBSharedUtils getLeague] advanceSeasonForAllExceptUser];
            [HBSharedUtils getLeague].recruitingStage = 0;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endedSeason" object:nil];
            [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newSeasonStart" object:nil];
            NSLog(@"SIM RECRUITING");
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
