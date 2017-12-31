//
//  RecruitingPeriodViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/28/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"

typedef enum {
    CFCRecruitEventPositionCoachMeeting,
    CFCRecruitEventOfficialVisit,
    CFCRecruitEventInHomeVisit,
    CFCRecruitEventExtendOffer,
    CFCRecruitEventCommitted
} CFCRecruitEvent;

@interface RecruitingPeriodViewController : FCTableViewController

@end
