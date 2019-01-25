//
//  TransferringPlayersViewController.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 12/22/18.
//  Copyright © 2018 Akshay Easwaran. All rights reserved.
//

#import "FCTableViewController.h"

#import "Team.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferringPlayersViewController : FCTableViewController
-(instancetype)initWithTeam:(Team *)t viewOption:(CRCTransferViewOption)option;
@end

NS_ASSUME_NONNULL_END
