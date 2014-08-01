//
//  MGDObjectLogger.m
//  BlockMemoryChecker
//
//  Created by Christopher Evans on 7/30/14.
//  Copyright (c) 2014 Morphosis Games. All rights reserved.
//

#import "MGDObjectLogger.h"

@implementation MGDObjectLogger

- (void)inflate {
    
    NSInteger megabyteInBits = 8000000;
    NSInteger size = sizeof(u_int32_t);
    NSMutableData* theData = [NSMutableData dataWithCapacity:megabyteInBits];
    for( unsigned int i = 0 ; i < megabyteInBits / size ; ++i ) {
        u_int32_t randomBits = arc4random();
        [theData appendBytes:(void*)&randomBits length:size];
    }
    
    self.data = [theData copy];
}

- (void)deflate {
    self.data = nil;
}

- (void)printSomething {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
}

- (void)printNumber {
    NSLog(@"%s %d", __PRETTY_FUNCTION__, self.number);
}

- (void)dealloc {
    NSLog(@"MGDObjectLogger - Dealloc: %p", self);
    [self deflate];
}

@end
