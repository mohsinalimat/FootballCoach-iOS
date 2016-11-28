//
//  GraduatingPlayersViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 11/28/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "GraduatingPlayersViewController.h"

#import "PlayerDetailViewController.h"
#import "HBRosterCell.h"
#import "Team.h"
#import "Player.h"

#import "UIScrollView+EmptyDataSet.h"

@interface GraduatingPlayersViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSArray *grads;
}
@end

@implementation GraduatingPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    grads = [[[HBSharedUtils getLeague] userTeam] playersLeaving];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    self.title = @"Players Leaving";
    [self.tableView registerNib:[UINib nibWithNibName:@"HBRosterCell" bundle:nil] forCellReuseIdentifier:@"HBRosterCell"];
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
    
    text = @"No Players Leaving";
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
    
    text = @"No players are leaving your program this offseason.";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return grads.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HBRosterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HBRosterCell"];
    Player *player = grads[indexPath.row];
    [cell.nameLabel setText:[player getInitialName]];
    [cell.yrLabel setText:[player getYearString]];
    [cell.ovrLabel setText:[NSString stringWithFormat:@"%d", player.ratOvr]];
    if (player.hasRedshirt) {
        [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
    } else if (player.isHeisman) {
        [cell.nameLabel setTextColor:[HBSharedUtils champColor]];
    } else if (player.isAllAmerican) {
        [cell.nameLabel setTextColor:[UIColor orangeColor]];
    } else if (player.isAllConference) {
        [cell.nameLabel setTextColor:[HBSharedUtils successColor]];
    } else {
        [cell.nameLabel setTextColor:[UIColor blackColor]];
    }
    
    if ([player isInjured]) {
        [cell.medImageView setHidden:NO];
    } else {
        [cell.medImageView setHidden:YES];
    }
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:grads[indexPath.row]] animated:YES];
}

@end
