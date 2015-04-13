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
#import "NotificationView.h"
#import "NSDate+Helper.h"

#define kArrowHeight 20

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

    self.view.backgroundColor = [UIColor clearColor];

    self.containerView = [[NotificationView alloc] initWithFrame:self.viewFrame andCaretHeight:kArrowHeight];
    self.containerView.layer.shadowOpacity = 0.9;
    self.containerView.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);

    self.containerView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.containerView];

    self.dataSource = [[ProjectSettings sharedManager] fetchNotifications];
    
    self.tableView = [[NotificationTableView alloc] initWithStyleAndFrame:CGRectMake(0, kArrowHeight, self.containerView.width, self.containerView.height-kArrowHeight)];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.containerView addSubview:self.tableView];
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


    [self configureCell:cell withIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(NotificationTableViewCell *)notifCell withIndexPath:(NSIndexPath *)indexPath {
    
    Notification *notification = self.dataSource[indexPath.row];
    
    if (! notification.isViewed) {
        notifCell.backgroundColor = [UIColor colorWithHexString:@"edeff5"];
    } else {
        notifCell.backgroundColor = [UIColor whiteColor];
    }
    
    notifCell.height = kNotificationCellSize;
    
    notifCell.notificationTextLabel.text = notification.text;
    [notifCell.notificationTextLabel sizeToFit];
    notifCell.dateLabel.text = [NSDate stringForDisplayFromDate:notification.receivedDate];
    [notifCell.dateLabel sizeToFit];
    notifCell.dateLabel.font = [UIFont systemFontOfSize:10];
    notifCell.dateLabel.top = notifCell.notificationTextLabel.bottom + 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    CGRect rectOfCellInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect rectOfCellInSuperview = [tableView convertRect:rectOfCellInTableView toView:[tableView superview]];

    NotificationWebView *notifWebView = [[NotificationWebView alloc] initWithCellRect:rectOfCellInSuperview andParentFrame:self.viewFrame andContent:self.dataSource[indexPath.row]];
    
    Notification *notification = self.dataSource[indexPath.row];
    notification.isViewed = [NSNumber numberWithBool:YES];
    
    [[ProjectSettings sharedManager] setNotificationAsViewed:notification];
    [self.view addSubview:notifWebView];

    NotificationTableViewCell *cell = (NotificationTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureCell:cell withIndexPath:indexPath];
    
    [notifWebView animateOpen:self.view.frame withNotification:self.dataSource[indexPath.row]];
}

- (void)dismissVC {
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
