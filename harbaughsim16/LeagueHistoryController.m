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
    NSDictionary *leagueHistory;
    NSDictionary *heismanHistory;
    NSDictionary *rotyHistory;
    NSDictionary *cotyHistory;
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
    
    text = @"As you play season after season, the national champion, Player of the Year, Rookie of the Year, and Coach of the Year for each season will be immortalized here.";
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

- (void)viewDidLoad {
    [super viewDidLoad];
    leagueHistory = [HBSharedUtils currentLeague].leagueHistoryDictionary;
    heismanHistory = [HBSharedUtils currentLeague].heismanHistoryDictionary;
    rotyHistory = [HBSharedUtils currentLeague].rotyHistoryDictionary;
    cotyHistory = [HBSharedUtils currentLeague].cotyHistoryDictionary;
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView setEstimatedRowHeight:105];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    self.title = @"League History";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reincarnateCoach" object:nil];
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
        [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
        
    }
    // Configure the cell...
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]];
    NSString *heisman = @"None";
    NSMutableArray *leagueYear = [NSMutableArray arrayWithObject:@"None"];
    NSString *roty;
    NSString *coty;
    
    if ([heismanHistory.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]]) {
        heisman = heismanHistory[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]];
    } else {
        heisman = @"None";
    }
    
    if ([leagueHistory.allKeys containsObject:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]]) {
        leagueYear = leagueHistory[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]];
    } else {
        leagueYear = [NSMutableArray arrayWithObject:@"None"];
    }
    
    if ([rotyHistory.allKeys containsObject:[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]]) {
        roty = rotyHistory[[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]];
        
    } else {
        roty = @"None";
    }
    
    if ([cotyHistory.allKeys containsObject:[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]]) {
        coty = cotyHistory[[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]];
        
    } else {
        coty = @"None";
    }
    
    NSMutableAttributedString *champString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Champion: %@",leagueYear[0]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:MEDIUM_FONT_SIZE]}];
    if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [champString.string containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [champString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, champString.string.length)];
    } else {
        [champString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, champString.string.length)];
    }
    
    NSMutableAttributedString *heismanString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nPOTY: %@",heisman] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:MEDIUM_FONT_SIZE]}];
    if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [heisman containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [heismanString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, heismanString.string.length)];
    } else {
        [heismanString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, heismanString.string.length)];
    }
    
    NSMutableAttributedString *rotyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nROTY: %@",roty] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:MEDIUM_FONT_SIZE]}];
    if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [roty containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [rotyString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, rotyString.string.length)];
    } else {
        [rotyString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, rotyString.string.length)];
    }
    
    NSMutableAttributedString *cotyString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nCOTY: %@",coty] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:MEDIUM_FONT_SIZE]}];
    if ([HBSharedUtils currentLeague].userTeam.abbreviation != nil && [coty containsString:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        [cotyString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, cotyString.string.length)];
    } else {
        [cotyString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, cotyString.string.length)];
    }
    
    [champString appendAttributedString:cotyString];
    [champString appendAttributedString:heismanString];
    [champString appendAttributedString:rotyString];
    [cell.detailTextLabel setAttributedText:champString];
    [cell.detailTextLabel sizeToFit];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
