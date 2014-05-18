//
//  Block.m
//  Cube_Smash_2014
//
//  Copyright (c) 2014 Joshua Howland. All rights reserved.
//

#import "Coin.h"

@implementation Coin

-(id)initWithPosition:(CGPoint)position andScreenSize:(CGSize)screenSize{
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
    
    self = [super init];
    
    _coinSprite = [[SKSpriteNode alloc] initWithImageNamed:@"btcpic"];
    _coinSprite.size = CGSizeMake(_a, _b);
    //_coinSprite = [[SKSpriteNode alloc] initWithColor:[UIColor yellowColor] size:CGSizeMake(_a, _b)];
    _coinSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_coinSprite.size];
    
    return self;
}

-(void)update{
    _a = (int)( (_y-_spawn.y)/_rad/5.0	);
    _b = _a;
    _x = _screenSize.width/2 - (_y-_spawn.y)/_rad*_over;
    //NSLog(@"x , %f",_y);
    _coinSprite.position = CGPointMake(_x,2*_spawn.y - _y);
    _coinSprite.size = CGSizeMake(_a, _b);
    _dy = (_y-_spawn.y)/30.0;
    if(_dy==0){
            _dy = 1;
    }
    _y+=_dy;
}

@end
