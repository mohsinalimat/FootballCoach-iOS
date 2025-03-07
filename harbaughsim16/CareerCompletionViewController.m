//
//  CareerCompletionViewController.m
//  harbaughsim16
//
//  Created by Akshay Easwaran on 1/5/19.
//  Copyright © 2019 Akshay Easwaran. All rights reserved.
//

#import "CareerCompletionViewController.h"
#import "HBSharedUtils.h"
#import "HeadCoach.h"
@import QuartzCore;

@interface CareerCompletionGlimpseView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *teamsLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerConfRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerConfRecordTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerRivalryRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerBowlRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerCCGRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerCCGRecordTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerNCGRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *careerAwardsReportLabel;
@property (weak, nonatomic) IBOutlet UILabel *playerAwardsReportLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *coachCareerScoreLabel;
@end
@implementation CareerCompletionGlimpseView
@end

@interface CareerCompletionViewController ()
{
    IBOutlet CareerCompletionGlimpseView *glimpseView;
    HeadCoach *selectedCoach;
    
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *nextButton;
    
    NSDictionary *coachDictionary;
}
@end

@implementation CareerCompletionViewController

-(instancetype)initWithCoach:(HeadCoach *)coach {
    self = [super init];
    if (self) {
        selectedCoach = coach;
    }
    return self;
}

-(instancetype)initWithCoachDictionary:(NSDictionary *)coachDict {
    self = [super init];
    if (self) {
        coachDictionary = coachDict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    glimpseView.layer.cornerRadius = 15.f;
    glimpseView.layer.masksToBounds = YES;
    
    [self updateGlimpseView];
    
    [closeButton setImage:[[UIImage imageNamed:@"close"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [closeButton.imageView setTintColor:[UIColor whiteColor]];
}

-(void)updateGlimpseView {
    if (selectedCoach != nil) {
        [glimpseView.titleLabel setText:@"Your Career Card"];
        [glimpseView.nameLabel setText:selectedCoach.name];
        [glimpseView.ageLabel setText:[NSString stringWithFormat:@"Age: %d | %d-%d | Overall: %d", selectedCoach.age, selectedCoach.startYear, selectedCoach.startYear + selectedCoach.year, selectedCoach.ratOvr]];
        [glimpseView.teamsLabel setText:[selectedCoach teamsCoachedString]];
        [glimpseView.teamsLabel sizeToFit];
        
        [glimpseView.careerRecordLabel setText:[NSString stringWithFormat:@"%d-%d", selectedCoach.totalWins,selectedCoach.totalLosses]];
        [glimpseView.careerConfRecordLabel setText:[NSString stringWithFormat:@"%d-%d", selectedCoach.totalConfWins,selectedCoach.totalConfLosses]];
        [glimpseView.careerRivalryRecordLabel setText:[NSString stringWithFormat:@"%d-%d", selectedCoach.totalRivalryWins,selectedCoach.totalRivalryLosses]];
        [glimpseView.careerBowlRecordLabel setText:[NSString stringWithFormat:@"%d-%d", selectedCoach.totalBowls,selectedCoach.totalBowlLosses]];
        [glimpseView.careerCCGRecordLabel setText:[NSString stringWithFormat:@"%d-%d", selectedCoach.totalCCs,selectedCoach.totalCCLosses]];
        [glimpseView.careerNCGRecordLabel setText:[NSString stringWithFormat:@"%d-%d", selectedCoach.totalNCs,selectedCoach.totalNCLosses]];
        
        [glimpseView.careerAwardsReportLabel setText:[selectedCoach coachAwardReportString]];
        [glimpseView.careerAwardsReportLabel sizeToFit];
        [glimpseView.playerAwardsReportLabel setText:[selectedCoach playerAwardReportString]];
        [glimpseView.playerAwardsReportLabel sizeToFit];
        
        [glimpseView.coachCareerScoreLabel setText:[NSString stringWithFormat:@"%d", [selectedCoach getCoachCareerScore]]];
    } else {
        [glimpseView.titleLabel setText:@"Career Card"];
        [glimpseView.nameLabel setText:coachDictionary[@"coachName"]];
        
        [glimpseView.ageLabel setText:[NSString stringWithFormat:@"Age: %@ | %@-%d | Overall: %@", coachDictionary[@"age"], coachDictionary[@"startYear"], ([coachDictionary[@"startYear"] intValue] + [coachDictionary[@"yearsCoachedFor"] intValue]), [self retrieveStat:@"ratOvr"]]];
        [glimpseView.teamsLabel setText:coachDictionary[@"teamsCoached"]];
        [glimpseView.teamsLabel sizeToFit];
        
        [glimpseView.careerRecordLabel setText:[NSString stringWithFormat:@"%@-%@", [self retrieveStat:@"totalWins"],[self retrieveStat:@"totalLosses"]]];
        [glimpseView.careerConfRecordLabel setText:[NSString stringWithFormat:@"%@-%@", [self retrieveStat:@"totalConfWins"],[self retrieveStat:@"totalConfLosses"]]];
        [glimpseView.careerRivalryRecordLabel setText:[NSString stringWithFormat:@"%@-%@", [self retrieveStat:@"totalRivalryWins"],[self retrieveStat:@"totalRivalryLosses"]]];
        [glimpseView.careerBowlRecordLabel setText:[NSString stringWithFormat:@"%@-%@", [self retrieveStat:@"totalBowls"],[self retrieveStat:@"totalBowlLosses"]]];
        [glimpseView.careerCCGRecordLabel setText:[NSString stringWithFormat:@"%@-%@", [self retrieveStat:@"totalCCs"],[self retrieveStat:@"totalCCLosses"]]];
        [glimpseView.careerNCGRecordLabel setText:[NSString stringWithFormat:@"%@-%@", [self retrieveStat:@"totalNCs"],[self retrieveStat:@"totalNCLosses"]]];
        
        [glimpseView.careerAwardsReportLabel setText:coachDictionary[@"coachAwards"]];
        [glimpseView.careerAwardsReportLabel sizeToFit];
        [glimpseView.playerAwardsReportLabel setText:coachDictionary[@"playerAwards"]];
        [glimpseView.playerAwardsReportLabel sizeToFit];
        
        [glimpseView.coachCareerScoreLabel setText:[NSString stringWithFormat:@"%@", [self retrieveStat:@"coachScore"]]];
    }
    
    [glimpseView setNeedsLayout];
}

-(NSString *)retrieveStat:(NSString *)statKey {
    return ([coachDictionary.allKeys containsObject:statKey]) ? coachDictionary[statKey] : @"0";
}

-(IBAction)closeController {
    UIViewController *presenter = self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        if (self->coachDictionary == nil && self->selectedCoach != nil) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HBSharedUtils showRetirementControllerUsingSourceViewController:presenter];
            });
        }
    }];
}

-(IBAction)shareCareer:(id)sender {
    UIImage *glimpseImage = [self imageFromView:glimpseView];
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:@[glimpseImage] applicationActivities:nil];
    //shareController.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll];
    [self presentViewController:shareController animated:YES completion:nil];
}

// From https://github.com/PatMurrayDEV/Share-Your-Rings/blob/master/CloseTheRings/Video%20Code/New%20Group/Glimpse.m
- (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size , YES , 0 );
    
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    } else {
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *rasterizedView = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rasterizedView;
}
@end
