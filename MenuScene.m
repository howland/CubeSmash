//
//  MenuScene.m
//  Cube_Smash
//
//  Created by Joshua Howland on 5/19/14.
//  Copyright (c) 2014 Shiv Pande. All rights reserved.
//

#import "MenuScene.h"
#import "SKPMyScene.h"

@interface MenuScene()

@property SKSpriteNode *backGround;
@property SKEmitterNode *snow;
@property SKSpriteNode *playButton;
@property SKSpriteNode *scoresButton;
@property SKSpriteNode *settingsButton;
@property SKSpriteNode *gameLabel;


@property SKSpriteNode *highScoreLabel;
@property SKSpriteNode *menuButton;
@property SKLabelNode *highScoreText;

@end

@implementation MenuScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        _backGround = [[SKSpriteNode alloc] initWithImageNamed:@"Background"];
        _backGround.size = CGSizeMake(self.size.width*4,self.size.height);
        _backGround.position = CGPointMake(-1*self.size.width + (int)(   arc4random()%(int)self.size.width*3     ), self.size.height/2);
        [self addChild:_backGround];
        
        //NSString *snowPath = [[NSBundle mainBundle] pathForResource:@"Snow" ofType:@"sks"];
        //_snow = [NSKeyedUnarchiver unarchiveObjectWithFile:snowPath];
        //_snow.particleSize = CGSizeMake(self.frame.size.width/20, self.frame.size.width/20);
        //_snow.alpha = 1.0f;
        //_snow.position = CGPointMake(self.size.width/2, self.size.height*1.1);
        //_snow.particleSize = CGSizeMake(self.size.width/30,self.size.width/3);
        
        //[self addChild:_snow];
        
        
        _playButton = [[SKSpriteNode alloc] initWithImageNamed:@"play"];
        _playButton.size = CGSizeMake(self.size.width*2/3, self.size.height*1/7);
        _playButton.position = CGPointMake(self.size.width/2, self.size.height*1.5/3);
        _playButton.name = @"playButton";
        //[self addChild:_playButton];
        
        _scoresButton = [[SKSpriteNode alloc] initWithImageNamed:@"scores"];
        _scoresButton.size = _playButton.size;
        _scoresButton.position = CGPointMake(_playButton.position.x, _playButton.position.y-_playButton.size.height*1.2);
        _scoresButton.name = @"scoresButton";
        
        
        _settingsButton = [[SKSpriteNode alloc] initWithImageNamed:@"settings"];
        _settingsButton.size = _playButton.size;
        _settingsButton.position = CGPointMake(_playButton.position.x, _playButton.position.y - 1.2*2*_playButton.size.height);
        _settingsButton.name = @"settingsButton";
        //[self addChild:_settingsButton];
        
        _gameLabel = [[SKSpriteNode alloc] initWithImageNamed:@"Name"];
        _gameLabel.size = CGSizeMake(1.2*_playButton.size.width, 1.2*_playButton.size.height);
        _gameLabel.position = CGPointMake(_playButton.position.x, _playButton.position.y + 1.4*_playButton.size.height);
        // [self addChild:_gameLabel];
        
        
        [self initMenu];
    }
    return self;
}


-(void)initMenu{
    if([_scoresButton parent]==NULL)
        [self addChild:_scoresButton];
    if([_settingsButton parent]==NULL)
        [self addChild:_settingsButton];
    if([_gameLabel parent ] == NULL)
        [self addChild:_gameLabel];
    if([_playButton parent]==NULL)
        [self addChild:_playButton];
}

-(void)removeMenu{
    [_scoresButton removeFromParent];
    [_settingsButton removeFromParent];
    [_playButton removeFromParent];
    //[_gameLabel removeFromParent];
}


-(void)fadeIn:(SKSpriteNode*)node{
    if([node parent]==NULL)
        [self addChild:node];
    node.alpha = 0.0;
    SKAction *fadeIn = [SKAction fadeInWithDuration:0.14];
    [node runAction:[SKAction sequence:@[fadeIn]]];
    
    
}


-(void)fadeOut:(SKSpriteNode*)node{
    //node.alpha = 0.0;
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.14];
    SKAction *remove = [SKAction removeFromParent];
    if([node parent] != NULL)
        [node runAction:[SKAction sequence:@[fadeOut,remove]]];
}



-(void)displayScores{
    // @property SKSpriteNode *highScoreLabel;
    // @property SKSpriteNode *menuButton;
    
    _highScoreLabel = [[SKSpriteNode alloc] initWithImageNamed:@"highScoreButton"];
    _highScoreLabel.size = _scoresButton.size;
    _highScoreLabel.position = _playButton.position;
    
    _menuButton = [[SKSpriteNode alloc] initWithImageNamed:@"Menu"];
    _menuButton.size = _scoresButton.size;
    _menuButton.position = _scoresButton.position;
    _menuButton.name = @"menuButton";
    
    
    
    
    
    int highScoreTemp = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    
    _highScoreText = [[SKLabelNode alloc] initWithFontNamed:@"AvenirNext-Heavy"];
    _highScoreText.text = [NSString stringWithFormat:@"%i",(int)highScoreTemp];
    _highScoreText.fontSize = self.frame.size.width/8;
    // _highScoreLabel.zPosition  = 100;
    _highScoreText.position = CGPointMake(_highScoreLabel.position.x*1.35,0.95*_highScoreLabel.position.y);
    _highScoreText.fontColor = [UIColor colorWithRed:58/255.f green:198/255.f blue:239/255.f alpha:1];
    
    [self addChild:_highScoreLabel];
    [self addChild:_menuButton];
    [self addChild:_highScoreText];
    
}


-(void)removeScoresDisplay{
    if([_highScoreLabel parent]==NULL)
        [_highScoreLabel removeFromParent];
    if([_menuButton parent]==NULL)
        [_menuButton removeFromParent];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    //for (UITouch *touch in touches) {
    SKNode *na1 = [self nodeAtPoint:location];
    if([na1.name isEqualToString:@"playButton"]){
        SKPMyScene *gameScene = [[SKPMyScene alloc] initWithSize:self.size];
        [self.view presentScene:gameScene transition:[SKTransition fadeWithColor:[UIColor clearColor] duration:1.0f]];
    }else if([na1.name isEqualToString:@"scoresButton"]){
        [self removeMenu];
        [self displayScores];
    }else if([na1.name isEqualToString:@"menuButton"]){
        [self removeScoresDisplay];
        [self initMenu];
    }
    
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
}

@end
