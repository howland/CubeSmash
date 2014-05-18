//
//  Tree.m
//  SHIV-IOS2014
//
//  Copyright (c) 2014 Shiv Pande. All rights reserved.
//

#import "Tree.h"

@implementation Tree

-(id)initWithPosition:(CGPoint)position andScreenSize:(CGSize)screenSize{
    _dy = 1.2;
    _rad = tan(1.13324753);
    self.screenSize =screenSize;
    _x = arc4random()%(int)screenSize.width;
	_y = position.y;
    _spawn = position;
    
    self = [super init];
    
    _treeSprite = [[SKSpriteNode alloc] initWithImageNamed:@"cliptree"];
    _treeSprite.size = CGSizeMake(_a, _b);
    _treeSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_treeSprite.size];
    
    return self;
}

-(void)update{
    _a = (int)( (_y-_spawn.y)/_rad	);
    _b = _a*1.5;
    double cst = 2.0;
    if(_x>_screenSize.width/2){
        _x = _x + _dy*_rad/cst;

    }else{
        _x = _x - _dy*_rad/cst;
    }
    //NSLog(@"x , %f",_y);
    _treeSprite.position = CGPointMake(_x,2*_spawn.y - _y);
    _treeSprite.size = CGSizeMake(_a, _b);
    _treeSprite.zPosition = _a;
    _dy = (_y-_spawn.y)/30.0;
    if(_dy==0){
            _dy = 1;
    }
    _y+=_dy;
}

@end
