//
//  SLGrid.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLGrid.h"
#import "SLCell.h"
#import "SLTile.h"
#import "SLGameScene.h"

@interface SLGrid()

@property (nonatomic, strong) NSMutableArray *grid;

@end

@implementation SLGrid

- (instancetype)initWithDimension:(NSInteger)dimension {
    if (self = [super init]) {
        _grid = [[NSMutableArray alloc] initWithCapacity:dimension];
        for (NSInteger i = 0; i < dimension; i++) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:dimension];
            for (NSInteger j = 0; j < dimension; j++) {
                [array addObject:[[SLCell alloc] initWithPosition:SLPositionMake(i, j)]];
            }
            [_grid addObject:array];
        }
        _dimension = dimension;
    }
    return self;
}

- (void)forEach:(IteratorBlock)block reverseOrder:(BOOL)reverse {
    if (!reverse) {
        for (NSInteger i = 0; i < self.dimension; i++)
            for (NSInteger j = 0; j < self.dimension; j++)
                block(SLPositionMake(i, j));
    } else {
        for (NSInteger i = self.dimension - 1; i >= 0; i--)
            for (NSInteger j = self.dimension - 1; j >= 0; j--)
                block(SLPositionMake(i, j));
    }
}

- (void)insertTileAtRandomAvailablePositionWithDelay:(BOOL)delay {
    SLCell *cell = [self randomAvailableCell];
    if (cell) {
        SLTile *tile = [SLTile insertNewTileToCell:cell];
        [self.scene addChild:tile];
        
        SKAction *delayAction = delay ? [SKAction waitForDuration:SLSTATE.animationDuration * 3] :
        [SKAction waitForDuration:0];
        SKAction *move = [SKAction moveBy:CGVectorMake(- SLSTATE.tileSize / 2, - SLSTATE.tileSize / 2)
                                 duration:SLSTATE.animationDuration];
        SKAction *scale = [SKAction scaleTo:1 duration:SLSTATE.animationDuration];
        [tile runAction:[SKAction sequence:@[delayAction, [SKAction group:@[move, scale]]]]];
    }
}

/**
 * Returns a randomly chosen cell that's available.
 *
 * @return A randomly chosen available cell, or nil if no cell is available.
 */
- (SLCell *)randomAvailableCell {
    NSArray *availableCells = [self availableCells];
    if (availableCells.count) {
        return [availableCells objectAtIndex:arc4random_uniform((int)availableCells.count)];
    }
    return nil;
}


/**
 * Returns all available cells in an array.
 *
 * @return The array of all available cells. If no cell is available, returns empty array.
 */
- (NSArray *)availableCells {
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:self.dimension * self.dimension];
    [self forEach:^(SLPosition position) {
        SLCell *cell = [self cellAtPosition:position];
        if (!cell.tile) {
            [array addObject:cell];
        }
    } reverseOrder:NO];
    return array;
}


#pragma mark - Position helpers

- (SLCell *)cellAtPosition:(SLPosition)position {
    if (position.x >= self.dimension || position.y >= self.dimension ||
        position.x < 0 || position.y < 0) return nil;
    return [[_grid objectAtIndex:position.x] objectAtIndex:position.y];
}


- (SLTile *)tileAtPosition:(SLPosition)position {
    SLCell *cell = [self cellAtPosition:position];
    return cell ? cell.tile : nil;
}

- (void)removeAllTilesAnimated:(BOOL)animated {
    [self forEach:^(SLPosition position) {
        SLTile *tile = [self tileAtPosition:position];
        if (tile) {
            [tile removeAnimated:animated];
        }
    } reverseOrder:NO];
}

- (BOOL)hasAvailableCells {
    return [self availableCells].count != 0;
}

@end
