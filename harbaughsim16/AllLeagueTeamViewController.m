//
//  AllLeagueTeamViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/31/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "AllLeagueTeamViewController.h"
#import "Team.h"
#import "League.h"
#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerTE.h"
#import "PlayerK.h"
#import "HBPlayerCell.h"
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

#import "HexColors.h"

@interface AllLeagueTeamViewController () <UIViewControllerPreviewingDelegate>
{
    NSDictionary *players;
    Player *heisman;
}
@end

@implementation AllLeagueTeamViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        Player *p;
        if (indexPath.section == 0) {
            p = players[@"QB"][indexPath.row];
        } else if (indexPath.section == 1) {
            p = players[@"RB"][indexPath.row];
        } else if (indexPath.section == 2) {
            p = players[@"WR"][indexPath.row];
        } else if (indexPath.section == 3) {
            p = players[@"TE"][indexPath.row];
        } else {
            p = players[@"K"][indexPath.row];
        }
        PlayerDetailViewController *playerDetail;
        if ([p.position isEqualToString:@"QB"]) {
            playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"RB"]) {
            playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"WR"]) {
            playerDetail = [[PlayerWRDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"TE"]) {
            playerDetail = [[PlayerTEDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"OL"]) {
            playerDetail = [[PlayerOLDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"DL"]) {
            playerDetail = [[PlayerDLDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"LB"]) {
            playerDetail = [[PlayerLBDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"CB"]) {
            playerDetail = [[PlayerCBDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"S"]) {
            playerDetail = [[PlayerSDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"K"]) {
            playerDetail = [[PlayerKDetailViewController alloc] initWithPlayer:p];
        } else {
            playerDetail = [[PlayerDetailViewController alloc] initWithPlayer:p];
        }
        playerDetail.preferredContentSize = CGSizeMake(0.0, 600);
        previewingContext.sourceRect = cell.frame;
        return playerDetail;
    } else {
        return nil;
    }
}

-(id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStylePlain]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    heisman = [[HBSharedUtils currentLeague] heisman];

    self.title = [NSString stringWithFormat:@"%ld's All-League Team", (long)([HBSharedUtils currentLeague].baseYear + [HBSharedUtils currentLeague].leagueHistoryDictionary.count)];
    players = [[HBSharedUtils currentLeague] allLeaguePlayers];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBPlayerCell" bundle:nil] forCellReuseIdentifier:@"HBPlayerCell"];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setRowHeight:60];
    [self.tableView setEstimatedRowHeight:60];
    self.tableView.tableFooterView = [UIView new];

    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"QB";
    } else if (section == 1) {
        return @"RB";
    } else if (section == 2) {
        return @"WR";
    } else if (section == 3) {
        return @"TE";
    } else {
        return @"K";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 3;
    } else if (section == 3) {
        return 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBPlayerCell *statsCell = (HBPlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"HBPlayerCell"];
    Player *plyr;
    if (indexPath.section == 0) {
        plyr = players[@"QB"][indexPath.row];
    } else if (indexPath.section == 1) {
        plyr = players[@"RB"][indexPath.row];
    } else if (indexPath.section == 2) {
        plyr = players[@"WR"][indexPath.row];
    } else if (indexPath.section == 3) {
        plyr = players[@"TE"][indexPath.row];
    } else {
        plyr = players[@"K"][indexPath.row];
    }
    NSString *stat1 = @"";
    NSString *stat2 = @"";
    NSString *stat3 = @"";
    NSString *stat4 = @"";

    NSString *stat1Value = @"";
    NSString *stat2Value = @"";
    NSString *stat3Value = @"";
    NSString *stat4Value = @"";

    if ([plyr isKindOfClass:[PlayerQB class]]) {
        stat1 = @"CMP%"; //comp/att, yds, td, int
        stat2 = @"Yds";
        stat3 = @"TDs";
        stat4 = @"INTs";

        stat1Value = [NSString stringWithFormat:@"%d%%",(100 * ((PlayerQB*)plyr).statsPassComp/((PlayerQB*)plyr).statsPassAtt)];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsPassYards];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsTD];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsInt];
        //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:13.0]];
    } else if ([plyr isKindOfClass:[PlayerRB class]]) {
        stat1 = @"Car";
        stat2 = @"Yds";
        stat3 = @"TD";
        stat4 = @"Fum";
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsRushAtt];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsRushYards];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsTD];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerRB*)plyr).statsFumbles];
        //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    } else if ([plyr isKindOfClass:[PlayerWR class]]) {
        stat1 = @"Rec";
        stat2 = @"Yds";
        stat3 = @"TD";
        stat4 = @"Fum";
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsReceptions];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsRecYards];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsTD];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsFumbles];
        //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    } else if ([plyr isKindOfClass:[PlayerTE class]]) {
        stat1 = @"Rec";
        stat2 = @"Yds";
        stat3 = @"TD";
        stat4 = @"Fum";
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsReceptions];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsRecYards];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsTD];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsFumbles];
        //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    } else { //PlayerK class
        stat1 = @"XPM";
        stat2 = @"XPA";
        stat3 = @"FGM";
        stat4 = @"FGA";

        stat1Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsXPMade];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsXPAtt];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsFGMade];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsFGAtt];
    }

    [statsCell.playerLabel setText:[plyr getInitialName]];
    [statsCell.teamLabel setText:plyr.team.abbreviation];

    if ([statsCell.teamLabel.text containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [statsCell.playerLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        if (heisman != nil) {
            if ([heisman isEqual:plyr]) {
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
    Player *plyr;
    PlayerDetailViewController *vc;
    if (indexPath.section == 0) {
        plyr = players[@"QB"][indexPath.row];
        vc = [[PlayerQBDetailViewController alloc] initWithPlayer:plyr];
    } else if (indexPath.section == 1) {
        plyr = players[@"RB"][indexPath.row];
        vc = [[PlayerRBDetailViewController alloc] initWithPlayer:plyr];
    } else if (indexPath.section == 2) {
        plyr = players[@"WR"][indexPath.row];
        vc = [[PlayerWRDetailViewController alloc] initWithPlayer:plyr];
    } else if (indexPath.section == 3) {
        plyr = players[@"TE"][indexPath.row];
        vc = [[PlayerTEDetailViewController alloc] initWithPlayer:plyr];
    } else {
        plyr = players[@"K"][indexPath.row];
        vc = [[PlayerKDetailViewController alloc] initWithPlayer:plyr];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
