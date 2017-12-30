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
{
    ScrollableSegmentedControl *positionSelectionControl;
    NSMutableArray *recruits;
}
@end

@implementation RecruitingPeriodViewController

-(void)selectPosition:(ScrollableSegmentedControl *)sender {
    NSLog(@"POSITION %lu SELECTED", sender.selectedSegmentIndex);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    positionSelectionControl = [[ScrollableSegmentedControl alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height, [UIScreen mainScreen].bounds.size.width, 44)];
    positionSelectionControl.segmentStyle = ScrollableSegmentedControlSegmentStyleTextOnly;
    positionSelectionControl.underlineSelected = YES;
    positionSelectionControl.selectedSegmentContentColor = [HBSharedUtils styleColor];
    positionSelectionControl.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"FFFFFF" alpha:0.85];
    [positionSelectionControl insertSegmentWithTitle:@"ALL" at:0];
    [positionSelectionControl insertSegmentWithTitle:@"QB" at:1];
    [positionSelectionControl insertSegmentWithTitle:@"RB" at:2];
    [positionSelectionControl insertSegmentWithTitle:@"WR" at:3];
    [positionSelectionControl insertSegmentWithTitle:@"TE" at:4];
    [positionSelectionControl insertSegmentWithTitle:@"OL" at:5];
    [positionSelectionControl insertSegmentWithTitle:@"DL" at:6];
    [positionSelectionControl insertSegmentWithTitle:@"LB" at:7];
    [positionSelectionControl insertSegmentWithTitle:@"CB" at:8];
    [positionSelectionControl insertSegmentWithTitle:@"S" at:9];
    [positionSelectionControl insertSegmentWithTitle:@"K" at:10];
    [positionSelectionControl addTarget:self action:@selector(selectPosition:) forControlEvents:UIControlEventValueChanged];
    [positionSelectionControl setSelectedSegmentIndex:0];
    [self.navigationController.view addSubview:positionSelectionControl];
    [self.tableView setContentInset:UIEdgeInsetsMake(44, 0, 0, 0)];

    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = 140;
    [self.tableView registerNib:[UINib nibWithNibName:@"CFCRecruitCell" bundle:nil] forCellReuseIdentifier:@"CFCRecruitCell"];
    self.navigationItem.title = @"Recruiting";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Advance" style:UIBarButtonItemStylePlain target:self action:@selector(advancePeriods)];
    
    // calculate recruiting points, but never show number - just show as usage as "% effort extended"
    
    recruits = [NSMutableArray array];
    // generate recruits the same way as before
    // generate offers for other teams
    [self.tableView reloadData];
}

-(void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)advancePeriods {
    // Basically advancing to results
    // need to run recruiting for other teams:
    //      1. from offers for recruit, calculate interest and sign with highest-interest team
    //      2. if highest-interest team is user team, then:
    //          * color name
    //          * change status to committed
    //      3. if highest-interest team is NOT user team. then:
    //          * if interest was mild or medium, then:
    //              * offer to flip (for large amount of recruiting points)
    //          * else:
    //              * fade name
    
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
    return 10; //recruits.count;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // navigate to page where you can view recruit details and have options to recruit him:
    //          1. extend offer - sends LOI to recruit; can only give out maxTeamSize - currentTeamSize of these
    //          2. extend official visit/OV - spend small amount of recruiting points (smaller amount than in-home) to court player on campus; increases interest by 10pts.
    //          3. visit recruit at home - spend large amount of recruiting points to court player at home; increases interest by 20pts.
    //          4. also provide option to cancel each of these -- basically we are building a recruiting process for each recruit that we think will be best to sign him
    // if committed to user team, show options:
    //          1. redshirt player
    // if committed, but NOT to user team, show options:
    //          1. if interest in that team was mild or medium, then:
    //              * offer and flip (for large amount of recruiting points) -- increases interest in user team by 20 pts.
    // also display recruiting process for this recruit: OV -> offer -> commit or offer -> commit or OV -> home visit -> offer -> commit
}

@end
