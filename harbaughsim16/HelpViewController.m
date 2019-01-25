//
//  HelpViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/1/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setEstimatedRowHeight:200];
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    self.navigationItem.title = @"Game Guide";
    [self.view setBackgroundColor:[HBSharedUtils styleColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"news-sort"] style:UIBarButtonItemStylePlain target:self action:@selector(navToSection)];
}

-(void)navToSection {
    UIAlertController *sectionSelect = [UIAlertController alertControllerWithTitle:@"Navigate to Help Section:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [sectionSelect addAction:[UIAlertAction actionWithTitle:@"General" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }]];
    [sectionSelect addAction:[UIAlertAction actionWithTitle:@"Depth Chart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }]];
    [sectionSelect addAction:[UIAlertAction actionWithTitle:@"Recruiting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }]];
    [sectionSelect addAction:[UIAlertAction actionWithTitle:@"Transfers" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }]];
    [sectionSelect addAction:[UIAlertAction actionWithTitle:@"Metadata Editing" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }]];
    
    [sectionSelect addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:sectionSelect animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 36;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    if (section == 0) {
        title = @"General";
    } else if (section == 1) {
        title = @"Depth Chart";
    } else if (section == 2) {
        title = @"Recruiting";
    } else if (section == 3) {
        title = @"Transfers";
    } else {
        title = @"Metadata Editing";
    }
    return title;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [header.textLabel setTextColor:[UIColor lightTextColor]];
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setFont:[UIFont systemFontOfSize:15.0]];
    [footer.textLabel setTextColor:[UIColor lightTextColor]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setNumberOfLines:0];
    }
    if (indexPath.section == 0) { // general description
        [cell.textLabel setText:[HBSharedUtils generalTutorialText]];
    } else if (indexPath.section == 1) { // depth chart
        [cell.textLabel setText:[HBSharedUtils depthChartTutorialText]];
    } else if (indexPath.section == 2) { // recruiting
        [cell.textLabel setText:[HBSharedUtils recruitingTutorialText]];
    } else if (indexPath.section == 3) { // recruiting
        [cell.textLabel setText:[HBSharedUtils transferTutorialText]];
    } else { //metadata editing
        [cell.textLabel setText:[HBSharedUtils metadataEditingText]];
    }
    [cell.textLabel sizeToFit];
    return cell;
}

@end
