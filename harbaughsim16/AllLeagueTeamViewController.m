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
#import "PlayerDL.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerS.h"
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
        } else if (indexPath.section == 4) {
            p = players[@"DL"][indexPath.row];
        } else if (indexPath.section == 5) {
            p = players[@"LB"][indexPath.row];
        } else if (indexPath.section == 6) {
            p = players[@"CB"][indexPath.row];
        } else if (indexPath.section == 7) {
            p = players[@"S"][indexPath.row];
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
        playerDetail.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
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
    } else if (section == 4) {
        return @"DL";
    } else if (section == 5) {
        return @"LB";
    } else if (section == 6) {
        return @"CB";
    } else if (section == 7) {
        return @"S";
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
    return 9;
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
    } else if (section == 4) {
        return 4;
    } else if (section == 5) {
        return 3;
    } else if (section == 6) {
        return 3;
    } else if (section == 7) {
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
    } else if (indexPath.section == 4) {
        plyr = players[@"DL"][indexPath.row];
    } else if (indexPath.section == 5) {
        plyr = players[@"LB"][indexPath.row];
    } else if (indexPath.section == 6) {
        plyr = players[@"CB"][indexPath.row];
    } else if (indexPath.section == 7) {
        plyr = players[@"S"][indexPath.row];
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
        if ([((PlayerQB*)plyr) getRushScore] >= [((PlayerQB*)plyr) getPassScore]) {
            stat1 = @"Car";
            stat2 = @"Yds";
            stat3 = @"TD";
            stat4 = @"Fum";
            stat1Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsRushAtt];
            stat2Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsRushYards];
            stat3Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsTD];
            stat4Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsFumbles];
        } else {
            stat1 = @"CMP%"; //comp/att, yds, td, int
            stat2 = @"Yds";
            stat3 = @"TDs";
            stat4 = @"INTs";
            
            stat1Value = [NSString stringWithFormat:@"%d%%",(100 * ((PlayerQB*)plyr).statsPassComp/((PlayerQB*)plyr).statsPassAtt)];
            stat2Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsPassYards];
            stat3Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsTD];
            stat4Value = [NSString stringWithFormat:@"%d",((PlayerQB*)plyr).statsInt];
        }
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
    } else if ([plyr isKindOfClass:[PlayerK class]]) { //PlayerK class
        stat1 = @"XPM";
        stat2 = @"XPA";
        stat3 = @"FGM";
        stat4 = @"FGA";

        stat1Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsXPMade];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsXPAtt];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsFGMade];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerK*)plyr).statsFGAtt];
    } else if ([plyr isKindOfClass:[PlayerDL class]]) {
        stat1 = @"Tkl";
        stat2 = @"Sck";
        stat3 = @"FFum";
        stat4 = @"PsDef";
        
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerDL*)plyr).statsTkl];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerDL*)plyr).statsSacks];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerDL*)plyr).statsForcedFum];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerDL*)plyr).statsPassDef];
    } else if ([plyr isKindOfClass:[PlayerLB class]]) {
        stat1 = @"Tkl";
        stat2 = @"Sck";
        stat3 = @"FFum";
        stat4 = @"PsDef";
        
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerLB*)plyr).statsTkl];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerLB*)plyr).statsSacks];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerLB*)plyr).statsForcedFum];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerLB*)plyr).statsPassDef];
    } else if ([plyr isKindOfClass:[PlayerCB class]]) {
        stat1 = @"Tkl";
        stat2 = @"INT";
        stat3 = @"FFum";
        stat4 = @"PsDef";
        
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerCB*)plyr).statsTkl];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerCB*)plyr).statsInt];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerCB*)plyr).statsForcedFum];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerCB*)plyr).statsPassDef];
    } else if ([plyr isKindOfClass:[PlayerS class]]) {
        stat1 = @"Tkl";
        stat2 = @"INT";
        stat3 = @"FFum";
        stat4 = @"PsDef";
        
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerS*)plyr).statsTkl];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerS*)plyr).statsInt];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerS*)plyr).statsForcedFum];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerS*)plyr).statsPassDef];
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
    } else if (indexPath.section == 4) {
        plyr = players[@"DL"][indexPath.row];
        vc = [[PlayerDLDetailViewController alloc] initWithPlayer:plyr];
    } else if (indexPath.section == 5) {
        plyr = players[@"LB"][indexPath.row];
        vc = [[PlayerLBDetailViewController alloc] initWithPlayer:plyr];
    } else if (indexPath.section == 6) {
        plyr = players[@"CB"][indexPath.row];
        vc = [[PlayerCBDetailViewController alloc] initWithPlayer:plyr];
    } else if (indexPath.section == 7) {
        plyr = players[@"S"][indexPath.row];
        vc = [[PlayerSDetailViewController alloc] initWithPlayer:plyr];
    } else { // PlayerK
        plyr = players[@"K"][indexPath.row];
        vc = [[PlayerKDetailViewController alloc] initWithPlayer:plyr];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
