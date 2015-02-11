//
//  ThemeManager.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ProjectSettings.h"
#import "ThemeElement.h"
#import "ShareTableViewTheme.h"
#import "SideMenuCellTheme.h"
#import "SideMenuHeaderTheme.h"
#import "SideMenuSectionHeaderTheme.h"
#import "StatusBarTheme.h"
#import "ShareTableViewTheme.h"
#import "ActivityIndicatorTheme.h"
#import "NavBarTheme.h"
#import "SideMenuTableViewTheme.h"
#import "ShareViewTheme.h"
#import "AppDelegate.h"

@interface ProjectSettings ()

@property NSDictionary *themeElements;
@property NSDictionary *projectVariables;
@property ThemeElement *themeItems;

@end

@implementation ProjectSettings

static ProjectSettings *sharedThemeManager = nil;

+ (ProjectSettings *)sharedManager {
    @synchronized([ProjectSettings class]){
        if (sharedThemeManager == nil) {
            sharedThemeManager = [[self alloc] initFromPlist];
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

- (id)initFromPlist {
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
// Theme Set - Core Data

-(void)populateCoreData:(NSManagedObjectContext *)moc withCompletion:(void(^)(BOOL))completion {


    ThemeElement *themeElement = [NSEntityDescription insertNewObjectForEntityForName:@"ThemeElement" inManagedObjectContext:moc];

    themeElement.navBar = [self setNavBar:moc];
    themeElement.statusBar = [self setStatusBarColor:moc];
    themeElement.sideMenuHeader = [self setSideMenuHeader:moc];
    themeElement.sideMenuTableView = [self setSideMenuTableView:moc];
    themeElement.sideMenuCell = [self setSideMenuCell:moc];
    themeElement.sideMenuSectionHeader = [self setSideMenuSectionHeader:moc];
    themeElement.shareView = [self setShareView:moc];
    themeElement.activityIndicator = [self setActivityIndicator:moc];
    [moc save:nil];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setBool:YES forKey:kFirstStartUp];
    
    [userDefaults synchronize];

    completion(YES);

    self.themeElements = nil;
}

//========= Side Menu ========

- (NavBarTheme *)setNavBar:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"NavBar";

    NavBarTheme  *navBarTheme = [NSEntityDescription insertNewObjectForEntityForName:@"NavBarTheme" inManagedObjectContext:moc];
    navBarTheme.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];
    navBarTheme.fontColor = [self returnThemeElement:themeItem andProperty:kFontColor];
    navBarTheme.fontFamily = [self returnThemeElement:themeItem andProperty:kFontFamily];

  
    return navBarTheme;
}

- (StatusBarTheme *)setStatusBarColor:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"StatusBar";

    StatusBarTheme *statusBar = [NSEntityDescription insertNewObjectForEntityForName:@"StatusBarTheme" inManagedObjectContext:moc];
    statusBar.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return statusBar;
}

- (SideMenuHeaderTheme *)setSideMenuHeader:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"SideMenuHeader";

    SideMenuHeaderTheme *sideMenuHeader = [NSEntityDescription insertNewObjectForEntityForName:@"SideMenuHeaderTheme" inManagedObjectContext:moc];
    sideMenuHeader.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return sideMenuHeader;
}

- (SideMenuTableViewTheme *)setSideMenuTableView:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"SideMenuTableView";

    SideMenuTableViewTheme *sideMenuTableView = [NSEntityDescription insertNewObjectForEntityForName:@"SideMenuTableViewTheme" inManagedObjectContext:moc];
    sideMenuTableView.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return sideMenuTableView;
}

- (SideMenuCellTheme *)setSideMenuCell:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"SideMenuCell";

    SideMenuCellTheme *sideMenuCell = [NSEntityDescription insertNewObjectForEntityForName:@"SideMenuCellTheme" inManagedObjectContext:moc];
    sideMenuCell.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];
    sideMenuCell.fontColor = [self returnThemeElement:themeItem andProperty:kFontColor];
    sideMenuCell.fontFamily = [self returnThemeElement:themeItem andProperty:kFontFamily];

    return sideMenuCell;
}

- (SideMenuSectionHeaderTheme *)setSideMenuSectionHeader:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"SideMenuSectionHeader";
    SideMenuSectionHeaderTheme *sideMenuHeader = [NSEntityDescription insertNewObjectForEntityForName:@"SideMenuSectionHeaderTheme" inManagedObjectContext:moc];
    sideMenuHeader.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];
    sideMenuHeader.fontColor =  [self returnThemeElement:themeItem andProperty:kFontColor];
    sideMenuHeader.fontFamily =  [self returnThemeElement:themeItem andProperty:kFontFamily];

    return sideMenuHeader;
}

- (ShareViewTheme *)setShareView:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"ShareView";
    ShareViewTheme *shareView = [NSEntityDescription insertNewObjectForEntityForName:@"ShareViewTheme" inManagedObjectContext:moc];
    shareView.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return shareView;
}

- (ActivityIndicatorTheme *)setActivityIndicator:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"ActivityIndicator";
    ActivityIndicatorTheme *activityIndicator = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityIndicatorTheme" inManagedObjectContext:moc];
    activityIndicator.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return activityIndicator;
}

// HELPERS

- (NSString *)fetchThemeElement:(NSString *)elementName withProperty:(NSString *)property {

    if (self.themeItems == nil) {
        NSFetchRequest *themeFetch = [[NSFetchRequest alloc] initWithEntityName:@"ThemeElement"];

        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

        NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:themeFetch error:nil];

        self.themeItems = [results firstObject];

    }

    return [[self.themeItems valueForKey:elementName] valueForKey:property];
}

- (NSString *)returnThemeElement:(NSString *)themeElement andProperty:(NSString *)property {

    return self.themeElements[themeElement][property];
}

- (void)setThemeItemsToNil {

    self.themeItems = nil;
}


// Theme Fetch - Core Data

// ======== Project Variabels ====


- (NSString *)homeVariables:(NSString *)property {

    return self.projectVariables[@"Home"][property];
}

- (NSString *)bundleID {

   return self.projectVariables[@"BundleId"];
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

- (NSArray *)shareItems {

    return self.projectVariables[@"Social"];
}

- (NSArray *)buttonsForShareItem:(int)shareId {

    return self.projectVariables[@"Social"][shareId][@"Buttons"];
}

- (NSString *)socialPropertiesForItem:(int)shareId withItem:(NSString *)item {

    return self.projectVariables[@"Social"][shareId][item];
}

- (NSString *)facebookId {

    return self.projectVariables[@"Social"][0][@"pageId"];
}

- (NSString *)facebookName {

    return self.projectVariables[@"Social"][0][@"pageName"];
}

- (NSString *)pintrestId {

    return self.projectVariables[@"Social"][1][@"appId"];
}

- (NSString *)socialAccountName:(int)shareId {

    return self.projectVariables[@"Social"][shareId][@"AccountName"];
}

- (NSString *)instagramOAuthItems:(NSString *)item {

    return self.projectVariables[@"Instagram"][item];
}

@end
