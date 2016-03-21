//
//  SettingsViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "SettingsViewController.h"

#import "HexColors.h"
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
}

-(void)dismissVC {
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"HexColors"];
        } else if (indexPath.row == 1) {
            [cell.textLabel setText:@"Whisper"];
        } else {
            [cell.textLabel setText:@"Icons8"];
        }
    } else {
        if (indexPath.row == 0) {
            [cell.textLabel setText:@"Developer's Website"];
        } else {
            [cell.textLabel setText:@"Email Developer"];
        }
    }
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"Libraries Used in this App";
    else return @"Support";
}

-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1)
        return [NSString stringWithFormat:@"Version %@ (%@)\nCopyright (c) 2016 Akshay Easwaran.",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    else
        return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSString *url;
        if (indexPath.row == 0) {
            url = @"https://github.com/mRs-/HexColors";
        } else if (indexPath.row == 1){
            url = @"https://github.com/hyperoslo/Whisper";
        }else {
            url = @"http://icons8.com";
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this link in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        if (indexPath.row == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Do you want to open this link in Safari?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
            [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://akeaswaran.me"]];
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
            [composer setMailComposeDelegate:self];
            [composer setToRecipients:@[@"akeaswaran@me.com"]];
            [composer setSubject:[NSString stringWithFormat:@"Football Coach %@ (%@)",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
            [self presentViewController:composer animated:YES completion:nil];
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
