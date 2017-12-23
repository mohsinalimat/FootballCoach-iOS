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
    SFSafariViewController *safVC = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:@"https://github.com/akeaswaran/FootballCoach-iOS/blob/master/README.md"]];
    [safVC setDelegate:self];
    [self presentViewController:safVC animated:YES completion:nil];
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
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:[[TeamSelectionViewController alloc] initWithLeague:[League newLeagueFromCSV:firstNameCSV lastNamesCSV:lastNameCSV]] animated:YES];
                });
            });
        });
    });
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
