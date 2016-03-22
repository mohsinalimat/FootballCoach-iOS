//
//  LeagueHistoryController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "LeagueHistoryController.h"
#import "LeagueYearViewController.h"

@interface LeagueHistoryController ()
{
    NSArray *leagueHistory;
}
@end

@implementation LeagueHistoryController

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    leagueHistory = [HBSharedUtils getLeague].leagueHistory;
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    self.title = @"League History";
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
    return leagueHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *leagueYear = leagueHistory[indexPath.row];
    [self.navigationController pushViewController:[[LeagueYearViewController alloc] initWithYear:[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)] top10:leagueYear] animated:YES];
}


@end
