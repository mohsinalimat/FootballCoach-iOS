//
//  HeismanLeadersViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "HeismanLeadersViewController.h"
#import "HBPlayerCell.h"
#import "Player.h"
#import "PlayerDetailViewController.h"
#import "PlayerDetailViewController.h"
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

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerLB.h"
#import "PlayerDL.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "HexColors.h"

@interface HeismanLeadersViewController () <UIViewControllerPreviewingDelegate>
{
    NSArray *heismanLeaders;
    Player *heisman;
}
@end

@implementation HeismanLeadersViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        HBPlayerCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        PlayerDetailViewController *playerDetail;
        Player *p = heismanLeaders[indexPath.row];
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

-(instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    heisman = [[HBSharedUtils currentLeague] heisman];
    
    if ([HBSharedUtils currentLeague].currentWeek < 13) {
        self.title = @"POTY Leaders";
    } else {
        self.title = @"POTY Results";
    }
    self.tableView.rowHeight = 60;
    self.tableView.estimatedRowHeight = 60;
    heismanLeaders = [[HBSharedUtils currentLeague] getHeismanLeaders];
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
    return heismanLeaders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBPlayerCell *statsCell = (HBPlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"HBPlayerCell"];
    Player *plyr = heismanLeaders[indexPath.row];
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
    
    if ([HBSharedUtils currentLeague].currentWeek >= 13 && heisman != nil) {
        [statsCell.teamLabel setText:plyr.team.abbreviation];
    } else {
        [statsCell.teamLabel setText:[NSString stringWithFormat:@"%@ (%d votes)", plyr.team.abbreviation, [plyr getHeismanScore]]];
    }
    
    if ([statsCell.teamLabel.text containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [statsCell.playerLabel setTextColor:[HBSharedUtils styleColor]];
    } else {        
        if ([HBSharedUtils currentLeague].currentWeek >= 13 && heisman != nil) {
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
    Player *p = heismanLeaders[indexPath.row];
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
