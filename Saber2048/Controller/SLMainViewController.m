//
//  SLMainViewController.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLMainViewController.h"
#import "SLScoreView.h"
#import "Masonry.h"
#import "SLGameScene.h"

@interface SLMainViewController ()

@property (nonatomic, strong) UILabel *targetScoreLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) SLScoreView *currentScoreView;
@property (nonatomic, strong) SLScoreView *bestScoreView;
@property (nonatomic, strong) UIButton *restartButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) SLGameScene *gameScene;

@end

@implementation SLMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self updateState];
}

- (void)setupUI {
    
    SKView * skView = [[SKView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
    _gameScene = [SLGameScene sceneWithSize:skView.bounds.size];
    _gameScene.scaleMode = SKSceneScaleModeAspectFill;
    [_gameScene startNewGame];
    _gameScene.controller = self;
    [skView presentScene:_gameScene];
    self.view = skView;
    
    __weak typeof(self) weakself = self;
    
    _targetScoreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_targetScoreLabel];
    [_targetScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(50);
    }];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width * 0.25;
    
    _currentScoreView = [[SLScoreView alloc] initWithFrame:CGRectZero];
    _currentScoreView.titleLabel.text = @"SCORE";
    [self.view addSubview:_currentScoreView];
    [_currentScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.targetScoreLabel.mas_top);
        make.left.equalTo(weakself.view.mas_centerX).offset(-20);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(width);
    }];
    
    _bestScoreView = [[SLScoreView alloc] initWithFrame:CGRectZero];
    _bestScoreView.titleLabel.text = @"BEST";
    [self.view addSubview:_bestScoreView];
    [_bestScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_targetScoreLabel.mas_top);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(width);
    }];
    
    _restartButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_restartButton setTitle:@"Restart" forState:UIControlStateNormal];
    _restartButton.layer.cornerRadius = SLSTATE.cornerRadius;
    _restartButton.layer.masksToBounds = YES;
    [self.view addSubview:_restartButton];
    [_restartButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(width);
        make.top.equalTo(weakself.bestScoreView.mas_bottom).offset(10);
        make.left.equalTo(weakself.bestScoreView.mas_left);
        make.right.equalTo(weakself.bestScoreView.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    _settingButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [_settingButton setTitle:@"Settings" forState:UIControlStateNormal];
    _settingButton.layer.cornerRadius = SLSTATE.cornerRadius;
    _settingButton.layer.masksToBounds = YES;
    [self.view addSubview:_settingButton];
    [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(width);
        make.top.equalTo(weakself.currentScoreView.mas_bottom).offset(10);
        make.left.equalTo(weakself.currentScoreView.mas_left);
        make.right.equalTo(weakself.currentScoreView.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _subTitleLabel.numberOfLines = 2;
    [self.view addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.settingButton.mas_bottom);
        make.left.mas_equalTo(15);
        make.right.equalTo(weakself.targetScoreLabel.mas_right);
    }];
    
    [self updateScore:0];
}

- (void)updateState {
    [_currentScoreView updateAppearance];
    [_bestScoreView updateAppearance];
    
    _restartButton.backgroundColor = [SLSTATE buttonColor];
    _restartButton.titleLabel.font = [UIFont fontWithName:[SLSTATE boldFontName] size:14];
    
    _settingButton.backgroundColor = [SLSTATE buttonColor];
    _settingButton.titleLabel.font = [UIFont fontWithName:[SLSTATE boldFontName] size:14];
    
    _targetScoreLabel.textColor = [SLSTATE buttonColor];
    _targetScoreLabel.font = [UIFont fontWithName:[SLSTATE boldFontName] size:40];
    _targetScoreLabel.text = @"2048";
    
    _subTitleLabel.textColor = [SLSTATE buttonColor];
    _subTitleLabel.font = [UIFont fontWithName:[SLSTATE regularFontName] size:14];
    _subTitleLabel.text = [NSString stringWithFormat:@"Join the numbers \nto get to %zd!", 2048];
}

- (void)updateScore:(NSInteger)score
{
    _currentScoreView.socreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
    if ([Settings integerForKey:@"Best Score"] < score) {
        [Settings setInteger:score forKey:@"Best Score"];
        _bestScoreView.socreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
    }
}

- (void)endGame:(BOOL)won {
    
}

@end
