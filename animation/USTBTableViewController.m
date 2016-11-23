//
//  USTBTableViewController.m
//  animation
//
//  Created by hanliqiang on 16/11/23.
//  Copyright © 2016年 ustb. All rights reserved.
//

#import "USTBTableViewController.h"
#import "DisViewController.h"
#import "SpringViewController.h"
@interface USTBTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@end

@implementation USTBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableview = [[UITableView alloc] init];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = 44;
    self.tableview.frame = self.view.bounds;
    [self.view addSubview:self.tableview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ustb = @"ustb";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ustb];
    if (cell == nil) {
        cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ustb];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        DisViewController *viewController = [[DisViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        SpringViewController *springViewController = [[SpringViewController alloc] init];
        [self.navigationController pushViewController:springViewController animated:YES];
    }
}

@end
