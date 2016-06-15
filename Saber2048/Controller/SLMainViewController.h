//
//  SLMainViewController.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

@interface SLMainViewController : UIViewController

- (void)updateScore:(NSInteger)score;

- (void)endGame:(BOOL)won;

@end
