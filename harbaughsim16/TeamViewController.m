//
//  TeamViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamViewController.h"
#import "Team.h"
#import "TeamRosterViewController.h"
#import "TeamHistoryViewController.h"
#import "TeamScheduleViewController.h"
#import "TeamRecordsViewController.h"

@interface HBTeamInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamPrestigeLabel;
@end

@implementation HBTeamInfoView
@end

@interface TeamViewController ()
{
    Team *selectedTeam;
    NSArray *stats;
    IBOutlet HBTeamInfoView *teamHeaderView;
}
@end

@implementation TeamViewController

-(instancetype)initWithTeam:(Team*)team {
    self = [super init];
    if (self) {
        selectedTeam = team;
    }
    return self;
}

-(void)changeTeamName {
    if (![HBSharedUtils getLeague].canRebrandTeam) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You can only rebrand teams during the offseason." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSString *oldName = selectedTeam.name;
        NSString *oldAbbrev = selectedTeam.abbreviation;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rebrand Team" message:@"Enter a new team name and abbreviation below." preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Team Name";
            textField.text = selectedTeam.name;
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Abbreviation";
            textField.text = selectedTeam.abbreviation;
        }];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to rebrand this team?" message:@"You can rebrand again at any time during the offseason." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //save
                UITextField *name = alert.textFields[0];
                UITextField *abbrev = alert.textFields[1];
                if ((![name.text isEqualToString:selectedTeam.name] || ![abbrev.text isEqualToString:selectedTeam.abbreviation]) && (name.text.length > 0 && abbrev.text.length > 0) && (![name.text isEqualToString:@""] && ![abbrev.text isEqualToString:@""])) {
                    [selectedTeam setName:name.text];
                    [selectedTeam setAbbreviation:abbrev.text];
                    Team *rival = [[HBSharedUtils getLeague] findTeam:selectedTeam.rivalTeam];
                    [rival setRivalTeam:abbrev.text];
                    
                    NSMutableArray *tempLeagueYear = [NSMutableArray array];
                    for (int k = 0; k < [HBSharedUtils getLeague].leagueHistory.count; k++) {
                        NSArray *leagueYear = [HBSharedUtils getLeague].leagueHistory[k];
                        tempLeagueYear = [NSMutableArray arrayWithArray:leagueYear];
                        for (int i =0; i < leagueYear.count; i++) {
                            NSString *teamString = leagueYear[i];
                            if ([teamString containsString:oldName]) {
                                teamString = [teamString stringByReplacingOccurrencesOfString:oldName withString:name.text];
                                NSLog(@"FOUND NAME MATCH IN LEAGUE HISTORY, REPLACING");
                                [tempLeagueYear replaceObjectAtIndex:i withObject:teamString];
                            }
                            
                            if ([teamString containsString:oldAbbrev]) {
                                teamString = [teamString stringByReplacingOccurrencesOfString:oldAbbrev withString:abbrev.text];
                                [tempLeagueYear replaceObjectAtIndex:i withObject:teamString];
                                NSLog(@"FOUND ABBREV MATCH IN LEAGUE HISTORY, REPLACING");
                            }
                        }
                        
                        [[HBSharedUtils getLeague].leagueHistory replaceObjectAtIndex:k withObject:[tempLeagueYear copy]];
                        [tempLeagueYear removeAllObjects];
                    }
                    
                    for (int j = 0; j < selectedTeam.teamHistory.count; j++) {
                        NSString *yearString = selectedTeam.teamHistory[j];
                        if ([yearString containsString:oldAbbrev]) {
                            yearString = [yearString stringByReplacingOccurrencesOfString:oldAbbrev withString:abbrev.text];
                            NSLog(@"FOUND ABBREV MATCH IN TEAM HISTORY, REPLACING");
                            [selectedTeam.teamHistory replaceObjectAtIndex:j withObject:yearString];
                        }
                    }
                    
                    for (int j = 0; j < [HBSharedUtils getLeague].heismanHistory.count; j++) {
                        NSString *heisString = [HBSharedUtils getLeague].heismanHistory[j];
                        if ([heisString containsString:[NSString stringWithFormat:@", %@ (", oldAbbrev]]) {
                            heisString = [heisString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@", %@ (", oldAbbrev] withString:[NSString stringWithFormat:@", %@ (", abbrev.text]];
                            NSLog(@"FOUND ABBREV MATCH IN HEISMAN HISTORY, REPLACING");
                            [[HBSharedUtils getLeague].heismanHistory replaceObjectAtIndex:j withObject:heisString];
                        }
                    }
                    
                    [[HBSharedUtils getLeague] save];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTeams" object:nil];
                    [self.tableView reloadData];
                    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils styleColor] message:[NSString stringWithFormat:@"Successfully rebranded this team to %@ (%@)!", name.text, abbrev.text] onViewController:self];
                } else {
                    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:@"Unable to rebrand this team.\nInvalid inputs provided." onViewController:self];
                }
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Team";
    stats = [selectedTeam getTeamStatsArray];
    NSString *rank = @"";
    if (selectedTeam.rankTeamPollScore < 26 && selectedTeam.rankTeamPollScore > 0) {
        rank = [NSString stringWithFormat:@"#%d ",selectedTeam.rankTeamPollScore];
    }
    [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, selectedTeam.name]];

    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)[HBSharedUtils getLeague].leagueHistory.count + 2016,(long)selectedTeam.wins,(long)selectedTeam.losses]];
    [teamHeaderView.teamPrestigeLabel setText:[NSString stringWithFormat:@"Prestige: %d",selectedTeam.teamPrestige]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setTableHeaderView:teamHeaderView];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reloadTeams" object:nil];
    
    if ([HBSharedUtils getLeague].canRebrandTeam) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(changeTeamName)];
    }
}

-(void)reloadAll {
    NSString *rank = @"";
    if (selectedTeam.rankTeamPollScore < 26 && selectedTeam.rankTeamPollScore > 0) {
        rank = [NSString stringWithFormat:@"#%d ",selectedTeam.rankTeamPollScore];
    }
    [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, selectedTeam.name]];
    
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)[HBSharedUtils getLeague].leagueHistory.count + 2016,(long)selectedTeam.wins,(long)selectedTeam.losses]];
    [teamHeaderView.teamPrestigeLabel setText:[NSString stringWithFormat:@"Prestige: %d",selectedTeam.teamPrestige]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setTableHeaderView:teamHeaderView];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setTableHeaderView:teamHeaderView];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Statistics";
    } else {
        return nil;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else {
        return stats.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"StatCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"StatCell"];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSArray *cellStat = stats[indexPath.row];
        
        NSString *stat = @"";
        if ([HBSharedUtils getLeague].currentWeek > 0) {
            stat = [NSString stringWithFormat:@"%@ (%@)", cellStat[0], cellStat[2]];
        } else {
            stat = cellStat[0];
        }
        
        [cell.textLabel setText:cellStat[1]];
        [cell.detailTextLabel setText:stat];
        return cell;
    } else {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Roster"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Schedule"];
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"Team History"];
        } else {
            [cell.textLabel setText:@"Team Records"];
        }
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[TeamRosterViewController alloc] initWithTeam:selectedTeam] animated:YES];
        } else if (indexPath.row == 1) {
            [self.navigationController pushViewController:[[TeamScheduleViewController alloc] initWithTeam:selectedTeam] animated:YES];
        } else if (indexPath.row == 2) {
            [self.navigationController pushViewController:[[TeamHistoryViewController alloc] initWithTeam:selectedTeam] animated:YES];
        } else {
            [self.navigationController pushViewController:[[TeamRecordsViewController alloc] initWithTeam:selectedTeam] animated:YES];
        }
    }
}


@end
