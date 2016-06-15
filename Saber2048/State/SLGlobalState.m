//
//  SLGlobalState.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLGlobalState.h"
#import "SLTheme.h"

#define kGameType  @"Game Type"
#define kTheme     @"Theme"
#define kBoardSize @"Board Size"
#define kBestScore @"Best Score"

@implementation SLGlobalState

+ (instancetype)state {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        [self setupDefaultState];
        [self loadGlobalState];
        
    }
    return self;
}

- (void)setupDefaultState {
    NSDictionary *defaultValues = @{kGameType: @0, kTheme: @0, kBoardSize: @1, kBestScore: @0};
    [Settings registerDefaults:defaultValues];
}

- (void)loadGlobalState {
    _dimension = [Settings integerForKey:kBoardSize] + 3;
    _cornerRadius = 4;
    _borderWidth = 5;
    _animationDuration = 0.1;
    _theme = [Settings integerForKey:kTheme];
    _tileSize = _dimension <= 4 ? 66 : 56;
    _horizontalOffset = [self getHorizontalOffset];
    _verticalOffset = [self getVerticalOffset];
}

- (NSInteger)getHorizontalOffset {
    CGFloat width = _dimension * (_tileSize + _borderWidth) + _borderWidth;
    return ([[UIScreen mainScreen] bounds].size.width - width) / 2;
}


- (NSInteger)getVerticalOffset {
    CGFloat height = _dimension * (_tileSize + _borderWidth) + _borderWidth + 120;
    return ([[UIScreen mainScreen] bounds].size.height - height) / 2;
}

- (NSInteger)valueForLevel:(NSInteger)level {
    if (self.gameType == SLGameType2) {
        NSInteger a = 1, b = 1;
        for (NSInteger i = 0; i < level; i++) {
            NSInteger c = a + b;
            a = b;
            b = c;
        }
        return b;
    } else {
        NSInteger value = 1;
        NSInteger base = self.gameType == SLGameType1 ? 2 : 3;
        for (NSInteger i = 0; i < level; i++) {
            value *= base;
        }
        return value;
    }
}

# pragma mark - Appearance

- (UIColor *)colorForLevel:(NSInteger)level {
    return [[SLTheme themeClassForType:self.theme] colorForLevel:level];
}


- (UIColor *)textColorForLevel:(NSInteger)level {
    return [[SLTheme themeClassForType:self.theme] textColorForLevel:level];
}


- (CGFloat)textSizeForValue:(NSInteger)value {
    NSInteger offset = self.dimension == 5 ? 2 : 0;
    if (value < 100) {
        return 32 - offset;
    } else if (value < 1000) {
        return 28 - offset;
    } else if (value < 10000) {
        return 24 - offset;
    } else if (value < 100000) {
        return 20 - offset;
    } else if (value < 1000000) {
        return 16 - offset;
    } else {
        return 13 - offset;
    }
}


- (UIColor *)backgroundColor {
    return [[SLTheme themeClassForType:self.theme] backgroundColor];
}

- (UIColor *)scoreBoardColor {
    return [[SLTheme themeClassForType:self.theme] scoreBoardColor];
}

- (UIColor *)boardColor {
    return [[SLTheme themeClassForType:self.theme] boardColor];
}

- (UIColor *)buttonColor {
    return [[SLTheme themeClassForType:self.theme] buttonColor];
}

- (NSString *)boldFontName {
    return [[SLTheme themeClassForType:self.theme] boldFontName];
}

- (NSString *)regularFontName {
    return [[SLTheme themeClassForType:self.theme] regularFontName];
}

# pragma mark - Position to point conversion
- (CGPoint)locationOfPosition:(SLPosition)position {
    return CGPointMake([self xLocationOfPosition:position] + self.horizontalOffset,
                       [self yLocationOfPosition:position] + self.verticalOffset);
}


- (CGFloat)xLocationOfPosition:(SLPosition)position {
    return position.y * (_tileSize + _borderWidth) + _borderWidth;
}


- (CGFloat)yLocationOfPosition:(SLPosition)position {
    return position.x * (_tileSize + _borderWidth) + _borderWidth;
}

- (NSInteger)mergeLevel:(NSInteger)level1 withLevel:(NSInteger)level2 {
    if (![self isLevel:level1 mergeableWithLevel:level2]) return 0;
    
    if (self.gameType == SLGameType2) {
        return (level1 + 1 == level2) ? level2 + 1 : level1 + 1;
    }
    return level1 + 1;
}

- (BOOL)isLevel:(NSInteger)level1 mergeableWithLevel:(NSInteger)level2 {
    if (self.gameType == SLGameType2) return abs((int)level1 - (int)level2) == 1;
    return level1 == level2;
}

@end
