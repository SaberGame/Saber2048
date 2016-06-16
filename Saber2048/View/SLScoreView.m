//
//  SLScoreView.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLScoreView.h"
#import "Masonry.h"

@implementation SLScoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(5);
        }];
        
        _socreLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _socreLabel.textColor = [UIColor whiteColor];
        _socreLabel.text = @"0";
        [self addSubview:_socreLabel];
        [_socreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-5);
        }];
        
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    
    self.layer.cornerRadius = SLSTATE.cornerRadius;
    self.layer.masksToBounds = YES;
    [self updateAppearance];
}

- (void)updateAppearance {
    self.backgroundColor = [SLSTATE scoreBoardColor];
    self.titleLabel.font = [UIFont fontWithName:[SLSTATE boldFontName] size:12];
    self.socreLabel.font = [UIFont fontWithName:[SLSTATE boldFontName] size:14];
}

@end
