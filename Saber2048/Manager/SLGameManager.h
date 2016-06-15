//
//  SLGameManager.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLGameScene;

typedef NS_ENUM(NSInteger, SLDirection) {
    SLDirectionUp,
    SLDirectionLeft,
    SLDirectionDown,
    SLDirectionRight
};


@interface SLGameManager : NSObject

/**
 * Starts a new session with the provided scene.
 *
 * @param scene The scene in which the game happens.
 */
- (void)startNewSessionWithScene:(SLGameScene *)scene;

/**
 * Moves all movable tiles to the desired direction, then add one more tile to the grid.
 * Also refreshes score and checks game status (won/lost).
 *
 * @param direction The direction of the move (up, right, down, left).
 */
- (void)moveToDirection:(SLDirection)direction;

@end
