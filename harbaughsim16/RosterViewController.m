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
#import "HBStatsCell.h"
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

@interface RosterViewController ()
{
    Team *userTeam;
}
@end

@implementation RosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Stats";
    [self.tableView registerNib:[UINib nibWithNibName:@"HBStatsCell" bundle:nil] forCellReuseIdentifier:@"HBStatsCell"];
    userTeam = [HBSharedUtils getLeague].userTeam;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else {
        return 3;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"QB";
    } else if (section == 1) {
        return @"RB";
    } else {
        return @"WR";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBStatsCell *cell = (HBStatsCell*)[tableView dequeueReusableCellWithIdentifier:@"HBStatsCell" forIndexPath:indexPath];
    Player *player;
    if (indexPath.section == 0) {
        player = [userTeam getQB:0];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            player = [userTeam getRB:0];
        } else {
            player = [userTeam getRB:1];
        }
    } else {
        if (indexPath.row == 0) {
            player = [userTeam getWR:0];
        } else if (indexPath.row == 1) {
            player = [userTeam getWR:1];
        } else {
            player = [userTeam getWR:2];
        }
    }
    [cell.nameLabel setText:[player getInitialName]];
    [cell.yrLabel setText:[player getYearString]];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player;
    if (indexPath.section == 0) {
        player = [userTeam getQB:0];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            player = [userTeam getRB:0];
        } else {
            player = [userTeam getRB:1];
        }
    } else {
        if (indexPath.row == 0) {
            player = [userTeam getWR:0];
        } else if (indexPath.row == 1) {
            player = [userTeam getWR:1];
        } else {
            player = [userTeam getWR:2];
        }
    }
    [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:player] animated:YES];
}

@end
