//
//  BASocialSignInViewController.m
//  DailyDoll
//
//  Created by Richmond on 3/8/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "BASocialShareViewController.h"
#import "OAuthSignInView.h"
#import <TwitterKit/TwitterKit.h>
#import "OAuthWebView.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ExternalWebModalViewController.h"

@interface BASocialShareViewController () <SocialProtocol, SocialPopUp, GPPSignInDelegate, UIWebViewDelegate>

@end

@implementation BASocialShareViewController



- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)instantiateOAuthLoginView:(int)socialType {

    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

    switch (socialType) {
        case TWIITER:

            self.signInView = [[OAuthSignInView alloc] initWithSubview:[self returnTwitterLoginButton] andParentFrame:mainWindow.frame];

            [self.signInView animateOntoScreen:mainWindow.frame];

            break;

        case INSTAGRAM: {
            OAuthWebView *oAuthWV = [[OAuthWebView alloc] initForInstagram:mainWindow.frame];

            oAuthWV.delegate = self;

            [oAuthWV loadRequest:[NSURLRequest requestWithURL:oAuthWV.urlToLoad]];

            self.signInView = [[OAuthSignInView alloc] initWithSubview:oAuthWV andParentFrame:mainWindow.frame];

            [self.socialPopUp animateOffScreen];

            [self.signInView animateOntoScreen:mainWindow.frame];
        }
            break;

        case GOOGLEPLUS: {

            GPPSignIn *signIn = [GPPSignIn sharedInstance];
            signIn.shouldFetchGooglePlusUser = YES;
            //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email

            // You previously set kClientId in the "Initialize the Google+ client" step
            signIn.clientID = [[ProjectSettings sharedManager] fetchSocialItem:GOOGLEPLUS withProperty:kSocialClientId];;

            // Uncomment one of these two statements for the scope you chose in the previous step
            signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
            //signIn.scopes = @[ @"profile" ];            // "profile" scope

            // Optional: declare signIn.actions, see "app activities"
            signIn.delegate = self;

            [signIn trySilentAuthentication];

            if (![[GPPSignIn sharedInstance] authentication]) {

                self.signInView = [[OAuthSignInView alloc] initWithSubview:[self returnGooglePlusLoginButton] andParentFrame:mainWindow.frame];

                [self.signInView animateOntoScreen:mainWindow.frame];

            }

        }

            break;

        default:
            break;

    }


    [mainWindow addSubview:self.signInView];

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

                [self.signInView animateOffScreen];

            }];
        }
        return NO;
    }

    return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {

    [super webViewDidFinishLoad:webView];
    NSLog(@"%@", [webView.request.URL absoluteString]);
    if ([webView isKindOfClass:[OAuthWebView class]]) {
        [((OAuthWebView *) webView).activityIndicator stopAnimating];
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
    } else {
        NSLog(@"Succes");

        [self removeViewsFromWindow];
    }
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


- (GPPSignInButton *)returnGooglePlusLoginButton {

    GPPSignInButton *googlePlusButton = [[GPPSignInButton alloc] init];

    [googlePlusButton addTarget:self action:@selector(removeViewsFromWindow)
               forControlEvents:UIControlEventTouchUpInside];

    return googlePlusButton;
}


- (void)displaySocialPoUp {

    UIWindow* mainWindow = [[UIApplication sharedApplication] keyWindow];

    [mainWindow addSubview: self.socialPopUp];

    self.socialPopUp.delegate = self;

    [self.socialPopUp animateOnToScreen];

    [self.socialPopUp.subviews[0] setCenter:CGPointMake(mainWindow.frame.size.width / 2, mainWindow.frame.size.height / 2)];
}

-(void)socialWebView:(NSURL *)facebookURL {

    [self.socialPopUp animateOffScreen];

    ExternalWebModalViewController *externalVC = [[ExternalWebModalViewController alloc] initWithRequest:[NSURLRequest requestWithURL:facebookURL]];

    [self presentViewController:externalVC animated:YES completion:nil];
}



@end
