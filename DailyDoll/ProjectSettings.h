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

-(void)populateCoreData:(NSManagedObjectContext *)moc withCompletion:(void(^)(BOOL))completion;

- (NSString *)fetchSocialItem:(int)itemId withProperty:(NSString *)property;

- (NSArray *)fetchSocialButtonsForItem:(int)itemId;

- (NSString *)fetchThemeItem:(int)itemId withProperty:(NSString *)property;

- (NSString *)metaDataVariables:(NSString *)property;

- (NSArray *)shareItems;

- (NSArray *)fetchMenuItemsAndHeaders;

- (BOOL)siteHasSocialAccount:(int)socialAccount withMoc:(NSManagedObjectContext *)moc;

- (void)saveSocialInteraction:(int)socialId withStatus:(BOOL)saveStatus;

- (BOOL)hasInteractedWithSocialItem:(int)socialId;

- (NSString *)fetchMetaThemeItemWithProperty:(NSString *)property;

- (NSArray *)shareItemsWithoutInstagram;

@end
