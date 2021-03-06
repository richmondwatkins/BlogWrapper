//
//  ThemeManager.m
//  DailyDoll
//
//  Created by Richmond on 2/6/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "APIManager.h"

#import "ThemeContainer.h"
#import "ThemeItem.h"

#import "ProjectVariable.h"
#import "SocialContainer.h"
#import "MetaData.h"
#import "Button.h"
#import "ProjectVariable.h"
#import "AccessoryPage.h"
#import "SocialContainer.h"
#import "SocialItem.h"

#import "MenuContainer.h"
#import "MenuItem.h"
#import "NSDate+Additions.h"

#import "AppDelegate.h"

@interface APIManager ()

@property NSArray *themeElementsPlist;

@property NSDictionary *primaryThemeElements;

@property NSDictionary *projectVariables;

@property NSArray *menuItems;

@end

@implementation APIManager

static APIManager *sharedThemeManager = nil;

+ (APIManager *)sharedManager {
    @synchronized([APIManager class]){
        if (sharedThemeManager == nil) {
            sharedThemeManager = [[self alloc] init];
        }

        return sharedThemeManager;
    }
    return nil;
}

+(id)alloc {
    @synchronized([APIManager class])
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

        self.primaryThemeElements = [themeDict objectForKey:@"Meta"];

        NSDictionary *projectDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                               pathForResource:@"ProjectVariables"
                                                                               ofType:@"plist"]];
        self.projectVariables = [projectDict objectForKey:@"Project"];


        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                                               pathForResource:@"MenuItemList"
                                                                               ofType:@"plist"]];
        self.menuItems = [dictionary objectForKey:@"Menu"];

        
        [self addImagesToFileSystem];
    }

    return self;
}

- (void)requestAppData:(NSManagedObjectContext *)moc {
    
    NSURL *url = [NSURL URLWithString:@"http://52.26.104.60/apps/1"];
//    NSURL *url = [NSURL URLWithString:@"http://appify.dev/apps/1"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXUyJ9.eyJzdWIiOjEsImlzcyI6Imh0dHA6XC9cL2FwcGlmeS5kZXZcL3Rlc3RlciIsImlhdCI6IjE0MzQ0MjMxODkiLCJleHAiOiIxNDM0NDI2Nzg5IiwibmJmIjoiMTQzNDQyMzE4OSIsImp0aSI6Ijk5MDAwMzMwNmMzYjJlYjkxMmFmNmM1MjMxM2E0MmJhIn0.OTI0Mjk4NmM1N2E3ZGEwMDBlODUzMDdhYTAyMDA0NjU0NTExZGE0MjQwMjUzZmEzYTJjYWQ3ZjBlZGZmZWNhOA" forHTTPHeaderField:@"Authorization"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (! connectionError) {
            [self deleteMenuContainer:moc];
            [self deleteProjectContainer:moc];
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            MenuContainer *menuContainer = [NSEntityDescription insertNewObjectForEntityForName:@"MenuContainer" inManagedObjectContext:moc];
            
            [menuContainer setMenuItems:[self createMenuItems:json[@"menu"] withManagedObject:moc]];
            
            ProjectVariable *projectVariable = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectVariable" inManagedObjectContext:moc];
            
            projectVariable.socialContainer = [NSEntityDescription insertNewObjectForEntityForName:@"SocialContainer" inManagedObjectContext:moc];
            
            [projectVariable.socialContainer  setSocialItems:[self returnSocialItemSet:json[@"socialData"] withMoc:moc]];
            
            projectVariable.metaData = [self setMetaData:json[@"metaData"] withMoc:moc];
            
            [moc save:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"coreDataUpdated" object:nil];
        }
    }];
}

- (void)deleteProjectContainer:(NSManagedObjectContext *)moc {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"ProjectVariable"];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count > 0) {
        
        [moc deleteObject:fetchedObjects.firstObject];
    }
}

- (void)deleteMenuContainer:(NSManagedObjectContext *)moc {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MenuContainer"];
  
    NSError *error = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects.count > 0) {
        
        [moc deleteObject:fetchedObjects.firstObject];
    }
}

- (void)addImagesToFileSystem {
    UIImage *logo = [UIImage imageNamed:@"logo"];

    NSData *logoData = UIImagePNGRepresentation(logo);

    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString *path = [docPaths objectAtIndex:0];

    NSString *filePath = [path stringByAppendingPathComponent:@"logo.png"]; //Add the file name

    [logoData writeToFile:filePath atomically:YES]; //Write the file
}

// Theme Set - Core Data

-(void)populateCoreData:(NSManagedObjectContext *)moc withCompletion:(void(^)(BOOL))completion {

    ThemeContainer *themeContainer = [NSEntityDescription insertNewObjectForEntityForName:@"ThemeContainer" inManagedObjectContext:moc];
    themeContainer.fontColor = self.primaryThemeElements[@"fontColor"];
    themeContainer.fontFamily = self.primaryThemeElements[@"fontFamily"];
    themeContainer.primaryColor = self.primaryThemeElements[@"primaryColor"];
    themeContainer.secondaryColor = self.primaryThemeElements[@"secondaryColor"];

    [themeContainer setThemeItem:[self returnThemeItemSet:moc]];


    ProjectVariable *projectVariable = [NSEntityDescription insertNewObjectForEntityForName:@"ProjectVariable" inManagedObjectContext:moc];

    projectVariable.metaData = [self setMetaData:self.projectVariables[kMetaData] withMoc:moc];


    MenuContainer *menuContainer = [NSEntityDescription insertNewObjectForEntityForName:@"MenuContainer" inManagedObjectContext:moc];
    
    [menuContainer setMenuItems:[self createMenuItems:self.menuItems withManagedObject:moc]];
    
    [moc save:nil];


    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    [userDefaults setBool:YES forKey:kSeedApp];
    
    [userDefaults synchronize];

    completion(YES);

    self.projectVariables = nil;
    self.menuItems = nil;
    self.themeElementsPlist = nil;
}

- (MetaData *)setMetaData:(NSDictionary *)data withMoc:(NSManagedObjectContext *)moc {

    MetaData *metaData = [NSEntityDescription insertNewObjectForEntityForName:kMetaData inManagedObjectContext:moc];
    metaData.siteName = data[kSiteName];
    metaData.url = data[kDomainString];
    metaData.siteEmail = data[kSiteEmail];
    metaData.version = data[@"version"];
    metaData.appId = data[@"appId"];
    
    NSURL *siteURL = [NSURL URLWithString:metaData.url];
    
    metaData.domain = siteURL.host;
    
    [metaData addAccessoryPages:[self returnAccesorryPages:moc]];

    return metaData;
}

- (NSSet *)returnAccesorryPages:(NSManagedObjectContext *)moc {

    NSArray *accessoryPages = self.projectVariables[kMetaData][kAccessoryPages];

    NSMutableArray *accessPageMutablearray = [NSMutableArray array];

    for (NSDictionary *accessoryPage in accessoryPages) {

        AccessoryPage *accPage = [NSEntityDescription insertNewObjectForEntityForName:@"AccessoryPage" inManagedObjectContext:moc];

        for (NSString *key in [accessoryPage allKeys]) {

            [accPage setValue:accessoryPage[key] forKey:key];
        }

        [accessPageMutablearray addObject:accPage];
    }

    return [NSSet setWithArray:accessPageMutablearray];

}

- (NSSet *)returnSocialItemSet:(NSArray *)socialItems  withMoc:(NSManagedObjectContext *)moc {

    NSMutableArray *socialItemsArray = [NSMutableArray array];

    for (NSDictionary *socialItemDict in socialItems) {

        SocialItem *socialItem =[NSEntityDescription insertNewObjectForEntityForName:@"SocialItem" inManagedObjectContext:moc];
    
        for (NSString *key in [socialItemDict allKeys]) {
            
            if ([key isEqualToString:@"platformId"]) {
                
                if ([socialItemDict[key] isEqualToString:@"facebook"]) {
                    socialItem.platformId = @(0);
                } else if([socialItemDict[key] isEqualToString:@"pinterest"]) {
                    socialItem.platformId = @(1);
                } else if([socialItemDict[key] isEqualToString:@"twitter"]) {
                    socialItem.platformId = @(2);
                } else if([socialItemDict[key] isEqualToString:@"instagram"]) {
                    socialItem.platformId = @(3);
                } else if([socialItemDict[key] isEqualToString:@"googlePlus"]) {
                    socialItem.platformId = @(4);
                } else if([socialItemDict[key] isEqualToString:@"email"]) {
                    socialItem.platformId = @(5);
                } else if([socialItemDict[key] isEqualToString:@"sms"]) {
                    socialItem.platformId = @(6);
                }
            } else {
                [socialItem setValue:socialItemDict[key] forKey:key];
            }
        }
        
        switch (socialItem.platformId.integerValue) {
                
            case FACEBOOK:
                socialItem.image = @"facebook";
                break;
            case PINTEREST:
                socialItem.image = @"pintrest";
                break;
            case TWIITER:
                socialItem.image = @"twitter";
                break;
            case INSTAGRAM:
                socialItem.image = @"instagram";
                break;
            case GOOGLEPLUS:
                 socialItem.image = @"googlePlus";
                break;
            case EMAIL:
                 socialItem.image = @"mail";
                break;
            case SMS:
                socialItem.image = @"sms";
                break;
            }
        
        [socialItem setButtons:[self createButtons:socialItem.platformId.intValue withManagedObject:moc]];

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

- (NSSet *)returnMenuGroup:(NSArray *)menuItems withMoc:(NSManagedObjectContext *)moc {

    NSMutableArray *menuItemsArray = [NSMutableArray array];

    for (NSDictionary *menuItemsDict in menuItems) {

        MenuContainer *menuGroup = [NSEntityDescription insertNewObjectForEntityForName:@"MenuContainer" inManagedObjectContext:moc];

        for (NSString *key in menuItemsDict.allKeys) {
            
            if (! [key isEqualToString:@"id"]) {
                if ([key isEqualToString:@"children"]) {
                    
                    [menuGroup addMenuItems:[self createMenuItems:menuItemsDict[key] withManagedObject:moc]];
                }else {
                    
                    [menuGroup setValue:menuItemsDict[key] forKey:key];
                }
            }
        }

        [menuItemsArray addObject:menuGroup];
    }
    
    return [NSSet setWithArray:menuItemsArray];
}

//TODO add option for email news letter sign up

- (NSSet *)createButtons:(int)platformId withManagedObject:(NSManagedObjectContext *)moc {
    
    switch (platformId) {
        case FACEBOOK:
            return  [self returnFacebookButtonSet:moc];
            break;
        case PINTEREST:
            return [self returnPinterestButtonSet:moc];
            
        case TWIITER:
            return [self returnTwitterButtonSet:moc];
            break;
            
        case INSTAGRAM:
            return [self returnInstagramButtonSet:moc];
            break;
        case GOOGLEPLUS:
            return [self returnGooglePlusButtonSet:moc];
            break;
        default:
             return [NSSet set];
            break;
    }
}

- (NSSet *)returnFacebookButtonSet:(NSManagedObjectContext * )moc {
    
    Button *buttonLike = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonLike.id = @0;
    buttonLike.title = @"Like";
    
    Button *buttonView = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonView.id = @1;
    buttonView.title = @"View";
    
    Button *buttonShare = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonShare.id = @2;
    buttonShare.title = @"Share";
    
    return  [NSSet setWithObjects:buttonLike, buttonView, buttonShare, nil];
}

- (NSSet *)returnPinterestButtonSet:(NSManagedObjectContext * )moc {
    
    Button *buttonPin = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonPin.id = @0;
    buttonPin.title = @"Pin";
    
    Button *buttonView = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonView.id = @1;
    buttonView.title = @"View Boards";
    
    return  [NSSet setWithObjects:buttonPin, buttonView, nil];
}

- (NSSet *)returnTwitterButtonSet:(NSManagedObjectContext * )moc {
    
    Button *buttonFollow = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonFollow.id = @0;
    buttonFollow.title = @"Follow";
    
    Button *buttonView = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonView.id = @1;
    buttonView.title = @"View";
    
    Button *buttonTweet = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonTweet.id = @2;
    buttonTweet.title = @"Tweet";
    
    return  [NSSet setWithObjects:buttonFollow, buttonView, buttonTweet, nil];
}

- (NSSet *)returnInstagramButtonSet:(NSManagedObjectContext * )moc {

    Button *buttonView = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonView.id = @0;
    buttonView.title = @"View";
    
    return  [NSSet setWithObjects:buttonView, nil];
}

- (NSSet *)returnGooglePlusButtonSet:(NSManagedObjectContext * )moc {
    
    Button *buttonView = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonView.id = @0;
    buttonView.title = @"View";
    
    Button *buttonShare = [NSEntityDescription insertNewObjectForEntityForName:@"Button" inManagedObjectContext:moc];
    buttonShare.id = @1;
    buttonShare.title = @"+1 Share";
    
    return  [NSSet setWithObjects:buttonView, buttonShare, nil];
}

- (NSSet *)createMenuItems:(NSArray *)menuItems withManagedObject:(NSManagedObjectContext *)moc {

    NSMutableArray *menuMutableArray = [NSMutableArray array];

    for (NSDictionary *menuDict in menuItems) {
        
        MenuItem *menuItem = [NSEntityDescription insertNewObjectForEntityForName:@"MenuItem" inManagedObjectContext:moc];
        
        for (NSString *key in menuDict.allKeys) {
            
            if (![key isEqualToString:@"id"]) {
                if ([key isEqualToString:@"children"]) {
                    
                    if (((NSArray *) menuDict[@"children"]).count > 0) {
                        
                        [menuItem addChildren:[self setChildrenMenuItems:menuDict[key] withMoc:moc]];
                    }
                    
                } else {
                    NSLog(@"%@", key);
                    [menuItem setValue:menuDict[key] forKey:key];
                }
            }
        }

        [menuMutableArray addObject:menuItem];
    }

    return [NSSet setWithArray:menuMutableArray];
}

- (NSSet *)setChildrenMenuItems:(NSArray *)children withMoc:(NSManagedObjectContext *)moc {
    
    NSMutableArray *childItemsArr = [NSMutableArray array];
    
    for (NSDictionary *child in children) {
        MenuItem *menuItem = [NSEntityDescription insertNewObjectForEntityForName:@"MenuItem"
                                                           inManagedObjectContext:moc];
        
        for (NSString *key in child.allKeys) {
            
             if (![key isEqualToString:@"id"]) {
                 if ([key isEqualToString:@"children"]) {
                     
                     if (((NSArray *) child[@"children"]).count > 0) {
                         
                         [menuItem addChildren:[self setChildrenMenuItems:child[key] withMoc:moc]];
                     }
                 } else {
                     
                     [menuItem setValue:child[key] forKey:key];
                 }
             }
        }
        
        [moc save:nil];
    
        [childItemsArr addObject:menuItem];
    }
    
    return [NSSet setWithArray:childItemsArr];
}

- (NSString *)fetchSocialItem:(int)itemId withProperty:(NSString *)property {

    NSFetchRequest *socialFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialItem"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [socialFetch setPredicate:[NSPredicate predicateWithFormat:@"platformId == %@", [NSNumber numberWithInt:itemId]]];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:socialFetch error:nil];

    return [results[0] valueForKey:property];
}

- (NSArray *)fetchSocialButtonsForItem:(int)itemId {

    NSFetchRequest *buttonFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialItem"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    [buttonFetch setPredicate:[NSPredicate predicateWithFormat:@"platformId == %@", [NSNumber numberWithInt:itemId]]];

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

- (NSString *)fetchMetaThemeItemWithProperty:(NSString *)property {

    NSFetchRequest *themeFetch = [[NSFetchRequest alloc] initWithEntityName:@"ThemeContainer"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:themeFetch error:nil];

    return [results[0] valueForKey:property];
}

- (NSMutableArray *)fetchMenuItemsAndHeaders {

    NSFetchRequest *menuItemFetch = [[NSFetchRequest alloc] initWithEntityName:@"MenuContainer"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    MenuContainer *menuContainer = [[appDelegate.managedObjectContext executeFetchRequest:menuItemFetch error:nil] firstObject];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];

    NSMutableArray *menuItems = menuContainer.menuItems.allObjects.mutableCopy;
    
    [menuItems sortUsingDescriptors:@[sortDescriptor]];

    for (int i = 0; i < menuItems.count; i++) {
        
        if (((MenuItem *) menuItems[i]).isHeader.boolValue) {
            NSMutableArray *children = ((MenuItem *) menuItems[i]).children.allObjects.mutableCopy;
            
            if (children.count > 0) {
                [children sortUsingDescriptors:@[sortDescriptor]];
                
                 int j = 0;
                for (MenuItem *child in children) {
                    [menuItems insertObject:child atIndex:i + j + 1];
                    j++;
                }
            }
        }
    }
    
    return menuItems;
}

// META DATA

- (NSArray *)fetchMetaDataAccessoryPages {

    NSFetchRequest *metaDataFetch = [[NSFetchRequest alloc] initWithEntityName:@"MetaData"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:metaDataFetch error:nil];

    MetaData *metaData = results[0];

    return [metaData.accessoryPages allObjects];
}

- (NSString *)fetchmetaDataVariables:(NSString *)property {

    NSFetchRequest *metaDataFetch = [[NSFetchRequest alloc] initWithEntityName:@"MetaData"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:metaDataFetch error:nil];

    return [results[0] valueForKey:property];
}


// Fetches share items for share tableview

- (NSArray *)fetchShareItems {

    NSFetchRequest *shareFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialContainer"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:shareFetch error:nil];

    SocialContainer *socialContainer = results[0];

    NSMutableArray *shareItems = [[socialContainer.socialItems allObjects] mutableCopy];

    NSSortDescriptor *shareSort = [[NSSortDescriptor alloc] initWithKey:@"platformId" ascending:YES];

    [shareItems sortUsingDescriptors:@[shareSort]];

    return [NSArray arrayWithArray:shareItems];
}

- (NSArray *)shareItemsWithoutInstagram {

    NSFetchRequest *socialFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialContainer"];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSArray *results = [appDelegate.managedObjectContext executeFetchRequest:socialFetch error:nil];

    SocialContainer *socialContainer = results[0];

    NSMutableArray *shareItems = [[socialContainer.socialItems allObjects] mutableCopy];

    NSSortDescriptor *shareSort = [[NSSortDescriptor alloc] initWithKey:kPlatformId ascending:YES];

    [shareItems sortUsingDescriptors:@[shareSort]];

    [shareItems enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(SocialItem *item, NSUInteger index, BOOL *stop) {
        if (item.platformId.intValue == INSTAGRAM) {
            [shareItems removeObjectAtIndex:index];
        }
    }];

    return [NSArray arrayWithArray:shareItems];
}


- (BOOL)siteHasSocialAccount:(int)socialAccount withMoc:(NSManagedObjectContext *)moc {

    NSFetchRequest *accountCheck = [[NSFetchRequest alloc] initWithEntityName:@"SocialItem"];

    [accountCheck setPredicate:[NSPredicate predicateWithFormat:@"platformId == %@", [NSNumber numberWithInt:socialAccount]]];

    NSInteger hasAccount = [moc countForFetchRequest:accountCheck error:nil];

    if (hasAccount) {
        
        return YES;
    }else {

        return NO;
    }
}

- (BOOL)hasInteractedWithSocialItem:(int)socialId {

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSFetchRequest *socialFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialItem"];

    [socialFetch setPredicate:[NSPredicate predicateWithFormat:@"platformId == %@", [NSNumber numberWithInt:socialId]]];

    NSArray *socialAccountResult = [appDelegate.managedObjectContext executeFetchRequest:socialFetch error:nil];

    SocialItem *socialItem = socialAccountResult[0];

    if ([socialItem.hasInteracted boolValue]) {

        return YES;
    }else {

        return NO;
    }
}

- (void)saveSocialInteraction:(int)socialId withStatus:(BOOL)saveStatus {

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSFetchRequest *socialFetch = [[NSFetchRequest alloc] initWithEntityName:@"SocialItem"];

    [socialFetch setPredicate:[NSPredicate predicateWithFormat:@"platformId == %@", [NSNumber numberWithInt:socialId]]];

    NSArray *socialAccountResult = [appDelegate.managedObjectContext executeFetchRequest:socialFetch error:nil];

    SocialItem *socialItem = socialAccountResult[0];
    socialItem.hasInteracted = [NSNumber numberWithBool:saveStatus];

    [appDelegate.managedObjectContext save:nil];
}

- (UIImage *)fetchLogoImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"logo.png"]; //Add the file name

    NSData *pngData = [NSData dataWithContentsOfFile:filePath];

    return [UIImage imageWithData:pngData];
}

- (BOOL)projectHasSocialAccounts { 

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SocialItem"];

    fetchRequest.resultType = NSCountResultType;

    NSUInteger itemsCount = [appDelegate.managedObjectContext countForFetchRequest:fetchRequest error:nil];

    if (itemsCount > 0) {

        return YES;
    }else {

        return NO;
    }
}

//Push Notifications

- (void)setNotification:(NSDictionary *)notification withManagedObjectContext:(NSManagedObjectContext *)moc {

    [self refreshNotifications:moc];
    
    Notification *newNotification = [NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:moc];

    newNotification.text = notification[@"aps"][@"alert"];
    
    newNotification.receivedDate = [NSDate date];

    [moc save:nil];
}

- (void)refreshNotifications:(NSManagedObjectContext *)moc {
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
    
    [fetch setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"receivedDate" ascending:YES]]];
    
    NSArray *notifications = [moc executeFetchRequest:fetch error:nil];
    
    if (notifications.count >= 14) {
        [moc deleteObject:[notifications lastObject]];
    }
    
    for (Notification *notification in notifications) {
        
        [moc deleteObject:notification];
    }
}

- (NSArray *)fetchNotifications {

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:@"Notification"];

    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"receivedDate" ascending:NO];

    [fetch setPredicate:[NSPredicate predicateWithFormat:@"text != nil"]];

    fetch.sortDescriptors  = @[dateSort];

   return [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
}

- (void)setNotificationAsViewed:(Notification *)notification {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    notification.isViewed = [NSNumber numberWithBool:YES];

    [appDelegate.managedObjectContext save:nil];
}

//Fonts
- (void)listFonts {
    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSUInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
    
}

@end
