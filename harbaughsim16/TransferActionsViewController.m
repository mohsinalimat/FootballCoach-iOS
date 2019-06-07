//
//  TransferActionsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/22/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "TransferActionsViewController.h"

#import "Player.h"
#import "PlayerQB.h"

#import "CFCRecruitCell.h"

#import "STPopup.h"
#import "ZMJTipView.h"

@interface TransferActionsViewController () <ZMJTipViewDelegate>
{
    Player *selectedRecruit;
    NSMutableArray *recruitEvents;
    NSMutableArray *availableEvents;
    NSMutableArray *offers;
}
@end

@implementation TransferActionsViewController

- (void)tipViewDidDimiss:(ZMJTipView *)tipView {
    
}

- (void)tipViewDidSelected:(ZMJTipView *)tipView {
    
}

-(instancetype)initWithPotentialTransfer:(Player *)p events:(NSArray *)events {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        selectedRecruit = p;
        recruitEvents = [NSMutableArray arrayWithArray:events];
        
        
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.85);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    availableEvents = [NSMutableArray arrayWithArray:@[@(CFCRecruitEventPositionCoachMeeting),@(CFCRecruitEventOfficialVisit),@(CFCRecruitEventInHomeVisit),@(CFCRecruitEventExtendOffer)]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CFCRecruitCell" bundle:nil] forCellReuseIdentifier:@"CFCRecruitCell"];
    [self reloadOffers];
    
    [self.tableView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    self.title = @"Transfer Profile";
    
    //display tutorial alert on first launch
    BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:HB_TRANSFER_TUTORIAL_SHOWN_KEY];
    if (!tutorialShown) {
        [self showTutorial];
    }
}

-(void)showTutorial {
    //display intro screen
    if (selectedRecruit.recruitStatus != CFCRecruitStatusCommitted || selectedRecruit.team != [HBSharedUtils currentLeague].userTeam) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *tipText = @"Tap on any of the actions below to use some recruiting effort to woo this player to your program. Keep in mind: each option costs a different amount of effort.";
            if ([HBSharedUtils currentLeague].isCareerMode && [HBSharedUtils currentLeague].isHardMode) {
                tipText = @"Tap on any of the actions below to use some recruiting effort to woo this player to your program. Keep in mind: each option costs a different amount of effort, and the amount of effort you need to expend will increase as your coach gets older.";
            }
            ZMJTipView *editTip = [[ZMJTipView alloc] initWithText:tipText preferences:nil delegate:self];
            [editTip showAnimated:YES forView:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] withinSuperview:self.tableView];
        });
    }
}

-(void)reloadOffers {
    offers = [NSMutableArray array];
    NSArray *offerAbbrev = [selectedRecruit.offers keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj2 compare:obj1];
    }];
    
    for (NSString *abbrev in offerAbbrev) {
        Team *t = [[HBSharedUtils currentLeague] findTeam:abbrev];
        if (!t.isUserControlled && ![offers containsObject:t]) {
            [offers addObject:t];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSNumber *)_retreiveEventCost:(CFCRecruitEvent)event {
    static dispatch_once_t onceToken;
    static NSDictionary *costs;
    dispatch_once(&onceToken, ^{
        costs = @{
                  @(CFCRecruitEventPositionCoachMeeting) : @(MEETING_INTEREST_BONUS),
                  @(CFCRecruitEventOfficialVisit): @(OFFICIAL_VISIT_INTEREST_BONUS),
                  @(CFCRecruitEventInHomeVisit) : @(INHOME_VISIT_INTEREST_BONUS),
                  @(CFCRecruitEventExtendOffer) : @(EXTEND_OFFER_COST),
                  @(CFCRecruitEventFlipped) : @(FLIP_COST)
                  };
    });
    
    return costs[@(event)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted && selectedRecruit.team == [HBSharedUtils currentLeague].userTeam) {
        return 2; // these are transfer class entries so no options to display
    } else if (selectedRecruit.recruitStatus != CFCRecruitStatusCommitted && [selectedRecruit.team isEqual:[HBSharedUtils currentLeague].userTeam]) {
        return 2; // player is transferring out of program
    }
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted) {
            return [NSString stringWithFormat:@"Committed to %@.", selectedRecruit.team.name];
        } else {
            if (selectedRecruit.offers.count == 0) {
                return @"No active offers.";
            } else if ([selectedRecruit.team isEqual:[HBSharedUtils currentLeague].userTeam]) {
                return @"This player is tranferring out of your program.";
            }
        }
    } else if (section == 0) {
        if (selectedRecruit.isGradTransfer) {
            return [NSString stringWithFormat:@"As a graduate transfer, %@ is eligible to play immediately.", [selectedRecruit getInitialName]];
        } else {
            return [NSString stringWithFormat:@"As a normal transfer, %@ will have to sit one year before he is eligible to play.", [selectedRecruit getInitialName]];
        }
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted) {
            return 0;
        } else {
            return offers.count;
        }
    } else {
        NSInteger count = 1;
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted) {// && selectedRecruit.team != [HBSharedUtils currentLeague].userTeam) {
            if (selectedRecruit.team != [HBSharedUtils currentLeague].userTeam) {
                return 1;
            } else {
                return 0;
            }
        } else {
            if (![selectedRecruit.team isEqual:[HBSharedUtils currentLeague].userTeam]) {
                count = availableEvents.count;
            } else {
                return 0;
            }
        }
        
        return count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 175;
    } else if (indexPath.section == 2) {
        return 120;
    } else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 175;
    } else if (indexPath.section == 2) {
        return 120;
    } else {
        return 50;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 36;
    } else if (section == 0) {
        return 54;
    }
    return 18;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 55.5;
    }
    return 38;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"INFORMATION";
    } else if (section == 1) {
        return @"OFFER LIST";
    } else {
        return @"ACTIONS";
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Drawing cell for section %lu index %lu", indexPath.section, indexPath.row);
    if (indexPath.section == 0) {
        int interest = 0;
        if ([selectedRecruit.offers.allKeys containsObject:[HBSharedUtils currentLeague].userTeam.abbreviation]) {
            interest = [selectedRecruit.offers[[HBSharedUtils currentLeague].userTeam.abbreviation] intValue];
        } else {
            interest = [selectedRecruit calculateInterestInTeam:[HBSharedUtils currentLeague].userTeam];
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
        
        int stars = selectedRecruit.stars;
        //// NSLog(@"%@'s OVR: %d stars: %d interest: %d offers: %@", selectedRecruit.name, selectedRecruit.ratOvr, stars, interest, selectedRecruit.offers);
        NSString *name = selectedRecruit.name;
        NSString *position = selectedRecruit.position;
        if ([selectedRecruit isKindOfClass:[PlayerQB class]]) {
            if (((PlayerQB *)selectedRecruit).ratSpeed >= 75) {
                position = @"DUAL";
            } else {
                position = @"PRO";
            }
        } else {
            position = selectedRecruit.position;
        }
        
        NSString *state = selectedRecruit.personalDetails[@"home_state"];
        NSString *overall;
        
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted && selectedRecruit.team == [HBSharedUtils currentLeague].userTeam) {
            overall =  ((id<TransferActionsDelegate>)_delegate).signedTransferRanks[[selectedRecruit uniqueIdentifier]];
        }
        
        NSDictionary *interestMetadata = [HBSharedUtils generateInterestMetadata:interest otherOffers:selectedRecruit.offers];
        
        
        // Valid cell data formatting code
        NSMutableAttributedString *interestString = [[NSMutableAttributedString alloc] initWithString:@"Interest: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
        [interestString appendAttributedString:[[NSAttributedString alloc] initWithString:interestMetadata[@"interest"] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : interestMetadata[@"color"]}]];
        
        
        UIColor *nameColor = [UIColor blackColor];
        NSString *offerTitle = @"Other Offers: ";
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted && selectedRecruit.team == [HBSharedUtils currentLeague].userTeam) {
            nameColor = [HBSharedUtils styleColor];
            offerTitle = @"Committed: ";
        } else if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted && selectedRecruit.team != [HBSharedUtils currentLeague].userTeam) {
            nameColor = [HBSharedUtils errorColor];
            offerTitle = @"Committed: ";
        } else if ([((id<TransferActionsDelegate>)_delegate).progressedTransfers containsObject:selectedRecruit]) {
            offerTitle = @"Other Offers: ";
            if ([recruitEvents containsObject:@(CFCRecruitEventExtendOffer)]) {
                nameColor = [HBSharedUtils offeredColor];
            } else {
                nameColor = [HBSharedUtils progressColor];
            }
        } else {
            nameColor = [UIColor blackColor];
            offerTitle = @"Other Offers: ";
        }
        
        NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", position] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        
        [nameString appendAttributedString:[[NSAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE weight:UIFontWeightMedium], NSForegroundColorAttributeName : nameColor}]];
        
        UIColor *stat2Color = [UIColor lightGrayColor];
        NSString *stat2 = [NSString stringWithFormat:@"%d",selectedRecruit.ratOvr];
        if ([stat2 containsString:@"9"]) {
            stat2Color = [HBSharedUtils successColor];
        } else if ([stat2 containsString:@"8"]) {
            stat2Color = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
        } else if ([stat2 containsString:@"7"]) {
            stat2Color = [HBSharedUtils champColor];
        } else if ([stat2 containsString:@"6"]) {
            stat2Color = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
        } else if ([stat2 containsString:@"5"]) {
            stat2Color = [UIColor hx_colorWithHexRGBAString:@"#d7191c"];
        } else {
            stat2Color = [UIColor lightGrayColor];
        }
        
        NSMutableAttributedString *overallString = [[NSMutableAttributedString alloc] initWithString:@"Overall: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
        [overallString appendAttributedString:[[NSAttributedString alloc] initWithString:stat2 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : stat2Color}]];
        
        NSString *type = selectedRecruit.isGradTransfer ? @"Grad" : @"Normal";
        NSMutableAttributedString *typeString = [[NSMutableAttributedString alloc] initWithString:@"Type: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
        [typeString appendAttributedString:[[NSAttributedString alloc] initWithString:type attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
        
        NSMutableAttributedString *offerString = [[NSMutableAttributedString alloc] initWithString:offerTitle attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted) {
            if (selectedRecruit.team == [HBSharedUtils currentLeague].userTeam) {
                [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:[HBSharedUtils currentLeague].userTeam.abbreviation attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE weight:UIFontWeightMedium], NSForegroundColorAttributeName : [HBSharedUtils styleColor]}]];
            } else if ([((id<TransferActionsDelegate>)_delegate).transferActivities.allKeys containsObject:[selectedRecruit uniqueIdentifier]]) {
                [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:selectedRecruit.team.abbreviation attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE weight:UIFontWeightMedium], NSForegroundColorAttributeName : [HBSharedUtils errorColor]}]];
            } else {
                [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:selectedRecruit.team.abbreviation attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE weight:UIFontWeightMedium], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
            }
        } else {
            [offerString appendAttributedString:[[NSAttributedString alloc] initWithString:[HBSharedUtils generateOfferString:selectedRecruit.offers] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
        }
        
        NSMutableAttributedString *specString = [[NSMutableAttributedString alloc] initWithString:@"Archetype: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
        [specString appendAttributedString:[[NSAttributedString alloc] initWithString:[selectedRecruit getPlayerArchetype] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
        
        
        CFCRecruitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFCRecruitCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.interestLabel setAttributedText:interestString];
        [cell.starImageView setImage:[UIImage imageNamed:[HBSharedUtils convertStarsToUIImageName:stars]]];
        [cell.nameLabel setAttributedText:nameString];
        [cell.stateLabel setText:state];
        [cell.heightLabel setAttributedText:overallString];
        [cell.weightLabel setAttributedText:typeString];
        [cell.specialtyLabel setAttributedText:specString];
        
        NSMutableAttributedString *potAtt = [[NSMutableAttributedString alloc] initWithString:@"Potential: " attributes:@{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE]}];
        NSString *stat1 = [selectedRecruit getLetterGrade:selectedRecruit.ratPot];
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
        
        [potAtt appendAttributedString:[[NSAttributedString alloc] initWithString:stat1 attributes:@{NSForegroundColorAttributeName : letterColor, NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE weight:UIFontWeightMedium]}]];
        [cell.fortyYdDashLabel setAttributedText:potAtt];
        
        [cell.rankLabel setText:overall];
        [cell.otherOffersLabel setAttributedText:offerString];
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
            [cell.detailTextLabel setNumberOfLines:0];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:MEDIUM_FONT_SIZE]];
            [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
            [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
        }
        
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted) {
            if (selectedRecruit.team != [HBSharedUtils currentLeague].userTeam) {
                // flip
                [cell.textLabel setText:[NSString stringWithFormat:@"Flip to %@",[HBSharedUtils currentLeague].userTeam.name]];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"Try to convince this player to sign with your school instead of %@. This will use a lot of recruiting effort.",selectedRecruit.team.name]];
                if (((id<TransferActionsDelegate>)_delegate).recruitingPoints - (((id<TransferActionsDelegate>)_delegate).usedRecruitingPoints + [self _retreiveEventCost:CFCRecruitEventFlipped].intValue) <= 0) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                } else if (![recruitEvents containsObject:@(CFCRecruitEventFlipped)]) {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [cell.textLabel setTextColor:[UIColor blackColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                } else {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            } // no option to redshirt a transfer
        } else {
            NSNumber *event = availableEvents[indexPath.row];
            if ([event isEqual:@(CFCRecruitEventPositionCoachMeeting)]) {
                [cell.textLabel setText:[NSString stringWithFormat:@"Invite for meeting with %@ Coach", selectedRecruit.position]];
                [cell.detailTextLabel setText:@"Invite this player to a meeting with his potential positional coach. Requires a nominal amount of recruiting effort."];
            } else if ([event isEqual:@(CFCRecruitEventOfficialVisit)]) {
                [cell.textLabel setText:@"Invite for official visit"];
                [cell.detailTextLabel setText:@"Invite this player to visit campus for a day and meet the staff and current players. Requires a medium amount of recruiting effort."];
            } else if ([event isEqual:@(CFCRecruitEventInHomeVisit)]) {
                [cell.textLabel setText:@"Visit in person"];
                [cell.detailTextLabel setText:[NSString stringWithFormat:@"Travel to %@ and convince this player and his family to sign with your school. Requires a considerable amount of recruiting effort.",selectedRecruit.personalDetails[@"home_state"]]];
            } else if ([event isEqual:@(CFCRecruitEventExtendOffer)]) {
                [cell.textLabel setText:@"Extend official offer"];
                [cell.detailTextLabel setText:@"Extend this player an official offer to sign with your school. Requires a significant amount of recruiting effort."];
            } else {
                [cell.textLabel setText:@"Unknown"];
                [cell.detailTextLabel setText:@"Unknown"];
            }
            
            if (((id<TransferActionsDelegate>)_delegate).recruitingPoints - (((id<TransferActionsDelegate>)_delegate).usedRecruitingPoints + [self _retreiveEventCost:(CFCRecruitEvent)event.integerValue].intValue) <= 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (![recruitEvents containsObject:event]) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.textLabel setTextColor:[UIColor blackColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
            } else {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"OfferCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.textLabel setFont:[UIFont systemFontOfSize:LARGE_FONT_SIZE]];
            [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        }
        
        Team *t = offers[indexPath.row];
        [cell.textLabel setText:t.name];
        
        // Valid cell data formatting code
        NSMutableAttributedString *interestString = [[NSMutableAttributedString alloc] initWithString:@"Interest: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : [UIColor blackColor]}];
        
        UIColor *offerColor;
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted) {
            if (selectedRecruit.team == [HBSharedUtils currentLeague].userTeam) {
                offerColor = [HBSharedUtils styleColor];
            } else if ([((id<TransferActionsDelegate>)_delegate).transferActivities.allKeys containsObject:[selectedRecruit uniqueIdentifier]]) {
                offerColor = [HBSharedUtils errorColor];
            } else {
                offerColor = [UIColor lightGrayColor];
            }
        } else {
            offerColor = [HBSharedUtils _calculateInterestColor:selectedRecruit.offers[t.abbreviation].intValue];
        }
        
        [interestString appendAttributedString:[[NSAttributedString alloc] initWithString:[HBSharedUtils _calculateInterestString:selectedRecruit.offers[t.abbreviation].intValue] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:LARGE_FONT_SIZE], NSForegroundColorAttributeName : offerColor}]];
        [cell.detailTextLabel setAttributedText:interestString];
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {
        if (selectedRecruit.recruitStatus == CFCRecruitStatusCommitted) {
            if (selectedRecruit.team != [HBSharedUtils currentLeague].userTeam) {
                // flip
                if ([recruitEvents containsObject:@(CFCRecruitEventFlipped)] || ((id<TransferActionsDelegate>)_delegate).recruitingPoints - (((id<TransferActionsDelegate>)_delegate).usedRecruitingPoints + [self _retreiveEventCost:CFCRecruitEventFlipped].intValue) <= 0) {
                    NSLog(@"[Transfers] NOT LEGAL");
                } else {
                    [recruitEvents addObject:@(CFCRecruitEventFlipped)];
                    if (_delegate && [_delegate respondsToSelector:@selector(transferActionsController:didUpdateTransfer:withEvent:)]) {
                        [(id<TransferActionsDelegate>)_delegate transferActionsController:self didUpdateTransfer:selectedRecruit withEvent:CFCRecruitEventFlipped];
                    }
                }
            } // no option to redshirt a transfer
        } else {
            NSNumber *event = availableEvents[indexPath.row];
            if (((id<TransferActionsDelegate>)_delegate).recruitingPoints - (((id<TransferActionsDelegate>)_delegate).usedRecruitingPoints + [self _retreiveEventCost:(CFCRecruitEvent)event.integerValue].intValue) <= 0 || [recruitEvents containsObject:event]) {
                NSLog(@"[Transfers] NOT LEGAL");
            } else {
                [recruitEvents addObject:event];
                if (_delegate && [_delegate respondsToSelector:@selector(transferActionsController:didUpdateTransfer:withEvent:)]) {
                    [(id<TransferActionsDelegate>)_delegate transferActionsController:self didUpdateTransfer:selectedRecruit withEvent:(CFCRecruitEvent)event.integerValue];
                }
            }
            [self reloadOffers];
        }
        
        [self.tableView reloadData];
    }
}


@end
