//
//  CCTriangulator.m
//  EvolutionRunners
//
//  Created by Антон Домашнев on 06.06.14.
//  Copyright (c) 2014 Anton Domashnev. All rights reserved.
//

#import "CCTriangulator.h"

#import "cocos2d.h"
#import "triangulate.h"

@implementation CCTriangulator

- (void)triangulateVertices:(const CGPoint*)vertices count:(NSUInteger)count completion:(void(^)(const CGPoint *vertices, NSUInteger count))completion
{
    Vector2dVector *inputPointsForTriangulation = new Vector2dVector;
    for(int i = 0; i < count; i++){
        CGPoint point = vertices[i];
        inputPointsForTriangulation->push_back(Vector2d(point.x, point.y));
    }
    
    Vector2dVector triangulatedPoints;
    Triangulate::Process(*inputPointsForTriangulation, triangulatedPoints);
    delete inputPointsForTriangulation;
    NSUInteger triangulatedPointCount = (NSUInteger)triangulatedPoints.size();
    
    CGPoint result[triangulatedPointCount];
    for(int i = 0; i < triangulatedPointCount; i++){
        result[i] = ccp(triangulatedPoints[i].GetX(), triangulatedPoints[i].GetY());
    }
    
    if(completion){
        completion(result, triangulatedPointCount);
    }
}

@end
