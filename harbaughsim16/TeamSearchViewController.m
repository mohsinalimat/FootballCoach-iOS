//
//  StatsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamSearchViewController.h"
#import "TeamViewController.h"
#import "Team.h"
#import "HBSharedUtils.h"
#import "League.h"

@interface TeamSearchViewController () <UISearchBarDelegate, UIScrollViewDelegate>
{
    NSMutableArray *teams;
    Team *selectedTeam;
    UISearchBar *navSearchBar;
    NSString *searchString;
}
@end

@implementation TeamSearchViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    teams = [NSMutableArray array];
    navSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navSearchBar setPlaceholder:@"Search Teams"];
    [navSearchBar setDelegate:self];
    [navSearchBar setBarStyle:UIBarStyleDefault];
    [navSearchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [navSearchBar setKeyboardType:UIKeyboardTypeAlphabet];
    [navSearchBar setReturnKeyType:UIReturnKeySearch];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor lightTextColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    
    self.navigationItem.titleView = navSearchBar;
    //[navSearchBar becomeFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [navSearchBar endEditing:YES];
}

-(void)refreshData {
    [teams removeAllObjects];
    if (searchString.length > 0 || ![searchString isEqualToString:@""]) {
        for (Team *t in [HBSharedUtils getLeague].teamList) {
            if ([t.name.lowercaseString containsString:searchString.lowercaseString] || [t.abbreviation.lowercaseString containsString:searchString.lowercaseString] || [t.conference.lowercaseString containsString:searchString.lowercaseString]) {
                if (![teams containsObject:t]) {
                    [teams addObject:t];
                }
            }
        }
    }
    [self.tableView reloadData];
}

-(void)search {
    [self searchBarSearchButtonClicked:navSearchBar];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchString = searchBar.text;
    [self refreshData];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchString = searchBar.text;
    [self refreshData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return teams.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    Team *t = teams[indexPath.row];
    [cell.textLabel setText:t.name];
    [cell.detailTextLabel setText:t.abbreviation];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:teams[indexPath.row]] animated:YES];
}

@end
