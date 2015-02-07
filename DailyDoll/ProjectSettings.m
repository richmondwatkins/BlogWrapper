//
//  ThemeManager.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ProjectSettings.h"

@interface ProjectSettings ()

@property NSDictionary *themeElements;
@property NSDictionary *projectVariables;

@end

@implementation ProjectSettings

static ProjectSettings *sharedThemeManager = nil;

+ (ProjectSettings *)sharedManager {
    @synchronized([ProjectSettings class]){
        if (sharedThemeManager == nil) {
            sharedThemeManager = [[self alloc] init];
        }

        return sharedThemeManager;
    }
    return nil;
}

+(id)alloc {
    @synchronized([ProjectSettings class])
    {
        NSAssert(sharedThemeManager == nil, @"Singleton already initialized.");
        sharedThemeManager = [super alloc];
        return sharedThemeManager;
    }
    return nil;
}

- (id)init {
    if ( (self = [super init]) ) {

        NSDictionary *themeDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                               pathForResource:@"Theme"
                                                                               ofType:@"plist"]];
        self.themeElements = [themeDict objectForKey:@"Theme"];

        NSDictionary *projectDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                               pathForResource:@"ProjectVariables"
                                                                               ofType:@"plist"]];
        self.projectVariables = [projectDict objectForKey:@"Project"];

    }
    return self;
}

//========= Side Menu ========

- (NSString *)navBar:(NSString *)property {

    return self.themeElements[@"NavBar"][property];
}

- (NSString *)statusBarColor:(NSString *)property {

    return self.themeElements[@"StatusBarColor"][property];
}

- (NSString *)sideMenuHeader:(NSString *)property {

    return self.themeElements[@"SideMenuHeader"][property];
}

- (NSString *)sideMenuTableView:(NSString *)property {

    return self.themeElements[@"SideMenuTableView"][property];
}

- (NSString *)sideMenuCell:(NSString *)property {

    return self.themeElements[@"SideMenuCell"][property];
}

- (NSString *)sideMenuSectionHeader:(NSString *)property {

    return self.themeElements[@"SideMenuSectionHeader"][property];
}


// ======== Project Variabels ====


- (NSString *)homeVariables:(NSString *)property {

    return self.projectVariables[@"Home"][property];
}

// ======= Main View ====

- (NSString *)activityIndicator:(NSString *)property {

    return self.themeElements[@"ActivityIndicator"][property];
}


// ======== Share View ====

- (NSString *)shareView:(NSString *)property {

    return self.themeElements[@"ShareView"][property];
}

- (NSString *)shareTableView:(NSString *)property {

    return self.themeElements[@"ShareTableView"][property];
}



@end
