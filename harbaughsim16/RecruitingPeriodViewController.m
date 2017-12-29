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

#import "STPopup.h"
#import "HexColors.h"
@import ScrollableSegmentedControl;

@interface RecruitingPeriodViewController ()

@end

@implementation RecruitingPeriodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = 140;
    [self.tableView registerNib:[UINib nibWithNibName:@"CFCRecruitCell" bundle:nil] forCellReuseIdentifier:@"CFCRecruitCell"];
    self.navigationItem.title = @"Early Signing Day";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Advance" style:UIBarButtonItemStylePlain target:self action:@selector(advancePeriods)];
}

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)advancePeriods {
    
}

-(UIColor *)convertInterestToColor:(int)interestVal {
    UIColor *letterColor = [UIColor lightGrayColor];
    if (interestVal > 89) { // LOCK
        letterColor = [HBSharedUtils successColor];
    } else if (interestVal > 74 && interestVal <= 89) { // HIGH
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#a6d96a"];
    } else if (interestVal > 64 && interestVal <= 74) { // MEDIUM
        letterColor = [HBSharedUtils champColor];
    } else if (interestVal > 49 && interestVal <= 64) { // MILD
        letterColor = [UIColor hx_colorWithHexRGBAString:@"#fdae61"];
    } else { // LOW
        letterColor = [UIColor lightGrayColor];
    }
    return letterColor;
}

-(NSString *)convertInterestToString:(int)interestVal {
    NSString *interestString = @"LOW";
    if (interestVal > 75) { // LOCK
        interestString = @"LOCK";
    } else if (interestVal > 64 && interestVal <= 75) { // HIGH
        interestString = @"HIGH";
    } else if (interestVal > 49 && interestVal <= 64) { // MEDIUM
        interestString = @"MEDIUM";
    } else if (interestVal > 33 && interestVal <= 49) { // MILD
        interestString = @"MILD";
    } else { // LOW
        interestString = @"LOW";
    }
    return interestString;
}

-(NSString *)convertStarsToUIImageName:(int)stars {
    switch (stars) {
        case 2:
            return @"2stars";
            break;
        case 3:
            return @"3stars";
            break;
        case 4:
            return @"4stars";
            break;
        case 5:
            return @"2stars";
            break;
        default:
            return @"1star";
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    [self setToolbarItems:@[
                            [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"roster"] style:UIBarButtonItemStylePlain target:self action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithTitle:@"View Needs" style:UIBarButtonItemStylePlain target:self action:nil],
                            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:nil]
                            ]
     ];
    self.navigationController.toolbarHidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CFCRecruitCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFCRecruitCell"];
    
    // test data
    int interest = (int)([HBSharedUtils randomValue] * 100);
    int stars = (int)([HBSharedUtils randomValue] * 4) + 1;
    NSString *name = [[HBSharedUtils getLeague] getRandName];
    NSString *position = @"WR";
    NSString *state = [HBSharedUtils randomState];
    NSString *height = @"6\'2\"";
    NSString *weight = @"235 lbs";
    NSString *fortyTime = @"4.50s";
    NSString *overall = [NSString stringWithFormat:@"#%lu %@", (indexPath.row + 1), position];
    
    
    // Valid cell data formatting code
    NSMutableAttributedString *interestString = [[NSMutableAttributedString alloc] initWithString:@"Interest: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [interestString appendAttributedString:[[NSAttributedString alloc] initWithString:[self convertInterestToString:interest] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [self convertInterestToColor:interest]}]];
    [cell.interestLabel setAttributedText:interestString];
    [cell.starImageView setImage:[UIImage imageNamed:[self convertStarsToUIImageName:stars]]];
    
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", position] attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
    [nameString appendAttributedString:[[NSAttributedString alloc] initWithString:name attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}]];
    [cell.nameLabel setAttributedText:nameString];
    
    [cell.stateLabel setText:state];
    
    NSMutableAttributedString *heightString = [[NSMutableAttributedString alloc] initWithString:@"Height: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [heightString appendAttributedString:[[NSAttributedString alloc] initWithString:height attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.heightLabel setAttributedText:heightString];
    
    NSMutableAttributedString *weightString = [[NSMutableAttributedString alloc] initWithString:@"Weight: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [weightString appendAttributedString:[[NSAttributedString alloc] initWithString:weight attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.weightLabel setAttributedText:weightString];
    
    NSMutableAttributedString *dashString = [[NSMutableAttributedString alloc] initWithString:@"40-yd dash: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor blackColor]}];
    [dashString appendAttributedString:[[NSAttributedString alloc] initWithString:fortyTime attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0], NSForegroundColorAttributeName : [UIColor lightGrayColor]}]];
    [cell.fortyYdDashLabel setAttributedText:dashString];
    
    [cell.rankLabel setText:overall];
    
    return cell;
}


@end
