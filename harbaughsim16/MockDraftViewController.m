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
    NSMutableArray *players;
    NSMutableArray *round1;
    NSMutableArray *round2;
    NSMutableArray *round3;
    NSMutableArray *round4;
    NSMutableArray *round5;
    NSMutableArray *round6;
    NSMutableArray *round7;
}
@end

@implementation MockDraftViewController

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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(changeRounds)];
    self.title = [NSString stringWithFormat:@"%ld Pro Draft", (long)(2016 + [HBSharedUtils getLeague].leagueHistory.count)];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    players = [NSMutableArray array];
    round1 = [NSMutableArray array];
    round2 = [NSMutableArray array];
    round3 = [NSMutableArray array];
    round4 = [NSMutableArray array];
    round5 = [NSMutableArray array];
    round6 = [NSMutableArray array];
    round7 = [NSMutableArray array];
    
    NSArray *teamList = [HBSharedUtils getLeague].teamList;
    for (Team *t in teamList) {
        if (!t.isUserControlled) {
            [t getPlayersLeaving];
        }
        [players addObjectsFromArray:t.playersLeaving];
    }
    Player *heisman = [[HBSharedUtils getLeague] getHeisman][0];
    
    [players sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        int adjADraftGrade = 0;
        int adjBDraftGrade = 0;
        int adjAHeisScore = 100 * ((double)[a getHeismanScore]/(double)[heisman getHeismanScore]);
        int adjBHeisScore = 100 * ((double)[b getHeismanScore]/(double)[heisman getHeismanScore]);
        
        if ([a isKindOfClass:[PlayerQB class]]) {
            PlayerQB *p = (PlayerQB*)a;
            
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratPassAcc + p.ratPassEva + p.ratPassPow + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerRB class]]) {
            PlayerRB *p = (PlayerRB*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRushEva + p.ratRushPow + p.ratRushSpd + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerWR class]]) {
            PlayerWR *p = (PlayerWR*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRecCat + p.ratRecEva + p.ratRecSpd + adjAHeisScore) / 6.0) * 12.0);
        } else if ([a isKindOfClass:[PlayerOL class]]) {
            PlayerOL *p = (PlayerOL*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratOLBkP + p.ratOLPow + p.ratOLBkR) / 5.0) * 11.0);
        } else if ([a isKindOfClass:[PlayerF7 class]]) {
            PlayerF7 *p = (PlayerF7*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratF7Pas + p.ratF7Pow + p.ratF7Rsh) / 5.0) * 10.5);
        } else if ([a isKindOfClass:[PlayerCB class]]) {
            PlayerCB *p = (PlayerCB*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratCBCov + p.ratCBSpd + p.ratCBTkl) / 5.0) * 10.5);
        } else if ([a isKindOfClass:[PlayerS class]]) {
            PlayerS *p = (PlayerS*)a;
            adjADraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratSCov + p.ratSSpd + p.ratSTkl) / 5.0) * 10.5);
        } else {
            PlayerK *k = (PlayerK*)a;
            adjADraftGrade = (int)(((double)(k.ratOvr + k.ratFootIQ + k.ratKickPow + k.ratKickAcc + k.ratKickFum) / 11.0) * 12.0);
        }
        
        
        if ([b isKindOfClass:[PlayerQB class]]) {
            PlayerQB *p = (PlayerQB*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratPassAcc + p.ratPassEva + p.ratPassPow + adjBHeisScore) / 6.0) * 12.0);
        } else if ([b isKindOfClass:[PlayerRB class]]) {
            PlayerRB *p = (PlayerRB*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRushEva + p.ratRushPow + p.ratRushSpd  + adjBHeisScore) / 6.0) * 12.0);
        } else if ([b isKindOfClass:[PlayerWR class]]) {
            PlayerWR *p = (PlayerWR*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratRecCat + p.ratRecEva + p.ratRecSpd + adjBHeisScore) / 6.0) * 12.0);
        } else if ([b isKindOfClass:[PlayerOL class]]) {
            PlayerOL *p = (PlayerOL*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratOLBkP + p.ratOLPow + p.ratOLBkR) / 5.0) * 11.0);
        } else if ([b isKindOfClass:[PlayerF7 class]]) {
            PlayerF7 *p = (PlayerF7*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratF7Pas + p.ratF7Pow + p.ratF7Rsh) / 5.0) * 10.5);
        } else if ([b isKindOfClass:[PlayerCB class]]) {
            PlayerCB *p = (PlayerCB*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratCBCov + p.ratCBSpd + p.ratCBTkl) / 5.0) * 10.5);
        } else if ([b isKindOfClass:[PlayerS class]]) {
            PlayerS *p = (PlayerS*)b;
            adjBDraftGrade = (int)(((double)(p.ratOvr + p.ratFootIQ + p.ratSCov + p.ratSSpd + p.ratSTkl) / 5.0) * 10.5);
        } else  {
            PlayerK *k = (PlayerK*)b;
            adjBDraftGrade = (int)(((double)(k.ratOvr + k.ratFootIQ + k.ratKickPow + k.ratKickAcc + k.ratKickFum) / 11.0) * 12.0);
        }
        
        return adjADraftGrade > adjBDraftGrade ? -1 : adjADraftGrade == adjBDraftGrade ? 0 : 1;
    }];
    NSLog(@"TOTAL DRAFTABLE PLAYERS: %ld", players.count);
    int round = 1;
    for (int i = 0; i < 32; i++) {
        Player *p = players[i];
        if (p.year == 3) {
            NSLog(@"JUNIOR: %@ ROUND: %ld", p, (long)round);
        }
        [round1 addObject:p];
    }
    round++;
    
    for (int j = 32; j < 64; j++) {
        Player *p = players[j];
        if (p.year == 3) {
            NSLog(@"JUNIOR: %@ ROUND: %ld", p, (long)round);
        }
        [round2 addObject:p];
    }
    round++;
    
    for (int k = 64; k < 96; k++) {
        Player *p = players[k];
        if (p.year == 3) {
            NSLog(@"JUNIOR: %@ ROUND: %ld", p, (long)round);
        }
        [round3 addObject:p];
    }
    round++;
    
    for (int r = 96; r < 128; r++) {
        Player *p = players[r];
        if (p.year == 3) {
            NSLog(@"JUNIOR: %@ ROUND: %ld", p, (long)round);
        }
        [round4 addObject:p];
    }
    round++;
    
    for (int c = 128; c < 160; c++) {
        Player *p = players[c];
        if (p.year == 3) {
            NSLog(@"JUNIOR: %@ ROUND: %ld", p, (long)round);
        }
        [round5 addObject:p];
    }
    round++;
    
    for (int a = 160; a < 192; a++) {
        Player *p = players[a];
        if (p.year == 3) {
            NSLog(@"JUNIOR: %@ ROUND: %ld", p, (long)round);
        }
        [round6 addObject:p];
    }
    round++;
    
    for (int b = 192; b < 224; b++) {
        Player *p = players[b];
        if (p.year == 3) {
            NSLog(@"JUNIOR: %@ ROUND: %ld", p, (long)round);
        }
        [round7 addObject:p];
    }
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
        if ([HBSharedUtils getLeague].currentWeek >= 13 && [[[HBSharedUtils getLeague] getHeisman][0] isEqual:p]) {
            nameColor = [UIColor hx_colorWithHexRGBAString:@"#eeb211"];
        } else {
            nameColor = [UIColor blackColor];
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
