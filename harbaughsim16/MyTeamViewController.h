//
//  MyTeamViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/16/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTableViewController.h"
#import "CFCTeamHistoryView.h"
#import "STPopup.h"
@class Team;

@interface MyTeamViewController : FCTableViewController
{
    IBOutlet CFCTeamHistoryView *teamHeaderView;
    STPopupController *popupController;
    Team *userTeam;
    NSArray *stats;
}
-(void)presentIntro;
-(void)setupTeamHeader;
-(void)resetForNewSeason;
-(void)reloadStats;
-(void)openSettings;
@end
