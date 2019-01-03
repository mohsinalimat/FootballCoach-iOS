//
//  AvailableJobsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/2/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "AvailableJobsViewController.h"

#import "League.h"
#import "Team.h"

#import "CFCRecruitCell.h"
#import "NSArray+Uniqueness.h"

#import "STPopup.h"
#import "HexColors.h"
#import "RMessage.h"
#import "UIScrollView+EmptyDataSet.h"

@interface AvailableJobsViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
{
    STPopupController *popupController;
    NSMutableArray *availableJobs;
    NSMutableArray *currentJobs;
    BOOL sortedByPrestige;
    
    HeadCoach *userCoach;
}

@end

@implementation AvailableJobsViewController

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    userCoach = [[HBSharedUtils currentLeague].userTeam getCurrentHC];
    

}

-(void)generateCoachingOffers {
    NSMutableArray *openJobs = [NSMutableArray array];
    for (Team *t in [HBSharedUtils currentLeague].teamList) {
        if (![t isEqual:[HBSharedUtils currentLeague].userTeam]
            && (t.coachFired || t.coachRetired || t.coaches.count == 0)
            && ![openJobs containsObject:t]) {
            [openJobs addObject:t];
        }
    }
    
    
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentJobs.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
