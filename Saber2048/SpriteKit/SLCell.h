//
//  SLCell.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SLTile;

@interface SLCell : NSObject

/** The position of the cell. */
@property (nonatomic, assign) SLPosition position;
/** The tile in the cell, if any. */
@property (nonatomic, weak) SLTile *tile;

/**
 * Initialize a M2Cell at the specified position with no tile in it.
 *
 * @param position The position of the cell.
 */
- (instancetype)initWithPosition:(SLPosition)position;

@end
