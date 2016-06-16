//
//  SLSettingViewController.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLSettingViewController.h"
#import "SLAboutViewController.h"
#import "SLSettingDetailViewController.h"

@interface SLSettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSArray *optionSelections;
@property (nonatomic, strong) NSArray *optionsNotes;

@end

@implementation SLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(clickDone)];
    
    self.navigationItem.title = @"Setting";
    _options = @[@"Game Type", @"Board Size", @"Theme"];
    
    _optionSelections = @[@[@"Powers of 2", @"Powers of 3", @"Fibonacci"],
                          @[@"3 x 3", @"4 x 4", @"5 x 5"],
                          @[@"Default", @"Vibrant", @"Joyful"]];
    
    _optionsNotes = @[@"For Fibonacci games, a tile can be joined with a tile that is one level above or below it, but not to one equal to it. For Powers of 3, you need 3 consecutive tiles to be the same to trigger a merge!",
                      @"The smaller the board is, the harder! For 5 x 5 board, two tiles will be added every round if you are playing Powers of 2.",
                      @"Choose your favorite appearance and get your own feeling of 2048! More (and higher quality) themes are in the works so check back regularly!"];
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)clickDone {
    [self dismissViewControllerAnimated:YES completion:nil];
    self.clickBlock();
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section ? 1 : _options.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *resuseID = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:resuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: resuseID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    if (indexPath.section) {
        cell.textLabel.text = @"About 2048";
        cell.detailTextLabel.text = @"";
        
    } else {
        cell.textLabel.text = [_options objectAtIndex:indexPath.row];
        
        NSInteger index = [Settings integerForKey:[_options objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = [[_optionSelections objectAtIndex:indexPath.row] objectAtIndex:index];
        cell.detailTextLabel.textColor = [SLSTATE scoreBoardColor];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section) return @"";
    return @"Please note: Changing the settings above would restart the game.";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        SLAboutViewController *vc = [[SLAboutViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SLSettingDetailViewController *vc = [[SLSettingDetailViewController alloc] init];
        NSInteger index = [_tableView indexPathForSelectedRow].row;
        vc.title = [_options objectAtIndex:index];
        vc.options = [_optionSelections objectAtIndex:index];
        vc.footer = [_optionsNotes objectAtIndex:index];
        __weak typeof(self) weakself = self;
        vc.clickBlock = ^{
            [weakself.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
