//
//  TeamRecordsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/30/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamRecordsViewController.h"
#import "Team.h"
#import "HBRecordCell.h"
#import "Player.h"
#import "Record.h"
#import "PlayerDetailViewController.h"

@interface TeamRecordsViewController ()
{
    Team *selectedTeam;
    NSArray *records;
    NSInteger selectedIndex;
}
@end

@implementation TeamRecordsViewController
-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithTeam:(Team*)team {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        selectedTeam = team;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBRecordCell" bundle:nil] forCellReuseIdentifier:@"HBRecordCell"];
    [self.tableView setRowHeight:87];
    [self.tableView setEstimatedRowHeight:87];
    //add seg control as title view
    //if seg control index == 0 - display single season records
    //if seg control index == 1 - display career records
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"Season", @"Career"]];
    [segControl setTintColor:[UIColor whiteColor]];
    [segControl setSelectedSegmentIndex:0];
    records = [selectedTeam singleSeasonRecords];
    selectedIndex = 0;
    [segControl addTarget:self action:@selector(switchViews:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segControl;
}

-(void)switchViews:(UISegmentedControl*)sender {
    selectedIndex = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == 0) {
        records = [selectedTeam singleSeasonRecords];
    } else {
        records = [selectedTeam careerRecords];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return records.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (selectedIndex == 0) {
        return @"Single Season";
    } else {
        return @"Career";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBRecordCell"];
    Record *curRecord = records[indexPath.row];
    [cell.statLabel setText:[NSString stringWithFormat:@"%ld", (long)curRecord.statistic]];
    [cell.yearLabel setText:[NSString stringWithFormat:@"%ld", (long)curRecord.year]];
    if (curRecord.holder) {
        [cell.playerLabel setText:[curRecord.holder getInitialName]];
        [cell.teamLabel setText:curRecord.holder.team.abbreviation];
    } else {
        [cell.playerLabel setText:@"No record holder"];
        [cell.teamLabel setText:@"N/A"];
    }
    [cell.titleLabel setText:curRecord.title];
    
    return cell;
}

@end
