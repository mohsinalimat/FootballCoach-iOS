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
#import "RecruitingViewController.h"
#import "HeismanLeadersViewController.h"
#import "BowlProjectionViewController.h"
#import "RankingsViewController.h"
#import "AllLeagueTeamViewController.h"
#import "AllConferenceTeamConferenceSelectorViewController.h"
#import "AllConferenceTeamViewController.h"
#import "ConferenceStandingsSelectorViewController.h"
#import "ConferenceStandingsViewController.h"
#import "MockDraftViewController.h"
#import "GraduatingPlayersViewController.h"
#import "HBTeamPlayView.h"

#import "CSNotificationView.h"
#import "HexColors.h"
#import "STPopup.h"
#import "UIScrollView+EmptyDataSet.h"

@interface NewsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSArray *news;
    Team *userTeam;
    IBOutlet HBTeamPlayView *teamHeaderView;
    int curNewsWeek;
    STPopupController *popupController;
}
@end

@implementation NewsViewController

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No news this week";
    font = [UIFont boldSystemFontOfSize:17.0];
    textColor = [UIColor lightTextColor];
    
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    text = @"Every week, news of upsets and thrilling victories from around the league will be posted here.";
    font = [UIFont systemFontOfSize:15.0];
    textColor = [UIColor lightTextColor];
    
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [HBSharedUtils styleColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0;
}

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

-(void)runOnSaveInProgress {
    [teamHeaderView.playButton setEnabled:NO];
}

-(void)runOnSaveFinished {
    [teamHeaderView.playButton setEnabled:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupTeamHeader];
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
    [HBSharedUtils simulateEntireSeason:(int)weekTotal viewController:self headerView:teamHeaderView callback:^{
        if ([HBSharedUtils getLeague].currentWeek <= 15) {
            [self.tableView reloadData];
        }
        [self setupTeamHeader];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
    }];
}

-(void)resetSimButton {
    if ([HBSharedUtils getLeague].currentWeek < 19) {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2016 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
}

-(void)hideSimButton {
    [self.navigationItem.leftBarButtonItem setEnabled:NO];
}

-(IBAction)playWeek:(id)sender {
    [HBSharedUtils playWeek:self headerView:teamHeaderView callback:^{
        [self.tableView reloadData];
        [self setupTeamHeader];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"playedWeek" object:nil];
    }];
}

-(void)startRecruiting {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld %@ Offseason", (long)([HBSharedUtils getLeague].leagueHistoryDictionary.count + 2016), userTeam.abbreviation] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"View Players Leaving" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController pushViewController:[[GraduatingPlayersViewController alloc] init] animated:YES];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Start Recruiting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_OFFSEASON_TUTORIAL_SHOWN_KEY];
        if (!tutorialShown) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_OFFSEASON_TUTORIAL_SHOWN_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //display intro screen
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController *tutorialAlert = [UIAlertController alertControllerWithTitle:@"Offseason Warning" message:@"Once you start the offseason, it is recommended that you do not quit or leave the game until you complete the draft and move on to the next season. Doing so may result in the corruption of your save file. Are you sure you wish to continue?" preferredStyle:UIAlertControllerStyleAlert];
                [tutorialAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [[HBSharedUtils getLeague] updateTeamHistories];
                    [[HBSharedUtils getLeague] updateLeagueHistory];
                    [userTeam resetStats];
                    [[HBSharedUtils getLeague] advanceSeason];
                    [[HBSharedUtils getLeague] save];
                    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]] animated:YES completion:nil];
                }]];
                [tutorialAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:tutorialAlert animated:YES completion:nil];
            });
        } else {
            [[HBSharedUtils getLeague] updateTeamHistories];
            [[HBSharedUtils getLeague] updateLeagueHistory];
            [userTeam resetStats];
            [[HBSharedUtils getLeague] advanceSeason];
            [[HBSharedUtils getLeague] save];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingViewController alloc] init]] animated:YES completion:nil];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"View Mock Draft" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MockDraftViewController alloc] init]] animated:YES completion:nil];
        });
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Latest News";
    [self reloadNews:[HBSharedUtils getLeague].currentWeek];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setTableHeaderView:teamHeaderView];
    self.tableView.estimatedRowHeight = 75;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"Sim %ld",(long)(2016 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)] style:UIBarButtonItemStylePlain target:self action:@selector(simulateEntireSeason)];
    if ([HBSharedUtils getLeague].currentWeek < 15) {
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
    } else {
        [self.navigationItem.leftBarButtonItem setEnabled:NO];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortNews)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNews) name:@"newNewsStory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNews) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideSimButton) name:@"hideSimButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSimButton) name:@"newSaveFile" object:nil];
    self.view.backgroundColor = [HBSharedUtils styleColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToConfTeam:) name:@"pushToConfTeam" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToConfStandings:) name:@"pushToConfStandings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runOnSaveInProgress) name:@"saveInProgress" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(runOnSaveFinished) name:@"saveFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertToSanction) name:@"userTeamSanctioned" object:nil];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

-(void)alertToSanction {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Sanctioned!" message:@"Your team has been sanctioned by the league for this season. As a result, you have lost 30 prestige." preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.03 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self presentViewController:controller animated:YES completion:nil];
    });
}

-(void)pushToConfTeam:(NSNotification*)confNotification {
    Conference *conf = (Conference*)[confNotification object];
    //delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[[AllConferenceTeamViewController alloc] initWithConference:conf] animated:YES];
    });
}

-(void)pushToConfStandings:(NSNotification*)confNotification {
    Conference *conf = (Conference*)[confNotification object];
    //delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:[[ConferenceStandingsViewController alloc] initWithConference:conf] animated:YES];
    });
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self setupTeamHeader];
    [self refreshNews];
}

-(void)refreshNews {
    int curWeek = [HBSharedUtils getLeague].currentWeek;
    if (curWeek <= 15) {
        [self reloadNews:curWeek];
    }
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
    userTeam = [HBSharedUtils getLeague].userTeam;
    if (userTeam) {
        NSString *rank = @"";
        if ([HBSharedUtils getLeague].currentWeek > 0 && userTeam.rankTeamPollScore < 26 && userTeam.rankTeamPollScore > 0) {
            rank = [NSString stringWithFormat:@"#%ld ",(long)userTeam.rankTeamPollScore];
        }
        [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, userTeam.name]];
        [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)(2016 + userTeam.teamHistoryDictionary.count),(long)userTeam.wins,(long)userTeam.losses]];
    } else {
        [teamHeaderView.teamRankLabel setText:@""];
        [teamHeaderView.teamRecordLabel setText:@"0-0"];
    }
    [teamHeaderView.playButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateDisabled];
    
    
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
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)sortNews {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View news from a specific week" message:@"Which week would you like to see?" preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < [HBSharedUtils getLeague].newsStories.count; i++) {
        NSString *week = @"";
        if (i > 0 && i <= 12) {
            week = [NSString stringWithFormat:@"Week %ld", (long)(i)];
        } else if (i == 0) {
            week = @"Preseason";
        } else if (i == 13) {
            week = @"Conference Championships";
        } else if (i == 14) {
            week = @"Bowls";
        } else if (i == 15) {
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
    if (curWeek > 15) {
        curWeek = 15;
    }
    
    curNewsWeek = curWeek;
    news = [HBSharedUtils getLeague].newsStories[curWeek];
    
    if (curNewsWeek == [HBSharedUtils getLeague].currentWeek) {
        self.navigationItem.title = @"Latest News";
    } else {
        NSString *week = @"";
        if (curNewsWeek > 0 && curNewsWeek <= 12) {
            week = [NSString stringWithFormat:@"Week %ld", (long)(curNewsWeek)];
        } else if (curNewsWeek == 0) {
            week = @"Preseason";
        } else if (curNewsWeek == 13) {
            week = @"Conference Championships";
        } else if (curNewsWeek == 14) {
            week = @"Bowl";
        } else if (curNewsWeek == 15) {
            week = @"National Championship";
        } else  {
            week = @"Offseason";
        }
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@ News", week];
    }
    [self setupTeamHeader];
    [self.tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([HBSharedUtils getLeague]) {
        if ([HBSharedUtils getLeague].currentWeek > 5) {
            return 2;
        } else {
            return 1;
        }
    } else {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([HBSharedUtils getLeague]) {
        if ([HBSharedUtils getLeague].currentWeek > 5) {
            if (section == 0) {
                if ([HBSharedUtils getLeague].currentWeek >= 15) {
                    return 6;
                } else {
                    return 4;
                }
            } else {
                return [news count];
            }
        } else {
            return [news count];
        }
    } else {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([HBSharedUtils getLeague].currentWeek > 5) {
        if (indexPath.section == 0) {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"NewsCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewsCell"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
            }
            
            if ([HBSharedUtils getLeague].currentWeek >= 15) {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"Final Polls";
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"Conference Standings"];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText:@"POTY Results"];
                } else if (indexPath.row == 3) {
                    cell.textLabel.text = @"Bowl Results";
                } else if (indexPath.row == 4) {
                    [cell.textLabel setText:@"All-League Team"];
                } else {
                    [cell.textLabel setText:@"All-Conference Teams"];
                }
            } else if ([HBSharedUtils getLeague].currentWeek == 13) {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"Current Polls";
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"Conference Standings"];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText:@"POTY Results"];
                } else {
                   cell.textLabel.text = @"Bowl Schedule";
                }
            } else if ([HBSharedUtils getLeague].currentWeek == 14) {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"Current Polls";
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"Conference Standings"];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText:@"POTY Results"];
                } else {
                    cell.textLabel.text = @"Bowl Results";
                }
            }  else {
                if (indexPath.row == 0) {
                    cell.textLabel.text = @"Current Polls";
                } else if (indexPath.row == 1) {
                    [cell.textLabel setText:@"Conference Standings"];
                } else if (indexPath.row == 2) {
                    [cell.textLabel setText:@"POTY Leaders"];
                } else {
                   cell.textLabel.text = @"Bowl Predictions";
                }
            }
            
            return cell;
        } else {
            UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
                [cell.textLabel setNumberOfLines:0];
                [cell setBackgroundColor:[UIColor whiteColor]];
                [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
            }
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:news[indexPath.row] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
            NSRange firstLine = [attString.string rangeOfString:@"\n"];
            [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium] range:NSMakeRange(0, firstLine.location)];
            
            
            [cell.textLabel setAttributedText:attString];
            [cell.textLabel sizeToFit];
            if (curNewsWeek > 0 && curNewsWeek <= 12) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"Week %ld", (long)(curNewsWeek)]];
            } else if (curNewsWeek == 0) {
                [cell.detailTextLabel setText:@"Preseason"];
            } else if (curNewsWeek == 13) {
                [cell.detailTextLabel setText:@"Conference Championships"];
            } else if (curNewsWeek == 14) {
                [cell.detailTextLabel setText:@"Bowls"];
            } else if (curNewsWeek == 15) {
                [cell.detailTextLabel setText:@"National Championship"];
            } else  {
                [cell.detailTextLabel setText:@"Offseason"];
            }
            
            
            return cell;
        }
    } else {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            [cell.textLabel setNumberOfLines:0];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
            
        }
        
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:news[indexPath.row] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]}];
        NSRange firstLine = [attString.string rangeOfString:@"\n"];
        [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18 weight:UIFontWeightMedium] range:NSMakeRange(0, firstLine.location)];
        
        
        [cell.textLabel setAttributedText:attString];
        [cell.textLabel sizeToFit];
        if (curNewsWeek > 0 && curNewsWeek <= 12) {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"Week %ld", (long)(curNewsWeek)]];
        } else if (curNewsWeek == 0) {
            [cell.detailTextLabel setText:@"Preseason"];
        } else if (curNewsWeek == 13) {
            [cell.detailTextLabel setText:@"Conference Championships"];
        } else if (curNewsWeek == 14) {
            [cell.detailTextLabel setText:@"Bowls"];
        } else if (curNewsWeek == 15) {
            [cell.detailTextLabel setText:@"National Championship"];
        } else  {
            [cell.detailTextLabel setText:@"Offseason"];
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([HBSharedUtils getLeague].currentWeek > 5) {
        if (indexPath.section == 0) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[[RankingsViewController alloc] initWithStatType:HBStatTypePollScore] animated:YES];
            } else if (indexPath.row == 1) {
                popupController = [[STPopupController alloc] initWithRootViewController:[[ConferenceStandingsSelectorViewController alloc] init]];
                [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
                [popupController.navigationBar setDraggable:YES];
                popupController.style = STPopupStyleBottomSheet;
                [popupController presentInViewController:self];
            } else if (indexPath.row == 2) {
                [self.navigationController pushViewController:[[HeismanLeadersViewController alloc] init] animated:YES];
            } else if (indexPath.row == 3) {
                [self.navigationController pushViewController:[[BowlProjectionViewController alloc] init] animated:YES];
            } else if (indexPath.row == 4) {
                [self.navigationController pushViewController:[[AllLeagueTeamViewController alloc] init] animated:YES];
            } else {
                popupController = [[STPopupController alloc] initWithRootViewController:[[AllConferenceTeamConferenceSelectorViewController alloc] init]];
                [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
                [popupController.navigationBar setDraggable:YES];
                popupController.style = STPopupStyleBottomSheet;
                [popupController presentInViewController:self];
            }
        }
    }
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

@end
