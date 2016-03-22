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

#import "HexColors.h"
#import "FCFileManager.h"
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


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStyleDone target:self action:@selector(dismissVC)];
    
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[UILabel appearanceWhenContainedInInstancesOfClasses:@[[UITableViewHeaderFooterView class],[self class]]] setTextColor:[UIColor lightTextColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"HBSettingsCell" bundle:nil] forCellReuseIdentifier:@"HBSettingsCell"];
}

-(void)dismissVC {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 3;
    } else if (section == 1) {
        return 6;
    } else {
        return 2;
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
                [cell.textLabel setText:@"FCFileManager"];
            } else if (indexPath.row == 2) {
                [cell.textLabel setText:@"HexColors"];
            } else if (indexPath.row == 3) {
                [cell.textLabel setText:@"Icons8"];
            } else if (indexPath.row == 4) {
                [cell.textLabel setText:@"STPopup"];
            } else {
                [cell.textLabel setText:@"Whisper"];
            }
        } else {
            if (indexPath.row == 0) {
                [cell.textLabel setText:@"Developer's Website"];
            } else if (indexPath.row == 1) {
                [cell.textLabel setText:@"Email Developer"];
            } else {
                [cell.textLabel setText:@"Football Coach on GitHub"];
            }
        }
        return cell;
    } else {
        if (indexPath.row == 0) {
            HBSettingsCell *setCell = (HBSettingsCell*)[tableView dequeueReusableCellWithIdentifier:@"HBSettingsCell"];
            BOOL notifsOn = [[NSUserDefaults standardUserDefaults] boolForKey:HB_IN_APP_NOTIFICATIONS_TURNED_ON];
            [setCell.settingSwitch setOnTintColor:[HBSharedUtils styleColor]];
            [setCell.settingSwitch setOn:notifsOn];
            [setCell.titleLabel setText:@"In App Notifications"];
            [setCell.settingSwitch addTarget:self action:@selector(changeNotificationSettings:) forControlEvents:UIControlEventValueChanged];
            
            return setCell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                cell.backgroundColor = [UIColor whiteColor];
                [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
                [cell.textLabel setTextColor:[UIColor redColor]];
            }
            [cell.textLabel setText:@"Delete Save File"];
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
            url = @"https://github.com/fabiocaccamo/FCFileManager";
        } else if (indexPath.row == 2) {
            //[cell.textLabel setText:@"HexColors"];
            url = @"https://github.com/mRs-/HexColors";
        } else if (indexPath.row == 3) {
            //[cell.textLabel setText:@"Icons8"];
            url = @"http://icons8.com";
        } else if (indexPath.row == 4) {
            //[cell.textLabel setText:@"Icons8"];
            url = @"https://github.com/kevin0571/STPopup";
        } else {
            //[cell.textLabel setText:@"Whisper"];
            url = @"https://github.com/hyperoslo/Whisper";
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
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this link in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/jonesguy14/footballcoach"]];
            }]];
            [self presentViewController:alert animated:YES completion:nil];

        }
    } else {
        if (indexPath.row == 1) {
            NSLog(@"Delete save File");
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure you want to delete your save file and start your career over?" message:@"This will take you back to the Team Selection screen." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
                BOOL success = [FCFileManager removeItemAtPath:@"league.cfb"];
                if (success) {
                    [HBSharedUtils getLeague].userTeam = nil;
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                       // [((MyTeamViewController*)self.presentingViewController) performSelector:@selector(presentIntro) withObject:nil afterDelay:0.1];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"noSaveFile" object:nil];
                    }];
                    
                } else {
                    NSLog(@"ERROR");
                }
            }]];
            [self presentViewController:alert animated:YES completion:nil];
            
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
