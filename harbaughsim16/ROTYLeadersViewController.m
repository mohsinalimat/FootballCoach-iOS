//
//  ROTYLeadersViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/25/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "ROTYLeadersViewController.h"
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

@interface ROTYLeadersViewController ()
{
    NSArray *rotyLeaders;
    Player *roty;
}
@end

@implementation ROTYLeadersViewController

-(instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    roty = [[HBSharedUtils currentLeague] roty];
    
    if ([HBSharedUtils currentLeague].currentWeek < 13) {
        self.title = @"ROTY Leaders";
    } else {
        self.title = @"ROTY Results";
    }
    self.tableView.rowHeight = 60;
    self.tableView.estimatedRowHeight = 60;
    rotyLeaders = [[HBSharedUtils currentLeague] getROTYLeaders];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBPlayerCell" bundle:nil] forCellReuseIdentifier:@"HBPlayerCell"];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
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
    return rotyLeaders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBPlayerCell *statsCell = (HBPlayerCell*)[tableView dequeueReusableCellWithIdentifier:@"HBPlayerCell"];
    Player *plyr = rotyLeaders[indexPath.row];
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
    } else {
        stat1 = @"Rec";
        stat2 = @"Yds";
        stat3 = @"TD";
        stat4 = @"Fum";
        stat1Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsReceptions];
        stat2Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsRecYards];
        stat3Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsTD];
        stat4Value = [NSString stringWithFormat:@"%d",((PlayerWR*)plyr).statsFumbles];
        //[statsCell.stat1ValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    
    [statsCell.playerLabel setText:[plyr getInitialName]];
    
    if ([HBSharedUtils currentLeague].currentWeek >= 13 && roty != nil) {
        [statsCell.teamLabel setText:plyr.team.abbreviation];
    } else {
        [statsCell.teamLabel setText:[NSString stringWithFormat:@"%@ (%d votes)", plyr.team.abbreviation, [plyr getHeismanScore]]];
    }
    
    if ([statsCell.teamLabel.text containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [statsCell.playerLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        if ([HBSharedUtils currentLeague].currentWeek >= 13 && roty != nil) {
            if ([roty isEqual:plyr]) {
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
    Player *p = rotyLeaders[indexPath.row];
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
