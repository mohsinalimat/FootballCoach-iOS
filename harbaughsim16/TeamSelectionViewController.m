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

#import <Crashlytics/Crashlytics.h> // If using Answers with Crashlytics


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

-(instancetype)initWithLeague:(League*)selectedLeague {
    self = [super init];
    if (self) {
        league = selectedLeague;
    }
    return self;
}

-(void)confirmTeamSelection {
    if (selectedIndexPath && userTeam) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to pick this team?" message:@"This choice can NOT be changed later." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Mode" message:@"Would you like to turn on hard mode? In hard mode, your rival will be more competitive, good players will have a higher chance of leaving for the pros, and your program can incur sanctions from the league." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes, I'd like a challenge." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [league setUserTeam:userTeam];
                league.isHardMode = YES;
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:league];
                [league save];
                
                NSLog(@"HARD MODE ENGAGED");
                [Answers logContentViewWithName:@"New Hard Mode Save Created" contentType:@"Team" contentId:@"hardmode-team16" customAttributes:@{@"Team Name":userTeam.name}];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"No, I'll stick with normal mode." style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [league setUserTeam:userTeam];
                league.isHardMode = NO;
                [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:league];
                [league save];
                
                [Answers logContentViewWithName:@"New Normal Mode Save Created" contentType:@"Team" contentId:@"team16" customAttributes:@{@"Team Name":userTeam.name}];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
            
            /*[league setUserTeam:userTeam];
            [league setCanRebrandTeam:YES];
            userTeam.isUserControlled = YES;
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:league];
            [league save];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];*/

            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"No team has been chosen. Please select one and try again." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"South";
    } else if (section == 1) {
        return @"Lakes";
    } else if (section == 2) {
        return @"North";
    } else if (section == 3) {
        return @"Cowboy";
    } else if (section == 4) {
        return @"Pacific";
    } else {
        return @"Mountain";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
