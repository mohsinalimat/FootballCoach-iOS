//
//  TeamHistoryViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamHistoryViewController.h"
#import "Team.h"

#import "PrestigeHistoryViewController.h"

@import Charts;

@interface TeamHistoryViewController ()
{
    Team *selectedTeam;
    NSDictionary *history;
}
@end

@implementation TeamHistoryViewController

-(instancetype)initWithTeam:(Team*)team {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        selectedTeam = team;
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
    history = [selectedTeam.teamHistoryDictionary copy];
    self.title = [NSString stringWithFormat:@"%@ Team History", selectedTeam.abbreviation];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];

    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    
    if (history.allKeys.count > 5) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"graph"] style:UIBarButtonItemStylePlain target:self action:@selector(viewPrestigeHistory)];

    }
}

-(void)viewPrestigeHistory {
    NSMutableArray *prestigeValues = [NSMutableArray array];
    NSMutableArray *colorValues = [NSMutableArray array];
    for (int i = 0; i < history.count; i++) {
        NSInteger year = [HBSharedUtils currentLeague].baseYear + i;
        float prestigeVal = 0.0;
        NSString *hist;
        if (selectedTeam.teamHistoryDictionary.count < i) {
            hist = [NSString stringWithFormat:@"%@ (0-0)",selectedTeam.abbreviation];
        } else {
            hist = selectedTeam.teamHistoryDictionary[[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + i)]];
        }
        NSArray *comps = [hist componentsSeparatedByString:@"\n"];
        NSString *prestigeString = nil;
        int i = 0;
        while (i < comps.count && (prestigeString == nil || ![prestigeString containsString:@"Prestige: "])) {
            prestigeString = comps[i];
            i++;
        }
        
        if (prestigeString == nil) {
            prestigeVal = 0.0;
        } else {
            NSString *cleanPrestige = [prestigeString stringByReplacingOccurrencesOfString:@"Prestige: " withString:@""];
            NSNumber *prestigeNum = [[self numberFormatter] numberFromString:cleanPrestige];
            prestigeVal = prestigeNum.floatValue;
        }
        
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
                    teamColor = [UIColor whiteColor];
                }
            }
        }
        [colorValues addObject:teamColor];
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:year y:prestigeVal];
        [prestigeValues addObject:entry];
    }
    
    LineChartDataSet *prestigeHistLine = [[LineChartDataSet alloc] initWithValues:prestigeValues label:@"Prestige over Time"];
    prestigeHistLine.circleColors = colorValues;
    prestigeHistLine.circleRadius /= 2;
    prestigeHistLine.drawCircleHoleEnabled = NO;
    prestigeHistLine.colors = @[[UIColor whiteColor]];
    prestigeHistLine.valueTextColor = [UIColor lightTextColor];
    
    PrestigeHistoryViewController *prestigeHistoryVC = [[PrestigeHistoryViewController alloc] initWithDataSets:@[prestigeHistLine]];
    prestigeHistoryVC.title = [NSString stringWithFormat:@"%@ Prestige History", selectedTeam.abbreviation];
    [self.navigationController pushViewController:prestigeHistoryVC animated:YES];
}

- (NSNumberFormatter *)numberFormatter {
    static dispatch_once_t onceToken;
    static NSNumberFormatter *formatter;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
    });
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return formatter;
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
        NSInteger lineCount = [self _lineCount:history[[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]]];
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
    if (history.count > 0) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
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
        if (history.count > 0) {
            return nil;
        } else {
            if ([selectedTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
                return @"No history recorded yet. Play some seasons to add to your resume!";
            } else {
                return @"No history recorded yet. Play some seasons to add to teams' resumes!";
            }
        }
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

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        if (history.count > 0) {
            return 36;
        } else {
            return 60;
        }
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
        NSInteger index = indexPath.row;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpperCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UpperCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            [cell.detailTextLabel setNumberOfLines:0];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        
        if (index == 0) {
            [cell.textLabel setText:@"Seasons"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%ld",(unsigned long)history.count]];
        } else if (index == 1) {
            [cell.textLabel setText:@"Win %"];
            if ((selectedTeam.totalLosses + selectedTeam.totalWins) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedTeam.totalWins) / (double)(selectedTeam.totalWins + selectedTeam.totalLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, selectedTeam.totalWins,selectedTeam.totalLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (index == 2) {
            [cell.textLabel setText:@"Conference Win %"];
            if ((selectedTeam.totalConfLosses + selectedTeam.totalConfWins) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedTeam.totalConfWins) / (double)(selectedTeam.totalConfWins + selectedTeam.totalConfLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent, selectedTeam.totalConfWins,selectedTeam.totalConfLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (index == 3) {
            [cell.textLabel setText:@"Bowl Win %"]; //XX% (W-L)
            if ((selectedTeam.totalBowlLosses + selectedTeam.totalBowls) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedTeam.totalBowls) / (double)(selectedTeam.totalBowls + selectedTeam.totalBowlLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,selectedTeam.totalBowls,selectedTeam.totalBowlLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (index == 4) {
            [cell.textLabel setText:@"Conference Championships"];
            if ((selectedTeam.totalCCLosses + selectedTeam.totalCCs) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedTeam.totalCCs) / (double)(selectedTeam.totalCCs + selectedTeam.totalCCLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,selectedTeam.totalCCs,selectedTeam.totalCCLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (index == 5) {
            [cell.textLabel setText:@"National Championships"];
            if ((selectedTeam.totalNCLosses + selectedTeam.totalNCs) > 0) {
                int winPercent = (int)ceil(100 * ((double)selectedTeam.totalNCs) / (double)(selectedTeam.totalNCs + selectedTeam.totalNCLosses));
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d%% (%d-%d)",winPercent,selectedTeam.totalNCs,selectedTeam.totalNCLosses]];
            } else {
                [cell.detailTextLabel setText:@"0% (0-0)"];
            }
        } else if (index == 6) {
            [cell.textLabel setText:@"Player of the Year Awards Won"];
            if (selectedTeam.heismans > 0) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedTeam.heismans]];
            } else {
                [cell.detailTextLabel setText:@"0"];
            }
        } else {
            [cell.textLabel setText:@"Rookie of the Year Awards Won"];
            if (selectedTeam.rotys > 0) {
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d", selectedTeam.rotys]];
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
        
        [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]];
        NSString *hist;
        if (selectedTeam.teamHistoryDictionary.count < indexPath.row) {
            hist = [NSString stringWithFormat:@"%@ (0-0)",selectedTeam.abbreviation];
        } else {
            hist = selectedTeam.teamHistoryDictionary[[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]];
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
