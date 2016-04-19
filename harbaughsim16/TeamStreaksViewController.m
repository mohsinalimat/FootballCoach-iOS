//
//  TeamStreaksViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamStreaksViewController.h"
#import "Team.h"
#import "TeamStreak.h"
#import "TeamViewController.h"

@interface TeamStreaksViewController () <UISearchBarDelegate, UIScrollViewDelegate>
{
    NSMutableArray *streaks;
    NSMutableDictionary *streakDict;
    Team *selectedTeam;
    UISearchBar *navSearchBar;
    NSString *searchString;
}
@end

@implementation TeamStreaksViewController

-(instancetype)initWithTeam:(Team*)team {
    self = [super init];
    if (self) {
        selectedTeam = team;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    streakDict = [selectedTeam.streaks copy];
    streaks = [NSMutableArray arrayWithArray:streakDict.allValues];
    [streaks sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        TeamStreak *a = (TeamStreak*)obj1;
        TeamStreak *b = (TeamStreak*)obj2;
        return [a.opponent.name compare:b.opponent.name];
    }];

    navSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navSearchBar setPlaceholder:@"Search Streaks"];
    [navSearchBar setDelegate:self];
    [navSearchBar setBarStyle:UIBarStyleDefault];
    [navSearchBar setSearchBarStyle:UISearchBarStyleMinimal];
    [navSearchBar setKeyboardType:UIKeyboardTypeAlphabet];
    [navSearchBar setReturnKeyType:UIReturnKeySearch];
    [navSearchBar setTintColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
    
    self.navigationItem.titleView = navSearchBar;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reloadTeams" object:nil];
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [navSearchBar endEditing:YES];
}

-(void)refreshData {
    [streaks removeAllObjects];
    if (searchString.length > 0 || ![searchString isEqualToString:@""]) {
        for (TeamStreak *ts in streakDict.allValues) {
            if ([ts.opponent.abbreviation.lowercaseString containsString:searchString.lowercaseString]
                || [ts.opponent.name.lowercaseString containsString:searchString.lowercaseString]
                || [ts.opponent.conference.lowercaseString containsString:searchString.lowercaseString]) {
                if (![streaks containsObject:ts]) {
                    [streaks addObject:ts];
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
    return streaks.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    TeamStreak *ts = streaks[indexPath.row];
    [cell.textLabel setText:ts.opponent.name];
    [cell.detailTextLabel setText:[ts stringRepresentation]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeamStreak *ts = streaks[indexPath.row];
    [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:ts.opponent] animated:YES];
}


@end
