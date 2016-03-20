//
//  RecruitingViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/20/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "RecruitingViewController.h"
#import "League.h"
#import "Team.h"

#define TUTORIAL_SHOWN @"kHBTutorialShownKey"

@implementation RecruitingViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //display tutorial alert on first launch
    BOOL tutorialShown = [[NSUserDefaults standardUserDefaults] boolForKey:TUTORIAL_SHOWN];
    if (!tutorialShown) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TUTORIAL_SHOWN];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //display intro screen
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Welcome to Recruiting Season, Coach!" message:@"At the end of each season, graduating seniors leave the program and spots open up. As coach, you are responsible for recruiting the next class of players that will lead your team to bigger and better wins. You recruit based on a budget, which is determined by your team's prestige. Better teams will have more money to work with, while worse teams will have to save money wherever they can.\n\nWhen you press \"Begin Recruiting\" after the season, you can see who is leaving your program and give you a sense of how many players you will need to replace. Next, the Recruiting menu opens up (where you are now). You can view recruits from every position or select \"Top 100 Recruits\" to see the best of the best. Each Recruit has their positional ratings as well as an Overall and Potential. The cost of each recruit (insert Cam Newton and/or Ole Miss joke here) is determined by how good they are. Once you are done recruiting all the players you need, or that you can afford, press \"Done\" to advance to the next season." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishRecruiting)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissVC)];
    
    self.title = [NSString stringWithFormat:@"Budget: $%d",[HBSharedUtils getLeague].userTeam.recruitingMoney];
}

-(void)dismissVC {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to quit recruiting?" message:@"If you choose to back out, your team's recruiting will be done automatically and you will have no control over who assistant coaches bring to your program. Do you still want to quit, coach?" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //sim recruiting for this guy
        NSLog(@"SIM RECRUITING");
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)finishRecruiting {
    /*if (selectedIndexPath && userTeam) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to pick this team?" message:@"This choice can NOT be changed later." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [league setUserTeam:userTeam];
            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:league];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"No team has been chosen. Please select one and try again." preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }*/
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Your position needs have not been filled. Please pick more recruits and try again." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
