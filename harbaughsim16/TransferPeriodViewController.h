//
//  TransferPeriodViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/22/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"
#import "TransferActionsViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface TransferPeriodViewController : FCTableViewController <TransferActionsDelegate>
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *signedTransferRanks;
@property (strong, nonatomic) NSMutableArray<Player *>* progressedTransfers;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *transferActivities;
@property (nonatomic) int recruitingPoints;
@property (nonatomic) int usedRecruitingPoints;
@end

NS_ASSUME_NONNULL_END
