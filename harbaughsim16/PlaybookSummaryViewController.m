//
//  PlaybookSummaryViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/28/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "PlaybookSummaryViewController.h"

#import "TeamStrategy.h"
#import "Team.h"

@interface PlaybookSummaryViewController ()
{
    TeamStrategy *offensivePlaybook;
    TeamStrategy *defensivePlaybook;
}
@end

@implementation PlaybookSummaryViewController

-(instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.65 * [UIScreen mainScreen].bounds.size.height);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Playbooks";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 115;
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setBackgroundColor:[HBSharedUtils styleColor]];
    self.tableView.tableFooterView = [UIView new];
    
    offensivePlaybook = [[HBSharedUtils currentLeague].userTeam getOffensiveTeamStrategies][[HBSharedUtils currentLeague].userTeam.teamStatOffNum];
    defensivePlaybook = [[HBSharedUtils currentLeague].userTeam getDefensiveTeamStrategies][[HBSharedUtils currentLeague].userTeam.teamStatDefNum];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Offensive";
    } else {
        return @"Defensive";
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setNumberOfLines:0];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    TeamStrategy *strat;
    if (indexPath.section == 0) {
        strat = offensivePlaybook;
    } else {
        strat = defensivePlaybook;
    }
    [cell.textLabel setText:strat.stratName];
    [cell.detailTextLabel setText:strat.stratDescription];
    [cell.detailTextLabel sizeToFit];
    
    return cell;
}


@end
