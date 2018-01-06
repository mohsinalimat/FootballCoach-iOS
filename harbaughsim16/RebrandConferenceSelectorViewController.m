//
//  RebrandConferenceSelectorViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 6/23/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "RebrandConferenceSelectorViewController.h"
#import "Conference.h"
#import "League.h"
#import "Team.h"

#import "STPopup.h"

@interface RebrandConferenceSelectorViewController ()
{
    NSArray *conferences;
}
@end

@implementation RebrandConferenceSelectorViewController

-(instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        self.contentSizeInPopup = CGSizeMake([UIScreen mainScreen].bounds.size.width, (6 * 50));
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Select a conference to rebrand";
    conferences = [HBSharedUtils currentLeague].conferences;
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
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    Conference *selectedConf = conferences[indexPath.row];
    NSLog(@"SELECTED CONF: %@", selectedConf.confName);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Rebranding %@", selectedConf.confName] message:@"Please enter a new conference name and abbreviation." preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Conference Name";
        textField.text = selectedConf.confFullName;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Conference Abbreviation";
        textField.text = selectedConf.confName;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL _notBad = ([[HBSharedUtils currentLeague] isConfAbbrValid:alertController.textFields[1].text] && [[HBSharedUtils currentLeague] isConfNameValid:alertController.textFields[0].text]);
        
        if (!_notBad) {
            NSLog(@"BAD");
            [self dismissViewControllerAnimated:YES completion:nil];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedConferenceError" object:nil];
            });
        } else {
            selectedConf.confFullName = alertController.textFields[0].text;
            selectedConf.confName = alertController.textFields[1].text;
            
            for (Team *t in selectedConf.confTeams) {
                t.conference = selectedConf.confName;
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updatedConferences" object:nil];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [[HBSharedUtils currentLeague] save];
            });
        }
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (void)textFieldDidChange:(UITextField*)sender
{
    UIResponder *resp = sender;
    while (![resp isKindOfClass:[UIAlertController class]]) {
        resp = resp.nextResponder;
    }
    UIAlertController *alertController = (UIAlertController *)resp;
    if ([sender.placeholder.lowercaseString isEqualToString:@"conference abbreviation"]) {
        [((UIAlertAction *)alertController.actions[0]) setEnabled:(!([sender.text isEqualToString:@""] || sender.text.length < 3))];
    } else {
        [((UIAlertAction *)alertController.actions[0]) setEnabled:(!([sender.text isEqualToString:@""] || sender.text.length == 0))];
    }
    
    
    if (![((UIAlertAction *)alertController.actions[0]) isEnabled]) {
        [alertController setMessage:@"Please finish filling out the fields to rebrand the conference."];
    } else {
        [alertController setMessage:@"Tap \"Save\" to finish the rebranding process!"];
    }
}


@end
