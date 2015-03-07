//
//  NotificationViewController.m
//  DailyDoll
//
//  Created by Richmond on 3/5/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationTableView.h"
#import "DetailNavigationBar.h"
#import "NotificationTableViewCell.h"
#import "NotificationWebView.h"
#import "UIView+Additions.h"

@interface NotificationViewController () <UITableViewDataSource, UITableViewDelegate>

@property NotificationTableView *tableView;
@property NSArray *dataSource;
@property CGRect viewFrame;
@property UINavigationController *navController;
@property CGFloat parentViewWidth;
@property UIView *containerView;
@end

@implementation NotificationViewController

- (instancetype)initWithStyleAndFrame:(CGRect)frame andParentWidth:(CGFloat)width {

    if (self=[super init]) {

        self.viewFrame = frame;
        self.parentViewWidth = width;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.width = self.parentViewWidth;

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];

    self.containerView = [[UIView alloc] initWithFrame:self.viewFrame];

    [self.view addSubview:self.containerView];

    self.tableView = [[NotificationTableView alloc] initWithStyleAndFrame:CGRectMake(0, 0, self.containerView.width, self.containerView.height)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.containerView addSubview:self.tableView];

    self.dataSource = [[ProjectSettings sharedManager] fetchNotifications];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self dismissVC];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) {
        cell = [[NotificationTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault
                                            reuseIdentifier: @"cell"];
    }


    [cell configureCell:self.dataSource[indexPath.row]];

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];

    NotificationWebView *notifWebView = [[NotificationWebView alloc] initWithCellRect:rectOfCellInSuperview andParentFrame:self.viewFrame andContent:self.dataSource[indexPath.row]];

    [self.view addSubview:notifWebView];

    [notifWebView animateOpen:self.view.frame withNotification:self.dataSource[indexPath.row]];
}

- (void)dismissVC {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
