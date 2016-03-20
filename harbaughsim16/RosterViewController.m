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
@interface HBButtonView : UIView
@property (weak, nonatomic) IBOutlet UIButton *button;
@end
@implementation HBButtonView
-(IBAction)goToRecruiting:(id)sender {
    NSLog(@"RECRUIT");
}
@end

@interface RosterViewController ()
{
    Team *userTeam;
    IBOutlet HBButtonView *buttonView;
}
@end

@implementation RosterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Roster";
    [self.tableView registerNib:[UINib nibWithNibName:@"HBRosterCell" bundle:nil] forCellReuseIdentifier:@"HBRosterCell"];
    userTeam = [HBSharedUtils getLeague].userTeam;
    self.tableView.tableHeaderView = buttonView;
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [buttonView setBackgroundColor:[HBSharedUtils styleColor]];
    
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
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        return 5;
    } else if (section == 4) {
        return 7;
    } else if (section == 5) {
        return 3;
    } else if (section == 6) {
        return 1;
    } else {
        return 1;
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
        player = [userTeam getQB:0];
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
        player = [userTeam getS:0];
    } else {
        player = [userTeam getK:0];
    }
    [cell.nameLabel setText:[player getInitialName]];
    [cell.yrLabel setText:[player getYearString]];
    [cell.ovrLabel setText:[NSString stringWithFormat:@"%d", player.ratOvr]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player;
    if (indexPath.section == 0) {
        player = [userTeam getQB:0];
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
        player = [userTeam getS:0];
    } else {
        player = [userTeam getK:0];
    }
    [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:player] animated:YES];
}

@end
