//
//  SLGameScene.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLGameScene.h"
#import "SLGameManager.h"
#import "SLGridView.h"

// The min distance in one direction for an effective swipe.
#define EFFECTIVE_SWIPE_DISTANCE_THRESHOLD 20.0f

// The max ratio between the translation in x and y directions
// to make a swipe valid. i.e. diagonal swipes are invalid.
#define VALID_SWIPE_DIRECTION_THRESHOLD 2.0f

@interface SLGameScene()

@property (nonatomic, assign) BOOL hasPendingSwipe;
@property (nonatomic, strong) SLGameManager *gameManager;
@property (nonatomic, strong) SKSpriteNode *board;

@end

@implementation SLGameScene

- (instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _gameManager = [[SLGameManager alloc] init];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view {
    if (view == self.view) {
        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
        [self.view addGestureRecognizer:recognizer];
    } else {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:recognizer];
        }
    }
}

- (void)handleSwipe:(UIPanGestureRecognizer *)swipe {
    if (swipe.state == UIGestureRecognizerStateBegan) {
        _hasPendingSwipe = YES;
    } else {
        [self commitTranslation:[swipe translationInView:self.view]];
    }
}

- (void)commitTranslation:(CGPoint)translation {
    
    if (!_hasPendingSwipe) {
        return;
    }
    
    CGFloat absX = fabs(translation.x);
    CGFloat absY = fabs(translation.y);
    if (MAX(absX, absY) < EFFECTIVE_SWIPE_DISTANCE_THRESHOLD) {
        return;
    }
    
    if (absX > absY * VALID_SWIPE_DIRECTION_THRESHOLD) {
        
        translation.x < 0 ? NSLog(@"Left") : NSLog(@"Right");
        translation.x < 0 ? [_gameManager moveToDirection:SLDirectionLeft] :
        [_gameManager moveToDirection:SLDirectionRight];
    } else if (absY > absX * VALID_SWIPE_DIRECTION_THRESHOLD) {
        translation.y < 0 ? NSLog(@"Up") : NSLog(@"Down");
        translation.y < 0 ? [_gameManager moveToDirection:SLDirectionUp] :
        [_gameManager moveToDirection:SLDirectionDown];
    }
    
    _hasPendingSwipe = NO;
}

- (void)startNewGame {
    [_gameManager startNewSessionWithScene:self];
}

- (void)loadBoardWithGrid:(SLGrid *)grid {
    if (_board) {
        [_board removeFromParent];
    }
    UIImage *image = [SLGridView gridImageWithGrid:grid];
    SKTexture *backgroundTexture = [SKTexture textureWithCGImage:image.CGImage];
    _board = [SKSpriteNode spriteNodeWithTexture:backgroundTexture];
    [_board setScale:1/[UIScreen mainScreen].scale];
    _board.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_board];
}

@end
