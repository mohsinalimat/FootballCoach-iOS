//
//  IntroViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "IntroViewController.h"
#import "TeamSelectionViewController.h"
#import "League.h"
#import "Team.h"
#import "AppDelegate.h"
#import "HelpViewController.h"

#import "MBProgressHUD.h"

@import SafariServices;

@interface IntroViewController () <SFSafariViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;

@end

@implementation IntroViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    [self.copyrightLabel setText:[NSString stringWithFormat:@"Copyright © %@ Akshay Easwaran", [formatter stringFromDate:[NSDate date]]]];
}

-(IBAction)pushTutorial:(id)sender {
//    SFSafariViewController *safVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/akeaswaran/FootballCoach-iOS/blob/master/README.md"]];
//    [safVC setDelegate:self];
//    [self presentViewController:safVC animated:YES completion:nil];
    [self.navigationController pushViewController:[[HelpViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}

-(IBAction)newDynasty {
    __block NSString *firstNameCSV, *lastNameCSV;
    // display a HUD while we wait for things to get done
    UIAlertController *convertProgressAlert = [UIAlertController alertControllerWithTitle:@"Welcome, Coach!" message:@"Preparing new career..." preferredStyle:UIAlertControllerStyleAlert];
    UIActivityIndicatorView *convertProgressView = [[UIActivityIndicatorView alloc] initWithFrame:convertProgressAlert.view.bounds];
    [convertProgressView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [convertProgressView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth];
    convertProgressView.center = convertProgressAlert.view.center;
    [convertProgressAlert.view addSubview:convertProgressView];
    convertProgressView.tintColor = [HBSharedUtils styleColor];
    [convertProgressView setUserInteractionEnabled:NO];
    [convertProgressView startAnimating];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:convertProgressAlert animated:YES completion:nil];
        
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray *firstNamePathFrags = [[HBSharedUtils firstNamesCSV] componentsSeparatedByString:@"."];
        NSString *firstNamePath = firstNamePathFrags[0];
        NSString *firstNameFullPath = [[NSBundle mainBundle] pathForResource:firstNamePath ofType:@"csv"];
        NSError *error;
        firstNameCSV = [NSString stringWithContentsOfFile:firstNameFullPath encoding:NSUTF8StringEncoding error:&error];
        if (error) {
            NSLog(@"First name list retrieve error: %@", error);
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSArray *lastNamePathFrags = [[HBSharedUtils lastNamesCSV] componentsSeparatedByString:@"."];
            NSString *lastNamePath = lastNamePathFrags[0];
            NSString *lastNameFullPath = [[NSBundle mainBundle] pathForResource:lastNamePath ofType:@"csv"];
            NSError *error;
            lastNameCSV = [NSString stringWithContentsOfFile:lastNameFullPath encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"Last name list retrieve error: %@", error);
            }
            
            // do UI updates on main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [convertProgressView stopAnimating];
                    [convertProgressAlert dismissViewControllerAnimated:YES completion:nil];
                });
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    League *ligue = [League newLeagueFromCSV:firstNameCSV lastNamesCSV:lastNameCSV];
                    ligue.canRebrandTeam = YES;
                    [self.navigationController pushViewController:[[TeamSelectionViewController alloc] initWithLeague:ligue] animated:YES];
                });
            });
        });
    });
}

-(IBAction)importLeagueMetadata:(id)sender {
    
    UIAlertController *urlAlert = [UIAlertController alertControllerWithTitle:@"Import League Metadata" message:@"Please enter the valid URL of a league metadata JSON file." preferredStyle:UIAlertControllerStyleAlert];
    [urlAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"URL to File"];
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [urlAlert addAction:[UIAlertAction actionWithTitle:@"Import" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [hud setMode:MBProgressHUDModeIndeterminate];
        [hud.label setText:@"Loading Metadata File..."];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSURL* fileURL = [NSURL URLWithString:urlAlert.textFields[0].text];
        if (fileURL == nil || ![fileURL.absoluteString containsString:@".json"]) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Metadata File" message:[NSString stringWithFormat:@"The metadata file from %@ is in an invalid format. Please provide a valid metadata file to import.",urlAlert.textFields[0].text] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
                [self presentViewController:alertController animated:YES completion:nil];
            });
        } else {
            //[Answers logContentViewWithName:@"Third-Party Roster Imported" contentType:@"Roster" contentId:@"roster16" customAttributes:nil];
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                //[HBSharedUtils generateLeagueWithRosterFileURL:urlAlert.textFields[0].text fromViewController:self hud:hud];
                NSURL *url = fileURL;
                NSStringEncoding encoding;
                NSError *error;
                NSString *metadataFile = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&error];
                
                if (error || metadataFile.length == 0 || [metadataFile containsString:@"<body"] || [metadataFile containsString:@"<html"] || [metadataFile containsString:@"<head"]) {
                    if (error) {
                        NSLog(@"ERROR IMPORTING: %@", error.localizedDescription);
                    }
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Invalid Metadata File" message:[NSString stringWithFormat:@"The metadata file from %@ is in an invalid format. Please provide a valid metadata file to import.",fileURL] preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        [hud hideAnimated:YES];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self presentViewController:alertController animated:YES completion:nil];
                        });
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                        
                        __block NSString *firstNameCSV, *lastNameCSV;
                        // display a HUD while we wait for things to get done
                        UIAlertController *convertProgressAlert = [UIAlertController alertControllerWithTitle:@"Welcome, Coach!" message:@"Preparing new career..." preferredStyle:UIAlertControllerStyleAlert];
                        UIActivityIndicatorView *convertProgressView = [[UIActivityIndicatorView alloc] initWithFrame:convertProgressAlert.view.bounds];
                        [convertProgressView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
                        [convertProgressView setAutoresizingMask: UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleWidth];
                        convertProgressView.center = convertProgressAlert.view.center;
                        [convertProgressAlert.view addSubview:convertProgressView];
                        convertProgressView.tintColor = [HBSharedUtils styleColor];
                        [convertProgressView setUserInteractionEnabled:NO];
                        [convertProgressView startAnimating];
                        
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self presentViewController:convertProgressAlert animated:YES completion:nil];
                            
                        });
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                            NSArray *firstNamePathFrags = [[HBSharedUtils firstNamesCSV] componentsSeparatedByString:@"."];
                            NSString *firstNamePath = firstNamePathFrags[0];
                            NSString *firstNameFullPath = [[NSBundle mainBundle] pathForResource:firstNamePath ofType:@"csv"];
                            NSError *error;
                            firstNameCSV = [NSString stringWithContentsOfFile:firstNameFullPath encoding:NSUTF8StringEncoding error:&error];
                            if (error) {
                                NSLog(@"First name list retrieve error: %@", error);
                            }
                            
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                NSArray *lastNamePathFrags = [[HBSharedUtils lastNamesCSV] componentsSeparatedByString:@"."];
                                NSString *lastNamePath = lastNamePathFrags[0];
                                NSString *lastNameFullPath = [[NSBundle mainBundle] pathForResource:lastNamePath ofType:@"csv"];
                                NSError *error;
                                lastNameCSV = [NSString stringWithContentsOfFile:lastNameFullPath encoding:NSUTF8StringEncoding error:&error];
                                if (error) {
                                    NSLog(@"Last name list retrieve error: %@", error);
                                }
                                
                                // do UI updates on main queue
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    League *ligue = [League newLeagueFromCSV:firstNameCSV lastNamesCSV:lastNameCSV];
                                    [ligue applyJSONMetadataChanges:metadataFile];
                                    
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [convertProgressView stopAnimating];
                                        [convertProgressAlert dismissViewControllerAnimated:YES completion:nil];
                                    });
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self.navigationController pushViewController:[[TeamSelectionViewController alloc] initWithLeague:ligue] animated:YES];
                                    });
                                });
                            });
                        });

                    });
                }
            });
        }
    }]];
    
    [urlAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:urlAlert animated:YES completion:nil];
    
    
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

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
