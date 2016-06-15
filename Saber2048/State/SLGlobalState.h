//
//  SLGlobalState.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SLSTATE [SLGlobalState state]

typedef NS_ENUM(NSInteger, SLGameType) {
    SLGameType1 = 0,
    SLGameType2 = 1,
    SLGameType3 = 2
};

@interface SLGlobalState : NSObject

@property (nonatomic, assign, readonly) NSInteger cornerRadius;
@property (nonatomic, assign, readonly) NSInteger winningLevel;
@property (nonatomic, assign, readonly) SLGameType gameType;
@property (nonatomic, assign) NSInteger theme;


/** The singleton instance of state. */
+ (instancetype)state;

/**
 * The numerical value of the specified level.
 *
 * @param level The level we are interested in.
 * @return The numerical value of the level.
 */
- (NSInteger)valueForLevel:(NSInteger)level;

- (UIColor *)backgroundColor;

- (UIColor *)boardColor;

- (UIColor *)scoreBoardColor;

- (UIColor *)buttonColor;

- (NSString *)boldFontName;

- (NSString *)regularFontName;

@end
