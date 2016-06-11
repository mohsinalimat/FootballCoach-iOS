//
//  HallOfFameViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 6/8/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "HallOfFameViewController.h"
#import "PlayerDetailViewController.h"
#import "Player.h"
#import "Team.h"
#import "Injury.h"
#import "League.h"

#import "UIScrollView+EmptyDataSet.h"

@interface HallOfFameViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    League *curLeague;
}
@end

@implementation HallOfFameViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Hall of Fame";
    curLeague = [HBSharedUtils getLeague];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setRowHeight:85];
    [self.tableView setEstimatedRowHeight:85];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    text = @"No Hall of Famers";
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
    
    text = @"No former players have been enshrined yet!";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return curLeague.hallOfFamers.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.detailTextLabel setNumberOfLines:4];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
    }
    
    Player *p = curLeague.hallOfFamers[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@ %@ (OVR: %li)",p.team.abbreviation,p.position,p.name,(long)p.ratOvr]];
    if (p.draftPosition) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"Played from %li - %li\nDrafted in %li: Rd %@, Pk %@\n%@",(long)p.startYear,(long)p.endYear, (long)p.endYear,p.draftPosition[@"round"],p.draftPosition[@"pick"],[p simpleAwardReport]]];
    } else {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"Played from %li - %li\nUndrafted in %li\n%@",(long)p.startYear,(long)p.endYear, (long)p.endYear,[p simpleAwardReport]]];
    }
    [cell.detailTextLabel sizeToFit];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Player *p = curLeague.hallOfFamers[indexPath.row];
    [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:p] animated:YES];
}

@end
