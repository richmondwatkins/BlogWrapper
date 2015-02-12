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

// ======= Project Variabels ====

-(NSString *)homeVariables:(NSString *)property;

// ======== Share View ====

- (NSString *)socialAccountName:(int)shareId;
- (NSArray *)shareItems;
- (NSString *)facebookId;
- (NSString *)facebookName;

- (NSString *)pintrestId;


@end
