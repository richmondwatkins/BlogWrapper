//
//  SocialStreamViewController.m
//  DailyDoll
//
//  Created by Richmond Watkins on 5/31/15.
//  Copyright (c) 2015 Richmond. All rights reserved.
//

#import "SocialStreamViewController.h"
#import "APIManager.h"
#import "SocialStreamViewModel.h"
@interface SocialStreamViewController () <SocialStreamProtocol, UITableViewDataSource, UITableViewDelegate>

@property SocialStreamViewModel *viewModel;
@property UITableView *tableView;

@end

@implementation SocialStreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.viewModel = [[SocialStreamViewModel alloc] init];
    self.viewModel.delegate = self;
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SocialCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.frame;
}

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.socialItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    NSDictionary *socialItem = self.viewModel.socialItems[indexPath.row];
    
    if (socialItem[@"isFacebook"]) {
        cell.textLabel.text = socialItem[@"message"];
    }
    
    return cell;
}

@end
