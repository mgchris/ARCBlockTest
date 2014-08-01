//
//  MGDQualifiersTableViewController.m
//  BlockMemoryChecker
//
//  Created by Christopher Evans on 8/1/14.
//  Copyright (c) 2014 Morphosis Games. All rights reserved.
//

#import "MGDQualifiersTableViewController.h"

@interface MGDQualifiersTableViewController ()

@end

@implementation MGDQualifiersTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Subclass
- (void)buildTableViewContent {
    [super buildTableViewContent];
    
    [self.cellContent addCellItemWithTitle:@"Example 1" withDetailText:@"Without qualifier" withSelector:@selector(example1)];
    [self.cellContent addCellItemWithTitle:@"Example 2" withDetailText:@"Like 1 but with __block" withSelector:@selector(example2)];
    [self.cellContent addCellItemWithTitle:@"Example 3" withDetailText:@"Like 1 and 2, but with __weak" withSelector:@selector(example3)];
    [self.cellContent addCellItemWithTitle:@"Example 4" withDetailText:@"Controller could be gone, when called" withSelector:@selector(example4)];
}


#pragma mark - Examples
- (void)example1 {
    
    MGDObjectLogger *logger = [[MGDObjectLogger alloc] init];
    
    MGDVoidBlock block = ^() {
        NSLog(@"In Block logger: %p", logger);
    };
    
    NSLog(@"1: logger: %p", logger);
    block();
    
    logger = [[MGDObjectLogger alloc] init];
    NSLog(@"2: logger: %p", logger);
    block();
    
    NSLog(@"Waiting...\n");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

- (void)example2 {
    
    __block MGDObjectLogger *logger = [[MGDObjectLogger alloc] init];
    
    MGDVoidBlock block = ^() {
        NSLog(@"In Block logger: %p", logger);
    };
    
    NSLog(@"1: logger: %p", logger);
    block();
    
    logger = [[MGDObjectLogger alloc] init];
    NSLog(@"2: logger: %p", logger);
    block();
    
    NSLog(@"Waiting...\n");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

- (void)example3 {
    MGDObjectLogger *logger = [[MGDObjectLogger alloc] init];
    __weak MGDObjectLogger* weakLogger = logger;
    
    MGDVoidBlock block = ^() {
        NSLog(@"In Block weak logger: %p", weakLogger);
    };
    
    NSLog(@"1: Weak logger: %p", weakLogger);
    block();
    
    logger = nil;
    NSLog(@"2: Weak logger: %p", weakLogger);
    
    NSLog(@"Waiting...\n");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

- (void)example4 {
    
    __weak MGDQualifiersTableViewController* retained = self;
    MGDVoidBlock block = ^() {
        [retained printSomething];
        NSLog(@"Done with Example 8 Block");
    };
    
    // Now leave before this block is called, and wait
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark -
- (void)printSomething {
    NSLog(@"%s %@", __PRETTY_FUNCTION__, self);
}




@end
