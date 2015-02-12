//
//  ThemeManager.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ProjectSettings.h"

#import "ThemeContainer.h"
#import "ThemeItem.h"

#import "ProjectVariable.h"
#import "SocialContainer.h"
#import "MetaData.h"
#import "Button.h"
#import "ProjectVariable.h"
#import "SocialContainer.h"
#import "SocialItem.h"

#import "AppDelegate.h"

@interface ProjectSettings ()

@property NSArray *themeElementsPlist;

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
                                                                               pathForResource:@"Themer"
                                                                               ofType:@"plist"]];
        self.themeElementsPlist = [themeDict objectForKey:@"ThemeItems"];

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


    ThemeContainer *themeContainer = [NSEntityDescription insertNewObjectForEntityForName:@"ThemeContainer" inManagedObjectContext:moc];

    [themeContainer setThemeItem:[self returnThemeItemSet:moc]];


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


- (NSSet *)returnThemeItemSet:(NSManagedObjectContext *)moc {

    NSMutableArray *socialItemsArray = [NSMutableArray array];

    for (NSDictionary *socialItemDict in self.themeElementsPlist) {

        ThemeItem *themeItem =[NSEntityDescription insertNewObjectForEntityForName:@"ThemeItem" inManagedObjectContext:moc];

        for (NSString *key in [socialItemDict allKeys]) {

            [themeItem setValue:socialItemDict[key] forKey:key];
        }

        [socialItemsArray addObject:themeItem];
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

- (NSString *)fetchThemeItem:(int)itemId withProperty:(NSString *)property {

    NSFetchRequest *themeFetch = [[NSFetchRequest alloc] initWithEntityName:@"ThemeItem"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [themeFetch setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [NSNumber numberWithInt:itemId]]];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:themeFetch error:nil];

    return [results[0] valueForKey:property];
}


// META DATA //TODO fetch this from core data

- (NSString *)homeVariables:(NSString *)property {

    return self.projectVariables[@"MetaData"][property];
}


- (NSArray *)shareItems {

    NSFetchRequest *themeFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialContainer"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:themeFetch error:nil];

    SocialContainer *socialContainer = results[0];

    return [socialContainer.socialItems  allObjects];
}




@end
