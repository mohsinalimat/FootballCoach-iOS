//
//  LeagueUpdater.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 11/1/17.
//  Copyright © 2017 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "League.h"

@interface LeagueUpdater : NSObject
+(void)convertLeagueFromOldVersion:(League* _Nonnull)oldLigue updatingBlock:(void (^_Nullable)(float progress, NSString * _Nullable updateStatus))updatingBlock completionBlock:(void (^_Nullable)(BOOL success, NSString * _Nullable finalStatus, League * _Nonnull ligue))completionBlock;
@end
