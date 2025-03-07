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
#import "TeamViewController.h"
#import "HBScoreCell.h"
#import "TeamStreak.h"
#import "InjuryReportViewController.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerTE.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerDefender.h"
#import "PlayerDL.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "PlayerQBDetailViewController.h"
#import "PlayerRBDetailViewController.h"
#import "PlayerWRDetailViewController.h"
#import "PlayerTEDetailViewController.h"
#import "PlayerOLDetailViewController.h"
#import "PlayerKDetailViewController.h"
#import "PlayerDLDetailViewController.h"
#import "PlayerLBDetailViewController.h"
#import "PlayerCBDetailViewController.h"
#import "PlayerSDetailViewController.h"
#import "PlayerDetailViewController.h"

#import "HexColors.h"

@interface GameDetailViewController () <UIViewControllerPreviewingDelegate>
{
    Game *selectedGame;
    NSDictionary *stats;
    Player *heisman;
    
    BOOL pbpEnabled;
}
@end

@implementation GameDetailViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        NSInteger section = indexPath.section;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIViewController *peekVC;
        if (section == 1) {
            if (!selectedGame.hasPlayed) {
                Player *p;
                if (indexPath.row == 0) {
                    p = [selectedGame.awayTeam playerToWatch];
                } else {
                    p = [selectedGame.homeTeam playerToWatch];
                }
                PlayerDetailViewController *playerDetail;
                if (p != nil) {
                    if ([p.position isEqualToString:@"QB"]) {
                        playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"RB"]) {
                        playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"WR"]) {
                        playerDetail = [[PlayerWRDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"TE"]) {
                        playerDetail = [[PlayerTEDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"OL"]) {
                        playerDetail = [[PlayerOLDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"DL"]) {
                        playerDetail = [[PlayerDLDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"LB"]) {
                        playerDetail = [[PlayerLBDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"CB"]) {
                        playerDetail = [[PlayerCBDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"S"]) {
                        playerDetail = [[PlayerSDetailViewController alloc] initWithPlayer:p];
                    } else if ([p.position isEqualToString:@"K"]) {
                        playerDetail = [[PlayerKDetailViewController alloc] initWithPlayer:p];
                    } else {
                        playerDetail = [[PlayerDetailViewController alloc] initWithPlayer:p];
                    }
                    peekVC = playerDetail;
                } else {
                    return nil;
                }
            }
        } else if (section == 2) {
            if (![self isHardMode]) {
                if (selectedGame.hasPlayed) {
                    Player *plyr;
                    NSDictionary *qbStats = stats[@"QBs"];
                    if (indexPath.row == 0) {
                        plyr = qbStats[@"awayQB"];
                    } else {
                        plyr = qbStats[@"homeQB"];
                    }

                    PlayerQBDetailViewController *playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:plyr];
                    peekVC = playerDetail;
                }
            } else {
                if (!selectedGame.hasPlayed) {
                    if (indexPath.row == 0) {
                        peekVC = [[InjuryReportViewController alloc] initWithTeam:selectedGame.awayTeam];
                    } else {
                        peekVC = [[InjuryReportViewController alloc] initWithTeam:selectedGame.homeTeam];
                    }
                } else {
                    Player *plyr;
                    NSDictionary *qbStats = stats[@"QBs"];
                    if (indexPath.row == 0) {
                        plyr = qbStats[@"awayQB"];
                    } else {
                        plyr = qbStats[@"homeQB"];
                    }

                    PlayerQBDetailViewController *playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:plyr];
                    peekVC = playerDetail;
                }
            }
        } else if (section == 3) {
            if (![self isHardMode]) {
                Player *plyr;
                NSDictionary *rbStats = stats[@"RBs"]; //carries, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = rbStats[@"awayRB1"];
                } else if (indexPath.row == 1) {
                    plyr = rbStats[@"awayRB2"];
                } else if (indexPath.row == 2) {
                    plyr = rbStats[@"homeRB1"];
                } else {
                    plyr = rbStats[@"homeRB2"];
                }
                PlayerRBDetailViewController *playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:plyr];
                peekVC = playerDetail;
            } else {
                if (selectedGame.hasPlayed) {
                    Player *plyr;
                    NSDictionary *rbStats = stats[@"RBs"]; //carries, yds, td, fum
                    if (indexPath.row == 0) {
                        plyr = rbStats[@"awayRB1"];
                    } else if (indexPath.row == 1) {
                        plyr = rbStats[@"awayRB2"];
                    } else if (indexPath.row == 2) {
                        plyr = rbStats[@"homeRB1"];
                    } else {
                        plyr = rbStats[@"homeRB2"];
                    }
                    PlayerRBDetailViewController *playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:plyr];
                    peekVC = playerDetail;
                }
            }
        } else if (section == 4) {
            Player *plyr;
            NSDictionary *wrStats = stats[@"WRs"]; //catches, yds, td, fum
            if (indexPath.row == 0) {
                plyr = wrStats[@"awayWR1"];
            } else if (indexPath.row == 1) {
                plyr = wrStats[@"awayWR2"];
            } else if (indexPath.row == 2) {
                plyr = wrStats[@"homeWR1"];
            } else {
                plyr = wrStats[@"homeWR2"];
            }
            PlayerWRDetailViewController *playerDetail = [[PlayerWRDetailViewController alloc] initWithPlayer:plyr];
            peekVC = playerDetail;
        } else if (section == 5) {
            Player *plyr;
            NSDictionary *qbStats = stats[@"TEs"];
            if (indexPath.row == 0) {
                plyr = qbStats[@"awayTE"];
            } else {
                plyr = qbStats[@"homeTE"];
            }

            PlayerTEDetailViewController *playerDetail = [[PlayerTEDetailViewController alloc] initWithPlayer:plyr];
            peekVC = playerDetail;
        } else if (section == 6) {
            Player *plyr;
            NSDictionary *wrStats = stats[@"DLs"]; //catches, yds, td, fum
            if (indexPath.row == 0) {
                plyr = wrStats[@"awayDL1"];
            } else if (indexPath.row == 1) {
                plyr = wrStats[@"awayDL2"];
            } else if (indexPath.row == 2) {
                plyr = wrStats[@"awayDL3"];
            } else if (indexPath.row == 3) {
                plyr = wrStats[@"awayDL4"];
            } else if (indexPath.row == 4) {
                plyr = wrStats[@"homeDL1"];
            } else if (indexPath.row == 5) {
                plyr = wrStats[@"homeDL2"];
            } else if (indexPath.row == 6) {
                plyr = wrStats[@"homeDL3"];
            } else {
                plyr = wrStats[@"homeDL4"];
            }
            PlayerDLDetailViewController *playerDetail = [[PlayerDLDetailViewController alloc] initWithPlayer:plyr];
            peekVC = playerDetail;
        } else if (section == 7) {
            Player *plyr;
            NSDictionary *wrStats = stats[@"LBs"]; //catches, yds, td, fum
            if (indexPath.row == 0) {
                plyr = wrStats[@"awayLB1"];
            } else if (indexPath.row == 1) {
                plyr = wrStats[@"awayLB2"];
            } else if (indexPath.row == 2) {
                plyr = wrStats[@"awayLB3"];
            } else if (indexPath.row == 3) {
                plyr = wrStats[@"homeLB1"];
            } else if (indexPath.row == 4) {
                plyr = wrStats[@"homeLB2"];
            } else {
                plyr = wrStats[@"homeLB3"];
            }
            PlayerLBDetailViewController *playerDetail = [[PlayerLBDetailViewController alloc] initWithPlayer:plyr];
            peekVC = playerDetail;
        } else if (section == 8) {
            Player *plyr;
            NSDictionary *wrStats = stats[@"CBs"]; //catches, yds, td, fum
            if (indexPath.row == 0) {
                plyr = wrStats[@"awayCB1"];
            } else if (indexPath.row == 1) {
                plyr = wrStats[@"awayCB2"];
            } else if (indexPath.row == 2) {
                plyr = wrStats[@"awayCB3"];
            } else if (indexPath.row == 3) {
                plyr = wrStats[@"homeCB1"];
            } else if (indexPath.row == 4) {
                plyr = wrStats[@"homeCB2"];
            } else {
                plyr = wrStats[@"homeCB3"];
            }
            PlayerCBDetailViewController *playerDetail = [[PlayerCBDetailViewController alloc] initWithPlayer:plyr];
            peekVC = playerDetail;
        } else if (section == 9) {
            Player *plyr;
            NSDictionary *qbStats = stats[@"Ss"];
            if (indexPath.row == 0) {
                plyr = qbStats[@"awayS"];
            } else {
                plyr = qbStats[@"homeS"];
            }
            
            PlayerSDetailViewController *playerDetail = [[PlayerSDetailViewController alloc] initWithPlayer:plyr];
            peekVC = playerDetail;
        } else if (section == 10) {
            Player *plyr;
            NSDictionary *qbStats = stats[@"Ks"];
            if (indexPath.row == 0) {
                plyr = qbStats[@"awayK"];
            } else {
                plyr = qbStats[@"homeK"];
            }

            PlayerKDetailViewController *playerDetail = [[PlayerKDetailViewController alloc] initWithPlayer:plyr];
            peekVC = playerDetail;
        } else {
            if (indexPath.row == 0) {
                peekVC = [[TeamViewController alloc] initWithTeam:selectedGame.awayTeam];
            } else if (indexPath.row == 1) {
                peekVC = [[TeamViewController alloc] initWithTeam:selectedGame.homeTeam];
            } else {
                peekVC = nil;
            }
        }
        if (peekVC != nil) {
            peekVC.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
            previewingContext.sourceRect = cell.frame;
            return peekVC;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(instancetype)initWithGame:(Game *)game {
    self = [super init];
    if(self) {
        selectedGame = game;
    }
    return self;
}


-(BOOL)isHardMode {
    return (selectedGame.homeTeam.league.isHardMode && selectedGame.awayTeam.league.isHardMode);
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Game";
    heisman = [[HBSharedUtils currentLeague] heisman];
    stats = [selectedGame gameReport];
    pbpEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:HB_PLAY_BY_PLAY_ENABLED];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBStatsCell" bundle:nil] forCellReuseIdentifier:@"HBStatsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBPlayerCell" bundle:nil] forCellReuseIdentifier:@"HBPlayerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScoreCell" bundle:nil] forCellReuseIdentifier:@"HBScoreCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reincarnateCoach" object:nil];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];

    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
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
    [header.textLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
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
        if (![self isHardMode]) {
            if (!selectedGame.hasPlayed) {
                return @"Scouting Report";
            } else {
                return @"Quarterbacks";
            }
        } else {
            if (!selectedGame.hasPlayed) {
                return @"Injury Report";
            } else {
                return @"Quarterbacks";
            }
        }
    } else if (section == 3) {
        if (![self isHardMode]) {
            return @"Running Backs";
        } else {
            if (!selectedGame.hasPlayed) {
                return @"Scouting Report";
            } else {
                return @"Running Backs";
            }
        }
    } else if (section == 4) {
        return @"Wide Receivers";
    } else if (section == 5) {
        return @"Tight Ends";
    } else if (section == 6) {
        return @"Defensive Lineman";
    } else if (section == 7) {
        return @"Linebackers";
    } else if (section == 8) {
        return @"Cornerbacks";
    } else if (section == 9) {
        return @"Safeties";
    } else if (section == 10) {
        return @"Kickers";
    } else {
        if ([selectedGame.gameName isEqualToString:@"NCG"]) {
            return [NSString stringWithFormat:@"%lu National Championship Game", (long)[[HBSharedUtils currentLeague] getCurrentYear] + 1];
        } else if ([selectedGame.gameName isEqualToString:@"Semis, 1v4"]) {
            return [NSString stringWithFormat:@"%lu National Semifinal - #1 vs #4", (long)[[HBSharedUtils currentLeague] getCurrentYear]];
        } else if ([selectedGame.gameName isEqualToString:@"Semis, 2v3"]) {
            return [NSString stringWithFormat:@"%lu National Semifinal - #2 vs #3", (long)[[HBSharedUtils currentLeague] getCurrentYear]];
        } else if ([selectedGame.gameName isEqualToString:@"In Conf"]) {
            return [NSString stringWithFormat:@"%@ Conference Play",selectedGame.homeTeam.conference];
        } else if ([selectedGame.gameName containsString:@" vs "]) {
            Conference *home = [[HBSharedUtils currentLeague] findConference:selectedGame.homeTeam.conference];
            Conference *away = [[HBSharedUtils currentLeague] findConference:selectedGame.awayTeam.conference];
            if (away != nil && home != nil) {
                return [NSString stringWithFormat:@"%@ vs %@", away.confFullName, home.confFullName];
            } else {
                return selectedGame.gameName;
            }
        } else {
            return selectedGame.gameName;
        }
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (!selectedGame.hasPlayed) {
            NSString *spread = [selectedGame.homeTeam getGameSummaryStrings:[NSNumber numberWithInteger:[selectedGame.homeTeam.gameSchedule indexOfObject:selectedGame]].intValue][1];
            if (selectedGame.homeTeam.streaks != nil && [selectedGame.homeTeam.streaks.allKeys containsObject:selectedGame.awayTeam.abbreviation]) {
                TeamStreak *streak = selectedGame.homeTeam.streaks[selectedGame.awayTeam.abbreviation];
                return [NSString stringWithFormat:@"Odds: %@, %@", spread, [streak stringRepresentation]];
            } else {
                return [NSString stringWithFormat:@"Odds: %@", spread];
            }
        } else {
            if (selectedGame.numOT > 0) {
                if (selectedGame.numOT == 1) {
                    return @"Final (OT)";
                } else {
                    return [NSString stringWithFormat:@"Final (%luOT)",(long)selectedGame.numOT];
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
        if ([self isHardMode]) {
            return 4;
        } else {
            return 3;
        }
    } else {
        return 11;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!selectedGame.hasPlayed) {
        if ([self isHardMode]) {
            if (section == 0) {
                return 2;
            } else if (section == 3) {
                return stats.allKeys.count;
            } else {
                return 2;
            }
        } else {
            if (section == 0) {
                return 2;
            } else if (section == 2) {
                return stats.allKeys.count;
            } else {
                return 2;
            }
        }
    } else {
        if (section == 0) {
            return 3;
        } else if (section == 1) {
            return 5;
        } else if (section == 2) {
            return 2;
        } else if (section == 3) {
            return 4;
        } else if (section == 4) {
            return 4;
        } else if (section == 5) {
            return 2;
        } else if (section == 6) {
            return 8;
        } else if (section == 7) {
            return 6;
        } else if (section == 8) {
            return 6;
        } else if (section == 9) {
            return 2;
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
                if ([HBSharedUtils currentLeague].currentWeek > 0 && selectedGame.awayTeam.rankTeamPollScore < 26 && selectedGame.awayTeam.rankTeamPollScore > 0) {
                    awayRank = [NSString stringWithFormat:@"#%d ",selectedGame.awayTeam.rankTeamPollScore];
                }
                [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,selectedGame.awayTeam.name]];
                [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%lu-%lu) %@",selectedGame.awayTeam.wins,selectedGame.awayTeam.losses,(long)[selectedGame.awayTeam calculateConfWins], (long)[selectedGame.awayTeam calculateConfLosses],selectedGame.awayTeam.conference]];
                [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",selectedGame.awayScore]];
                if ([selectedGame.awayTeam.abbreviation isEqualToString:@"FCS"]) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
            } else {
                NSString *homeRank = @"";
                if ([HBSharedUtils currentLeague].currentWeek > 0 && selectedGame.homeTeam.rankTeamPollScore < 26 && selectedGame.homeTeam.rankTeamPollScore > 0) {
                    homeRank = [NSString stringWithFormat:@"#%d ",selectedGame.homeTeam.rankTeamPollScore];
                }
                [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,selectedGame.homeTeam.name]];
                [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%lu-%lu) %@",selectedGame.homeTeam.wins,selectedGame.homeTeam.losses,(long)[selectedGame.homeTeam calculateConfWins], (long)[selectedGame.homeTeam calculateConfLosses],selectedGame.homeTeam.conference]];
                [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",selectedGame.homeScore]];
                if ([selectedGame.homeTeam.abbreviation isEqualToString:@"FCS"]) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
            }
            return cell;
        } else if ((indexPath.section == 3 && [self isHardMode]) || (indexPath.section == 2 && ![self isHardMode])) {
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
        } else if (indexPath.section == 1) {
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
                //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:SMALL_FONT_SIZE]];
            } else if ([plyr isKindOfClass:[PlayerRB class]]) {
                stat1 = @"Car";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsRushAtt];
                stat2Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsRushYards];
                stat3Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsTD];
                stat4Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsFumbles];
                //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
            } else if ([plyr isKindOfClass:[PlayerWR class]]) {
                stat1 = @"Rec";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsReceptions];
                stat2Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsRecYards];
                stat3Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsTD];
                stat4Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsFumbles];
                //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
            } else if ([plyr isKindOfClass:[PlayerTE class]]) {
                stat1 = @"Rec";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",((PlayerTE*)plyr).statsReceptions];
                stat2Value = [NSString stringWithFormat:@"%d",((PlayerTE*)plyr).statsRecYards];
                stat3Value = [NSString stringWithFormat:@"%d",((PlayerTE*)plyr).statsTD];
                stat4Value = [NSString stringWithFormat:@"%d",((PlayerTE*)plyr).statsFumbles];
                //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
            } else if ([plyr isKindOfClass:[PlayerDefender class]]) {
                stat1 = @"Tkl";
                stat2 = @"INT";
                stat3 = @"FFum";
                stat4 = @"PsDef";
                stat1Value = [NSString stringWithFormat:@"%d",((PlayerDefender *)plyr).statsTkl];
                stat2Value = [NSString stringWithFormat:@"%d",((PlayerDefender *)plyr).statsSacks];
                stat3Value = [NSString stringWithFormat:@"%d",((PlayerDefender*)plyr).statsForcedFum];
                stat4Value = [NSString stringWithFormat:@"%d",((PlayerDefender*)plyr).statsPassDef];
            }

            [statsCell.playerLabel setText:[plyr getInitialName]];
            [statsCell.teamLabel setText:plyr.team.abbreviation];

            if ([HBSharedUtils currentLeague].currentWeek >= 13 && heisman != nil) {
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InjuryCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"InjuryCell"];
                [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
                [cell.detailTextLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
                [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }

            if (indexPath.row == 0) {
                NSString *number;
                if (selectedGame.awayTeam.injuredPlayers.count == 0) {
                    number = @"No players out";
                } else if (selectedGame.awayTeam.injuredPlayers.count == 1) {
                    number = @"1 player out";
                } else {
                    number = [NSString stringWithFormat:@"%lu players out",(long)selectedGame.awayTeam.injuredPlayers.count];
                }
                [cell.textLabel setText:[NSString stringWithFormat:@"%@ Injury Report",selectedGame.awayTeam.abbreviation]];
                [cell.detailTextLabel setText:number];
            } else {
                NSString *number;
                if (selectedGame.homeTeam.injuredPlayers.count == 0) {
                    number = @"No players out";
                } else if (selectedGame.homeTeam.injuredPlayers.count == 1) {
                    number = @"1 player out";
                } else {
                    number = [NSString stringWithFormat:@"%lu players out",(long)selectedGame.homeTeam.injuredPlayers.count];
                }
                [cell.textLabel setText:[NSString stringWithFormat:@"%@ Injury Report",selectedGame.homeTeam.abbreviation]];
                [cell.detailTextLabel setText:number];
            }

            return cell;
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0 || indexPath.row == 1) {
                HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
                if (indexPath.row == 0) {
                    NSString *awayRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && selectedGame.awayTeam.rankTeamPollScore < 26 && selectedGame.awayTeam.rankTeamPollScore > 0) {
                        awayRank = [NSString stringWithFormat:@"#%d ",selectedGame.awayTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,selectedGame.awayTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%lu-%lu) %@",selectedGame.awayTeam.wins,selectedGame.awayTeam.losses,(long)[selectedGame.awayTeam calculateConfWins], (long)[selectedGame.awayTeam calculateConfLosses],selectedGame.awayTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",selectedGame.awayScore]];
                    if (selectedGame.homeScore < selectedGame.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                        [cell.scoreLabel setTextColor:[UIColor blackColor]];
                    }
                    if ([selectedGame.awayTeam.abbreviation isEqualToString:@"FCS"]) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    }
                } else {
                    NSString *homeRank = @"";
                    if ([HBSharedUtils currentLeague].currentWeek > 0 && selectedGame.homeTeam.rankTeamPollScore < 26 && selectedGame.homeTeam.rankTeamPollScore > 0) {
                        homeRank = [NSString stringWithFormat:@"#%d ",selectedGame.homeTeam.rankTeamPollScore];
                    }
                    [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,selectedGame.homeTeam.name]];
                    [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%lu-%lu) %@",selectedGame.homeTeam.wins,selectedGame.homeTeam.losses,(long)[selectedGame.homeTeam calculateConfWins], (long)[selectedGame.homeTeam calculateConfLosses],selectedGame.homeTeam.conference]];
                    [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",selectedGame.homeScore]];
                    if (selectedGame.homeScore > selectedGame.awayScore) {
                        [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                        [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
                    } else {
                        [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                        [cell.scoreLabel setTextColor:[UIColor blackColor]];
                    }
                    if ([selectedGame.homeTeam.abbreviation isEqualToString:@"FCS"]) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    } else {
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
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
                    [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
                }

                if (pbpEnabled) {
                    [cell.textLabel setText:@"View Play by Play"];
                } else {
                    [cell.textLabel setText:@"View Game Summary"];
                }

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
                    plyr = qbStats[@"awayQB"];
                    plyrStats = qbStats[@"awayQBStats"];
                } else {
                    plyr = qbStats[@"homeQB"];
                    plyrStats = qbStats[@"homeQBStats"];
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
                    plyr = rbStats[@"awayRB1"];
                    plyrStats = rbStats[@"awayRB1Stats"];
                } else if (indexPath.row == 1) {
                    plyr = rbStats[@"awayRB2"];
                    plyrStats = rbStats[@"awayRB2Stats"];
                } else if (indexPath.row == 2) {
                    plyr = rbStats[@"homeRB1"];
                    plyrStats = rbStats[@"homeRB1Stats"];
                } else {
                    plyr = rbStats[@"homeRB2"];
                    plyrStats = rbStats[@"homeRB2Stats"];
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
                    plyr = wrStats[@"awayWR1"];
                    plyrStats = wrStats[@"awayWR1Stats"];
                } else if (indexPath.row == 1) {
                    plyr = wrStats[@"awayWR2"];
                    plyrStats = wrStats[@"awayWR2Stats"];
                } else if (indexPath.row == 2) {
                    plyr = wrStats[@"homeWR1"];
                    plyrStats = wrStats[@"homeWR1Stats"];
                } else {
                    plyr = wrStats[@"homeWR2"];
                    plyrStats = wrStats[@"homeWR2Stats"];
                }


                stat1 = @"Rec";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[0] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[2] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[3] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[5] intValue]];
            } else if (indexPath.section == 5) {
                NSDictionary *teStats = combinedStats[@"TEs"]; //catchs, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = teStats[@"awayTE"];
                    plyrStats = teStats[@"awayTEStats"];
                } else {
                    plyr = teStats[@"homeTE"];
                    plyrStats = teStats[@"homeTEStats"];
                }


                stat1 = @"Rec";
                stat2 = @"Yds";
                stat3 = @"TD";
                stat4 = @"Fum";
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[0] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[2] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[3] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[5] intValue]];
            } else if (indexPath.section == 6) {
                NSDictionary *dlStats = combinedStats[@"DLs"]; //catchs, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = dlStats[@"awayDL1"];
                    plyrStats = dlStats[@"awayDL1Stats"];
                } else if (indexPath.row == 1) {
                    plyr = dlStats[@"awayDL2"];
                    plyrStats = dlStats[@"awayDL2Stats"];
                } else if (indexPath.row == 2) {
                    plyr = dlStats[@"awayDL3"];
                    plyrStats = dlStats[@"awayDL3Stats"];
                } else if (indexPath.row == 3) {
                    plyr = dlStats[@"awayDL4"];
                    plyrStats = dlStats[@"awayDL4Stats"];
                } else if (indexPath.row == 4) {
                    plyr = dlStats[@"homeDL1"];
                    plyrStats = dlStats[@"homeDL1Stats"];
                } else if (indexPath.row == 5) {
                    plyr = dlStats[@"homeDL2"];
                    plyrStats = dlStats[@"homeDL2Stats"];
                } else if (indexPath.row == 6) {
                    plyr = dlStats[@"homeDL3"];
                    plyrStats = dlStats[@"homeDL3Stats"];
                } else {
                    plyr = dlStats[@"homeDL4"];
                    plyrStats = dlStats[@"homeDL4Stats"];
                }
                
                
                stat1 = @"Tkl";
                stat2 = @"INT";
                stat3 = @"FFum";
                stat4 = @"PsDef";
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatTkl] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatINT] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatForcedFum] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatPassDef] intValue]];
            } else if (indexPath.section == 7) {
                NSDictionary *dlStats = combinedStats[@"LBs"]; //catchs, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = dlStats[@"awayLB1"];
                    plyrStats = dlStats[@"awayLB1Stats"];
                } else if (indexPath.row == 1) {
                    plyr = dlStats[@"awayLB2"];
                    plyrStats = dlStats[@"awayLB2Stats"];
                } else if (indexPath.row == 2) {
                    plyr = dlStats[@"awayLB3"];
                    plyrStats = dlStats[@"awayLB3Stats"];
                } else if (indexPath.row == 3) {
                    plyr = dlStats[@"homeLB1"];
                    plyrStats = dlStats[@"homeLB1Stats"];
                } else if (indexPath.row == 4) {
                    plyr = dlStats[@"homeLB2"];
                    plyrStats = dlStats[@"homeLB2Stats"];
                } else {
                    plyr = dlStats[@"homeLB3"];
                    plyrStats = dlStats[@"homeLB3Stats"];
                }
                
                
                stat1 = @"Tkl";
                stat2 = @"INT";
                stat3 = @"FFum";
                stat4 = @"PsDef";
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatTkl] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatINT] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatForcedFum] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatPassDef] intValue]];
            } else if (indexPath.section == 8) {
                NSDictionary *dlStats = combinedStats[@"CBs"]; //catchs, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = dlStats[@"awayCB1"];
                    plyrStats = dlStats[@"awayCB1Stats"];
                } else if (indexPath.row == 1) {
                    plyr = dlStats[@"awayCB2"];
                    plyrStats = dlStats[@"awayCB2Stats"];
                } else if (indexPath.row == 2) {
                    plyr = dlStats[@"awayCB3"];
                    plyrStats = dlStats[@"awayCB3Stats"];
                } else if (indexPath.row == 3) {
                    plyr = dlStats[@"homeCB1"];
                    plyrStats = dlStats[@"homeCB1Stats"];
                } else if (indexPath.row == 4) {
                    plyr = dlStats[@"homeCB2"];
                    plyrStats = dlStats[@"homeCB2Stats"];
                } else {
                    plyr = dlStats[@"homeCB3"];
                    plyrStats = dlStats[@"homeCB3Stats"];
                }
                
                
                stat1 = @"Tkl";
                stat2 = @"INT";
                stat3 = @"FFum";
                stat4 = @"PsDef";
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatTkl] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatINT] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatForcedFum] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatPassDef] intValue]];
            } else if (indexPath.section == 9) {
                NSDictionary *dlStats = combinedStats[@"Ss"]; //catchs, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = dlStats[@"awayS"];
                    plyrStats = dlStats[@"awaySStats"];
                } else {
                    plyr = dlStats[@"homeS"];
                    plyrStats = dlStats[@"homeSStats"];
                }
                
                stat1 = @"Tkl";
                stat2 = @"INT";
                stat3 = @"FFum";
                stat4 = @"PsDef";
                stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatTkl] intValue]];
                stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatINT] intValue]];
                stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatForcedFum] intValue]];
                stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[FCDefensiveStatPassDef] intValue]];
            } else {
                NSDictionary *kStats = combinedStats[@"Ks"]; //xp made, xp att, fg made, fg att
                if (indexPath.row == 0) {
                    plyr = kStats[@"awayK"];
                    plyrStats = kStats[@"awayKStats"];
                } else {
                    plyr = kStats[@"homeK"];
                    plyrStats = kStats[@"homeKStats"];
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
                [statsCell.teamLabel setText:selectedGame.homeTeam.abbreviation];
            } else {
                [statsCell.teamLabel setText:selectedGame.awayTeam.abbreviation];
            }

            if ([HBSharedUtils currentLeague].currentWeek >= 13 && heisman != nil) {
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
            } else if (indexPath.row == 3)  {
                title = @"Rush Yards";
            } else {
                title = @"Turnovers Lost";
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
    UIViewController *peekVC;
    NSInteger section = indexPath.section;
    
    if (section == 0) {
        if (indexPath.row == 0) { // awayTeam
            if (![selectedGame.awayTeam.abbreviation isEqualToString:@"FCS"]) {
                [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:selectedGame.awayTeam] animated:YES];
            }
        } else if (indexPath.row == 1) { // homeTeam
            if (![selectedGame.homeTeam.abbreviation isEqualToString:@"FCS"]) {
                [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:selectedGame.homeTeam] animated:YES];
            }
        } else { //game log
            [self viewGameSummary];
        }
    } else if (section == 1) {
        if (!selectedGame.hasPlayed) {
            Player *p;
            if (indexPath.row == 0) {
                p = [selectedGame.awayTeam playerToWatch];
            } else {
                p = [selectedGame.homeTeam playerToWatch];
            }
            PlayerDetailViewController *playerDetail;
            if (p != nil) {
                if ([p.position isEqualToString:@"QB"]) {
                    playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"RB"]) {
                    playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"WR"]) {
                    playerDetail = [[PlayerWRDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"TE"]) {
                    playerDetail = [[PlayerTEDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"OL"]) {
                    playerDetail = [[PlayerOLDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"DL"]) {
                    playerDetail = [[PlayerDLDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"LB"]) {
                    playerDetail = [[PlayerLBDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"CB"]) {
                    playerDetail = [[PlayerCBDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"S"]) {
                    playerDetail = [[PlayerSDetailViewController alloc] initWithPlayer:p];
                } else if ([p.position isEqualToString:@"K"]) {
                    playerDetail = [[PlayerKDetailViewController alloc] initWithPlayer:p];
                } else {
                    playerDetail = [[PlayerDetailViewController alloc] initWithPlayer:p];
                }
                peekVC = playerDetail;
            }
        }
    } else if (section == 2) {
        if (![self isHardMode]) {
            if (selectedGame.hasPlayed) {
                Player *plyr;
                NSDictionary *qbStats = stats[@"QBs"];
                if (indexPath.row == 0) {
                    plyr = qbStats[@"awayQB"];
                } else {
                    plyr = qbStats[@"homeQB"];
                }
                
                PlayerQBDetailViewController *playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:plyr];
                peekVC = playerDetail;
            }
        } else {
            if (!selectedGame.hasPlayed) {
                if (indexPath.row == 0) {
                    peekVC = [[InjuryReportViewController alloc] initWithTeam:selectedGame.awayTeam];
                } else {
                    peekVC = [[InjuryReportViewController alloc] initWithTeam:selectedGame.homeTeam];
                }
            } else {
                Player *plyr;
                NSDictionary *qbStats = stats[@"QBs"];
                if (indexPath.row == 0) {
                    plyr = qbStats[@"awayQB"];
                } else {
                    plyr = qbStats[@"homeQB"];
                }
                
                PlayerQBDetailViewController *playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:plyr];
                peekVC = playerDetail;
            }
        }
    } else if (section == 3) {
        if (![self isHardMode]) {
            Player *plyr;
            NSDictionary *rbStats = stats[@"RBs"]; //carries, yds, td, fum
            if (indexPath.row == 0) {
                plyr = rbStats[@"awayRB1"];
            } else if (indexPath.row == 1) {
                plyr = rbStats[@"awayRB2"];
            } else if (indexPath.row == 2) {
                plyr = rbStats[@"homeRB1"];
            } else {
                plyr = rbStats[@"homeRB2"];
            }
            PlayerRBDetailViewController *playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:plyr];
            peekVC = playerDetail;
        } else {
            if (selectedGame.hasPlayed) {
                Player *plyr;
                NSDictionary *rbStats = stats[@"RBs"]; //carries, yds, td, fum
                if (indexPath.row == 0) {
                    plyr = rbStats[@"awayRB1"];
                } else if (indexPath.row == 1) {
                    plyr = rbStats[@"awayRB2"];
                } else if (indexPath.row == 2) {
                    plyr = rbStats[@"homeRB1"];
                } else {
                    plyr = rbStats[@"homeRB2"];
                }
                PlayerRBDetailViewController *playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:plyr];
                peekVC = playerDetail;
            }
        }
    } else if (section == 4) {
        Player *plyr;
        NSDictionary *wrStats = stats[@"WRs"]; //catches, yds, td, fum
        if (indexPath.row == 0) {
            plyr = wrStats[@"awayWR1"];
        } else if (indexPath.row == 1) {
            plyr = wrStats[@"awayWR2"];
        } else if (indexPath.row == 2) {
            plyr = wrStats[@"homeWR1"];
        } else {
            plyr = wrStats[@"homeWR2"];
        }
        PlayerWRDetailViewController *playerDetail = [[PlayerWRDetailViewController alloc] initWithPlayer:plyr];
        peekVC = playerDetail;
    } else if (section == 5) {
        Player *plyr;
        NSDictionary *qbStats = stats[@"TEs"];
        if (indexPath.row == 0) {
            plyr = qbStats[@"awayTE"];
        } else {
            plyr = qbStats[@"homeTE"];
        }
        
        PlayerTEDetailViewController *playerDetail = [[PlayerTEDetailViewController alloc] initWithPlayer:plyr];
        peekVC = playerDetail;
    } else if (section == 6) {
        Player *plyr;
        NSDictionary *wrStats = stats[@"DLs"]; //catches, yds, td, fum
        if (indexPath.row == 0) {
            plyr = wrStats[@"awayDL1"];
        } else if (indexPath.row == 1) {
            plyr = wrStats[@"awayDL2"];
        } else if (indexPath.row == 2) {
            plyr = wrStats[@"awayDL3"];
        } else if (indexPath.row == 3) {
            plyr = wrStats[@"awayDL4"];
        } else if (indexPath.row == 4) {
            plyr = wrStats[@"homeDL1"];
        } else if (indexPath.row == 5) {
            plyr = wrStats[@"homeDL2"];
        } else if (indexPath.row == 6) {
            plyr = wrStats[@"homeDL3"];
        } else {
            plyr = wrStats[@"homeDL4"];
        }
        PlayerDLDetailViewController *playerDetail = [[PlayerDLDetailViewController alloc] initWithPlayer:plyr];
        peekVC = playerDetail;
    } else if (section == 7) {
        Player *plyr;
        NSDictionary *wrStats = stats[@"LBs"]; //catches, yds, td, fum
        if (indexPath.row == 0) {
            plyr = wrStats[@"awayLB1"];
        } else if (indexPath.row == 1) {
            plyr = wrStats[@"awayLB2"];
        } else if (indexPath.row == 2) {
            plyr = wrStats[@"awayLB3"];
        } else if (indexPath.row == 3) {
            plyr = wrStats[@"homeLB1"];
        } else if (indexPath.row == 4) {
            plyr = wrStats[@"homeLB2"];
        } else {
            plyr = wrStats[@"homeLB3"];
        }
        PlayerLBDetailViewController *playerDetail = [[PlayerLBDetailViewController alloc] initWithPlayer:plyr];
        peekVC = playerDetail;
    } else if (section == 8) {
        Player *plyr;
        NSDictionary *wrStats = stats[@"CBs"]; //catches, yds, td, fum
        if (indexPath.row == 0) {
            plyr = wrStats[@"awayCB1"];
        } else if (indexPath.row == 1) {
            plyr = wrStats[@"awayCB2"];
        } else if (indexPath.row == 2) {
            plyr = wrStats[@"awayCB3"];
        } else if (indexPath.row == 3) {
            plyr = wrStats[@"homeCB1"];
        } else if (indexPath.row == 4) {
            plyr = wrStats[@"homeCB2"];
        } else {
            plyr = wrStats[@"homeCB3"];
        }
        PlayerCBDetailViewController *playerDetail = [[PlayerCBDetailViewController alloc] initWithPlayer:plyr];
        peekVC = playerDetail;
    } else if (section == 9) {
        Player *plyr;
        NSDictionary *qbStats = stats[@"Ss"];
        if (indexPath.row == 0) {
            plyr = qbStats[@"awayS"];
        } else {
            plyr = qbStats[@"homeS"];
        }
        
        PlayerSDetailViewController *playerDetail = [[PlayerSDetailViewController alloc] initWithPlayer:plyr];
        peekVC = playerDetail;
    } else if (section == 10) {
        Player *plyr;
        NSDictionary *qbStats = stats[@"Ks"];
        if (indexPath.row == 0) {
            plyr = qbStats[@"awayK"];
        } else {
            plyr = qbStats[@"homeK"];
        }
        
        PlayerKDetailViewController *playerDetail = [[PlayerKDetailViewController alloc] initWithPlayer:plyr];
        peekVC = playerDetail;
    } else {
        if (indexPath.row == 0) {
            peekVC = [[TeamViewController alloc] initWithTeam:selectedGame.awayTeam];
        } else if (indexPath.row == 1) {
            peekVC = [[TeamViewController alloc] initWithTeam:selectedGame.homeTeam];
        } else {
            peekVC = nil;
        }
    }
    if (peekVC != nil) {
        [self.navigationController pushViewController:peekVC animated:YES];
    }
}

@end
