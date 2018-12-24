//
//  TransferringPlayersViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/22/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "TransferringPlayersViewController.h"

#import "Team.h"
#import "Player.h"

#import "PlayerQBDetailViewController.h"
#import "PlayerRBDetailViewController.h"
#import "PlayerWRDetailViewController.h"
#import "PlayerTEDetailViewController.h"
#import "PlayerOLDetailViewController.h"
#import "PlayerKDetailViewController.h"
#import "PlayerDLDetailViewController.h"
#import "PlayerLBDetailViewController.h"
#import "PlayerCBDetailViewController.h"
#import "PlayerSDetailViewController.h"
#import "PlayerDetailViewController.h"

#import "UIScrollView+EmptyDataSet.h"

@interface TransferringPlayersViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    Team *selectedTeam;
    CRCTransferViewOption selectedViewOption;
    NSInteger selectedIndex;
    NSMutableArray<Player *> *players;
    NSMutableDictionary<NSString *, NSString *> *incomingPlayerOldTeams;
}
@end

@implementation TransferringPlayersViewController

-(instancetype)initWithTeam:(Team *)t viewOption:(CRCTransferViewOption)option {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        selectedTeam = t;
        selectedViewOption = option;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"Outgoing", @"Incoming"]];
    [segControl setTintColor:[UIColor whiteColor]];
    [segControl setSelectedSegmentIndex:0];
    if (selectedViewOption == CRCTransferViewOptionIncoming) {
        players = selectedTeam.transferClass;
        self.title = @"Incoming Transfers";
    } else {
        players = selectedTeam.playersTransferring;
        self.title = @"Outgoing Transfers";
    }
    
    if (selectedViewOption == CRCTransferViewOptionIncoming || selectedViewOption == CRCTransferViewOptionBoth) {
        incomingPlayerOldTeams = [NSMutableDictionary dictionary];
        [self generateOrigins];
    }
    
    selectedIndex = 0;
    
    if (selectedViewOption == CRCTransferViewOptionBoth) {
        [segControl addTarget:self action:@selector(switchViews:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = segControl;
    }
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [HBSharedUtils styleColor];
}

-(void)generateOrigins {
    for (Player *p in selectedTeam.transferClass) {
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
            if (![t isEqual:selectedTeam] && [t.playersTransferring containsObject:p]) {
                [incomingPlayerOldTeams setObject:t.abbreviation forKey:[p uniqueIdentifier]];
                break;
            }
        }
    }
}

-(void)switchViews:(UISegmentedControl*)sender {
    selectedIndex = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == 0) {
        players = selectedTeam.playersTransferring;
    } else {
        players = selectedTeam.transferClass;
    }
    [self.tableView reloadData];
}

    
#pragma mark - DZNEmptyDataSetSource Methods
    
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    if (selectedIndex == 0) {
        text = @"No outgoing transfers";
    } else {
        text = @"No incoming transfers";
    }
    font = [UIFont boldSystemFontOfSize:17.0];
    textColor = [UIColor lightTextColor];
    
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    if (selectedIndex == 0) {
        text = @"No players transferred out of your program this offseason.";
    } else {
        text = @"No players transferred into your program this offseason.";
    }
    font = [UIFont systemFontOfSize:15.0];
    textColor = [UIColor lightTextColor];
    
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [HBSharedUtils styleColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return players.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
        
    }
    Player *player = players[indexPath.row];
    UIColor *nameColor;
    
    if (player.hasRedshirt) {
        nameColor = [UIColor lightGrayColor];
    } else if (player.isHeisman) {
        nameColor = [HBSharedUtils champColor];
    } else if (player.isAllAmerican) {
        nameColor = [UIColor orangeColor];
    } else if (player.isAllConference) {
        nameColor = [HBSharedUtils successColor];
    } else {
        nameColor = [UIColor blackColor];
    }
    
    NSString *name = (IS_IPHONE_5) ? [player getInitialName] : player.name;
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ (Ovr: %d)",player.position,name, player.ratOvr] attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular]}];
    [attText addAttribute:NSForegroundColorAttributeName value:nameColor range:[attText.string rangeOfString:name]];
    [attText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[attText.string rangeOfString:player.position]];
    [attText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[attText.string rangeOfString:[NSString stringWithFormat:@"(Ovr: %d)", (player.ratOvr)]]];
    [cell.textLabel setAttributedText:attText];
    if ([HBSharedUtils currentLeague].didFinishTransferPeriod) {
        if (selectedIndex == 0) {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"to %@", player.team.abbreviation]];
        } else {
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"from %@", incomingPlayerOldTeams[[player uniqueIdentifier]]]];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Player *p = players[indexPath.row];
    if ([p.position isEqualToString:@"QB"]) {
        [self.navigationController pushViewController:[[PlayerQBDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"RB"]) {
        [self.navigationController pushViewController:[[PlayerRBDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"WR"]) {
        [self.navigationController pushViewController:[[PlayerWRDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"TE"]) {
        [self.navigationController pushViewController:[[PlayerTEDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"OL"]) {
        [self.navigationController pushViewController:[[PlayerOLDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"DL"]) {
        [self.navigationController pushViewController:[[PlayerDLDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"LB"]) {
        [self.navigationController pushViewController:[[PlayerLBDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"CB"]) {
        [self.navigationController pushViewController:[[PlayerCBDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"S"]) {
        [self.navigationController pushViewController:[[PlayerSDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else if ([p.position isEqualToString:@"K"]) {
        [self.navigationController pushViewController:[[PlayerKDetailViewController alloc] initWithPlayer:p] animated:YES];
    } else {
        [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:p] animated:YES];
    }
}

@end
