//
//  LeagueYearViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "LeagueYearViewController.h"
#import "League.h"
#import "Team.h"

@interface LeagueYearViewController ()
{
    NSArray *top10;
    NSString *selectedYear;
}
@end

@implementation LeagueYearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ Season Recap",selectedYear];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(instancetype)initWithYear:(NSString*)year top10:(NSArray*)apTop10 {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        top10 = apTop10;
        selectedYear = year;
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return top10.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    // Configure the cell...
    [cell.textLabel setText:[NSString stringWithFormat:@"#%ld: %@",(long) (1 + indexPath.row),top10[indexPath.row]]];
    if ([cell.textLabel.text containsString:[HBSharedUtils getLeague].userTeam.abbreviation]) {
        [cell.textLabel setTextColor:[HBSharedUtils styleColor]];
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
    }
    return cell;
}
@end
