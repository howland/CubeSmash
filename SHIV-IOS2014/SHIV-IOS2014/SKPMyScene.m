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

@interface SKPMyScene()

@property int time;
@property int score;
@property BOOL playing;
@property SKSpriteNode *player;
@property NSMutableArray *blocks;
@property NSMutableArray *trees;
@property CGPoint treeSpawn;

@property int lastTouchX;

@property SKLabelNode *tapToStart;
@property SKLabelNode *scoreLabel;

@end

@implementation SKPMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        
       // _player = [[SKSpriteNode alloc] initWithImageNamed:@"PlayerImage"];
        _player = [[SKSpriteNode alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(self.size.width/20, self.size.width/20)];
       // _player.size = CGSizeMake(self.size.width/20, self.size.width/20);
        _player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_player.size];
        _player.name = @"Player";
        [self addChild:_player];
        
        _tapToStart = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _tapToStart.text = @"Tap To Start!";
        _tapToStart.fontSize = self.size.width/10;
        _tapToStart.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        _scoreLabel.text = [NSString stringWithFormat:@"%i",(int)_score];
        _scoreLabel.fontSize = self.size.width/10;

        [self addChild:_scoreLabel];
        _scoreLabel.zPosition = 100;
        
        _trees = [[NSMutableArray alloc] init];
        
        [self reset];
        
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
        
        
        /*
         SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"IMG_3733.jpg"];
         
         CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
         CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
         
         CGMutablePathRef path = CGPathCreateMutable();
         
         CGPathMoveToPoint(path, NULL, 112 - offsetX, 1583 - offsetY);
         CGPathAddLineToPoint(path, NULL, 148 - offsetX, 1516 - offsetY);
         CGPathAddLineToPoint(path, NULL, 78 - offsetX, 1514 - offsetY);
         
         CGPathCloseSubpath(path);
         
         sprite.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
         
         */
        
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
        
        //SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        //sprite.position = location;
        
        //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        //[sprite runAction:[SKAction repeatActionForever:action]];
        
        //[self addChild:sprite];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        int dp = location.x -_lastTouchX;
        double tol = 0.1;
        if(dp<0){
            if(_player.position.x>self.size.width*tol){
                _player.position = CGPointMake(_player.position.x + dp, _player.position.y);

            }
        }else{
            if(_player.position.x<self.size.width*(1-tol)){
                _player.position = CGPointMake(_player.position.x + dp, _player.position.y);
                
            }
        }
        _lastTouchX = location.x;

    }
}

-(void)reset{
    [self addChild:_tapToStart];
    
    _playing = NO;
    _score = 0;
    _time = 0;
    _player.position = CGPointMake(self.size.width/2, ((int)self.size.height*.2));
    _scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame),self.size.height*4/5);
    _blocks = [[NSMutableArray alloc] init];
    
    _treeSpawn = CGPointMake(self.size.width/2, self.size.height*.7);
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

/*
 Utility method that fades out the sprite node sent to it.
 Removes the node from the scene after its fading action
 has terminated.  For safety, it only fades node out if
 node has a parent.  If node does not have a parent, it is
 not possible for it to be visible in scene, so fading out is
 not nessescary.
 */
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
        _score = _time; //NEED A HUERISTIC FOR SCORE
        if(_time%10==0)
            _scoreLabel.text = [NSString stringWithFormat:@"%i",(int)_score];
        
        //if(((int)arc4random()%5)==0){
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
        //if(((int)arc4random()%8)==0){
        if((_time%((20-(_time/5000.0))==0) && (arc4random()%8==0))){
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
    }
}

@end
