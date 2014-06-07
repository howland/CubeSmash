//
//  Block.m
//  Cube_Smash_2014
//
//  Copyright (c) 2014 Joshua Howland. All rights reserved.
//

#import "Block.h"

@implementation Block

-(id)initWithPosition:(CGPoint)position andScreenSize:(CGSize)screenSize{
    self = [super init];

    _dy = 1.2;
    _over = 0;
    _a =0;
    _b = 0;
    _rad = tan(1.13324753);
    self.screenSize =screenSize;
    _over = 1 - 2*((double)(arc4random()%100))/100.0;
	_x = position.x;
	_y = position.y;
    _spawn = position;
    
    _blockSprite = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(_a, _b)];
    _blockSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_blockSprite.size];
    
    return self;
}

-(void)update{
    _a = (int)( (_y-_spawn.y)/_rad/5.0	);
    _b = _a;
    _x = _screenSize.width/2 - (_y-_spawn.y)/_rad*_over;
    //NSLog(@"x , %f",_y);
    _blockSprite.position = CGPointMake(_x,2*_spawn.y - _y);
    _blockSprite.size = CGSizeMake(_a, _b);
    _dy = (_y-_spawn.y)/30.0;
    if(_dy==0){
            _dy = 1;
    }
    _y+=_dy;
}

@end
