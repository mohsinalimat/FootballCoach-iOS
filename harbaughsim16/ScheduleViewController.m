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
-(void)runOnSaveInProgress {
    [teamHeaderView.playButton setEnabled:NO];
}

-(void)runOnSaveFinished {
    [teamHeaderView.playButton setEnabled:YES];
}

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
                [self playWeek:nil];
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
    League *simLeague = [HBSharedUtils getLeague];
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
    [teamHeaderView.playButton setEnabled:NO];
    if (simLeague.recruitingStage == 0) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 1;
            [HBSharedUtils getLeague].canRebrandTeam = YES;
            [[HBSharedUtils getLeague] save];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)(2016 + userTeam.teamHistory.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [simLeague playWeek];
                
                if (simLeague.currentWeek < 12) {
                    [self.navigationItem.leftBarButtonItem setEnabled:YES];
                    [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 12) {
                    NSString *heisman = [simLeague getHeismanCeremonyStr];
                    NSLog(@"HEISMAN: %@", heisman); //can't do anything with this result, just want to run it tbh
                    [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 13) {
                    [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 14) {
                    [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
                } else {
                    [HBSharedUtils getLeague].canRebrandTeam = YES;
                    [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
                    [self.navigationItem.leftBarButtonItem setEnabled:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSimButton" object:nil];
                }
                
                [self reloadSchedule];
                [self setupTeamHeader];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
                if (weekTotal > 1) {
                    [self simSeason:(weekTotal - 1)];
                } else {
                    [self.navigationItem.leftBarButtonItem setEnabled:YES];
                    [teamHeaderView.playButton setEnabled:YES];
                    [[HBSharedUtils getLeague] save];
                }
            });
        }
        
    } else {
        [self startRecruiting];
    }
}

-(void)resetSimButton {
    if ([HBSharedUtils getLeague].recruitingStage == 0) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2016 + [HBSharedUtils getLeague].leagueHistory.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSimButton) name:@"hideSimButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runOnSaveInProgress) name:@"saveInProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runOnSaveFinished) name:@"saveFinished" object:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2016 + [HBSharedUtils getLeague].leagueHistory.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
    if ([HBSharedUtils getLeague].currentWeek < 15) {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)hideSimButton {
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

-(void)reloadAll {
    [self reloadSchedule];
    [self setupTeamHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupTeamHeader];
}

-(void)setupTeamHeader {
    NSString *rank = @"";
    if ([HBSharedUtils getLeague].currentWeek > 0 && userTeam.rankTeamPollScore < 26 && userTeam.rankTeamPollScore > 0) {
        rank = [NSString stringWithFormat:@"#%ld ",(long)userTeam.rankTeamPollScore];
    }
    [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, userTeam.name]];
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)(2016 + userTeam.teamHistory.count),(long)userTeam.wins,(long)userTeam.losses]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    
    League *simLeague = [HBSharedUtils getLeague];
    if (simLeague.currentWeek < 12) {
        [HBSharedUtils getLeague].canRebrandTeam = NO;
        [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 12) {
        [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 13) {
        [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
    } else if (simLeague.currentWeek == 14) {
        [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
    } else {
        [HBSharedUtils getLeague].canRebrandTeam = YES;
        [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
    }
    [teamHeaderView.playButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
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


-(IBAction)playWeek:(id)sender {
    
    League *simLeague = [HBSharedUtils getLeague];
    
    if (simLeague.recruitingStage == 0) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 1;
            [HBSharedUtils getLeague].canRebrandTeam = YES;
            [self startRecruiting];
        } else {
            NSInteger numGamesPlayed = userTeam.gameWLSchedule.count;
            [simLeague playWeek];
            [[HBSharedUtils getLeague] save];
            if (simLeague.currentWeek == 15) {
                // Show NCG summary
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)(2016 + userTeam.teamHistory.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            } else if (userTeam.gameWLSchedule.count > numGamesPlayed) {
                // Played a game, show summary - show notification
                if (simLeague.currentWeek <= 12) {
                    NSString *gameSummary = [userTeam weekSummaryString];
                    if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"Week %ld: %@", (long)simLeague.currentWeek, [userTeam weekSummaryString]] onViewController:self];
                    } else {
                        [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"Week %ld: %@", (long)simLeague.currentWeek, [userTeam weekSummaryString]] onViewController:self];
                    }
                } else {
                    if (simLeague.currentWeek == 15) {
                        [self.navigationItem.leftBarButtonItem setEnabled:NO];
                        NSString *gameSummary = [userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"NCG: %@",[userTeam weekSummaryString]] onViewController:self];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"NCG: %@",[userTeam weekSummaryString]] onViewController:self];
                        }
                    } else if (simLeague.currentWeek == 14) {
                        NSString *gameSummary = [userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"Bowls: %@", [userTeam weekSummaryString]] onViewController:self];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"Bowls: %@", [userTeam weekSummaryString]] onViewController:self];
                        }
                    } else if (simLeague.currentWeek == 13) {
                        NSString *gameSummary = [userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"%@ CCG: %@", userTeam.conference, [userTeam weekSummaryString]] onViewController:self];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"%@ CCG: %@",userTeam.conference, [userTeam weekSummaryString]] onViewController:self];
                        }
                    }
                }
            }
            
            // Show notification for being invited/not invited to bowl or CCG
            if (simLeague.currentWeek >= 12) {
                Game *nextGame = userTeam.gameSchedule[userTeam.gameSchedule.count - 1];
                if (!nextGame.hasPlayed) {
                    NSString *weekGameName = nextGame.gameName;
                    if ([weekGameName isEqualToString:@"NCG"]) {
                        [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"%@ was invited to the National Championship Game!",userTeam.name] onViewController:self];
                    } else {
                        [HBSharedUtils showNotificationWithTintColor:[UIColor hx_colorWithHexRGBAString:@"#009740"] message:[NSString stringWithFormat:@"%@ was invited to the %@!",userTeam.name, weekGameName] onViewController:self];
                    }
                } else if (simLeague.currentWeek == 12) {
                    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"%@ was not invited to the %@ CCG.",userTeam.name,userTeam.conference] onViewController:self];
                } else if (simLeague.currentWeek == 13) {
                    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:[NSString stringWithFormat:@"%@ was not invited to a bowl game.",userTeam.name] onViewController:self];
                    
                }
            }
            
            if (simLeague.currentWeek < 12) {
                [HBSharedUtils getLeague].canRebrandTeam = NO;
                [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 12) {
                [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 13) {
                NSString *heismanString = [simLeague getHeismanCeremonyStr];
                NSArray *heismanParts = [heismanString componentsSeparatedByString:@"?"];
                NSMutableString *composeHeis = [NSMutableString string];
                for (int i = 1; i < heismanParts.count; i++) {
                    [composeHeis appendString:heismanParts[i]];
                }
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld's Player of the Year", (long)(2016 + userTeam.teamHistory.count)] message:composeHeis preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 14) {
                [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
            } else {
                [HBSharedUtils getLeague].canRebrandTeam = YES;
                [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSimButton" object:nil];
                [self.navigationItem.leftBarButtonItem setEnabled:NO];
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
    ////NSLog(@"Recruiting");
    [userTeam getGraduatingPlayers];
    NSString *gradPlayersStr = [userTeam getGraduatingPlayersString];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Players Leaving", userTeam.abbreviation] message:gradPlayersStr preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Start Recruiting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HBSharedUtils getLeague] updateTeamHistories];
        [[HBSharedUtils getLeague] updateLeagueHistory];
        [userTeam resetStats];
        [[HBSharedUtils getLeague] advanceSeason];
        [[HBSharedUtils getLeague] save];
        
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]] animated:YES completion:nil];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"View Mock Draft" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MockDraftViewController alloc] init]] animated:YES completion:nil];
        });
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
