//
//  HBSharedUtils.h
//  harbaughsim16
//
//  Created by Akshay Easwaran on 3/18/16.
//  Copyright © 2016 Akshay Easwaran. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "League.h"
#import "HBTeamPlayView.h"

#define HB_IN_APP_NOTIFICATIONS_TURNED_ON @"inAppNotifs"
#define HB_CURRENT_THEME_COLOR @"themeColor"
#define HB_NUMBER_OF_COLOR_OPTIONS 4
#define HB_RECRUITING_TUTORIAL_SHOWN @"kHBTutorialShownKey"
#define HB_UPCOMING_TUTORIAL_SHOWN_KEY @"kHBPlayingTutorialKey"
#define HB_ROSTER_TUTORIAL_SHOWN_KEY @"kHBRosterTutorialShownKey"
#define HB_TRANSFER_TUTORIAL_SHOWN_KEY @"kHBTransferTutorialShownKey"
#define HB_COACHING_TUTORIAL_SHOWN_KEY @"kHBCoachingTutorialShownKey"
#define HB_STAT_HISTORY_TUTORIAL_SHOWN_KEY @"kHBStatHistoryTutorialShownKey"
#define kHBSimFirstLaunchKey @"firstLaunch"
#define HB_OFFSEASON_TUTORIAL_SHOWN_KEY @"kHBOffseasonTutorialShownKey"
#define HB_PLAY_BY_PLAY_ENABLED @"playByPlayEnabled"

#define HB_APP_REVIEW_URL @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1095701497&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"

#define HB_CURRENT_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define HB_APP_VERSION_CURRENT_MINOR_VERSION [HBSharedUtils currentMinorVersion]
#define HB_APP_VERSION_PRE_OVERHAUL @"1.1.4"
#define HB_APP_VERSION_POST_OVERHAUL @"2.0"

#define HB_SAVE_FILE_NEEDS_UPDATE YES

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define MEETING_INTEREST_BONUS 5
#define OFFICIAL_VISIT_INTEREST_BONUS 10
#define INHOME_VISIT_INTEREST_BONUS 15

#define AGE_ADDED_COST (([HBSharedUtils currentLeague].isCareerMode && [HBSharedUtils currentLeague].isHardMode) ? MAX(0, ([[HBSharedUtils currentLeague].userTeam getCurrentHC].age - 70) * 2.0) : 0)

#define MEETING_COST 12 + AGE_ADDED_COST
#define OFFICIAL_VISIT_COST 25 + AGE_ADDED_COST
#define INHOME_VISIT_COST 50 + AGE_ADDED_COST
#define EXTEND_OFFER_COST 75 + AGE_ADDED_COST
#define FLIP_COST 150 + AGE_ADDED_COST

#define LARGE_FONT_SIZE 17.0
#define MEDIUM_FONT_SIZE 15.0
#define SMALL_FONT_SIZE 12.0

#ifdef DEBUG
#   define IS_DEBUG true
#else
#   define IS_DEBUG false
#endif

#ifdef DEBUG
#   define NSLog(...) NSLog(__VA_ARGS__)
#else
#   define NSLog(...) (void)0
#endif

typedef enum {
    CFCRegionDistanceMatch,
    CFCRegionDistanceNeighbor,
    CFCRegionDistanceFar,
    CFCRegionDistanceCrossCountry
} CFCRegionDistance;

typedef enum {
    CFCRegionNortheast,
    CFCRegionSouth,
    CFCRegionMidwest,
    CFCRegionWest,
    CFCRegionUnknown
} CFCRegion;

typedef enum {
    CFCRecruitEventPositionCoachMeeting,
    CFCRecruitEventOfficialVisit,
    CFCRecruitEventInHomeVisit,
    CFCRecruitEventExtendOffer,
    CFCRecruitEventCommitted,
    CFCRecruitEventFlipped,
    CFCRecruitEventRedshirted,
    CFCRecruitEventUnredshirted
} CFCRecruitEvent;

typedef enum {
    CFCRecruitingStageWinter,
    CFCRecruitingStageEarlySigningDay,
    CFCRecruitingStageSigningDay,
    CFCRecruitingStageFallCamp,
    CFCRecruitingStageStartTransferPeriod,
    CFCRecruitingStageMidTransferPeriod,
    CFCRecruitingStageEndTransferPeriod
} CFCRecruitingStage;

typedef enum {
    CRCTransferViewOptionIncoming,
    CRCTransferViewOptionOutgoing,
    CRCTransferViewOptionBoth
} CRCTransferViewOption;

typedef enum {
    FCCoachStatusNormal,
    FCCoachStatusHotSeat,
    FCCoachStatusSecure,
    FCCoachStatusSafe,
    FCCoachStatusUnsafe,
    FCCoachStatusOk
} FCCoachStatus;

@interface HBSharedUtils : NSObject
+(double)randomValue;
+(League*)currentLeague;
+(UIColor *)styleColor;
+(UIColor *)errorColor;
+(UIColor *)successColor;
+(UIColor *)progressColor;
+(UIColor *)offeredColor;
+(UIColor *)champColor;
+(void)setStyleColor:(NSDictionary*)colorDict;
+(NSArray *)colorOptions;
+(NSString*)firstNamesCSV;
+(NSString*)lastNamesCSV;
+ (NSArray *)states;
+ (NSString *)generalTutorialText;
+ (NSString *)recruitingTutorialText;
+ (NSString *)depthChartTutorialText;
+ (NSString *)metadataEditingText;
+ (NSString *)transferTutorialText;

+(void)showNotificationWithTintColor:(UIColor*)tintColor message:(NSString*)message onViewController:(UIViewController*)viewController;
+(void)showNotificationWithTintColor:(UIColor*)tintColor title:(NSString *)title message:(NSString*)message onViewController:(UIViewController*)viewController;
+(NSString *)randomState;

+(NSComparisonResult)compareRecruitingComposite:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)comparePlayers:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareDepthChartPositions:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareDepthChartPositionsPostInjury:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)comparePositions:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareDivTeams:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareMVPScore:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)comparePollScore:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareSoW:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)comparePlayoffTeams:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareStars:(id)obj1 toObj2:(id)obj2;

+(NSComparisonResult)compareTeamPPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareOppPPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareOppYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamPYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareOppPYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamRYPG:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareOppRYPG:(id)obj1 toObj2:(id)obj2;

+(NSComparisonResult)compareTeamTODiff:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamOffTalent:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamDefTalent:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamPrestige:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareTeamLeastWins:(id)obj1 toObj2:(id)obj2;

+(NSComparisonResult)compareCoachScore:(id)obj1 toObj2:(id)obj2;
+(NSComparisonResult)compareCoachOvr:(id)obj1 toObj2:(id)obj2;

+(NSComparisonResult)compareConfPrestige:(id)obj1 toObj2:(id)obj2;

+(NSString *)generateOfferString:(NSDictionary *)offers;
+(NSDictionary *)generateInterestMetadata:(int)interestVal otherOffers:(NSDictionary *)offers;
+(NSString *)_calculateInterestString:(int)interestVal;
+(UIColor *)_calculateInterestColor:(int)interestVal;
+(NSString *)convertStarsToUIImageName:(int)stars;

+(void)simulateEntireSeason:(int)weekTotal viewController:(UIViewController*)viewController headerView:(HBTeamPlayView*)teamHeaderView callback:(void (^)(void))callback;
+(void)playWeek:(UIViewController*)viewController headerView:(HBTeamPlayView*)teamHeaderView callback:(void (^)(void))callback;

+(CFCRegion)regionForState:(NSString *)state;
+(CFCRegionDistance)distanceFromRegion:(CFCRegion)region1 toRegion:(CFCRegion)region2;
+ (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber;

+(NSString*)getLetterGrade:(int)num;
+(UIColor *)_colorForCoachStatus:(FCCoachStatus)status;
+(UIColor *)_colorForLetterGrade:(NSString *)letterGrade;
+ (NSString *)jobPickerTutorial:(BOOL)wasFired;
+(BOOL)isValidNumber:(id)supposedNumber;
+(NSString *)currentMinorVersion;

+(NSString *)convertStatKeyToTitle:(NSString *)key;
+(NSArray *)sortStatKeyArray:(NSArray<NSString *> *)keys;
+(NSArray *)sortStatHistoryYears:(NSArray<NSString *> *)keys;
+(NSComparisonResult)compareStatHistoryYears:(NSString *)year1 year2:(NSString *)year2;

+ (CGFloat)calculateConferencePrestigeFactor:(NSString *)conf resetMarker:(BOOL)resetMarker;
+ (CGFloat)calculateMaxPrestige;
+ (void)showRetirementControllerUsingSourceViewController:(UIViewController *)viewController;
+ (void)addCoachToCoachLeaderboard:(HeadCoach *)coach;

+(NSNumberFormatter *)prestigeNumberFormatter;

+ (CGFloat)mapValue:(CGFloat)input inputMin:(CGFloat)inMin inputMax:(CGFloat)inMax outputMin:(CGFloat)outMin outputMax:(CGFloat)outMax;
@end
