//
//  MockDraftViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/15/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "MockDraftViewController.h"
#import "League.h"
#import "Team.h"
#import "Player.h"
#import "PlayerDetailViewController.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerF7.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "HexColors.h"

@interface MockDraftViewController ()
{
    NSArray *draftRounds;
    NSMutableArray *round1;
    NSMutableArray *round2;
    NSMutableArray *round3;
    NSMutableArray *round4;
    NSMutableArray *round5;
    NSMutableArray *round6;
    NSMutableArray *round7;
    Player *heisman;
}
@end

@implementation MockDraftViewController

-(void)viewDraftSummary {
    NSMutableString *draftSummary = [NSMutableString string];
    NSMutableArray *userDraftees = [NSMutableArray array];
    Team *userTeam = [HBSharedUtils getLeague].userTeam;
    for (Player *p in userTeam.teamQBs) {
        if (p.draftPosition != nil) {
            [userDraftees addObject:p];
        }
    }
    
    for (Player *p in userTeam.teamRBs) {
        if (p.draftPosition != nil) {
            [userDraftees addObject:p];
        }
    }
    
    for (Player *p in userTeam.teamWRs) {
        if (p.draftPosition != nil) {
            [userDraftees addObject:p];
        }
    }
    
    for (Player *p in userTeam.teamOLs) {
        if (p.draftPosition != nil) {
            [userDraftees addObject:p];
        }
    }
    
    for (Player *p in userTeam.teamF7s) {
        if (p.draftPosition != nil) {
            [userDraftees addObject:p];
        }
    }
    
    for (Player *p in userTeam.teamCBs) {
        if (p.draftPosition != nil) {
            [userDraftees addObject:p];
        }
    }
    
    for (Player *p in userTeam.teamSs) {
        if (p.draftPosition != nil) {
            [userDraftees addObject:p];
        }
    }
    
    for (Player *p in userTeam.teamKs) {
        if (p.draftPosition != nil) {
            [userDraftees addObject:p];
        }
    }
    
    [userDraftees sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player *)obj1;
        Player *b = (Player *)obj2;
        NSInteger aDraftRound = [a.draftPosition[@"round"] integerValue];
        NSInteger bDraftRound = [b.draftPosition[@"round"] integerValue];
        NSInteger aDraftPick = [a.draftPosition[@"pick"] integerValue];
        NSInteger bDraftPick = [b.draftPosition[@"pick"] integerValue];
        
        if (aDraftRound < bDraftRound) {
            return -1;
        } else if (bDraftRound < aDraftRound) {
            return 1;
        } else {
            if (aDraftPick < bDraftPick) {
                return -1;
            } else if (bDraftPick < aDraftPick) {
                return 1;
            } else {
                return 0;
            }
        }
    }];
    
    for (Player *p in userDraftees) {
        [draftSummary appendFormat:@"Rd %@, Pk %@: %@ %@ (OVR: %li)\n", p.draftPosition[@"round"], p.draftPosition[@"pick"], p.position, [p getInitialName], (long)p.ratOvr];
    }
    
    if (draftSummary.length == 0) {
        [draftSummary appendString:@"No players drafted"];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Draft Summary", [HBSharedUtils getLeague].userTeam.abbreviation] message:draftSummary preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setToolbarItems:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],[[UIBarButtonItem alloc] initWithTitle:@"View Draft Summary" style:UIBarButtonItemStylePlain target:self action:@selector(viewDraftSummary)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]]];
    self.navigationController.toolbarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)changeRounds {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"View picks from a specific round" message:@"Which round would you like to see?" preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < 7; i++) {
        NSString *week = [NSString stringWithFormat:@"Round %ld", (long)(i + 1)];

        [alertController addAction:[UIAlertAction actionWithTitle:week style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }]];
        
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    draftRounds = [[HBSharedUtils getLeague] allDraftedPlayers];
    round1 = draftRounds[0];
    round2 = draftRounds[1];
    round3 = draftRounds[2];
    round4 = draftRounds[3];
    round5 = draftRounds[4];
    round6 = draftRounds[5];
    round7 = draftRounds[6];
    
    if (!heisman) {
        NSArray *candidates = [[HBSharedUtils getLeague] calculateHeismanCandidates];
        if (candidates.count > 0) {
            heisman = candidates[0];
        }
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(changeRounds)];
    self.title = [NSString stringWithFormat:@"%ld Pro Draft", (long)(2016 + [HBSharedUtils getLeague].leagueHistoryDictionary.count)];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Round %ld", (long)(1 + section)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return round1.count;
    } else if (section == 1) {
        return round2.count;
    } else if (section == 2) {
        return round3.count;
    } else if (section == 3) {
        return round4.count;
    } else if (section == 4) {
        return round5.count;
    } else if (section == 5) {
        return round6.count;
    } else {
        return round7.count;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
    
    Player *p;
    if (indexPath.section == 0) {
        p = round1[indexPath.row];
    } else if (indexPath.section == 1) {
        p = round2[indexPath.row];
    } else if (indexPath.section == 2) {
        p = round3[indexPath.row];
    } else if (indexPath.section == 3) {
        p = round4[indexPath.row];
    } else if (indexPath.section == 4) {
        p = round5[indexPath.row];
    } else if (indexPath.section == 5) {
        p = round6[indexPath.row];
    } else {
        p = round7[indexPath.row];
    }
    NSMutableAttributedString *attName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld: ",(long)(1 + indexPath.row)] attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    
    [attName appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", p.position] attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    UIColor *nameColor = [UIColor blackColor];
    if ([p.team isEqual:[HBSharedUtils getLeague].userTeam]) {
        nameColor = [HBSharedUtils styleColor];
    } else {
        if (heisman != nil) {
            if ([heisman isEqual:p]) {
                nameColor = [HBSharedUtils champColor];
            } else {
                nameColor = [UIColor blackColor];
            }
        }
    }
    
    [attName appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", [p getInitialName]] attributes:@{NSForegroundColorAttributeName : nameColor}]];
    [attName appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", [p getYearString]] attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    [cell.textLabel setAttributedText:attName];
    [cell.detailTextLabel setText:[p.team strRep]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Player *p;
    if (indexPath.section == 0) {
        p = round1[indexPath.row];
    } else if (indexPath.section == 1) {
        p = round2[indexPath.row];
    } else if (indexPath.section == 2) {
        p = round3[indexPath.row];
    } else if (indexPath.section == 3) {
        p = round4[indexPath.row];
    } else if (indexPath.section == 4) {
        p = round5[indexPath.row];
    } else if (indexPath.section == 5) {
        p = round6[indexPath.row];
    } else {
        p = round7[indexPath.row];
    }
    [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:p] animated:YES];
}



@end
