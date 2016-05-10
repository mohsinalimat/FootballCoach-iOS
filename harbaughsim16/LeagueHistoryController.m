//
//  LeagueHistoryController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "LeagueHistoryController.h"
#import "Team.h"

#import "HexColors.h"
#import "UIScrollView+EmptyDataSet.h"

@interface LeagueHistoryController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSArray *leagueHistory;
    NSArray *heismanHistory;
}
@end

@implementation LeagueHistoryController
#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No league history yet";
    font = [UIFont boldSystemFontOfSize:18.0];
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
    
    text = @"As you play season after season, the national champion and the Player of the Year for each season will be immortalized here.";
    font = [UIFont systemFontOfSize:17.0];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    leagueHistory = [HBSharedUtils getLeague].leagueHistory;
    heismanHistory = [HBSharedUtils getLeague].heismanHistory;
    [self.tableView setRowHeight:60];
    [self.tableView setEstimatedRowHeight:60];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    self.title = @"League History";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.detailTextLabel setNumberOfLines:0];
    }
    // Configure the cell...
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)]];
    NSString *heisman;
    NSMutableArray *leagueYear;
    if (indexPath.row > heismanHistory.count || indexPath.row > leagueHistory.count) {
        heisman = @"None";
        leagueYear = [NSMutableArray arrayWithObject:@"None"];
    } else {
        heisman = heismanHistory[indexPath.row];
        leagueYear = leagueHistory[indexPath.row];
    }
    NSMutableAttributedString *champString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Champion: %@",leagueYear[0]]];
    if ([champString.string containsString:[HBSharedUtils getLeague].userTeam.abbreviation]) {
        [champString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, champString.string.length)];
    } else {
        [champString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, champString.string.length)];
    }
    
    NSMutableAttributedString *heismanString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nPOTY: %@",heisman]];
    if ([heisman containsString:[HBSharedUtils getLeague].userTeam.abbreviation]) {
        [heismanString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, heismanString.string.length)];
    } else {
        [heismanString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, heismanString.string.length)];
    }
    
    [champString appendAttributedString:heismanString];
    [cell.detailTextLabel setAttributedText:champString];
    [cell.detailTextLabel sizeToFit];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSMutableArray *leagueYear = leagueHistory[indexPath.row];
    //[self.navigationController pushViewController:[[LeagueYearViewController alloc] initWithYear:[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)] top10:leagueYear] animated:YES];
}


@end
