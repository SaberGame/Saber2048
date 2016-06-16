//
//  SLAboutViewController.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLAboutViewController.h"
#import "Masonry.h"

@interface SLAboutViewController ()

@end

@implementation SLAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"About 2048";
    self.navigationController.navigationBar.tintColor = [SLSTATE scoreBoardColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"This game is based on the popular web-based game 2048, by Gabriele Cirulli. You can find the original game at http://git.io/2048. Please refer to its documentation to see its detail. \n\nAre you a developer? This game is an open source project. If you are interested in SpriteKit, the cool new addition to iOS 7, or in iOS development in general, check out its source code at https://github.com/SaberGame/Saber2048. Any contributions or forks are highly welcome, and I hope you find the source code useful in your own development work! \n\nMade by Long Song";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor darkGrayColor];
    label.numberOfLines = 0;
    label.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 40;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}


@end
