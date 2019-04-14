//
//  CareerLeaderboardViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "CareerLeaderboardViewController.h"
#import "League.h"
#import "Team.h"

#import "NSArray+Uniqueness.h"
#import "TeamViewController.h"
#import "CareerCompletionViewController.h"

#import "STPopup.h"
#import "HexColors.h"
#import "UIScrollView+EmptyDataSet.h"

@interface CareerLeaderboardViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSMutableArray *coachList;
    NSNumber *bestCoachScore;
    NSNumber *worstCoachScore;
}
@end

@implementation CareerLeaderboardViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.title = @"Lifetime Career Leaderboard";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"coach-leaderboard.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) {
        
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"coach-leaderboard.plist"] ];
    }
    
    NSMutableDictionary *data;
    coachList = [NSMutableArray array];
    
    if ([fileManager fileExistsAtPath: path]) {
        data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        coachList = [NSMutableArray arrayWithArray:data[@"coaches"]];
    }
    
    [coachList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *a = (NSDictionary *)obj1;
        NSDictionary *b = (NSDictionary *)obj2;
        return a[@"coachScore"] > b[@"coachScore"] ? -1 : ((a[@"coachScore"] == a[@"coachScore"]) ? ([a[@"coachName"] compare:b[@"coachName"]]) : 1);
    }];
    
    bestCoachScore = [coachList firstObject][@"coachScore"];
    worstCoachScore = [coachList lastObject][@"coachScore"];
    [self.tableView reloadData];
    
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    self.tableView.tableFooterView = [UIView new];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.isBeingPresented) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:self action:@selector(closeWindow)];
    }
}

-(void)closeWindow {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No coaches on leaderboard";
    font = [UIFont boldSystemFontOfSize:16.0];
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
    
    text = @"There are no coaches saved to your leaderboard yet. Play through career mode to add them!";
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

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return coachList.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setNumberOfLines:0];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    NSDictionary *coachDict = coachList[indexPath.row];
    if (coachDict != nil) {
        [self configureCellForCoach:coachDict indexPath:indexPath cell:cell];
    } else {
        [cell.textLabel setText:@""];
        [cell.detailTextLabel setText:@""];
    }
    
    return cell;
}

-(void)configureCellForCoach:(NSDictionary *)coachDict indexPath:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell {
    [cell.textLabel setText:[NSString stringWithFormat:@"HC %@ (Age: %@)", coachDict[@"coachName"],coachDict[@"age"]]];

//    NSMutableAttributedString *ageString = [[NSMutableAttributedString alloc] initWithString:@"Age: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
//    [ageString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", coachDict[@"age"]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *yearString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Coached from %@ to %d", coachDict[@"startYear"],([coachDict[@"startYear"] intValue] + [coachDict[@"yearsCoachedFor"] intValue])] attributes:@{NSFontAttributeName : [UIFont italicSystemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    
    NSMutableAttributedString *careerScoreString = [[NSMutableAttributedString alloc] initWithString:@"\nCareer Score: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [careerScoreString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", coachDict[@"coachScore"]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *lifetimeRecordString = [[NSMutableAttributedString alloc] initWithString:@"\nLifetime: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lifetimeRecordString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@-%@", coachDict[@"totalWins"],coachDict[@"totalLosses"]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *lastBowlString = [[NSMutableAttributedString alloc] initWithString:@"\nTeams Coached: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lastBowlString appendAttributedString:[[NSAttributedString alloc] initWithString:coachDict[@"teamsCoached"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];

    NSMutableAttributedString *coachAwardsString = [[NSMutableAttributedString alloc] initWithString:@"\nCoach Awards: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [coachAwardsString appendAttributedString:[[NSAttributedString alloc] initWithString:coachDict[@"coachAwards"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];

    NSMutableAttributedString *playerAwardsString = [[NSMutableAttributedString alloc] initWithString:@"\nPlayer Awards: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [playerAwardsString appendAttributedString:[[NSAttributedString alloc] initWithString:coachDict[@"playerAwards"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];

    NSMutableAttributedString *compoundHistoryString = [[NSMutableAttributedString alloc] initWithAttributedString:yearString];
//    [compoundHistoryString appendAttributedString:yearString];
    [compoundHistoryString appendAttributedString:careerScoreString];
    [compoundHistoryString appendAttributedString:lifetimeRecordString];
    [compoundHistoryString appendAttributedString:lastBowlString];
    [compoundHistoryString appendAttributedString:coachAwardsString];
    [compoundHistoryString appendAttributedString:playerAwardsString];
    
    [cell.detailTextLabel setAttributedText:compoundHistoryString];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController presentViewController:[[CareerCompletionViewController alloc] initWithCoachDictionary:coachList[indexPath.row]] animated:YES completion:nil];
}

@end
