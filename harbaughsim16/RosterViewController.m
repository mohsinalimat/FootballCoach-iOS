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
#import "PlayerTE.h"
#import "PlayerDL.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerS.h"
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
#import "InjuryReportViewController.h"

#import "HexColors.h"
#import "STPopup.h"
#import "ZMJTipView.h"

#define FCTutorialEditDepthChart 1000
#define FCTutorialScrollToPosition 1001
#define FCTutorialInjuryToolbar 1002

@interface RosterViewController () <ZMJTipViewDelegate>
{
    Team *userTeam;
    STPopupController *popupController;
}
@end

@implementation RosterViewController

//MARK: ZMJTipViewDelegate
- (void)tipViewDidDimiss:(ZMJTipView *)tipView {
    // show new tips based on last shown tipview
    if (tipView.tag == FCTutorialEditDepthChart) {
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:@"Tap here to select a specific position to scroll down to view." preferences:nil delegate:self];
        editTip.tag = FCTutorialScrollToPosition;
        [editTip showAnimated:YES forItem:self.navigationItem.leftBarButtonItem withinSuperview:self.navigationController.view];
    }
}

- (void)tipViewDidSelected:(ZMJTipView *)tipView {
    // do nothing
}

-(void)manageEditing {
    if (self.editing) {
        [super setEditing:NO animated:NO];
        [self.tableView setEditing:NO animated:NO];
        [self.tableView reloadData];
        if (!userTeam.league.isHardMode) {
            [self.navigationItem.rightBarButtonItem setTitle:@"Reorder"];
            [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        }
        [[HBSharedUtils currentLeague] save];
    } else {
        [super setEditing:YES animated:YES];
        [self.tableView setEditing:YES animated:YES];
        [self.tableView reloadData];
        if (!userTeam.league.isHardMode) {
            [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
            [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        }
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *player;
    if (indexPath.section == 0) {
        player = [userTeam getQB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 1) {
        player = [userTeam getRB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 2) {
        player = [userTeam getWR:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 3) {
        player = [userTeam getTE:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 4) {
        player = [userTeam getOL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 5) {
        player = [userTeam getDL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 6) {
        player = [userTeam getLB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 7) {
        player = [userTeam getCB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 8) {
        player = [userTeam getS:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else {
        player = [userTeam getK:[NSNumber numberWithInteger:indexPath.row].intValue];
    }
    
    if (player.hasRedshirt || [player isInjured] || player.isTransfer) {
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    NSIndexPath *attemptIndexPath = proposedDestinationIndexPath;
    
    if (sourceIndexPath.section != proposedDestinationIndexPath.section) {
        NSInteger row = 0;
        if (sourceIndexPath.section < proposedDestinationIndexPath.section) {
            row = [tableView numberOfRowsInSection:sourceIndexPath.section] - 1;
        }
        attemptIndexPath = [NSIndexPath indexPathForRow:row inSection:sourceIndexPath.section];
    }
    
    Player *player;
    if (attemptIndexPath.section == 0) {
        player = [userTeam getQB:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else if (attemptIndexPath.section == 1) {
        player = [userTeam getRB:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else if (attemptIndexPath.section == 2) {
        player = [userTeam getWR:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else if (attemptIndexPath.section == 3) {
        player = [userTeam getTE:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else if (attemptIndexPath.section == 4) {
        player = [userTeam getOL:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else if (attemptIndexPath.section == 5) {
        player = [userTeam getDL:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else if (attemptIndexPath.section == 6) {
        player = [userTeam getLB:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else if (attemptIndexPath.section == 7) {
        player = [userTeam getCB:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else if (attemptIndexPath.section == 8) {
        player = [userTeam getS:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    } else {
        player = [userTeam getK:[NSNumber numberWithInteger:attemptIndexPath.row].intValue];
    }

    if (player.hasRedshirt || [player isInjured] || player.isTransfer) {
        return sourceIndexPath;
    }
    
    return attemptIndexPath;
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if(sourceIndexPath.section == destinationIndexPath.section) {
        if (destinationIndexPath.section == 0) {
            PlayerQB *qb = [userTeam getQB:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (qb != nil) {
                [userTeam.teamQBs removeObject:qb];
                [userTeam.teamQBs insertObject:qb atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamQBs copy] position:0];
            }
        } else if (destinationIndexPath.section == 1) {
            PlayerRB *rb = [userTeam getRB:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (rb != nil) {
                [userTeam.teamRBs removeObject:rb];
                [userTeam.teamRBs insertObject:rb atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamRBs copy] position:1];
            }
        } else if (destinationIndexPath.section == 2) {
            PlayerWR *wr = [userTeam getWR:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (wr != nil) {
                [userTeam.teamWRs removeObject:wr];
                [userTeam.teamWRs insertObject:wr atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamWRs copy] position:2];
            }
        } else if (destinationIndexPath.section == 3) {
            PlayerTE *te = [userTeam getTE:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (te != nil) {
                [userTeam.teamTEs removeObject:te];
                [userTeam.teamTEs insertObject:te atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamTEs copy] position:3];
            }
        } else if (destinationIndexPath.section == 4) {
            PlayerOL *ol = [userTeam getOL:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (ol != nil) {
                [userTeam.teamOLs removeObject:ol];
                [userTeam.teamOLs insertObject:ol atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamOLs copy] position:4];
            }
        } else if (destinationIndexPath.section == 5) {
            PlayerDL *f7 = [userTeam getDL:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (f7 != nil) {
                [userTeam.teamDLs removeObject:f7];
                [userTeam.teamDLs insertObject:f7 atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamDLs copy] position:5];
            }
        } else if (destinationIndexPath.section == 6) {
            PlayerLB *f7 = [userTeam getLB:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (f7 != nil) {
                [userTeam.teamLBs removeObject:f7];
                [userTeam.teamLBs insertObject:f7 atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamLBs copy] position:6];
            }
        } else if (destinationIndexPath.section == 7) {
            PlayerCB *cb = [userTeam getCB:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (cb != nil) {
                [userTeam.teamCBs removeObject:cb];
                [userTeam.teamCBs insertObject:cb atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamCBs copy] position:7];
            }
        } else if (destinationIndexPath.section == 8) {
            PlayerS *s = [userTeam getS:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (s != nil) {
                [userTeam.teamSs removeObject:s];
                [userTeam.teamSs insertObject:s atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamSs copy] position:8];
            }
        } else {
            PlayerK *k = [userTeam getK:[NSNumber numberWithInteger:sourceIndexPath.row].intValue];
            if (k != nil) {
                [userTeam.teamKs removeObject:k];
                [userTeam.teamKs insertObject:k atIndex:destinationIndexPath.row];
                [userTeam setStarters:[userTeam.teamKs copy] position:9];
            }
        }
    }
}

-(void)viewInjuryReport {
    InjuryReportViewController *injuryVC = [[InjuryReportViewController alloc] initWithTeam:userTeam];
    injuryVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:injuryVC] animated:YES completion:nil];
}

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewRosterOptions {
    UIAlertController *rosterOptionsController = [UIAlertController alertControllerWithTitle:@"Roster Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if (!self.editing) {
        [rosterOptionsController addAction:[UIAlertAction actionWithTitle:@"Edit Roster" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self manageEditing];
        }]];
    } else {
        [rosterOptionsController addAction:[UIAlertAction actionWithTitle:@"Save Roster Changes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self manageEditing];
        }]];
    }
    
    if ([HBSharedUtils currentLeague].isHardMode) {
        [rosterOptionsController addAction:[UIAlertAction actionWithTitle:@"View Injury Report" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self viewInjuryReport];
        }]];
    }
    
    [rosterOptionsController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:rosterOptionsController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Depth Chart";
    [self.tableView registerNib:[UINib nibWithNibName:@"HBRosterCell" bundle:nil] forCellReuseIdentifier:@"HBRosterCell"];
    userTeam = [HBSharedUtils currentLeague].userTeam;
    //[userTeam sortPlayers];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    if (userTeam.league.isHardMode) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(viewRosterOptions)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reorder" style:UIBarButtonItemStylePlain target:self action:@selector(manageEditing)];
    }

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(scrollToPositionGroup)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRoster) name:@"injuriesPosted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRoster) name:@"awardsPosted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRoster) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRoster) name:@"newSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reincarnateCoach" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadRoster) name:@"updateInjuryCount" object:nil];
    
    BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_ROSTER_TUTORIAL_SHOWN_KEY];
    if (!tutorialShown) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_ROSTER_TUTORIAL_SHOWN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //display intro screen
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            NSString *tipText = @"Tap here to edit your depth chart. When you're done, tap again to save your changes.";
            if ([HBSharedUtils currentLeague].isHardMode) {
                tipText = @"Tap here to view your roster options. From here, you can edit your depth chart and view your injury report for this week.";
            }
            ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:tipText preferences:nil delegate:self];
            editTip.tag = FCTutorialEditDepthChart;
            [editTip showAnimated:YES forItem:self.navigationItem.rightBarButtonItem withinSuperview:self.navigationController.view];
            
        });
    }
    [self.tableView setRowHeight:50];
    [self.tableView setEstimatedRowHeight:50];
}

-(void)reloadAll {
    [self.tableView reloadData];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadRoster {
    userTeam = [HBSharedUtils currentLeague].userTeam;
    if (userTeam.league.isHardMode) {
        if (userTeam.injuredPlayers.count > 0) {
            [self.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%lu", (long)userTeam.injuredPlayers.count];
        } else {
            [self.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
        }
    }
    [self.tableView reloadData];
}

-(void)scrollToPositionGroup {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View a specific position" message:@"Which position would you like to see?" preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.tableView.numberOfSections; i++) {
        NSString *position = @"";
        if (i == 0) {
            position = @"QB";
        } else if (i == 1) {
            position = @"RB";
        } else if (i == 2) {
            position = @"WR";
        } else if (i == 3) {
            position = @"TE";
        } else if (i == 4) {
            position = @"OL";
        } else if (i == 5) {
            position = @"DL";
        } else if (i == 6) {
            position = @"LB";
        } else if (i == 7) {
            position = @"CB";
        } else if (i == 8) {
            position = @"S";
        } else {
            position = @"K";
        }
        [alertController addAction:[UIAlertAction actionWithTitle:position style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([self.tableView numberOfRowsInSection:i] > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
        }]];
        
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return userTeam.teamQBs.count;
    } else if (section == 1) {
        return userTeam.teamRBs.count;
    } else if (section == 2) {
        return userTeam.teamWRs.count;
    } else if (section == 3) {
        return userTeam.teamTEs.count;
    } else if (section == 4) {
        return userTeam.teamOLs.count;
    } else if (section == 5) {
        return userTeam.teamDLs.count;
    } else if (section == 6) {
        return userTeam.teamLBs.count;
    } else if (section == 7) {
        return userTeam.teamCBs.count;
    } else if (section == 8) {
        return userTeam.teamSs.count;
    } else {
        return userTeam.teamKs.count;
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [NSString stringWithFormat:@"QB (%ld)", (long)userTeam.teamQBs.count];
    } else if (section == 1) {
        return [NSString stringWithFormat:@"RB (%ld)", (long)userTeam.teamRBs.count];
    } else if (section == 2) {
        return [NSString stringWithFormat:@"WR (%ld)", (long)userTeam.teamWRs.count];
    } else if (section == 3) {
        return [NSString stringWithFormat:@"TE (%ld)", (long)userTeam.teamTEs.count];
    } else if (section == 4) {
        return [NSString stringWithFormat:@"OL (%ld)", (long)userTeam.teamOLs.count];
    } else if (section == 5) {
        return [NSString stringWithFormat:@"DL (%ld)", (long)userTeam.teamDLs.count];
    } else if (section == 6) {
        return [NSString stringWithFormat:@"LB (%ld)", (long)userTeam.teamLBs.count];
    } else if (section == 7) {
        return [NSString stringWithFormat:@"CB (%ld)", (long)userTeam.teamCBs.count];
    } else if (section == 8) {
        return [NSString stringWithFormat:@"S (%ld)", (long)userTeam.teamSs.count];
    } else {
        return [NSString stringWithFormat:@"K (%ld)", (long)userTeam.teamKs.count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBRosterCell *cell = (HBRosterCell*)[tableView dequeueReusableCellWithIdentifier:@"HBRosterCell" forIndexPath:indexPath];
    Player *player;
    if (indexPath.section == 0) {
        player = [userTeam getQB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 1) {
        player = [userTeam getRB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 2) {
        player = [userTeam getWR:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 3) {
        player = [userTeam getTE:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 4) {
        player = [userTeam getOL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 5) {
        player = [userTeam getDL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 6) {
        player = [userTeam getLB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 7) {
        player = [userTeam getCB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 8) {
        player = [userTeam getS:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else {
        player = [userTeam getK:[NSNumber numberWithInteger:indexPath.row].intValue];
    }
    [cell.nameLabel setText:[player getInitialName]];
    [cell.yrLabel setText:[player getYearString]];
    [cell.ovrLabel setText:[NSString stringWithFormat:@"%d", player.ratOvr]];
    
    if ([player isInjured]) {
        [cell.medImageView setHidden:NO];
    } else {
        [cell.medImageView setHidden:YES];
    }
    
    if (player.hasRedshirt || [player isInjured]) {
        [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
    } else if (player.isTransfer) {
        [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
        [cell.yrLabel setText:@"XFER"];
    } else if (player.isHeisman || player.isROTY) {
        [cell.nameLabel setTextColor:[HBSharedUtils champColor]];
    } else if (player.isAllAmerican) {
        [cell.nameLabel setTextColor:[UIColor orangeColor]];
    } else if (player.isAllConference) {
         [cell.nameLabel setTextColor:[HBSharedUtils successColor]];
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row < 2) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row < 2) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else if (indexPath.section == 4) {
            if (indexPath.row < 5) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else if (indexPath.section == 5) {
            if (indexPath.row < 4) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else if (indexPath.section == 6) {
            if (indexPath.row < 3) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else if (indexPath.section == 7) {
            if (indexPath.row < 3) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else if (indexPath.section == 8) {
            if (indexPath.row == 0) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        } else {
            if (indexPath.row == 0) {
                [cell.nameLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.nameLabel setTextColor:[UIColor blackColor]];
            }
        }
    }
    
    return cell;
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Player *player;
    if (indexPath.section == 0) {
        player = [userTeam getQB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 1) {
        player = [userTeam getRB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 2) {
        player = [userTeam getWR:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 3) {
        player = [userTeam getTE:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 4) {
        player = [userTeam getOL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 5) {
        player = [userTeam getDL:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 6) {
        player = [userTeam getLB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 7) {
        player = [userTeam getCB:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else if (indexPath.section == 8) {
        player = [userTeam getS:[NSNumber numberWithInteger:indexPath.row].intValue];
    } else {
        player = [userTeam getK:[NSNumber numberWithInteger:indexPath.row].intValue];
    }
    
    if (indexPath.section == 0) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerQBDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 1) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerRBDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 2) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerWRDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 3) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerTEDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 4) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerOLDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 5) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerDLDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 6) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerLBDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 7) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerCBDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 8) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerSDetailViewController alloc] initWithPlayer:player]];
    } else if (indexPath.section == 9) {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerKDetailViewController alloc] initWithPlayer:player]];
    } else {
        popupController = [[STPopupController alloc] initWithRootViewController:[[PlayerDetailViewController alloc] initWithPlayer:player]];
    }
    [popupController.navigationBar setDraggable:YES];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

@end
