//
//  TeamHistoryViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamHistoryViewController.h"
#import "Team.h"

@interface HBTeamCompiledHistoryView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamSeasonsLabel;
@end

@implementation HBTeamCompiledHistoryView
@end

@interface TeamHistoryViewController ()
{
    Team *userTeam;
    NSDictionary *history;
    IBOutlet HBTeamCompiledHistoryView *teamHeaderView;
}
@end

@implementation TeamHistoryViewController

-(instancetype)initWithTeam:(Team*)team {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        userTeam = team;
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

-(NSInteger)_lineCount:(NSString*)string {
    NSInteger numberOfLines, index, stringLength = [string length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
        index = NSMaxRange([string lineRangeForRange:NSMakeRange(index, 0)]);
    if([string hasSuffix:@"\n"] || [string hasSuffix:@"\r"])
        numberOfLines += 1;
    if([string hasPrefix:@"\n"] || [string hasPrefix:@"\r"])
        numberOfLines += 1;
    return numberOfLines;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    history = [userTeam.teamHistoryDictionary copy];
    self.title = [NSString stringWithFormat:@"%@ Team History", userTeam.abbreviation];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [teamHeaderView.teamNameLabel setText:userTeam.name];
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%d-%d",userTeam.totalWins, userTeam.totalLosses]];
    if ([userTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
        if (history.count> 1 || history.count == 0) {
            [teamHeaderView.teamSeasonsLabel setText:[NSString stringWithFormat:@"Coaching for %ld seasons",(unsigned long)history.count]];
        } else {
            [teamHeaderView.teamSeasonsLabel setText:@"Coaching for 1 season"];
        }
    } else {
        [teamHeaderView.teamSeasonsLabel setText:@""];
    }
    
    [self.tableView setTableHeaderView:teamHeaderView];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    } else {
        NSInteger lineCount = [self _lineCount:history[[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)]]];
        if (lineCount > 2) {
            return 100 + (10 * (lineCount - 2));
        } else if (lineCount == 2) {
            return 90;
        } else {
            return 80;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    } else {
        return history.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Past Seasons";
    } else {
        return nil;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return @"Color Key:\nGreen - Conference Champion\nOrange - Bowl Winner\nGold - National Champion";
    } else {
        return nil;
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 36;
    } else {
        return 90;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 18;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpperCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UpperCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            [cell.detailTextLabel setNumberOfLines:0];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Seasons"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(unsigned long)history.count]];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Winning Percentage"];
            if ((userTeam.totalLosses + userTeam.totalWins) > 0) {
                int winPercent = (int)ceil(100 * ((double)userTeam.totalWins) / (double)(userTeam.totalWins + userTeam.totalLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, userTeam.totalWins,userTeam.totalLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"Conference Win Percentage"];
            if ((userTeam.totalConfLosses + userTeam.totalConfWins) > 0) {
                int winPercent = (int)ceil(100 * ((double)userTeam.totalConfWins) / (double)(userTeam.totalConfWins + userTeam.totalConfLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, userTeam.totalConfWins,userTeam.totalConfLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 3) {
            [cell.textLabel setText:@"Bowl Win Percentage"]; //XX% (W-L)
            if ((userTeam.totalBowlLosses + userTeam.totalBowls) > 0) {
                int winPercent = (int)ceil(100 * ((double)userTeam.totalBowls) / (double)(userTeam.totalBowls + userTeam.totalBowlLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,userTeam.totalBowls,userTeam.totalBowlLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 4) {
            [cell.textLabel setText:@"Conference Championships"];
            if ((userTeam.totalCCLosses + userTeam.totalCCs) > 0) {
                int winPercent = (int)ceil(100 * ((double)userTeam.totalCCs) / (double)(userTeam.totalCCs + userTeam.totalCCLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,userTeam.totalCCs,userTeam.totalCCLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (indexPath.row == 5) {
            [cell.textLabel setText:@"National Championships"];
            if ((userTeam.totalNCLosses + userTeam.totalNCs) > 0) {
                int winPercent = (int)ceil(100 * ((double)userTeam.totalNCs) / (double)(userTeam.totalNCs + userTeam.totalNCLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,userTeam.totalNCs,userTeam.totalNCLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else {
            [cell.textLabel setText:@"Player of the Year Awards Won"];
            if (userTeam.heismans > 0) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", userTeam.heismans]];
            } else {
                [cell.detailTextLabel setText:@"0"];
            }
        }
        return cell;
    } else {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LowerCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LowerCell"];
            [cell setBackgroundColor:[UIColor whiteColor]];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.detailTextLabel setNumberOfLines:7];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)]];
        NSString *hist;
        if (userTeam.teamHistoryDictionary.count < indexPath.row) {
            hist = [NSString stringWithFormat:@"%@ (0-0)",userTeam.abbreviation];
        } else {
            hist = userTeam.teamHistoryDictionary[[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)]];
        }
        NSArray *comps = [hist componentsSeparatedByString:@"\n"];
        
        UIColor *teamColor;
        if ([hist containsString:@"NCG - W"] || [hist containsString:@"NCW"]) {
            teamColor = [HBSharedUtils champColor];
        } else {
            if ([hist containsString:@"Bowl - W"] || [hist containsString:@"Semis,1v4 - W"] || [hist containsString:@"Semis,2v3 - W"] || [hist containsString:@"BW"] || [hist containsString:@"SFW"]) {
                teamColor = [UIColor orangeColor];
            } else {
                if ([hist containsString:@"CCG - W"] || [hist containsString:@"CC"]) {
                    teamColor = [HBSharedUtils successColor];
                } else {
                    teamColor = [UIColor lightGrayColor];
                }
            }
        }
        NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:hist attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular]}];
        [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular] range:[hist rangeOfString:comps[0]]];
        [attText addAttribute:NSForegroundColorAttributeName value:teamColor range:[hist rangeOfString:comps[0]]];
        [cell.detailTextLabel setAttributedText:attText];
        [cell.detailTextLabel sizeToFit];
        return cell;
    }
}


@end
