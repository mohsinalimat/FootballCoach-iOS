//
//  TeamRecordsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/30/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamRecordsViewController.h"
#import "Team.h"
#import "HBRecordCell.h"
#import "Player.h"
#import "Record.h"
#import "PlayerDetailViewController.h"

#import "UIScrollView+EmptyDataSet.h"
#import "HexColors.h"

@interface TeamRecordsViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    Team *selectedTeam;
    NSArray *records;
    NSInteger selectedIndex;
}
@end

@implementation TeamRecordsViewController

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    if (selectedIndex == 0) {
        text = @"No single-season records yet";
    } else {
        text = @"No all-time records yet";
    }
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
    
    text = @"When players set or break records, they will be immortalized here!";
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

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithTeam:(Team*)team {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        selectedTeam = team;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBRecordCell" bundle:nil] forCellReuseIdentifier:@"HBRecordCell"];
    [self.tableView setRowHeight:75];
    [self.tableView setEstimatedRowHeight:75];
    //add seg control as title view
    //if seg control index == 0 - display single season records
    //if seg control index == 1 - display career records
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"Season", @"All-Time"]];
    [segControl setTintColor:[UIColor whiteColor]];
    [segControl setSelectedSegmentIndex:0];
    records = [selectedTeam singleSeasonRecords];
    selectedIndex = 0;
    [segControl addTarget:self action:@selector(switchViews:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segControl;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

-(void)switchViews:(UISegmentedControl*)sender {
    selectedIndex = sender.selectedSegmentIndex;
    if (sender.selectedSegmentIndex == 0) {
        records = [selectedTeam singleSeasonRecords];
    } else {
        records = [selectedTeam careerRecords];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBRecordCell"];
    Record *curRecord = records[indexPath.row];
    [cell.statLabel setText:[NSString stringWithFormat:@"%ld", (long)curRecord.statistic]];
    [cell.yearLabel setText:[NSString stringWithFormat:@"%ld", (long)curRecord.year]];
    if (curRecord.holder) {
        [cell.playerLabel setText:[curRecord.holder getInitialName]];
        [cell.teamLabel setText:curRecord.holder.team.abbreviation];
    } else if (curRecord.coachHolder) {
        [cell.playerLabel setText:[curRecord.coachHolder getInitialName]];
        [cell.teamLabel setText:curRecord.coachHolder.team.abbreviation];
    } else {
        [cell.playerLabel setText:@"No record holder"];
        [cell.teamLabel setText:@"N/A"];
    }
    [cell.titleLabel setText:curRecord.title];
    
    return cell;
}

@end
