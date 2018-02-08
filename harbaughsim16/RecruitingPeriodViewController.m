//
//  RecruitingPeriodViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/28/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "RecruitingPeriodViewController.h"
#import "League.h"
#import "Team.h"
#import "TeamRosterViewController.h"
#import "PlayerDetailViewController.h"

#import "Player.h"
#import "PlayerQB.h"
#import "PlayerRB.h"
#import "PlayerWR.h"
#import "PlayerK.h"
#import "PlayerOL.h"
#import "PlayerDL.h"
#import "PlayerTE.h"
#import "PlayerLB.h"
#import "PlayerCB.h"
#import "PlayerS.h"

#import "CFCRecruitCell.h"
#import "NSArray+Uniqueness.h"

#import "STPopup.h"
#import "HexColors.h"
@import ScrollableSegmentedControl;
#import "MBProgressHUD.h"
#import "RMessage.h"
#import "UIScrollView+EmptyDataSet.h"
#import "ZGNavigationBarTitleViewController.h"

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...) (void)0
#endif

@interface RecruitingPeriodViewController () <DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
{
    ScrollableSegmentedControl *positionSelectionControl;
    STPopupController *popupController;

    NSMutableArray *totalRecruits;
    NSMutableArray *currentRecruits;

    NSMutableArray<Player*>* availQBs;
    NSMutableArray<Player*>* availRBs;
    NSMutableArray<Player*>* availWRs;
    NSMutableArray<Player*>* availTEs;
    NSMutableArray<Player*>* availOLs;
    NSMutableArray<Player*>* availKs;
    NSMutableArray<Player*>* availSs;
    NSMutableArray<Player*>* availCBs;
    NSMutableArray<Player*>* availLBs;
    NSMutableArray<Player*>* availDLs;

    NSInteger needQBs;
    NSInteger needRBs;
    NSInteger needWRs;
    NSInteger needTEs;
    NSInteger needOLs;
    NSInteger needKs;
    NSInteger needsS;
    NSInteger needCBs;
    NSInteger needLBs;
    NSInteger needDLs;

    CFCRecruitingStage recruitingStage;
    BOOL allPlayersAvailable;
    BOOL sortedByInterest;

}
@end

@implementation RecruitingPeriodViewController
@synthesize signedRecruitRanks,progressedRecruits,recruitingPoints,usedRecruitingPoints,recruitActivities;

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)reloadRecruits {
    [totalRecruits removeAllObjects];

    [availQBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];

    [availRBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];
    [availWRs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];
    [availTEs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];
    [availOLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];
    [availDLs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];

    [availLBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];

    [availCBs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];
    [availSs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];
    [availKs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];

    [totalRecruits addObjectsFromArray:availQBs];
    [totalRecruits addObjectsFromArray:availRBs];
    [totalRecruits addObjectsFromArray:availWRs];
    [totalRecruits addObjectsFromArray:availTEs];
    [totalRecruits addObjectsFromArray:availOLs];
    [totalRecruits addObjectsFromArray:availDLs];
    [totalRecruits addObjectsFromArray:availLBs];
    [totalRecruits addObjectsFromArray:availCBs];
    [totalRecruits addObjectsFromArray:availSs];
    [totalRecruits addObjectsFromArray:availKs];

    [totalRecruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(NSInteger)_indexForPosition:(Player *)p {
    NSMutableArray *array;
    if ([p.position isEqualToString:@"QB"]) {
        array = availQBs;
    } else if ([p.position isEqualToString:@"RB"]) {
        array = availRBs;
    } else if ([p.position isEqualToString:@"WR"]) {
        array = availWRs;
    } else if ([p.position isEqualToString:@"OL"]) {
        array = availOLs;
    } else if ([p.position isEqualToString:@"TE"]) {
        array = availTEs;
    } else if ([p.position isEqualToString:@"K"]) {
        array = availKs;
    } else if ([p.position isEqualToString:@"S"]) {
        array = availSs;
    } else if ([p.position isEqualToString:@"CB"]) {
        array = availCBs;
    } else if ([p.position isEqualToString:@"DL"]) {
        array = availDLs;
    } else if ([p.position isEqualToString:@"LB"]) {
        array = availLBs;
    } else { // unknown
        array = [NSMutableArray array];
    }
    return [array indexOfObject:p];
}

-(void)advanceRecruits {
    // For 2 rounds (dec and feb signing days):
    //      - choose a random offer and increase its interest by a random set of events
    //      - if the offer puts interest for a team at 100+, have the team sign the recruit, add committed event, and fade them from the board
    // After round 2 (feb signing day):
    //      1. if highest-interest team is user team, then:
    //          * color name
    //          * change status to committed
    //      2. if highest-interest team is NOT user team, then:
    //          * if interest in user team was medium or high, then:
    //              * offer to flip (for large amount of effort)
    //          * else:
    //              * fade name

    __block NSDictionary<NSNumber *, NSNumber *> *eventsValues = @{@(CFCRecruitEventPositionCoachMeeting) : @(MEETING_INTEREST_BONUS), @(CFCRecruitEventOfficialVisit): @(OFFICIAL_VISIT_INTEREST_BONUS), @(CFCRecruitEventInHomeVisit) : @(INHOME_VISIT_INTEREST_BONUS)};
    if (recruitingStage != CFCRecruitingStageFallCamp) { // process winter and move to early/late signing day

        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [hud setMode:MBProgressHUDModeIndeterminate];

        if (recruitingStage == CFCRecruitingStageWinter) {
            [hud.label setText:[NSString stringWithFormat:@"Advancing to Early Signing Day..."]];
        } else if (recruitingStage == CFCRecruitingStageEarlySigningDay) {
            [hud.label setText:[NSString stringWithFormat:@"Advancing to Signing Day..."]];
        } else {
            [hud.label setText:[NSString stringWithFormat:@"Advancing to Fall Camps..."]];
        }

        __block League *currentLeague = [HBSharedUtils currentLeague];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            for (Player *p in totalRecruits) {
                if (p.team == nil || p.recruitStatus != CFCRecruitStatusCommitted) {
                    // choose a random offer and increase its interest by a random set of events
                    if (p.offers != nil && p.offers.allKeys.count > 0) {
                        if (recruitingStage != CFCRecruitingStageSigningDay) {
                            if (!(p.offers.count == 1 && [p.offers.allKeys containsObject:currentLeague.userTeam.abbreviation])) {
                                NSString *randomOffer;
                                // NSLog(@"STARTING TO FIND RANDOM OFFER FROM: %@", p.offers.allKeys);
                                while (randomOffer == nil || [randomOffer isEqualToString:currentLeague.userTeam.abbreviation]) {
                                    randomOffer = [p.offers.allKeys getElementsRandomly:1][0];
                                    // NSLog(@"CYCLED RAND OFFER");
                                }
                                // NSLog(@"VALID RANDOM OFFER FOUND: %@", randomOffer);
                                
                                // NSLog(@"ADDING EVENTS FOR OFFER: %@", randomOffer);
                                NSArray *randomEventsSet = [eventsValues.allKeys getElementsRandomly:(int)([HBSharedUtils randomValue] * 3)];
                                // NSLog(@"PICKED EVENTS");
                                int offerInterest = p.offers[randomOffer].intValue;
                                for (NSNumber *eventType in randomEventsSet) {
                                    offerInterest += eventsValues[eventType].intValue;
                                }
                                // NSLog(@"UPDATED INTEREST STATS, SAVING OFFER: %@", randomOffer);
                                [p.offers setObject:@(offerInterest) forKey:randomOffer];
                                // NSLog(@"SAVED OFFER: %@", randomOffer);
                            }
                        }

                        // if the offer puts interest for a team at 100+:
                        // NSLog(@"SORTING OFFERS TO FIND TOP ONES");
                        NSArray *sortedOffers = [p.offers keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            return [obj2 compare:obj1];
                        }];

                        // NSLog(@"RETREIVING TOP OFFER FROM: %@", sortedOffers);
                        NSString *highestOffer = sortedOffers[0];
                        // NSLog(@"PROCESSING TOP OFFER: %@", highestOffer);
                        if (recruitingStage != CFCRecruitingStageSigningDay) {
                            if (p.offers[highestOffer].intValue > 99) {
                                // sign him to that team
                                // NSLog(@"STAGE %d - SIGNING PLAYER TO %@", recruitingStage, highestOffer);
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    Team *t = [currentLeague findTeam:highestOffer];
                                    if (![t.recruitingClass containsObject:p]) {
                                        [p setRecruitStatus:CFCRecruitStatusCommitted];
                                        [p setTeam:t];
                                        [t.recruitingClass addObject:p];
                                        
                                        if (t == currentLeague.userTeam) {
                                            [signedRecruitRanks setObject:[NSString stringWithFormat:@"#%lu %@ (#%lu ovr)", (long)([self _indexForPosition:p] + 1), p.position, (long)([totalRecruits indexOfObject:p] + 1)] forKey:[p uniqueIdentifier]];
                                        }
                                    }
                                });
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                Team *t = [currentLeague findTeam:highestOffer];
                                // NSLog(@"STAGE %d - SIGNING PLAYER TO %@", recruitingStage, highestOffer);
                                if (![t.recruitingClass containsObject:p]) {
                                    [p setRecruitStatus:CFCRecruitStatusCommitted];
                                    [p setTeam:t];
                                    [t.recruitingClass addObject:p];
                                
                                    if (t == currentLeague.userTeam) {
                                        [signedRecruitRanks setObject:[NSString stringWithFormat:@"#%lu %@ (#%lu ovr)", (long)([self _indexForPosition:p] + 1), p.position, (long)([totalRecruits indexOfObject:p] + 1)] forKey:[p uniqueIdentifier]];
                                    }
                                }
                            });
                        }
                    } else {
                        NSLog(@"YOU AIN'T GOT NO OFFERS, LT. DAN!");
                    }
                }
            }

            // NSLog(@"THROWING IT BACK TO MAIN THREAD FOR UI UPDATES");

            dispatch_async(dispatch_get_main_queue(), ^{
                if ([HBSharedUtils currentLeague].isHardMode) {
                    if (recruitingStage == CFCRecruitingStageWinter) {
                        recruitingStage = CFCRecruitingStageEarlySigningDay;
                        // NSLog(@"STARTING SIGNING DAY, STAGE %d", recruitingStage);
                        self.title = [NSString stringWithFormat:@"Early Signing Day %lu", (long)([[HBSharedUtils currentLeague] getCurrentYear] + 1)];
                        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(advanceRecruits)];
                    } else if (recruitingStage == CFCRecruitingStageEarlySigningDay) {
                        recruitingStage = CFCRecruitingStageSigningDay;
                        // NSLog(@"STARTING SIGNING DAY, STAGE %d", recruitingStage);
                        self.title = [NSString stringWithFormat:@"Signing Day %lu", (long)([[HBSharedUtils currentLeague] getCurrentYear] + 1)];
                        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(advanceRecruits)];
                    } else {
                        recruitingStage = CFCRecruitingStageFallCamp;
                        // NSLog(@"SHOWING RECRUITING CLASS, STAGE %d", recruitingStage);
                        self.title = [NSString stringWithFormat:@"%lu Recruiting Class",  (long)([[HBSharedUtils currentLeague] getCurrentYear] + 1)];
                        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStyleDone target:self action:@selector(finishRecruitingSeason)];
                    }
                } else {
                    if (recruitingStage == CFCRecruitingStageWinter) {
                        recruitingStage = CFCRecruitingStageSigningDay;
                        // NSLog(@"STARTING SIGNING DAY, STAGE %d", recruitingStage);
                        self.title = [NSString stringWithFormat:@"Signing Day %lu", (long)([[HBSharedUtils currentLeague] getCurrentYear] + 1)];
                        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(advanceRecruits)];
                    } else {
                        recruitingStage = CFCRecruitingStageFallCamp;
                        // NSLog(@"SHOWING RECRUITING CLASS, STAGE %d", recruitingStage);
                        self.title = [NSString stringWithFormat:@"%lu Recruiting Class",  (long)([[HBSharedUtils currentLeague] getCurrentYear] + 1)];
                        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Finish" style:UIBarButtonItemStyleDone target:self action:@selector(finishRecruitingSeason)];
                    }
                }

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                    if (recruitingStage == CFCRecruitingStageFallCamp) {
                        [positionSelectionControl removeFromSuperview];
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                        self.navigationController.toolbarHidden = YES;
                        if (@available(iOS 11, *)) {
                            [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
                        } else {
                            [self.tableView setContentInset:UIEdgeInsetsMake(self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, 0, 0, 0)];
                        }
                    }
                    [self.tableView reloadData];
                });
            });
        });
    }
}

-(void)calculateTeamNeeds {
    //since players haven't actually left yet, adding needs from playersLeaving and subtracting needs for recruits who signed
    Team *t = [HBSharedUtils currentLeague].userTeam;

    needQBs = MAX(0, 2 - t.teamQBs.count + [self _calculateNeededPlayersAtPosition:@"QB"] - [self _calculateSignedPlayersAtPosition:@"QB"]);
    needRBs = MAX(0, 4 - t.teamRBs.count + [self _calculateNeededPlayersAtPosition:@"RB"] - [self _calculateSignedPlayersAtPosition:@"RB"]);
    needWRs = MAX(0, 6 - t.teamWRs.count + [self _calculateNeededPlayersAtPosition:@"WR"] - [self _calculateSignedPlayersAtPosition:@"WR"]);
    needTEs = MAX(0, 2 - t.teamTEs.count + [self _calculateNeededPlayersAtPosition:@"TE"] - [self _calculateSignedPlayersAtPosition:@"TE"]);
    needOLs = MAX(0, 10 - t.teamOLs.count + [self _calculateNeededPlayersAtPosition:@"OL"] - [self _calculateSignedPlayersAtPosition:@"OL"]);
    needDLs = MAX(0, 8 - t.teamDLs.count + [self _calculateNeededPlayersAtPosition:@"DL"] - [self _calculateSignedPlayersAtPosition:@"DL"]);
    needLBs = MAX(0, 6 - t.teamLBs.count + [self _calculateNeededPlayersAtPosition:@"LB"] - [self _calculateSignedPlayersAtPosition:@"LB"]);
    needCBs = MAX(0, 6 - t.teamCBs.count + [self _calculateNeededPlayersAtPosition:@"CB"] - [self _calculateSignedPlayersAtPosition:@"CB"]);
    needsS = MAX(0, 2 - t.teamSs.count + [self _calculateNeededPlayersAtPosition:@"S"] - [self _calculateSignedPlayersAtPosition:@"S"]);
    needKs = MAX(0, 2 - t.teamKs.count + [self _calculateNeededPlayersAtPosition:@"K"] - [self _calculateSignedPlayersAtPosition:@"K"]);
}

-(void)showRemainingNeeds {
    // TODO: add snippet to line if recruit at position has been interacted with but not signed - EX: "Need 1 active QB (1 on watchlist)"
    [self calculateTeamNeeds];
    NSMutableString *summary = [NSMutableString string];

    if (needQBs > 0) {
        if (needQBs > 1) {
            [summary appendFormat:@"Need %ld active QBs",(long)needQBs];
        } else {
            [summary appendFormat:@"Need %ld active QB",(long)needQBs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"QB"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (needRBs > 0) {
        if (needRBs > 1) {
            [summary appendFormat:@"Need %ld active RBs",(long)needRBs];
        } else {
            [summary appendFormat:@"Need %ld active RB",(long)needRBs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"RB"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (needWRs > 0) {
        if (needWRs > 1) {
            [summary appendFormat:@"Need %ld active WRs",(long)needWRs];
        } else {
            [summary appendFormat:@"Need %ld active WR",(long)needWRs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"WR"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (needTEs > 0) {
        if (needTEs > 1) {
            [summary appendFormat:@"Need %ld active TEs",(long)needTEs];
        } else {
            [summary appendFormat:@"Need %ld active TE",(long)needTEs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"TE"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (needOLs > 0) {
        if (needOLs > 1) {
            [summary appendFormat:@"Need %ld active OLs",(long)needOLs];
        } else {
            [summary appendFormat:@"Need %ld active OL",(long)needOLs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"OL"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }
    
    if (needDLs > 0) {
        if (needDLs > 1) {
            [summary appendFormat:@"Need %ld active DLs",(long)needDLs];
        } else {
            [summary appendFormat:@"Need %ld active DL",(long)needDLs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"DL"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (needLBs > 0) {
        if (needLBs > 1) {
            [summary appendFormat:@"Need %ld active LBs",(long)needLBs];
        } else {
            [summary appendFormat:@"Need %ld active LB",(long)needLBs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"LB"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (needCBs > 0) {
        if (needCBs > 1) {
            [summary appendFormat:@"Need %ld active CBs",(long)needCBs];
        } else {
            [summary appendFormat:@"Need %ld active CB",(long)needCBs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"CB"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (needsS > 0) {
        if (needsS > 1) {
            [summary appendFormat:@"Need %ld active Ss",(long)needsS];
        } else {
            [summary appendFormat:@"Need %ld active S",(long)needsS];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"S"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (needKs > 0) {
        if (needKs > 1) {
            [summary appendFormat:@"Need %ld active Ks",(long)needKs];
        } else {
            [summary appendFormat:@"Need %ld active K",(long)needKs];
        }
        
        NSInteger progressed = [self _calculateProgressedPlayersAtPosition:@"K"];
        if (progressed > 0) {
            [summary appendFormat:@" (%ld on watchlist)", (long)progressed];
        }
        
        [summary appendString:@"\n\n"];
    }

    if (summary.length == 0 || [summary isEqualToString:@""]) {
        [summary appendString:@"All positional needs filled!"];
    }

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ Remaining Needs",[HBSharedUtils currentLeague].userTeam.abbreviation] message:summary preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [alertController.view setNeedsLayout];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(NSInteger)_calculateNeededPlayersAtPosition:(NSString *)pos {
    return [self _calculateNeededPlayersAtPosition:pos team:[HBSharedUtils currentLeague].userTeam];
}

-(NSInteger)_calculateNeededPlayersAtPosition:(NSString *)pos team:(Team*)t {
    NSMutableArray *mapped = [NSMutableArray array];
    [t.playersLeaving enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Player *p = (Player *)obj;
        if ([p.position isEqualToString:pos]) {
            [mapped addObject:p];
        }
    }];
    return mapped.count;
}

-(NSInteger)_calculateSignedPlayersAtPosition:(NSString *)pos {
    NSMutableArray *mapped = [NSMutableArray array];
    [progressedRecruits enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Player *p = (Player *)obj;
        if ([p.position isEqualToString:pos] && p.recruitStatus == CFCRecruitStatusCommitted && p.team == [HBSharedUtils currentLeague].userTeam) {
            [mapped addObject:p];
        }
    }];
    return mapped.count;
}

-(NSInteger)_calculateProgressedPlayersAtPosition:(NSString *)pos {
    NSMutableArray *mapped = [NSMutableArray array];
    [progressedRecruits enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Player *p = (Player *)obj;
        if ([p.position isEqualToString:pos] && p.recruitStatus != CFCRecruitStatusCommitted) {
            [mapped addObject:p];
        }
    }];
    return mapped.count;
}

-(void)viewRoster {
    TeamRosterViewController *roster = [[TeamRosterViewController alloc] initWithTeam:[HBSharedUtils currentLeague].userTeam];
    roster.isPopup = YES;
    popupController = [[STPopupController alloc] initWithRootViewController:roster];
    [popupController.navigationBar setDraggable:YES];
    [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
    popupController.style = STPopupStyleBottomSheet;
    [popupController presentInViewController:self];
}

-(void)finishRecruitingSeason {
    [[HBSharedUtils currentLeague] updateTeamHistories];
    [[HBSharedUtils currentLeague] updateLeagueHistory];
    [[HBSharedUtils currentLeague].userTeam resetStats];
    [[HBSharedUtils currentLeague] advanceSeason];

    for (Team *t in [HBSharedUtils currentLeague].teamList) {
        for (Player *p in t.recruitingClass) {
            [t addPlayer:p];
        }
        // if necessary, add walk-ons
        if (t.isUserControlled) {
            [t recruitWalkOns:@[@(2 - t.teamQBs.count), @(4 - t.teamRBs.count), @(6 - t.teamWRs.count), @(2 - t.teamKs.count), @(10 - t.teamOLs.count), @(2 - t.teamSs.count), @(6 - t.teamCBs.count), @(8 - t.teamDLs.count), @(6 - t.teamLBs.count), @(2 - t.teamTEs.count)]];
        } else {
            [t recruitPlayersFreshman:@[@(2 - t.teamQBs.count), @(4 - t.teamRBs.count), @(6 - t.teamWRs.count), @(2 - t.teamKs.count), @(10 - t.teamOLs.count), @(2 - t.teamSs.count), @(6 - t.teamCBs.count), @(8 - t.teamDLs.count), @(6 - t.teamLBs.count), @(2 - t.teamTEs.count)]];
        }

        [t calculateRecruitingClassRanking];
    }
    [[HBSharedUtils currentLeague] setTeamRanks];

    // post a news story about recruiting
    [[HBSharedUtils currentLeague].teamList sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareRecruitingComposite:obj1 toObj2:obj2];
    }];
    NSMutableString *recruitingRanks = [NSMutableString stringWithFormat:@"%@ leads the pack, has best recruiting class of %lu\n%@ has the nation's best recruiting class this year, pulling in %lu recruits and posting a composite score of %d. Rounding out the top 5 are: ", [HBSharedUtils currentLeague].teamList[0].abbreviation, (long)[[HBSharedUtils currentLeague] getCurrentYear], [HBSharedUtils currentLeague].teamList[0].name, (long)[HBSharedUtils currentLeague].teamList[0].recruitingClass.count, [HBSharedUtils currentLeague].teamList[0].teamRecruitingClassScore];
    for (int i = 1; i < 5; i++) {
        Team *t = [HBSharedUtils currentLeague].teamList[i];
        if (i == 4) {
            [recruitingRanks appendFormat:@"and %d) %@.", (i + 1), t.name];
        } else {
            [recruitingRanks appendFormat:@"%d) %@, ", (i + 1), t.name];
        }
    }
    [[HBSharedUtils currentLeague].newsStories[0] addObject:recruitingRanks];

    [[HBSharedUtils currentLeague] setTeamRanks];
    for (Team *t in [HBSharedUtils currentLeague].teamList) {
        // clear the recruiting classes
        t.recruitingClass = [NSMutableArray array];
        [t updateTalentRatings];
    }

    [HBSharedUtils currentLeague].recruitingStage = 0;
    [[HBSharedUtils currentLeague] save];

    if ([HBSharedUtils currentLeague].isHardMode && [[HBSharedUtils currentLeague].cursedTeam isEqual:[HBSharedUtils currentLeague].userTeam]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userTeamSanctioned" object:nil];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newSeasonStart" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endedSeason" object:nil];

    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)selectPosition:(ScrollableSegmentedControl *)sender {
    //// NSLog(@"POSITION %lu SELECTED", (long)sender.selectedSegmentIndex);
    if (progressedRecruits.count > 0) {
        switch (sender.selectedSegmentIndex) {
            case 0:
                currentRecruits = totalRecruits;
                break;
            case 1:
                currentRecruits = progressedRecruits;
                break;
            case 2:
                currentRecruits = availQBs;
                break;
            case 3:
                currentRecruits = availRBs;
                break;
            case 4:
                currentRecruits = availWRs;
                break;
            case 5:
                currentRecruits = availTEs;
                break;
            case 6:
                currentRecruits = availOLs;
                break;
            case 7:
                currentRecruits = availDLs;
                break;
            case 8:
                currentRecruits = availLBs;
                break;
            case 9:
                currentRecruits = availCBs;
                break;
            case 10:
                currentRecruits = availSs;
                break;
            case 11:
                currentRecruits = availKs;
                break;
            default:
                break;
        }
    } else {
        switch (sender.selectedSegmentIndex) {
            case 0:
                currentRecruits = totalRecruits;
                break;
            case 1:
                currentRecruits = availQBs;
                break;
            case 2:
                currentRecruits = availRBs;
                break;
            case 3:
                currentRecruits = availWRs;
                break;
            case 4:
                currentRecruits = availTEs;
                break;
            case 5:
                currentRecruits = availOLs;
                break;
            case 6:
                currentRecruits = availDLs;
                break;
            case 7:
                currentRecruits = availLBs;
                break;
            case 8:
                currentRecruits = availCBs;
                break;
            case 9:
                currentRecruits = availSs;
                break;
            case 10:
                currentRecruits = availKs;
                break;
            default:
                break;
        }
    }

    if (sortedByInterest) {
        [currentRecruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            Player *p1 = (Player *)obj1;
            Player *p2 = (Player *)obj2;
            return [[NSNumber numberWithInt:[self _calculateTotalInterestLevel:p2]] compare:[NSNumber numberWithInt:[self _calculateTotalInterestLevel:p1]]];
        }];
    } else {
        [currentRecruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils compareStars:obj1 toObj2:obj2];
        }];
    }

    [self.tableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
}

-(int)_calculateTotalInterestLevel:(Player *)p {
    NSMutableArray *recruitEvents = ([recruitActivities.allKeys containsObject:[p uniqueIdentifier]]) ? recruitActivities[[p uniqueIdentifier]] : [NSMutableArray array];

    if (![p.offers.allKeys containsObject:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        int interestVal1 = [p calculateInterestInTeam:[HBSharedUtils currentLeague].userTeam];
        if ([recruitEvents containsObject:@(CFCRecruitEventPositionCoachMeeting)]) {
            interestVal1 += MEETING_INTEREST_BONUS;
        }
        if ([recruitEvents containsObject:@(CFCRecruitEventOfficialVisit)]) {
            interestVal1 += OFFICIAL_VISIT_INTEREST_BONUS;
        }
        if ([recruitEvents containsObject:@(CFCRecruitEventInHomeVisit)]) {
            interestVal1 += INHOME_VISIT_INTEREST_BONUS;
        }
        return interestVal1;
    } else {
        return [p.offers[[HBSharedUtils currentLeague].userTeam.abbreviation] intValue];
    }
}

-(void)activateSortByInterest {
    //// NSLog(@"SORTING BY INTEREST");
    sortedByInterest = !sortedByInterest;
    [positionSelectionControl setSelectedSegmentIndex:positionSelectionControl.selectedSegmentIndex];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = 150;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"CFCRecruitCell" bundle:nil] forCellReuseIdentifier:@"CFCRecruitCell"];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(advanceRecruits)];

    // calculate recruiting points, but never show number - just show as usage as "% effort extended"
    recruitingPoints = ([HBSharedUtils currentLeague].isHardMode) ? (int)ceilf(20.0 * [HBSharedUtils currentLeague].userTeam.teamPrestige) : (int)ceilf(25.0 * [HBSharedUtils currentLeague].userTeam.teamPrestige);
    usedRecruitingPoints = 0;

    NSLog(@"Recruiting points total: %d", recruitingPoints);
    
    [self setSubtitle:@"0% of total recruiting effort used"];
    
    [self setTitle:[NSString stringWithFormat:@"Winter %lu", ((long)([[HBSharedUtils currentLeague] getCurrentYear] + 1))]];

    [self calculateTeamNeeds];
    recruitingStage = CFCRecruitingStageWinter;

    positionSelectionControl = [[ScrollableSegmentedControl alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    positionSelectionControl.segmentStyle = ScrollableSegmentedControlSegmentStyleTextOnly;
    positionSelectionControl.underlineSelected = YES;
    positionSelectionControl.selectedSegmentContentColor = [HBSharedUtils styleColor];
    positionSelectionControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FFFFFF" alpha:0.85];
    [positionSelectionControl insertSegmentWithTitle:@"ALL" at:0];
    [positionSelectionControl insertSegmentWithTitle:@"QB" at:1];
    [positionSelectionControl insertSegmentWithTitle:@"RB" at:2];
    [positionSelectionControl insertSegmentWithTitle:@"WR" at:3];
    [positionSelectionControl insertSegmentWithTitle:@"TE" at:4];
    [positionSelectionControl insertSegmentWithTitle:@"OL" at:5];
    [positionSelectionControl insertSegmentWithTitle:@"DL" at:6];
    [positionSelectionControl insertSegmentWithTitle:@"LB" at:7];
    [positionSelectionControl insertSegmentWithTitle:@"CB" at:8];
    [positionSelectionControl insertSegmentWithTitle:@"S" at:9];
    [positionSelectionControl insertSegmentWithTitle:@"K" at:10];
    [positionSelectionControl addTarget:self action:@selector(selectPosition:) forControlEvents:UIControlEventValueChanged];

    [self.navigationController.view addSubview:positionSelectionControl];
    


    // note bonus
    currentRecruits = [NSMutableArray array];
//    userRecruitingClass = [NSMutableArray array];
    recruitActivities = [NSMutableDictionary dictionary];
    progressedRecruits = [NSMutableArray array];
    signedRecruitRanks = [NSMutableDictionary dictionary];
    sortedByInterest = NO;

    totalRecruits = [NSMutableArray array];
    availQBs = [NSMutableArray array];
    availRBs = [NSMutableArray array];
    availWRs = [NSMutableArray array];
    availTEs = [NSMutableArray array];
    availOLs = [NSMutableArray array];
    availKs = [NSMutableArray array];
    availSs = [NSMutableArray array];
    availCBs = [NSMutableArray array];
    availDLs = [NSMutableArray array];
    availLBs = [NSMutableArray array];

    [self generateRecruits];

    //display tutorial alert on first launch
    BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_RECRUITING_TUTORIAL_SHOWN];
    if (!tutorialShown) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HB_RECRUITING_TUTORIAL_SHOWN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //display intro screen
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Welcome to Recruiting Season, Coach!" message:[HBSharedUtils recruitingTutorialText] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    UIBarButtonItem *needsButton = [[UIBarButtonItem alloc] initWithTitle:@"View Team Needs" style:UIBarButtonItemStylePlain target:self action:@selector(showRemainingNeeds)];
    
    [self setToolbarItems:@[[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"roster"] style:UIBarButtonItemStylePlain target:self action:@selector(viewRoster)],[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],needsButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]]];
    self.navigationController.toolbarHidden = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    if (@available(iOS 11, *)) {
        [self.tableView setContentInset:UIEdgeInsetsMake(positionSelectionControl.frame.size.height, 0, 0, 0)];
    } else {
        [self.tableView setContentInset:UIEdgeInsetsMake(positionSelectionControl.frame.size.height + self.navigationController.navigationBar.frame.size.height + 5, 0, positionSelectionControl.frame.size.height, 0)];
    }
}

-(void)generateRecruits {
    // generate recruits the same way as before
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud.label setText:@"Generating recruits..."];
    int position = 0;

    CGFloat inMin = 0.0;
    CGFloat inMax = 90;

    CGFloat outMin = 0;
    CGFloat outMax = 8;

    CGFloat input = MIN(90.0, (CGFloat) [HBSharedUtils currentLeague].userTeam.teamPrestige);
    int avail5Stars;
    if ([HBSharedUtils currentLeague].isHardMode) {
        avail5Stars = (int)((outMin + (outMax - outMin) * (input - inMin) / (inMax - inMin)));
    } else {
        avail5Stars = 8;
    }

    allPlayersAvailable = (avail5Stars == 8);

    for (int i = 0; i < avail5Stars; i++) {
        position = (int)([HBSharedUtils randomValue] * 10);
        if (position < 0) {
            position = 0;
        }

        if (position > 9) {
            position = 9;
        }

        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:5 team:nil]];
        }
    }

    outMin = 0;
    outMax = 40;

    int avail4Stars;
    if ([HBSharedUtils currentLeague].isHardMode) {
        avail4Stars = (int)((outMin + (outMax - outMin) * (input - inMin) / (inMax - inMin)));
    } else {
        avail4Stars = 40;
    }

    for (int i = 0; i < avail4Stars; i++) {
        position = (int)([HBSharedUtils randomValue] * 10) - 1;
        if (position < 0) {
            position = 0;
        }

        if (position > 9) {
            position = 9;
        }

        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:4 team:nil]];
        }
    }

    outMin = 0;
    outMax = 40;

    int avail3Stars;
    if ([HBSharedUtils currentLeague].isHardMode) {
        avail3Stars = (int)((outMin + (outMax - outMin) * (input - inMin) / (inMax - inMin)));
    } else {
        avail3Stars = 40;
    }

    for (int i = 0; i < avail3Stars; i++) {
        position = (int)([HBSharedUtils randomValue] * 10) - 1;
        if (position < 0) {
            position = 0;
        }

        if (position > 9) {
            position = 9;
        }

        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 1) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    for (int i = 0; i < 16; i++) {
        position = (int)([HBSharedUtils randomValue] * 10);
        if (position < 0) {
            position = 0;
        }

        if (position > 9) {
            position = 9;
        }

        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:2 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:2 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:2 team:nil]];
        }
    }

    for (int i = 0; i < 3; i++) {
        position = (int)([HBSharedUtils randomValue] * 10);
        if (position < 0) {
            position = 0;
        }

        if (position > 9) {
            position = 9;
        }

        if (position == 0) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 1 ) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 2) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 3) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 4) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 5) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 6) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 7) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else if (position == 8) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        } else {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:1 team:nil]];
        }
    }

    if (availQBs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availQBs addObject:[PlayerQB newQBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availRBs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availRBs addObject:[PlayerRB newRBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availWRs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availWRs addObject:[PlayerWR newWRWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availTEs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availTEs addObject:[PlayerTE newTEWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availOLs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availOLs addObject:[PlayerOL newOLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availDLs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availDLs addObject:[PlayerDL newDLWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availLBs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availLBs addObject:[PlayerLB newLBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availCBs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availCBs addObject:[PlayerCB newCBWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availSs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availSs addObject:[PlayerS newSWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    if (availKs.count == 0) {
        for (int i = 0; i < 3; i++) {
            [availKs addObject:[PlayerK newKWithName:[[HBSharedUtils currentLeague] getRandName] year:1 stars:3 team:nil]];
        }
    }

    [totalRecruits addObjectsFromArray:availQBs];
    [totalRecruits addObjectsFromArray:availRBs];
    [totalRecruits addObjectsFromArray:availWRs];
    [totalRecruits addObjectsFromArray:availTEs];
    [totalRecruits addObjectsFromArray:availOLs];
    [totalRecruits addObjectsFromArray:availDLs];
    [totalRecruits addObjectsFromArray:availLBs];
    [totalRecruits addObjectsFromArray:availCBs];
    [totalRecruits addObjectsFromArray:availSs];
    [totalRecruits addObjectsFromArray:availKs];
    [totalRecruits sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [HBSharedUtils compareStars:obj1 toObj2:obj2];
    }];

    [hud.label setText:@"Organizing offers from other teams..."];
    __block NSArray *teamList = [HBSharedUtils currentLeague].teamList;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableDictionary *teamNeeds = [NSMutableDictionary dictionary];
        for (Team *t in teamList) {
            t.recruitingClass = [NSMutableArray array];
            if (!t.isUserControlled) {
                // need to prevent some teams from just stockpiling recruits - that's bad
                // let's create a data structure that takes into account positional needs for each team.
                //[teamNeeds setObject:@(48 - [t getTeamSize]) forKey:t.abbreviation];
                [teamNeeds setObject:[NSMutableDictionary dictionaryWithDictionary:@{
                                                                                     @"QB" : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"QB" team:t])),
                                                                                     @"RB" : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"RB" team:t])),
                                                                                     @"WR" : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"WR" team:t])),
                                                                                     @"K"  : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"K" team:t])),
                                                                                     @"OL" : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"OL" team:t])),
                                                                                     @"S"  : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"S" team:t])),
                                                                                     @"CB" : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"CB" team:t])),
                                                                                     @"DL" : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"DL" team:t])),
                                                                                     @"LB" : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"LB" team:t])),
                                                                                     @"TE" : @(MAX(0, [self _calculateNeededPlayersAtPosition:@"TE" team:t]))
                                                                                     }] forKey:t.abbreviation];
            }
        }

        // generate offers from other teams
        for (Player *p in totalRecruits) {
            p.offers = [NSMutableDictionary dictionary];
            NSMutableDictionary *prelimOffers = [NSMutableDictionary dictionary];
            for (Team *t in teamList) {
                if (!t.isUserControlled) {
                    int interest = [p calculateInterestInTeam:t];
                    [prelimOffers setObject:@(interest) forKey:t.abbreviation];
                }
            }

            NSArray *sortedOffers = [prelimOffers keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj2 compare:obj1];
            }];

            NSMutableDictionary *highestOffers  = [NSMutableDictionary dictionary];
            int offers = 0;
            int i = 0;
            while (offers < 3 && i < sortedOffers.count) {
                NSString *abbrev = sortedOffers[i];
                NSMutableDictionary *teamPositionalNeeds = teamNeeds[abbrev];
                NSNumber *slotsAvailable = teamPositionalNeeds[p.position];
                if (slotsAvailable.intValue > 0) {
                    [highestOffers setObject:prelimOffers[abbrev] forKey:abbrev];
                    [teamPositionalNeeds setObject:[NSNumber numberWithInt:slotsAvailable.intValue - 1] forKey:p.position];
                    [teamNeeds setObject:teamPositionalNeeds forKey:abbrev];
                    offers++;
                }
                i++;
            }

            p.offers = highestOffers;
            if (highestOffers.count == 0) {
                NSLog(@"%@ %@ has no offers; may cause crash", p.position, p.name);
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            [positionSelectionControl setSelectedSegmentIndex:0];
            [self.tableView reloadData];
        });
    });
}

-(void)dismissVC {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you are done recruiting?" message:@"You will be sent to the start of next season, and any remaining openings on your team will be filled by walk-ons." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // finish the recruiting season
        [self finishRecruitingSeason];

    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];

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

    text = @"No signed recruits";
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

    text = @"You weren't able to sign any recruits this year. Better luck next year!";
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

#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (recruitingStage == CFCRecruitingStageFallCamp) {
        return [HBSharedUtils currentLeague].userTeam.recruitingClass.count;
    } else {
        return currentRecruits.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Player *p;
    if (recruitingStage == CFCRecruitingStageFallCamp) {
        @synchronized([HBSharedUtils currentLeague].userTeam.recruitingClass) {
            if (indexPath.row < [HBSharedUtils currentLeague].userTeam.recruitingClass.count) {
                p = [HBSharedUtils currentLeague].userTeam.recruitingClass[indexPath.row];
            }
        }
    } else {
        p = currentRecruits[indexPath.row];
    }
    
    CFCRecruitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFCRecruitCell"];
    if (p != nil) {
        [self configureCellForPlayer:p indexPath:indexPath cell:cell];
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

-(void)configureCellForPlayer:(Player *)p indexPath:(NSIndexPath *)indexPath cell:(CFCRecruitCell *)cell {
    int interest = 0;
    if ([p.offers.allKeys containsObject:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
        interest = [p.offers[[HBSharedUtils currentLeague].userTeam.abbreviation] intValue];
    } else {
        interest = [p calculateInterestInTeam:[HBSharedUtils currentLeague].userTeam];
        NSMutableArray *recruitEvents = ([recruitActivities.allKeys containsObject:[p uniqueIdentifier]]) ? recruitActivities[[p uniqueIdentifier]] : [NSMutableArray array];
        if ([recruitEvents containsObject:@(CFCRecruitEventPositionCoachMeeting)]) {
            interest += MEETING_INTEREST_BONUS;
        }
        if ([recruitEvents containsObject:@(CFCRecruitEventOfficialVisit)]) {
            interest += OFFICIAL_VISIT_INTEREST_BONUS;
        }
        if ([recruitEvents containsObject:@(CFCRecruitEventInHomeVisit)]) {
            interest += INHOME_VISIT_INTEREST_BONUS;
        }
    }
    
    int stars = p.stars;
    //// NSLog(@"%@'s OVR: %d stars: %d interest: %d offers: %@", p.name, p.ratOvr, stars, interest, p.offers);
    NSString *name = [p getInitialName];
    NSString *position = p.position;
    if ([p isKindOfClass:[PlayerQB class]]) {
        if (((PlayerQB *)p).ratSpeed >= 75) {
            position = @"DUAL";
        } else {
            position = @"PRO";
        }
    } else {
        position = p.position;
    }
    
    NSString *state = p.personalDetails[@"home_state"];
    NSString *height = p.personalDetails[@"height"];
    NSString *weight = p.personalDetails[@"weight"];
    NSString *overall;
    
    if (recruitingStage != CFCRecruitingStageFallCamp) {
        if (sortedByInterest) {
            if (positionSelectionControl.selectedSegmentIndex == 0) {
                overall = [NSString stringWithFormat:@"#%lu int.", (long)(indexPath.row + 1)];
            } else {
                overall = [NSString stringWithFormat:@"#%lu %@ int.", (long)(indexPath.row + 1), p.position];
            }
        } else {
            if (allPlayersAvailable) {
                if (positionSelectionControl.selectedSegmentIndex == 0) {
                    overall = [NSString stringWithFormat:@"#%lu overall", (long)(indexPath.row + 1)];
                } else {
                    overall = [NSString stringWithFormat:@"#%lu %@", (long)(indexPath.row + 1), p.position];
                }
            } else {
                if (positionSelectionControl.selectedSegmentIndex == 0) {
                    overall = [NSString stringWithFormat:@"#%lu avl", (long)(indexPath.row + 1)];
                } else {
                    overall = [NSString stringWithFormat:@"#%lu %@ avl", (long)(indexPath.row + 1), p.position];
                }
            }
        }
    } else {
        overall = signedRecruitRanks[[p uniqueIdentifier]];
    }
    
    NSDictionary *interestMetadata = [HBSharedUtils generateInterestMetadata:interest otherOffers:p.offers];
    
    
    // Valid cell data formatting code
    NSMutableAttributedString *interestString = [[NSMutableAttributedString alloc] initWithString:@"Interest: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [interestString appendAttributedString:[[NSAttributedString alloc] initWithString:interestMetadata[@"interest"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : interestMetadata[@"color"]}]];
    
    
    UIColor *nameColor = [UIColor blackColor];
    NSString *offerTitle = @"Other Offers: ";
    if (p.recruitStatus == CFCRecruitStatusCommitted && p.team == [HBSharedUtils currentLeague].userTeam) {
        nameColor = [HBSharedUtils styleColor];
        offerTitle = @"Committed: ";
    } else if (p.recruitStatus == CFCRecruitStatusCommitted && p.team != [HBSharedUtils currentLeague].userTeam) {
        nameColor = [HBSharedUtils errorColor];
        offerTitle = @"Committed: ";
    } else if ([recruitActivities.allKeys containsObject:[p uniqueIdentifier]]) {
        offerTitle = @"Other Offers: ";
        NSArray *events = recruitActivities[[p uniqueIdentifier]];
        if ([events containsObject:@(CFCRecruitEventExtendOffer)]) {
            nameColor = [HBSharedUtils offeredColor];
        } else {
            nameColor = [HBSharedUtils progressColor];
        }
    } else {
        nameColor = [UIColor blackColor];
        offerTitle = @"Other Offers: ";
    }
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", position] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    
    [nameString appendAttributedString:[[NSAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium], NSForegroundColorAttributeName : nameColor}]];
    
    NSMutableAttributedString *heightString = [[NSMutableAttributedString alloc] initWithString:@"Height: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [heightString appendAttributedString:[[NSAttributedString alloc] initWithString:height attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *weightString = [[NSMutableAttributedString alloc] initWithString:@"Weight: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [weightString appendAttributedString:[[NSAttributedString alloc] initWithString:weight attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    
    NSMutableAttributedString *offerString = [[NSMutableAttributedString alloc] initWithString:offerTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    if (p.recruitStatus == CFCRecruitStatusCommitted) {
        if (p.team == [HBSharedUtils currentLeague].userTeam) {
            [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:[HBSharedUtils currentLeague].userTeam.abbreviation attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium], NSForegroundColorAttributeName : [HBSharedUtils styleColor]}]];
        } else if ([recruitActivities.allKeys containsObject:[p uniqueIdentifier]]) {
            [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:p.team.abbreviation attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium], NSForegroundColorAttributeName : [HBSharedUtils errorColor]}]];
        } else {
            [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:p.team.abbreviation attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
        }
    } else {
        [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:[HBSharedUtils generateOfferString:p.offers] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    }
    
    [cell.interestLabel setAttributedText:interestString];
    [cell.starImageView setImage:[UIImage imageNamed:[HBSharedUtils convertStarsToUIImageName:stars]]];
    [cell.nameLabel setAttributedText:nameString];
    [cell.stateLabel setText:state];
    [cell.heightLabel setAttributedText:heightString];
    [cell.weightLabel setAttributedText:weightString];
    
    NSMutableAttributedString *potAtt = [[NSMutableAttributedString alloc] initWithString:@"Potential: " attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:16.0]}];
    NSString *stat1 = [p getLetterGrade:p.ratPot];
    UIColor *letterColor = [UIColor lightGrayColor];
    if ([stat1 containsString:@"A"]) {
        letterColor = [HBSharedUtils successColor];
    } else if ([stat1 containsString:@"B"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
    } else if ([stat1 containsString:@"C"]) {
        letterColor = [HBSharedUtils champColor];
    } else if ([stat1 containsString:@"D"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
    } else if ([stat1 containsString:@"F"]) {
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
    } else {
        letterColor = [UIColor lightGrayColor];
    }
    
    [potAtt appendAttributedString:[[NSAttributedString alloc] initWithString:stat1 attributes:@{NSForegroundColorAttributeName : letterColor, NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]}]];
    [cell.fortyYdDashLabel setAttributedText:potAtt];
    
    [cell.rankLabel setText:overall];
    [cell.otherOffersLabel setAttributedText:offerString];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // navigate to page where you can view recruit details and have options to recruit him:
    //          1. extend offer - sends LOI to recruit; can only give out maxTeamSize - currentTeamSize of these
    //          2. extend official visit/OV - spend small amount of recruiting points (smaller amount than in-home) to court player on campus; increases interest by 10pts.
    //          3. visit recruit at home - spend large amount of recruiting points to court player at home; increases interest by 20pts.
    //          4. also provide option to cancel each of these -- basically we are building a recruiting process for each recruit that we think will be best to sign him
    // if committed to user team, show options:
    //          1. redshirt player
    // if committed, but NOT to user team, show options:
    //          1. if interest in that team was mild or medium, then:
    //              * offer and flip (for large amount of recruiting points) -- increases interest in user team by 20 pts.
    // also display recruiting process for this recruit: OV -> offer -> commit or offer -> commit or OV -> home visit -> offer -> commit
    Player *p;
    if (recruitingStage == CFCRecruitingStageFallCamp) {
        @synchronized([HBSharedUtils currentLeague].userTeam.recruitingClass) {
            if (indexPath.row < [HBSharedUtils currentLeague].userTeam.recruitingClass.count) {
                p = [HBSharedUtils currentLeague].userTeam.recruitingClass[indexPath.row];
            }
        }
    } else {
        p = currentRecruits[indexPath.row];
    }
    if (p != nil) {
        NSMutableArray *recruitEvents = ([recruitActivities.allKeys containsObject:[p uniqueIdentifier]]) ? recruitActivities[[p uniqueIdentifier]] : [NSMutableArray array];
        RecruitingActionsViewController *actionsVC = [[RecruitingActionsViewController alloc] initWithRecruit:p events:recruitEvents];
        actionsVC.delegate = self;
        popupController = [[STPopupController alloc] initWithRootViewController:actionsVC];
        [popupController.navigationBar setDraggable:YES];
        [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
        popupController.style = STPopupStyleBottomSheet;
        [popupController presentInViewController:self];
    }
}

- (void)recruitingActionsController:(RecruitingActionsViewController *)actionsController didUpdateRecruit:(Player *)recruit withEvent:(CFCRecruitEvent)event {
    NSMutableArray *recruitEvents = ([recruitActivities.allKeys containsObject:[recruit uniqueIdentifier]]) ? recruitActivities[[recruit uniqueIdentifier]] : [NSMutableArray array];
    
    
    switch (event) {
        case CFCRecruitEventFlipped: {
            [recruitEvents addObject:@(CFCRecruitEventFlipped)];
            [recruitActivities setObject:recruitEvents forKey:[recruit uniqueIdentifier]];

            // flipping depends on difference between first choice and user team.
            CGFloat inMin = 0.0;
            CGFloat inMax = 100.0;
            
            CGFloat outMin = 50.0;
            CGFloat outMax = 0.0;
            
            NSArray *sortedOffers = [recruit.offers keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj2 compare:obj1];
            }];
            
            // NSLog(@"RETREIVING TOP OFFER FROM: %@", sortedOffers);
            NSString *highestOffer = sortedOffers[0];
            NSNumber *highestInterest = recruit.offers[highestOffer];
            
            CGFloat input = MAX(0.0, highestInterest.floatValue - (float)[self _calculateTotalInterestLevel:recruit]);
            
            CGFloat flipChance = ((outMin + (outMax - outMin) * (input - inMin) / (inMax - inMin)));
            //NSLog(@"Flip Chance: %f for INPUT: %f", flipChance, input);

            if ([HBSharedUtils randomValue] < (flipChance / 100.0)) {
                // flip successful, move the recruit over to our team
                Team *prevTeam = recruit.team;
                [recruit.team.recruitingClass removeObject:recruit];
                recruit.team = [HBSharedUtils currentLeague].userTeam;
                [[HBSharedUtils currentLeague].userTeam.recruitingClass addObject:recruit];

                if (![progressedRecruits containsObject:recruit]) {
                    [progressedRecruits addObject:recruit];
                    if (progressedRecruits.count == 1) {
                        NSInteger selectedIdx = positionSelectionControl.selectedSegmentIndex;
                        [positionSelectionControl insertSegmentWithTitle:@"WTCH" at:1];
                        [positionSelectionControl setSelectedSegmentIndex:selectedIdx + 1];
                    }
                }

                [signedRecruitRanks setObject:[NSString stringWithFormat:@"#%lu %@ (#%lu ovr)", (long)([self _indexForPosition:recruit] + 1), recruit.position, (long)([totalRecruits indexOfObject:recruit] + 1)] forKey:[recruit uniqueIdentifier]];
                //[HBSharedUtils showNotificationWithTintColor:[HBSharedUtils successColor] title:@"Flip successful!" message:[NSString stringWithFormat:@"%@ %@ signed with your team over %@ on signing day!", recruit.position, recruit.name, prevTeam.abbreviation] onViewController:popupController.topViewController];
                
                [RMessage showNotificationInViewController:popupController.topViewController.navigationController
                                                     title:@"Flip successful!"
                                                  subtitle:[NSString stringWithFormat:@"%@ %@ signed with your team over %@ on signing day!", recruit.position, recruit.name, prevTeam.abbreviation]
                                                 iconImage:nil
                                                      type:RMessageTypeCustom
                                            customTypeName:@"alternate-success"
                                                  duration:0.75
                                                  callback:nil
                                               buttonTitle:nil
                                            buttonCallback:nil
                                                atPosition:RMessagePositionNavBarOverlay
                                      canBeDismissedByUser:YES];

            } else {
                // flip unsuccessful
                //[HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] title:@"Flip failed!" message:[NSString stringWithFormat:@"%@ %@ chose to stay with %@.",recruit.position, recruit.name, recruit.team.abbreviation] onViewController:popupController.topViewController];
                [RMessage showNotificationInViewController:popupController.topViewController.navigationController
                                                     title:@"Flip failed!"
                                                  subtitle:[NSString stringWithFormat:@"%@ %@ chose to stay with %@.",recruit.position, recruit.name, recruit.team.abbreviation]
                                                 iconImage:nil
                                                      type:RMessageTypeCustom
                                            customTypeName:@"alternate-error"
                                                  duration:0.75
                                                  callback:nil
                                               buttonTitle:nil
                                            buttonCallback:nil
                                                atPosition:RMessagePositionNavBarOverlay
                                      canBeDismissedByUser:YES];

            }

            usedRecruitingPoints += FLIP_COST;
            //[navigationTitleView setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];
            [self setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];

            [self.tableView reloadData];
            break;
        }
        case CFCRecruitEventRedshirted:
            recruit.hasRedshirt = YES;
            break;
        case CFCRecruitEventUnredshirted:
            recruit.hasRedshirt = NO;
            break;
        case CFCRecruitEventPositionCoachMeeting:
            [recruitEvents addObject:@(CFCRecruitEventPositionCoachMeeting)];
            [recruitActivities setObject:recruitEvents forKey:[recruit uniqueIdentifier]];
            usedRecruitingPoints += MEETING_COST;

            if ([recruit.offers.allKeys containsObject:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
                NSNumber *offer = recruit.offers[[HBSharedUtils currentLeague].userTeam.abbreviation];
                int interest = [offer intValue];
                interest += MEETING_INTEREST_BONUS;
                [recruit.offers setObject:@(interest) forKey:[HBSharedUtils currentLeague].userTeam.abbreviation];
            }

            if (![progressedRecruits containsObject:recruit]) {
                [progressedRecruits addObject:recruit];
                if (progressedRecruits.count == 1) {
                    NSInteger selectedIdx = positionSelectionControl.selectedSegmentIndex;
                    [positionSelectionControl insertSegmentWithTitle:@"WTCH" at:1];
                    [positionSelectionControl setSelectedSegmentIndex:selectedIdx + 1];
                }
            }

            //[navigationTitleView setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];
            [self setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];

            [self.tableView reloadData];
            break;
        case CFCRecruitEventOfficialVisit:
            [recruitEvents addObject:@(CFCRecruitEventOfficialVisit)];
            [recruitActivities setObject:recruitEvents forKey:[recruit uniqueIdentifier]];
            usedRecruitingPoints += OFFICIAL_VISIT_COST;

            if ([recruit.offers.allKeys containsObject:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
                NSNumber *offer = recruit.offers[[HBSharedUtils currentLeague].userTeam.abbreviation];
                int interest = [offer intValue];
                interest += OFFICIAL_VISIT_INTEREST_BONUS;
                [recruit.offers setObject:@(interest) forKey:[HBSharedUtils currentLeague].userTeam.abbreviation];
            }

            if (![progressedRecruits containsObject:recruit]) {
                [progressedRecruits addObject:recruit];
                if (progressedRecruits.count == 1) {
                    NSInteger selectedIdx = positionSelectionControl.selectedSegmentIndex;
                    [positionSelectionControl insertSegmentWithTitle:@"WTCH" at:1];
                    [positionSelectionControl setSelectedSegmentIndex:selectedIdx + 1];
                }
            }

            //[navigationTitleView setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];
            [self setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];
            [self.tableView reloadData];
            break;
        case CFCRecruitEventInHomeVisit:
            [recruitEvents addObject:@(CFCRecruitEventInHomeVisit)];
            [recruitActivities setObject:recruitEvents forKey:[recruit uniqueIdentifier]];
            usedRecruitingPoints += INHOME_VISIT_COST;

            if ([recruit.offers.allKeys containsObject:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
                NSNumber *offer = recruit.offers[[HBSharedUtils currentLeague].userTeam.abbreviation];
                int interest = [offer intValue];
                interest += INHOME_VISIT_INTEREST_BONUS;
                [recruit.offers setObject:@(interest) forKey:[HBSharedUtils currentLeague].userTeam.abbreviation];
            }

            if (![progressedRecruits containsObject:recruit]) {
                [progressedRecruits addObject:recruit];
                if (progressedRecruits.count == 1) {
                    NSInteger selectedIdx = positionSelectionControl.selectedSegmentIndex;
                    [positionSelectionControl insertSegmentWithTitle:@"WTCH" at:1];
                    [positionSelectionControl setSelectedSegmentIndex:selectedIdx + 1];
                }
            }

            //[navigationTitleView setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];
            [self setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];

            [self.tableView reloadData];
            break;
        case CFCRecruitEventExtendOffer:
            [recruitEvents addObject:@(CFCRecruitEventExtendOffer)];
            [recruitActivities setObject:recruitEvents forKey:[recruit uniqueIdentifier]];
            int interest = [recruit calculateInterestInTeam:[HBSharedUtils currentLeague].userTeam];

            if (![recruit.offers.allKeys containsObject:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
                if ([recruitEvents containsObject:@(CFCRecruitEventPositionCoachMeeting)]) {
                    interest += MEETING_INTEREST_BONUS;
                }
                if ([recruitEvents containsObject:@(CFCRecruitEventOfficialVisit)]) {
                    interest += OFFICIAL_VISIT_INTEREST_BONUS;
                }
                if ([recruitEvents containsObject:@(CFCRecruitEventInHomeVisit)]) {
                    interest += INHOME_VISIT_INTEREST_BONUS;
                }
                [recruit.offers setObject:@(interest) forKey:[HBSharedUtils currentLeague].userTeam.abbreviation];
            }

            if (![progressedRecruits containsObject:recruit]) {
                [progressedRecruits addObject:recruit];
                if (progressedRecruits.count == 1) {
                    NSInteger selectedIdx = positionSelectionControl.selectedSegmentIndex;
                    [positionSelectionControl insertSegmentWithTitle:@"WTCH" at:1];
                    [positionSelectionControl setSelectedSegmentIndex:selectedIdx + 1];
                }
            }

            usedRecruitingPoints += EXTEND_OFFER_COST;
            //[navigationTitleView setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];
            [self setSubtitle:[NSString stringWithFormat:@"%.0f%% of total recruiting effort used",((float) usedRecruitingPoints / (float) recruitingPoints) * 100.0]];

            [self.tableView reloadData];
            break;
        default:
            break;
    }
}



@end
