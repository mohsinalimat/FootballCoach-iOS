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

#import "HexColors.h"
#import "FCFileManager.h"
#import "STPopup.h"
@import MessageUI;

@interface SettingsViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SettingsViewController

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

-(void)changeTeamName{
    if (![HBSharedUtils getLeague].canRebrandTeam) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"You can only rebrand your team during the offseason." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        Team *userTeam = [HBSharedUtils getLeague].userTeam;
        NSString *oldName = userTeam.name;
        NSString *oldAbbrev = userTeam.abbreviation;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rebrand Team" message:@"Enter your new team name and abbreviation below." preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Team Name";
            textField.text = userTeam.name;
        }];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"Abbreviation";
            textField.text = userTeam.abbreviation;
        }];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to rebrand your team?" message:@"You can rebrand again at any time during the offseason." preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //save
                UITextField *name = alert.textFields[0];
                UITextField *abbrev = alert.textFields[1];
                if ((![name.text isEqualToString:userTeam.name] || ![abbrev.text isEqualToString:userTeam.abbreviation]) && (name.text.length > 0 && abbrev.text.length > 0) && (![name.text isEqualToString:@""] && ![abbrev.text isEqualToString:@""])) {
                    [[HBSharedUtils getLeague].userTeam setName:name.text];
                    [[HBSharedUtils getLeague].userTeam setAbbreviation:abbrev.text];
                    Team *rival = [[HBSharedUtils getLeague] findTeam:[HBSharedUtils getLeague].userTeam.rivalTeam];
                    if (![userTeam isEqual:[[HBSharedUtils getLeague] findTeam:@"GEO"]] && [rival.abbreviation isEqualToString:@"ALA"]) {
                        [rival setRivalTeam:@"GEO"];
                    }
                    rival = [[HBSharedUtils getLeague] findTeam:[HBSharedUtils getLeague].userTeam.rivalTeam];
                    [rival setRivalTeam:abbrev.text];

                    NSMutableArray *tempLeagueYear = [NSMutableArray array];
                    for (int k = 0; k < [HBSharedUtils getLeague].leagueHistory.count; k++) {
                        NSArray *leagueYear = [HBSharedUtils getLeague].leagueHistory[k];
                        tempLeagueYear = [NSMutableArray arrayWithArray:leagueYear];
                        for (int i =0; i < leagueYear.count; i++) {
                            NSString *teamString = leagueYear[i];
                            if ([teamString containsString:oldName]) {
                                teamString = [teamString stringByReplacingOccurrencesOfString:oldName withString:name.text];
                                NSLog(@"FOUND NAME MATCH IN LEAGUE HISTORY, REPLACING");
                                [tempLeagueYear replaceObjectAtIndex:i withObject:teamString];
                            }
                            
                            if ([teamString containsString:oldAbbrev]) {
                                teamString = [teamString stringByReplacingOccurrencesOfString:oldAbbrev withString:abbrev.text];
                                [tempLeagueYear replaceObjectAtIndex:i withObject:teamString];
                                NSLog(@"FOUND ABBREV MATCH IN LEAGUE HISTORY, REPLACING");
                            }
                        }
                        
                        [[HBSharedUtils getLeague].leagueHistory replaceObjectAtIndex:k withObject:[tempLeagueYear copy]];
                        [tempLeagueYear removeAllObjects];
                    }
                    
                    for (int j = 0; j < [HBSharedUtils getLeague].userTeam.teamHistory.count; j++) {
                        NSString *yearString = [HBSharedUtils getLeague].userTeam.teamHistory[j];
                        if ([yearString containsString:oldAbbrev]) {
                            yearString = [yearString stringByReplacingOccurrencesOfString:oldAbbrev withString:abbrev.text];
                            NSLog(@"FOUND ABBREV MATCH IN TEAM HISTORY, REPLACING");
                            [[HBSharedUtils getLeague].userTeam.teamHistory replaceObjectAtIndex:j withObject:yearString];
                        }
                    }
                    
                    for (int j = 0; j < [HBSharedUtils getLeague].heismanHistory.count; j++) {
                        NSString *heisString = [HBSharedUtils getLeague].heismanHistory[j];
                        if ([heisString containsString:[NSString stringWithFormat:@", %@ (", oldAbbrev]]) {
                            heisString = [heisString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@", %@ (", oldAbbrev] withString:[NSString stringWithFormat:@", %@ (", abbrev.text]];
                            NSLog(@"FOUND ABBREV MATCH IN HEISMAN HISTORY, REPLACING");
                            [[HBSharedUtils getLeague].heismanHistory replaceObjectAtIndex:j withObject:heisString];
                        }
                    }
                    
                    [[HBSharedUtils getLeague] save];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newTeamName" object:nil];
                    [self.tableView reloadData];
                    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils styleColor] message:[NSString stringWithFormat:@"Successfully rebranded your team to %@ (%@)!", name.text, abbrev.text] onViewController:self];
                } else {
                    [HBSharedUtils showNotificationWithTintColor:[HBSharedUtils errorColor] message:@"Unable to rebrand your team.\nInvalid inputs provided." onViewController:self];
                }
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBSettingsCell" bundle:nil] forCellReuseIdentifier:@"HBSettingsCell"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50;
    } else {
        return UITableViewAutomaticDimension;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 5;
    } else if (section == 1) {
        return 6;
    } else {
        return 3;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.backgroundColor = [UIColor whiteColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [cell.textLabel setText:@"AutoCoding"];
            } else if (indexPath.row == 1) {
                [cell.textLabel setText:@"CSNotificationView"];
            } else if (indexPath.row == 2) {
                [cell.textLabel setText:@"FCFileManager"];
            } else if (indexPath.row == 3) {
                [cell.textLabel setText:@"HexColors"];
            } else if (indexPath.row == 4) {
                [cell.textLabel setText:@"Icons8"];
            } else {
                [cell.textLabel setText:@"STPopup"];
            }
        } else {
            if (indexPath.row == 0) {
                [cell.textLabel setText:@"Developer's Website"];
            } else if (indexPath.row == 1) {
                [cell.textLabel setText:@"Email Developer"];
            } else if (indexPath.row == 2) {
                [cell.textLabel setText:@"Football Coach on GitHub"];
            } else if (indexPath.row == 3) {
                [cell.textLabel setText:@"Football Coach on Reddit"];
            } else {
                [cell.textLabel setText:@"Submit a Review"];
            }
        }
        return cell;
    } else {
        if (indexPath.row == 0) {
            HBSettingsCell *setCell = (HBSettingsCell*)[tableView dequeueReusableCellWithIdentifier:@"HBSettingsCell"];
            BOOL notifsOn = [[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
            [setCell.settingSwitch setOnTintColor:[HBSharedUtils styleColor]];
            [setCell.settingSwitch setOn:notifsOn];
            [setCell.titleLabel setText:@"Weekly Summary Notifications"];
            [setCell.settingSwitch addTarget:self action:@selector(changeNotificationSettings:) forControlEvents:UIControlEventValueChanged];
            
            return setCell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                cell.backgroundColor = [UIColor whiteColor];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                
            }
            if (indexPath.row == 1) {
                [cell.textLabel setText:@"Rebrand Team"];
                [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
            } else {
                [cell.textLabel setText:@"Delete Save File"];
                [cell.textLabel setTextColor:[HBSharedUtils errorColor]];
            }
            return cell;
        }
    }
}

-(void)changeNotificationSettings:(UISwitch*)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.isOn forKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) return @"Libraries Used in this App";
    else if (section == 2) return @"Support";
    else return @"Options";
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 2)
        return [NSString stringWithFormat:@"Version %@ (%@)\nCopyright (c) 2016 Akshay Easwaran.",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    else
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSString *url;
        if (indexPath.row == 0) {
            //[cell.textLabel setText:@"AutoCoding"];
            url = @"https://github.com/nicklockwood/AutoCoding";
        } else if (indexPath.row == 1) {
            //[cell.textLabel setText:@"FCFileManager"];
            url = @"https://github.com/problame/CSNotificationView";
        } else if (indexPath.row == 2) {
            //[cell.textLabel setText:@"FCFileManager"];
            url = @"https://github.com/fabiocaccamo/FCFileManager";
        } else if (indexPath.row == 3) {
            //[cell.textLabel setText:@"HexColors"];
            url = @"https://github.com/mRs-/HexColors";
        } else if (indexPath.row == 4) {
            //[cell.textLabel setText:@"Icons8"];
            url = @"http://icons8.com";
        } else {
            //[cell.textLabel setText:@"Icons8"];
            url = @"https://github.com/kevin0571/STPopup";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this link in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this link in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://akeaswaran.me"]];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else if (indexPath.row == 1) {
            MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
            [composer setMailComposeDelegate:self];
            [composer setToRecipients:@[@"akeaswaran@me.com"]];
            [composer setSubject:[NSString stringWithFormat:@"Football Coach %@ (%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
            [self presentViewController:composer animated:YES completion:nil];
        } else if (indexPath.row == 2) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this link in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/akeaswaran/FootballCoach-iOS"]];
            }]];
            [self presentViewController:alert animated:YES completion:nil];

        } else if (indexPath.row == 3) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this link in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://reddit.com/r/FootballCoach"]];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to leave Football Coach?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:HB_APP_REVIEW_URL]];
            }]];
            [self presentViewController:alert animated:YES completion:nil];

        }
    } else {
        if (indexPath.row == 2) {
            //NSLog(@"Delete save File");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete your save file and start your career over?" message:@"This will take you back to the Team Selection screen." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                BOOL success = [FCFileManager removeItemAtPath:@"league.cfb"];
                if (success) {
                    [HBSharedUtils getLeague].userTeam = nil;
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"noSaveFile" object:nil];
                    }];
                    
                } else {
                    //NSLog(@"ERROR");
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            
            if (indexPath.row == 1) {
                [self changeTeamName];
            }
        }
    }
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultFailed:
            [self dismissViewControllerAnimated:YES completion:nil];
            [self emailFail:error];
            break;
        case MFMailComposeResultSent:
            [self dismissViewControllerAnimated:YES completion:nil];
            [self emailSuccess];
        default:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

-(void)emailSuccess {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your email was sent successfully!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)emailFail:(NSError*)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Your email was unable to be sent." message:[NSString stringWithFormat:@"Sending failed with the following error: \"%@\".",error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
