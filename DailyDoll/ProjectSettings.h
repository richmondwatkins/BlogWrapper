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

- (NSString *)fetchThemeElement:(NSString *)elementName withProperty:(NSString *)property;

- (NSString *)fetchSocialItem:(int)itemId withProperty:(NSString *)property;

- (NSArray *)fetchSocialButtonsForItem:(int)itemId;

- (NSString *)fetchThemeItem:(int)itemId withProperty:(NSString *)property;

- (void)setThemeItemsToNil;

-(NSString *)metaDataVariables:(NSString *)property;

- (NSString *)socialAccountName:(int)shareId;

- (NSArray *)shareItems;

- (BOOL)siteHasSocialAccount:(int)socialAccount withMoc:(NSManagedObjectContext *)moc;

- (void)saveSocialInteraction:(int)socialItem;

- (BOOL)hasInteractedWithSocialItem:(int)socialId;

@end
