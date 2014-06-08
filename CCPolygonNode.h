//
//  CCPolygonNode.h
//  EvolutionRunners
//
//  Created by Антон Домашнев on 06.06.14.
//  Copyright (c) 2014 Anton Domashnev. All rights reserved.
//

#import "CCNode.h"

@class CCTriangulator;

@interface CCPolygonNode : CCNode

@property (nonatomic, strong) CCTexture *texture;
@property (nonatomic, strong) CCTriangulator *triangulator;

- (instancetype)initWithVertices:(const CGPoint*)verts count:(NSUInteger)count andTexture:(CCTexture *) fillTexture;

@end
