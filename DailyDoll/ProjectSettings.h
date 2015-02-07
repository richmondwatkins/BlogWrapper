//
//  ThemeManager.h
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectSettings : NSObject


+ (ProjectSettings *)sharedManager;

// ======= Side Menu ============

-(NSString *)navBar:(NSString *)property;
-(NSString *)statusBarColor:(NSString *)property;
-(NSString *)sideMenuHeader:(NSString *)property;
-(NSString *)sideMenuTableView:(NSString *)property;
-(NSString *)sideMenuCell:(NSString *)property;
-(NSString *)sideMenuSectionHeader:(NSString *)property;

// ======= Project Variabels ====

-(NSString *)homeVariables:(NSString *)property;

// ======= Main View ====

-(NSString *)activityIndicator:(NSString *)property;


@end