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
#import "CareerLeaderboardViewController.h"

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
    HelpViewController *helpVC = [[HelpViewController alloc] initWithStyle:UITableViewStyleGrouped];
    helpVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStyleDone target:self action:@selector(dismissVC)];
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:helpVC] animated:YES completion:nil];

}

-(IBAction)pushLeaderboard:(id)sender {
    CareerLeaderboardViewController *helpVC = [[CareerLeaderboardViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:helpVC] animated:YES completion:nil];
}

-(void)dismissVC {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)newGame:(id)sender {
    // show alert for career vs normal
    UIAlertController *modeChooser = [UIAlertController alertControllerWithTitle:@"What mode would you like to play?" message:@"In Career mode, you can change jobs if other schools have openings and be fired from your program for poor performance.\n\nIn Normal mode, there's no hiring and firing. You can play forever as the same coach at the same program." preferredStyle:UIAlertControllerStyleAlert];
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"Normal Mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // career mode stuff
            [self startNewNormalModeGame];
        });
    }]];
    
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"Career Mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // career mode stuff
            [self startNewCareerModeGame];
        });
    }]];
    
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:modeChooser animated:YES completion:nil];
}

-(void)startNewCareerModeGame {
    NSLog(@"Career Mode");
    // show alert for career vs normal
    UIAlertController *modeChooser = [UIAlertController alertControllerWithTitle:@"Game Difficulty" message:@"Would you like to set your career difficulty to hard? On hard, your rival will be more competitive, good players will have a higher chance of leaving for the pros, and your program can incur sanctions from the league." preferredStyle:UIAlertControllerStyleAlert];
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"Yes, I'd like a challenge." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self provisionNewCareer:YES];
        });
    }]];

    [modeChooser addAction:[UIAlertAction actionWithTitle:@"No, I'll stick with easy." style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self provisionNewCareer:NO];
        });
    }]];
    [self presentViewController:modeChooser animated:YES completion:nil];
}

-(void)provisionNewCareer:(BOOL)isHardMode {
    [self createLeague:^(League * _Nullable ligue) {
        ligue.isCareerMode = YES;
        ligue.isHardMode = isHardMode;
        [self.navigationController pushViewController:[[TeamSelectionViewController alloc] initWithLeague:ligue] animated:YES];
    }];
}

-(void)startNewNormalModeGame {
    [self createLeague:^(League * _Nullable ligue) {
        [self.navigationController pushViewController:[[TeamSelectionViewController alloc] initWithLeague:ligue] animated:YES];
    }];
}

-(void)createLeague:(void (^_Nullable)(League * _Nullable ligue))completionBlock {
    __block NSString *firstNameCSV, *lastNameCSV;
    // display a HUD while we wait for things to get done
    UIAlertController *convertProgressAlert = [UIAlertController alertControllerWithTitle:@"Welcome, Coach!" message:@"Preparing new game..." preferredStyle:UIAlertControllerStyleAlert];
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
                    completionBlock(ligue);
                });
            });
        });
    });
}

-(void)showDifficultySelectionForMetadataGameMode:(BOOL)isForCareerMode {
    NSString *introText = @"Would you like to set your game difficulty to hard?\n\nOn hard, your rival will be more competitive, good players will have a higher chance of leaving for the pros, and your program can incur sanctions from the league.";
    if (isForCareerMode) {
        introText = @"Would you like to set your career difficulty to hard?\n\nOn hard, you will have to start your coaching career with a conference bottom-feeder, your team's rival will be more competitive, good players will have a higher chance of leaving for the pros, and your program can incur sanctions from the league.";
    }
    UIAlertController *modeChooser = [UIAlertController alertControllerWithTitle:@"Game Difficulty" message:introText preferredStyle:UIAlertControllerStyleAlert];
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"Yes, I'd like a challenge." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showLeagueMetadataWindowForGameMode:isForCareerMode difficulty:YES];
        });
    }]];
    
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"No, I'll stick with easy." style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showLeagueMetadataWindowForGameMode:isForCareerMode difficulty:NO];
        });
    }]];
    [self presentViewController:modeChooser animated:YES completion:nil];
}

-(IBAction)importLeagueMetadata:(id)sender
{
    // show alert for career vs normal
    UIAlertController *modeChooser = [UIAlertController alertControllerWithTitle:@"What mode would you like to import a file for?" message:@"In Career mode, you can change jobs if other schools have openings and be fired from your program for poor performance.\n\nIn Normal mode, there's no hiring and firing. You can play forever as the same coach at the same program." preferredStyle:UIAlertControllerStyleAlert];
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"Normal Mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // normal mode stuff
            [self showDifficultySelectionForMetadataGameMode:NO];
        });
    }]];
    
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"Career Mode" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // career mode stuff
            [self showDifficultySelectionForMetadataGameMode:YES];
        });
    }]];
    
    [modeChooser addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:modeChooser animated:YES completion:nil];
}

-(void)showLeagueMetadataWindowForGameMode:(BOOL)isForCareerMode difficulty:(BOOL)isForHardMode {
    NSString *introText;
    if (isForHardMode && isForCareerMode) {
        introText = @"Please enter the valid URL of a league metadata JSON file. This file will be used to start a Career mode save file on Hard difficulty.";
    } else if (!isForHardMode) { // career mode + easy difficulty
        introText = @"Please enter the valid URL of a league metadata JSON file. This file will be used to start a Career mode save file.";
    } else if (!isForCareerMode) { // normal mode + hard difficulty
        introText = @"Please enter the valid URL of a league metadata JSON file. This file will be used to start a Normal mode save file on Hard difficulty.";
    } else { // normal mode + easy difficulty;
        introText = @"Please enter the valid URL of a league metadata JSON file. This file will be used to start a Normal mode save file.";
    }
    UIAlertController *urlAlert = [UIAlertController alertControllerWithTitle:@"Import League Metadata" message:introText preferredStyle:UIAlertControllerStyleAlert];
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
                                    ligue.isCareerMode = isForCareerMode;
                                    ligue.isHardMode = isForHardMode;
                                    [ligue applyJSONMetadataChanges:metadataFile];
                                    
                                    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [convertProgressView stopAnimating];
                                        [convertProgressAlert dismissViewControllerAnimated:YES completion:nil];
                                    });
                                    
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self.navigationController pushViewController:[[TeamSelectionViewController alloc] initWithLeague:ligue fromMetadata:YES] animated:YES];
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
