//
//  CCTriangulator.h
//  EvolutionRunners
//
//  Created by Антон Домашнев on 06.06.14.
//  Copyright (c) 2014 Anton Domashnev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCTriangulator : NSObject

- (void)triangulateVertices:(const CGPoint*)vertices count:(NSUInteger)count completion:(void(^)(const CGPoint *vertices, NSUInteger count))completion;

@end
