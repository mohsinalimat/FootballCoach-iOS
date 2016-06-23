//
//  ConferenceStandingsSelectorViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 4/14/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "ConferenceStandingsSelectorViewController.h"
#import "Conference.h"
#import "League.h"

#import "STPopup.h"

@interface ConferenceStandingsSelectorViewController ()
{
    NSArray *conferences;
}
@end

@implementation ConferenceStandingsSelectorViewController


-(instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, (6 * 50));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select a conference to view";
    conferences = [HBSharedUtils getLeague].conferences;
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    [self.popupController.containerView setBackgroundColor:[HBSharedUtils styleColor]];
    [self.tableView setRowHeight:50];
    [self.tableView setEstimatedRowHeight:50];
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
    return conferences.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
    }
    
    Conference *conf = conferences[indexPath.row];
    [cell.textLabel setText:[conf confFullName]];
    [cell.detailTextLabel setText:conf.confName];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSLog(@"SELECTED CONF: %@", [conferences[indexPath.row] confName]);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToConfStandings" object:conferences[indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
