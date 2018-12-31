//
//  HeadCoachDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/29/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "HeadCoachDetailViewController.h"

#import "HeadCoach.h"
#import "HeadCoachHistoryViewController.h"

#import "HexColors.h"
#import "STPopup.h"

@interface HeadCoachDetailViewController ()
{
    HeadCoach *selectedCoach;
    NSDictionary *careerStats;
    NSDictionary *ratings;
    IBOutlet HBPlayerDetailView *playerDetailView;
}
@end

@implementation HeadCoachDetailViewController
-(instancetype)initWithCoach:(HeadCoach*)coach {
    self = [super init];
    if(self) {
        selectedCoach = coach;
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height * (3.0/4.0)));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Coach";
    [playerDetailView.nameLabel setText:selectedCoach.name];
    [playerDetailView.yrLabel setText:[NSString stringWithFormat:@"%@ - Ovr: %d",selectedCoach.team.abbreviation,selectedCoach.ratOvr]];
    [playerDetailView.posLabel setText:@"HC"];
    self.tableView.tableHeaderView = playerDetailView;
    careerStats = [selectedCoach detailedCareerStats];
    ratings = [selectedCoach detailedRatings];
    [playerDetailView.medImageView setHidden:YES];
    
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"changedStrategy" object:nil];
    [playerDetailView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
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
    if (section != 2) {
        return 36;
    } else {
        return 0;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Career Stats";
    } else if (section == 0) {
        return @"Information";
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 36;
    } else {
        return 18;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 13;
    } else if (section == 0) {
        return 11;
    } else {
        return 1;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return [NSString stringWithFormat:@"Over %ld career games", (long)selectedCoach.gamesCoached];
    } else {
        return nil;
    }
}

-(UIColor *)_colorForCoachStatus:(FCCoachStatus)status {
    switch (status) {
        case FCCoachStatusNormal:
            return [UIColor lightGrayColor];
            break;
        case FCCoachStatusOk:
            return [HBSharedUtils champColor];
            break;
        case FCCoachStatusUnsafe:
            return [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
            break;
        case FCCoachStatusSafe:
            return [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
            break;
        case FCCoachStatusHotSeat:
            return [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
            break;
        case FCCoachStatusSecure:
            return [HBSharedUtils successColor];
            break;
        default:
            return [UIColor lightGrayColor];
            break;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            // age
            [cell.textLabel setText:@"Age"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d years old", selectedCoach.age]];
        } else if (indexPath.row == 1) {
            // coach status
            [cell.textLabel setText:@"Status"];
            [cell.detailTextLabel setText:[selectedCoach getCoachStatusString]];
            [cell.detailTextLabel setTextColor:[self _colorForCoachStatus:[selectedCoach getCoachStatus]]];
        } else if (indexPath.row == 2) {
            // contract yera + length
            [cell.textLabel setText:@"Contract Details"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d years (%d left)", selectedCoach.contractLength,(selectedCoach.contractLength - selectedCoach.contractYear - 1)]];
        } else if (indexPath.row == 3) {
            // off
            [cell.textLabel setText:@"Offensive Philosophy"];
            [cell.detailTextLabel setText:ratings[@"offensivePlaybook"]];
        } else if (indexPath.row == 4) {
            // def
            [cell.textLabel setText:@"Defensive Philosophy"];
            [cell.detailTextLabel setText:ratings[@"defensivePlaybook"]];
        } else if (indexPath.row == 5) {
            // off
            [cell.textLabel setText:@"Offensive Ability"];
            [cell.detailTextLabel setText:ratings[@"offensiveAbility"]];
        } else if (indexPath.row == 6) {
            // def
            [cell.textLabel setText:@"Defensive Ability"];
            [cell.detailTextLabel setText:ratings[@"defensiveAbility"]];
        } else if (indexPath.row == 7) {
            // talent
            [cell.textLabel setText:@"Talent Progression"];
            [cell.detailTextLabel setText:ratings[@"talentProgression"]];
        } else if (indexPath.row == 8) {
            // discipline
            [cell.textLabel setText:@"Discipline"];
            [cell.detailTextLabel setText:ratings[@"discipline"]];
        } else if (indexPath.row == 9) {
            // potential
            [cell.textLabel setText:@"Potential"];
            [cell.detailTextLabel setText:ratings[@"potential"]];
        } else {
            // baseline prestige
            [cell.textLabel setText:@"Baseline Prestige"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedCoach.baselinePrestige]];
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
        
    } else if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        if (indexPath.row == 0) {
            // Career Record
            [cell.textLabel setText:@"Winning Percentage"];
            if ((selectedCoach.totalWins + selectedCoach.totalLosses) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedCoach.totalWins) / (double)(selectedCoach.totalWins + selectedCoach.totalLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, selectedCoach.totalWins,selectedCoach.totalLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 1) {
            // Career Conf Record
            [cell.textLabel setText:@"Conference Winning Percentage"];
            if ((selectedCoach.totalConfLosses + selectedCoach.totalConfWins) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedCoach.totalConfWins) / (double)(selectedCoach.totalConfWins + selectedCoach.totalConfLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, selectedCoach.totalConfWins,selectedCoach.totalConfLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 2) {
            // Career Rivalry Record
            [cell.textLabel setText:@"Rivalry Winning Percentage"];
            if ((selectedCoach.totalRivalryWins + selectedCoach.totalRivalryLosses) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedCoach.totalRivalryWins) / (double)(selectedCoach.totalRivalryWins + selectedCoach.totalRivalryLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, selectedCoach.totalRivalryWins,selectedCoach.totalRivalryLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 3) {
            // Career Bowl Record
            [cell.textLabel setText:@"Bowl Win Percentage"];
            if ((selectedCoach.totalBowls + selectedCoach.totalBowlLosses) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedCoach.totalBowls) / (double)(selectedCoach.totalBowls + selectedCoach.totalBowlLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, selectedCoach.totalBowls,selectedCoach.totalBowlLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 4) {
            // Career CC Record
            [cell.textLabel setText:@"Conference Championships"];
            if ((selectedCoach.totalCCs + selectedCoach.totalCCLosses) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedCoach.totalCCs) / (double)(selectedCoach.totalCCs + selectedCoach.totalCCLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, selectedCoach.totalCCs,selectedCoach.totalCCLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 5) {
            // Career NC Record
            [cell.textLabel setText:@"National Championships"];
            if ((selectedCoach.totalNCs + selectedCoach.totalNCLosses) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedCoach.totalNCs) / (double)(selectedCoach.totalNCs + selectedCoach.totalNCLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, selectedCoach.totalNCs,selectedCoach.totalNCLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 6) {
            // Cumulative Prestige
            [cell.textLabel setText:@"Cumulative Prestige"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedCoach.cumulativePrestige]];
        } else if (indexPath.row == 7) {
            // COTYs
            [cell.textLabel setText:@"National Coach of the Year Awards"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedCoach.careerCOTYs]];
        } else if (indexPath.row == 8) {
            // Conf COTYs
            [cell.textLabel setText:@"Conf Coach of the Year Awards"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedCoach.careerConfCOTYs]];
        } else if (indexPath.row == 9) {
            // POTYs
            [cell.textLabel setText:@"Players of the Year Coached"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedCoach.totalHeismans]];
        } else if (indexPath.row == 10) {
            // ROTYs
            [cell.textLabel setText:@"Rookies of the Year Coached"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedCoach.totalROTYs]];
        } else if (indexPath.row == 11) {
            // All Americans
            [cell.textLabel setText:@"All-League Players Coached"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedCoach.totalAllAmericans]];
        } else {
            // All Conference
            [cell.textLabel setText:@"All-Conference Players Coached"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedCoach.totalAllConferences]];
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        // show coach history view
        cell.textLabel.text = @"View Coaching History";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[HeadCoachHistoryViewController alloc] initWithCoach:selectedCoach] animated:YES];
        }
    }
}


@end
