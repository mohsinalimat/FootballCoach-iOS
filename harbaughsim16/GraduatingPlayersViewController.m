//
//  GraduatingPlayersViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 11/28/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "GraduatingPlayersViewController.h"

#import "PlayerDetailViewController.h"
#import "Team.h"
#import "Player.h"

#import "UIScrollView+EmptyDataSet.h"

@interface GraduatingPlayersViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    NSMutableArray *grads;
}
@end

@implementation GraduatingPlayersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
    grads = [[[HBSharedUtils currentLeague] userTeam] playersLeaving];
    [grads sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        return (a.ratOvr > b.ratOvr ? -1 : a.ratOvr == b.ratOvr ? ([a.name compare:b.name]) : 1);
    }];
    self.tableView.tableFooterView = [UIView new];
    
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    if (grads.count > 0) {
        self.title = [NSString stringWithFormat:@"%lu Players Leaving", (long)grads.count];
    } else {
        self.title = @"No Players Leaving";
    }
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

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
        
    }
    Player *player = grads[indexPath.row];
    UIColor *nameColor;
    
    if (player.hasRedshirt) {
        nameColor = [UIColor lightGrayColor];
    } else if (player.isHeisman) {
        nameColor = [HBSharedUtils champColor];
    } else if (player.isAllAmerican) {
        nameColor = [UIColor orangeColor];
    } else if (player.isAllConference) {
        nameColor = [HBSharedUtils successColor];
    } else {
        nameColor = [UIColor blackColor];
    }
    
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",player.position,player.name] attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor], NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular]}];
    [attText addAttribute:NSForegroundColorAttributeName value:nameColor range:[attText.string rangeOfString:player.name]];
    [attText addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:[attText.string rangeOfString:player.position]];
    [cell.textLabel setAttributedText:attText];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"Ovr: %lu", (long)(player.ratOvr)]];
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[PlayerDetailViewController alloc] initWithPlayer:grads[indexPath.row]] animated:YES];
}

@end
