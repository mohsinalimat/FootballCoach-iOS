//
//  TeamSelectionViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import "TeamSelectionViewController.h"
#import "Team.h"
#import "League.h"
#import "HBSharedUtils.h"
#import "AppDelegate.h"

#import <Crashlytics/Crashlytics.h>

@interface TeamSelectionViewController ()
{
    League *league;
    Team *userTeam;
    NSIndexPath *selectedIndexPath;
    BOOL isMetadataImport;
}
@end

@implementation TeamSelectionViewController

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

-(instancetype)initWithLeague:(League*)selectedLeague {
    self = [super init];
    if (self) {
        league = selectedLeague;
        isMetadataImport = NO;
    }
    return self;
}

-(instancetype)initWithLeague:(League*)selectedLeague fromMetadata:(BOOL)metadataStatus {
    self = [super init];
    if (self) {
        league = selectedLeague;
        isMetadataImport = metadataStatus;
    }
    return self;
}

-(BOOL)isValidName:(NSString *)text {
    return (!([text isEqualToString:@""] || text.length == 0 || [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0 || [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]));
}

-(void)injectCoachNameAlert:(NSString *)firstName lastName:(NSString *)lastName callback:(void (^ _Nonnull)(NSString *firstName, NSString *lastName))saveBlock {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Career - Coach Name" message:@"What do you want your coach to be named?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Coach First Name";
        textField.text = ([self isValidName:firstName]) ? firstName : nil;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Coach Last Name";
        textField.text = ([self isValidName:lastName]) ? lastName : nil;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __block NSString *first = alert.textFields[0].text;
        __block NSString *last = alert.textFields[1].text;
        if (![self isValidName:first] || ![self isValidName:last]) {
            // one of them is randomized
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIAlertController *nameAlert = [UIAlertController alertControllerWithTitle:@"Warning! Blank Name" message:@"You have left part of your coach's name blank. To preserve data quality, this will be filled in for you by the computer. Do you want to proceed?" preferredStyle:UIAlertControllerStyleAlert];
                [nameAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (![self isValidName:first]) {
                            int fn = (int)([HBSharedUtils randomValue] * self->league.nameList.count);
                            first = self->league.nameList[fn];
                        }
                        if (![self isValidName:last]) {
                            int ln = (int)([HBSharedUtils randomValue] * self->league.lastNameList.count);
                            last = self->league.lastNameList[ln];
                        }
                        saveBlock(first, last);
                    });
                }]];
                
                [nameAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self injectCoachNameAlert:first lastName:last callback:saveBlock];
                    });
                }]];
                [self presentViewController:nameAlert animated:YES completion:nil];
            });
        } else { // both names are fine
            saveBlock(first, last);
        }
     }]];
    alert.actions[0].enabled = ([self isValidName:firstName] && [self isValidName:lastName]);
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)confirmTeamSelection {
    if (selectedIndexPath && userTeam) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Are you sure you want to start your career with this team?" message:@"This choice can NOT be changed later." preferredStyle:UIAlertControllerStyleAlert];
        if (league.isCareerMode) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (self->isMetadataImport) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        UIAlertController *nameChangeAlert = [UIAlertController alertControllerWithTitle:@"Do you want to edit your coach's name?" message:@"All other attributes (including his contract length and current contract year) will be kept the same. Only the name will change." preferredStyle:UIAlertControllerStyleAlert];
                         [nameChangeAlert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 NSArray *names = [[self->userTeam getCurrentHC].name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                 NSString *firstName = names[0];
                                 NSString *lastName = names[1];
                                 [self injectCoachNameAlert:firstName lastName:lastName callback:^(NSString *firstName, NSString *lastName) {
                                     [self->userTeam getCurrentHC].name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
                                     self->userTeam.isUserControlled = YES;
                                     [self->league setUserTeam:self->userTeam];
                                     [self->league generateExpectationsNews];
                                     [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:self->league];
                                     [self->league save];
                                     
                                     NSLog(@"[Team Selection] Career MODE ENGAGED: %@, difficulty: %@", [self->userTeam getCurrentHC].name, (self->league.isHardMode) ? @"hard" : @"easy");
                                     [Answers logContentViewWithName:@"New career Save Created" contentType:@"Team" contentId:@"career-team19" customAttributes:@{@"Team Name":self->userTeam.name}];
                                     
                                     [((AppDelegate*)[[UIApplication sharedApplication] delegate]) updateTabBarForCareer];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
                             });
                         }]];
                          
                        [nameChangeAlert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            self->userTeam.isUserControlled = YES;
                            [self->league setUserTeam:self->userTeam];
                            [self->league generateExpectationsNews];
                            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:self->league];
                            [self->league save];
                            
                            NSLog(@"[Team Selection] Career MODE ENGAGED: %@, difficulty: %@", [self->userTeam getCurrentHC].name, (self->league.isHardMode) ? @"hard" : @"easy");
                            [Answers logContentViewWithName:@"New career Save Created" contentType:@"Team" contentId:@"career-team19" customAttributes:@{@"Team Name":self->userTeam.name}];
                            
                            [((AppDelegate*)[[UIApplication sharedApplication] delegate]) updateTabBarForCareer];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }]];
                          [self presentViewController:nameChangeAlert animated:YES completion:nil];
                    });
                } else {
                    NSArray *names = [[self->userTeam getCurrentHC].name componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSString *firstName = names[0];
                    NSString *lastName = names[1];
                    [self injectCoachNameAlert:firstName lastName:lastName callback:^(NSString *firstName, NSString *lastName) {
                        [self->userTeam setupUserCoach:[NSString stringWithFormat:@"%@ %@", firstName,lastName]];
                        self->userTeam.isUserControlled = YES;
                        [self->league setUserTeam:self->userTeam];
                        [self->league generateExpectationsNews];
                        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:self->league];
                        [self->league save];
                        
                        NSLog(@"[Team Selection] Career MODE ENGAGED: %@, difficulty: %@", [self->userTeam getCurrentHC].name, (self->league.isHardMode) ? @"hard" : @"easy");
                        [Answers logContentViewWithName:@"New career Save Created" contentType:@"Team" contentId:@"career-team19" customAttributes:@{@"Team Name":self->userTeam.name}];
                        
                        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) updateTabBarForCareer];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                }
            }]];
        } else {
            [alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game Difficulty" message:@"Would you like to set your game difficulty to hard? On hard, your rival will be more competitive, good players will have a higher chance of leaving for the pros, and your program can incur sanctions from the league." preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"Yes, I'd like a challenge." style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    self->userTeam.isUserControlled = YES;
                    [self->league setUserTeam:self->userTeam];
                    self->league.isHardMode = YES;
                    self->league.canRebrandTeam = YES;
                    [self->league generateExpectationsNews];
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:self->league];
                    [self->league save];
                    
                    NSLog(@"[Team Selection] HARD MODE ENGAGED");
                    [Answers logContentViewWithName:@"New Hard Mode Save Created" contentType:@"Team" contentId:@"hardmode-team16" customAttributes:@{@"Team Name":self->userTeam.name}];
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) updateTabBarForNormal];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                
                [alert addAction:[UIAlertAction actionWithTitle:@"No, I'll stick with easy." style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    self->userTeam.isUserControlled = YES;  
                    [self->league setUserTeam:self->userTeam];
                    self->league.isHardMode = NO;
                    self->league.canRebrandTeam = YES;
                    [self->league generateExpectationsNews];
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) setLeague:self->league];
                    [self->league save];
                    
                    [Answers logContentViewWithName:@"New Easy Mode Save Created" contentType:@"Team" contentId:@"team16" customAttributes:@{@"Team Name":self->userTeam.name}];
                    [((AppDelegate*)[[UIApplication sharedApplication] delegate]) updateTabBarForNormal];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newNewsStory" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"newSaveFile" object:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }]];
        }
       
        [alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pick your team!";
    for (Conference *c in league.conferences) {
        [c.confTeams sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [HBSharedUtils compareTeamPrestige:obj1 toObj2:obj2];
        }];
    }
    [self.tableView reloadData];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmTeamSelection)];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
}

-(void)reloadTable {
    if (!selectedIndexPath || !userTeam) {
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
    } else {
        [self.navigationItem.rightBarButtonItem setEnabled:YES];
    }
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor hx_colorWithHexRGBAString:@"#F7F7F7"];
    [header.textLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return league.conferences.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return league.conferences[section].confTeams.count;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%@ (Prestige: %d)",league.conferences[section].confFullName,league.conferences[section].confPrestige];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:17.0]];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:15.0]];
    }
    
    Team *team;
    if (selectedIndexPath) {
        if (indexPath.section == selectedIndexPath.section && indexPath.row == selectedIndexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    team = league.conferences[indexPath.section].confTeams[indexPath.row];
    [cell.textLabel setText:team.name];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"Prestige: %d",team.teamPrestige]];
    if (league.isHardMode && league.isCareerMode) {
        if (indexPath.row == league.conferences[indexPath.section].confTeams.count - 1 || indexPath.row == league.conferences[indexPath.section].confTeams.count - 2) {
            [cell.textLabel setTextColor:[UIColor blackColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        } else {
            [cell.textLabel setTextColor:[UIColor lightGrayColor]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    } else {
        [cell.textLabel setTextColor:[UIColor blackColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (league.isHardMode && league.isCareerMode) {
        if (indexPath.row == league.conferences[indexPath.section].confTeams.count - 1 || indexPath.row == league.conferences[indexPath.section].confTeams.count - 2) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            userTeam = league.conferences[indexPath.section].confTeams[indexPath.row];
            if ([selectedIndexPath isEqual:indexPath]) {
                selectedIndexPath = nil;
            } else {
                selectedIndexPath = indexPath;
            }
            [self reloadTable];
        }
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        userTeam = league.conferences[indexPath.section].confTeams[indexPath.row];
        if ([selectedIndexPath isEqual:indexPath]) {
            selectedIndexPath = nil;
        } else {
            selectedIndexPath = indexPath;
        }
        [self reloadTable];
    }
}

- (void)textFieldDidChange:(UITextField*)sender
{
    UIResponder *resp = sender;
    while (![resp isKindOfClass:[UIAlertController class]]) {
        resp = resp.nextResponder;
    }
    UIAlertController *alertController = (UIAlertController *)resp;
    [((UIAlertAction *)alertController.actions[0]) setEnabled:[self isValidName:sender.text]];
    
    if (![((UIAlertAction *)alertController.actions[0]) isEnabled]) {
        [alertController setMessage:@"Please fill in all fields to start your career."];
    } else {
        [alertController setMessage:@"Tap \"Save\" to start your career!"];
    }
}

@end
