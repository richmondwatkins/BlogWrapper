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
#import "AppDelegate.h"

@interface ProjectSettings ()

@property NSDictionary *themeElements;
@property NSDictionary *projectVariables;

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

-(void)populateCoreData:(NSManagedObjectContext *)moc {


    ThemeElement *themeElement = [NSEntityDescription insertNewObjectForEntityForName:@"ThemeElement" inManagedObjectContext:moc];

    themeElement.navBar = [self setNavBar:moc];
    themeElement.statusBar = [self setStatusBarColor:moc];
    themeElement.sideMenuHeader = [self setSideMenuHeader:moc];
    themeElement.sideMenutableView = [self setSideMenuTableView:moc];
    themeElement.sideMenuCell = [self setSideMenuCell:moc];
    themeElement.sideMenuSectionHeader = [self setSideMenuSectionHeader:moc];

    [moc save:nil];
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

- (NSString *)getNavBar:(NSString *)property {

    NSArray *fetchResults = [self fetchThemeElement:@"NavBarTheme"];

    NavBarTheme *themeItem = [fetchResults firstObject];

    return [themeItem valueForKey:property];
}


- (StatusBarTheme *)setStatusBarColor:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"StatusBar";

    StatusBarTheme *statusBar = [NSEntityDescription insertNewObjectForEntityForName:@"StatusBarTheme" inManagedObjectContext:moc];
    statusBar.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return statusBar;
}

- (NSString *)getStatusBarColor:(NSString *)property {

    NSArray *fetchResults = [self fetchThemeElement:@"StatusBarTheme"];

    StatusBarTheme *themeItem = [fetchResults firstObject];

    return [themeItem valueForKey:property];
}

- (SideMenuHeaderTheme *)setSideMenuHeader:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"SideMenuHeader";

    SideMenuHeaderTheme *sideMenuHeader = [NSEntityDescription insertNewObjectForEntityForName:@"SideMenuHeaderTheme" inManagedObjectContext:moc];
    sideMenuHeader.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return sideMenuHeader;
}

- (NSString *)getSideMenuHeader:(NSString *)property {

    NSArray *fetchResults = [self fetchThemeElement:@"SideMenuHeaderTheme"];

    SideMenuHeaderTheme *themeItem = [fetchResults firstObject];

    return [themeItem valueForKey:property];
}

- (SideMenuTableViewTheme *)setSideMenuTableView:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"SideMenuTableView";

    SideMenuTableViewTheme *sideMenuTableView = [NSEntityDescription insertNewObjectForEntityForName:@"SideMenuTableViewTheme" inManagedObjectContext:moc];
    sideMenuTableView.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return sideMenuTableView;
}

- (NSString *)getSideMenuTableView:(NSString *)property {

    NSArray *fetchResults = [self fetchThemeElement:@"SideMenuTableViewTheme"];

    SideMenuTableViewTheme *themeItem = [fetchResults firstObject];

    return [themeItem valueForKey:property];
}


- (SideMenuCellTheme *)setSideMenuCell:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"SideMenuCell";

    SideMenuCellTheme *sideMenuCell = [NSEntityDescription insertNewObjectForEntityForName:@"SideMenuCellTheme" inManagedObjectContext:moc];
    sideMenuCell.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];
    sideMenuCell.fontColor = [self returnThemeElement:themeItem andProperty:kFontColor];
    sideMenuCell.fontFamily = [self returnThemeElement:themeItem andProperty:kFontFamily];

    return sideMenuCell;
}

- (NSString *)getSideMenuCell:(NSString *)property {

    NSArray *fetchResults = [self fetchThemeElement:@"SideMenuCellTheme"];

    SideMenuCellTheme *themeItem = [fetchResults firstObject];

    return [themeItem valueForKey:property];
}

- (SideMenuSectionHeaderTheme *)setSideMenuSectionHeader:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"SideMenuSectionHeader";
    SideMenuSectionHeaderTheme *sideMenuHeader = [NSEntityDescription insertNewObjectForEntityForName:@"SideMenuSectionHeaderTheme" inManagedObjectContext:moc];
    sideMenuHeader.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];
    sideMenuHeader.fontColor =  [self returnThemeElement:themeItem andProperty:kFontColor];
    sideMenuHeader.fontFamily =  [self returnThemeElement:themeItem andProperty:kFontFamily];

    return sideMenuHeader;
}

- (NSString *)getSideMenuSectionHeader:(NSString *)property {

    NSArray *fetchResults = [self fetchThemeElement:@"SideMenuSectionHeaderTheme"];

    SideMenuSectionHeaderTheme *themeItem = [fetchResults firstObject];

    return [themeItem valueForKey:property];
}

// HELPER

- (NSString *)returnThemeElement:(NSString *)themeElement andProperty:(NSString *)property {

    return self.themeElements[themeElement][property];
}


// Theme Fetch - Core Data

// ======== Project Variabels ====

- (NSArray *)fetchThemeElement:(NSString *)elementName {

    NSFetchRequest *themeFetch = [[NSFetchRequest alloc] initWithEntityName:elementName];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:themeFetch error:nil];

    return results;
}

- (NSString *)fetchThemeElement:(NSString *)elementName withProperty:(NSString *)property {

    NSFetchRequest *themeFetch = [[NSFetchRequest alloc] initWithEntityName:elementName];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:themeFetch error:nil];

    return [results firstObject][property];
}


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
