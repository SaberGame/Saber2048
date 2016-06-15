//
//  SLGridView.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLGridView.h"
#import "SLGrid.h"

@implementation SLGridView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [SLSTATE scoreBoardColor];
        self.layer.cornerRadius = SLSTATE.cornerRadius;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (instancetype)init
{
    NSInteger side = SLSTATE.dimension * (SLSTATE.tileSize + SLSTATE.borderWidth) + SLSTATE.borderWidth;
    CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - SLSTATE.verticalOffset;
    return [self initWithFrame:CGRectMake(SLSTATE.horizontalOffset, verticalOffset - side, side, side)];
}

+ (UIImage *)gridImageWithGrid:(SLGrid *)grid {
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    backgroundView.backgroundColor = [SLSTATE backgroundColor];
   
    SLGridView *view = [[SLGridView alloc] init];
    [backgroundView addSubview:view];
    
    [grid forEach:^(SLPosition position) {
        CALayer *layer = [CALayer layer];
        CGPoint point = [SLSTATE locationOfPosition:position];
        CGRect frame = layer.frame;
        frame.size = CGSizeMake(SLSTATE.tileSize, SLSTATE.tileSize);
        frame.origin = CGPointMake(point.x, [[UIScreen mainScreen] bounds].size.height - point.y - SLSTATE.tileSize);
        layer.frame = frame;
        
        layer.backgroundColor = [SLSTATE boardColor].CGColor;
        layer.cornerRadius = SLSTATE.cornerRadius;
        layer.masksToBounds = YES;
        [backgroundView.layer addSublayer:layer];
    } reverseOrder:NO];
    
    return [SLGridView snapshotWithView:backgroundView];
}

+ (UIImage *)snapshotWithView:(UIView *)view {
    // This is a little hacky, but is probably the best generic way to do this.
    // [UIColor colorWithPatternImage] doesn't really work with SpriteKit, and we need
    // to take a retina-quality screenshot. But then in SpriteKit we need to shrink the
    // corresponding node back to scale 1.0 in order for it to display properly.
    UIGraphicsBeginImageContextWithOptions(view.frame.size, view.opaque, 0.0);
    [[view layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
