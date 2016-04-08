//
//  LeagueHistoryController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/21/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "LeagueHistoryController.h"
#import "Team.h"

@interface LeagueHistoryController ()
{
    NSArray *leagueHistory;
    NSArray *heismanHistory;
}
@end

@implementation LeagueHistoryController

-(id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    leagueHistory = [HBSharedUtils getLeague].leagueHistory;
    heismanHistory = [HBSharedUtils getLeague].heismanHistory;
    [self.tableView setRowHeight:60];
    [self.tableView setEstimatedRowHeight:60];
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    self.title = @"League History";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAll) name:@"newTeamName" object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadAll {
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return leagueHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.detailTextLabel setNumberOfLines:0];
    }
    // Configure the cell...
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)]];
    NSString *heisman = heismanHistory[indexPath.row];
    NSMutableArray *leagueYear = leagueHistory[indexPath.row];
    NSMutableAttributedString *champString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Champion: %@",leagueYear[0]]];
    if ([champString.string containsString:[HBSharedUtils getLeague].userTeam.abbreviation]) {
        [champString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, champString.string.length)];
    } else {
        [champString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, champString.string.length)];
    }
    
    
    NSMutableAttributedString *heismanString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nPOTY: %@",heisman]];
    if ([heisman containsString:[HBSharedUtils getLeague].userTeam.abbreviation]) {
        [heismanString addAttribute:NSForegroundColorAttributeName value:[HBSharedUtils styleColor] range:NSMakeRange(0, heismanString.string.length)];
    } else {
        [heismanString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, heismanString.string.length)];
    }
    
    [champString appendAttributedString:heismanString];
    [cell.detailTextLabel setAttributedText:champString];
    [cell.detailTextLabel sizeToFit];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSMutableArray *leagueYear = leagueHistory[indexPath.row];
    //[self.navigationController pushViewController:[[LeagueYearViewController alloc] initWithYear:[NSString stringWithFormat:@"%ld", (long)(2016 + indexPath.row)] top10:leagueYear] animated:YES];
}


@end
