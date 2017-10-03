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

#import "CSNotificationView.h"
#import "HexColors.h"

#define ARC4RANDOM_MAX      0x100000000
static UIColor *styleColor = nil;

@implementation HBSharedUtils

+(double)randomValue {
    return ((double)arc4random() / ARC4RANDOM_MAX);
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
    BOOL weekNotifs = [[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
    if (weekNotifs) {
        [CSNotificationView showInViewController:viewController tintColor:tintColor image:nil message:message duration:0.75];
    }
}

+ (NSArray *)states {
    static dispatch_once_t onceToken;
    static NSArray *states;
    dispatch_once(&onceToken, ^{
        states = @[@"Alabama", @"Alaska", @"Arizona", @"Arkansas", @"California", @"Colorado", @"Connecticut", @"Delaware", @"Florida", @"Georgia", @"Hawaii", @"Idaho", @"Illinois", @"Indiana", @"Iowa", @"Kansas", @"Kentucky", @"Louisiana", @"Maine", @"Maryland", @"Massachusetts", @"Michigan", @"Minnesota", @"Mississippi", @"Missouri", @"Montana", @"Nebraska", @"Nevada", @"New Hampshire", @"New Jersey", @"New Mexico", @"New York", @"North Carolina", @"North Dakota", @"Ohio", @"Oklahoma", @"Oregon", @"Pennsylvania", @"Rhode Island", @"South Carolina", @"South Dakota", @"Tennessee", @"Texas", @"Utah", @"Vermont", @"Virginia", @"Washington", @"West Virginia", @"Wisconsin", @"Wyoming"];
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
        return  1;
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

//+(void)playWeek:(UIViewController*)viewController headerView:(UIView*)teamHeaderView callback:(void (^)(void))callback {
//    League *simLeague = [HBSharedUtils currentLeague];
//    
//    //if (simLeague.recruitingStage == 0) {
//    // Perform action on click
//    if (simLeague.currentWeek > 19) {
//        [HBSharedUtils currentLeague].canRebrandTeam = YES;
//        [HBSharedUtils startOffseason:viewController callback:nil];
//    } else {
//        [simLeague playWeek];
//        [[HBSharedUtils currentLeague] save];
//        if (simLeague.currentWeek == 20) {
//            // Show NCG summary
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)(2017 + simLeague.userTeam.teamHistoryDictionary.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
//            [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
//            [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeValue:nil];
//        }
//        
//        if (simLeague.currentWeek > 15) {
//            Game *nextGame = simLeague.userTeam.gameSchedule[simLeague.userTeam.gameSchedule.count - 1];
//            [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeColor:[HBSharedUtils champColor]];
//            if (!nextGame) {
//                [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeValue:nil];
//            } else if (!nextGame.hasPlayed) {
//                NSString *weekGameName = nextGame.gameName;
//                if ([weekGameName isEqualToString:@"Champs Bowl"]) {
//                    [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"ChBwl"];
//                } else if ([weekGameName containsString:@"Div Rd"]) {
//                    [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"Div"];
//                } else if ([weekGameName containsString:@"WC Rd"]) {
//                    [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"WC"];
//                } else if ([weekGameName containsString:@"CCG"]) {
//                    [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"CCG"];
//                }
//            } else if (simLeague.currentWeek == 16) {
//                if (![simLeague.playoffsAM containsObject:simLeague.userTeam] && ![simLeague.playoffsNA containsObject:simLeague.userTeam]) {
//                    [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeValue:nil];
//                } else {
//                    [viewController.navigationController.tabBarController.tabBar.items[1] setBadgeValue:@"Div"];
//                }
//            }
//            
//        }
//        
//        if (simLeague.currentWeek < 16) {
//            [HBSharedUtils currentLeague].canRebrandTeam = NO;
//            [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Week" forState:UIControlStateNormal];
//            
//            if (simLeague.userTeam.league.currentWeek != 20) {
//                if (simLeague.userTeam.injuredPlayers.count > 0) {
//                    [viewController.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = [NSString stringWithFormat:@"%lu", (long)simLeague.userTeam.injuredPlayers.count];
//                } else {
//                    [viewController.navigationController.tabBarController.tabBar.items objectAtIndex:2].badgeValue = nil;
//                }
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateInjuryCount" object:nil];
//            }
//            
//        } else if (simLeague.currentWeek == 16) {
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Wild Card Round" forState:UIControlStateNormal];
//        } else if (simLeague.currentWeek == 17) {
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Divisional Round" forState:UIControlStateNormal];
//        } else if (simLeague.currentWeek == 18) {
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
//        } else if (simLeague.currentWeek == 19) {
//            NSString *heismanString = [simLeague getMVPCeremonyStr];
//            NSArray *heismanParts = [heismanString componentsSeparatedByString:@"?"];
//            NSMutableString *composeHeis = [NSMutableString string];
//            for (int i = 1; i < heismanParts.count; i++) {
//                [composeHeis appendString:heismanParts[i]];
//            }
//            
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld's Most Valuable Player", (long)(2017 + simLeague.userTeam.teamHistoryDictionary.count)] message:composeHeis preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
//            [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Champions Bowl" forState:UIControlStateNormal];
//        } else {
//            [HBSharedUtils currentLeague].canRebrandTeam = YES;
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Start Offseason" forState:UIControlStateNormal];
//            [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSimButton" object:nil];
//        }
//        
//        callback();
//    }
//}
//
//+(void)simulateEntireSeason:(int)weekTotal viewController:(UIViewController *)viewController headerView:(UIView *)teamHeaderView callback:(void (^)(void))callback {
//    League *simLeague = [HBSharedUtils currentLeague];
//    [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
//    [[(HBTeamPlayView*)teamHeaderView playButton] setEnabled:NO];
//    float simTime = 0.5;
//    if (IS_IPHONE_5 || IS_IPHONE_4_OR_LESS) {
//        simTime = 1.0;
//    }
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(simTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [simLeague playWeek];
//        
//        if (simLeague.currentWeek < 16) {
//            [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Week" forState:UIControlStateNormal];
//        } else if (simLeague.currentWeek == 16) {
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Wild Card Round" forState:UIControlStateNormal];
//        } else if (simLeague.currentWeek == 17) {
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Divisional Round" forState:UIControlStateNormal];
//        } else if (simLeague.currentWeek == 18) {
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Conf Championships" forState:UIControlStateNormal];
//        } else if (simLeague.currentWeek == 19) {
//            NSString *mvp = [simLeague getMVPCeremonyStr];
//            NSLog(@"HEISMAN: %@", mvp); //can't do anything with this result, just want to run it tbh
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Play Champions Bowl" forState:UIControlStateNormal];
//        } else {
//            [HBSharedUtils currentLeague].canRebrandTeam = YES;
//            [((HBTeamPlayView*)teamHeaderView).playButton setTitle:@" Start Offseason" forState:UIControlStateNormal];
//            [viewController.navigationItem.leftBarButtonItem setEnabled:NO];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"hideSimButton" object:nil];
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%ld Season Summary", (long)(2017 + simLeague.userTeam.teamHistoryDictionary.count)] message:[simLeague seasonSummaryStr] preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
//            [viewController.tabBarController presentViewController:alertController animated:YES completion:nil];
//        }
//        
//        callback();
//        
//        if (weekTotal > 1) {
//            NSLog(@"WEEK TOTAL: %d",weekTotal);
//            [[self class] simulateEntireSeason:(weekTotal - 1) viewController:viewController headerView:teamHeaderView callback:callback];
//        } else {
//            NSLog(@"NO WEEKS LEFT");
//            if (simLeague.currentWeek == 20) {
//                [((HBTeamPlayView*)teamHeaderView).playButton setEnabled:YES];
//            } else {
//                [viewController.navigationItem.leftBarButtonItem setEnabled:YES];
//                [((HBTeamPlayView*)teamHeaderView).playButton setEnabled:YES];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"injuriesPosted" object:nil];
//            [[HBSharedUtils currentLeague] save];
//        }
//    });
//}


@end
