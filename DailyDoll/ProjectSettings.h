//
//  ThemeManager.h
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIColor+UIColor_Expanded.h"
#import "ProjectSettingsKeys.h"

@interface ProjectSettings : NSObject


+ (ProjectSettings *)sharedManager;

- (id)initFromPlist;

-(void)populateCoreData:(NSManagedObjectContext *)moc;

// ======= Side Menu ============

- (NSString *)getNavBar:(NSString *)property;
- (NSString *)getStatusBarColor:(NSString *)property;
- (NSString *)getSideMenuHeader:(NSString *)property;
- (NSString *)getSideMenuTableView:(NSString *)property;
- (NSString *)getSideMenuCell:(NSString *)property;
- (NSString *)getSideMenuSectionHeader:(NSString *)property;

// ======= Project Variabels ====

-(NSString *)homeVariables:(NSString *)property;
- (NSString *)bundleID;

// ======= Main View ====

-(NSString *)activityIndicator:(NSString *)property;

// ======== Share View ====

- (NSString *)socialPropertiesForItem:(int)shareId withItem:(NSString *)item;
- (NSString *)socialAccountName:(int)shareId;
- (NSString *)shareView:(NSString *)property;
- (NSString *)shareTableView:(NSString *)property;
- (NSArray *)shareItems;
- (NSArray *)buttonsForShareItem:(int)shareId;
- (NSString *)facebookId;
- (NSString *)facebookName;

- (NSString *)pintrestId;

- (NSString *)instagramOAuthItems:(NSString *)item;

@end
