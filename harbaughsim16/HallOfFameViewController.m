//
//  HallOfFameViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 6/8/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "HallOfFameViewController.h"
#import "Player.h"
#import "Team.h"
#import "Injury.h"
#import "League.h"

#import "PlayerQBDetailViewController.h"
#import "PlayerRBDetailViewController.h"
#import "PlayerWRDetailViewController.h"
#import "PlayerTEDetailViewController.h"
#import "PlayerOLDetailViewController.h"
#import "PlayerKDetailViewController.h"
#import "PlayerDLDetailViewController.h"
#import "PlayerLBDetailViewController.h"
#import "PlayerCBDetailViewController.h"
#import "PlayerSDetailViewController.h"
#import "PlayerDetailViewController.h"

#import "UIScrollView+EmptyDataSet.h"

@interface HallOfFameViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIViewControllerPreviewingDelegate>
{
    League *curLeague;
    Team *userTeam;
}
@end

@implementation HallOfFameViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        PlayerDetailViewController *playerDetail;
        Player *p = curLeague.hallOfFamers[indexPath.row];
        if ([p.position isEqualToString:@"QB"]) {
            playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"RB"]) {
            playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"WR"]) {
            playerDetail = [[PlayerWRDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"TE"]) {
            playerDetail = [[PlayerTEDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"OL"]) {
            playerDetail = [[PlayerOLDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"DL"]) {
            playerDetail = [[PlayerDLDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"LB"]) {
            playerDetail = [[PlayerLBDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"CB"]) {
            playerDetail = [[PlayerCBDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"S"]) {
            playerDetail = [[PlayerSDetailViewController alloc] initWithPlayer:p];
        } else if ([p.position isEqualToString:@"K"]) {
            playerDetail = [[PlayerKDetailViewController alloc] initWithPlayer:p];
        } else {
            playerDetail = [[PlayerDetailViewController alloc] initWithPlayer:p];
        }
        playerDetail.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
        previewingContext.sourceRect = cell.frame;
        return playerDetail;
    } else {
        return nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (curLeague.hallOfFamers.count > 0) {
        [self sortByHallow];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Hall of Fame";
    curLeague = [HBSharedUtils currentLeague];
    userTeam = curLeague.userTeam;
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setRowHeight:110];
    [self.tableView setEstimatedRowHeight:110];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];

    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }

    if (curLeague.hallOfFamers.count > 0) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortROH)]];
    }
}

-(void)sortROH {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sort Hall of Fame" message:@"How should the Hall of Fame be sorted?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"By Composite Fame" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sortByHallow];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"By Freshman Year" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sortByStartYear];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"By Overall Rating" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self sortByOvr];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)sortByOvr {
    [curLeague.hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils comparePlayers:obj1 toObj2:obj2];
    }];
    [self.tableView reloadData];
}

-(void)sortByHallow {
    [self sortByOvr];

    //sort by most hallowed (hallowScore = normalized OVR + 2 * all-conf + 4 * all-Amer + 6 * Heisman; tie-break w/ pure OVR, then gamesPlayed, then potential)
    int maxOvr = curLeague.hallOfFamers[0].ratOvr;
    [curLeague.hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
        int aHallowScore = (100 * ((double)a.ratOvr / (double) maxOvr)) + (2 * a.careerAllConferences) + (4 * a.careerAllAmericans) + (6 * a.careerHeismans);
        int bHallowScore = (100 * ((double)b.ratOvr / (double) maxOvr)) + (2 * b.careerAllConferences) + (4 * b.careerAllAmericans) + (6 * b.careerHeismans);
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
                if (a.gamesPlayed > b.gamesPlayed) {
                    return -1;
                } else if (a.gamesPlayed < b.gamesPlayed) {
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
    [curLeague.hallOfFamers sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Player *a = (Player*)obj1;
        Player *b = (Player*)obj2;
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

    text = @"No Hall of Famers";
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

    text = @"No former players have been enshrined yet!";
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
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
    }

    Player *p = curLeague.hallOfFamers[indexPath.row];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ %@ %@ (OVR: %li)",p.team.abbreviation,p.position,p.name,(long)p.ratOvr]];
    if (p.draftPosition) {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"Played from %li - %li\nDrafted in %li: Rd %@, Pk %@\n%@",(long)p.startYear,(long)p.endYear, (long)p.endYear,p.draftPosition[@"round"],p.draftPosition[@"pick"],[p simpleAwardReport]]];
    } else {
        [cell.detailTextLabel setText:[NSString stringWithFormat:@"Played from %li - %li\nUndrafted in %li\n%@",(long)p.startYear,(long)p.endYear, (long)p.endYear,[p simpleAwardReport]]];
    }
    [cell.detailTextLabel sizeToFit];

    if ([p.team isEqual:userTeam]) {
        [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Player *p = curLeague.hallOfFamers[indexPath.row];
    PlayerDetailViewController *playerDetail;
    if ([p.position isEqualToString:@"QB"]) {
        playerDetail = [[PlayerQBDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"RB"]) {
        playerDetail = [[PlayerRBDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"WR"]) {
        playerDetail = [[PlayerWRDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"TE"]) {
        playerDetail = [[PlayerTEDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"OL"]) {
        playerDetail = [[PlayerOLDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"DL"]) {
        playerDetail = [[PlayerDLDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"LB"]) {
        playerDetail = [[PlayerLBDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"CB"]) {
        playerDetail = [[PlayerCBDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"S"]) {
        playerDetail = [[PlayerSDetailViewController alloc] initWithPlayer:p];
    } else if ([p.position isEqualToString:@"K"]) {
        playerDetail = [[PlayerKDetailViewController alloc] initWithPlayer:p];
    } else {
        playerDetail = [[PlayerDetailViewController alloc] initWithPlayer:p];
    }
    if (self.popupController.presented) {
        [self.popupController pushViewController:playerDetail animated:YES];
    } else {
        [self.navigationController pushViewController:playerDetail animated:YES];
    }
}

@end
