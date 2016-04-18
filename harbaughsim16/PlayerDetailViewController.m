//
//  StatDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Player.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "HexColors.h"

@interface HBPlayerDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yrLabel;
@property (weak, nonatomic) IBOutlet UILabel *posLabel;
@end
@implementation HBPlayerDetailView
@end

@interface PlayerDetailViewController ()
{
    Player *selectedPlayer;
    IBOutlet HBPlayerDetailView *playerDetailView;
    NSDictionary *stats;
    NSDictionary *careerStats;
    NSDictionary *ratings;
}
@end

@implementation PlayerDetailViewController
-(instancetype)initWithPlayer:(Player*)player {
    self = [super init];
    if(self) {
        selectedPlayer = player;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Player";
    [playerDetailView.nameLabel setText:selectedPlayer.name];
    [playerDetailView.yrLabel setText:[NSString stringWithFormat:@"%@ - %@ (Ovr: %d)",[selectedPlayer getFullYearString],selectedPlayer.team.abbreviation,selectedPlayer.ratOvr]];
    [playerDetailView.posLabel setText:selectedPlayer.position];
    self.tableView.tableHeaderView = playerDetailView;
    stats = [selectedPlayer detailedStats:[HBSharedUtils getLeague].currentWeek];
    careerStats = [selectedPlayer detailedCareerStats];
    ratings = [selectedPlayer detailedRatings];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [playerDetailView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)reloadAll {
    [playerDetailView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    } else {
       return [super tableView:tableView heightForHeaderInSection:section];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Season Stats";
    } else if (section == 2) {
        return @"Career Stats";
    } else {
        return @"Ratings";
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
        return 3;
    } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
        return 3;
    } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
        return 3;
    } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerF7 class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
        return 1;
    } else { // PlayerK class
        return 3;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return stats.allKeys.count;
    } else if (section == 2) {
        return careerStats.allKeys.count;
    } else {
        return ratings.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return [NSString stringWithFormat:@"Over %ld games", (long)selectedPlayer.gamesPlayed];
    } else {
        return nil;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
        if (indexPath.section == 0) {   //ratings
            if (indexPath.row == 0) {
                //pot
                [cell.detailTextLabel setText:ratings[@"potential"]];
                [cell.textLabel setText:@"Potential"];
            } else if (indexPath.row == 1) {
                //pow
                [cell.detailTextLabel setText:ratings[@"passPower"]];
                [cell.textLabel setText:@"Throwing Power"];
            } else if (indexPath.row == 2) {
                //acc
                [cell.detailTextLabel setText:ratings[@"passAccuracy"]];
                [cell.textLabel setText:@"Throwing Accuracy"];
            } else if (indexPath.row == 3) {
                //eva
                [cell.detailTextLabel setText:ratings[@"passEvasion"]];
                [cell.textLabel setText:@"Evasion"];
            } else {
                //footiq
                [cell.detailTextLabel setText:ratings[@"footballIQ"]];
                [cell.textLabel setText:@"Football IQ"];
            }
        } else {    //stats - comp, att, yds, CompPerc, Yd/att, ypg, TD, INT
            if (indexPath.row == 0) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"completions"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"completions"]];
                }
                [cell.textLabel setText:@"Completions"];
            } else if (indexPath.row == 1) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"attempts"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"attempts"]];
                }
                [cell.textLabel setText:@"Pass Attempts"];
            } else if (indexPath.row == 2) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"passYards"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"passYards"]];
                }
                [cell.textLabel setText:@"Yards"];
            } else if (indexPath.row == 3) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"completionPercentage"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"completionPercentage"]];
                }
                [cell.textLabel setText:@"Completion Percentage"];
            } else if (indexPath.row == 4) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"yardsPerAttempt"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerAttempt"]];
                }
                [cell.textLabel setText:@"Yards Per Attempt"];
            } else if (indexPath.row == 5) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                }
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 6) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"touchdowns"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                }
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"interceptions"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"interceptions"]];
                }
                [cell.textLabel setText:@"Interceptions"];
            }
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
        if (indexPath.section == 0) {   //ratings
            if (indexPath.row == 0) {
                //pot
                [cell.detailTextLabel setText:ratings[@"potential"]];
                [cell.textLabel setText:@"Potential"];
            } else if (indexPath.row == 1) {
                //pow
                [cell.detailTextLabel setText:ratings[@"rushPower"]];
                [cell.textLabel setText:@"Strength"];
            } else if (indexPath.row == 2) {
                //spd
                [cell.detailTextLabel setText:ratings[@"rushSpeed"]];
                [cell.textLabel setText:@"Speed"];
            } else if (indexPath.row == 3) {
                //eva
                [cell.detailTextLabel setText:ratings[@"rushEvasion"]];
                [cell.textLabel setText:@"Evasion"];
            } else {
                //footiq
                [cell.detailTextLabel setText:ratings[@"footballIQ"]];
                [cell.textLabel setText:@"Football IQ"];
            }
        } else {    //stats - carries, yards, yd/car, ypg, TD, Fum
            if (indexPath.row == 0) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"carries"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"carries"]];
                }
                [cell.textLabel setText:@"Carries"];
            } else if (indexPath.row == 1) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"rushYards"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"rushYards"]];
                }
                [cell.textLabel setText:@"Yards"];
            } else if (indexPath.row == 2) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"yardsPerCarry"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerCarry"]];
                }
                [cell.textLabel setText:@"Yards Per Carry"];
            } else if (indexPath.row == 3) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                }
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 4) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"touchdowns"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                }
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"fumbles"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                }
                [cell.textLabel setText:@"Fumbles"];
            }
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
        if (indexPath.section == 0) {   //ratings
            if (indexPath.row == 0) {
                //pot
                [cell.detailTextLabel setText:ratings[@"potential"]];
                [cell.textLabel setText:@"Potential"];
            } else if (indexPath.row == 1) {
                //cat
                [cell.detailTextLabel setText:ratings[@"recCatch"]];
                [cell.textLabel setText:@"Catching"];
            } else if (indexPath.row == 2) {
                //spd
                [cell.detailTextLabel setText:ratings[@"recSpeed"]];
                [cell.textLabel setText:@"Speed"];
            } else if (indexPath.row == 3) {
                //eva
                [cell.detailTextLabel setText:ratings[@"recEvasion"]];
                [cell.textLabel setText:@"Evasion"];
            } else {
                //footiq
                [cell.detailTextLabel setText:ratings[@"footballIQ"]];
                [cell.textLabel setText:@"Football IQ"];
            }
        } else {    //stats - catches, yards, yd/cat, ypg, TD, Fum
            if (indexPath.row == 0) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"catches"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"catches"]];
                }
                [cell.textLabel setText:@"Catches"];
            } else if (indexPath.row == 1) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"recYards"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"recYards"]];
                }
                [cell.textLabel setText:@"Yards"];
            } else if (indexPath.row == 2) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"yardsPerCatch"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerCatch"]];
                }
                [cell.textLabel setText:@"Yards Per Catch"];
            } else if (indexPath.row == 3) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"yardsPerGame"]];
                }
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 4) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"touchdowns"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"touchdowns"]];
                }
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"fumbles"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                }
                [cell.textLabel setText:@"Fumbles"];
            }
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
        //ratings
        if (indexPath.row == 0) {
            //pot
            [cell.detailTextLabel setText:ratings[@"potential"]];
            [cell.textLabel setText:@"Potential"];
        } else if (indexPath.row == 1) {
            //pow
            [cell.detailTextLabel setText:ratings[@"olPower"]];
            [cell.textLabel setText:@"Strength"];
        } else if (indexPath.row == 2) {
            //blkP
            [cell.detailTextLabel setText:ratings[@"olPassBlock"]];
            [cell.textLabel setText:@"Pass Blocking"];
        } else if (indexPath.row == 3) {
            //blkR
            [cell.detailTextLabel setText:ratings[@"olRunBlock"]];
            [cell.textLabel setText:@"Run Blocking"];
        } else {
            //footiq
            [cell.detailTextLabel setText:ratings[@"footballIQ"]];
            [cell.textLabel setText:@"Football IQ"];
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerF7 class]]) {
        //ratings
        if (indexPath.row == 0) {
            //pot
            [cell.detailTextLabel setText:ratings[@"potential"]];
            [cell.textLabel setText:@"Potential"];
        } else if (indexPath.row == 1) {
            //pow
            [cell.detailTextLabel setText:ratings[@"f7Pow"]];
            [cell.textLabel setText:@"Strength"];
        } else if (indexPath.row == 2) {
            //pass
            [cell.detailTextLabel setText:ratings[@"f7Pass"]];
            [cell.textLabel setText:@"Pass Pressure"];
        } else if (indexPath.row == 3) {
            //rsh
            [cell.detailTextLabel setText:ratings[@"f7Run"]];
            [cell.textLabel setText:@"Run Stopping"];
        } else {
            //footiq
            [cell.detailTextLabel setText:ratings[@"footballIQ"]];
            [cell.textLabel setText:@"Football IQ"];
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
        //ratings
        if (indexPath.row == 0) {
            //pot
            [cell.detailTextLabel setText:ratings[@"potential"]];
            [cell.textLabel setText:@"Potential"];
        } else if (indexPath.row == 1) {
           //cov
            [cell.detailTextLabel setText:ratings[@"cbCoverage"]];
            [cell.textLabel setText:@"Coverage Ability"];
        } else if (indexPath.row == 2) {
            //spd
            [cell.detailTextLabel setText:ratings[@"cbSpeed"]];
            [cell.textLabel setText:@"Speed"];
        } else if (indexPath.row == 3) {
            //tkl
            [cell.detailTextLabel setText:ratings[@"cbTackling"]];
            [cell.textLabel setText:@"Tackling Ability"];
        } else {
            //footiq
            [cell.detailTextLabel setText:ratings[@"footballIQ"]];
            [cell.textLabel setText:@"Football IQ"];
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
        //ratings
        if (indexPath.row == 0) {
            //pot
            [cell.detailTextLabel setText:ratings[@"potential"]];
            [cell.textLabel setText:@"Potential"];
        } else if (indexPath.row == 1) {
            //cov
            [cell.detailTextLabel setText:ratings[@"sCoverage"]];
            [cell.textLabel setText:@"Coverage Ability"];
        } else if (indexPath.row == 2) {
            //spd
            [cell.detailTextLabel setText:ratings[@"sSpeed"]];
            [cell.textLabel setText:@"Speed"];
        } else if (indexPath.row == 3) {
            //tkl
            [cell.detailTextLabel setText:ratings[@"sTackling"]];
            [cell.textLabel setText:@"Tackling Ability"];
        } else {
            //footiq
            [cell.detailTextLabel setText:ratings[@"footballIQ"]];
            [cell.textLabel setText:@"Football IQ"];
        }
    } else { // PlayerK class
        if (indexPath.section == 0) {   //ratings
            if (indexPath.row == 0) {
                //pot
                [cell.detailTextLabel setText:ratings[@"potential"]];
                [cell.textLabel setText:@"Potential"];
            } else if (indexPath.row == 1) {
                //pow
                [cell.detailTextLabel setText:ratings[@"kickPower"]];
                [cell.textLabel setText:@"Kick Power"];
            } else if (indexPath.row == 2) {
                //acc
                [cell.detailTextLabel setText:ratings[@"kickAccuracy"]];
                [cell.textLabel setText:@"Kick Accuracy"];
            } else if (indexPath.row == 3) {
                //fum
                [cell.detailTextLabel setText:ratings[@"kickClumsiness"]];
                [cell.textLabel setText:@"Clumsiness"];
            } else {
                //footiq
                [cell.detailTextLabel setText:ratings[@"footballIQ"]];
                [cell.textLabel setText:@"Football IQ"];
            }
        } else {    //stats - xp made, xp att, xp perc, fg made, fg att, fg perc
            if (indexPath.row == 0) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"xpMade"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"xpMade"]];
                }
                [cell.textLabel setText:@"XP Made"];
            } else if (indexPath.row == 1) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"xpAtt"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"xpAtt"]];
                }
                [cell.textLabel setText:@"XP Attempted"];
            } else if (indexPath.row == 2) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"xpPercentage"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"xpPercentage"]];
                }
                [cell.textLabel setText:@"XP Percentage"];
            } else if (indexPath.row == 3) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"fgMade"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fgMade"]];
                }
                [cell.textLabel setText:@"FG Made"];
            } else if (indexPath.row == 4) {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"fgAtt"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fgAtt"]];
                }
                [cell.textLabel setText:@"FG Attempted"];
            } else {
                if (indexPath.section == 1) {
                    [cell.detailTextLabel setText:stats[@"fgPercentage"]];
                } else {
                    [cell.detailTextLabel setText:careerStats[@"fgPercentage"]];
                }
                [cell.textLabel setText:@"FG Percentage"];
            }
        }
    }
    
    NSString *stat = cell.detailTextLabel.text;
    
    if (indexPath.section == 0) {
        UIColor *letterColor;   //colors for ratings to tell what's what
        if ([stat containsString:@"A"]) {
            letterColor = [HBSharedUtils successColor];
        } else if ([stat containsString:@"B"]) {
            letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
        } else if ([stat containsString:@"C"]) {
            letterColor = [HBSharedUtils champColor];
        } else if ([stat containsString:@"D"]) {
            letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
        } else {
            letterColor = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
        }
        [cell.detailTextLabel setTextColor:letterColor];
    } else {
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    return cell;
}

@end
