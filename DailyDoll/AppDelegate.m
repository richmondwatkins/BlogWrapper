//
//  AppDelegate.m
//  DailyDoll
//
//  Created by Richmond on 2/1/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "AppDelegate.h"
#import "SideMenuViewController.h"
#import "CenterViewController.h"
#import "ShareViewController.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "ProjectSettings.h"
#import <SSKeychain.h>
#import <GooglePlus/GooglePlus.h>
#import "SNS.h"
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (![[NSUserDefaults standardUserDefaults] boolForKey:kSeedApp]) {
        ProjectSettings *projectSettings = [[ProjectSettings sharedManager] initFromPlist];
        [projectSettings populateCoreData:self.managedObjectContext withCompletion:^(BOOL completion) {
            if (completion) {
                [self setUpDrawerController];

                [self checkForTwitter];

                [self setUpGooglePlus];
            }
        }];
    } else {
    
        [[ProjectSettings sharedManager] requestAppData:self.managedObjectContext];

        [self checkForTwitter];

        [self setUpDrawerController];

        [self setUpGooglePlus];
    }


    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];

    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    AWSStaticCredentialsProvider *credentialsProvider = [AWSStaticCredentialsProvider credentialsWithAccessKey:@"AKIAIWP6JCHRY25UQ2DA" secretKey:@"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"];

    AWSServiceConfiguration *defaultServiceConfiguration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSWest2
                                                                                        credentialsProvider:credentialsProvider];

    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = defaultServiceConfiguration;

#if DEBUG
    [[ProjectSettings sharedManager] setNotification:@{@"aps":@{@"alert":@"This is a test push notif"}} withManagedObjectContext:self.managedObjectContext];
#endif
    
    int cacheSizeMemory = 4*1024*1024; // 4MB
    int cacheSizeDisk = 32*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];

    return YES;
}

- (void) checkForTwitter {

    BOOL hasTwitter = [[ProjectSettings sharedManager] siteHasSocialAccount:TWIITER withMoc:self.managedObjectContext];

    if (hasTwitter) {
         [Fabric with:@[TwitterKit]];
    }
}


- (void) setUpGooglePlus {

    BOOL hasGooglePlus = [[ProjectSettings sharedManager] siteHasSocialAccount:GOOGLEPLUS withMoc:self.managedObjectContext];

    if (hasGooglePlus) {

        [GPPSignIn sharedInstance].clientID = [[ProjectSettings sharedManager] fetchSocialItem:GOOGLEPLUS withProperty:kSocialClientId];
        
        [GPPDeepLink setDelegate:self];

        [GPPDeepLink readDeepLinkAfterInstall];
    }

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    NSString *deviceTokenString = [self deviceTokenFromData:deviceToken];

    NSLog(@"deviceTokenString: %@", deviceTokenString);
    [[NSUserDefaults standardUserDefaults] setObject:deviceTokenString forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    AWSSNS *sns = [AWSSNS defaultSNS];
    AWSSNSCreatePlatformEndpointInput *request = [AWSSNSCreatePlatformEndpointInput new];
    request.token = deviceTokenString;
    request.platformApplicationArn = @"arn:aws:sns:us-west-2:093375523987:app/APNS_SANDBOX/DailyDoll";
    [[sns createPlatformEndpoint:request] continueWithBlock:^id(BFTask *task) {
        if (task.error != nil) {
            NSLog(@"Error: %@",task.error);
        } else {
            NSLog(@"Success");
        }

        return nil;
    }];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    [[ProjectSettings sharedManager] setNotification:userInfo withManagedObjectContext:self.managedObjectContext];
}


- (NSString *)deviceTokenFromData:(NSData *)tokenData
{
    NSString *token = [tokenData description];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    return token;
}

- (void) setUpDrawerController {

    BOOL hasSocialAccounts = [[ProjectSettings sharedManager] projectHasSocialAccounts];

    SideMenuViewController * leftDrawer = [[SideMenuViewController alloc] init];
    CenterViewController *mainVC = [[CenterViewController alloc] init];
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];

    if (hasSocialAccounts) {
         ShareViewController *rightDrawer = [[ShareViewController alloc] init];

        self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:navigationController leftDrawerViewController:leftDrawer rightDrawerViewController:rightDrawer];

        [mainVC setRightNavigationItem];

         self.drawerController.maximumRightDrawerWidth = [rightDrawer returnWidthForShareVC];
    }else {

        self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:navigationController leftDrawerViewController:leftDrawer];
    }


    self.drawerController.maximumLeftDrawerWidth = [leftDrawer returnWidthForMenuViewController];

     self.drawerController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    self.drawerController.shouldStretchDrawer = NO;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.drawerController];
}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com-greekconnect.RedditDigest" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    // Create the coordinator and store

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RedditDigest.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
