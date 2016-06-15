//
//  SLCell.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLCell.h"
#import "SLTile.h"

@implementation SLCell

- (instancetype)initWithPosition:(SLPosition)position {
    if (self = [super init]) {
        self.position = position;
        self.tile = nil;
    }
    return self;
}

- (void)setTile:(SLTile *)tile {
    _tile = tile;
    if (tile) {
       tile.cell = self;
    }
}

@end
