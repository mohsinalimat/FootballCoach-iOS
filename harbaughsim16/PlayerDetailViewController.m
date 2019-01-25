//
//  StatDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Player.h"

#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerTE.h"
#import "PlayerOL.h"
#import "PlayerLB.h"
#import "PlayerDL.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "HexColors.h"
#import "STPopup.h"

@interface PlayerDetailViewController ()
{
    
}
@end

@implementation PlayerDetailViewController
-(instancetype)initWithPlayer:(Player*)player {
    self = [super init];
    if(self) {
        selectedPlayer = player;
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height * (3.0/4.0)));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Player";
    [playerDetailView.nameLabel setText:selectedPlayer.name];
    [playerDetailView.yrLabel setText:[NSString stringWithFormat:@"%@ - %@ (Ovr: %d)",[selectedPlayer getFullYearString],selectedPlayer.team.abbreviation,selectedPlayer.ratOvr]];
    [playerDetailView.posLabel setText:selectedPlayer.position];
    self.tableView.tableHeaderView = playerDetailView;
    stats = [selectedPlayer detailedStats:selectedPlayer.gamesPlayedSeason];
    careerStats = [selectedPlayer detailedCareerStats];
    ratings = [selectedPlayer detailedRatings];
    
    if ([selectedPlayer isInjured]) {
        [playerDetailView.medImageView setHidden:NO];
    } else {
        [playerDetailView.medImageView setHidden:YES];
    }
    
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [playerDetailView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
}

-(void)reloadAll {
    [playerDetailView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ((selectedPlayer.year > 4 && selectedPlayer.isGradTransfer == NO) || selectedPlayer.draftPosition != nil) {
        if (section == 1) {
            return @"Career Stats";
        } else {
            return @"Information";
        }
    } else {
        if (section == 1) {
            return @"Season Stats";
        } else if (section == 2) {
            return @"Career Stats";
        } else {
            return @"Information";
        }
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((selectedPlayer.year > 4 && selectedPlayer.isGradTransfer == NO) || selectedPlayer.draftPosition != nil) {
        if (section == 1) {
            return 36;
        } else {
            return 18;
        }
    } else {
        if (section != 0) {
            return 36;
        } else {
            return 18;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if ((selectedPlayer.year > 4 && selectedPlayer.isGradTransfer == NO) || selectedPlayer.draftPosition != nil) {
           return careerStats.allKeys.count;
        } else {
            return stats.allKeys.count;
        }
    } else if (section == 2) {
        return careerStats.allKeys.count;
    } else {
        return (ratings.count + 4);
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if ((selectedPlayer.year > 4 && selectedPlayer.isGradTransfer == NO) || selectedPlayer.draftPosition != nil) {
        if (section == 1) {
            return [NSString stringWithFormat:@"Over %ld games", (long)selectedPlayer.gamesPlayed];
        } else {
            return nil;
        }
    } else {
        if (section == 2) {
            return [NSString stringWithFormat:@"Over %ld games", (long)selectedPlayer.gamesPlayed];
        } else if (section == 1) {
            if ([selectedPlayer isKindOfClass:[PlayerDL class]] || [selectedPlayer isKindOfClass:[PlayerLB class]] || [selectedPlayer isKindOfClass:[PlayerCB class]] || [selectedPlayer isKindOfClass:[PlayerS class]]) {
                return [NSString stringWithFormat:@"Through %ld games this season (%ld games total)", (long)selectedPlayer.gamesPlayedSeason, (long)selectedPlayer.gamesPlayed];
            } else {
                return [NSString stringWithFormat:@"Through %ld games this season", (long)selectedPlayer.gamesPlayedSeason];
            }
        } else {
            return nil;
        }
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    
    return cell;
}

@end
