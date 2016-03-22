//
//  StatisticsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "RosterViewController.h"
#import "HBSharedUtils.h"
#import "Team.h"
#import "HBRosterCell.h"
#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"
#import "PlayerDetailViewController.h"

#import "HexColors.h"

@interface RosterViewController ()
{
    Team *userTeam;
}
@end

@implementation RosterViewController

-(void)manageEditing {
    if (self.editing) {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [[HBSharedUtils getLeague] save];
    } else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        return [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    return proposedDestinationIndexPath;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    //NSString *item = [[arryData objectAtIndex:fromIndexPath.row] retain];
    //[arryData removeObject:item];
    //[arryData insertObject:item atIndex:toIndexPath.row];
    //[item release];
    
    if(sourceIndexPath.section == destinationIndexPath.section) {
        if (destinationIndexPath.section == 0) {
            PlayerQB *qb = userTeam.teamQBs[sourceIndexPath.row];
            [userTeam.teamQBs removeObject:qb];
            [userTeam.teamQBs insertObject:qb atIndex:destinationIndexPath.row];
            [userTeam setStarters:[userTeam.teamQBs copy] position:0];
        } else if (destinationIndexPath.section == 1) {
            PlayerRB *rb = userTeam.teamRBs[sourceIndexPath.row];
            [userTeam.teamRBs removeObject:rb];
            [userTeam.teamRBs insertObject:rb atIndex:destinationIndexPath.row];
            [userTeam setStarters:[userTeam.teamRBs copy] position:1];
        } else if (destinationIndexPath.section == 2) {
            PlayerWR *wr = userTeam.teamWRs[sourceIndexPath.row];
            [userTeam.teamWRs removeObject:wr];
            [userTeam.teamWRs insertObject:wr atIndex:destinationIndexPath.row];
            [userTeam setStarters:[userTeam.teamWRs copy] position:2];
        } else if (destinationIndexPath.section == 3) {
            PlayerOL *ol = userTeam.teamOLs[sourceIndexPath.row];
            [userTeam.teamOLs removeObject:ol];
            [userTeam.teamOLs insertObject:ol atIndex:destinationIndexPath.row];
            [userTeam setStarters:[userTeam.teamOLs copy] position:3];
        } else if (destinationIndexPath.section == 4) {
            PlayerF7 *f7 = userTeam.teamF7s[sourceIndexPath.row];
            [userTeam.teamF7s removeObject:f7];
            [userTeam.teamF7s insertObject:f7 atIndex:destinationIndexPath.row];
            [userTeam setStarters:[userTeam.teamRBs copy] position:4];
        } else if (destinationIndexPath.section == 5) {
            PlayerCB *cb = userTeam.teamCBs[sourceIndexPath.row];
            [userTeam.teamCBs removeObject:cb];
            [userTeam.teamCBs insertObject:cb atIndex:destinationIndexPath.row];
            [userTeam setStarters:[userTeam.teamCBs copy] position:5];
        } else if (destinationIndexPath.section == 6) {
            PlayerS *s = userTeam.teamSs[sourceIndexPath.row];
            [userTeam.teamSs removeObject:s];
            [userTeam.teamSs insertObject:s atIndex:destinationIndexPath.row];
            [userTeam setStarters:[userTeam.teamSs copy] position:6];
        } else {
            PlayerK *k = userTeam.teamKs[sourceIndexPath.row];
            [userTeam.teamKs removeObject:k];
            [userTeam.teamKs insertObject:k atIndex:destinationIndexPath.row];
            [userTeam setStarters:[userTeam.teamKs copy] position:7];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Depth Chart";
    [self.tableView registerNib:[UINib nibWithNibName:@"HBRosterCell" bundle:nil] forCellReuseIdentifier:@"HBRosterCell"];
    userTeam = [HBSharedUtils getLeague].userTeam;
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(manageEditing)];
    [self.navigationItem setRightBarButtonItem:addButton];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(scrollToPositionGroup)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRoster) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRoster) name:@"newSaveFile" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadRoster {
    userTeam = [HBSharedUtils getLeague].userTeam;
    [self.tableView reloadData];
}

-(void)scrollToPositionGroup {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View a specific position" message:@"Which position would you like to see?" preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.tableView.numberOfSections; i++) {
        NSString *position = @"";
        if (i == 0) {
            position = @"QB";
        } else if (i == 1) {
            position = @"RB";
        } else if (i == 2) {
            position = @"WR";
        } else if (i == 3) {
            position = @"OL";
        } else if (i == 4) {
            position = @"F7";
        } else if (i == 5) {
            position = @"CB";
        } else if (i == 6) {
            position = @"S";
        } else {
            position = @"K";
        }
        [alertController addAction:[UIAlertAction actionWithTitle:position style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.tableView reloadData];
        }]];
        
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return userTeam.teamQBs.count;
    } else if (section == 1) {
        return userTeam.teamRBs.count;
    } else if (section == 2) {
        return userTeam.teamWRs.count;
    } else if (section == 3) {
        return userTeam.teamOLs.count;
    } else if (section == 4) {
        return userTeam.teamF7s.count;
    } else if (section == 5) {
        return userTeam.teamCBs.count;
    } else if (section == 6) {
        return userTeam.teamSs.count;
    } else {
        return userTeam.teamKs.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"QB";
    } else if (section == 1) {
        return @"RB";
    } else if (section == 2) {
        return @"WR";
    } else if (section == 3) {
        return @"OL";
    } else if (section == 4) {
        return @"F7";
    } else if (section == 5) {
        return @"CB";
    } else if (section == 6) {
        return @"S";
    } else {
        return @"K";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBRosterCell *cell = (HBRosterCell*)[tableView dequeueReusableCellWithIdentifier:@"HBRosterCell" forIndexPath:indexPath];
    Player *player;
    if (indexPath.section == 0) {
        player = [userTeam getQB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 1) {
        player = [userTeam getRB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 2) {
        player = [userTeam getWR:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 3) {
        player = [userTeam getOL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 4) {
        player = [userTeam getF7:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 5) {
        player = [userTeam getCB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 6) {
        player = [userTeam getS:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else {
        player = [userTeam getK:[NSNumber numberWithInteger:indexPath.row].intValue];
    }
    [cell.nameLabel setText:[player getInitialName]];
    [cell.yrLabel setText:[player getYearString]];
    [cell.ovrLabel setText:[NSString stringWithFormat:@"%d", player.ratOvr]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Player *player;
    if (indexPath.section == 0) {
        player = [userTeam getQB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 1) {
        player = [userTeam getRB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 2) {
        player = [userTeam getWR:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 3) {
        player = [userTeam getOL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 4) {
        player = [userTeam getF7:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 5) {
        player = [userTeam getCB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 6) {
        player = [userTeam getS:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else {
        player = [userTeam getK:[NSNumber numberWithInteger:indexPath.row].intValue];
    }
    [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:player] animated:YES];
}

@end
