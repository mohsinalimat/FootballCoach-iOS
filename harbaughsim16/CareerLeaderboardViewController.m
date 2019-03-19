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

#import "CFCRecruitCell.h"
#import "NSArray+Uniqueness.h"
#import "TeamViewController.h"

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
    
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = 150;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"CFCRecruitCell" bundle:nil] forCellReuseIdentifier:@"CFCRecruitCell"];
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
    
    CFCRecruitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFCRecruitCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *coachDict = coachList[indexPath.row];
    if (coachDict != nil) {
        [self configureCellForCoach:coachDict indexPath:indexPath cell:cell];
    } else {
        [cell.interestLabel setText:@""];
        [cell.starImageView setImage:nil];
        [cell.nameLabel setText:@""];
        [cell.stateLabel setText:@""];
        [cell.heightLabel setText:@""];
        [cell.weightLabel setText:@""];
    }
    
    return cell;
}

-(void)configureCellForCoach:(NSDictionary *)coachDict indexPath:(NSIndexPath *)indexPath cell:(CFCRecruitCell *)cell {
    [cell.nameLabel setText:coachDict[@"coachName"]];
    [cell.stateLabel setText:[NSString stringWithFormat:@"Coach Score: %@", coachDict[@"coachScore"]]];

    CGFloat inMin = [worstCoachScore floatValue];
    CGFloat inMax = [bestCoachScore floatValue];

    CGFloat outMin = 1.0;
    CGFloat outMax = 5.0;

    CGFloat input = (CGFloat)[coachDict[@"coachScore"] floatValue];
    int stars = (int)(outMin + (outMax - outMin) * (input - inMin) / (inMax - inMin));

    [cell.starImageView setImage:[UIImage imageNamed:[HBSharedUtils convertStarsToUIImageName:MAX(1, stars)]]];
    
    NSMutableAttributedString *lastBowlString = [[NSMutableAttributedString alloc] initWithString:@"Teams Coached: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lastBowlString appendAttributedString:[[NSAttributedString alloc] initWithString:coachDict[@"teamsCoached"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.heightLabel setAttributedText:lastBowlString];

    NSMutableAttributedString *coachAwardsString = [[NSMutableAttributedString alloc] initWithString:@"Coach Awards: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [coachAwardsString appendAttributedString:[[NSAttributedString alloc] initWithString:coachDict[@"coachAwards"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.fortyYdDashLabel setAttributedText:coachAwardsString];

    NSMutableAttributedString *playerAwardsString = [[NSMutableAttributedString alloc] initWithString:@"Player Awards: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [playerAwardsString appendAttributedString:[[NSAttributedString alloc] initWithString:coachDict[@"playerAwards"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.otherOffersLabel setAttributedText:playerAwardsString];
    
//    NSMutableAttributedString *recordString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld: ", (long)[[HBSharedUtils currentLeague] getCurrentYear]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
//    [recordString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d-%d",t.wins,t.losses] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
//        [cell.weightLabel setAttributedText:recordString];

    NSMutableAttributedString *lifetimeRecordString = [[NSMutableAttributedString alloc] initWithString:@"Lifetime: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lifetimeRecordString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@-%@", coachDict[@"totalWins"],coachDict[@"totalLosses"]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.weightLabel setAttributedText:lifetimeRecordString];
    
    [cell.rankLabel setText:[NSString stringWithFormat:@"#%ld HC", (long)(indexPath.row + 1)]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
