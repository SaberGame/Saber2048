//
//  SLSettingDetailViewController.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSettingDetailViewController : UIViewController

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSString *footer;

@property (nonatomic, copy) void(^clickBlock)();

@end
