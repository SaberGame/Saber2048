//
//  SLScoreView.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLScoreView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *socreLabel;

- (void)updateAppearance;

@end
