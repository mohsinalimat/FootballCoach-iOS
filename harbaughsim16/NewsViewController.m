//
//  FirstViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "NewsViewController.h"
#import "Team.h"
#import "Game.h"
#import "harbaughsim16-swift.h"
#import "RecruitingViewController.h"

#define WHISPER_DELAY 1.0

@interface HBTeamPlayView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRecordLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@end

@implementation HBTeamPlayView
@end


@interface NewsViewController ()
{
    NSArray *news;
    Team *userTeam;
    IBOutlet HBTeamPlayView *teamHeaderView;
    int curNewsWeek;
}
@end

@implementation NewsViewController

-(void)simulateEntireSeason {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to sim this season?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self simSeason];
        NSLog(@"SIMULATE SEASON");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)simSeason {
    
    League *simLeague = [HBSharedUtils getLeague];
    
    if (simLeague.recruitingStage == -1) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 0;
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (NSInteger)(2016 + userTeam.teamHistory.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
            /*[alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self startRecruiting];
            }]];*/
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
            //[self startRecruiting];
        } else {
            [simLeague playWeek];
            
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
                [WhisperBridge shout:@"Offseason Update" message:@"Recruiting is now available!" toViewController:self];
            }
            
            [self reloadNews:[HBSharedUtils getLeague].currentWeek];
            [self setupTeamHeader];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
            [self simSeason];
        }
    } else {
        [self startRecruiting];
    }

    
}

-(IBAction)playWeek:(id)sender {

    League *simLeague = [HBSharedUtils getLeague];
    
    if (simLeague.recruitingStage == -1) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 0;
            [self startRecruiting];
        } else {
            NSInteger numGamesPlayed = userTeam.gameWLSchedule.count;
            [simLeague playWeek];
            if (simLeague.currentWeek == 15) {
                // Show NCG summary
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (NSInteger)(2016 + userTeam.teamHistory.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                
            } else if (userTeam.gameWLSchedule.count > numGamesPlayed) {
                // Played a game, show summary - show notification
                [WhisperBridge shout:[NSString stringWithFormat:@"Week %d Update", simLeague.currentWeek] message:[userTeam weekSummaryString] toViewController:self];
                
            }
            
            // Show notification for being invited/not invited to bowl or CCG
            if (simLeague.currentWeek >= 12) {
                Game *nextGame = userTeam.gameSchedule[userTeam.gameSchedule.count - 1];
                if (!nextGame.hasPlayed) {
                    NSString *weekGameName = nextGame.gameName;
                    if ([weekGameName isEqualToString:@"NCG"]) {
                        [WhisperBridge shout:@"Congratulations!" message:[NSString stringWithFormat:@"%@ was invited to the National Championship Game!",userTeam.name] toViewController:self];
                    } else {
                       [WhisperBridge shout:@"Congratulations!" message:[NSString stringWithFormat:@"%@ was invited to the %@!",userTeam.name, weekGameName] toViewController:self];
                    }
                } else if (simLeague.currentWeek == 12) {
                    [WhisperBridge shout:@"Postseason Update" message:[NSString stringWithFormat:@"%@ was not invited to the %@ CCG.",userTeam.name,userTeam.conference] toViewController:self];
                } else if (simLeague.currentWeek == 13) {
                    //Toast.makeText(MainActivity.this, userTeam.name + " was not invited to a bowl game.", Toast.LENGTH_SHORT).show();
                    [WhisperBridge shout:@"Postseason Update" message:[NSString stringWithFormat:@"%@ was not invited to a bowl game.",userTeam.name] toViewController:self];
                    
                }
            }
            
            if (simLeague.currentWeek < 12) {
                [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 12) {
                [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 13) {
                NSString *heismanString = [simLeague getHeismanCeremonyStr];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld's Player of the Year", (NSInteger)(2016 + userTeam.teamHistory.count)] message:heismanString preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                
                [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 14) {
                [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
            } else {
                [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
                [WhisperBridge shout:@"Offseason Update" message:@"Recruiting is now available!" toViewController:self];
            }
            
            [self reloadNews:[HBSharedUtils getLeague].currentWeek];
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
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]] animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sim Recruiting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to sim recruiting?" message:@"If you choose to do so, your team's recruiting will be done automatically and you will have no control over who assistant coaches bring to your program. Do you still want to quit, coach?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //sim recruiting for this guy
            NSLog(@"SIM RECRUITING");
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
    /*
     @Override
     public void onClick(DialogInterface dialog, int which) {
     simLeague.updateLeagueHistory();
     simLeague.updateTeamHistories();
     userTeam.resetStats();
     simLeague.advanceSeason();
     [[NSNotificationCenter defaultCenter] postNotificationName:@"endedSeason" object:nil];
     saveLeagueFile = new File(getFilesDir(), "saveLeagueRecruiting.cfb");
     simLeague.saveLeague(saveLeagueFile);
     
     //Get String of user team's players and such
     StringBuilder sb = new StringBuilder();
     sb.append(userTeam.conference + "," + userTeam.name + "," + userTeam.abbr + "," + userTeam.teamPrestige + "%\n");
     sb.append(userTeam.getPlayerInfoSaveFile());
     sb.append("END_TEAM_INFO%\n");
     sb.append(userTeam.getRecruitsInfoSaveFile());
     
     }
     });
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Latest News";
    //[self setupTeamHeader];
    [self reloadNews:[HBSharedUtils getLeague].currentWeek];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setTableHeaderView:teamHeaderView];
    self.tableView.estimatedRowHeight = 75;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortNews)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNews) name:@"newNewsStory" object:nil];
    self.view.backgroundColor = [HBSharedUtils styleColor];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sim" style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
}

-(void)refreshNews {
    [self reloadNews:[HBSharedUtils getLeague].currentWeek];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTeamHeader {
    if (!userTeam) {
        [teamHeaderView.teamRankLabel setText:@" "];
        userTeam = [HBSharedUtils getLeague].userTeam;
    }
    
    if (userTeam) {
        NSString *rank = @"";
        if (userTeam.rankTeamPollScore < 26 && userTeam.rankTeamPollScore > 0) {
            rank = [NSString stringWithFormat:@"#%ld ",(long)userTeam.rankTeamPollScore];
        }
        [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, userTeam.name]];
        [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)(2016 + userTeam.teamHistory.count),(long)userTeam.wins,(long)userTeam.losses]];
    } else {
        [teamHeaderView.teamRankLabel setText:@""];
        [teamHeaderView.teamRecordLabel setText:@"0-0"];
    }
    
    
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

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)sortNews {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View news from a specific week" message:@"Which week would you like to see?" preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < [HBSharedUtils getLeague].newsStories.count; i++) {
        NSString *week = @"";
        if (i > 0 && i < 12) {
            week = [NSString stringWithFormat:@"Week %ld", (long)(i)];
        } else if (i == 0) {
            week = @"Preseason";
        } else if (i == 12) {
            week = @"Conference Championships";
        } else if (i == 13) {
            week = @"Bowls";
        } else if (i == 14) {
            week = @"National Championship";
        } else  {
            week = @"Offseason";
        }
        NSMutableArray *curArr = [HBSharedUtils getLeague].newsStories[i];
        if (curArr.count > 0) {
            [alertController addAction:[UIAlertAction actionWithTitle:week style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self reloadNews:i];
                [self.tableView reloadData];
            }]];
        }
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)reloadNews:(int)curWeek {
    curNewsWeek = curWeek;
    news = [HBSharedUtils getLeague].newsStories[curWeek];
    
    if (curNewsWeek == [HBSharedUtils getLeague].currentWeek) {
        self.title = @"Latest News";
    } else {
        NSString *week = @"";
        if (curNewsWeek > 0 && curNewsWeek < 12) {
            week = [NSString stringWithFormat:@"Week %ld", (long)(curNewsWeek)];
        } else if (curNewsWeek == 0) {
            week = @"Preseason";
        } else if (curNewsWeek == 12) {
            week = @"Conference Championships";
        } else if (curNewsWeek == 13) {
            week = @"Bowl";
        } else if (curNewsWeek == 14) {
            week = @"National Championship";
        } else  {
            week = @"Offseason";
        }

        self.title = [NSString stringWithFormat:@"%@ News", week];
    }
    [self setupTeamHeader];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([HBSharedUtils getLeague]) {
        return 1;
    } else {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([HBSharedUtils getLeague]) {
        return [news count];
    } else {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.textLabel setNumberOfLines:0];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    //NSMutableArray *week = ;
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:news[indexPath.row]];
    NSRange firstLine = [attString.string rangeOfString:@"\n"];
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(0, firstLine.location)];
    
    
    [cell.textLabel setAttributedText:attString];
    [cell.textLabel sizeToFit];
    if (curNewsWeek > 0 && curNewsWeek < 12) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"Week %ld", (long)(curNewsWeek)]];
    } else if (curNewsWeek == 0) {
        [cell.detailTextLabel setText:@"Preseason"];
    } else if (curNewsWeek == 12) {
        [cell.detailTextLabel setText:@"Conference Championships"];
    } else if (curNewsWeek == 13) {
        [cell.detailTextLabel setText:@"Bowls"];
    } else if (curNewsWeek == 14) {
        [cell.detailTextLabel setText:@"National Championship"];
    } else  {
        [cell.detailTextLabel setText:@"Offseason"];
    }
    
    
    return cell;
}

@end
