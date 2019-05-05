//
//  SettingsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "SettingsViewController.h"
#import "HBSettingsCell.h"
#import "MyTeamViewController.h"
#import "Team.h"
#import "RebrandConferenceSelectorViewController.h"
#import "HelpViewController.h"
#import "CareerLeaderboardViewController.h"

#import "HexColors.h"
#import "FCFileManager.h"
#import "STPopup.h"
#import <StoreKit/StoreKit.h>
#import "MBProgressHUD.h"
#import "RSEmailFeedback.h"
@import MessageUI;
@import SafariServices;

@interface SettingsViewController () //<MFMailComposeViewControllerDelegate>
{
    STPopupController *popupController;
    NSString *currentYear;
}
@end

@implementation SettingsViewController

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

-(void)changeCoachName {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rename Coach" message:@"Enter your coach's new name below." preferredStyle:UIAlertControllerStyleAlert];
    NSArray *nameParts = [[[HBSharedUtils currentLeague].userTeam getCurrentHC].name componentsSeparatedByString:@" "];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Coach First Name";
        textField.text = nameParts[0];
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Coach Last Name";
        textField.text = nameParts[1];
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HBSharedUtils currentLeague].userTeam getCurrentHC].name = [NSString stringWithFormat:@"%@ %@", alert.textFields[0].text, alert.textFields[1].text];
        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils styleColor] title:@"Rename successful!" message:[NSString stringWithFormat:@"Coach renamed to %@",[[HBSharedUtils currentLeague].userTeam getCurrentHC].name] onViewController:self];
        [[HBSharedUtils currentLeague] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedCoachName" object:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openLeaderboard {
    CareerLeaderboardViewController *helpVC = [[CareerLeaderboardViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:helpVC] animated:YES completion:nil];
}

-(void)changeTeamName {
    if ([HBSharedUtils currentLeague].canRebrandTeam) {
        __block Team *userTeam = [HBSharedUtils currentLeague].userTeam;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rebrand Team" message:@"Enter your new team name and abbreviation below." preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Team Name";
            textField.text = userTeam.name;
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Abbreviation";
            textField.text = userTeam.abbreviation;
            textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"State";
            textField.text = userTeam.state;
            textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        }];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to rebrand your team?" message:@"You can rebrand again at any time during the offseason." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self applyTeamInfoChanges:alert.textFields userTeam:userTeam];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)applyTeamInfoChanges:(NSArray<UITextField *> *)textFields userTeam:(Team *)userTeam {
    NSString *oldName = userTeam.name;
    NSString *oldAbbrev = userTeam.abbreviation;
    
    NSString *name = [textFields[0].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *abbrev = [textFields[1].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *state = [textFields[2].text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (![name isEqualToString:userTeam.name] && [userTeam.league isTeamNameValid:name allowUserTeam:NO allowOverwrite:NO]) {
        [[HBSharedUtils currentLeague].userTeam setName:name];
        [[HBSharedUtils currentLeague] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
        [self.tableView reloadData];
    } else if (![userTeam.league isTeamNameValid:name allowUserTeam:NO allowOverwrite:NO]) {
        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] title:@"Error" message:@"Unable to update your team's information - invalid team name provided" onViewController:self];
        return;
    }
    
    if (![abbrev isEqualToString:userTeam.abbreviation] && [userTeam.league isTeamAbbrValid:abbrev allowUserTeam:NO allowOverwrite:NO]) {
        [[HBSharedUtils currentLeague].userTeam setAbbreviation:abbrev];
        
        Team *rival = [[HBSharedUtils currentLeague] findTeam:[HBSharedUtils currentLeague].userTeam.rivalTeam];
        [rival setRivalTeam:abbrev];
        
        NSMutableArray *tempLeagueYear;
        for (int k = 0; k < [HBSharedUtils currentLeague].leagueHistoryDictionary.count; k++) {
            NSArray *leagueYear = [HBSharedUtils currentLeague].leagueHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + k)]];
            tempLeagueYear = [NSMutableArray arrayWithArray:leagueYear];
            for (int i =0; i < leagueYear.count; i++) {
                NSString *teamString = leagueYear[i];
                if ([teamString containsString:oldName]) {
                    teamString = [teamString stringByReplacingOccurrencesOfString:oldName withString:name];
                    [tempLeagueYear replaceObjectAtIndex:i withObject:teamString];
                }
                
                if ([teamString containsString:oldAbbrev]) {
                    teamString = [teamString stringByReplacingOccurrencesOfString:oldAbbrev withString:abbrev];
                    [tempLeagueYear replaceObjectAtIndex:i withObject:teamString];
                }
            }
            
            [[HBSharedUtils currentLeague].leagueHistoryDictionary setObject:[tempLeagueYear copy] forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + k)]];
            [tempLeagueYear removeAllObjects];
        }
        
        for (int j = 0; j < [HBSharedUtils currentLeague].userTeam.teamHistoryDictionary.count; j++) {
            NSString *yearString = [HBSharedUtils currentLeague].userTeam.teamHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            if ([yearString containsString:oldAbbrev]) {
                yearString = [yearString stringByReplacingOccurrencesOfString:oldAbbrev withString:abbrev];
                
                [[HBSharedUtils currentLeague].userTeam.teamHistoryDictionary setObject:yearString forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            }
        }
        
        for (int j = 0; j < [HBSharedUtils currentLeague].heismanHistoryDictionary.count; j++) {
            NSString *heisString = [HBSharedUtils currentLeague].heismanHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            if ([heisString containsString:[NSString stringWithFormat:@", %@ (", oldAbbrev]]) {
                heisString = [heisString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@", %@ (", oldAbbrev] withString:[NSString stringWithFormat:@", %@ (", abbrev]];
                
                [[HBSharedUtils currentLeague].heismanHistoryDictionary setObject:heisString forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            }
        }
        
        for (int j = 0; j < [HBSharedUtils currentLeague].rotyHistoryDictionary.count; j++) {
            NSString *heisString = [HBSharedUtils currentLeague].rotyHistoryDictionary[[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            if ([heisString containsString:[NSString stringWithFormat:@", %@ (", oldAbbrev]]) {
                heisString = [heisString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@", %@ (", oldAbbrev] withString:[NSString stringWithFormat:@", %@ (", abbrev]];
                
                [[HBSharedUtils currentLeague].rotyHistoryDictionary setObject:heisString forKey:[NSString stringWithFormat:@"%ld",(long)([HBSharedUtils currentLeague].baseYear + j)]];
            }
        }
        
        [[HBSharedUtils currentLeague] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
        [self.tableView reloadData];
    } else if (![userTeam.league isTeamAbbrValid:abbrev allowUserTeam:NO allowOverwrite:NO]) {
        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] title:@"Error" message:@"Unable to update your team's information - invalid team abbreviation provided" onViewController:self];
        return;
    }
    
    if (![state isEqualToString:userTeam.state] && [userTeam.league isStateValid:state]) {
        [[HBSharedUtils currentLeague].userTeam setState:state];
        [[HBSharedUtils currentLeague] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
        [self.tableView reloadData];
    } else if (![userTeam.league isStateValid:state]) {
        [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] title:@"Error" message:@"Unable to update your team's information - invalid state provided" onViewController:self];
        return;
    }
    
    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils styleColor] title:@"Rebrand successful!" message:@"Successfully updated your team information!" onViewController:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBSettingsCell" bundle:nil] forCellReuseIdentifier:@"HBSettingsCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"reincarnateCoach" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleConfError) name:@"updatedConferenceError" object:nil];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    currentYear = [formatter stringFromDate:[NSDate date]];
}

-(void)handleConfError {
    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] title:@"Error" message:@"Unable to rebrand the selected conference - A conference with that name already exists." onViewController:self];
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
    self.navigationController.navigationBar.barTintColor = [HBSharedUtils styleColor];
    
}

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 50;
    } else {
        return 20;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
     return 36;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    } else {
        return UITableViewAutomaticDimension;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 6;
    } else if (section == 1) {
        return 17;
    } else {
        return 7;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LinkCell"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"AccordionSwift"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"ATAppUpdater"];
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"AutoCoding"];
        } else if (indexPath.row == 3) {
            [cell.textLabel setText:@"ios-charts"];
        } else if (indexPath.row == 4) {
            [cell.textLabel setText:@"DZNEmptyDataSet"];
        } else if (indexPath.row == 5) {
            [cell.textLabel setText:@"Fabric"];
        } else if (indexPath.row == 6) {
            [cell.textLabel setText:@"FCFileManager"];
        } else if (indexPath.row == 7) {
            [cell.textLabel setText:@"HexColors"];
        } else if (indexPath.row == 8) {
            [cell.textLabel setText:@"Icons8"];
        } else if (indexPath.row == 9) {
            [cell.textLabel setText:@"MBProgressHUD"];
        } else if (indexPath.row == 10) {
            [cell.textLabel setText:@"RMessage"];
        } else if (indexPath.row == 11) {
            [cell.textLabel setText:@"RSEmailFeedback"];
        } else if (indexPath.row == 12) {
            [cell.textLabel setText:@"ScrollableSegmentedControl"];
        } else if (indexPath.row == 13) {
            [cell.textLabel setText:@"STPopup"];
        } else if (indexPath.row == 14) {
            [cell.textLabel setText:@"WhatsNew"];
        } else if (indexPath.row == 15) {
            [cell.textLabel setText:@"ZGNavigationBarTitle"];
        } else {
            [cell.textLabel setText:@"ZMJTipView"];
        }
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Sec2Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Sec2Cell"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        }
        
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"View Game Guide"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"View Developer's Website"];
        } else if (indexPath.row == 2) {
            [cell.textLabel setText:@"Send Feedback"];
        } else if (indexPath.row == 3) {
            [cell.textLabel setText:@"View Football Coach on GitHub"];
        } else if (indexPath.row == 4) {
            [cell.textLabel setText:@"View Football Coach on Reddit"];
        } else {
            [cell.textLabel setText:@"Submit a Review"];
        }
        return cell;
    }else {
        if (indexPath.row == 0) {
            HBSettingsCell *setCell = (HBSettingsCell*)[tableView dequeueReusableCellWithIdentifier:@"HBSettingsCell"];
            BOOL notifsOn = [[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
            [setCell.settingSwitch setOnTintColor:[HBSharedUtils styleColor]];
            [setCell.settingSwitch setOn:notifsOn];
            setCell.tag = 1;
            [setCell.titleLabel setText:@"Weekly Summary Notifications"];
            [setCell.settingSwitch addTarget:self action:@selector(changeNotificationSettings:) forControlEvents:UIControlEventValueChanged];
            
            return setCell;
        } else if (indexPath.row == 1) {
            HBSettingsCell *setCell = (HBSettingsCell*)[tableView dequeueReusableCellWithIdentifier:@"HBSettingsCell"];
            BOOL pbpEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:HB_PLAY_BY_PLAY_ENABLED];
            [setCell.settingSwitch setOnTintColor:[HBSharedUtils styleColor]];
            [setCell.settingSwitch setOn:pbpEnabled];
            setCell.tag = 2;
            [setCell.titleLabel setText:@"Full Play by Play"];
            [setCell.settingSwitch addTarget:self action:@selector(changeNotificationSettings:) forControlEvents:UIControlEventValueChanged];
            
            return setCell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OptionsCell"];
                cell.backgroundColor = [UIColor whiteColor];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
               
            }
            
            if (indexPath.row == 2) {
                if ([HBSharedUtils currentLeague].isCareerMode) {
                    [cell.textLabel setText:@"Rename Coach"];
                    [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                } else {
                    [cell.textLabel setText:@"Rebrand Team"];
                    if ([HBSharedUtils currentLeague].canRebrandTeam) {
                        [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    } else {
                        [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }
                }
            } else if (indexPath.row == 3) {
                [cell.textLabel setText:@"Rebrand Conferences"];
                if ([HBSharedUtils currentLeague].canRebrandTeam) {
                    [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                } else {
                    [cell.textLabel setTextColor:[UIColor lightGrayColor]];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            } else if (indexPath.row == 4) {
                [cell.textLabel setText:@"View Career Leaderboard"];
                [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            } else if (indexPath.row == 5) {
                [cell.textLabel setText:@"Export League Metadata"];
                [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            } else {
                [cell.textLabel setText:@"Delete Save File"];
                [cell.textLabel setTextColor:[HBSharedUtils errorColor]];
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            return cell;
        }
    }
}

-(void)changeNotificationSettings:(UISwitch*)sender {
    if (sender.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:HB_PLAY_BY_PLAY_ENABLED];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) return @"Libraries Used in this Game";
    else if (section == 2) return @"Support";
    else return @"Options";
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2)
        return [NSString stringWithFormat:@"Version %@ (%@)\nCopyright © %@ Akshay Easwaran.",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"], currentYear];
    else
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSString *url;
        if (indexPath.row == 0) {
            url = @"https://github.com/Vkt0r/AccordionSwift";
        } else if (indexPath.row == 1) {
            url = @"https://github.com/apptality/ATAppUpdater";
        } else if (indexPath.row == 2) {
            url = @"https://github.com/nicklockwood/AutoCoding";
        } else if (indexPath.row == 3) {
            url = @"https://github.com/danielgindi/Charts";
        } else if (indexPath.row == 4) {
            url = @"https://github.com/dzenbot/DZNEmptyDataSet";
        } else if (indexPath.row == 5) {
            url = @"https://fabric.io";
        } else if (indexPath.row == 6) {
            url = @"https://github.com/fabiocaccamo/FCFileManager";
        } else if (indexPath.row == 7) {
            url = @"https://github.com/mRs-/HexColors";
        } else if (indexPath.row == 8) {
            url = @"http://icons8.com";
        } else if (indexPath.row == 9) {
            url = @"https://github.com/jdg/MBProgressHUD/";
        } else if (indexPath.row == 10) {
            url = @"https://github.com/donileo/RMessage";
        } else if (indexPath.row == 11) {
            url = @"https://github.com/ricsantos/RSEmailFeedback";
        } else if (indexPath.row == 12) {
            url = @"https://github.com/GocePetrovski/ScrollableSegmentedControl";
        } else if (indexPath.row == 13) {
            url = @"https://github.com/kevin0571/STPopup";
        } else if (indexPath.row == 14) {
            url = @"https://github.com/BalestraPatrick/WhatsNew";
        } else if (indexPath.row == 15) {
            url = @"https://github.com/zhigang1992/ZGNavigationBarTitle";
        } else {
            url = @"https://github.com/keshiim/ZMJTipView";
        }
        
        SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
        if ([safariVC respondsToSelector:@selector(setPreferredBarTintColor:)]) {
            safariVC.preferredBarTintColor = [HBSharedUtils styleColor];
            safariVC.preferredControlTintColor = [UIColor whiteColor];
        }
        [self presentViewController:safariVC animated:YES completion:nil];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[[HelpViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        } else if (indexPath.row == 1) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://akeaswaran.me"]];
            if ([safariVC respondsToSelector:@selector(setPreferredBarTintColor:)]) {
                safariVC.preferredBarTintColor = [HBSharedUtils styleColor];
                safariVC.preferredControlTintColor = [UIColor whiteColor];
            }
            [self presentViewController:safariVC animated:YES completion:nil];
        } else if (indexPath.row == 2) {
            RSEmailFeedback *emailFeedback = [[RSEmailFeedback alloc] init];
            emailFeedback.additionalDeviceInfo = @[([HBSharedUtils currentLeague].isHardMode ? @"Difficulty: Hard" : @"Difficulty: Easy"),([HBSharedUtils currentLeague].isCareerMode ? @"Mode: Career" : @"Mode: Normal")];
            emailFeedback.toRecipients = @[@"akeaswaran@me.com"];
            emailFeedback.subject = [NSString stringWithFormat:@"Feedback on College Football Coach %@ (%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
            [emailFeedback showOnViewController:self withCompletionHandler:^(MFMailComposeResult result, NSError *error) {
                if (result == MFMailComposeResultSent) {
                    NSLog(@"[Support Email] email sent");
                    [self emailSuccess];
                } else if (result == MFMailComposeResultFailed) {
                    NSLog(@"[Support Email] email not sent");
                    [self emailFail:error];
                }
            }];
        } else if (indexPath.row == 3) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/akeaswaran/FootballCoach-iOS"]];
            if ([safariVC respondsToSelector:@selector(setPreferredBarTintColor:)]) {
                safariVC.preferredBarTintColor = [HBSharedUtils styleColor];
                safariVC.preferredControlTintColor = [UIColor whiteColor];
            }
            [self presentViewController:safariVC animated:YES completion:nil];
            
        } else if (indexPath.row == 4) {
            SFSafariViewController *safariVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://reddit.com/r/FootballCoach"]];
            if ([safariVC respondsToSelector:@selector(setPreferredBarTintColor:)]) {
                safariVC.preferredBarTintColor = [HBSharedUtils styleColor];
                safariVC.preferredControlTintColor = [UIColor whiteColor];
            }
            [self presentViewController:safariVC animated:YES completion:nil];
            
        } else {
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.3")) {
                [SKStoreReviewController requestReview];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to leave College Football Coach?" message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
                [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:HB_APP_REVIEW_URL] options:@{} completionHandler:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    } else {
        if (indexPath.row == 6) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete your save file and start your career over?" message:@"This will take you back to the Team Selection screen." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                BOOL success = [FCFileManager removeItemAtPath:@"league.cfb"];
                if (success) {
                    [HBSharedUtils currentLeague].userTeam = nil;
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"noSaveFile" object:nil];
                    }];
                    
                } else {
                    ////NSLog(@"ERROR");
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else if (indexPath.row == 2) {
            if ([HBSharedUtils currentLeague].isCareerMode) {
                // rename coach
                [self changeCoachName];
            } else {
                if ([HBSharedUtils currentLeague].canRebrandTeam) {
                    [self changeTeamName];
                }
            }
        } else if (indexPath.row == 3) {
            if ([HBSharedUtils currentLeague].canRebrandTeam) {
                RebrandConferenceSelectorViewController *selectConf = [[RebrandConferenceSelectorViewController alloc] init];
                popupController = [[STPopupController alloc] initWithRootViewController:selectConf];
                [popupController.backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewDidTap)]];
                [popupController.navigationBar setDraggable:YES];
                popupController.style = STPopupStyleBottomSheet;
                popupController.safeAreaInsets = UIEdgeInsetsZero;
                [popupController presentInViewController:self];
            }
        } else if (indexPath.row == 4) {
            [self openLeaderboard];
        } else if (indexPath.row == 5) { // export
            NSString *metadataFile = ([HBSharedUtils currentLeague] != nil) ? [[HBSharedUtils currentLeague] leagueMetadataJSON] : @"";
            NSError *dataErr;
            NSData *jsonData = [metadataFile dataUsingEncoding:NSUTF8StringEncoding];
            id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&dataErr];
            if (jsonObject != nil && !dataErr) {
                NSError *serializeErr;
                NSData *prettyJsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:&serializeErr];
                if (prettyJsonData != nil && !serializeErr) {
                    NSString *prettyPrintedJson = [NSString stringWithUTF8String:[prettyJsonData bytes]];
                    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[prettyPrintedJson] applicationActivities:nil];
                    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,UIActivityTypeAirDrop,UIActivityTypePostToVimeo,UIActivityTypePostToFlickr,UIActivityTypeOpenInIBooks,UIActivityTypePostToWeibo,UIActivityTypeAddToReadingList,UIActivityTypePostToFacebook,UIActivityTypePostToTencentWeibo];
                    [self presentViewController:activityVC animated:YES completion:nil];
                } else {
                    NSLog(@"[Metadata Export] SERIALIZE ERR: %@", serializeErr);
                }
            } else {
                NSLog(@"[Metadata Export] DATA ERR: %@", dataErr);
            }
        }
    }
}

- (void)textFieldDidChange:(UITextField*)sender
{
    UIResponder *resp = sender;
    while (![resp isKindOfClass:[UIAlertController class]]) {
        resp = resp.nextResponder;
    }
    UIAlertController *alertController = (UIAlertController *)resp;
    NSURL* url = [NSURL URLWithString:sender.text];
    [((UIAlertAction *)alertController.actions[0]) setEnabled:(!([sender.text isEqualToString:@""] || sender.text.length == 0 || !url))];
    
    
    if (![((UIAlertAction *)alertController.actions[0]) isEnabled]) {
        [alertController setMessage:@"Please enter the valid URL of a metadata file."];
    } else {
        [alertController setMessage:@"Tap \"Import\" to apply the changes from your metadata file to your league!"];
    }
}

-(void)backgroundViewDidTap {
    [popupController dismiss];
}

-(void)emailSuccess {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Thanks for your feedback!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)emailFail:(NSError*)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your feedback was unable to be sent." message:[NSString stringWithFormat:@"Sending failed with the following error: \"%@\".",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
