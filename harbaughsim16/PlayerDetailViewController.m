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
    [playerDetailView.yrLabel setText:[NSString stringWithFormat:@"%@ (Ovr: %d)",[selectedPlayer getFullYearString],selectedPlayer.ratOvr]];
    [playerDetailView.posLabel setText:selectedPlayer.position];
    self.tableView.tableHeaderView = playerDetailView;
    stats = [selectedPlayer detailedStats:[HBSharedUtils getLeague].currentWeek];
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
        return @"Statistics";
    } else {
        return @"Ratings";
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
        return 2;
    } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
        return 2;
    } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
        return 2;
    } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerF7 class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
        return 1;
    } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
        return 1;
    } else { // PlayerK class
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return stats.allKeys.count;
    } else {
        return 3;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //NSString *stat;
    /*if (indexPath.section == 1) {
        stat = stats.allValues[indexPath.row];
        [cell.textLabel setText:[self getStatName:stats.allKeys[indexPath.row]]];
    } else {
        stat = ratings.allValues[indexPath.row];
        [cell.textLabel setText:[self getStatName:ratings.allKeys[indexPath.row]]];
    }*/
    
    if ([selectedPlayer isKindOfClass:[PlayerQB class]]) {
        if (indexPath.section == 0) {   //ratings
            if (indexPath.row == 0) {
                //pow
                [cell.detailTextLabel setText:ratings[@"passPower"]];
                [cell.textLabel setText:@"Throwing Power"];
            } else if (indexPath.row == 1) {
                //acc
                [cell.detailTextLabel setText:ratings[@"passAccuracy"]];
                [cell.textLabel setText:@"Throwing Accuracy"];
            } else {
                //eva
                [cell.detailTextLabel setText:ratings[@"passEvasion"]];
                [cell.textLabel setText:@"Evasion"];
            }
        } else {    //stats - comp, att, yds, CompPerc, Yd/att, ypg, TD, INT
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:stats[@"completions"]];
                [cell.textLabel setText:@"Completions"];
            } else if (indexPath.row == 1) {
                [cell.detailTextLabel setText:stats[@"attempts"]];
                [cell.textLabel setText:@"Pass Attempts"];
            } else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:stats[@"passYards"]];
                [cell.textLabel setText:@"Yards"];
            } else if (indexPath.row == 3) {
                [cell.detailTextLabel setText:stats[@"completionPercentage"]];
                [cell.textLabel setText:@"Completion Percentage"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:stats[@"yardsPerAttempt"]];
                [cell.textLabel setText:@"Yards Per Attempt"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:stats[@"touchdowns"]];
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                [cell.detailTextLabel setText:stats[@"interceptions"]];
                [cell.textLabel setText:@"Interceptions"];
            }
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerRB class]]) {
        if (indexPath.section == 0) {   //ratings
            if (indexPath.row == 0) {
                //pow
                [cell.detailTextLabel setText:ratings[@"rushPower"]];
                [cell.textLabel setText:@"Strength"];
            } else if (indexPath.row == 1) {
                //spd
                [cell.detailTextLabel setText:ratings[@"rushSpeed"]];
                [cell.textLabel setText:@"Speed"];
            } else {
                //eva
                [cell.detailTextLabel setText:ratings[@"rushEvasion"]];
                [cell.textLabel setText:@"Evasion"];
            }
        } else {    //stats - carries, yards, yd/car, ypg, TD, Fum
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:stats[@"carries"]];
                [cell.textLabel setText:@"Carries"];
            } else if (indexPath.row == 1) {
                [cell.detailTextLabel setText:stats[@"rushYards"]];
                [cell.textLabel setText:@"Yards"];
            } else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:stats[@"yardsPerCarry"]];
                [cell.textLabel setText:@"Yards Per Carry"];
            } else if (indexPath.row == 3) {
                [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:stats[@"touchdowns"]];
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                [cell.detailTextLabel setText:stats[@"fumbles"]];
                [cell.textLabel setText:@"Fumbles"];
            }
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerWR class]]) {
        if (indexPath.section == 0) {   //ratings
            if (indexPath.row == 0) {
                //cat
                [cell.detailTextLabel setText:ratings[@"recCatch"]];
                [cell.textLabel setText:@"Catching"];
            } else if (indexPath.row == 1) {
                //spd
                [cell.detailTextLabel setText:ratings[@"recSpeed"]];
                [cell.textLabel setText:@"Speed"];
            } else {
                //eva
                [cell.detailTextLabel setText:ratings[@"recEvasion"]];
                [cell.textLabel setText:@"Evasion"];
            }
        } else {    //stats - catches, yards, yd/cat, ypg, TD, Fum
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:stats[@"catches"]];
                [cell.textLabel setText:@"Catches"];
            } else if (indexPath.row == 1) {
                [cell.detailTextLabel setText:stats[@"recYards"]];
                [cell.textLabel setText:@"Yards"];
            } else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:stats[@"yardsPerCatch"]];
                [cell.textLabel setText:@"Yards Per Catch"];
            } else if (indexPath.row == 3) {
                [cell.detailTextLabel setText:stats[@"yardsPerGame"]];
                [cell.textLabel setText:@"Yards Per Game"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:stats[@"touchdowns"]];
                [cell.textLabel setText:@"Touchdowns"];
            } else {
                [cell.detailTextLabel setText:stats[@"fumbles"]];
                [cell.textLabel setText:@"Fumbles"];
            }
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerOL class]]) {
        //ratings
        if (indexPath.row == 0) {
            //pow
            [cell.detailTextLabel setText:ratings[@"olPower"]];
            [cell.textLabel setText:@"Strength"];
        } else if (indexPath.row == 1) {
            //blkP
            [cell.detailTextLabel setText:ratings[@"olPassBlock"]];
            [cell.textLabel setText:@"Pass Blocking"];
        } else {
            //blkR
            [cell.detailTextLabel setText:ratings[@"olRunBlock"]];
            [cell.textLabel setText:@"Run Blocking"];
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerF7 class]]) {
        //ratings
        if (indexPath.row == 0) {
            //pow
            [cell.detailTextLabel setText:ratings[@"f7Pow"]];
            [cell.textLabel setText:@"Strength"];
        } else if (indexPath.row == 1) {
            //pass
            [cell.detailTextLabel setText:ratings[@"f7Pass"]];
            [cell.textLabel setText:@"Pass Pressure"];
        } else {
            //rsh
            [cell.detailTextLabel setText:ratings[@"f7Run"]];
            [cell.textLabel setText:@"Run Stopping"];
            
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerCB class]]) {
        //ratings
        if (indexPath.row == 0) {
           //cov
            [cell.detailTextLabel setText:ratings[@"cbCoverage"]];
            [cell.textLabel setText:@"Coverage Ability"];
        } else if (indexPath.row == 1) {
            //spd
            [cell.detailTextLabel setText:ratings[@"cbSpeed"]];
            [cell.textLabel setText:@"Speed"];
        } else {
            //tkl
            [cell.detailTextLabel setText:ratings[@"cbTackling"]];
            [cell.textLabel setText:@"Tackling Ability"];
        }
    } else if ([selectedPlayer isKindOfClass:[PlayerS class]]) {
        //ratings
        if (indexPath.row == 0) {
            //cov
            [cell.detailTextLabel setText:ratings[@"sCoverage"]];
            [cell.textLabel setText:@"Coverage Ability"];
        } else if (indexPath.row == 1) {
            //spd
            [cell.detailTextLabel setText:ratings[@"sSpeed"]];
            [cell.textLabel setText:@"Speed"];
        } else {
            //tkl
            [cell.detailTextLabel setText:ratings[@"sTackling"]];
            [cell.textLabel setText:@"Tackling Ability"];
        }
    } else { // PlayerK class
        if (indexPath.section == 0) {   //ratings
            if (indexPath.row == 0) {
                //pow
                [cell.detailTextLabel setText:ratings[@"kickPower"]];
                [cell.textLabel setText:@"Kick Power"];
            } else if (indexPath.row == 1) {
                //acc
                [cell.detailTextLabel setText:ratings[@"kickAccuracy"]];
                [cell.textLabel setText:@"Kick Accuracy"];
            } else {
                //fum
                [cell.detailTextLabel setText:ratings[@"kickClumsiness"]];
                [cell.textLabel setText:@"Clumsiness"];
            }
        } else {    //stats - xp made, xp att, xp perc, fg made, fg att, fg perc
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:stats[@"xpMade"]];
                [cell.textLabel setText:@"XP Made"];
            } else if (indexPath.row == 1) {
                [cell.detailTextLabel setText:stats[@"xpAtt"]];
                [cell.textLabel setText:@"XP Attempted"];
            } else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:stats[@"xpPercentage"]];
                [cell.textLabel setText:@"XP Percentage"];
            } else if (indexPath.row == 3) {
                [cell.detailTextLabel setText:stats[@"fgMade"]];
                [cell.textLabel setText:@"FG Made"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:stats[@"fgAtt"]];
                [cell.textLabel setText:@"FG Attempted"];
            } else {
                [cell.detailTextLabel setText:stats[@"fgPercentage"]];
                [cell.textLabel setText:@"FG Percentage"];
            }
        }
    }
    
    
    //[cell.detailTextLabel setText:stat];
    NSString *stat = cell.detailTextLabel.text;
    
    if (indexPath.section == 0) {
        UIColor *letterColor;   //colors for ratings to tell what's what
        if ([stat containsString:@"A"]) {
            letterColor = [UIColor hx_colorWithHexRGBAString:@"#1a9641"];
        } else if ([stat containsString:@"B"]) {
            letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
        } else if ([stat containsString:@"C"]) {
            letterColor = [UIColor hx_colorWithHexRGBAString:@"#eeb211"];
        } else if ([stat containsString:@"D"]) {
            letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
        } else {
            letterColor = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
        }
        [cell.detailTextLabel setTextColor:letterColor];
    }
    
    
    return cell;
}


-(NSString*)getStatName:(NSString*)key {
    if ([key isEqualToString:@"touchdowns"]) {              //QBs
        return @"Touchdowns";
    } else if ([key isEqualToString:@"interceptions"]) {
        return @"Interceptions";
    } else if ([key isEqualToString:@"completions"]) {
        return @"Pass Completions";
    } else if ([key isEqualToString:@"attempts"]) {
        return @"Pass Attempts";
    } else if ([key isEqualToString:@"interceptions"]) {
        return @"Interceptions";
    } else if ([key isEqualToString:@"completionPercentage"]) {
        return @"Completion Percentage";
    } else if ([key isEqualToString:@"passYards"]) {
        return @"Pass Yards";
    } else if ([key isEqualToString:@"yardsPerGame"]) {
        return @"Yards Per Game";
    } else if ([key isEqualToString:@"yardsPerAttempt"]) {
        return @"Yards Per Attempt";
    } else if ([key isEqualToString:@"passPower"]) {
        return @"Arm Strength";
    } else if ([key isEqualToString:@"passAccuracy"]) {
        return @"Pass Accuracy";
    } else if ([key isEqualToString:@"passEvasion"]) {
        return @"Evasion";
    }
    
    else if ([key isEqualToString:@"fumbles"]) {          //RBs
        return @"Fumbles";
    } else if ([key isEqualToString:@"carries"]) {
        return @"Carries";
    } else if ([key isEqualToString:@"rushYards"]) {
        return @"Rush Yards";
    } else if ([key isEqualToString:@"yardsPerGame"]) {
        return @"Yards Per Game";
    } else if ([key isEqualToString:@"yardsPerCarry"]) {
        return @"Yards Per Carry";
    } else if ([key isEqualToString:@"rushPower"]) {
        return @"Strength";
    } else if ([key isEqualToString:@"rushSpeed"]) {
        return @"Speed";
    } else if ([key isEqualToString:@"rushEvasion"]) {
        return @"Evasion";
    }
    
    
    else if ([key isEqualToString:@"yardsPerCatch"]) {   //WRs
        return @"Yards Per Catch";
    } else if ([key isEqualToString:@"catches"]) {
        return @"Catches";
    } else if ([key isEqualToString:@"recYards"]) {
        return @"Receiving Yards";
    } else if ([key isEqualToString:@"yardsPerGame"]) {
        return @"Yards Per Game";
    } else if ([key isEqualToString:@"yardsPerAttempt"]) {
        return @"Yards Per Attempt";
    } else if ([key isEqualToString:@"recCatch"]) {
        return @"Catching Ability";
    } else if ([key isEqualToString:@"recSpeed"]) {
        return @"Speed";
    } else if ([key isEqualToString:@"recEvasion"]) {
        return @"Evasion";
    }
    
    
    else if ([key isEqualToString:@"olPotential"]) {          //OLs
        return @"Potential";
    } else if ([key isEqualToString:@"olPower"]) {
        return @"Strength";
    } else if ([key isEqualToString:@"olPassBlock"]) {
        return @"Pass Blocking";
    } else if ([key isEqualToString:@"olRunBlock"]) {
        return @"Run Blocking";
    }
    
    else if ([key isEqualToString:@"xpMade"]) {          //Ks
        return @"XP Made";
    } else if ([key isEqualToString:@"xpAtt"]) {
        return @"XP Attempted";
    } else if ([key isEqualToString:@"xpPercentage"]) {
        return @"XP Percentage";
    } else if ([key isEqualToString:@"fgMade"]) {
        return @"FG Made";
    } else if ([key isEqualToString:@"fgAtt"]) {
        return @"FG Attempted";
    } else if ([key isEqualToString:@"fgPercentage"]) {
        return @"FG Percentage";
    } else if ([key isEqualToString:@"kickPower"]) {
        return @"Kicking Power";
    } else if ([key isEqualToString:@"kickAccuracy"]) {
        return @"Kick Accuracy";
    } else if ([key isEqualToString:@"kickClumsiness"]) {
        return @"Clumsiness";
    }
    
    else if ([key isEqualToString:@"f7Potential"]) {          //F7s
        return @"Potential";
    } else if ([key isEqualToString:@"f7Power"]) {
        return @"Strength";
    } else if ([key isEqualToString:@"f7Rush"]) {
        return @"Run Defense";
    } else if ([key isEqualToString:@"f7Pass"]) {
        return @"Pass Pressure";
    }
    
    else if ([key isEqualToString:@"cbPotential"]) {          //CBs
        return @"Potential";
    } else if ([key isEqualToString:@"cbCoverage"]) {
        return @"Coverage Ability";
    } else if ([key isEqualToString:@"cbSpeed"]) {
        return @"Speed";
    } else if ([key isEqualToString:@"cbTackling"]) {
        return @"Tackling Ability";
    }
    
    else if ([key isEqualToString:@"sPotential"]) {          //Ss
        return @"Potential";
    } else if ([key isEqualToString:@"sCoverage"]) {
        return @"Coverage Ability";
    } else if ([key isEqualToString:@"sSpeed"]) {
        return @"Speed";
    } else if ([key isEqualToString:@"sTackling"]) {
        return @"Tackling Ability";
    }
    
    else {
        return @"Unknown";
    }
}

@end
