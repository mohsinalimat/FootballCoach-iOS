//
//  TeamScheduleViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamScheduleViewController.h"
#import "Team.h"
#import "Game.h"
#import "HBScheduleCell.h"
#import "GameDetailViewController.h"

#import "HexColors.h"

@interface TeamScheduleViewController () <UIViewControllerPreviewingDelegate>
{
    Team *userTeam;
    NSArray *schedule;
}
@end

@implementation TeamScheduleViewController


// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        HBScheduleCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        GameDetailViewController *gameDetail = [[GameDetailViewController alloc] initWithGame:userTeam.gameSchedule[indexPath.row]];
        gameDetail.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
        previewingContext.sourceRect = cell.frame;
        return gameDetail;
    } else {
        return nil;
    }
}

-(instancetype)initWithTeam:(Team*)team {
    if (self = [super init]) {
        userTeam = team;
        schedule = [team.gameSchedule copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = [NSString stringWithFormat:@"%@ Schedule",userTeam.abbreviation];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScheduleCell" bundle:nil] forCellReuseIdentifier:@"HBScheduleCell"];
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return schedule.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBScheduleCell *cell = (HBScheduleCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScheduleCell"];
    //Game *game = schedule[indexPath.row];
    int index = [NSNumber numberWithInteger:indexPath.row].intValue;
    [cell.gameNameLabel setText:[userTeam getGameSummaryStrings:index][0]];
    [cell.gameScoreLabel setText:[userTeam getGameSummaryStrings:index][1]];
    [cell.gameSummaryLabel setText:[userTeam getGameSummaryStrings:index][2]];
    
    if (userTeam.gameWLSchedule.count > indexPath.row) {
        if (![cell.gameScoreLabel.text containsString:userTeam.abbreviation] && ![cell.gameScoreLabel.text containsString:@"PUSH"]) {
            if ([cell.gameScoreLabel.text containsString:@"W"]) {
                [cell.gameScoreLabel setTextColor:[HBSharedUtils successColor]];
            } else if ([cell.gameScoreLabel.text containsString:@"L"]) {
                [cell.gameScoreLabel setTextColor:[HBSharedUtils errorColor]];
            } else {
                [cell.gameScoreLabel setTextColor:[UIColor blackColor]];
            }
        } else {
            [cell.gameScoreLabel setTextColor:[UIColor blackColor]];
        }
    } else {
        [cell.gameScoreLabel setTextColor:[UIColor blackColor]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Game *game = schedule[indexPath.row];
    [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:game] animated:YES];
}


@end
