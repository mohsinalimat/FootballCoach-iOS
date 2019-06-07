//
//  TeamStrategyViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/22/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamStrategyViewController.h"
#import "TeamStrategy.h"
#import "Team.h"
#import "HeadCoach.h"

#import "STPopup.h"
#import "MBProgressHUD.h"

@interface TeamStrategyViewController ()
{
    NSArray *teamStrats;
    NSIndexPath *selectedIndexPath;
    BOOL isOffense;
}
@end

@implementation TeamStrategyViewController

-(instancetype)initWithType:(BOOL)offensive options:(NSArray<TeamStrategy*> *)options {
    self = [super init];
    if (self) {
        isOffense = offensive;
        if (isOffense) {
            self.title = @"Offensive Playbooks";
            if ([HBSharedUtils currentLeague].isCareerMode) {
                selectedIndexPath = [NSIndexPath indexPathForRow:[[HBSharedUtils currentLeague].userTeam getCurrentHC].offStratNum inSection:0];
            } else {
                selectedIndexPath = [NSIndexPath indexPathForRow:[HBSharedUtils currentLeague].userTeam.teamStatOffNum inSection:0];
            }
        } else {
            self.title = @"Defensive Playbooks";
            if ([HBSharedUtils currentLeague].isCareerMode) {
                selectedIndexPath = [NSIndexPath indexPathForRow:[[HBSharedUtils currentLeague].userTeam getCurrentHC].defStratNum inSection:0];
            } else {
                selectedIndexPath = [NSIndexPath indexPathForRow:[HBSharedUtils currentLeague].userTeam.teamStatDefNum inSection:0];
            }
        }
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.75 * [UIScreen mainScreen].bounds.size.height);
        teamStrats = options;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 115;
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setBackgroundColor:[HBSharedUtils styleColor]];
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return teamStrats.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.detailTextLabel setNumberOfLines:0];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:SMALL_FONT_SIZE]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
    }
    TeamStrategy *strat = teamStrats[indexPath.row];
    [cell.textLabel setText:strat.stratName];
    [cell.detailTextLabel setText:strat.stratDescription];
    [cell.detailTextLabel sizeToFit];
    
    if(selectedIndexPath) {
        if (indexPath.row == selectedIndexPath.row && indexPath.section == selectedIndexPath.section) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __block MBProgressHUD *hud;
    dispatch_async(dispatch_get_main_queue(), ^{
       hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        [hud.label setText:@"Saving league data..."];
        hud.mode = MBProgressHUDModeIndeterminate;
    });
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        if ([self->selectedIndexPath isEqual:indexPath]) {
            self->selectedIndexPath = nil;
        } else {
            self->selectedIndexPath = indexPath;
        }
        
        if(self->isOffense) {
            [[HBSharedUtils currentLeague].userTeam setOffensiveStrategy:self->teamStrats[indexPath.row]];
            [[HBSharedUtils currentLeague].userTeam setTeamStatOffNum:(int)indexPath.row];
            [[[HBSharedUtils currentLeague].userTeam getCurrentHC] setOffStratNum:(int)indexPath.row];
        } else {
            [[HBSharedUtils currentLeague].userTeam setDefensiveStrategy:self->teamStrats[indexPath.row]];
            [[HBSharedUtils currentLeague].userTeam setTeamStatDefNum:(int)indexPath.row];
            [[[HBSharedUtils currentLeague].userTeam getCurrentHC] setDefStratNum:(int)indexPath.row];
        }
        
        [[HBSharedUtils currentLeague] save:^(BOOL success, NSError *err) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                if (err) {
                    NSLog(@"[Playbooks] SAVE ERROR: %@", err);
                }
                [hud hideAnimated:YES];
                [tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changedStrategy" object:nil];
            });
        }];
    });
}

@end
