//
//  MyCareerViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/1/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "MyCareerViewController.h"
#import "SettingsViewController.h"
#import "Team.h"
#import "League.h"
#import "HBSharedUtils.h"
#import "TeamHistoryViewController.h"
#import "LeagueHistoryController.h"
#import "TeamStrategyViewController.h"
#import "IntroViewController.h"
#import "RankingsViewController.h"
#import "TeamRecordsViewController.h"
#import "LeagueRecordsViewController.h"
#import "ConferenceStandingsViewController.h"
#import "TeamStreaksViewController.h"
#import "RingOfHonorViewController.h"
#import "HallOfFameViewController.h"
#import "HeadCoachDetailViewController.h"
#import "CFCTeamHistoryView.h"
#import "TeamViewController.h"
#import "HeadCoachHistoryViewController.h"
#import "PlayerStatsViewController.h"
#import "CoachHallOfFameViewController.h"

#import "HexColors.h"
#import "STPopup.h"

@interface MyCareerViewController () <UIViewControllerPreviewingDelegate>
{
    HeadCoach *currentCoach;
    NSArray<TeamStrategy *> *offensiveStrats;
    NSArray<TeamStrategy *> *defensiveStrats;
}
@end

@implementation MyCareerViewController

// 3D Touch methods
-(void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (nullable UIViewController *)previewingContext:(nonnull id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        UIViewController *peekVC;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                peekVC = [[TeamViewController alloc] initWithTeam:currentCoach.team];
            }
        } else if (indexPath.section == 3) {
            if (indexPath.row == 0) {
                //league
                peekVC = [[HeadCoachHistoryViewController alloc] initWithCoach:currentCoach];
            } else if (indexPath.row == 1) { //hallOfFame
                peekVC = [[PlayerStatsViewController alloc] initWithStatType:HBStatPositionHC];
            } else if (indexPath.row == 2) {
                //league
                peekVC = [[LeagueHistoryController alloc] init];
            } else if (indexPath.row == 3) { //hallOfFame
                peekVC = [[CoachHallOfFameViewController alloc] init];
            } else if (indexPath.row == 4) { //hallOfFame
                peekVC = [[HallOfFameViewController alloc] init];
            } else {
                //league records
                peekVC = [[LeagueRecordsViewController alloc] init];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 4) { //hallOfFame
                peekVC = [[HeadCoachDetailViewController alloc] initWithCoach:currentCoach];
            }
        }
        if (peekVC != nil) {
            peekVC.preferredContentSize = CGSizeMake(0.0, 0.60 * [UIScreen mainScreen].bounds.size.height);
            previewingContext.sourceRect = cell.frame;
            return peekVC;
        } else {
            return nil;
        }
    }
    return nil;
}

-(void)presentIntro {
    UINavigationController *introNav = [[UINavigationController alloc] initWithRootViewController:[[IntroViewController alloc] init]];
    [introNav setNavigationBarHidden:YES];
    [self.navigationController.tabBarController presentViewController:introNav animated:YES completion:nil];
}

-(void)setupTeamHeader {
    currentCoach = [[HBSharedUtils currentLeague].userTeam getCurrentHC];
    offensiveStrats = [[HBSharedUtils currentLeague].userTeam getOffensiveTeamStrategies];
    defensiveStrats = [[HBSharedUtils currentLeague].userTeam getDefensiveTeamStrategies];
    [[HBSharedUtils currentLeague] setTeamRanks];
    stats = [[HBSharedUtils currentLeague].userTeam getTeamStatsArray];
    [teamHeaderView.teamRankLabel setText:currentCoach.name];
    [teamHeaderView.teamRecordLabel setText:[NSString stringWithFormat:@"Career: %ld-%ld",(long)currentCoach.totalWins,(long)currentCoach.totalLosses]];
    [teamHeaderView.teamPrestigeLabel setText:[NSString stringWithFormat:@"Age: %d | Overall: %d | Prestige: %@",currentCoach.age, currentCoach.ratOvr,(currentCoach.cumulativePrestige > 0) ? [NSString stringWithFormat:@"+%d", currentCoach.cumulativePrestige] : [NSString stringWithFormat:@"%d", currentCoach.cumulativePrestige]]];
    [teamHeaderView setBackgroundColor:[HBSharedUtils styleColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Career";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(openSettings)];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"team"] style:UIBarButtonItemStylePlain target:self action:@selector(openMyTeamView)];
    [self setupTeamHeader];
    self.tableView.tableHeaderView = teamHeaderView;
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTeamHeader) name:@"endedSeason" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"checkedContracts" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"playedWeek" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadStats) name:@"changedStrategy" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentIntro) name:@"noSaveFile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"newSaveFile" object:nil];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetForNewSeason) name:@"updatedStarters" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupTeamHeader) name:@"updatedCoachName" object:nil];
    
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
}

-(void)resetForNewSeason {
    [self setupTeamHeader];
    [self.tableView reloadData];
}

-(void)openMyTeamView {
    TeamViewController *myTeam = [[TeamViewController alloc] initWithTeam:currentCoach.team];
    myTeam.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.75);
    popupController = [[STPopupController alloc] initWithRootViewController:myTeam];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    [popupController.navigationBar setDraggable:YES];
    popupController.style = STPopupStyleBottomSheet;
    popupController.safeAreaInsets = UIEdgeInsetsZero;
    [popupController presentInViewController:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 2;
    } else if (section == 2) {
        return 5;
    } else {
        return 6;
    }
}


-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else if (section == 1) {
        return @"Coaching Philosophies";
    } else if (section == 2) {
        return @"Attributes";
    } else {
        return @"History";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Current Team"];
            [cell.detailTextLabel setText:currentCoach.team.name];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"Current Status"];
            [cell.detailTextLabel setText:[currentCoach getCoachStatusString]];
            [cell.detailTextLabel setTextColor:[HBSharedUtils _colorForCoachStatus:[currentCoach getCoachStatus]]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Contract Details"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%d years (%d left)", currentCoach.contractLength,(currentCoach.contractLength - currentCoach.contractYear - 1)]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Offensive"];
            [cell.detailTextLabel setText:offensiveStrats[currentCoach.offStratNum].stratName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else {
            [cell.textLabel setText:@"Defensive"];
            [cell.detailTextLabel setText:defensiveStrats[currentCoach.defStratNum].stratName];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Offensive Ability"];
            [cell.detailTextLabel setText:[HBSharedUtils getLetterGrade:currentCoach.ratOff]];
            [cell.detailTextLabel setTextColor:[HBSharedUtils _colorForLetterGrade:[HBSharedUtils getLetterGrade:currentCoach.ratOff]]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Defensive Ability"];
            [cell.detailTextLabel setText:[HBSharedUtils getLetterGrade:currentCoach.ratDef]];
            [cell.detailTextLabel setTextColor:[HBSharedUtils _colorForLetterGrade:[HBSharedUtils getLetterGrade:currentCoach.ratDef]]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"Talent Progression"];
            [cell.detailTextLabel setText:[HBSharedUtils getLetterGrade:currentCoach.ratTalent]];
            [cell.detailTextLabel setTextColor:[HBSharedUtils _colorForLetterGrade:[HBSharedUtils getLetterGrade:currentCoach.ratTalent]]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else if (indexPath.row == 3) {
            [cell.textLabel setText:@"Discipline"];
            [cell.detailTextLabel setText:[HBSharedUtils getLetterGrade:currentCoach.ratDiscipline]];
            [cell.detailTextLabel setTextColor:[HBSharedUtils _colorForLetterGrade:[HBSharedUtils getLetterGrade:currentCoach.ratDiscipline]]];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        } else {
            [cell.detailTextLabel setText:@""];
            [cell.textLabel setText:@"More Details"];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    } else {
        NSString *title = @"";
        [cell.detailTextLabel setText:@""];
        if (indexPath.row == 0) {
            title = @"Coaching History";
        } else if (indexPath.row == 1) {
            title = @"Coaching Leaders";
        } else if (indexPath.row == 2) {
            title = @"League History";
        } else if (indexPath.row == 3) {
            title = @"Coaching Hall of Fame";
        } else if (indexPath.row == 4) {
            title = @"Hall of Fame";
        } else {
            title = @"League Records";
        }
        [cell.textLabel setText:title];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self openMyTeamView];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            popupController = [[STPopupController alloc] initWithRootViewController:[[TeamStrategyViewController alloc] initWithType:TRUE options:[[HBSharedUtils currentLeague].userTeam getOffensiveTeamStrategies]]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            popupController.safeAreaInsets = UIEdgeInsetsZero;
            [popupController presentInViewController:self];
        } else {
            popupController = [[STPopupController alloc] initWithRootViewController:[[TeamStrategyViewController alloc] initWithType:FALSE options:[[HBSharedUtils currentLeague].userTeam getDefensiveTeamStrategies]]];
            [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
            [popupController.navigationBar setDraggable:YES];
            popupController.style = STPopupStyleBottomSheet;
            popupController.safeAreaInsets = UIEdgeInsetsZero;
            [popupController presentInViewController:self];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            //league
            [self.navigationController pushViewController:[[HeadCoachHistoryViewController alloc] initWithCoach:currentCoach] animated:YES];
        } else if (indexPath.row == 1) {
            //league
            [self.navigationController pushViewController:[[PlayerStatsViewController alloc] initWithStatType:HBStatPositionHC] animated:YES];
        } else if (indexPath.row == 2) {
            //league
            [self.navigationController pushViewController:[[LeagueHistoryController alloc] init] animated:YES];
        } else if (indexPath.row == 3) { //hallOfFame
            [self.navigationController pushViewController:[[CoachHallOfFameViewController alloc] init] animated:YES];
        } else if (indexPath.row == 4) { //hallOfFame
            [self.navigationController pushViewController:[[HallOfFameViewController alloc] init] animated:YES];
        } else {
            //league records
            [self.navigationController pushViewController:[[LeagueRecordsViewController alloc] init] animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 4) { //hallOfFame
            [self.navigationController pushViewController:[[HeadCoachDetailViewController alloc] initWithCoach:currentCoach] animated:YES];
        }
    }
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

@end
