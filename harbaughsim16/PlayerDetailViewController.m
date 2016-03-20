//
//  StatDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Player.h"

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
    [playerDetailView.yrLabel setText:[selectedPlayer getFullYearString]];
    [playerDetailView.posLabel setText:selectedPlayer.position];
    self.tableView.tableHeaderView = playerDetailView;
    stats = [selectedPlayer detailedStats:[HBSharedUtils getLeague].currentWeek];
    ratings = [selectedPlayer detailedRatings];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [playerDetailView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Statistics";
    } else {
        return @"Ratings";
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
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
    
    NSString *stat;
    if (indexPath.section == 1) {
        stat = stats.allValues[indexPath.row];
        [cell.textLabel setText:[self getStatName:stats.allKeys[indexPath.row]]];
    } else {
        stat = ratings.allValues[indexPath.row];
        [cell.textLabel setText:[self getStatName:ratings.allKeys[indexPath.row]]];
    }
    [cell.detailTextLabel setText:stat];
    
    if (indexPath.section == 0) {
        UIColor *letterColor;  //['#d7191c','#fdae61','#ffffbf','#a6d96a','#1a9641']
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
    } else if ([key isEqualToString:@"completionPercentage"]) {
        return @"Completion Percentage";
    } else if ([key isEqualToString:@"passYards"]) {
        return @"Pass Yards";
    } else if ([key isEqualToString:@"yardsPerGame"]) {
        return @"Yards per Game";
    } else if ([key isEqualToString:@"yardsPerAttempt"]) {
        return @"Yards per Attempt";
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
        return @"Yards per Game";
    } else if ([key isEqualToString:@"yardsPerCarry"]) {
        return @"Yards per Carry";
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
        return @"Yards per Game";
    } else if ([key isEqualToString:@"yardsPerAttempt"]) {
        return @"Yards per Attempt";
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
