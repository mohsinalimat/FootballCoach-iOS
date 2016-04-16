//
//  ConferenceStandingsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/14/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "ConferenceStandingsViewController.h"
#import "Conference.h"
#import "Team.h"
#import "TeamViewController.h"
#import "HBTeamRankCell.h"
#import "HBScoreCell.h"
#import "Game.h"
#import "TeamStreak.h"
#import "GameDetailViewController.h"

@interface ConferenceStandingsViewController ()
{
    Conference *selectedConf;
    Game *ccg;
}
@end

@implementation ConferenceStandingsViewController

-(id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

-(instancetype)initWithConference:(Conference*)conf {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        selectedConf = conf;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    if (selectedConf.league.currentWeek < 13) {
        self.title = [NSString stringWithFormat:@"%@ Standings (through Week %ld)", selectedConf.confName, (long)selectedConf.league.currentWeek];
    } else {
        self.title = [NSString stringWithFormat:@"Final %@ Standings", selectedConf.confName];
    }

    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [selectedConf sortConfTeams];
    ccg = [selectedConf ccgPrediction];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HBTeamRankCell" bundle:nil] forCellReuseIdentifier:@"HBTeamRankCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScoreCell" bundle:nil] forCellReuseIdentifier:@"HBScoreCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (selectedConf.league.currentWeek > 8) {
        return 2;
    } else {
        return 1;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (selectedConf.league.currentWeek > 8) {
        if (section == 0) {
            if (ccg.hasPlayed || selectedConf.league.currentWeek >= 12) {
                return [NSString stringWithFormat:@"%@ Championship Game", selectedConf.confName];
            } else {
                return [NSString stringWithFormat:@"Projected %@ Championship Game", selectedConf.confName];
            }
        } else {
            return @"Full Standings";
        }
    } else {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (selectedConf.league.currentWeek > 8) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                return 75;
            } else {
                return 50;
            }
        } else {
            return 60;
        }
    } else {
        return 60;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (selectedConf.league.currentWeek > 8) {
        if (section == 0) {
            return 3;
        } else {
            return selectedConf.confTeams.count;
        }
    } else {
        return selectedConf.confTeams.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (selectedConf.league.currentWeek > 8) {
        if (section == 1) {
            return @"Abbreviation Key:\nCW - Conference Wins\nCL - Conference Losses\nW - Season Wins\nL - Season Losses";
        } else {
            if (!ccg.hasPlayed) {
                if (ccg.homeTeam.streaks != nil && [ccg.homeTeam.streaks.allKeys containsObject:ccg.awayTeam.abbreviation]) {
                    TeamStreak *streak = ccg.homeTeam.streaks[ccg.awayTeam.abbreviation];
                    return [streak stringRepresentation];
                } else {
                    return @"To be played";
                }
            } else {
                if (ccg.numOT > 0) {
                    if (ccg.numOT == 1) {
                        return @"Final (OT)";
                    } else {
                        return [NSString stringWithFormat:@"Final (%ldOT)",(long)ccg.numOT];
                    }
                } else {
                    return @"Final";
                }
            }
        }
    } else {
        if (section == 0) {
            return @"Abbreviation Key:\nCW - Conference Wins\nCL - Conference Losses\nW - Season Wins\nL - Season Losses";
        } else {
            return nil;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (selectedConf.league.currentWeek > 8) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if (ccg.awayTeam.rankTeamPollScore < 26 && ccg.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",ccg.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,ccg.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",ccg.awayTeam.wins,ccg.awayTeam.losses,(long)[ccg.awayTeam getConfWins], (long)[ccg.awayTeam getConfLosses],ccg.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",ccg.awayScore]];
                    if (ccg.homeScore < ccg.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([ccg.awayTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                            [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                        } else {
                            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                            [cell.scoreLabel setTextColor:[UIColor blackColor]];
                        }
                    }
                } else {
                    NSString *homeRank = @"";
                    if (ccg.homeTeam.rankTeamPollScore < 26 && ccg.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",ccg.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,ccg.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",ccg.homeTeam.wins,ccg.homeTeam.losses,(long)[ccg.homeTeam getConfWins], (long)[ccg.homeTeam getConfLosses],ccg.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",ccg.homeScore]];
                    if (ccg.homeScore > ccg.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        if ([ccg.homeTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                            [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                        } else {
                            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                            [cell.scoreLabel setTextColor:[UIColor blackColor]];
                        }
                    }
                }
                
                
                return cell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
                }
                
                if (ccg.hasPlayed) {
                    [cell.textLabel setText:@"View Game"];
                } else {
                    [cell.textLabel setText:@"Preview Matchup"];
                }
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setTextColor:self.view.tintColor];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                return cell;
            }
        } else {
            HBTeamRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBTeamRankCell"];
            Team *t = selectedConf.confTeams[indexPath.row];
            [cell.confWinsLabel setText:[NSString stringWithFormat:@"%ld", (long)[t getConfWins]]];
            [cell.confLossLabel setText:[NSString stringWithFormat:@"%ld", (long)[t getConfLosses]]];
            [cell.totalWinsLabel setText:[NSString stringWithFormat:@"%ld", (long)t.wins]];
            [cell.totalLossesLabel setText:[NSString stringWithFormat:@"%ld", (long)t.losses]];
            [cell.teamNameLabel setText:t.name];
            if ([t isEqual:[HBSharedUtils getLeague].userTeam]) {
                [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.teamNameLabel setTextColor:[UIColor blackColor]];
            }
            [cell.rankLabel setText:[NSString stringWithFormat:@"#%ld", (long)(1 + indexPath.row)]];
            return cell;
        }
    } else {
        HBTeamRankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBTeamRankCell"];
        Team *t = selectedConf.confTeams[indexPath.row];
        [cell.confWinsLabel setText:[NSString stringWithFormat:@"%ld", (long)[t getConfWins]]];
        [cell.confLossLabel setText:[NSString stringWithFormat:@"%ld", (long)[t getConfLosses]]];
        [cell.totalWinsLabel setText:[NSString stringWithFormat:@"%ld", (long)t.wins]];
        [cell.totalLossesLabel setText:[NSString stringWithFormat:@"%ld", (long)t.losses]];
        [cell.teamNameLabel setText:t.name];
        if ([t isEqual:[HBSharedUtils getLeague].userTeam]) {
            [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
        } else {
            [cell.teamNameLabel setTextColor:[UIColor blackColor]];
        }
        [cell.rankLabel setText:[NSString stringWithFormat:@"#%ld", (long)(1 + indexPath.row)]];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedConf.league.currentWeek > 8) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                Team *t = ccg.awayTeam;
                [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:t] animated:YES];
            } else if (indexPath.row == 1) {
                Team *t = ccg.homeTeam;
                [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:t] animated:YES];
            } else {
                [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:ccg] animated:YES];
            }
        } else {
            Team *t = selectedConf.confTeams[indexPath.row];
            [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:t] animated:YES];
        }
    } else {
        Team *t = selectedConf.confTeams[indexPath.row];
        [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:t] animated:YES];
    }
}

@end
