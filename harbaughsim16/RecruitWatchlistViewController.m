//
//  RecruitWatchlistViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/5/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "RecruitWatchlistViewController.h"
#import "League.h"
#import "Team.h"
#import "CFCWatchlistCell.h"

#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerDL.h"
#import "PlayerTE.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "STPopup.h"
#import "UIScrollView+EmptyDataSet.h"

@interface RecruitWatchlistViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSArray *selectedRecruits;
    NSDictionary *recruitActivities;
}
@end

@implementation RecruitWatchlistViewController

-(instancetype)initWithRecruits:(NSArray *)recruits activities:(NSDictionary *)activities {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        selectedRecruits = recruits;
        recruitActivities = activities;
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.height / 2.0));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Watchlist";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 165;
    [self.tableView registerNib:[UINib nibWithNibName:@"CFCWatchlistCell" bundle:nil] forCellReuseIdentifier:@"CFCWatchlistCell"];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.tableView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No recruit interactions";
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
    
    text = @"You haven't interacted with recruits yet. Check back here once you do!";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return selectedRecruits.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CFCWatchlistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFCWatchlistCell"];
    
    Player *p = selectedRecruits[indexPath.row];
    NSMutableString *recruitHistory = [NSMutableString string];
    NSArray *recruitEvents = ([recruitActivities.allKeys containsObject:[p uniqueIdentifier]]) ? recruitActivities[[p uniqueIdentifier]] : [NSMutableArray array];
    
    int interest = 0;
    if ([p.offers.allKeys containsObject:[HBSharedUtils getLeague].userTeam.abbreviation]) {
        interest = [p.offers[[HBSharedUtils getLeague].userTeam.abbreviation] intValue];
    } else {
        interest = [p calculateInterestInTeam:[HBSharedUtils getLeague].userTeam];
        NSMutableArray *recruitEvents = ([recruitActivities.allKeys containsObject:[p uniqueIdentifier]]) ? recruitActivities[[p uniqueIdentifier]] : [NSMutableArray array];
        if ([recruitEvents containsObject:@(CFCRecruitEventPositionCoachMeeting)]) {
            interest += MEETING_INTEREST_BONUS;
        }
        if ([recruitEvents containsObject:@(CFCRecruitEventOfficialVisit)]) {
            interest += OFFICIAL_VISIT_INTEREST_BONUS;
        }
        if ([recruitEvents containsObject:@(CFCRecruitEventInHomeVisit)]) {
            interest += INHOME_VISIT_INTEREST_BONUS;
        }
    }
    
    if ([recruitEvents containsObject:@(CFCRecruitEventPositionCoachMeeting)]) {
        [recruitHistory appendFormat:@"Met with %@ Coach\n",p.position];
    }
    if ([recruitEvents containsObject:@(CFCRecruitEventOfficialVisit)]) {
        [recruitHistory appendFormat:@"Came to Official Visit\n"];
    }
    if ([recruitEvents containsObject:@(CFCRecruitEventInHomeVisit)]) {
        [recruitHistory appendFormat:@"Went to In-home Visit\n"];
    }
    if ([recruitEvents containsObject:@(CFCRecruitEventExtendOffer)]) {
        [recruitHistory appendFormat:@"Extended Offer\n"];
    }
    
    if (recruitHistory.length == 0) {
        [recruitHistory appendString:@"None"];
    } else {
        recruitHistory = [NSMutableString stringWithFormat:@"%@",[recruitHistory stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    
    NSMutableAttributedString *historyString = [[NSMutableAttributedString alloc] initWithString:@"Previous actions:\n" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [historyString appendAttributedString:[[NSAttributedString alloc] initWithString:recruitHistory attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:17.0]}]];
    [cell.activitiesLabel setAttributedText:historyString];
    
    NSDictionary *interestMetadata = [HBSharedUtils generateInterestMetadata:interest otherOffers:p.offers];
    // Valid cell data formatting code
    NSMutableAttributedString *interestString = [[NSMutableAttributedString alloc] initWithString:@"Interest: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [interestString appendAttributedString:[[NSAttributedString alloc] initWithString:interestMetadata[@"interest"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : interestMetadata[@"color"]}]];
    [cell.interestLabel setAttributedText:interestString];
    [cell.starImageView setImage:[UIImage imageNamed:[HBSharedUtils convertStarsToUIImageName:p.stars]]];
    
    UIColor *nameColor = [UIColor blackColor];
    if (p.recruitStatus == CFCRecruitStatusCommitted && p.team == [HBSharedUtils getLeague].userTeam) {
        nameColor = [HBSharedUtils styleColor];
    } else if (p.recruitStatus == CFCRecruitStatusCommitted && p.team != [HBSharedUtils getLeague].userTeam) {
        nameColor = [HBSharedUtils errorColor];
    } else if ([recruitActivities.allKeys containsObject:[p uniqueIdentifier]]) {
        NSArray *events = recruitActivities[[p uniqueIdentifier]];
        if ([events containsObject:@(CFCRecruitEventExtendOffer)]) {
            nameColor = [HBSharedUtils offeredColor];
        } else {
            nameColor = [HBSharedUtils progressColor];
        }
    } else {
        nameColor = [UIColor blackColor];
    }
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", p.position] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    [nameString appendAttributedString:[[NSAttributedString alloc] initWithString:p.name attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0], NSForegroundColorAttributeName : nameColor}]];
    [cell.nameLabel setAttributedText:nameString];
    
    [cell.stateLabel setText:p.personalDetails[@"home_state"]];
    
    return cell;
}

@end
