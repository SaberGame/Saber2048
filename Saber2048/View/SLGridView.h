//
//  SLGridView.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SLGrid;

@interface SLGridView : UIView

/**
 * Create the entire background of the view with the grid at the correct position.
 *
 * @param grid The grid object that the image bases on.
 */
+ (UIImage *)gridImageWithGrid:(SLGrid *)grid;

/**
 * Create the entire background of the view with a translucent overlay on the grid.
 * The rest of the image is clear color, to create the illusion that the overlay is
 * only over the grid.
 */
+ (UIImage *)gridImageWithOverlay;

@end
