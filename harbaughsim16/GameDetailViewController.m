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

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "HexColors.h"

@interface HBGameDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *homeLabel;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeScore;
@property (weak, nonatomic) IBOutlet UILabel *awayScore;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation HBGameDetailCell
@end

@interface HBGameSummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *centerLabel;
@end

@implementation HBGameSummaryCell
@end

@interface GameDetailViewController ()
{
    Game *selectedGame;
    IBOutlet HBGameDetailCell *gameDetailCell;
    IBOutlet HBGameSummaryCell *gameSummaryCell;
    NSDictionary *stats;
    //game detail cell
    
    //game stats
        //home qb
        //away qb
    
        //home rbs (2)
        //away rbs (2)
    
        //home WRs
        //away WRs
    
        //home K
        //away K
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
    NSString *homeRank = @"";
    if (selectedGame.homeTeam.rankTeamPollScore < 26) {
        homeRank = [NSString stringWithFormat:@"#%d ",selectedGame.homeTeam.rankTeamPollScore];
    }
    [gameDetailCell.homeLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,selectedGame.homeTeam.abbreviation]];
    NSString *awayRank = @"";
    if (selectedGame.awayTeam.rankTeamPollScore < 26) {
        awayRank = [NSString stringWithFormat:@"#%d ",selectedGame.awayTeam.rankTeamPollScore];
    }
    [gameDetailCell.awayLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,selectedGame.awayTeam.abbreviation]];
    [gameDetailCell.homeScore setText:[NSString stringWithFormat:@"%d",selectedGame.homeScore]];
    [gameDetailCell.awayScore setText:[NSString stringWithFormat:@"%d",selectedGame.awayScore]];
    [gameDetailCell.nameLabel setText:selectedGame.gameName];
    if (selectedGame.hasPlayed) {
        [gameDetailCell.timeLabel setText:@"Final"];
    } else {
        [gameDetailCell.timeLabel setText:@"TBP"];
    }
    
    stats = [selectedGame gameReport];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBStatsCell" bundle:nil] forCellReuseIdentifier:@"HBStatsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBPlayerCell" bundle:nil] forCellReuseIdentifier:@"HBPlayerCell"];
    
    [self.view setBackgroundColor:[UIColor hx_colorWithHexRGBAString:@"#009740"]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
}

-(void)viewGameSummary {
    UIViewController *viewController = [[UIViewController alloc] init];
    [viewController.view setBackgroundColor:[UIColor whiteColor]];
    viewController.title = @"Summary";

    NSString *summary = [selectedGame gameSummary];
    
    CGSize size = [summary boundingRectWithSize:CGSizeMake(260, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;//[attributedText boundingRectWithSize:CGSizeMake(260, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    UITextView *postTextLabel = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width - 30, size.height)];
    [postTextLabel setEditable:NO];

    [postTextLabel setText:summary];
    [postTextLabel sizeToFit];
    [postTextLabel.textContainer setSize:postTextLabel.frame.size];
    
    
    [viewController setView:postTextLabel];
    [self.navigationController pushViewController:viewController animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 175;
        } else {
            return 50;
        }
    } else {
        return 60;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        if (!selectedGame.hasPlayed) {
            return @"Scouting Report";
        } else {
            return @"Game Stats";
        }
    } else if (section == 2) {
        return @"Quarterbacks";
    } else if (section == 3) {
        return @"Running Backs";
    } else if (section == 4) {
        return @"Wide Receivers";
    } else if (section == 5) {
        return @"Kickers";
    } else {
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!selectedGame.hasPlayed) {
        return 2;
    } else {
        return 6;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!selectedGame.hasPlayed) {
        if (section == 0) {
            return 1;
        } else {
            return stats.allKeys.count;
        }
    } else {
        if (section == 0) {
            return 2;
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
            return gameDetailCell;
        } else {
            HBStatsCell *statsCell = (HBStatsCell*)[tableView dequeueReusableCellWithIdentifier:@"HBStatsCell"];
            NSArray *stat; //= stats.allValues[indexPath.row];
            NSString *title;// = stats.allKeys[indexPath.row];
            if (indexPath.row == 0) {
                title = @"Ranking";
            } else if (indexPath.row == 1) {
                title = @"Record";
            } else if (indexPath.row == 2) {
                title = @"PPG";
            } else if (indexPath.row == 3) {
                title = @"Opp PPG";
            } else if (indexPath.row == 4) {
                title = @"YPG";
            } else if (indexPath.row == 5) {
                title = @"Opp YPG";
            } else if (indexPath.row == 6) {
                title = @"Pass YPG";
            } else if (indexPath.row == 7) {
                title = @"Opp PYPG";
            } else if (indexPath.row == 8) {
                title = @"Rush YPG";
            } else if (indexPath.row == 9) {
                title = @"Opp RYPG";
            } else {
                title = @"Prestige";
            }
            stat = stats[title];
            
            [statsCell.statLabel setText:title];
            [statsCell.homeTeamLabel setText:selectedGame.homeTeam.abbreviation];
            [statsCell.awayTeamLabel setText:selectedGame.awayTeam.abbreviation];
            [statsCell.homeValueLabel setText:stat[1]];
            [statsCell.awayValueLabel setText:stat[0]];
            return statsCell;
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                return gameDetailCell;
            } else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
                
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
                }
                
                [cell.textLabel setText:@"View Game Summary"];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setTextColor:self.view.tintColor];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
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
                    plyrStats = qbStats[@"homeQBStats"];
                }
                stat1 = @"C/A"; //comp/att, yds, td, int
                stat2 = @"Yds";
                stat3 = @"TDs";
                stat4 = @"INTs";
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
            }
            
            stat1Value = [NSString stringWithFormat:@"%d",[plyrStats[0] intValue]];
            stat2Value = [NSString stringWithFormat:@"%d",[plyrStats[1] intValue]];
            stat3Value = [NSString stringWithFormat:@"%d",[plyrStats[2] intValue]];
            stat4Value = [NSString stringWithFormat:@"%d",[plyrStats[3] intValue]];
            
            [statsCell.playerLabel setText:[plyr getInitialName]];
            [statsCell.teamLabel setText:plyr.team.abbreviation];
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
            } else if (indexPath.section == 4) {
                if (indexPath.row == 0) {
                    plyr = kStats[@"homeK"];
                } else {
                    plyr = kStats[@"awayK"];
                }
            } else {
                if (indexPath.section == 0 && indexPath.row == 1) {
                    [self viewGameSummary];
                } else {
                    //do nothing
                }
            }
            
            if (plyr) {
                [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:plyr] animated:YES];
            }
            
        }
    }
    
}
@end
