//
//  HBSharedUtils.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "HBSharedUtils.h"
#import "AppDelegate.h"
#import "League.h"
#import "Team.h"
#import "Player.h"
#import "HBTeamPlayView.h"

#import "RMessage.h"
#import "HexColors.h"

#import "MockDraftViewController.h"
//#import "RecruitingViewController.h"
#import "RecruitingPeriodViewController.h"
#import "GraduatingPlayersViewController.h"

#define ARC4RANDOM_MAX      0x100000000
static UIColor *styleColor = nil;

@implementation HBSharedUtils


+ (NSString *)recruitingTutorialText {
    return @"At the end of each season, graduating seniors leave the program and spots open up. As coach, you are responsible for recruiting the next class of players that will lead your team to bigger and better wins. You have a maximum amount of effort you can exert while recruiting, which is dependent on your prestige and openings. Better teams will be able to exert more force in recruiting, while weaker teams may have to force their efforts more.\n\nWhen you press \"Start Recruiting\" after the season, you can see who is leaving your program and give you a sense of how many players you will need to replace. Next, the Recruiting menu opens up (where you are now).\n\nHere, you can interact with potential signees and convince them to sign with your program over the others that have extended them offers. The quality of recruits available to you will differ depending on your prestige, denoted in recruits' ranking by avl. (available) or overall. Better programs will be able to recruit blue-chip recruits, while weaker programs will be forced to settle for 2- or 3-stars.\n\nThere are two stages: Winter and Signing Day. During both periods, you have four possible interactions with an uncommitted recruit: offering them a meeting with their positional coach, inviting them on an official visit to campus, offering to visit them at home, and extending them an official offer. The first three interaction with a player will turn their name orange in the list, while extending them an offer will mark them as dark green. When you advance between stages, other teams will make efforts to recruit players. Depending on their interest in your program, recruits will choose to accept your offer or choose another school's. If a recruit accepts your offer, their name will appear in light green. If a recruit commits to a different school, their name will be faded out. If you recruited them and they STILL committed to a different school, their name and the school they committed to will be listed in red. However, you can put in a lot of effort to flip that recruit's commitment, but you may miss out on other recruits in the process.\n\nAt the end of recruiting season, you'll be able to view the recruits that signed with your program. Any remaining positional needs will be filled by walk-on players.\n\nNow, go out there and bolster your team - good luck, coach!";
}

+ (NSString *)depthChartTutorialText {
    return @"This page contains your team's roster, separated into depth charts by position and ordered by overall rating. At any time during the season, you can start or sit players by moving them up or down on the depth chart. Redshirted players will always appear at the bottom of the depth chart. \nThe positions:\n\nQB = Quarterback\n\nRB = Running Back\n\nWR = Wide Reciever\n\nTE = Tight End\n\nOL = Offensive Line\n\nDL = Defensive Line\n\nLB = Linebacker\n\nCB = Cornerback\n\nS = Safety\n\nK = Kicker\n\n\nAt the end of each season, graduating seniors and highly-touted juniors will leave the program and open up spots on the roster, which you can fill during the recruiting period. Over the offseason, players will grow and their stats will improve, as they train and learn from their in-game experience. Some players may even turn into superstars through your offseason training program. Manage your roster carefully, recruit and play the right players, and your team will become a force to be reckoned with. Good luck, coach!";
}

+(double)randomValue {
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

+(NSString*)firstNamesCSV {
    return @"first-names.csv";
}

+(NSString*)lastNamesCSV {
    return @"last-names.csv";
}

+(League*)getLeague {
    League *ligue = [((AppDelegate*)[[UIApplication sharedApplication] delegate]) league];
    ligue.userTeam.isUserControlled = YES;
    return ligue;
}

+(int)leagueRecruitingStage {
    return [HBSharedUtils getLeague].recruitingStage;
}

+(UIColor *)styleColor { //FC Android color: #3EB49F or #3DB39E //FC iOS color: #009740 //USA Red: #BB133E // USA Blue: #002147
    return [UIColor hx_colorWithHexRGBAString:@"#3DB39E"];
}

+(UIColor *)offeredColor {
    return [UIColor hx_colorWithHexRGBAString:@"#009740"];
}

+(UIColor *)progressColor {
    return [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
}

+(UIColor *)errorColor {
    return [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
}

+(UIColor *)successColor {
    return [UIColor hx_colorWithHexRGBAString:@"#1a9641"];
}

+(UIColor *)champColor {
    return [UIColor hx_colorWithHexRGBAString:@"#eeb211"];
}

+(void)setStyleColor:(NSDictionary*)colorDict {
    styleColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorDict[@"color"]];
    [[NSUserDefaults standardUserDefaults] setObject:colorDict forKey:HB_CURRENT_THEME_COLOR];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
     [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setupAppearance];
    
}

+(NSArray*)colorOptions { //FC Android color: #3EB49F //FC iOS color: #009740 //USA Red: #BB133E // USA Blue: #002147
    return @[
  @{@"title" : @"Android Default", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#3EB49F"]]},
  @{@"title" : @"iOS Default", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#009740"]]},
  @{@"title" : @"Old Glory Blue", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#002147"]]},
  @{@"title" : @"Old Glory Red", @"color" : [NSKeyedArchiver archivedDataWithRootObject:[UIColor hx_colorWithHexRGBAString:@"#BB133E"]]}
             ];
}

+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController {
    [HBSharedUtils showNotificationWithTintColor:tintColor title:nil message:message onViewController:viewController];
}

+(void)showNotificationWithTintColor:(UIColor*)tintColor title:(NSString *)title message:(NSString*)message onViewController:(UIViewController*)viewController {
    BOOL weekNotifs = [[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
    if (weekNotifs) {
        if (title == nil) {
            if ([tintColor isEqual:[HBSharedUtils styleColor]]) {
                [RMessage showNotificationInViewController:viewController title:message subtitle:nil type:RMessageTypeCustom customTypeName:@"alternate-success" duration:0.75 callback:nil];
            } else if ([tintColor isEqual:[HBSharedUtils successColor]]) {
                [RMessage showNotificationInViewController:viewController title:message subtitle:nil type:RMessageTypeCustom customTypeName:@"win" duration:0.75 callback:nil];
            } else if ([tintColor isEqual:[HBSharedUtils champColor]]) {
                 [RMessage showNotificationInViewController:viewController title:message subtitle:nil type:RMessageTypeCustom customTypeName:@"champs" duration:0.75 callback:nil];
            } else if ([tintColor isEqual:[HBSharedUtils errorColor]]) {
                [RMessage showNotificationInViewController:viewController title:message subtitle:nil type:RMessageTypeCustom customTypeName:@"alternate-error" duration:0.75 callback:nil];
            } else {
                [RMessage showNotificationInViewController:viewController title:message subtitle:nil type:RMessageTypeCustom customTypeName:@"loss" duration:0.75 callback:nil];
            }
        } else {
            if ([tintColor isEqual:[HBSharedUtils styleColor]]) {
                [RMessage showNotificationInViewController:viewController title:title subtitle:message type:RMessageTypeCustom customTypeName:@"alternate-success" duration:0.75 callback:nil];
            } else if ([tintColor isEqual:[HBSharedUtils successColor]]) {
                [RMessage showNotificationInViewController:viewController title:title subtitle:message type:RMessageTypeCustom customTypeName:@"win" duration:0.75 callback:nil];
            } else if ([tintColor isEqual:[HBSharedUtils champColor]]) {
                [RMessage showNotificationInViewController:viewController title:title subtitle:message type:RMessageTypeCustom customTypeName:@"champs" duration:0.75 callback:nil];
            } else if ([tintColor isEqual:[HBSharedUtils errorColor]]) {
                [RMessage showNotificationInViewController:viewController title:title subtitle:message type:RMessageTypeCustom customTypeName:@"alternate-error" duration:0.75 callback:nil];
            } else {
                [RMessage showNotificationInViewController:viewController title:title subtitle:message type:RMessageTypeCustom customTypeName:@"loss" duration:0.75 callback:nil];
            }
        }
    }
}

+ (NSArray *)states {
    static dispatch_once_t onceToken;
    static NSArray *states;
    dispatch_once(&onceToken, ^{
        states = @[@"Alabama",@"Alaska",@"Arizona",@"Arkansas",@"California",@"Colorado",@"Connecticut",@"Delaware",@"Florida",@"Georgia",@"Hawaii",@"Idaho",@"Illinois",@"Indiana",@"Iowa",@"Kansas",@"Kentucky",@"Louisiana",@"Maine",@"Maryland",@"Massachusetts",@"Michigan",@"Minnesota",@"Mississippi",@"Missouri",@"Montana",@"Nebraska",@"Nevada",@"New Hampshire",@"New Jersey",@"New Mexico",@"New York",@"North Carolina",@"North Dakota",@"Ohio",@"Oklahoma",@"Oregon",@"Pennsylvania",@"Rhode Island",@"South Carolina",@"South Dakota",@"Tennessee",@"Texas",@"Utah",@"Vermont",@"Virginia",@"Washington",@"West Virginia",@"Wisconsin",@"Wyoming",@"Washington DC",@"American Samoa"];
    });
    return states;
}

+ (NSString *)randomState {
    int index = [[self class] randomValue] * 50;
    return [[self class] states][index];
}

+(NSComparisonResult)comparePlayers:(id)obj1 toObj2:(id)obj2 {
    Player *a = (Player*)obj1;
    Player *b = (Player*)obj2;
    if (![a isInjured] && [b isInjured]) {
        return -1;
    } else if ([a isInjured] && ![b isInjured]) {
        return 1;
    } else {
        return a.ratOvr > b.ratOvr ? -1 : (a.ratOvr == b.ratOvr ? 0 : 1);
    }
}

+(NSComparisonResult)comparePositions:(id)obj1 toObj2:(id)obj2 {
    Player *a = (Player*)obj1;
    Player *b = (Player*)obj2;
    int aPos = [Player getPosNumber:a.position];
    int bPos = [Player getPosNumber:b.position];
    return aPos < bPos ? -1 : aPos == bPos ? 0 : 1;
}

+(NSComparisonResult)compareDivTeams:(id)obj1 toObj2:(id)obj2
{
    return [HBSharedUtils comparePlayoffTeams:obj1 toObj2:obj2];
}

+(NSComparisonResult)comparePlayoffTeams:(id)obj1 toObj2:(id)obj2
{
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    int aDivW = [a calculateConfWins];
    int bDivW = [b calculateConfWins];
    
    if ([a.confChampion isEqualToString:@"CC"] && ![b.confChampion isEqualToString:@"CC"])
        return -1;
    else if ([b.confChampion isEqualToString:@"CC"] && ![a.confChampion isEqualToString:@"CC"])
        return 1;
    else if (a.wins > b.wins) {
        return -1;
    } else if (a.wins < b.wins) {
        return 1;
    } else { // wins equal, check head to head
        if (![b.gameWinsAgainst containsObject:a]) {
            // b never won against a
            return -1;
        } else if (![a.gameWinsAgainst containsObject:b]) {
            // a never won against b
            return 1;
        } else { //they both beat each other at least once, check poll score, which will tie break with ppg if necessary
            if (aDivW > bDivW) {
                return -1;
            } else if (bDivW > aDivW) {
                return 1;
            } else {
                return [HBSharedUtils comparePollScore:a toObj2:b];
            }
        }
    }
}

+(NSComparisonResult)compareMVPScore:(id)obj1 toObj2:(id)obj2 {
    Player *a = (Player*)obj1;
    Player *b = (Player*)obj2;
    return [a getHeismanScore] > [b getHeismanScore] ? -1 : [a getHeismanScore] == [b getHeismanScore] ? 0 : 1;
}

+(NSComparisonResult)comparePollScore:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamPollScore > b.teamPollScore ? -1 : a.teamPollScore == b.teamPollScore ? (a.wins > b.wins ? -1 : a.wins == b.wins ? ([[self class] compareTeamPPG:a toObj2:b]) : 1) : 1;
}

+(NSComparisonResult)compareSoW:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamStrengthOfWins > b.teamStrengthOfWins ? -1 : a.teamStrengthOfWins == b.teamStrengthOfWins ? 0 : 1;
}

+(NSComparisonResult)compareTeamPPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamPoints/[a numGames] > b.teamPoints/[b numGames] ? -1 : a.teamPoints/[a numGames] == b.teamPoints/[b numGames] ? 0 : 1;
}
+(NSComparisonResult)compareOppPPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOppPoints/[a numGames] < b.teamOppPoints/[b numGames] ? -1 : a.teamOppPoints/[a numGames] == b.teamOppPoints/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareTeamYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamYards/[a numGames] > b.teamYards/[b numGames] ? -1 : a.teamYards/[a numGames] == b.teamYards/[b numGames] ? 0 : 1;
}
+(NSComparisonResult)compareOppYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOppYards/[a numGames] < b.teamOppYards/[b numGames] ? -1 : a.teamOppYards/[a numGames] == b.teamOppYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareOppPYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOppPassYards/[a numGames] < b.teamOppPassYards/[b numGames] ? -1 : a.teamOppPassYards/[a numGames] == b.teamOppPassYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareOppRYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOppRushYards/[a numGames] < b.teamOppRushYards/[b numGames] ? -1 : a.teamOppRushYards/[a numGames] == b.teamOppRushYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareTeamPYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamPassYards/[a numGames] > b.teamPassYards/[b numGames] ? -1 : a.teamPassYards/[a numGames] == b.teamPassYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareTeamRYPG:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamRushYards/[a numGames] > b.teamRushYards/[b numGames] ? -1 : a.teamRushYards/[a numGames] == b.teamRushYards/[b numGames] ? 0 : 1;
}

+(NSComparisonResult)compareTeamTODiff:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamTODiff > b.teamTODiff ? -1 : a.teamTODiff == b.teamTODiff ? 0 : 1;
}

+(NSComparisonResult)compareTeamOffTalent:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamOffTalent > b.teamOffTalent ? -1 : a.teamOffTalent == b.teamOffTalent ? 0 : 1;
}

+(NSComparisonResult)compareTeamDefTalent:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamDefTalent > b.teamDefTalent ? -1 : a.teamDefTalent == b.teamDefTalent ? 0 : 1;
}

+(NSComparisonResult)compareTeamPrestige:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.teamPrestige > b.teamPrestige ? -1 : a.teamPrestige == b.teamPrestige ? 0 : 1;
}

+(NSComparisonResult)compareTeamLeastWins:(id)obj1 toObj2:(id)obj2 {
    Team *a = (Team*)obj1;
    Team *b = (Team*)obj2;
    return a.wins < b.wins ? -1 : a.wins == b.wins ? 0 : 1;
}

+ (void)startOffseason:(UIViewController*)viewController callback:(void (^)(void))callback {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld %@ Offseason", (long)([HBSharedUtils getLeague].leagueHistoryDictionary.count + [HBSharedUtils getLeague].baseYear), [HBSharedUtils getLeague].userTeam.abbreviation] message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"View Players Leaving" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [viewController.navigationController pushViewController:[[GraduatingPlayersViewController alloc] init] animated:YES];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Start Recruiting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_OFFSEASON_TUTORIAL_SHOWN_KEY];
        if (!tutorialShown) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_OFFSEASON_TUTORIAL_SHOWN_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            //display intro screen
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController *tutorialAlert = [UIAlertController alertControllerWithTitle:@"Offseason Warning" message:@"Once you start the offseason, it is recommended that you do not quit or leave the game until you complete the draft and move on to the next season. Doing so may result in the corruption of your save file. Are you sure you wish to continue?" preferredStyle:UIAlertControllerStyleAlert];
                [tutorialAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingPeriodViewController alloc] init]] animated:YES completion:nil];
                }]];
                [tutorialAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
                [viewController presentViewController:tutorialAlert animated:YES completion:nil];
            });
        } else {
            [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[RecruitingPeriodViewController alloc] init]] animated:YES completion:nil];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"View Mock Draft" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [viewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MockDraftViewController alloc] init]] animated:YES completion:nil];
        });
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
    [viewController presentViewController:alertController animated:YES completion:nil];
    
}

+(void)playWeek:(UIViewController*)viewController headerView:(HBTeamPlayView*)teamHeaderView callback:(void (^)(void))callback {
    League *simLeague = [HBSharedUtils getLeague];
    
    if (simLeague.recruitingStage == 0) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 1;
            [HBSharedUtils getLeague].canRebrandTeam = YES;
            [HBSharedUtils startOffseason:viewController callback:nil];
        } else {
            NSInteger numGamesPlayed = simLeague.userTeam.gameWLSchedule.count;
            [simLeague playWeek];
            [[HBSharedUtils getLeague] save];
            if (simLeague.currentWeek == 15) {
                // Show NCG summary
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)([HBSharedUtils getLeague].baseYear + simLeague.userTeam.teamHistoryDictionary.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
                
                
            } else if (simLeague.userTeam.gameWLSchedule.count > numGamesPlayed) {
                // Played a game, show summary - show notification
                if (simLeague.currentWeek <= 12) {
                    NSString *gameSummary = [simLeague.userTeam weekSummaryString];
                    if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                        [HBSharedUtils showNotificationWithTintColor:[UIColor redColor] title:[NSString stringWithFormat:@"%ld Week %ld", simLeague.baseYear + simLeague.leagueHistoryDictionary.count, (long)simLeague.currentWeek] message:[simLeague.userTeam weekSummaryString] onViewController:viewController];
                    } else {
                        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils successColor] title:[NSString stringWithFormat:@"%ld Week %ld", simLeague.baseYear + simLeague.leagueHistoryDictionary.count, (long)simLeague.currentWeek] message:[simLeague.userTeam weekSummaryString] onViewController:viewController];
                    }
                } else {
                    if (simLeague.currentWeek == 15) {
                        [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
                        NSString *gameSummary = [simLeague.userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor redColor] title:[NSString stringWithFormat:@"%ld National Championship Game", simLeague.baseYear + simLeague.leagueHistoryDictionary.count + 1] message:[simLeague.userTeam weekSummaryString] onViewController:viewController];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils champColor] title:[NSString stringWithFormat:@"%ld National Championship Game", simLeague.baseYear + simLeague.leagueHistoryDictionary.count + 1] message:[simLeague.userTeam weekSummaryString] onViewController:viewController];
                        }
                    } else if (simLeague.currentWeek == 14) {
                        NSString *gameSummary = [simLeague.userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor redColor] title:[NSString stringWithFormat:@"%ld Bowl Season", simLeague.baseYear + simLeague.leagueHistoryDictionary.count] message:[simLeague.userTeam weekSummaryString] onViewController:viewController];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils successColor] title:[NSString stringWithFormat:@"%ld Bowl Season", simLeague.baseYear + simLeague.leagueHistoryDictionary.count] message:[simLeague.userTeam weekSummaryString] onViewController:viewController];
                        }
                    } else if (simLeague.currentWeek == 13) {
                        NSString *gameSummary = [simLeague.userTeam weekSummaryString];
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor redColor] message:[NSString stringWithFormat:@"%ld %@ CCG: %@", simLeague.baseYear + simLeague.leagueHistoryDictionary.count, simLeague.userTeam.conference, [simLeague.userTeam weekSummaryString]] onViewController:viewController];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils successColor] message:[NSString stringWithFormat:@"%ld %@ CCG: %@", simLeague.baseYear + simLeague.leagueHistoryDictionary.count,simLeague.userTeam.conference, [simLeague.userTeam weekSummaryString]] onViewController:viewController];
                        }
                        if ([gameSummary containsString:@" L "] || [gameSummary containsString:@"Lost "]) {
                            [HBSharedUtils showNotificationWithTintColor:[UIColor redColor] title:[NSString stringWithFormat:@"%ld %@ Conference Championship", simLeague.baseYear + simLeague.leagueHistoryDictionary.count, simLeague.userTeam.conference] message:[simLeague.userTeam weekSummaryString] onViewController:viewController];
                        } else {
                            [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils successColor] title:[NSString stringWithFormat:@"%ld %@ Conference Championship", simLeague.baseYear + simLeague.leagueHistoryDictionary.count, simLeague.userTeam.conference] message:[simLeague.userTeam weekSummaryString] onViewController:viewController];
                        }
                    }
                }
                
            }
            
            if (simLeague.currentWeek >= 12) {
                if (simLeague.userTeam.gameSchedule.count > 0) {
                    Game *nextGame = [simLeague.userTeam.gameSchedule lastObject];
                    if (!nextGame.hasPlayed) {
                        NSString *weekGameName = nextGame.gameName;
                        if ([weekGameName isEqualToString:@"NCG"]) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils successColor] title:@"Postseason Update!" message:[NSString stringWithFormat:@"%@ was invited to the %ld National Championship Game!",simLeague.userTeam.name,simLeague.baseYear + simLeague.leagueHistoryDictionary.count + 1] onViewController:viewController];
                            });
                        } else {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils successColor] title:@"Postseason Update!" message:[NSString stringWithFormat:@"%@ was invited to the %ld %@!",simLeague.userTeam.name,simLeague.baseYear + simLeague.leagueHistoryDictionary.count,weekGameName] onViewController:viewController];
                            });
                        }
                    } else if (simLeague.currentWeek == 12) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [HBSharedUtils showNotificationWithTintColor:[UIColor redColor] title:@"Postseason Update!" message:[NSString stringWithFormat:@"%@ was not invited to the %ld %@ CCG.",simLeague.userTeam.name,simLeague.baseYear + simLeague.leagueHistoryDictionary.count,simLeague.userTeam.conference] onViewController:viewController];
                        });
                    } else if (simLeague.currentWeek == 13) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [HBSharedUtils showNotificationWithTintColor:[UIColor redColor] title:@"Postseason Update!" message:[NSString stringWithFormat:@"%@ was not invited to a bowl game this year.",simLeague.userTeam.name] onViewController:viewController];
                        });
                    }
                }
            }
            
            if (simLeague.currentWeek < 12) {
                [HBSharedUtils getLeague].canRebrandTeam = NO;
                [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
                [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
                
                if ([[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON] && simLeague.userTeam.league.currentWeek != 15 && simLeague.userTeam.injuredPlayers.count > 0 && simLeague.userTeam.league.isHardMode) {
                    NSString *injuryReport = [simLeague.userTeam injuryReport];
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Injury Report", simLeague.userTeam.abbreviation] message:injuryReport preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
                    });
                }
                
            } else if (simLeague.currentWeek == 12) {
                [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 13) {
                NSString *heismanString = [simLeague getHeismanCeremonyStr];
                NSArray *heismanParts = [heismanString componentsSeparatedByString:@"?"];
                NSMutableString *composeHeis = [NSMutableString string];
                for (int i = 1; i < heismanParts.count; i++) {
                    [composeHeis appendString:heismanParts[i]];
                }
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld's Player of the Year", (long)([HBSharedUtils getLeague].baseYear + simLeague.userTeam.teamHistoryDictionary.count)] message:composeHeis preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
                
                [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
            } else if (simLeague.currentWeek == 14) {
                [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
            } else {
                [HBSharedUtils getLeague].canRebrandTeam = YES;
                [teamHeaderView.playButton setEnabled:YES];
                [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
                [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSimButton" object:nil];
            }
            
            callback();
        }
    } else {
        simLeague.recruitingStage = 1;
        [HBSharedUtils startOffseason:viewController callback:nil];
    }
}

+(void)simulateEntireSeason:(int)weekTotal viewController:(UIViewController *)viewController headerView:(HBTeamPlayView *)teamHeaderView callback:(void (^)(void))callback {
    League *simLeague = [HBSharedUtils getLeague];
    [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
    [teamHeaderView.playButton setEnabled:NO];
    if (simLeague.recruitingStage == 0) {
        // Perform action on click
        if (simLeague.currentWeek == 15) {
            simLeague.recruitingStage = 1;
            [HBSharedUtils getLeague].canRebrandTeam = YES;
            [[HBSharedUtils getLeague] save];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)([HBSharedUtils getLeague].baseYear + simLeague.userTeam.teamHistoryDictionary.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
        } else {
            float simTime = 0.5;
            if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
                simTime = 1.5;
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(simTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [simLeague playWeek];
                
                if (simLeague.currentWeek < 12) {
                    [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
                    [teamHeaderView.playButton setTitle:@" Play Week" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 12) {
                    NSString *heisman = [simLeague getHeismanCeremonyStr];
                    NSLog(@"HEISMAN: %@", heisman); //can't do anything with this result, just want to run it tbh
                    [teamHeaderView.playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 13) {
                    [teamHeaderView.playButton setTitle:@" Play Bowl Games" forState:UIControlStateNormal];
                } else if (simLeague.currentWeek == 14) {
                    [teamHeaderView.playButton setTitle:@" Play National Championship" forState:UIControlStateNormal];
                } else {
                    [HBSharedUtils getLeague].canRebrandTeam = YES;
                    simLeague.recruitingStage = 1;
                    [((HBTeamPlayView*)teamHeaderView).playButton setEnabled:YES];
                    [teamHeaderView.playButton setTitle:@" Start Recruiting" forState:UIControlStateNormal];
                    [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSimButton" object:nil];
                }
                
                callback();
                if (weekTotal > 1 && simLeague.currentWeek < 15) {
                    NSLog(@"WEEK TOTAL: %d",weekTotal);
                    [[self class] simulateEntireSeason:(weekTotal - 1) viewController:viewController headerView:teamHeaderView callback:callback];
                } else {
                    NSLog(@"NO WEEKS LEFT");
                    if (simLeague.currentWeek > 14) {
                       [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
                    } else {
                        [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
                        [((HBTeamPlayView*)teamHeaderView).playButton setEnabled:YES];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"injuriesPosted" object:nil];
                    [[HBSharedUtils getLeague] save];
                }
            });
        }
    } else {
        [HBSharedUtils startOffseason:viewController callback:nil];
    }
}


+ (CFCRegion)regionForState:(NSString *)state {
    NSArray *northeast = @[@"Connecticut", @"Delaware", @"Maine", @"Massachusetts", @"New Hampshire", @"New Jersey", @"New York", @"Pennsylvania", @"Rhode Island", @"Vermont"];
    NSArray *south = @[@"Alabama", @"Arkansas", @"Florida", @"Georgia", @"Kentucky", @"Louisiana", @"Maryland", @"Mississippi", @"North Carolina", @"Oklahoma", @"South Carolina", @"Tennessee", @"Texas", @"Virginia", @"West Virginia", @"Washington DC"];
    NSArray *west = @[@"Alaska", @"Arizona", @"California", @"Colorado", @"Hawaii", @"Idaho", @"Montana", @"Nevada", @"New Mexico", @"Oregon", @"Utah", @"Washington", @"Wyoming", @"American Samoa"];
    NSArray *midwest = @[@"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Michigan", @"Minnesota", @"Missouri", @"Nebraska", @"North Dakota", @"Ohio", @"South Dakota", @"Wisconsin"];
    if ([northeast containsObject:state]) {
        return CFCRegionNortheast;
    } else if ([south containsObject:state]) {
        return CFCRegionSouth;
    } else if ([west containsObject:state]) {
        return CFCRegionWest;
    } else if ([midwest containsObject:state]) {
        return CFCRegionMidwest;
    } else {
        return CFCRegionUnknown;
    }
}

+ (NSArray *)_orderedNeighboringRegions:(CFCRegion)region {
    switch (region) {
        case CFCRegionNortheast:
            return @[@(CFCRegionNortheast), @(CFCRegionSouth), @(CFCRegionMidwest),@(CFCRegionWest)];
            break;
        case CFCRegionSouth:
            return @[@(CFCRegionSouth), @(CFCRegionNortheast), @(CFCRegionMidwest),@(CFCRegionWest)];
            break;
        case CFCRegionMidwest:
            return @[@(CFCRegionMidwest), @(CFCRegionWest), @(CFCRegionSouth),@(CFCRegionNortheast)];
            break;
        case CFCRegionWest:
            return @[@(CFCRegionWest), @(CFCRegionMidwest), @(CFCRegionSouth),@(CFCRegionNortheast)];
            break;
        default:
            return @[];
            break;
    }
}

+ (CFCRegionDistance)distanceFromRegion:(CFCRegion)region1 toRegion:(CFCRegion)region2 {
    if (region1 == region2) {
        return CFCRegionDistanceMatch;
    } else {
        NSArray *orderedRegions = [[self class] _orderedNeighboringRegions:region1];
        NSInteger rgnIndex = [orderedRegions indexOfObject:@(region2)];
        if (rgnIndex == 0) {
            return CFCRegionDistanceMatch;
        } else if (rgnIndex == 1) {
            return CFCRegionDistanceNeighbor;
        } else if (rgnIndex == 2) {
            return CFCRegionDistanceFar;
        } else {
            return CFCRegionDistanceCrossCountry;
        }
    }
}

+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

@end
