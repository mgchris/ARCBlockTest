//
//  MGDObjectLogger.h
//  BlockMemoryChecker
//
//  Created by Christopher Evans on 7/30/14.
//  Copyright (c) 2014 Morphosis Games. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MGDObjectLoggerBlock)(void);

@interface MGDObjectLogger : NSObject
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, strong) NSData * data;
@property (nonatomic, strong) NSString* string;
@property (nonatomic, strong) id holdOnTo;
@property (nonatomic, copy) MGDObjectLoggerBlock block;

- (void)inflate;
- (void)deflate;
- (void)printSomething;
- (void)printNumber;
@end
