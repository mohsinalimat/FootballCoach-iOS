//
//  COTYLeadersViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/1/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "COTYLeadersViewController.h"
#import "HeadCoach.h"
#import "HBPlayerCell.h"
#import "HeadCoachDetailViewController.h"

@interface COTYLeadersViewController () <UIViewControllerPreviewingDelegate>
{
    NSArray *cotyLeaders;
    HeadCoach *coty;
}
@end

@implementation COTYLeadersViewController

-(instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        HBPlayerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        HeadCoachDetailViewController *coachDetail = [[HeadCoachDetailViewController alloc] initWithCoach:cotyLeaders[indexPath.row]];

        coachDetail.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
        previewingContext.sourceRect = cell.frame;
        return coachDetail;
    } else {
        return nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    coty = [HBSharedUtils currentLeague].cotyWinner;
    
    if ([HBSharedUtils currentLeague].currentWeek < 13) {
        self.title = @"COTY Leaders";
    } else {
        self.title = @"COTY Results";
    }
    self.tableView.rowHeight = 60;
    self.tableView.estimatedRowHeight = 60;
    cotyLeaders = [[HBSharedUtils currentLeague] getCOTYLeaders];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBPlayerCell" bundle:nil] forCellReuseIdentifier:@"HBPlayerCell"];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
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
    return cotyLeaders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBPlayerCell *statsCell = (HBPlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"HBPlayerCell"];
    HeadCoach *hc = cotyLeaders[indexPath.row];
    NSString *stat1 = @"";
    NSString *stat2 = @"W";
    NSString *stat3 = @"L";
    NSString *stat4 = @"Rank";
    
    NSString *stat2Value = [NSString stringWithFormat:@"%d", hc.team.wins];
    NSString *stat3Value = [NSString stringWithFormat:@"%d", hc.team.losses];
    NSString *stat4Value = [NSString stringWithFormat:@"%d", hc.team.rankTeamPollScore];
    NSString *stat1Value = @"";
    
    
    [statsCell.playerLabel setText:[hc getInitialName]];
    
    if ([HBSharedUtils currentLeague].currentWeek >= 13 && coty != nil) {
        [statsCell.teamLabel setText:hc.team.abbreviation];
    } else {
        [statsCell.teamLabel setText:[NSString stringWithFormat:@"%@ (%d vts)", hc.team.abbreviation, [hc getCoachScore]]];
    }
    
    if ([statsCell.teamLabel.text containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [statsCell.playerLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        if ([HBSharedUtils currentLeague].currentWeek >= 13 && coty != nil) {
            if ([coty isEqual:hc]) {
                [statsCell.playerLabel setTextColor:[HBSharedUtils champColor]];
            } else {
                [statsCell.playerLabel setTextColor:[UIColor blackColor]];
            }
        }
    }
    
    [statsCell.stat1Label setText:stat1];
    [statsCell.stat1ValueLabel setText:stat1Value];
    [statsCell.stat2Label setText:stat2];
    [statsCell.stat2ValueLabel setText:stat2Value];
    [statsCell.stat3Label setText:stat3];
    [statsCell.stat3ValueLabel setText:stat3Value];
    [statsCell.stat4Label setText:stat4];
    [statsCell.stat4ValueLabel setText:stat4Value];
    
    return statsCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HeadCoach *hc = cotyLeaders[indexPath.row];
    [self.navigationController pushViewController:[[HeadCoachDetailViewController alloc] initWithCoach:hc] animated:YES];
}

@end
