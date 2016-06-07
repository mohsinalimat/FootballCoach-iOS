//
//  GameDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "GameDetailViewController.h"
#import "Game.h"
#import "Team.h"
#import "Player.h"
#import "HBStatsCell.h"
#import "HBPlayerCell.h"
#import "PlayerDetailViewController.h"
#import "TeamViewController.h"
#import "HBScoreCell.h"
#import "TeamStreak.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "HexColors.h"

@interface GameDetailViewController ()
{
    Game *selectedGame;
    NSDictionary *stats;
    Player *heisman;
}
@end

@implementation GameDetailViewController

-(instancetype)initWithGame:(Game *)game {
    self = [super init];
    if(self) {
        selectedGame = game;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Game";
    heisman = [[HBSharedUtils getLeague] heisman];
    stats = [selectedGame gameReport];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBStatsCell" bundle:nil] forCellReuseIdentifier:@"HBStatsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBPlayerCell" bundle:nil] forCellReuseIdentifier:@"HBPlayerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScoreCell" bundle:nil] forCellReuseIdentifier:@"HBScoreCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

-(void)viewGameSummary {
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController.view setBackgroundColor:[UIColor whiteColor]];
    viewController.title = @"Summary";

    NSString *summary = [selectedGame gameSummary];
    
    CGSize size = [summary boundingRectWithSize:CGSizeMake(260, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
    UITextView *postTextLabel = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, size.height)];
    [postTextLabel setSelectable:NO];
    [postTextLabel setEditable:NO];

    [postTextLabel setText:summary];
    [postTextLabel sizeToFit];
    [postTextLabel.textContainer setSize:postTextLabel.frame.size];
    
    
    [viewController setView:postTextLabel];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return 75;
        } else {
            return 50;
        }
    } else {
        return 60;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:15.0]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 48;
    } else {
        return 36;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 36;
    } else {
        return 18;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (!selectedGame.hasPlayed) {
            return @"Players to Watch";
        } else {
            return @"Game Stats";
        }
    } else if (section == 2) {
        if (!selectedGame.hasPlayed) {
            return @"Scouting Report";
        } else {
            return @"Quarterbacks";
        }
    } else if (section == 3) {
        return @"Running Backs";
    } else if (section == 4) {
        return @"Wide Receivers";
    } else if (section == 5) {
        return @"Kickers";
    } else {
        if ([selectedGame.gameName isEqualToString:@"NCG"]) {
            return @"National Championship Game";
        } else if ([selectedGame.gameName isEqualToString:@"Semis, 1v4"]) {
            return @"National Semifinal - #1 vs #4";
        } else if ([selectedGame.gameName isEqualToString:@"Semis, 2v3"]) {
            return @"National Semifinal - #2 vs #3";
        } else if ([selectedGame.gameName isEqualToString:@"In Conf"]) {
            return [NSString stringWithFormat:@"%@ Conference Play",selectedGame.homeTeam.conference];
        } else if ([selectedGame.gameName isEqualToString:@"SOU vs PAC"]) {
            return @"South vs Pacific";
        } else if ([selectedGame.gameName isEqualToString:@"PAC vs SOU"]) {
            return @"Pacific vs South";
        } else if ([selectedGame.gameName isEqualToString:@"SOU vs LAK"]) {
            return @"South vs Lakes";
        } else if ([selectedGame.gameName isEqualToString:@"LAK vs SOU"]) {
            return @"Lakes vs South";
        } else if ([selectedGame.gameName isEqualToString:@"SOU vs MOU"]) {
            return @"South vs Mountain";
        } else if ([selectedGame.gameName isEqualToString:@"MOU vs SOU"]) {
            return @"Mountain vs South";
        } else if ([selectedGame.gameName isEqualToString:@"SOU vs NOR"]) {
            return @"South vs North";
        } else if ([selectedGame.gameName isEqualToString:@"NOR vs SOU"]) {
            return @"North vs South";
        } else if ([selectedGame.gameName isEqualToString:@"SOU vs COW"]) {
            return @"South vs Cowboy";
        } else if ([selectedGame.gameName isEqualToString:@"COW vs SOU"]) {
            return @"Cowboy vs South";
        } else if ([selectedGame.gameName isEqualToString:@"NOR vs PAC"]) {
            return @"North vs Pacific";
        } else if ([selectedGame.gameName isEqualToString:@"PAC vs NOR"]) {
            return @"Pacific vs North";
        } else if ([selectedGame.gameName isEqualToString:@"PAC vs LAK"]) {
            return @"Pacific vs Lakes";
        } else if ([selectedGame.gameName isEqualToString:@"LAK vs PAC"]) {
            return @"Lakes vs Pacific";
        } else if ([selectedGame.gameName isEqualToString:@"PAC vs MOU"]) {
            return @"Pacific vs Mountain";
        } else if ([selectedGame.gameName isEqualToString:@"MOU vs PAC"]) {
            return @"Mountain vs Pacific";
        } else if ([selectedGame.gameName isEqualToString:@"PAC vs COW"]) {
            return @"Pacific vs Cowboy";
        } else if ([selectedGame.gameName isEqualToString:@"COW vs PAC"]) {
            return @"Cowboy vs Pacific";
        } else if ([selectedGame.gameName isEqualToString:@"COW vs NOR"]) {
            return @"Cowboy vs North";
        } else if ([selectedGame.gameName isEqualToString:@"NOR vs COW"]) {
            return @"North vs Cowboy";
        } else if ([selectedGame.gameName isEqualToString:@"COW vs LAK"]) {
            return @"Cowboy vs Lakes";
        } else if ([selectedGame.gameName isEqualToString:@"LAK vs COW"]) {
            return @"Lakes vs Cowboy";
        } else if ([selectedGame.gameName isEqualToString:@"COW vs MOU"]) {
            return @"Cowboy vs Mountain";
        } else if ([selectedGame.gameName isEqualToString:@"MOU vs COW"]) {
            return @"Mountain vs Cowboy";
        } else if ([selectedGame.gameName isEqualToString:@"LAK vs NOR"]) {
            return @"Lakes vs North";
        } else if ([selectedGame.gameName isEqualToString:@"NOR vs LAK"]) {
            return @"North vs Lakes";
        } else if ([selectedGame.gameName isEqualToString:@"LAK vs MOU"]) {
            return @"Lakes vs Mountain";
        } else if ([selectedGame.gameName isEqualToString:@"MOU vs LAK"]) {
            return @"Mountain vs Lakes";
        } else if ([selectedGame.gameName isEqualToString:@"MOU vs NOR"]) {
            return @"Mountain vs North";
        } else if ([selectedGame.gameName isEqualToString:@"NOR vs MOU"]) {
            return @"North vs Mountain";
        } else {
            return selectedGame.gameName;
        }
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (!selectedGame.hasPlayed) {
            if (selectedGame.homeTeam.streaks != nil && [selectedGame.homeTeam.streaks.allKeys containsObject:selectedGame.awayTeam.abbreviation]) {
                TeamStreak *streak = selectedGame.homeTeam.streaks[selectedGame.awayTeam.abbreviation];
                return [streak stringRepresentation];
            } else {
                return @"To be played";
            }
        } else {
            if (selectedGame.numOT > 0) {
                if (selectedGame.numOT == 1) {
                    return @"Final (OT)";
                } else {
                    return [NSString stringWithFormat:@"Final (%ldOT)",(long)selectedGame.numOT];
                }
            } else {
                return @"Final";
            }
        }
    } else {
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!selectedGame.hasPlayed) {
        return 3;
    } else {
        return 6;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!selectedGame.hasPlayed) {
        if (section == 0) {
            return 2;
        } else if (section == 2) {
            return stats.allKeys.count;
        } else {
            return 2;
        }
    } else {
        if (section == 0) {
            return 3;
        } else if (section == 1) {
            return 4;
        } else if (section == 2) {
            return 2;
        } else if (section == 3) {
            return 4;
        } else if (section == 4) {
            return 6;
        } else {
            return 2;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!selectedGame.hasPlayed) {
        if (indexPath.section == 0) {
            HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
            if (indexPath.row == 0) {
                NSString *awayRank = @"";
                if ([HBSharedUtils getLeague].currentWeek > 0 && selectedGame.awayTeam.rankTeamPollScore < 26 && selectedGame.awayTeam.rankTeamPollScore > 0) {
                    awayRank = [NSString stringWithFormat:@"#%d ",selectedGame.awayTeam.rankTeamPollScore];
                }
                [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,selectedGame.awayTeam.name]];
                [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",selectedGame.awayTeam.wins,selectedGame.awayTeam.losses,(long)[selectedGame.awayTeam calculateConfWins], (long)[selectedGame.awayTeam calculateConfLosses],selectedGame.awayTeam.conference]];
                [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",selectedGame.awayScore]];
            } else {
                NSString *homeRank = @"";
                if ([HBSharedUtils getLeague].currentWeek > 0 && selectedGame.homeTeam.rankTeamPollScore < 26 && selectedGame.homeTeam.rankTeamPollScore > 0) {
                    homeRank = [NSString stringWithFormat:@"#%d ",selectedGame.homeTeam.rankTeamPollScore];
                }
                [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,selectedGame.homeTeam.name]];
                [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",selectedGame.homeTeam.wins,selectedGame.homeTeam.losses,(long)[selectedGame.homeTeam calculateConfWins], (long)[selectedGame.homeTeam calculateConfLosses],selectedGame.homeTeam.conference]];
                [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",selectedGame.homeScore]];
            }
            return cell;
        } else if (indexPath.section == 2) {
            HBStatsCell *statsCell = (HBStatsCell*)[tableView dequeueReusableCellWithIdentifier:@"HBStatsCell"];
            NSArray *stat; //= stats.allValues[indexPath.row];
            NSString *title;// = stats.allKeys[indexPath.row];
            if (indexPath.row == 0) {
                title = @"Ranking";
            } else if (indexPath.row == 1) {
                title = @"Record";
            } else if (indexPath.row == 2) {
                title = @"Offensive Talent";
            } else if (indexPath.row == 3) {
                title = @"Defensive Talent";
            } else if (indexPath.row == 4) {
                title = @"Prestige";
            } else if (indexPath.row == 5) {
                title = @"Points Per Game";
            } else if (indexPath.row == 6) {
                title = @"Opp PPG";
            } else if (indexPath.row == 7) {
                title = @"Yards Per Game";
            } else if (indexPath.row == 8) {
                title = @"Opp YPG";
            } else if (indexPath.row == 9) {
                title = @"Pass YPG";
            } else if (indexPath.row == 10) {
                title = @"Opp Pass YPG";
            } else if (indexPath.row == 11) {
                title = @"Rush YPG";
            } else {
                title = @"Opp Rush YPG";
            }
            stat = stats[title];
            
            [statsCell.statLabel setText:title];
            [statsCell.homeTeamLabel setText:selectedGame.homeTeam.abbreviation];
            [statsCell.awayTeamLabel setText:selectedGame.awayTeam.abbreviation];
            [statsCell.homeValueLabel setText:stat[1]];
            [statsCell.awayValueLabel setText:stat[0]];
            return statsCell;
        } else {
            HBPlayerCell *statsCell = (HBPlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"HBPlayerCell"];
            Player *plyr;
            if (indexPath.row == 0) {
                plyr = [selectedGame.awayTeam playerToWatch];
            } else {
                plyr = [selectedGame.homeTeam playerToWatch];
            }
            
            if (plyr == nil) {
                [statsCell.playerLabel setText:@"No player found"];
                return statsCell;
            }
            
            NSString *stat1 = @"";
            NSString *stat2 = @"";
            NSString *stat3 = @"";
            NSString *stat4 = @"";
            
            NSString *stat1Value = @"";
            NSString *stat2Value = @"";
            NSString *stat3Value = @"";
            NSString *stat4Value = @"";
            
            if ([plyr isKindOfClass:[PlayerQB class]]) {
                stat1 = @"CMP%"; //comp/att, yds, td, int
                stat2 = @"Yds";
                stat3 = @"TDs";
                stat4 = @"INTs";
                
                if (((PlayerQB*)plyr).statsPassAtt > 0) {
                    stat1Value = [NSString stringWithFormat:@"%d%%",(100 * ((PlayerQB*)plyr).statsPassComp/((PlayerQB*)plyr).statsPassAtt)];
                } else {
                    stat1Value = @"0%";
                }
                stat2Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsPassYards];
                stat3Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsTD];
                stat4Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsInt];
                //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:13.0]];
            } else if ([plyr isKindOfClass:[PlayerRB class]]) {
                stat1 = @"Car";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsRushAtt];
                stat2Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsRushYards];
                stat3Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsTD];
                stat4Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsFumbles];
                //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:17.0]];
            } else {
                stat1 = @"Rec";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsReceptions];
                stat2Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsRecYards];
                stat3Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsTD];
                stat4Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsFumbles];
                //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:17.0]];
            }
            
            [statsCell.playerLabel setText:[plyr getInitialName]];
            [statsCell.teamLabel setText:plyr.team.abbreviation];
            
            /*if ([HBSharedUtils getLeague].currentWeek >= 13 && [[[HBSharedUtils getLeague] calculateHeismanCandidates][0] isEqual:plyr]) {
                [statsCell.playerLabel setTextColor:[HBSharedUtils champColor]];
            } else {
                [statsCell.playerLabel setTextColor:[UIColor blackColor]];
            }*/
            
            if ([HBSharedUtils getLeague].currentWeek >= 13 && heisman != nil) {
                if ([heisman isEqual:plyr]) {
                    [statsCell.playerLabel setTextColor:[HBSharedUtils champColor]];
                } else {
                    [statsCell.playerLabel setTextColor:[UIColor blackColor]];
                }
            }
            
            [statsCell.stat1Label setText:stat1];
            [statsCell.stat1ValueLabel setText:stat1Value];
            [statsCell.stat2Label setText:stat2];
            [statsCell.stat2ValueLabel setText:stat2Value];
            [statsCell.stat3Label setText:stat3];
            [statsCell.stat3ValueLabel setText:stat3Value];
            [statsCell.stat4Label setText:stat4];
            [statsCell.stat4ValueLabel setText:stat4Value];
            
            return statsCell;
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if (selectedGame.awayTeam.rankTeamPollScore < 26 && selectedGame.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",selectedGame.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,selectedGame.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",selectedGame.awayTeam.wins,selectedGame.awayTeam.losses,(long)[selectedGame.awayTeam calculateConfWins], (long)[selectedGame.awayTeam calculateConfLosses],selectedGame.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",selectedGame.awayScore]];
                    if (selectedGame.homeScore < selectedGame.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                        [cell.scoreLabel setTextColor:[UIColor blackColor]];
                    }
                } else {
                    NSString *homeRank = @"";
                    if (selectedGame.homeTeam.rankTeamPollScore < 26 && selectedGame.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",selectedGame.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,selectedGame.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",selectedGame.homeTeam.wins,selectedGame.homeTeam.losses,(long)[selectedGame.homeTeam calculateConfWins], (long)[selectedGame.homeTeam calculateConfLosses],selectedGame.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",selectedGame.homeScore]];
                    if (selectedGame.homeScore > selectedGame.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                        [cell.scoreLabel setTextColor:[UIColor blackColor]];
                    }
                }
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
                    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                    [cell.textLabel setTextColor:self.view.tintColor];
                    [cell setAccessoryType:UITableViewCellAccessoryNone];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
                }
                
                [cell.textLabel setText:@"View Game Summary"];
                
                return cell;
            }
        } else if (indexPath.section != 1) {
            NSDictionary *combinedStats = stats;
            HBPlayerCell *statsCell = (HBPlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"HBPlayerCell"];
            Player *plyr;
            NSArray *plyrStats;
            NSString *stat1 = @"";
            NSString *stat2 = @"";
            NSString *stat3 = @"";
            NSString *stat4 = @"";
            
            NSString *stat1Value = @"";
            NSString *stat2Value = @"";
            NSString *stat3Value = @"";
            NSString *stat4Value = @"";
            
            if (indexPath.section == 2) {
                NSDictionary *qbStats = combinedStats[@"QBs"];
                if (indexPath.row == 0) {
                    plyr = qbStats[@"homeQB"];
                    plyrStats = qbStats[@"homeQBStats"];
                } else {
                    plyr = qbStats[@"awayQB"];
                    plyrStats = qbStats[@"awayQBStats"];
                }
                stat1 = @"C/A"; //comp/att, yds, td, int
                stat2 = @"Yds";
                stat3 = @"TDs";
                stat4 = @"INTs";
                
                stat1Value = [NSString stringWithFormat:@"%d/%d",[plyrStats[1] intValue],[plyrStats[0] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[4] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[2] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[3] intValue]];
            } else if (indexPath.section == 3) {
                NSDictionary *rbStats = combinedStats[@"RBs"]; //carries, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = rbStats[@"homeRB1"];
                    plyrStats = rbStats[@"homeRB1Stats"];
                } else if (indexPath.row == 1) {
                    plyr = rbStats[@"homeRB2"];
                    plyrStats = rbStats[@"homeRB2Stats"];
                } else if (indexPath.row == 2) {
                    plyr = rbStats[@"awayRB1"];
                    plyrStats = rbStats[@"awayRB1Stats"];
                } else {
                    plyr = rbStats[@"awayRB2"];
                    plyrStats = rbStats[@"awayRB2Stats"];
                }
                
                stat1 = @"Car";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[0] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[1] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[2] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[3] intValue]];
            } else if (indexPath.section == 4) {
                NSDictionary *wrStats = combinedStats[@"WRs"]; //catchs, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = wrStats[@"homeWR1"];
                    plyrStats = wrStats[@"homeWR1Stats"];
                } else if (indexPath.row == 1) {
                    plyr = wrStats[@"homeWR2"];
                    plyrStats = wrStats[@"homeWR2Stats"];
                } else if (indexPath.row == 2) {
                    plyr = wrStats[@"homeWR3"];
                    plyrStats = wrStats[@"homeWR3Stats"];
                } else if (indexPath.row == 3) {
                    plyr = wrStats[@"awayWR1"];
                    plyrStats = wrStats[@"awayWR1Stats"];
                } else if (indexPath.row == 4) {
                    plyr = wrStats[@"awayWR2"];
                    plyrStats = wrStats[@"awayWR2Stats"];
                } else {
                    plyr = wrStats[@"awayWR3"];
                    plyrStats = wrStats[@"awayWR3Stats"];
                }
                
                
                stat1 = @"Rec";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[0] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[2] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[3] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[5] intValue]];
            } else {
                NSDictionary *kStats = combinedStats[@"Ks"]; //xp made, xp att, fg made, fg att
                if (indexPath.row == 0) {
                    plyr = kStats[@"homeK"];
                    plyrStats = kStats[@"homeKStats"];
                } else {
                    plyr = kStats[@"awayK"];
                    plyrStats = kStats[@"awayKStats"];
                }
                stat1 = @"XPM";
                stat2 = @"XPA";
                stat3 = @"FGM";
                stat4 = @"FGA";
                
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[0] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[1] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[2] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[3] intValue]];
            }
            
            
            
            [statsCell.playerLabel setText:[plyr getInitialName]];
            
            if (([self tableView:tableView numberOfRowsInSection:indexPath.section]/ 2) <= indexPath.row) {
                [statsCell.teamLabel setText:selectedGame.awayTeam.abbreviation];
            } else {
                [statsCell.teamLabel setText:selectedGame.homeTeam.abbreviation];
            }
            
            /*if ([HBSharedUtils getLeague].currentWeek >= 13 && [[[HBSharedUtils getLeague] calculateHeismanCandidates][0] isEqual:plyr]) {
                [statsCell.playerLabel setTextColor:[HBSharedUtils champColor]];
             } else {
                [statsCell.playerLabel setTextColor:[UIColor blackColor]];
             }*/
            
            if ([HBSharedUtils getLeague].currentWeek >= 13 && heisman != nil) {
                if ([heisman isEqual:plyr]) {
                    [statsCell.playerLabel setTextColor:[HBSharedUtils champColor]];
                } else {
                    [statsCell.playerLabel setTextColor:[UIColor blackColor]];
                }
            }
            
            
            [statsCell.stat1Label setText:stat1];
            [statsCell.stat1ValueLabel setText:stat1Value];
            [statsCell.stat2Label setText:stat2];
            [statsCell.stat2ValueLabel setText:stat2Value];
            [statsCell.stat3Label setText:stat3];
            [statsCell.stat3ValueLabel setText:stat3Value];
            [statsCell.stat4Label setText:stat4];
            [statsCell.stat4ValueLabel setText:stat4Value];
            
            
            return statsCell;
        } else {
            HBStatsCell *statsCell = (HBStatsCell*)[tableView dequeueReusableCellWithIdentifier:@"HBStatsCell"];
            NSArray *stat; // = [stats[@"gameStats"] allValues][indexPath.row];
            NSString *title; //= [stats[@"gameStats"] allKeys][indexPath.row];
            NSDictionary *gameStats = stats[@"gameStats"];
            
            if (indexPath.row == 0) {
                title = @"Score";
            } else if (indexPath.row == 1) {
                title = @"Total Yards";
            } else if (indexPath.row == 2) {
                title = @"Pass Yards";
            } else {
                title = @"Rush Yards";
            }
            stat = gameStats[title];
            
            [statsCell.statLabel setText:title];
            [statsCell.homeTeamLabel setText:selectedGame.homeTeam.abbreviation];
            [statsCell.awayTeamLabel setText:selectedGame.awayTeam.abbreviation];
            [statsCell.homeValueLabel setText:stat[1]];
            [statsCell.awayValueLabel setText:stat[0]];
            return statsCell;
        }
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedGame.hasPlayed) {
        if (indexPath.section != 0 || indexPath.section != 1) {
            Player *plyr;
            NSDictionary *combinedStats = stats;
            NSDictionary *qbStats = combinedStats[@"QBs"];
            NSDictionary *rbStats = combinedStats[@"RBs"];
            NSDictionary *wrStats = combinedStats[@"WRs"];
            NSDictionary *kStats = combinedStats[@"Ks"];
            if (indexPath.section == 2) {
                if (indexPath.row == 0) {
                    plyr = qbStats[@"homeQB"];
                } else {
                    plyr = qbStats[@"awayQB"];
                }
            } else if (indexPath.section == 3) {
                if (indexPath.row == 0) {
                    plyr = rbStats[@"homeRB1"];
                } else if (indexPath.row == 1) {
                    plyr = rbStats[@"homeRB2"];
                } else if (indexPath.row == 2) {
                    plyr = rbStats[@"awayRB1"];
                } else {
                    plyr = rbStats[@"awayRB2"];
                }
            } else if (indexPath.section == 4) {
                if (indexPath.row == 0) {
                    plyr = wrStats[@"homeWR1"];
                } else if (indexPath.row == 1) {
                    plyr = wrStats[@"homeWR2"];
                } else if (indexPath.row == 2) {
                    plyr = wrStats[@"homeWR3"];
                } else if (indexPath.row == 3) {
                    plyr = wrStats[@"awayWR1"];
                } else if (indexPath.row == 4) {
                    plyr = wrStats[@"awayWR2"];
                } else {
                    plyr = wrStats[@"awayWR3"];
                }
            } else if (indexPath.section == 5) {
                if (indexPath.row == 0) {
                    plyr = kStats[@"homeK"];
                } else {
                    plyr = kStats[@"awayK"];
                }
            } else {
                if (indexPath.section == 0) {
                    if (indexPath.row == 0) {
                        [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:selectedGame.awayTeam] animated:YES];
                    } else if (indexPath.row == 1) {
                        [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:selectedGame.homeTeam] animated:YES];
                    } else {
                        [self viewGameSummary];
                    }
                }
            }
            
            if (plyr) {
                [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:plyr] animated:YES];
            }
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:selectedGame.awayTeam] animated:YES];
            } else if (indexPath.row == 1) {
                [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:selectedGame.homeTeam] animated:YES];
            } else {
                [self viewGameSummary];
            }
        } else if (indexPath.section == 1) {
            Player *plyr;
            if (indexPath.row == 0) {
                plyr = [selectedGame.awayTeam playerToWatch];
            } else {
                plyr = [selectedGame.homeTeam playerToWatch];
            }
            [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:plyr] animated:YES];
        }
    }
    
}
@end
