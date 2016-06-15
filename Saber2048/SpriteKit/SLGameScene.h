//
//  SLGameScene.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@class SLGrid;
@class SLMainViewController;

@interface SLGameScene : SKScene

@property (nonatomic, weak) SLMainViewController *controller;

- (void)startNewGame;

- (void)loadBoardWithGrid:(SLGrid *)grid;

@end
