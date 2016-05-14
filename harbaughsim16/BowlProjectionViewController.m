//
//  BowlProjectionViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/25/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "BowlProjectionViewController.h"
#import "HBScoreCell.h"
#import "GameDetailViewController.h"
#import "Team.h"
#import "Game.h"

@interface BowlProjectionViewController ()
{
    NSArray *bowlPredictions;
}
@end

@implementation BowlProjectionViewController

-(instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([HBSharedUtils getLeague].currentWeek >= 14) {
       self.title = @"Bowl Results";
    } else {
        self.title = @"Bowl Predictions";
    }
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    bowlPredictions = [[HBSharedUtils getLeague] getBowlPredictions];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBScoreCell" bundle:nil] forCellReuseIdentifier:@"HBScoreCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    Game *bowl = bowlPredictions[section];
    if ([bowl.gameName isEqualToString:@"NCG"]) {
        return @"National Championship Game";
    } else if ([bowl.gameName isEqualToString:@"Semis, 1v4"]) {
        return @"National Semifinal - #1 vs #4";
    } else if ([bowl.gameName isEqualToString:@"Semis, 2v3"]) {
        return @"National Semifinal - #2 vs #3";
    } else {
        return bowl.gameName;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 50;
    } else {
        return 75;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 48;
    } else {
        return 24;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 24;
}

/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    CGFloat height = 18;
    CGFloat y = 0;
    if (section == 0)
    {
        height = 36;
        y = 5;
    }
    
    myLabel.frame = CGRectMake(18, y, [UIScreen mainScreen].bounds.size.width, height);
    myLabel.font = [UIFont systemFontOfSize:15.0];
    [myLabel setTextColor:[UIColor lightTextColor]];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.text = myLabel.text.uppercaseString;
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return bowlPredictions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Game *bowl = bowlPredictions[indexPath.section];
    if (indexPath.row == 0 || indexPath.row == 1) {
        HBScoreCell *cell = (HBScoreCell*)[tableView dequeueReusableCellWithIdentifier:@"HBScoreCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            NSString *awayRank = @"";
            if (bowl.awayTeam.rankTeamPollScore < 26 && bowl.awayTeam.rankTeamPollScore > 0) {
                awayRank = [NSString stringWithFormat:@"#%d ",bowl.awayTeam.rankTeamPollScore];
            }
            [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",awayRank,bowl.awayTeam.name]];
            [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.awayTeam.wins,bowl.awayTeam.losses,(long)[bowl.awayTeam calculateConfWins], (long)[bowl.awayTeam calculateConfLosses],bowl.awayTeam.conference]];
            [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
            if (bowl.homeScore < bowl.awayScore) {
                [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
            } else {
                if ([bowl.awayTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                    [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                    [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                    [cell.scoreLabel setTextColor:[UIColor blackColor]];
                }
            }
        } else {
            NSString *homeRank = @"";
            if (bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
            }
            [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,bowl.homeTeam.name]];
            [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d (%ld-%ld) %@",bowl.homeTeam.wins,bowl.homeTeam.losses,(long)[bowl.homeTeam calculateConfWins], (long)[bowl.homeTeam calculateConfLosses],bowl.homeTeam.conference]];
            [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
            if (bowl.homeScore > bowl.awayScore) {
                [cell.teamNameLabel setTextColor:[HBSharedUtils successColor]];
                [cell.scoreLabel setTextColor:[HBSharedUtils successColor]];
            } else {
                if ([bowl.homeTeam isEqual:[HBSharedUtils getLeague].userTeam]) {
                    [cell.teamNameLabel setTextColor:[HBSharedUtils styleColor]];
                    [cell.scoreLabel setTextColor:[HBSharedUtils styleColor]];
                } else {
                    [cell.teamNameLabel setTextColor:[UIColor blackColor]];
                    [cell.scoreLabel setTextColor:[UIColor blackColor]];
                }
            }
        }
        return cell;

    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            [cell.textLabel setTextColor:self.view.tintColor];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        
        if (bowl.hasPlayed) {
            [cell.textLabel setText:@"View Game"];
        } else {
            [cell.textLabel setText:@"Preview Matchup"];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        Game *bowl = bowlPredictions[indexPath.section];
        [self.navigationController pushViewController:[[GameDetailViewController alloc] initWithGame:bowl] animated:YES];
    }
}
@end
