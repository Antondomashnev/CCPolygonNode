//
//  CCPolygonNode.m
//  EvolutionRunners
//
//  Created by Антон Домашнев on 06.06.14.
//  Copyright (c) 2014 Anton Domashnev. All rights reserved.
//

#import "CCPolygonNode.h"

#import "cocos2d.h"
#import "CCTexture_Private.h"
#import "CCTriangulator.h"

@interface CCPolygonNode (){
    int _areaTrianglePointCount;
	ccBlendFunc _blendFunc;
	ccVertex2F *_areaTrianglePoints;
	ccVertex2F *_textureCoordinates;
}

- (void)calculateTextureCoordinates;

@end

@implementation CCPolygonNode

- (instancetype)initWithVertices:(const CGPoint*)verts count:(NSUInteger)count andTexture:(CCTexture *)fillTexture
{
    if(self = [super init]){
		
        self.triangulator = [CCTriangulator new];
        [self setVertices:verts count:count];
		self.texture = fillTexture;
        _shaderProgram = [[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTexture];
	}
	
	return self;
}

- (void)dealloc
{
	free(_areaTrianglePoints);
	free(_textureCoordinates);
    _texture = nil;
    _triangulator = nil;
}

#pragma mark - Properties

- (void)setBlendFunc:(ccBlendFunc)blendFuncIn
{
	_blendFunc = blendFuncIn;
}

- (ccBlendFunc)blendFunc
{
	return _blendFunc;
}

- (void)setTexture:(CCTexture *)texture
{
	// accept texture==nil as argument
	NSAssert(!_texture || [_texture isKindOfClass:[CCTexture class]], @"setTexture expects a CCTexture. Invalid argument");
	
	_texture = texture;
	ccTexParams texParams = {GL_NEAREST, GL_NEAREST, GL_REPEAT, GL_REPEAT};
	[texture setTexParameters: &texParams];
	[self updateBlendFunc];
	[self calculateTextureCoordinates];
}

#pragma mark - Helpers

- (void)setVertices:(const CGPoint*)verts count:(NSUInteger)count
{
    if(_areaTrianglePoints){
        free(_areaTrianglePoints);
    }
    if(_textureCoordinates){
        free(_textureCoordinates);
    }
    
    __weak CCPolygonNode *weakNode = self;
    [_triangulator triangulateVertices:verts count:count completion:^(const CGPoint *vertices, NSUInteger count) {
        _areaTrianglePointCount = count;
        _areaTrianglePoints = (ccVertex2F *) malloc(sizeof(ccVertex2F) * _areaTrianglePointCount);
        _textureCoordinates = (ccVertex2F *) malloc(sizeof(ccVertex2F) * _areaTrianglePointCount);
        for (int i = 0; i < _areaTrianglePointCount; i++) {
            _areaTrianglePoints[i] = (ccVertex2F) { vertices[i].x, vertices[i].y };
        }
        [weakNode calculateTextureCoordinates];
    }];
}

- (void)calculateTextureCoordinates
{
    for (int i = 0; i < _areaTrianglePointCount; i++) {
        GLfloat scale = 1. / _texture.pixelWidth * [CCDirector sharedDirector].contentScaleFactor;
        _textureCoordinates[i] = (ccVertex2F) { _areaTrianglePoints[i].x * scale, _areaTrianglePoints[i].y * scale };
        _textureCoordinates[i].y = 1 - _textureCoordinates[i].y;
    }
}

#pragma mark - Draw

-(void) draw
{
    CC_NODE_DRAW_SETUP();
    
    ccGLBindTexture2D([_texture name]);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    ccGLBlendFunc(_blendFunc.src, _blendFunc.dst);
    
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position | kCCVertexAttribFlag_TexCoords );
    
    glVertexAttribPointer(kCCVertexAttrib_Position, 2, GL_FLOAT, GL_FALSE, 0, _areaTrianglePoints);
    glVertexAttribPointer(kCCVertexAttrib_TexCoords, 2, GL_FLOAT, GL_FALSE, 0, _textureCoordinates);
    
    glDrawArrays(GL_TRIANGLES, 0, _areaTrianglePointCount);
}

- (void)updateBlendFunc
{
	if( !_texture || ! [_texture hasPremultipliedAlpha] ) {
		_blendFunc.src = GL_SRC_ALPHA;
		_blendFunc.dst = GL_ONE_MINUS_SRC_ALPHA;
		//[self setOpacityModifyRGB:NO];
	} else {
		_blendFunc.src = CC_BLEND_SRC;
		_blendFunc.dst = CC_BLEND_DST;
		//[self setOpacityModifyRGB:YES];
	}
}

@end
