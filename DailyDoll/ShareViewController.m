 //
//  ShareViewController.m
//  DailyDoll
//
//  Created by Richmond on 2/7/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "ShareViewController.h"
#import "ShareView.h"
#import "ShareTableView.h"
#import "ShareTableViewCell.h"
#import "ProjectSettings.h"
#import "SocialSharingActionController.h"
#import "SocialSharePopoverView.h"
#import "ExternalWebModalViewController.h"
#import "OAuthSignInView.h"
#import <TwitterKit/TwitterKit.h>
#import "OAuthWebView.h"

@import Social;

@interface ShareViewController () <UITableViewDataSource, UITableViewDelegate, SocialProtocol, SocialPopUp, UIWebViewDelegate>

@property ShareTableView *tableView;
@property NSArray *dataSource;
@property SocialSharingActionController *actionController;
@property SocialSharePopoverView *socialPopUp;
@property OAuthSignInView *signInView;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ShareView *shareView = [[ShareView alloc] initWithStyleAndFrame:CGRectMake(0, 20, [self returnWidthForShareVC], self.view.frame.size.height)];

    self.tableView = [[ShareTableView alloc] initWithStyleAndFrame:shareView.frame];

    [shareView addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.view = shareView;

    self.dataSource = [[ProjectSettings sharedManager] shareItems];

    [self.tableView reloadData];
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareCell"];

    if (!cell) {
        cell = [[ShareTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareCell"];
    }

    [cell addShareButtonAndAdjustFrame:self.view.frame
                        withCellObject:self.dataSource[indexPath.row]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

    if (!self.actionController) {
        self.actionController = [[SocialSharingActionController alloc] init];
    }

    self.actionController.delegate = self;

    switch ([[self.dataSource[indexPath.row] valueForKey:@"id" ] intValue]) {
        case 0:

           self.socialPopUp = [self.actionController facebookPopConfig:mainWindow.frame];
            break;
        case 1:

            self.socialPopUp = [self.actionController pintrestPopConfig:mainWindow.frame];
            break;
        case 2:

            self.socialPopUp = [self.actionController twitterPopConfig:mainWindow.frame];
            break;
        case 3:
            
            self.socialPopUp = [self.actionController instagramPopConfig:mainWindow.frame];
            break;
        case 4:
//            [SocialSharingActionController handleGooglePlusShare];
            break;

        default:
            break;
    }

    [self displaySocialPoUp];

}

- (int)returnWidthForShareVC {

    return [[UIScreen mainScreen] bounds].size.width * 0.15;
}

- (void)facebookShareInternal:(NSString *)shareContent{
    
    [self.socialPopUp animateOffScreen];

    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        //TODO add text and images
        [controller setInitialText:shareContent];
        [self presentViewController:controller animated:YES completion:Nil];
    }
}

- (void)facebookShareExternal:(FBLinkShareParams *)shareContent {

    [FBDialogs presentShareDialogWithLink:shareContent.link
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          // An error occurred, we need to handle the error
                                          // See: https://developers.facebook.com/docs/ios/errors
                                          NSLog(@"Error publishing story: %@", error.description);
                                      } else {
                                          // Success
                                          NSLog(@"result %@", results);
                                      }
                                  }];
}

-(void)socialWebView:(NSURL *)facebookURL {

    [self.socialPopUp animateOffScreen];

    ExternalWebModalViewController *externalVC = [[ExternalWebModalViewController alloc] initWithRequest:[NSURLRequest requestWithURL:facebookURL]];

    [self presentViewController:externalVC animated:YES completion:nil];
}

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {

    if (self.view.frame.size.height > self.view.frame.size.width) {
        //view is in portrait about to transtion to landscape
        if (self.socialPopUp) {
            [self.socialPopUp animateOffScreen];
        }
    }
}

- (void)instantiateOAuthLoginView:(int)socialType {

    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

    switch (socialType) {
        case TWIITER:
            //TODO make call back for animation to ensure it is complete before performin anything else
//            [self.socialPopUp animateOffScreen];

            self.signInView = [[OAuthSignInView alloc] initWithSubview:[self returnTwitterLoginButton] andParentFrame:mainWindow.frame];

            [self.signInView animateOntoScreen:mainWindow.frame];

            break;

        case INSTAGRAM: {
            OAuthWebView *oAuthWV = [[OAuthWebView alloc] initForInstagram:mainWindow.frame];

            oAuthWV.delegate = self;

            [oAuthWV loadRequest:[NSURLRequest requestWithURL:oAuthWV.urlToLoad]];

            self.signInView = [[OAuthSignInView alloc] initWithSubview:oAuthWV andParentFrame:mainWindow.frame];

            [self.socialPopUp removeChildView];

            [self.signInView animateOntoScreen:mainWindow.frame];
        }


            break;

        default:
            break;

    }


    [mainWindow addSubview:self.signInView];

}

- (TWTRLogInButton *)returnTwitterLoginButton {

    TWTRLogInButton* logInButton =  [TWTRLogInButton
                                     buttonWithLogInCompletion:
                                     ^(TWTRSession* session, NSError* error) {
                                         if (session) {
                                             NSLog(@"signed in as %@", session);

                                            [[ProjectSettings sharedManager] saveSocialInteraction:TWIITER withStatus:YES];

                                             UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

                                             self.socialPopUp = [self.actionController twitterPopConfig:mainWindow.frame];

                                             [self displaySocialPoUp];

                                         } else {
                                             NSLog(@"error: %@", [error localizedDescription]);
                                         }
                                     }];

    [logInButton addTarget:self action:@selector(removeViewsFromWindow)
          forControlEvents:UIControlEventTouchUpInside];

    return logInButton;
}


- (void)displaySocialPoUp {

    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

    [mainWindow addSubview: self.socialPopUp];

    self.socialPopUp.delegate = self;

    [self.socialPopUp animateOnToScreen];

    [self.socialPopUp.subviews[0] setCenter:CGPointMake(mainWindow.frame.size.width / 2, mainWindow.frame.size.height / 2)];
}

- (void)removeViewsFromWindow {

    [self.socialPopUp animateOffScreen];

    [self.signInView animateOffScreen];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    NSString *URLString = [request.URL absoluteString];
    if ([URLString hasPrefix:@"scheme"]) {

        NSString *delimiter = @"access_token=";

        NSArray *components = [URLString componentsSeparatedByString:delimiter];

        if (components.count > 1) {

            NSString *accessToken = [components lastObject];

            NSLog(@"ACCESS TOKEN = %@",accessToken);

            NSString *urlString=[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/relationship?access_token=%@",@"486292136",accessToken];

            NSURL* url = [NSURL URLWithString:urlString];

            NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:1000.0];

            NSString *parameters;

            BOOL isFollowing = [[ProjectSettings sharedManager] hasInteractedWithSocialItem:INSTAGRAM];

            if (isFollowing) {
                parameters=@"action=unfollow";
            }else {
                parameters=@"action=follow";
            }

            [[ProjectSettings sharedManager] saveSocialInteraction:INSTAGRAM withStatus:!isFollowing];

            [theRequest setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];

            [theRequest setHTTPMethod:@"POST"];

            [NSURLConnection sendAsynchronousRequest:theRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

                UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

                self.socialPopUp = [self.actionController instagramPopConfig:mainWindow.frame];

                [self displaySocialPoUp];

            }];
        }
        return NO;
    }
    
    return YES;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView {

    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById('id_username').select();"];
}


@end
