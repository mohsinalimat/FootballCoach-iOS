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
            [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d, %@",bowl.awayTeam.wins,bowl.awayTeam.losses,bowl.awayTeam.conference]];
            [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.awayScore]];
        } else {
            NSString *homeRank = @"";
            if (bowl.homeTeam.rankTeamPollScore < 26 && bowl.homeTeam.rankTeamPollScore > 0) {
                homeRank = [NSString stringWithFormat:@"#%d ",bowl.homeTeam.rankTeamPollScore];
            }
            [cell.teamNameLabel setText:[NSString stringWithFormat:@"%@%@",homeRank,bowl.homeTeam.name]];
            [cell.teamAbbrevLabel setText:[NSString stringWithFormat:@"%d-%d, %@",bowl.homeTeam.wins,bowl.homeTeam.losses,bowl.homeTeam.conference]];
            [cell.scoreLabel setText:[NSString stringWithFormat:@"%d",bowl.homeScore]];
        }
        return cell;

    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ButtonCell"];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ButtonCell"];
        }
        
        [cell.textLabel setText:@"View Game"];
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setTextColor:self.view.tintColor];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
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
