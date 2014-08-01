//
//  MGDMemoryRetainViewController.m
//  BlockMemoryChecker
//
//  Created by Christopher Evans on 7/30/14.
//  Copyright (c) 2014 Morphosis Games. All rights reserved.
//

#import "MGDMemoryRetainTableViewController.h"

@interface MGDMemoryRetainTableViewController ()
@property (nonatomic, assign) BOOL isRetained;
@property (nonatomic, copy) MGDVoidBlock example1Block;
@property (nonatomic, copy) MGDVoidBlock example3Block;

@property (nonatomic, strong) UIView* example4View;

@property (nonatomic, strong) MGDObjectLogger* example5Logger;
@end

@implementation MGDMemoryRetainTableViewController

- (void)buildTableViewContent {
    [super buildTableViewContent];
    
    [self.cellContent addCellItemWithTitle:@"Example 1" withDetailText:@"Will cause a strong reference" withSelector:@selector(example1)];
    [self.cellContent addCellItemWithTitle:@"Example 2" withDetailText:@"Click cell and quickly and go back and wait 4 seconds" withSelector:@selector(example2)];
    [self.cellContent addCellItemWithTitle:@"Example 3" withDetailText:@"Strong reference, but will get broken" withSelector:@selector(example3)];
    [self.cellContent addCellItemWithTitle:@"Example 4" withDetailText:@"Play with UIView animation block" withSelector:@selector(example4)];
    [self.cellContent addCellItemWithTitle:@"Example 5" withDetailText:@"Create strong reference between objects" withSelector:@selector(example5)];
    [self.cellContent addCellItemWithTitle:@"Example 6" withDetailText:@"Block inside of blocks" withSelector:@selector(example6)];
    [self.cellContent addCellItemWithTitle:@"Example 7" withDetailText:@"Nearly same as 6, but does do a strong reference" withSelector:@selector(example7)];
    
}

#pragma mark - Examples
- (void)example1 {
    // Strong reference.  Why?
    
    if(self.example1Block == nil) {
        self.example1Block = ^() {
            // Notice: Get a nice little warning from Xcode
            self.isRetained = YES;  // Why is this never broken?  Hint: exampleBlock1
        };
    }
    
    self.example1Block();
}

- (void)example2 {
    // No strong reference.  Why?
    
    MGDVoidBlock block = ^() {
        self.isRetained = YES;  // Why does it eventually broken in the future?  Hint: dispatch_after
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

- (void)example3 {
    // Will cause strong reference, but will be broken.  Why?
    if(self.example3Block == nil) {
        self.example3Block = ^() {
            self.isRetained = YES;  // Hint: viewDidDisappear.
        };
    }
    
    self.example3Block();
}

- (void)example4 {
    // Might cause strong reference.  Why?
    
    self.example4View = [[UIView alloc] initWithFrame:(CGRect){self.view.center, {64, 64}}];
    self.example4View.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.example4View];
    
    
    // Note: This is long because I want to be pedantic.
    //  What happens if you tap more than once, when the animation is running?  Why?
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.example4View.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              self.example4View.center = CGPointMake(0,
                                                                                     self.view.center.y);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.5
                                                               animations:^{
                                                                   self.example4View.center = CGPointMake(self.view.frame.size.width,
                                                                                                          self.view.center.y);
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:0.5
                                                                                    animations:^{
                                                                                        self.example4View.center = self.view.center;
                                                                                    }
                                                                                    completion:^(BOOL finished) {
                                                                                        [UIView animateWithDuration:0.5
                                                                                                         animations:^{
                                                                                                             self.example4View.alpha = 0.0f;
                                                                                                         }
                                                                                                         completion:^(BOOL finished) {
                                                                                                             [self.example4View removeFromSuperview];
                                                                                                             self.example4View = nil;
                                                                                                         }];
                                                                                    }];
                                                               }];
                                              
                                          }];
                     }];
}

- (void)example5 {
    // Will cause strong reference.  Why?
    
    MGDVoidBlock block = ^() {
        MGDObjectLogger *logger = [[MGDObjectLogger alloc] init];
        logger.holdOnTo = self;
        self.example5Logger = logger;
    };
    
    block();
}

- (void)example6 {
    // No strong reference.  Why?
    
    MGDVoidBlock block = ^() {
        MGDObjectLogger *logger = [[MGDObjectLogger alloc] init];
        logger.block = ^() {
            NSLog(@"Logger block print viewController: %p", self);
        };
        
        logger.block();
        NSLog(@"Almost done with example 6");
    };
    
    block();
}

- (void)example7 {
    // Will cause strong reference.  Why?
    
    MGDVoidBlock block = ^() {
        MGDObjectLogger *logger = [[MGDObjectLogger alloc] init];
        logger.block = ^() {
            NSLog(@"Logger: %p and viewController: %p", logger, self);
        };
        
        logger.block();
    };
    
    block();
}

#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // For example 4
    self.example4View.center = CGPointMake(1000, 1000);
    self.example4View.alpha = 0.0f;
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // for example 3
    self.example3Block = nil;
}


@end
