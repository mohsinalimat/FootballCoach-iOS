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

#import "UIScrollView+EmptyDataSet.h"
#import "HexColors.h"

@interface TeamStreaksViewController () <UISearchBarDelegate, UIScrollViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIViewControllerPreviewingDelegate>
{
    NSMutableArray<TeamStreak*> *streaks;
    NSMutableDictionary *streakDict;
    Team *selectedTeam;
    UISearchBar *navSearchBar;
    NSString *searchString;
}
@end

@implementation TeamStreaksViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        TeamViewController *teamDetail = [[TeamViewController alloc] initWithTeam:streaks[indexPath.row].opponent];
        teamDetail.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
        previewingContext.sourceRect = cell.frame;
        return teamDetail;
    } else {
        return nil;
    }
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No streaks yet";
    font = [UIFont boldSystemFontOfSize:17.0];
    textColor = [UIColor lightTextColor];
    
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    text = @"When your team starts playing games, its records against other teams will be displayed here.";
    font = [UIFont systemFontOfSize:15.0];
    textColor = [UIColor lightTextColor];
    
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [HBSharedUtils styleColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 0.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 10.0;
}

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
    self.navigationItem.title = @"Streaks";
    self.tableView.tableFooterView = [UIView new];
    
    if (streaks.count > 0) {
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
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reincarnateCoach" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reloadTeams" object:nil];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
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
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    
    TeamStreak *ts = streaks[indexPath.row];
    [cell.textLabel setText:ts.opponent.name];
    NSMutableAttributedString *teamString = [[NSMutableAttributedString alloc] initWithString:ts.opponent.name attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    [cell.detailTextLabel setText:[ts stringRepresentation]];
    
    if ([ts.opponent.abbreviation isEqualToString:[HBSharedUtils currentLeague].userTeam.rivalTeam]) {
        [teamString appendAttributedString:[[NSAttributedString alloc] initWithString:@" RIVAL" attributes:@{NSForegroundColorAttributeName : [HBSharedUtils styleColor], NSFontAttributeName : [UIFont systemFontOfSize:12.0]}]];
    }
    [cell.textLabel setAttributedText:teamString];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TeamStreak *ts = streaks[indexPath.row];
    [self.navigationController pushViewController:[[TeamViewController alloc] initWithTeam:ts.opponent] animated:YES];
}


@end
