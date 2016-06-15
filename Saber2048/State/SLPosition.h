
//
//  SLPosition.h
//  Saber2048
//
//  Created by songlong on 16/6/15.
//  Copyright © 2016年 SaberGame. All rights reserved.
//

#ifndef SLPosition_h
#define SLPosition_h

typedef struct Position {
    NSInteger x;
    NSInteger y;
} SLPosition;

CG_INLINE SLPosition SLPositionMake(NSInteger x, NSInteger y) {
    SLPosition position;
    position.x = x; position.y = y;
    return position;
}

#endif /* SLPosition_h */
