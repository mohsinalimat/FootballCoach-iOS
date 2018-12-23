//
//  TransferLogViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/22/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "TransferLogViewController.h"

#import "Team.h"

#import "UIScrollView+EmptyDataSet.h"

@interface TransferLogViewController () <DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end

@implementation TransferLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    
    self.title = @"Transfer Log";
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [HBSharedUtils styleColor];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [HBSharedUtils currentLeague].transferLog.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setNumberOfLines:0];
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    
    [cell.textLabel setText:[HBSharedUtils currentLeague].transferLog[indexPath.row]];
    if ([cell.textLabel.text containsString:[NSString stringWithFormat:@" %@ ", [HBSharedUtils currentLeague].userTeam.abbreviation]]) {
        [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
       [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    [cell.textLabel sizeToFit];

    return cell;
}


#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No transfers";
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
    
    text = @"No players transferred this offseason.";
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

@end
