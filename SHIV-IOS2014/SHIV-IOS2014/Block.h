//
//  Block.h
//  SHIV-IOS2014
//
//  Created by Joshua Howland on 5/3/14.
//  Copyright (c) 2014 Shiv Pande. All rights reserved.
//

#import "SpriteSuper.h"

@interface Block : SpriteSuper
-(id)initWithPosition:(CGPoint)position andScreenSize:(CGSize)screenSize;
-(void)update;

@property SKSpriteNode *blockSprite;
@property CGSize screenSize;
@property double x;
@property double y;
@property double dy;
@property double over;
@property int a;
@property int b;
@property int op;
@property double rad;
@property CGPoint spawn;

@end
