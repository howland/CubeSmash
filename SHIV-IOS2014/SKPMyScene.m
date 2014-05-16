//
//  SKPMyScene.m
//  SHIV-IOS2014
//
//  Created by Shiv Pande on 5/1/14.
//  Copyright (c) 2014 Shiv Pande. All rights reserved.
//

#import "SKPMyScene.h"
#import "SpriteSuper.h"
#import "Tree.h"
#import "Block.h"
#import "Coin.h"

@interface SKPMyScene()

@property int time;
@property int score;
@property BOOL playing;
@property SKSpriteNode *player;
@property NSMutableArray *blocks;
@property NSMutableArray *trees;
@property CGPoint treeSpawn;
@property Coin *coin;
@property BOOL coinInUse;
@property int coinCount;

@property float coinprice;

@property int lastTouchX;

@property SKLabelNode *tapToStart;
@property SKLabelNode *countLabel;
@property SKLabelNode *scoreLabel;
@property SKLabelNode *priceLabel;

@property NSData* bitdata;

@end

@implementation SKPMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
        _player = [[SKSpriteNode alloc] initWithColor:[UIColor purpleColor] size:CGSizeMake(self.size.width/20, self.size.width/20)];
        _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
        _player.name = @"Player";
        [self addChild:_player];
        
        _tapToStart = [SKLabelNode labelNodeWithFontNamed:@"Georgia-Bold"];
        _tapToStart.text = @"Tap To Start!";
        _tapToStart.fontSize = self.size.width/10;
        _tapToStart.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        _countLabel = [SKLabelNode labelNodeWithFontNamed:@"Georgia-Bold"];
        _countLabel.text = [NSString stringWithFormat:@"Time:%i, Coins:%i",(int)_time/10, (int)_coinCount];
        _countLabel.fontSize = self.size.width/17;
        [self addChild:_countLabel];
        _countLabel.zPosition = 100;
        
        
        _coinInUse = false;
        _coinCount = 0;
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Georgia-Bold"];
        _scoreLabel.text = [NSString stringWithFormat:@"%i",(int)_score];
        _scoreLabel.fontSize = self.size.width/10;
        [self addChild:_scoreLabel];
        _scoreLabel.zPosition = 100;
        
        
        
        _trees = [[NSMutableArray alloc] init];
        
        [self reset];
        _player.position = CGPointMake(self.size.width/2, ((int)self.size.height*.2));
        _countLabel.position = CGPointMake(CGRectGetMidX(self.frame),self.size.height*17/20);
        _scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),self.size.height*15/20);
        
        SKShapeNode *side1 = [SKShapeNode node];
        CGMutablePathRef pathToDraw1 = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw1, NULL,  _treeSpawn.x  ,_treeSpawn.y);
        CGPathAddLineToPoint(pathToDraw1, NULL, 0 - self.size.width*.13, 0);
        side1.path = pathToDraw1;
        [side1 setStrokeColor:[UIColor greenColor]];
        [self addChild:side1];
        
        SKShapeNode *side2 = [SKShapeNode node];
        CGMutablePathRef pathToDraw2 = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw2, NULL, _treeSpawn.x  ,_treeSpawn.y);
        CGPathAddLineToPoint(pathToDraw2, NULL, self.size.width + self.size.width*.13, 0);
        side2.path = pathToDraw2;
        [side2 setStrokeColor:[UIColor greenColor]];
        [self addChild:side2];
        
        
        /* COMMENTED OUT LIVE BITCOIN PRICE FETCH */
  //         USE HARD CODED VALUE INCASE OF INTERNET PROBLEMS
      /*  _bitdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://coinbase.com/api/v1/prices/buy"]];
        NSString *bitstr = [[NSString alloc] initWithData:_bitdata encoding:NSUTF8StringEncoding];
        NSString *justprice = [bitstr substringWithRange:NSMakeRange(23,30)];
        _coinprice= [justprice floatValue];
    */
        _coinprice = 421;
        
        
        
        NSLog(@"Bitcoin Price: %i",(int)_coinprice);
        _priceLabel = [SKLabelNode labelNodeWithFontNamed:@"Georgia-Bold"];
        _priceLabel.text = [NSString stringWithFormat:@"1BTC=%iUSD",(int)_coinprice];
        _priceLabel.fontSize = self.size.width/25;
        [self addChild:_priceLabel];
        _priceLabel.zPosition = 100;
        _priceLabel.position = CGPointMake(80,7);
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    if(!_playing){
        _playing = YES;
        [_tapToStart removeFromParent];
    }
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        _lastTouchX = location.x;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        //_player.position = CGPointMake(location.x, _player.position.y);
        int newX = _player.position.x + (_lastTouchX-location.x);
        _player.position = CGPointMake(_player.position.x + (_lastTouchX-location.x), _player.position.y);
        _lastTouchX = location.x;

    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //reset last touch?
}

-(void)reset{
    [self addChild:_tapToStart];
    
    _playing = NO;
    _score = 0;
    _time = 0;
    _blocks = [[NSMutableArray alloc] init];
    _coinInUse = false;
    _coinCount = 0;
    
    _treeSpawn = CGPointMake(self.size.width/2, self.size.height*.7);
    [_coin.coinSprite removeFromParent];
}


-(void)blowUp:(SKSpriteNode*)node{
    SKAction *expand = [SKAction resizeByWidth:3*node.size.width height:3*node.size.height duration:0.2];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.15];
    SKAction *remove = [SKAction removeFromParent];
    if([node parent] != NULL)
        [node runAction:[SKAction sequence:@[expand,fadeOut,remove]]];
}


/*
 Utility method that fades in the sprite node sent to it.
 Also adds node to current scene, but only if the spritenode
 does not currenlty have a parent (safety check)
 */
-(void)fadeIn:(SKSpriteNode*)node{
    if([node parent]==NULL)
        [self addChild:node];
    node.alpha = 0.0;
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.14];
    [node runAction:[SKAction sequence:@[fadeIn]]];
}


-(void)fadeOut:(SKSpriteNode*)node{
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.14];
    SKAction *remove = [SKAction removeFromParent];
    if([node parent] != NULL)
        [node runAction:[SKAction sequence:@[fadeOut,remove]]];
}


-(void)gameOver{
    for(int i=0;i<_blocks.count;i++){
        Block *tempBlock = _blocks[i];
        SKSpriteNode *nTemp = tempBlock.blockSprite;
        [self blowUp:nTemp];
    }
    
    [self reset];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if(_playing){
        _time++;
        if(_time%10==0){
            _score = _time+_coinCount*_coinprice; //NEED A HUERISTIC FOR SCORE
            _countLabel.text = [NSString stringWithFormat:@"Time:%i, Coins:%i",(int)_time/10, (int)_coinCount];
            _scoreLabel.text = [NSString stringWithFormat:@"%i",(int)_score];
        }
        
        if((_time%5==0) && (arc4random()%4==0)){
            Tree *treeTemp = [[Tree alloc] initWithPosition:_treeSpawn andScreenSize:self.size];
            [_trees addObject:treeTemp];
            [self addChild:treeTemp.treeSprite];
        }
        
        for(int i=0;i<_trees.count;i++){
            Tree *tempTree = _trees[i];
            [tempTree update];
            if((tempTree.treeSprite.position.y<-100) || (tempTree.treeSprite.position.x<-100) || (tempTree.treeSprite.position.x>self.size.width*1.1)){
                [tempTree.treeSprite removeFromParent];
                [_trees removeObject:tempTree];
            }
        }
        
        int x = _time/1000+1;
        if(x>10){
            x=10;
        }
        BOOL createone = false;
        for(int i=0;i<x; i++){
            if(arc4random()%20==0){
                createone=true;
            }
        }
        
        if(createone){
            Block *blockTemp = [[Block alloc] initWithPosition:_treeSpawn andScreenSize:self.size];
            [_blocks addObject:blockTemp];
            [self addChild:blockTemp.blockSprite];
        }
        
        for(int i=0;i<_blocks.count;i++){
            Block *tempBlock = _blocks[i];
            if(tempBlock.blockSprite.position.y<self.size.height/3)
                if([_player intersectsNode:tempBlock.blockSprite]){
                    [self gameOver];
                }
            [tempBlock update];
            if(tempBlock.blockSprite.position.y<-100){
                [tempBlock.blockSprite removeFromParent];
                [_blocks removeObject:tempBlock];
                
            }
        }
        if(_coinInUse == false && _time%(20-(_time/5000))==0 && (arc4random()%18==0)){
            //Block *blockTemp = [[Block alloc] initWithPosition:_treeSpawn andScreenSize:self.size];
            _coin = [[Coin alloc] initWithPosition:_treeSpawn andScreenSize:self.size];
            [self addChild:_coin.coinSprite];
            _coinInUse=true;
        }
        if(_coinInUse == true && _coin.coinSprite.position.y<self.size.height/3){
            if([_player intersectsNode:_coin.coinSprite]){
                _coinCount++;
                _coinInUse = false;
                [_coin.coinSprite removeFromParent];
            }
        }
        
        if(_coinInUse == true){
            [_coin update];
            if(_coin.coinSprite.position.y<-100){
                _coinInUse = false;
                [_coin.coinSprite removeFromParent];
            }
        }
        
    }
}

@end
