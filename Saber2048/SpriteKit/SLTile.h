//
//  SLTile.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
@class SLCell;

@interface SLTile : SKShapeNode

/** The level of the tile. */
@property (nonatomic, assign) NSInteger level;

/** The cell this tile belongs to. */
@property (nonatomic, weak) SLCell *cell;


/**
 * Creates and inserts a new tile at the specified cell.
 *
 * @param cell The cell to insert tile into.
 * @return The tile created.
 */
+ (SLTile *)insertNewTileToCell:(SLCell *)cell;


/**
 * Removes the tile from its cell and from the scene.
 *
 * @param animated If YES, the removal will be animated.
 */
- (void)removeAnimated:(BOOL)animated;

/**
 * Whether this tile can merge with the given tile.
 *
 * @param tile The target tile to merge with.
 * @return YES if the two tiles can be merged.
 */
- (BOOL)canMergeWithTile:(SLTile *)tile;


/**
 * Checks whether this tile can merge with the given tile, and merge them
 * if possible. The resulting tile is at the position of the given tile.
 *
 * @param tile Target tile to merge into.
 * @return The resulting level of the merge, or 0 if unmergeable.
 */
- (NSInteger)mergeToTile:(SLTile *)tile;

- (NSInteger)merge3ToTile:(SLTile *)tile andTile:(SLTile *)furtherTile;
/**
 * Moves the tile to the specified cell. If the tile is not already in the grid,
 * calling this method would result in error.
 *
 * @param cell The destination cell.
 */
- (void)moveToCell:(SLCell *)cell;

- (void)commitPendingActions;

@end
