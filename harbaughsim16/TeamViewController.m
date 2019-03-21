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
#import "RingOfHonorViewController.h"
#import "HeadCoachDetailViewController.h"
#import "TeamStreaksViewController.h"

#import "STPopup.h"

@interface HBTeamInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *teamRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamPrestigeLabel;
@end

@implementation HBTeamInfoView
@end

@interface TeamViewController () <UIViewControllerPreviewingDelegate>
{
    Team *selectedTeam;
    NSArray *stats;
    IBOutlet HBTeamInfoView *teamHeaderView;
}
@end

@implementation TeamViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIViewController *peekVC;
        if (indexPath.section == 0) {
            if (([HBSharedUtils currentLeague].isCareerMode && (!selectedTeam.isUserControlled && ![selectedTeam isEqual:[HBSharedUtils currentLeague].userTeam])) || ![HBSharedUtils currentLeague].isCareerMode) {
                if (indexPath.row == 0) {
                    peekVC = [[HeadCoachDetailViewController alloc] initWithCoach:[selectedTeam getCurrentHC]];
                } else if (indexPath.row == 1) {
                    peekVC = [[TeamRosterViewController alloc] initWithTeam:selectedTeam];
                } else if (indexPath.row == 2) {
                    peekVC = [[TeamScheduleViewController alloc] initWithTeam:selectedTeam];
                } else if (indexPath.row == 3) {
                    peekVC = [[TeamHistoryViewController alloc] initWithTeam:selectedTeam];
                } else if (indexPath.row == 4) {
                    peekVC = [[RingOfHonorViewController alloc] initWithTeam:selectedTeam];
                } else {
                    peekVC = [[TeamRecordsViewController alloc] initWithTeam:selectedTeam];
                }
            } else {
                if (indexPath.row == 0) {
                    peekVC = [[TeamRosterViewController alloc] initWithTeam:selectedTeam];
                } else if (indexPath.row == 1) {
                    peekVC = [[TeamScheduleViewController alloc] initWithTeam:selectedTeam];
                } else if (indexPath.row == 2) {
                    peekVC = [[TeamHistoryViewController alloc] initWithTeam:selectedTeam];
                } else if (indexPath.row == 3) {
                    peekVC = [[RingOfHonorViewController alloc] initWithTeam:selectedTeam];
                } else {
                    peekVC = [[TeamRecordsViewController alloc] initWithTeam:selectedTeam];
                }
            }
        }
        peekVC.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
        previewingContext.sourceRect = cell.frame;
        return peekVC;
    } else {
        return nil;
    }
}

-(instancetype)initWithTeam:(Team*)team {
    self = [super init];
    if (self) {
        selectedTeam = team;
        
        if ([HBSharedUtils currentLeague].canRebrandTeam) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(changeTeamName)];
        }
    }
    return self;
}

-(void)finalizeCoachingCarousel {
    NSLog(@"Carousel team: %@",selectedTeam.abbreviation);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"signingWithTeam" object:selectedTeam];
}

-(void)changeTeamName {
    if (![HBSharedUtils currentLeague].canRebrandTeam) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You can only rebrand teams during the offseason." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rebrand Team" message:@"Enter a new team name and abbreviation below." preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Team Name";
            textField.text = self->selectedTeam.name;
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Abbreviation";
            textField.text = self->selectedTeam.abbreviation;
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"State";
            textField.text = self->selectedTeam.state;
        }];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to rebrand this team?" message:@"You can rebrand again at any time during the offseason." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self applyTeamInfoChanges:alert.textFields selectedTeam:self->selectedTeam];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)applyTeamInfoChanges:(NSArray<UITextField *> *)textFields selectedTeam:(Team *)selTeam {
    NSString *oldName = selTeam.name;
    NSString *oldAbbrev = selTeam.abbreviation;
    
    NSString *name = [textFields[0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *abbrev = [textFields[1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *state = [textFields[2].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![name isEqualToString:selTeam.name] && [selTeam.league isTeamNameValid:name allowUserTeam:YES allowOverwrite:NO]) {
        [selectedTeam setName:name];
        [[HBSharedUtils currentLeague] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
        [self.tableView reloadData];
    } else if (![name isEqualToString:selTeam.name] && ![selTeam.league isTeamNameValid:name allowUserTeam:YES allowOverwrite:NO]) {
        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] title:@"Error" message:@"Unable to update this team's information - invalid team name provided" onViewController:self];
        return;
    }
    
    if (![abbrev isEqualToString:selTeam.abbreviation] && [selTeam.league isTeamAbbrValid:abbrev allowUserTeam:YES allowOverwrite:NO]) {
        [selectedTeam setAbbreviation:abbrev];
        [[HBSharedUtils currentLeague] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
        [self.tableView reloadData];
        
        Team *rival = [[HBSharedUtils currentLeague] findTeam:selectedTeam.rivalTeam];
        [rival setRivalTeam:abbrev];
        
        NSMutableArray *tempLeagueYear;
        for (int k = 0; k < [HBSharedUtils currentLeague].leagueHistoryDictionary.count; k++) {
            NSArray *leagueYear = [HBSharedUtils currentLeague].leagueHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + k)]];
            tempLeagueYear = [NSMutableArray arrayWithArray:leagueYear];
            for (int i =0; i < leagueYear.count; i++) {
                NSString *teamString = leagueYear[i];
                if ([teamString containsString:oldName]) {
                    teamString = [teamString stringByReplacingOccurrencesOfString:oldName withString:name];
                    [tempLeagueYear replaceObjectAtIndex:i withObject:teamString];
                }
                
                if ([teamString containsString:oldAbbrev]) {
                    teamString = [teamString stringByReplacingOccurrencesOfString:oldAbbrev withString:abbrev];
                    [tempLeagueYear replaceObjectAtIndex:i withObject:teamString];
                }
            }
            
            [[HBSharedUtils currentLeague].leagueHistoryDictionary setObject:[tempLeagueYear copy] forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + k)]];
            [tempLeagueYear removeAllObjects];
        }
        
        for (int j = 0; j < selectedTeam.teamHistoryDictionary.count; j++) {
            NSString *yearString = selectedTeam.teamHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            if ([yearString containsString:oldAbbrev]) {
                yearString = [yearString stringByReplacingOccurrencesOfString:oldAbbrev withString:abbrev];
                
                [selectedTeam.teamHistoryDictionary setObject:yearString forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            }
        }
        
        for (int j = 0; j < [HBSharedUtils currentLeague].heismanHistoryDictionary.count; j++) {
            NSString *heisString = [HBSharedUtils currentLeague].heismanHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            if ([heisString containsString:[NSString stringWithFormat:@", %@ (", oldAbbrev]]) {
                heisString = [heisString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@", %@ (", oldAbbrev] withString:[NSString stringWithFormat:@", %@ (", abbrev]];
                
                [[HBSharedUtils currentLeague].heismanHistoryDictionary setObject:heisString forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            }
        }
        
        for (int j = 0; j < [HBSharedUtils currentLeague].rotyHistoryDictionary.count; j++) {
            NSString *heisString = [HBSharedUtils currentLeague].rotyHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            if ([heisString containsString:[NSString stringWithFormat:@", %@ (", oldAbbrev]]) {
                heisString = [heisString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@", %@ (", oldAbbrev] withString:[NSString stringWithFormat:@", %@ (", abbrev]];
                
                [[HBSharedUtils currentLeague].rotyHistoryDictionary setObject:heisString forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            }
        }
    } else if (![abbrev isEqualToString:selTeam.abbreviation] && ![selTeam.league isTeamAbbrValid:abbrev allowUserTeam:YES allowOverwrite:NO]) {
        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] title:@"Error" message:@"Unable to update this team's information - invalid team abbreviation provided" onViewController:self];
        return;
    }
    
    if (![state isEqualToString:selTeam.state] && [selTeam.league isStateValid:state]) {
        [selectedTeam setState:state];
        [[HBSharedUtils currentLeague] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
        [self.tableView reloadData];
    } else if (![selTeam.league isStateValid:state]) {
        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] title:@"Error" message:@"Unable to update this team's information - invalid state provided" onViewController:self];
        return;
    }
    
    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils styleColor] title:@"Rebrand successful!" message:@"Successfully updated this team information!" onViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Team";

    stats = [selectedTeam getTeamStatsArray];
    NSString *rank = @"";
    if ([HBSharedUtils currentLeague].currentWeek > 0 && selectedTeam.rankTeamPollScore < 26 && selectedTeam.rankTeamPollScore > 0) {
        rank = [NSString stringWithFormat:@"#%d ",selectedTeam.rankTeamPollScore];
    }
    [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, selectedTeam.name]];

    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)[HBSharedUtils currentLeague].leagueHistoryDictionary.count + [HBSharedUtils currentLeague].baseYear,(long)selectedTeam.wins,(long)selectedTeam.losses]];
    [teamHeaderView.teamPrestigeLabel setText:[NSString stringWithFormat:@"Prestige: %d",selectedTeam.teamPrestige]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setTableHeaderView:teamHeaderView];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reincarnateCoach" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reloadTeams" object:nil];

    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

-(void)reloadAll {
    NSString *rank = @"";
    if ([HBSharedUtils currentLeague].currentWeek > 0 && selectedTeam.rankTeamPollScore < 26 && selectedTeam.rankTeamPollScore > 0) {
        rank = [NSString stringWithFormat:@"#%d ",selectedTeam.rankTeamPollScore];
    }
    [teamHeaderView.teamRankLabel setText:[NSString stringWithFormat:@"%@%@",rank, selectedTeam.name]];
    
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"%ld: %ld-%ld",(long)[HBSharedUtils currentLeague].leagueHistoryDictionary.count + [HBSharedUtils currentLeague].baseYear,(long)selectedTeam.wins,(long)selectedTeam.losses]];
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
    return 18;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 36;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if (([HBSharedUtils currentLeague].isCareerMode && (!selectedTeam.isUserControlled && ![selectedTeam isEqual:[HBSharedUtils currentLeague].userTeam])) || ![HBSharedUtils currentLeague].isCareerMode) {
            return 7;
        } else {
            return 6;
        }
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
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        NSArray *cellStat = stats[indexPath.row];
        
        NSString *stat = @"";
        if ([HBSharedUtils currentLeague].currentWeek > 0) {
            if (indexPath.row == 5 || indexPath.row == 6) {
                stat = cellStat[0];
            } else {
                stat = [NSString stringWithFormat:@"%@ (%@)", cellStat[0], cellStat[2]];
            }
        } else {
            stat = cellStat[0];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setText:cellStat[1]];
        [cell.detailTextLabel setText:stat];
        return cell;
    } else {
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        if (([HBSharedUtils currentLeague].isCareerMode && (!selectedTeam.isUserControlled && ![selectedTeam isEqual:[HBSharedUtils currentLeague].userTeam])) || ![HBSharedUtils currentLeague].isCareerMode) {
            if (indexPath.row == 0) {
                [cell.textLabel setText:@"Head Coach"];
                if (selectedTeam.coachFired) {
                    [cell.detailTextLabel setText:@"None (coach fired)"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else if (selectedTeam.coachRetired) {
                    [cell.detailTextLabel setText:@"None (coach retired)"];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else {
                    [cell.detailTextLabel setText:[[selectedTeam getCurrentHC] getInitialName]];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                }
            } else if (indexPath.row == 1) {
                [cell.textLabel setText:@"Roster"];
            } else if (indexPath.row == 2) {
                [cell.textLabel setText:@"Schedule"];
            } else if (indexPath.row == 3) {
                [cell.textLabel setText:@"Team Streaks"];
            } else if (indexPath.row == 4) {
                [cell.textLabel setText:@"Team History"];
            } else if (indexPath.row == 5) {
                [cell.textLabel setText:@"Ring of Honor"];
            } else {
                [cell.textLabel setText:@"Team Records"];
            }
        } else {
            if (indexPath.row == 0) {
                [cell.textLabel setText:@"Roster"];
            } else if (indexPath.row == 1) {
                [cell.textLabel setText:@"Schedule"];
            } else if (indexPath.row == 2) {
                [cell.textLabel setText:@"Team Streaks"];
            } else if (indexPath.row == 3) {
                [cell.textLabel setText:@"Team History"];
            } else if (indexPath.row == 4) {
                [cell.textLabel setText:@"Ring of Honor"];
            } else {
                [cell.textLabel setText:@"Team Records"];
            }
        }
        return cell;

    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.popupController) {
            if (([HBSharedUtils currentLeague].isCareerMode && (!selectedTeam.isUserControlled && ![selectedTeam isEqual:[HBSharedUtils currentLeague].userTeam])) || ![HBSharedUtils currentLeague].isCareerMode) {
                if (indexPath.row == 0) {
                    if (!selectedTeam.coachRetired && !selectedTeam.coachFired) {
                        [self.popupController pushViewController:[[HeadCoachDetailViewController alloc] initWithCoach:[selectedTeam getCurrentHC]] animated:YES];
                    }
                } else if (indexPath.row == 1) {
                    [self.popupController pushViewController:[[TeamRosterViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 2) {
                    [self.popupController pushViewController:[[TeamScheduleViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 3) {
                    [self.popupController pushViewController:[[TeamStreaksViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 4) {
                    [self.popupController pushViewController:[[TeamHistoryViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 5) {
                    [self.popupController pushViewController:[[RingOfHonorViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else {
                    [self.popupController pushViewController:[[TeamRecordsViewController alloc] initWithTeam:selectedTeam] animated:YES];
                }
            } else {
                if (indexPath.row == 0) {
                    [self.popupController pushViewController:[[TeamRosterViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 1) {
                    [self.popupController pushViewController:[[TeamScheduleViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 2) {
                    [self.popupController pushViewController:[[TeamStreaksViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 3) {
                    [self.popupController pushViewController:[[TeamHistoryViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 4) {
                    [self.popupController pushViewController:[[RingOfHonorViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else {
                    [self.popupController pushViewController:[[TeamRecordsViewController alloc] initWithTeam:selectedTeam] animated:YES];
                }
            }
        } else {
            if (([HBSharedUtils currentLeague].isCareerMode && (!selectedTeam.isUserControlled && ![selectedTeam isEqual:[HBSharedUtils currentLeague].userTeam])) || ![HBSharedUtils currentLeague].isCareerMode) {
                if (indexPath.row == 0) {
                    [self.navigationController pushViewController:[[HeadCoachDetailViewController alloc] initWithCoach:[selectedTeam getCurrentHC]] animated:YES];
                } else if (indexPath.row == 1) {
                    [self.navigationController pushViewController:[[TeamRosterViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 2) {
                    [self.navigationController pushViewController:[[TeamScheduleViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 3) {
                    [self.navigationController pushViewController:[[TeamStreaksViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 4) {
                    [self.navigationController pushViewController:[[TeamHistoryViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 5) {
                    [self.navigationController pushViewController:[[RingOfHonorViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else {
                    [self.navigationController pushViewController:[[TeamRecordsViewController alloc] initWithTeam:selectedTeam] animated:YES];
                }
            } else {
                if (indexPath.row == 0) {
                    [self.navigationController pushViewController:[[TeamRosterViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 1) {
                    [self.navigationController pushViewController:[[TeamScheduleViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 2) {
                    [self.navigationController pushViewController:[[TeamStreaksViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 3) {
                    [self.navigationController pushViewController:[[TeamHistoryViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else if (indexPath.row == 4) {
                    [self.navigationController pushViewController:[[RingOfHonorViewController alloc] initWithTeam:selectedTeam] animated:YES];
                } else {
                    [self.navigationController pushViewController:[[TeamRecordsViewController alloc] initWithTeam:selectedTeam] animated:YES];
                }
            }
        }
    }
}


@end
