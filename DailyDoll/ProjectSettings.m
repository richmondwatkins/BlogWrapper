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
#import "ActivityIndicatorTheme.h"
#import "NavBarTheme.h"
#import "SideMenuTableViewTheme.h"
#import "ShareViewTheme.h"

#import "ProjectVariable.h"
#import "SocialContainer.h"
#import "MetaData.h"
#import "Button.h"
#import "ProjectVariable.h"
#import "SocialContainer.h"
#import "SocialItem.h"

#import "AppDelegate.h"

@interface ProjectSettings ()

@property NSDictionary *themeElementsPlist;
@property NSDictionary *projectVariables;
@property ThemeElement *themeElementsCoreData;

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
        self.themeElementsPlist = [themeDict objectForKey:@"Theme"];

        NSDictionary *projectDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                               pathForResource:@"ProjectVariables"
                                                                               ofType:@"plist"]];

        if (!self.projectVariables) {
            self.projectVariables = [projectDict objectForKey:@"Project"];
        }

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
    themeElement.shareTableView = [self setShareTableView:moc];

    ProjectVariable *projectVariable = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectVariable" inManagedObjectContext:moc];

    projectVariable.socialContainer = [NSEntityDescription insertNewObjectForEntityForName:@"SocialContainer" inManagedObjectContext:moc];

    [projectVariable.socialContainer  setSocialItems:[self returnSocialItemSet:moc]];

    projectVariable.metaData = [self setMetaData:moc];

    [moc save:nil];


    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setBool:YES forKey:kFirstStartUp];
    
    [userDefaults synchronize];

    completion(YES);

    self.themeElementsPlist = nil;
}

- (MetaData *)setMetaData:(NSManagedObjectContext *)moc {

    MetaData *metaData = [NSEntityDescription insertNewObjectForEntityForName:@"MetaData" inManagedObjectContext:moc];
    metaData.domain = self.projectVariables[@"MetaData"][@"DomainString"];
    metaData.name = self.projectVariables[@"MetaData"][@"Name"];
    metaData.urlString = self.projectVariables[@"MetaData"][kURLString];

    return metaData;
}

- (NSSet *)returnSocialItemSet:(NSManagedObjectContext *)moc {

    NSMutableArray *socialItemsArray = [NSMutableArray array];

    for (NSDictionary *socialItemDict in self.projectVariables[@"Social"]) {

        SocialItem *socialItem =[NSEntityDescription insertNewObjectForEntityForName:@"SocialItem" inManagedObjectContext:moc];
    
        for (NSString *key in [socialItemDict allKeys]) {

            if ([key isEqualToString:kButtons]) {

                [socialItem setButtons:[self createButtons:socialItemDict[key] withManagedObject:moc]];
            }else {
                
                [socialItem setValue:socialItemDict[key] forKey:key];
            }
        }

        [socialItemsArray addObject:socialItem];
    }

    return [NSSet setWithArray:socialItemsArray];
}

//TODO setup primary and secondary colors
//TODO add option for email news letter sign up

- (NSSet *)createButtons:(NSArray *)buttons withManagedObject:(NSManagedObjectContext *)moc {

    NSMutableArray *buttonMutableArray = [NSMutableArray array];

    for (NSDictionary *buttonDict in buttons) {

        Button *buttonCD = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
        buttonCD.id = buttonDict[@"Id"];
        buttonCD.title = buttonDict[@"Title"];

        [buttonMutableArray addObject:buttonCD];
    }

    return [NSSet setWithArray:buttonMutableArray];
}

- (NSString *)fetchSocialItem:(int)itemId withProperty:(NSString *)property {

    NSFetchRequest *socialFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialItem"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [socialFetch setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [NSNumber numberWithInt:itemId]]];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:socialFetch error:nil];

    return [results[0] valueForKey:property];
}

- (NSArray *)fetchSocialButtonsForItem:(int)itemId {

    NSFetchRequest *buttonFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialItem"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [buttonFetch setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [NSNumber numberWithInt:itemId]]];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:buttonFetch error:nil];

    NSMutableArray *buttonsArray = [[[results[0] valueForKey:kButtons] allObjects] mutableCopy];

    NSSortDescriptor *sortButtons = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];

    [buttonsArray sortUsingDescriptors:@[sortButtons]];

    return [NSArray arrayWithArray:buttonsArray];
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

- (ShareTableViewTheme *)setShareTableView:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"ShareView";
    ShareTableViewTheme *shareTableView = [NSEntityDescription insertNewObjectForEntityForName:@"ShareTableViewTheme" inManagedObjectContext:moc];
    shareTableView.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return shareTableView;
}

- (ActivityIndicatorTheme *)setActivityIndicator:(NSManagedObjectContext *)moc {

    NSString *themeItem = @"ActivityIndicator";
    ActivityIndicatorTheme *activityIndicator = [NSEntityDescription insertNewObjectForEntityForName:@"ActivityIndicatorTheme" inManagedObjectContext:moc];
    activityIndicator.backgroundColor = [self returnThemeElement:themeItem andProperty:kBackgroundColor];

    return activityIndicator;
}

// HELPERS

- (NSString *)fetchThemeElement:(NSString *)elementName withProperty:(NSString *)property {

    if (self.themeElementsCoreData == nil) {
        NSFetchRequest *themeFetch = [[NSFetchRequest alloc] initWithEntityName:@"ThemeElement"];

        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
n         NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:themeFetch error:nil];

        self.themeElementsCoreData = [results firstObject];

    }

    return [[self.themeElementsCoreData valueForKey:elementName] valueForKey:property];
}

- (NSString *)returnThemeElement:(NSString *)themeElement andProperty:(NSString *)property {

    return self.themeElementsPlist[themeElement][property];
}


- (void)setThemeItemsToNil {

    self.themeElementsCoreData = nil;
}


// Theme Fetch - Core Data

// ======== Project Variabels ====


- (NSString *)homeVariables:(NSString *)property {

    return self.projectVariables[@"MetaData"][property];
}


// ======== Share View ====


- (NSArray *)shareItems {

    NSFetchRequest *themeFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialContainer"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:themeFetch error:nil];

    SocialContainer *socialContainer = results[0];

    return [socialContainer.socialItems  allObjects];
}




@end
