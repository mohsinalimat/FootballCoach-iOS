//
//  AvailableJobsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/2/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "AvailableJobsViewController.h"

#import "League.h"
#import "Team.h"

#import "CFCRecruitCell.h"
#import "NSArray+Uniqueness.h"
#import "TeamViewController.h"

#import "STPopup.h"
#import "HexColors.h"
#import "MBProgressHUD.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ZMJTipView.h"

#define FCTutorialTeamSelect 1000
#define FCTutorialCloseJobsWindow 1004

@interface AvailableJobsViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource, ZMJTipViewDelegate>
{
    STPopupController *popupController;
    NSMutableArray *availableJobs;

    HeadCoach *userCoach;

    NSIndexPath *selectedIndexPath;
    Team *selectedTeam;

    NSMutableDictionary<NSString *, NSString *> *lastBowlMap;
    NSMutableDictionary<NSString *, NSString *> *lastCCGMap;
    NSMutableDictionary<NSString *, NSString *> *lastNCGMap;

    BOOL coachUnemployed;
}

@end

@implementation AvailableJobsViewController

//MARK: ZMJTipViewDelegate
- (void)tipViewDidDimiss:(ZMJTipView *)tipView {
    // show new tips based on last shown tipview
    if (tipView.tag == FCTutorialTeamSelect) {
        NSString *tipText = @"Tap here to close the jobs window. Note: if you close the jobs window, you will be randomly signed to a team.";
        if (!coachUnemployed) {
            tipText = @"Tap here to close the jobs window.";
        }
        ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:tipText preferences:nil delegate:self];
        editTip.tag = FCTutorialCloseJobsWindow;
        [editTip showAnimated:YES forItem:self.navigationItem.leftBarButtonItem withinSuperview:self.navigationController.view];
    }
}

- (void)tipViewDidSelected:(ZMJTipView *)tipView {
    // do nothing
}

-(instancetype)initWithJobStatus:(BOOL)wasFired {
    self = [super init];
    coachUnemployed = wasFired;
    return self;
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)_generateJobOffers {
    availableJobs = [NSMutableArray array];
    for (Team *t in [HBSharedUtils currentLeague].teamList) {
        if (![t isEqual:[HBSharedUtils currentLeague].userTeam]
            && (t.coachFired || t.coachRetired || t.coaches.count == 0)
            && ![availableJobs containsObject:t]) {
            // view all available if the coach wasn't fired, but if he was, only show the ones he qualifies for.
            if ((userCoach.team.coachFired && [t getMinCoachHireReq] <= userCoach.ratOvr) || !userCoach.team.coachFired) {
                [availableJobs addObject:t];
            }
        }
    }
    
    [availableJobs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareTeamPrestige:obj1 toObj2:obj2];
    }];
    
    [self generateDetailStrings];
    [self.tableView reloadData];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    if (userCoach.team.coachFired) {
        self.title = [NSString stringWithFormat:@"%ld Job Offers", (long)([[HBSharedUtils currentLeague] getCurrentYear] + 1)];
    } else {
        self.title = [NSString stringWithFormat:@"%ld Coaching Carousel", (long)([[HBSharedUtils currentLeague] getCurrentYear] + 1)];
    }

    userCoach = [[HBSharedUtils currentLeague].userTeam getCurrentHC];
    [self _generateJobOffers];

    //[hud hideAnimated:YES];

    [self.view setBackgroundColor:[HBSharedUtils styleColor]];

    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = 150;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"CFCRecruitCell" bundle:nil] forCellReuseIdentifier:@"CFCRecruitCell"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveSigningNotif:) name:@"signingWithTeam" object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(sortJobs)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:self action:@selector(closeCarousel)];


    BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_COACHING_TUTORIAL_SHOWN_KEY];
    if (!tutorialShown) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_COACHING_TUTORIAL_SHOWN_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //display intro screen
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self openJobTutorial];
        });
    }
}

-(void)sortJobs {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Job Sort Options" message:@"What metric would you like to sort by?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Prestige" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self->availableJobs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils compareTeamPrestige:obj1 toObj2:obj2];
        }];
        [self.tableView reloadData];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Interest" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self->availableJobs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return [a calculateInterestInCoach:self->userCoach] > [b calculateInterestInCoach:self->userCoach] ? -1 : [a calculateInterestInCoach:self->userCoach] == [b calculateInterestInCoach:self->userCoach] ? 0 : 1;
        }];
        [self.tableView reloadData];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Total Wins" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self->availableJobs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Team *a = (Team*)obj1;
            Team *b = (Team*)obj2;
            return a.totalWins > b.totalWins ? -1 : a.totalWins == b.totalWins ? 0 : 1;
        }];
        [self.tableView reloadData];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%ld Record",(long)[[HBSharedUtils currentLeague] getCurrentYear]] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self->availableJobs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils compareTeamLeastWins:obj2 toObj2:obj1];
        }];
        [self.tableView reloadData];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)openJobTutorial {
    //display intro screen
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self->availableJobs.count > 0) {
            NSString *tipText = @"This is a job offer from another program. You can read a short version of how the program has done recently, and tap on the program to learn more and sign a contract with them.";
            if (!self->userCoach.team.coachFired) {
                tipText = @"This is a job opening at another program. You can read a short version of how the program has done recently, and tap on the program to learn more and sign a contract with them. If the program's information is grayed out, you do not meet the minimum requirements for their posting.";
            }
            ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:tipText preferences:nil delegate:self];
            editTip.tag = FCTutorialTeamSelect;
            [editTip showAnimated:YES forView:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] withinSuperview:self.tableView];
        }
    });
}

-(void)closeCarousel {
    // do you want to close?
    // will be assigned to a random team if one is not selected
    if (coachUnemployed) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Exiting Coaching Carousel" message:@"Are you sure you want to exit and sim the coaching carousel? You will be randomly signed to a team with a head coaching vacancy." preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                [hud setMode:MBProgressHUDModeIndeterminate];
                [hud.label setText:@"Processing open coaching positions..."];
                [HBSharedUtils currentLeague].userTeam.isUserControlled = NO;
                //        [[HBSharedUtils currentLeague].userTeam.coaches removeObject:self->userCoach];
                if (![[HBSharedUtils currentLeague].coachList containsObject:self->userCoach]) {
                    [[HBSharedUtils currentLeague].coachList addObject:self->userCoach];
                }

                for (Team *t in self->availableJobs) {
                    if (t.coaches.count != 0 && (t.coachFired || t.coachRetired)) {
                        [t.coaches removeObjectAtIndex:0]; // remove all fired coaches (if not removed already)
                    }
                }

                // process rest of coaching carousel
                [[HBSharedUtils currentLeague] processCoachingCarousel];
                // mark coaching carousel as over
                [HBSharedUtils currentLeague].didFinishCoachingCarousel = YES;
                // save
                [[HBSharedUtils currentLeague] save];
                // post newCoach notif (same as newSaveFile)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                [hud hideAnimated:YES];
                // dismiss
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            });
        }]];

        [alert addAction:[UIAlertAction actionWithTitle:@"No, keep looking at offers." style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

-(void)recieveSigningNotif:(NSNotification *)notif {
    selectedTeam = (Team *)notif.object;
    [self finalizeCoachingCarousel];
}

-(void)finalizeCoachingCarousel {
    if (popupController.presented) {
        [popupController dismiss];
    }
    if (selectedTeam) {
        // Are you sure you want to sign with (team)? Your contract will be for 6 years.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Signing Contract with %@", selectedTeam.abbreviation] message:[NSString stringWithFormat:@"Are you sure you want to sign with %@? Your contract will be for 6 years.\n\nThis action will end the coaching carousel. You will not be able to pick another job this offseason.", selectedTeam.name] preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Yes, I'll sign with %@.",self->selectedTeam.abbreviation] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                [hud setMode:MBProgressHUDModeIndeterminate];
                [hud.label setText:[NSString stringWithFormat:@"Signing contract with %@...",self->selectedTeam.abbreviation]];
                for (Team *t in self->availableJobs) {
                    if (t.coaches.count != 0 && (t.coachFired || t.coachRetired)) {
                        [t.coaches removeObjectAtIndex:0]; // remove all fired coaches
                    }
                }

                // yes
                [HBSharedUtils currentLeague].userTeam.isUserControlled = NO;
                [[HBSharedUtils currentLeague].userTeam.coaches removeObject:self->userCoach];
//                self->userCoach.team = self->selectedTeam;
//                self->userCoach.contractYear = 0;
//                self->userCoach.contractLength = 6;
//                self->userCoach.baselinePrestige = self->selectedTeam.teamPrestige;
//                self->userCoach.cumulativePrestige = 0;
                [self->selectedTeam addCoach:self->userCoach];
                [HBSharedUtils currentLeague].userTeam = self->selectedTeam;
                [HBSharedUtils currentLeague].userTeam.isUserControlled = YES;
                [HBSharedUtils currentLeague].userTeam.coachFired = NO;
                [HBSharedUtils currentLeague].userTeam.coachRetired = NO;
                [self->selectedTeam.coaches addObject:self->userCoach];

                if ([[HBSharedUtils currentLeague].coachList containsObject:self->userCoach]) {
                    [[HBSharedUtils currentLeague].coachList removeObject:self->userCoach];
                }
                if ([[HBSharedUtils currentLeague].coachStarList containsObject:self->userCoach]) {
                    [[HBSharedUtils currentLeague].coachStarList removeObject:self->userCoach];
                }

                [hud.label setText:@"Processing remaining open coaching positions..."];
                // process rest of coaching carousel
                [[HBSharedUtils currentLeague] processCoachingCarousel];
                // mark coaching carousel as over
                [HBSharedUtils currentLeague].didFinishCoachingCarousel = YES;
                // save
                [[HBSharedUtils currentLeague] save:^(BOOL success, NSError *err) {
                    // post newCoach notif (same as newSaveFile)
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                    [hud hideAnimated:YES];
                    // dismiss
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
            });
        }]];

        // NO
        // cancel
        [alert addAction:[UIAlertAction actionWithTitle:@"No, let me see other offers." style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadTable {
    if (!selectedIndexPath || !selectedTeam) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    [self.tableView reloadData];
}

-(void)generateDetailStrings {
    lastCCGMap = [NSMutableDictionary dictionary];
    lastBowlMap = [NSMutableDictionary dictionary];
    lastNCGMap = [NSMutableDictionary dictionary];
    NSString *lastCCGYear = @"Never";
    NSString *lastNCGYear = @"Never";
    NSString *lastBowlYear = @"Never";
    for (Team *t in availableJobs) {
        lastCCGYear = @"Never";
        lastNCGYear = @"Never";
        lastBowlYear = @"Never";
        NSMutableArray *years = [NSMutableArray arrayWithArray:t.teamHistoryDictionary.allKeys];
        [years sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [[NSNumber numberWithInt:[obj2 intValue]] compare:[NSNumber numberWithInt:[obj1 intValue]]];
        }];
        if (t.rankTeamPollScore > 24) {
            for (NSString *year in years) {
                NSString *history = t.teamHistoryDictionary[year];
                if ([history containsString:@"Semis"] || [history containsString:@"Bowl -"]) {
                    lastBowlYear = year;
                }
                break;
            }
        } else {
            lastBowlYear = [NSString stringWithFormat:@"%ld", (long)[[HBSharedUtils currentLeague] getCurrentYear]];
        }
        [lastBowlMap setObject:lastBowlYear forKey:t.abbreviation];

        if (![t.confChampion containsString:@"CC"]) {
            for (NSString *year in years) {
                NSString *history = t.teamHistoryDictionary[year];
                if ([history containsString:@"CCG -"]) {
                    lastCCGYear = year;
                }
                break;
            }
        } else {
            lastCCGYear = [NSString stringWithFormat:@"%ld", (long)[[HBSharedUtils currentLeague] getCurrentYear]];
        }
        [lastCCGMap setObject:lastCCGYear forKey:t.abbreviation];

        if (![t.natlChampWL containsString:@"NC"]) {
            for (NSString *year in years) {
                NSString *history = t.teamHistoryDictionary[year];
                if ([history containsString:@"NCG -"]) {
                    lastNCGYear = year;
                }
                break;
            }
        } else {
            lastNCGYear = [NSString stringWithFormat:@"%ld", (long)[[HBSharedUtils currentLeague] getCurrentYear]];
        }
        [lastNCGMap setObject:lastNCGYear forKey:t.abbreviation];
    }
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = nil;
    UIFont *font = nil;
    UIColor *textColor = nil;

    NSMutableDictionary *attributes = [NSMutableDictionary new];

    text = @"No job offers";
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

    text = @"There are no head coaching jobs currently available.";
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


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return availableJobs.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CFCRecruitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFCRecruitCell"];
    Team *t = availableJobs[indexPath.row];
    if (t != nil) {
        [self configureCellForTeam:t indexPath:indexPath cell:cell];
    } else {
        [cell.interestLabel setText:@""];
        [cell.starImageView setImage:nil];
        [cell.nameLabel setText:@""];
        [cell.stateLabel setText:@""];
        [cell.heightLabel setText:@""];
        [cell.weightLabel setText:@""];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

-(void)configureCellForTeam:(Team *)t indexPath:(NSIndexPath *)indexPath cell:(CFCRecruitCell *)cell {
    [cell.nameLabel setText:t.name];
    [cell.stateLabel setText:[NSString stringWithFormat:@"Conference: %@", t.conference]];
    if (userCoach.ratOvr >= [t getMinCoachHireReq]) {
        if ([t.natlChampWL containsString:@"NCW"]) {
            [cell.nameLabel setTextColor:[HBSharedUtils champColor]];
        } else {
            [cell.nameLabel setTextColor:[UIColor blackColor]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    } else {
        [cell.nameLabel setTextColor:[UIColor lightGrayColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    int stars = (int)ceilf([HBSharedUtils mapValue:t.teamPrestige inputMin:50 inputMax:100 outputMin:1 outputMax:5]);
    [cell.starImageView setImage:[UIImage imageNamed:[HBSharedUtils convertStarsToUIImageName:stars]]];
    

    UIColor *interestColor = [HBSharedUtils _calculateInterestColor:[t calculateInterestInCoach:userCoach]];
    NSString *interestString = [HBSharedUtils _calculateInterestString:[t calculateInterestInCoach:userCoach]];
    NSMutableAttributedString *interestAttString = [[NSMutableAttributedString alloc] initWithString:@"Interest: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [interestAttString appendAttributedString:[[NSAttributedString alloc] initWithString:interestString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : interestColor}]];
    [cell.rankLabel setAttributedText:interestAttString];
    
    
    NSMutableAttributedString *lastBowlString = [[NSMutableAttributedString alloc] initWithString:@"Last Bowl: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lastBowlString appendAttributedString:[[NSAttributedString alloc] initWithString:lastBowlMap[t.abbreviation] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];

    NSMutableAttributedString *lastCCGString = [[NSMutableAttributedString alloc] initWithString:@"Last CCG: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lastCCGString appendAttributedString:[[NSAttributedString alloc] initWithString:lastCCGMap[t.abbreviation] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];

    NSMutableAttributedString *lastNCGString = [[NSMutableAttributedString alloc] initWithString:@"Last NCG: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lastNCGString appendAttributedString:[[NSAttributedString alloc] initWithString:lastNCGMap[t.abbreviation] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.heightLabel setAttributedText:lastBowlString];
    [cell.fortyYdDashLabel setAttributedText:lastCCGString];
    [cell.specialtyLabel setAttributedText:lastNCGString];
    [cell.otherOffersLabel setAlpha:0.0];

    NSMutableAttributedString *recordString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld: ", (long)[[HBSharedUtils currentLeague] getCurrentYear]] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [recordString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d-%d",t.wins,t.losses] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];

    NSMutableAttributedString *lifetimeRecordString = [[NSMutableAttributedString alloc] initWithString:@"Lifetime: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [lifetimeRecordString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d-%d",t.totalWins,t.totalLosses] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.weightLabel setAttributedText:recordString];
    [cell.interestLabel setAttributedText:lifetimeRecordString];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Team *t = availableJobs[indexPath.row];
    if (userCoach.ratOvr >= [t getMinCoachHireReq]) {
        TeamViewController *teamVC = [[TeamViewController alloc] initWithTeam:t];
        teamVC.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0.75 * [UIScreen mainScreen].bounds.size.height);
        teamVC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign" style:UIBarButtonItemStyleDone target:teamVC action:@selector(finalizeCoachingCarousel)];
        popupController = [[STPopupController alloc] initWithRootViewController:teamVC];
        [popupController.navigationBar setDraggable:YES];
        popupController.safeAreaInsets = UIEdgeInsetsZero;
        [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    }
}



@end
