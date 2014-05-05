//
//  Block.h
//  SHIV-IOS2014
//
//  Copyright (c) 2014 Shiv Pande. All rights reserved.
//

#import "SpriteSuper.h"

@interface Coin : SpriteSuper
-(id)initWithPosition:(CGPoint)position andScreenSize:(CGSize)screenSize;
-(void)update;

@property SKSpriteNode *coinSprite;
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
