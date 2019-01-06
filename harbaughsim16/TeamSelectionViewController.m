//
//  TeamSelectionViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamSelectionViewController.h"
#import "Team.h"
#import "League.h"
#import "HBSharedUtils.h"
#import "AppDelegate.h"

#import <Crashlytics/Crashlytics.h>

@interface TeamSelectionViewController ()
{
    NSArray *southTeams;
    NSArray *lakesTeams;
    NSArray *pacificTeams;
    NSArray *northTeams;
    NSArray *cowbyTeams;
    NSArray *mountTeams;
    League *league;
    Team *userTeam;
    NSIndexPath *selectedIndexPath;
}
@end

@implementation TeamSelectionViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(instancetype)initWithLeague:(League*)selectedLeague {
    self = [super init];
    if (self) {
        league = selectedLeague;
    }
    return self;
}

-(void)confirmTeamSelection {
    if (selectedIndexPath && userTeam) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to start your career with this team?" message:@"This choice can NOT be changed later." preferredStyle:UIAlertControllerStyleAlert];
        if (league.isCareerMode) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Career - Coach Name" message:@"What do you want your coach to be named?" preferredStyle:UIAlertControllerStyleAlert];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Coach First Name";
                }];
                [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Coach Last Name";
                }];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self->userTeam setupUserCoach:[NSString stringWithFormat:@"%@ %@", alert.textFields[0].text, alert.textFields[1].text]];
                    self->userTeam.isUserControlled = YES;
                    [self->league setUserTeam:self->userTeam];
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:self->league];
                    [self->league save];
                    
                    NSLog(@"Career MODE ENGAGED: %@, difficulty: %@", [self->userTeam getCurrentHC].name, (self->league.isHardMode) ? @"hard" : @"easy");
                    [Answers logContentViewWithName:@"New career Save Created" contentType:@"Team" contentId:@"career-team19" customAttributes:@{@"Team Name":self->userTeam.name}];
                    
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) updateTabBarForCareer];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }]];
        } else {
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Difficulty" message:@"Would you like to set your game difficulty to hard? On hard, your rival will be more competitive, good players will have a higher chance of leaving for the pros, and your program can incur sanctions from the league." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Yes, I'd like a challenge." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self->userTeam.isUserControlled = YES;
                    [self->league setUserTeam:self->userTeam];
                    self->league.isHardMode = YES;
                    self->league.canRebrandTeam = YES;
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:self->league];
                    [self->league save];
                    
                    NSLog(@"HARD MODE ENGAGED");
                    [Answers logContentViewWithName:@"New Hard Mode Save Created" contentType:@"Team" contentId:@"hardmode-team16" customAttributes:@{@"Team Name":self->userTeam.name}];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"No, I'll stick with easy." style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    self->userTeam.isUserControlled = YES;  
                    [self->league setUserTeam:self->userTeam];
                    self->league.isHardMode = NO;
                    self->league.canRebrandTeam = YES;
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:self->league];
                    [self->league save];
                    
                    [Answers logContentViewWithName:@"New Easy Mode Save Created" contentType:@"Team" contentId:@"team16" customAttributes:@{@"Team Name":self->userTeam.name}];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }]];
        }
       
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pick your team!";
    southTeams = league.conferences[0].confTeams;
    lakesTeams = league.conferences[1].confTeams;
    northTeams = league.conferences[2].confTeams;
    cowbyTeams = league.conferences[3].confTeams;
    pacificTeams = league.conferences[4].confTeams;
    mountTeams = league.conferences[5].confTeams;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmTeamSelection)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

-(void)reloadTable {
    if (!selectedIndexPath || !userTeam) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return league.conferences[section].confFullName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    
    Team *team;
    if (selectedIndexPath) {
        if (indexPath.section == selectedIndexPath.section && indexPath.row == selectedIndexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 0) {
        team = southTeams[indexPath.row];
    } else if (indexPath.section == 1) {
        team = lakesTeams[indexPath.row];
    } else if (indexPath.section == 2) {
        team = northTeams[indexPath.row];
    } else if (indexPath.section == 3) {
        team = cowbyTeams[indexPath.row];
    } else if (indexPath.section == 4) {
        team = pacificTeams[indexPath.row];
    } else {
        team = mountTeams[indexPath.row];
    }
    [cell.textLabel setText:team.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"Prestige: %d",team.teamPrestige]];
    if (league.isHardMode && league.isCareerMode) {
        if (indexPath.row == southTeams.count - 1 || indexPath.row == southTeams.count - 2) {
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else {
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (league.isHardMode && league.isCareerMode) {
        if (indexPath.row == southTeams.count - 1 || indexPath.row == southTeams.count - 2) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            if (indexPath.section == 0) {
                userTeam = southTeams[indexPath.row];
            } else if (indexPath.section == 1) {
                userTeam = lakesTeams[indexPath.row];
            } else if (indexPath.section == 2) {
                userTeam = northTeams[indexPath.row];
            } else if (indexPath.section == 3) {
                userTeam = cowbyTeams[indexPath.row];
            } else if (indexPath.section == 4) {
                userTeam = pacificTeams[indexPath.row];
            } else {
                userTeam = mountTeams[indexPath.row];
            }
            if ([selectedIndexPath isEqual:indexPath]) {
                selectedIndexPath = nil;
            } else {
                selectedIndexPath = indexPath;
            }
            [self reloadTable];
        }
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if (indexPath.section == 0) {
            userTeam = southTeams[indexPath.row];
        } else if (indexPath.section == 1) {
            userTeam = lakesTeams[indexPath.row];
        } else if (indexPath.section == 2) {
            userTeam = northTeams[indexPath.row];
        } else if (indexPath.section == 3) {
            userTeam = cowbyTeams[indexPath.row];
        } else if (indexPath.section == 4) {
            userTeam = pacificTeams[indexPath.row];
        } else {
            userTeam = mountTeams[indexPath.row];
        }
        if ([selectedIndexPath isEqual:indexPath]) {
            selectedIndexPath = nil;
        } else {
            selectedIndexPath = indexPath;
        }
        [self reloadTable];
    }
    
}

@end
