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

@interface TeamSearchViewController () <UISearchBarDelegate, UIScrollViewDelegate, UIViewControllerPreviewingDelegate>
{
    NSMutableArray *teams;
    Team *selectedTeam;
    UISearchBar *navSearchBar;
    NSString *searchString;
}
@end

@implementation TeamSearchViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        TeamViewController *teamDetail = [[TeamViewController alloc] initWithTeam:teams[indexPath.row]];
        teamDetail.preferredContentSize = CGSizeMake(0.0, 600);
        previewingContext.sourceRect = cell.frame;
        return teamDetail;
    } else {
        return nil;
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    teams = [HBSharedUtils currentLeague].teamList;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    teams=[[teams sortedArrayUsingDescriptors:@[sort]] mutableCopy];
    
    navSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [navSearchBar setPlaceholder:@"Search Teams"];
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
    
    self.tableView.tableFooterView = [UIView new];
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [navSearchBar endEditing:YES];
}

-(void)refreshData {
    [teams removeAllObjects];
    if (searchString.length > 0 || ![searchString isEqualToString:@""]) {
        for (Team *t in [HBSharedUtils currentLeague].teamList) {
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
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    Team *t = teams[indexPath.row];
    if (t.isUserControlled) {
        [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    [cell.textLabel setText:t.name];
    [cell.detailTextLabel setText:t.abbreviation];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:teams[indexPath.row]] animated:YES];
}

@end
