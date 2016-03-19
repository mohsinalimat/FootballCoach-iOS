//
//  StatDetailViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "PlayerDetailViewController.h"
#import "Player.h"

@interface PlayerDetailViewController ()
{
    Player *selectedPlayer;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *yrLabel;
    IBOutlet UILabel *statsLabel;
}
@end

@implementation PlayerDetailViewController
-(instancetype)initWithPlayer:(Player*)player {
    self = [super init];
    if(self) {
        selectedPlayer = player;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Player";
    [nameLabel setText:selectedPlayer.name];
    [yrLabel setText:[selectedPlayer getYearString]];
    NSMutableString *stats = [NSMutableString string];
    for (int i = 0; i < [selectedPlayer getDetailedStatsList:[HBSharedUtils getLeague].currentWeek].count; i++) {
        [stats appendString:[selectedPlayer getDetailedStatsList:[HBSharedUtils getLeague].currentWeek][i]];
    }
    if (stats.length == 0) {
        [statsLabel setText:@"Nothing yet"];
        [statsLabel setTextColor:[UIColor lightTextColor]];
    } else {
        [statsLabel setText:stats];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
