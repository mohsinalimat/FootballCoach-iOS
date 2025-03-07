//
//  HeadCoachHistoryViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/31/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "HeadCoachHistoryViewController.h"
#import "HeadCoach.h"
#import "PrestigeHistoryViewController.h"

#import "UIScrollView+EmptyDataSet.h"

@interface HeadCoachHistoryViewController ()  <DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    HeadCoach *selectedCoach;
    NSDictionary *history;
}
@end

@implementation HeadCoachHistoryViewController

-(instancetype)initWithCoach:(HeadCoach*)coach {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        selectedCoach = coach;
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

-(NSInteger)_lineCount:(NSString*)string {
    NSInteger numberOfLines, index, stringLength = [string length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
        index = NSMaxRange([string lineRangeForRange:NSMakeRange(index, 0)]);
    if([string hasSuffix:@"\n"] || [string hasSuffix:@"\r"])
        numberOfLines += 1;
    if([string hasPrefix:@"\n"] || [string hasPrefix:@"\r"])
        numberOfLines += 1;
    return numberOfLines;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    history = selectedCoach.coachingHistoryDictionary;
    self.title = [NSString stringWithFormat:@"Coaching History for %@", [selectedCoach getInitialName]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    
    if (history.allKeys.count > 5) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"graph"] style:UIBarButtonItemStylePlain target:self action:@selector(viewChartOptions)];
        
    }
    
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

-(void)viewChartOptions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Chart Options" message:@"Which chart would you like to view?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Prestige" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self viewPrestigeHistory];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Coach Score" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self viewCoachScoreHistory];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)viewCoachScoreHistory {
    NSMutableArray *scoreValues = [NSMutableArray array];
    NSMutableArray *colorValues = [NSMutableArray array];
    
    for (int i = 0; i < selectedCoach.prestigeHistoryDictionary.count; i++) {
        NSInteger year = selectedCoach.startYear + i;
        NSInteger coachScore = [selectedCoach.prestigeHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)year]][@"coachScore"] integerValue];
        NSString *hist = history[[NSString stringWithFormat:@"%ld",(long)year]];
        
        UIColor *teamColor;
        if ([hist containsString:@"NCG - W"] || [hist containsString:@"NCW"]) {
            teamColor = [HBSharedUtils champColor];
        } else {
            if ([hist containsString:@"Bowl - W"] || [hist containsString:@"Semis,1v4 - W"] || [hist containsString:@"Semis,2v3 - W"] || [hist containsString:@"BW"] || [hist containsString:@"SFW"]) {
                teamColor = [UIColor orangeColor];
            } else {
                if ([hist containsString:@"CCG - W"] || [hist containsString:@"CC"]) {
                    teamColor = [HBSharedUtils successColor];
                } else {
                    teamColor = [UIColor whiteColor];
                }
            }
        }
        [colorValues addObject:teamColor];
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:year y:coachScore];
        [scoreValues addObject:entry];
    }
    
    LineChartDataSet *prestigeHistLine = [[LineChartDataSet alloc] initWithValues:scoreValues label:@"Coach Score over Time"];
    prestigeHistLine.circleColors = colorValues;
    prestigeHistLine.circleRadius /= 2;
    prestigeHistLine.drawCircleHoleEnabled = NO;
    prestigeHistLine.colors = @[[UIColor whiteColor]];
    prestigeHistLine.valueTextColor = [UIColor lightTextColor];
    
    PrestigeHistoryViewController *prestigeHistoryVC = [[PrestigeHistoryViewController alloc] initWithDataSets:@[prestigeHistLine]];
    prestigeHistoryVC.title = [NSString stringWithFormat:@"Coach Score History for %@", [selectedCoach getInitialName]];
    if (self.popupController.presented) {
        prestigeHistoryVC.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.75 * [UIScreen mainScreen].bounds.size.height);
        [self.popupController pushViewController:prestigeHistoryVC animated:YES];
    } else {
        [self.navigationController pushViewController:prestigeHistoryVC animated:YES];
    }
}

-(void)viewPrestigeHistory {
    NSMutableArray *scoreValues = [NSMutableArray array];
    NSMutableArray *colorValues = [NSMutableArray array];
    
    for (int i = 0; i < selectedCoach.prestigeHistoryDictionary.count; i++) {
        NSInteger year = selectedCoach.startYear + i;
        NSInteger coachScore = [selectedCoach.prestigeHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)year]][@"prestige"] integerValue];
        NSString *hist = history[[NSString stringWithFormat:@"%ld",(long)year]];
        
        UIColor *teamColor;
        if ([hist containsString:@"NCG - W"] || [hist containsString:@"NCW"]) {
            teamColor = [HBSharedUtils champColor];
        } else {
            if ([hist containsString:@"Bowl - W"] || [hist containsString:@"Semis,1v4 - W"] || [hist containsString:@"Semis,2v3 - W"] || [hist containsString:@"BW"] || [hist containsString:@"SFW"]) {
                teamColor = [UIColor orangeColor];
            } else {
                if ([hist containsString:@"CCG - W"] || [hist containsString:@"CC"]) {
                    teamColor = [HBSharedUtils successColor];
                } else {
                    teamColor = [UIColor whiteColor];
                }
            }
        }
        [colorValues addObject:teamColor];
        
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:year y:coachScore];
        [scoreValues addObject:entry];
    }
    
    LineChartDataSet *prestigeHistLine = [[LineChartDataSet alloc] initWithValues:scoreValues label:@"Team Prestige over Time"];
    prestigeHistLine.circleColors = colorValues;
    prestigeHistLine.circleRadius /= 2;
    prestigeHistLine.drawCircleHoleEnabled = NO;
    prestigeHistLine.colors = @[[UIColor whiteColor]];
    prestigeHistLine.valueTextColor = [UIColor lightTextColor];
    
    PrestigeHistoryViewController *prestigeHistoryVC = [[PrestigeHistoryViewController alloc] initWithDataSets:@[prestigeHistLine]];
    prestigeHistoryVC.title = [NSString stringWithFormat:@"Team Prestige History for %@", [selectedCoach getInitialName]];
    if (self.popupController.presented) {
        prestigeHistoryVC.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.75 * [UIScreen mainScreen].bounds.size.height);
        [self.popupController pushViewController:prestigeHistoryVC animated:YES];
    } else {
        [self.navigationController pushViewController:prestigeHistoryVC animated:YES];
    }
}

- (NSNumberFormatter *)numberFormatter {
    static dispatch_once_t onceToken;
    static NSNumberFormatter *formatter;
    dispatch_once(&onceToken, ^{
        formatter = [[NSNumberFormatter alloc] init];
    });
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return formatter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No history to view";
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
    
    text = [NSString stringWithFormat:@"This coach has no previous coaching history to review."];
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

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger lineCount = [self _lineCount:history[[NSString stringWithFormat:@"%ld", (long)([HBSharedUtils currentLeague].baseYear + indexPath.row)]]];
    if (lineCount > 2) {
        return 100 + (10 * (lineCount - 2));
    } else if (lineCount == 2) {
        return 90;
    } else {
        return 80;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return history.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (history.count > 0) {
        return @"Color Key:\nGreen - Conference Champion\nOrange - Bowl Winner\nGold - National Champion";
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (history.count > 0) {
        return 90;
    }
    return [super tableView:tableView heightForFooterInSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"LowerCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LowerCell"];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setNumberOfLines:7];
        [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)(selectedCoach.startYear + indexPath.row)]];
    NSString *hist;
    if (![history.allKeys containsObject:[NSString stringWithFormat:@"%ld", (long)(selectedCoach.startYear + indexPath.row)]]) {
        hist = [NSString stringWithFormat:@"%@ (0-0)",selectedCoach.team.abbreviation];
    } else {
        hist = selectedCoach.coachingHistoryDictionary[[NSString stringWithFormat:@"%ld", (long)(selectedCoach.startYear + indexPath.row)]];
    }
    NSArray *comps = [hist componentsSeparatedByString:@"\n"];
    
    UIColor *teamColor;
    if ([hist containsString:@"NCG - W"] || [hist containsString:@"NCW"]) {
        teamColor = [HBSharedUtils champColor];
    } else {
        if ([hist containsString:@"Bowl - W"] || [hist containsString:@"Semis,1v4 - W"] || [hist containsString:@"Semis,2v3 - W"] || [hist containsString:@"BW"] || [hist containsString:@"SFW"]) {
            teamColor = [UIColor orangeColor];
        } else {
            if ([hist containsString:@"CCG - W"]) {
                teamColor = [HBSharedUtils successColor];
            } else {
                teamColor = [UIColor lightGrayColor];
            }
        }
    }
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:hist attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:MEDIUM_FONT_SIZE weight:UIFontWeightRegular]}];
    [attText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE weight:UIFontWeightRegular] range:[hist rangeOfString:comps[0]]];
    [attText addAttribute:NSForegroundColorAttributeName value:teamColor range:[hist rangeOfString:comps[0]]];
    [cell.detailTextLabel setAttributedText:attText];
    [cell.detailTextLabel sizeToFit];
    return cell;
    
}


@end
