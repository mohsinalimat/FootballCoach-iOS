//
//  PlayerCBViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/20/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "PlayerCBDetailViewController.h"

#import "Player.h"

#import "PlayerCB.h"

#import "HexColors.h"
#import "STPopup.h"


@interface PlayerCBDetailViewController ()

@end

@implementation PlayerCBDetailViewController

-(instancetype)initWithPlayer:(PlayerCB*)player {
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
            //cov
            [cell.detailTextLabel setText:ratings[@"cbCoverage"]];
            [cell.textLabel setText:@"Coverage Ability"];
        } else if (indexPath.row == 9) {
            //spd
            [cell.detailTextLabel setText:ratings[@"cbSpeed"]];
            [cell.textLabel setText:@"Speed"];
        } else {
            //tkl
            [cell.detailTextLabel setText:ratings[@"cbTackling"]];
            [cell.textLabel setText:@"Tackling Ability"];
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
                [cell.detailTextLabel setText:careerStats[@"tackles"]];
                [cell.textLabel setText:@"Tackles"];
            } else if (indexPath.row == 5) {
                [cell.detailTextLabel setText:careerStats[@"passesDefended"]];
                [cell.textLabel setText:@"Passes Defended"];
            } else if (indexPath.row == 6) {
                [cell.detailTextLabel setText:careerStats[@"interceptions"]];
                [cell.textLabel setText:@"Interceptions"];
            } else if (indexPath.row == 7) {
                [cell.detailTextLabel setText:careerStats[@"sacks"]];
                [cell.textLabel setText:@"Sacks"];
            } else {
                [cell.detailTextLabel setText:careerStats[@"forcedFumbles"]];
                [cell.textLabel setText:@"Forced Fumbles"];
            }
        } else {
            if (indexPath.row == 0) {
                [cell.detailTextLabel setText:stats[@"tackles"]];
                [cell.textLabel setText:@"Tackles"];
            } else if (indexPath.row == 1) {
                [cell.detailTextLabel setText:stats[@"passesDefended"]];
                [cell.textLabel setText:@"Passes Defended"];
            } else if (indexPath.row == 2) {
                [cell.detailTextLabel setText:stats[@"interceptions"]];
                [cell.textLabel setText:@"Interceptions"];
            } else if (indexPath.row == 3) {
                [cell.detailTextLabel setText:stats[@"sacks"]];
                [cell.textLabel setText:@"Sacks"];
            } else {
                [cell.detailTextLabel setText:stats[@"forcedFumbles"]];
                [cell.textLabel setText:@"Forced Fumbles"];
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
            [cell.detailTextLabel setText:careerStats[@"tackles"]];
            [cell.textLabel setText:@"Tackles"];
        } else if (indexPath.row == 5) {
            [cell.detailTextLabel setText:careerStats[@"passesDefended"]];
            [cell.textLabel setText:@"Passes Defended"];
        } else if (indexPath.row == 6) {
            [cell.detailTextLabel setText:careerStats[@"interceptions"]];
            [cell.textLabel setText:@"Interceptions"];
        } else if (indexPath.row == 7) {
            [cell.detailTextLabel setText:careerStats[@"sacks"]];
            [cell.textLabel setText:@"Sacks"];
        } else {
            [cell.detailTextLabel setText:careerStats[@"forcedFumbles"]];
            [cell.textLabel setText:@"Forced Fumbles"];
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
