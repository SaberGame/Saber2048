//
//  SLOverlayView.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLOverlayView.h"
#import "Masonry.h"

@implementation SLOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textColor = [SLSTATE buttonColor];
        _messageLabel.font = [UIFont fontWithName:[SLSTATE boldFontName] size:36];
        [self addSubview:_messageLabel];
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
        
        _restartGameButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _restartGameButton.titleLabel.font = [UIFont fontWithName:[SLSTATE boldFontName] size:17];
        [_restartGameButton setTitleColor:[SLSTATE buttonColor] forState:UIControlStateNormal];
        [_restartGameButton setTitle:@"New Game" forState:UIControlStateNormal];
        [self addSubview:_restartGameButton];
        [_restartGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(_messageLabel.mas_bottom).offset(10);
        }];
        
        _keepPlayingButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _keepPlayingButton.titleLabel.font = [UIFont fontWithName:[SLSTATE boldFontName] size:17];
        [_keepPlayingButton setTitleColor:[SLSTATE buttonColor] forState:UIControlStateNormal];
        [_keepPlayingButton setTitle:@"Keep Playing" forState:UIControlStateNormal];
        [self addSubview:_keepPlayingButton];
        [_keepPlayingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.equalTo(_restartGameButton.mas_bottom).offset(10);
        }];
    }
    return self;
}

@end
