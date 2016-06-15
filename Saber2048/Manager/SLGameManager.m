//
//  SLGameManager.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLGameManager.h"
#import "SLGrid.h"
#import "SLTile.h"
#import "SLGameScene.h"
#import "SLMainViewController.h"

/**
 * Helper function that checks the termination condition of either counting up or down.
 *
 * @param value The current i value.
 * @param countUp If YES, we are counting up.
 * @param upper The upper bound of i.
 * @param lower The lower bound of i.
 * @return YES if the counting is still in progress. NO if it should terminate.
 */
BOOL iterate(NSInteger value, BOOL countUp, NSInteger upper, NSInteger lower) {
    return countUp ? value < upper : value > lower;
}

@interface SLGameManager()

@property (nonatomic, assign) BOOL gameOver;
@property (nonatomic, assign) BOOL gameWon;
@property (nonatomic, assign) BOOL keepPlaying;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger pendingScore;
@property (nonatomic, strong) SLGrid *grid;
@property (nonatomic, strong) CADisplayLink *addTileDisplayLink;

@end


@implementation SLGameManager


- (void)moveToDirection:(SLDirection)direction {
    
    __block SLTile *tile = nil;
    
    // Remember that the coordinate system of SpriteKit is the reverse of that of UIKit.
    BOOL reverse = direction == SLDirectionUp || direction == SLDirectionRight;
    NSInteger unit = reverse ? 1 : -1;
    if (direction == SLDirectionUp || direction == SLDirectionDown) {
        
        [_grid forEach:^(SLPosition position) {
            if ((tile = [_grid tileAtPosition:position])) {
                NSInteger target = position.x;
                for (NSInteger i = position.x + unit; iterate(i, reverse, _grid.dimension, -1); i += unit) {
                    SLTile *t = [_grid tileAtPosition:SLPositionMake(i, position.y)];
                    // Empty cell; we can move at least to here.
                    if (!t) {
                        target = i;
                    } else {
                        NSInteger level = 0;
                        if (SLSTATE.gameType == SLGameType3) {
                            SLPosition further = SLPositionMake(i + unit, position.y);
                            SLTile *ft = [_grid tileAtPosition:further];
                            if (ft) {
                                level = [tile merge3ToTile:t andTile:ft];
                            }
                        } else {
                            level = [tile mergeToTile:t];
                        }
                        
                        if (level) {
                            target = position.x;
                            _pendingScore = [SLSTATE valueForLevel:level];
                        }
                        break;
                    }
                }
                // The current tile is movable.
                if (target != position.x) {
                    [tile moveToCell:[_grid cellAtPosition:SLPositionMake(target, position.y)]];
                    _pendingScore++;
                }
            }
        } reverseOrder:reverse];
    } else {
        [_grid forEach:^(SLPosition position) {
            if ((tile = [_grid tileAtPosition:position])) {
                NSInteger target = position.y;
                for (NSInteger i = position.y + unit; iterate(i, reverse, _grid.dimension, -1); i += unit) {
                    SLTile *t = [_grid tileAtPosition:SLPositionMake(position.x, i)];
                    
                    if (!t) target = i;
                    
                    else {
                        NSInteger level = 0;
                        
                        if (SLSTATE.gameType == SLGameType3) {
                            SLPosition further = SLPositionMake(position.x, i + unit);
                            SLTile *ft = [_grid tileAtPosition:further];
                            if (ft) {
                                level = [tile merge3ToTile:t andTile:ft];
                            }
                        } else {
                            level = [tile mergeToTile:t];
                        }
                        
                        if (level) {
                            target = position.y;
                            _pendingScore = [SLSTATE valueForLevel:level];
                        }
                        
                        break;
                    }
                }
                
                // The current tile is movable.
                if (target != position.y) {
                    [tile moveToCell:[_grid cellAtPosition:SLPositionMake(position.x, target)]];
                    _pendingScore++;
                }
            }
        } reverseOrder:reverse];
    }
    
    // Cannot move to the given direction. Abort.
    if (!_pendingScore) return;
    
    // Commit tile movements.
    [_grid forEach:^(SLPosition position) {
        SLTile *tile = [_grid tileAtPosition:position];
        if (tile) {
            [tile commitPendingActions];
            if (tile.level >= SLSTATE.winningLevel) _gameWon = YES;
        }
    } reverseOrder:reverse];
    
    // Increment score.
    [self materializePendingScore];
    
    // Check post-move status.
    if (!_keepPlaying && _gameWon) {
        // We set `keepPlaying` to YES. If the user decides not to keep playing,
        // we will be starting a new game, so the current state is no longer relevant.
        _keepPlaying = YES;
        [_grid.scene.controller endGame:YES];
    }
    
    // Add one more tile to the grid.
    [_grid insertTileAtRandomAvailablePositionWithDelay:YES];
    if (SLSTATE.dimension == 5 && SLSTATE.gameType == SLGameType2)
        [_grid insertTileAtRandomAvailablePositionWithDelay:YES];
    
    if (![self movesAvailable]) {
        [_grid.scene.controller endGame:NO];
    }
}

# pragma mark - State checkers

/**
 * Whether there are moves available.
 *
 * A move is available if either there is an empty cell, or there are adjacent matching cells.
 * The check for matching cells is more expensive, so it is only performed when there is no
 * available cell.
 *
 * @return YES if there are moves available.
 */
- (BOOL)movesAvailable
{
    return [_grid hasAvailableCells] || [self adjacentMatchesAvailable];
}

/**
 * Whether there are adjacent matches available.
 *
 * An adjacent match is present when two cells that share an edge can be merged. We do not
 * consider cases in which two mergable cells are separated by some empty cells, as that should
 * be covered by the `cellsAvailable` function.
 *
 * @return YES if there are adjacent matches available.
 */
- (BOOL)adjacentMatchesAvailable {
    for (NSInteger i = 0; i < _grid.dimension; i++) {
        for (NSInteger j = 0; j < _grid.dimension; j++) {
            // Due to symmetry, we only need to check for tiles to the right and down.
            SLTile *tile = [_grid tileAtPosition:SLPositionMake(i, j)];
            
            // Continue with next iteration if the tile does not exist. Note that this means that
            // the cell is empty. For our current usage, it will never happen. It is only in place
            // in case we want to use this function by itself.
            if (!tile) continue;
            
            if (SLSTATE.gameType == SLGameType3) {
                if (([tile canMergeWithTile:[_grid tileAtPosition:SLPositionMake(i + 1, j)]] &&
                     [tile canMergeWithTile:[_grid tileAtPosition:SLPositionMake(i + 2, j)]]) ||
                    ([tile canMergeWithTile:[_grid tileAtPosition:SLPositionMake(i, j + 1)]] &&
                     [tile canMergeWithTile:[_grid tileAtPosition:SLPositionMake(i, j + 2)]])) {
                        return YES;
                    }
            } else {
                if ([tile canMergeWithTile:[_grid tileAtPosition:SLPositionMake(i + 1, j)]] ||
                    [tile canMergeWithTile:[_grid tileAtPosition:SLPositionMake(i, j + 1)]]) {
                    return YES;
                }
            }
        }
    }
    
    // Nothing is found.
    return NO;
}

# pragma mark - Score

- (void)materializePendingScore
{
    _score += _pendingScore;
    _pendingScore = 0;
    [_grid.scene.controller updateScore:_score];
}


- (void)startNewSessionWithScene:(SLGameScene *)scene {
    if (_grid) {
        [_grid removeAllTilesAnimated:NO];
    }
    
    if (!_grid || _grid.dimension != SLSTATE.dimension) {
        _grid = [[SLGrid alloc] initWithDimension:SLSTATE.dimension];
        _grid.scene = scene;
    }
    
    [scene loadBoardWithGrid:_grid];
    
    _score = 0;
    _gameWon = NO;
    _gameOver = NO;
    _keepPlaying = NO;
    
    // Existing tile removal is async and happens in the next screen refresh, so we'd wait a bit.
    _addTileDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(addTwoRandomTiles)];
    [_addTileDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)addTwoRandomTiles {
    // If the scene only has one child (the board), we can proceed with adding new tiles
    // since all old ones are removed. After adding new tiles, remove the displaylink.
    if (_grid.scene.children.count <= 1) {
        [_grid insertTileAtRandomAvailablePositionWithDelay:NO];
        [_grid insertTileAtRandomAvailablePositionWithDelay:NO];
        [_addTileDisplayLink invalidate];
    }
}

@end
