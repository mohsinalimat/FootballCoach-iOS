//
//  PlayerQBDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/20/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "PlayerQBDetailViewController.h"

#import "Player.h"

#import "PlayerQB.h"

#import "HexColors.h"
#import "STPopup.h"

@implementation PlayerQBDetailViewController
-(instancetype)initWithPlayer:(PlayerQB*)player {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self) {
        selectedPlayer = player;
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height * (3.0/4.0)));
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ((selectedPlayer.year > 4 && selectedPlayer.isGradTransfer == NO) || selectedPlayer.draftPosition != nil) {
        return 2;
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
        [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.detailTextLabel setText:selectedPlayer.personalDetails[@"home_state"]];
            [cell.textLabel setText:@"Home State"];
        } else if (indexPath.row == 1) {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d-star", MIN(5, selectedPlayer.stars)]];
            [cell.textLabel setText:@"Recruit Rating"];
        } else if (indexPath.row == 2) {
            [cell.detailTextLabel setText:[selectedPlayer getPlayerArchetype]];
            [cell.textLabel setText:@"Player Archetype"];
        } else if (indexPath.row == 3) {
            [cell.detailTextLabel setText:selectedPlayer.personalDetails[@"height"]];
            [cell.textLabel setText:@"Height"];
        } else if (indexPath.row == 4) {
            [cell.detailTextLabel setText:selectedPlayer.personalDetails[@"weight"]];
            [cell.textLabel setText:@"Weight"];
        } else if (indexPath.row == 5) {
            [cell.detailTextLabel setText:ratings[@"potential"]];
            [cell.textLabel setText:@"Potential"];
        } else if (indexPath.row == 6) {
            [cell.detailTextLabel setText:ratings[@"footballIQ"]];
            [cell.textLabel setText:@"Football IQ"];
        } else if (indexPath.row == 7) {
            [cell.detailTextLabel setText:ratings[@"durability"]];
            [cell.textLabel setText:@"Durability"];
        } else if (indexPath.row == 8) {
            //pow
            [cell.detailTextLabel setText:ratings[@"passPower"]];
            [cell.textLabel setText:@"Throwing Power"];
        } else if (indexPath.row == 9) {
            //acc
            [cell.detailTextLabel setText:ratings[@"passAccuracy"]];
            [cell.textLabel setText:@"Throwing Accuracy"];
        } else if (indexPath.row == 10) {
            //eva
            [cell.detailTextLabel setText:ratings[@"passEvasion"]];
            [cell.textLabel setText:@"Evasion"];
        } else {
            //eva
            [cell.detailTextLabel setText:ratings[@"rushSpeed"]];
            [cell.textLabel setText:@"Speed"];
        }
    } else if (indexPath.section == 1) {
        if ((selectedPlayer.year > 4 && selectedPlayer.isGradTransfer == NO) || selectedPlayer.draftPosition != nil) {
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:careerStats[@"ROTYs"]];
                [cell.textLabel setText:@"Rookie of the Year Awards"];
            } else if (indexPath.row == 1) {
                [cell.detailTextLabel setText:careerStats[@"heismans"]];
                [cell.textLabel setText:@"Player of the Year Awards"];
            } else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:careerStats[@"allAmericans"]];
                [cell.textLabel setText:@"All-League Nominations"];
            } else if (indexPath.row == 3) {
                [cell.detailTextLabel setText:careerStats[@"allConferences"]];
                [cell.textLabel setText:@"All-Conference Nominations"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:careerStats[@"completions"]];
                [cell.textLabel setText:@"Completions"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:careerStats[@"attempts"]];
                [cell.textLabel setText:@"Pass Attempts"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:careerStats[@"passYards"]];
                [cell.textLabel setText:@"Pass Yards"];
            } else if (indexPath.row == 7) {
                [cell.detailTextLabel setText:careerStats[@"completionPercentage"]];
                [cell.textLabel setText:@"Completion Percentage"];
            } else if (indexPath.row == 8) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerAttempt"]];
                [cell.textLabel setText:@"Yards Per Attempt"];
            } else if (indexPath.row == 9) {
                [cell.detailTextLabel setText:careerStats[@"passYardsPerGame"]];
                [cell.textLabel setText:@"Pass Yards Per Game"];
            } else if (indexPath.row == 10) {
                [cell.detailTextLabel setText:careerStats[@"passTouchdowns"]];
                [cell.textLabel setText:@"Pass TDs"];
            } else if (indexPath.row == 11) {
                [cell.detailTextLabel setText:careerStats[@"interceptions"]];
                [cell.textLabel setText:@"Interceptions"];
            } else if (indexPath.row == 12) {
                [cell.detailTextLabel setText:careerStats[@"carries"]];
                [cell.textLabel setText:@"Carries"];
            } else if (indexPath.row == 13) {
                [cell.detailTextLabel setText:careerStats[@"rushYards"]];
                [cell.textLabel setText:@"Rush Yards"];
            } else if (indexPath.row == 14) {
                [cell.detailTextLabel setText:careerStats[@"yardsPerCarry"]];
                [cell.textLabel setText:@"Rush Yards Per Carry"];
            } else if (indexPath.row == 15) {
                [cell.detailTextLabel setText:careerStats[@"rushYardsPerGame"]];
                [cell.textLabel setText:@"Rush Yards Per Game"];
            } else if (indexPath.row == 16) {
                [cell.detailTextLabel setText:careerStats[@"rushTouchdowns"]];
                [cell.textLabel setText:@"Rush TDs"];
            } else {
                [cell.detailTextLabel setText:careerStats[@"fumbles"]];
                [cell.textLabel setText:@"Fumbles"];
            }
        } else {
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:stats[@"completions"]];
                [cell.textLabel setText:@"Completions"];
            } else if (indexPath.row == 1) {
                [cell.detailTextLabel setText:stats[@"attempts"]];
                [cell.textLabel setText:@"Pass Attempts"];
            } else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:stats[@"passYards"]];
                [cell.textLabel setText:@"Pass Yards"];
            } else if (indexPath.row == 3) {
                [cell.detailTextLabel setText:stats[@"completionPercentage"]];
                [cell.textLabel setText:@"Completion Percentage"];
            } else if (indexPath.row == 4) {
                [cell.detailTextLabel setText:stats[@"yardsPerAttempt"]];
                [cell.textLabel setText:@"Pass Yards Per Attempt"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:stats[@"passYardsPerGame"]];
                [cell.textLabel setText:@"Pass Yards Per Game"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:stats[@"passTouchdowns"]];
                [cell.textLabel setText:@"Pass TDs"];
            } else if (indexPath.row == 7) {
                [cell.detailTextLabel setText:stats[@"interceptions"]];
                [cell.textLabel setText:@"Interceptions"];
            } else if (indexPath.row == 8) {
                [cell.detailTextLabel setText:stats[@"carries"]];
                [cell.textLabel setText:@"Carries"];
            } else if (indexPath.row == 9) {
                [cell.detailTextLabel setText:stats[@"rushYards"]];
                [cell.textLabel setText:@"Rush Yards"];
            } else if (indexPath.row == 10) {
                [cell.detailTextLabel setText:stats[@"yardsPerCarry"]];
                [cell.textLabel setText:@"Rush Yards Per Carry"];
            } else if (indexPath.row == 11) {
                [cell.detailTextLabel setText:stats[@"rushYardsPerGame"]];
                [cell.textLabel setText:@"Rush Yards Per Game"];
            } else if (indexPath.row == 12) {
                [cell.detailTextLabel setText:stats[@"rushTouchdowns"]];
                [cell.textLabel setText:@"Rush TDs"];
            } else {
                [cell.detailTextLabel setText:stats[@"fumbles"]];
                [cell.textLabel setText:@"Fumbles"];
            }
        }
    } else {
        if (indexPath.row == 0) {
            [cell.detailTextLabel setText:careerStats[@"ROTYs"]];
            [cell.textLabel setText:@"Rookie of the Year Awards"];
        } else if (indexPath.row == 1) {
            [cell.detailTextLabel setText:careerStats[@"heismans"]];
            [cell.textLabel setText:@"Player of the Year Awards"];
        } else if (indexPath.row == 2) {
            [cell.detailTextLabel setText:careerStats[@"allAmericans"]];
            [cell.textLabel setText:@"All-League Nominations"];
        } else if (indexPath.row == 3) {
            [cell.detailTextLabel setText:careerStats[@"allConferences"]];
            [cell.textLabel setText:@"All-Conference Nominations"];
        } else if (indexPath.row == 4) {
            [cell.detailTextLabel setText:careerStats[@"completions"]];
            [cell.textLabel setText:@"Completions"];
        } else if (indexPath.row == 5) {
            [cell.detailTextLabel setText:careerStats[@"attempts"]];
            [cell.textLabel setText:@"Pass Attempts"];
        } else if (indexPath.row == 6) {
            [cell.detailTextLabel setText:careerStats[@"passYards"]];
            [cell.textLabel setText:@"Pass Yards"];
        } else if (indexPath.row == 7) {
            [cell.detailTextLabel setText:careerStats[@"completionPercentage"]];
            [cell.textLabel setText:@"Completion Percentage"];
        } else if (indexPath.row == 8) {
            [cell.detailTextLabel setText:careerStats[@"yardsPerAttempt"]];
            [cell.textLabel setText:@"Yards Per Attempt"];
        } else if (indexPath.row == 9) {
            [cell.detailTextLabel setText:careerStats[@"passYardsPerGame"]];
            [cell.textLabel setText:@"Yards Per Game"];
        } else if (indexPath.row == 10) {
            [cell.detailTextLabel setText:careerStats[@"passTouchdowns"]];
            [cell.textLabel setText:@"Touchdowns"];
        } else if (indexPath.row == 11) {
            [cell.detailTextLabel setText:careerStats[@"interceptions"]];
            [cell.textLabel setText:@"Interceptions"];
        } else if (indexPath.row == 12) {
            [cell.detailTextLabel setText:careerStats[@"carries"]];
            [cell.textLabel setText:@"Carries"];
        } else if (indexPath.row == 13) {
            [cell.detailTextLabel setText:careerStats[@"rushYards"]];
            [cell.textLabel setText:@"Rush Yards"];
        } else if (indexPath.row == 14) {
            [cell.detailTextLabel setText:careerStats[@"yardsPerCarry"]];
            [cell.textLabel setText:@"Rush Yards Per Carry"];
        } else if (indexPath.row == 15) {
            [cell.detailTextLabel setText:careerStats[@"rushYardsPerGame"]];
            [cell.textLabel setText:@"Rush Yards Per Game"];
        } else if (indexPath.row == 16) {
            [cell.detailTextLabel setText:careerStats[@"rushTouchdowns"]];
            [cell.textLabel setText:@"Rush TDs"];
        } else {
            [cell.detailTextLabel setText:careerStats[@"fumbles"]];
            [cell.textLabel setText:@"Fumbles"];
        }
    }
    
    if (indexPath.section == 0 && indexPath.row > 4) {
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
    } else {
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    return cell;
}
@end
