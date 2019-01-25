//
//  StatDetailViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Player;
#import "FCTableViewController.h"
#import "HBPlayerDetailView.h"

@interface PlayerDetailViewController : FCTableViewController
{
    Player *selectedPlayer;
    NSDictionary *stats;
    NSDictionary *careerStats;
    NSDictionary *ratings;
    IBOutlet HBPlayerDetailView *playerDetailView;
}
-(instancetype)initWithPlayer:(Player*)player;
@end
