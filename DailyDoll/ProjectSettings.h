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
#import "Notification.h"

@interface ProjectSettings : NSObject


+ (ProjectSettings *)sharedManager;

- (id)initFromPlist;

-(void)populateCoreData:(NSManagedObjectContext *)moc withCompletion:(void(^)(BOOL))completion;

- (NSString *)fetchSocialItem:(int)itemId withProperty:(NSString *)property;

- (NSArray *)fetchSocialButtonsForItem:(int)itemId;

- (NSString *)fetchThemeItem:(int)itemId withProperty:(NSString *)property;

- (NSString *)fetchmetaDataVariables:(NSString *)property;

- (NSArray *)fetchShareItems;

- (NSArray *)fetchMenuItemsAndHeaders;

- (BOOL)siteHasSocialAccount:(int)socialAccount withMoc:(NSManagedObjectContext *)moc;

- (void)saveSocialInteraction:(int)socialId withStatus:(BOOL)saveStatus;

- (BOOL)hasInteractedWithSocialItem:(int)socialId;

- (NSString *)fetchMetaThemeItemWithProperty:(NSString *)property;

- (NSArray *)shareItemsWithoutInstagram;

- (NSArray *)fetchMetaDataAccessoryPages;

- (BOOL)projectHasSocialAccounts;

- (UIImage *)fetchLogoImage;

//Push Notifications

- (void)setNotification:(NSDictionary *)notification withManagedObjectContext:(NSManagedObjectContext *)moc;

- (NSArray *)fetchNotifications;

- (void)setNotificationAsViewed:(Notification *)notification;

- (void)listFonts;

@end
