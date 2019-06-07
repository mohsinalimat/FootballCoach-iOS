//
//  CoachHallOfFameViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 5/4/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "CoachHallOfFameViewController.h"
#import "HeadCoach.h"
#import "Team.h"
#import "League.h"

#import "HeadCoachDetailViewController.h"

#import "UIScrollView+EmptyDataSet.h"

@interface CoachHallOfFameViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIViewControllerPreviewingDelegate>
{
    League *curLeague;
    Team *userTeam;
}

@end

@implementation CoachHallOfFameViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        HeadCoachDetailViewController *playerDetail = [[HeadCoachDetailViewController alloc] initWithCoach:curLeague.coachingHallOfFamers[indexPath.row]];
        playerDetail.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
        previewingContext.sourceRect = cell.frame;
        return playerDetail;
    } else {
        return nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (curLeague.coachingHallOfFamers.count > 0) {
        [self sortByHallow];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Coaching Hall of Fame";
    curLeague = [HBSharedUtils currentLeague];
    userTeam = curLeague.userTeam;
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:110];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    if (curLeague.coachingHallOfFamers.count > 0) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortROH)]];
    }
}

-(void)sortROH {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sort Hall of Fame" message:@"How should the Hall of Fame be sorted?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"By Composite Fame" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sortByHallow];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"By Start Year" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sortByStartYear];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"By Overall Rating" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sortByOvr];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)sortByOvr {
    [curLeague.coachingHallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareCoachOvr:obj1 toObj2:obj2];
    }];
    [self.tableView reloadData];
}

-(void)sortByHallow {
    [self sortByOvr];
    
    //sort by most hallowed (hallowScore = normalized OVR + 2 * all-conf + 4 * all-Amer + 6 * Heisman; tie-break w/ pure OVR, then gamesPlayed, then potential)
    int maxOvr = curLeague.coachingHallOfFamers[0].ratOvr;
    [curLeague.coachingHallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HeadCoach *a = (HeadCoach*)obj1;
        HeadCoach *b = (HeadCoach*)obj2;
        int aHallowScore = (100 * ((double)a.ratOvr / (double) maxOvr)) + [a getCoachCareerScore];
        int bHallowScore = (100 * ((double)b.ratOvr / (double) maxOvr)) + [b getCoachCareerScore];
        if (aHallowScore > bHallowScore) {
            return -1;
        } else if (bHallowScore > aHallowScore) {
            return 1;
        } else {
            if (a.ratOvr > b.ratOvr) {
                return -1;
            } else if (a.ratOvr < b.ratOvr) {
                return 1;
            } else {
                if (a.gamesCoached > b.gamesCoached) {
                    return -1;
                } else if (a.gamesCoached < b.gamesCoached) {
                    return 1;
                } else {
                    if (a.ratPot > b.ratPot) {
                        return -1;
                    } else if (a.ratPot < b.ratPot) {
                        return 1;
                    } else {
                        return 0;
                    }
                }
            }
            
        }
    }];
    [self.tableView reloadData];
}

-(void)sortByStartYear {
    [curLeague.coachingHallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        HeadCoach *a = (HeadCoach*)obj1;
        HeadCoach *b = (HeadCoach*)obj2;
        return a.startYear < b.startYear ? -1 : a.startYear == b.startYear ? (a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? 0 : 1) : 1;
    }];
    [self.tableView reloadData];
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No Hall of Fame Coaches";
    font = [UIFont boldSystemFontOfSize:LARGE_FONT_SIZE];
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
    
    text = @"No former coaches have been enshrined yet!";
    font = [UIFont systemFontOfSize:MEDIUM_FONT_SIZE];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return curLeague.coachingHallOfFamers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.detailTextLabel setNumberOfLines:0];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
    }
    
    HeadCoach *hc = curLeague.coachingHallOfFamers[indexPath.row];
    if (hc != nil) {
        [self configureCellForCoach:hc indexPath:indexPath cell:cell];
    } else {
        [cell.textLabel setText:@""];
        [cell.detailTextLabel setText:@""];
    }
    
    return cell;
}

-(NSString*) suffixNumber:(NSNumber*)number
{
    if (!number)
        return @"";
    
    long long num = [number longLongValue];
    
    int s = ( (num < 0) ? -1 : (num > 0) ? 1 : 0 );
    NSString* sign = (s == -1 ? @"-" : @"" );
    
    num = llabs(num);
    
    if (num < 1000)
        return [NSString stringWithFormat:@"%@%lld",sign,num];
    
    int exp = (int) (log10l(num) / 3.f); //log10l(1000));
    
    NSArray* units = @[@"K",@"M",@"G",@"T",@"P",@"E"];
    
    return [NSString stringWithFormat:@"%@%.1f%@",sign, (num / pow(1000, exp)), [units objectAtIndex:(exp-1)]];
}

-(void)configureCellForCoach:(HeadCoach *)coach indexPath:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell {
    [cell.textLabel setText:[NSString stringWithFormat:@"HC %@ (Age: %d)", coach.name,coach.age]];
    
    //    NSMutableAttributedString *ageString = [[NSMutableAttributedString alloc] initWithString:@"Age: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    //    [ageString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", coachDict[@"age"]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *yearString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Coached from %d to %d", coach.startYear,(coach.startYear + coach.year)] attributes:@{NSFontAttributeName : [UIFont italicSystemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    
    NSMutableAttributedString *careerScoreString = [[NSMutableAttributedString alloc] initWithString:@"\nCareer Score: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [careerScoreString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", [self suffixNumber:[NSNumber numberWithInt:[coach getCoachCareerScore]]]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *lifetimeRecordString = [[NSMutableAttributedString alloc] initWithString:@"\nLifetime: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lifetimeRecordString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d-%d", coach.totalWins,coach.totalLosses] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *natlTitleString = [[NSMutableAttributedString alloc] initWithString:@"\nNatl Titles: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [natlTitleString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", coach.totalNCs] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *lastBowlString = [[NSMutableAttributedString alloc] initWithString:@"\nTeams Coached: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lastBowlString appendAttributedString:[[NSAttributedString alloc] initWithString:[coach teamsCoachedString] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *coachAwardsString = [[NSMutableAttributedString alloc] initWithString:@"\nCoach Awards: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [coachAwardsString appendAttributedString:[[NSAttributedString alloc] initWithString:[coach coachAwardReportString] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *playerAwardsString = [[NSMutableAttributedString alloc] initWithString:@"\nPlayer Awards: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [playerAwardsString appendAttributedString:[[NSAttributedString alloc] initWithString:[coach playerAwardReportString] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *compoundHistoryString = [[NSMutableAttributedString alloc] initWithAttributedString:yearString];
    //    [compoundHistoryString appendAttributedString:yearString];
    [compoundHistoryString appendAttributedString:careerScoreString];
    [compoundHistoryString appendAttributedString:lifetimeRecordString];
    [compoundHistoryString appendAttributedString:natlTitleString];
    [compoundHistoryString appendAttributedString:lastBowlString];
    [compoundHistoryString appendAttributedString:coachAwardsString];
    [compoundHistoryString appendAttributedString:playerAwardsString];
    
    [cell.detailTextLabel setAttributedText:compoundHistoryString];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HeadCoachDetailViewController *playerDetail = [[HeadCoachDetailViewController alloc] initWithCoach:curLeague.coachingHallOfFamers[indexPath.row]];
    if (self.popupController.presented) {
        [self.popupController pushViewController:playerDetail animated:YES];
    } else {
        [self.navigationController pushViewController:playerDetail animated:YES];
    }
}


@end
