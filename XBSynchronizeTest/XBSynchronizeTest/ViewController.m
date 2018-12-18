//
//  ViewController.m
//  XBSynchronizeTest
//
//  Created by xxb on 2017/11/7.
//  Copyright © 2017年 xxb. All rights reserved.
//

#import "ViewController.h"
static NSString *cellReuseID = @"cellReuseID";

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tbv_content;
@property (nonatomic,strong) NSArray *arr_dataSource;
@end

@implementation ViewController

//dispatch_source_t _timers;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tbv_content = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.tbv_content];
    self.tbv_content.delegate = self;
    self.tbv_content.dataSource = self;
    [self.tbv_content registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseID];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
    cell.textLabel.text = self.arr_dataSource[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [self.navigationController pushViewController:[NSClassFromString(@"QueueAndSyncTestViewController") new] animated:YES];
    }
    if (indexPath.row == 1)
    {
        [self.navigationController pushViewController:[NSClassFromString(@"ThreadSynchronizeTestViewController") new] animated:YES];
    }
}

- (NSArray *)arr_dataSource
{
    if (_arr_dataSource == nil)
    {
        _arr_dataSource = @[@"同步、异步、串行、并行之间组合测试",
                            @"线程同步技术测试 - 1"];
    }
    return _arr_dataSource;
}

@end

