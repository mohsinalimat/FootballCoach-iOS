//
//  TransferActionsViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/22/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class Player;

@interface TransferActionsViewController : FCTableViewController
@property (nonatomic) id delegate;
-(instancetype)initWithPotentialTransfer:(Player *)p events:(NSArray *)events;
@end

@protocol TransferActionsDelegate
@required
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSString *> *signedTransferRanks;
@property (strong, nonatomic) NSMutableArray<Player *>* progressedTransfers;
@property (strong, nonatomic) NSMutableDictionary<NSString *, NSMutableArray *> *transferActivities;
@property (nonatomic) int recruitingPoints;
@property (nonatomic) int usedRecruitingPoints;
-(void)transferActionsController:(TransferActionsViewController *)actionsController didUpdateTransfer:(Player *)transfer withEvent:(CFCRecruitEvent)event;
@end

NS_ASSUME_NONNULL_END
