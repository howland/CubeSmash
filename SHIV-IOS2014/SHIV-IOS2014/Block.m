//
//  Block.m
//  SHIV-IOS2014
//
//  Created by Joshua Howland on 5/3/14.
//  Copyright (c) 2014 Shiv Pande. All rights reserved.
//

#import "Block.h"

@implementation Block

-(id)initWithPosition:(CGPoint)position andScreenSize:(CGSize)screenSize{
    _dy = 1.2;
    _time = 0;
    _over = 0;
    _a =0;
    _b = 0;
    _rad = 0.93324753;
    self.screenSize =screenSize;
    _over = 1 - 2*((double)(arc4random()%100))/100.0;
	_x = position.x;
	_y = position.y;
    _spawn = position;
    
    self = [super init];
    
    
    //_blockSprite = [[SKSpriteNode alloc] initWithImageNamed:@"Block"];
   // _blockSprite.size = CGSizeMake(_a, _b);
    _blockSprite = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(_a, _b)];
    _blockSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_blockSprite.size];
    
    return self;
}

-(void)update{
    _a = (int)( (_y-_spawn.y)/tan(_rad)/4.0	);
    _b = _a;
    
    _x = _screenSize.width/2 - (_y-_spawn.y)/tan(_rad)*_over;
    NSLog(@"x , %f",_y);
    _blockSprite.position = CGPointMake(_x,2*_spawn.y - _y);
    _blockSprite.size = CGSizeMake(_a, _b);
    _dy = (_y-_spawn.y)/30.0;
    if(_dy==0)
    {if(_time%10==0)
        _dy = 1;
    else
        _dy = 0;}
    _y+=_dy;
    _time++;
}

@end
