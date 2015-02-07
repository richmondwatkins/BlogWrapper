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

@interface ShareViewController () <UITableViewDataSource, UITableViewDelegate>

@property ShareTableView *tableView;
@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ShareView *shareView = [[ShareView alloc] initWithStyleAndFrame:CGRectMake(0, 0, [self returnWidthForShareVC], self.view.frame.size.height)];

    self.view = shareView;

    self.tableView = [[ShareTableView alloc] initWithStyleAndFrame:self.view.frame];

    [self.view addSubview:self.tableView];
}


#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tableView.customDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareCell"];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shareCell"];
    }

    return cell;
}



- (int)returnWidthForShareVC {

    return [[UIScreen mainScreen] bounds].size.width * 0.15;
}

@end
