//
//  SLGlobalState.m
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#import "SLGlobalState.h"
#import "SLTheme.h"

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
        _theme = 0;
        _cornerRadius = 4;
    }
    return self;
}



- (NSInteger)valueForLevel:(NSInteger)level {
    return 555;
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


@end
