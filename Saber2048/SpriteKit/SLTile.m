//
//  SLTile.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLTile.h"
#import "SLCell.h"

typedef void (^SLBlock)();

@interface SLTile()

@property (nonatomic, strong) SKLabelNode *value;
@property (nonatomic, strong) NSMutableArray *pendingActions;
@property (nonatomic, copy) SLBlock pendingBlock;

@end

@implementation SLTile

- (instancetype)init {
    if (self = [super init]) {
        // Layout of the tile.
        CGRect rect = CGRectMake(0, 0, SLSTATE.tileSize, SLSTATE.tileSize);
        CGPathRef rectPath = CGPathCreateWithRoundedRect(rect, SLSTATE.cornerRadius, SLSTATE.cornerRadius, NULL);
        self.path = rectPath;
        CFRelease(rectPath);
        self.lineWidth = 0;
        
        // Initiate pending actions queue.
        _pendingActions = [NSMutableArray array];
        
        // Set up value label.
        _value = [SKLabelNode labelNodeWithFontNamed:[SLSTATE boldFontName]];
        _value.position = CGPointMake(SLSTATE.tileSize / 2, SLSTATE.tileSize / 2);
        _value.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        _value.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:_value];
        
        // For Fibonacci game, which is way harder than 2048 IMO, 40 seems to be the easiest number.
        // 90 definitely won't work, as we need approximately equal number of 2 and 3 to make the
        // game remotely makes sense.
        if (SLSTATE.gameType == SLGameType2) {
            self.level = arc4random_uniform(100) < 40 ? 1 : 2;
        } else {
            self.level = arc4random_uniform(100) < 95 ? 1 : 2;
        }
        
        [self refreshValue];
        
    }
    return self;
}

- (void)refreshValue {
    NSInteger value = [SLSTATE valueForLevel:self.level];
    _value.text = [NSString stringWithFormat:@"%zd", value];
    _value.fontColor = [SLSTATE textColorForLevel:self.level];
    _value.fontSize = [SLSTATE textSizeForValue:value];
    
    self.fillColor = [SLSTATE colorForLevel:self.level];
}

+ (SLTile *)insertNewTileToCell:(SLCell *)cell {
    SLTile *tile = [[SLTile alloc] init];
    
    // The initial position of the tile is at the center of its cell. This is so because when
    // scaling the tile, SpriteKit does so from the origin, not the center. So we have to scale
    // the tile while moving it back to its normal position to achieve the "pop out" effect.
    CGPoint origin = [SLSTATE locationOfPosition:cell.position];
    tile.position = CGPointMake(origin.x + SLSTATE.tileSize / 2, origin.y + SLSTATE.tileSize / 2);
    [tile setScale:0];
    
    cell.tile = tile;
    return tile;
}

- (void)removeAnimated:(BOOL)animated {
    if (animated) {
        [_pendingActions addObject:[SKAction scaleTo:0 duration:SLSTATE.animationDuration]];
    }
    [_pendingActions addObject:[SKAction removeFromParent]];
    
    __weak typeof(self) weakSelf = self;
    _pendingBlock = ^{
        [weakSelf removeFromParentCell];
    };
    [self commitPendingActions];
}

- (void)removeFromParentCell {
    // Check if the tile is still registered with its parent cell, and if so, remove it.
    // We don't really care about self.cell, because that is a weak pointer.
    if (self.cell.tile == self) {
        self.cell.tile = nil;
    }
}

- (void)commitPendingActions {
    [self runAction:[SKAction sequence:_pendingActions] completion:^{
        [_pendingActions removeAllObjects];
        if (_pendingBlock) {
            _pendingBlock();
            _pendingBlock = nil;
        }
    }];
}

//- (BOOL)canMergeWithTile:(SLTile *)tile {
//    
//}

- (NSInteger)mergeToTile:(SLTile *)tile {
    // Cannot merge with thin air. Also cannot merge with tile that has a pending merge.
    // For the latter, imagine we have 4, 2, 2. If we move to the right, it will first
    // become 4, 4. Now we cannot merge the two 4's.
    if (!tile || [tile hasPendingMerge]) {
         return 0;
    }
    
    NSInteger newLevel = [SLSTATE mergeLevel:self.level withLevel:tile.level];

    if (newLevel > 0) {
        // 1. Move self to the destination cell.
        [self moveToCell:tile.cell];
        
        // 2. Remove the tile in the destination cell.
        [tile removeWithDelay];
        
        // 3. Update value and pop.
        [self updateLevelTo:newLevel];
        [_pendingActions addObject:[self pop]];
    }
    return newLevel;
}

- (NSInteger)merge3ToTile:(SLTile *)tile andTile:(SLTile *)furtherTile {
    if (!tile || [tile hasPendingMerge] || [furtherTile hasPendingMerge]) return 0;
    
    NSUInteger newLevel = MIN([SLSTATE mergeLevel:self.level withLevel:tile.level],
                              [SLSTATE mergeLevel:tile.level withLevel:furtherTile.level]);
    if (newLevel > 0) {
        // 1. Move self to the destination cell AND move the intermediate tile to there too.
        [tile moveToCell:furtherTile.cell];
        [self moveToCell:furtherTile.cell];
        
        // 2. Remove the tile in the destination cell.
        [tile removeWithDelay];
        [furtherTile removeWithDelay];
        
        // 3. Update value and pop.
        [self updateLevelTo:newLevel];
        [_pendingActions addObject:[self pop]];
    }
    return newLevel;
}

- (void)moveToCell:(SLCell *)cell {
    [_pendingActions addObject:[SKAction moveTo:[SLSTATE locationOfPosition:cell.position]
                                       duration:SLSTATE.animationDuration]];
    self.cell.tile = nil;
    cell.tile = self;
}

- (void)updateLevelTo:(NSInteger)level {
    self.level = level;
    [_pendingActions addObject:[SKAction runBlock:^{
        [self refreshValue];
    }]];
}

- (void)removeWithDelay {
    SKAction *wait = [SKAction waitForDuration:SLSTATE.animationDuration];
    SKAction *remove = [SKAction removeFromParent];
    [self runAction:[SKAction sequence:@[wait, remove]] completion:^{
        [self removeFromParentCell];
    }];
}

- (BOOL)hasPendingMerge {
    // A move is only one action, so if there are more than one actions, there must be
    // a merge that needs to be committed. If things become more complicated, change
    // this to an explicit ivar or property.
    return _pendingActions.count > 1;
}

# pragma mark - SKAction helpers

- (SKAction *)pop {
    CGFloat d = 0.15 * SLSTATE.tileSize;
    SKAction *wait = [SKAction waitForDuration:SLSTATE.animationDuration / 3];
    SKAction *enlarge = [SKAction scaleTo:1.3 duration:SLSTATE.animationDuration / 1.5];
    SKAction *move = [SKAction moveBy:CGVectorMake(-d, -d) duration:SLSTATE.animationDuration / 1.5];
    SKAction *restore = [SKAction scaleTo:1 duration:SLSTATE.animationDuration / 1.5];
    SKAction *moveBack = [SKAction moveBy:CGVectorMake(d, d) duration:SLSTATE.animationDuration / 1.5];
    
    return [SKAction sequence:@[wait, [SKAction group:@[enlarge, move]],
                                [SKAction group:@[restore, moveBack]]]];
}

- (BOOL)canMergeWithTile:(SLTile *)tile {
    if (!tile) return NO;
    return [SLSTATE isLevel:self.level mergeableWithLevel:tile.level];
}


@end
