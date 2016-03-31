//
//  HeismanHistoryViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "HeismanHistoryViewController.h"
#import "Team.h"

@interface HeismanHistoryViewController ()
{
    NSArray *heismanHistory;
}
@end

@implementation HeismanHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    heismanHistory = [HBSharedUtils getLeague].heismanHistory;
    self.title = @"POTY History";
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return heismanHistory.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld",(long) (2016 + indexPath.row)]];
    [cell.detailTextLabel setText:heismanHistory[indexPath.row]];
    if([cell.detailTextLabel.text containsString:[HBSharedUtils getLeague].userTeam.abbreviation]) {
        [cell.detailTextLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    return cell;
}

@end
