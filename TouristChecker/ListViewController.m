//
//  ListViewController.m
//  TouristChecker
//
//  Created by Wane Wang on 2015/8/21.
//  Copyright (c) 2015年 Wane Wang. All rights reserved.
//

#import "ListViewController.h"
#import "MapDataTableViewCell.h"

@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%zd", self.viewModel.dataArray.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const REUSE_MAP_CELL = @"MAP_DATA_CELL";
    MapDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REUSE_MAP_CELL forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setupCellView:)]) {
        [cell performSelector:@selector(setupCellView:) withObject:[self.viewModel.dataArray objectAtIndex:indexPath.row]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
