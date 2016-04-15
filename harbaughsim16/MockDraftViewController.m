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
}
@end

@implementation MockDraftViewController

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.title = [NSString stringWithFormat:@"%ld Pro Draft", (long)(2016 + [HBSharedUtils getLeague].leagueHistory.count)];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    players = [NSMutableArray array];
    round1 = [NSMutableArray array];
    round2 = [NSMutableArray array];
    
    NSArray *teamList = [HBSharedUtils getLeague].teamList;
    for (Team *t in teamList) {
        [t getPlayersLeaving];
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
    
    for (int i = 0; i < 32; i++) {
        [round1 addObject:players[i]];
    }
    
    for (int j = 32; j < 64; j++) {
        [round2 addObject:players[j]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"ROUND 1";
    } else {
        return @"ROUND 2";
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return round1.count;
    } else {
        return round2.count;
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
    } else {
        p = round2[indexPath.row];
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
    } else {
        p = round2[indexPath.row];
    }
    [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:p] animated:YES];
}



@end
