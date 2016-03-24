//
//  ColorSelectionViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/24/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "ColorSelectionViewController.h"
#import "Team.h"

#import "STPopup.h"

@interface ColorSelectionViewController ()
{
    NSIndexPath *selectedIndexPath;
}
@end

@implementation ColorSelectionViewController

-(instancetype)init {
    if (self = [super init]) {
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, 10 + (HB_NUMBER_OF_COLOR_OPTIONS * 50));
        NSDictionary *selectedColor = [[NSUserDefaults standardUserDefaults] objectForKey:HB_CURRENT_THEME_COLOR];
        if (selectedColor) {
            NSInteger index = [[HBSharedUtils colorOptions] indexOfObject:selectedColor];
            selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Theme Color";
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
    return [HBSharedUtils colorOptions].count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    
    NSDictionary *color = [HBSharedUtils colorOptions][indexPath.row];
    [cell.textLabel setText:color[@"title"]];
    
    if (selectedIndexPath) {
        if (indexPath.row == selectedIndexPath.row && indexPath.section == selectedIndexPath.section) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([selectedIndexPath isEqual:indexPath]) {
        selectedIndexPath = nil;
    } else {
        selectedIndexPath = indexPath;
    }
    
    [HBSharedUtils setStyleColor:[HBSharedUtils colorOptions][indexPath.row]];
    //self.navigationController.navigationBar.barTintColor = [HBSharedUtils styleColor];
    self.popupController.navigationBar.barTintColor = [HBSharedUtils styleColor];
    [self.tableView reloadData];
    //[[HBSharedUtils getLeague] save];
}

@end
