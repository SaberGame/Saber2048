//
//  SLSettingDetailViewController.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLSettingDetailViewController.h"

@interface SLSettingDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SLSettingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.navigationController.navigationBar.tintColor = [SLSTATE scoreBoardColor];
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return self.footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resuseID = @"SettingDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: resuseID];
    }
    
    cell.textLabel.text = [self.options objectAtIndex:indexPath.row];
    cell.accessoryType = ([Settings integerForKey:self.title] == indexPath.row) ?
    UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.tintColor = [SLSTATE scoreBoardColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [Settings setInteger:indexPath.row forKey:self.title];
    [self.tableView reloadData];
    SLSTATE.needRefresh = YES;
    self.clickBlock();
}

@end
