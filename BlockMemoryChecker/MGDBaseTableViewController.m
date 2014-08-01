//
//  MGDBaseTableViewController.m
//  BlockMemoryChecker
//
//  Created by Christopher Evans on 8/1/14.
//  Copyright (c) 2014 Morphosis Games. All rights reserved.
//

#import "MGDBaseTableViewController.h"



@implementation NSMutableArray (BaseHelper)

- (NSString*)cellTitleForIndex:(NSInteger)index {
    return self[index][@"title"];
}

- (NSString*)cellDetailTextForIndex:(NSInteger)index {
    return self[index][@"detailText"];
}

- (SEL)selectorForCellForIndex:(NSInteger)index {
    return [self[index][@"selector"] pointerValue];
}

- (void)addCellItemWithTitle:(NSString*)title
              withDetailText:(NSString*)detailText
                withSelector:(SEL)selector {
    [self addObject:@{@"title": title,
                      @"detailText": detailText,
                      @"selector": [NSValue valueWithPointer:selector]}];
}

@end



#pragma mark -

static NSString* const kMGDBaseTableViewControllerCellIdentifier = @"baseCellIdentifier";

@interface MGDBaseTableViewController ()

@end

@implementation MGDBaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildTableViewContent];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"Removed View Controller: %p", self);
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Dealloc"
                                                    message:@"Did remove View Controller!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - Table view data source
- (void)buildTableViewContent {
    self.cellContent = [NSMutableArray array];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.cellContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMGDBaseTableViewControllerCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.cellContent cellTitleForIndex:indexPath.row];
    cell.detailTextLabel.text = [self.cellContent cellDetailTextForIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL selector = [self.cellContent selectorForCellForIndex:indexPath.row];
    
    // I am a programmer and I know what I am doing.  Trussssstttt mmmmmeeeee....
    //  Ignore the warning about arc leak, wont be a problem as long as you don't return anything from this selector
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if([self respondsToSelector:selector]) {
        [self performSelector:selector];
    }
#pragma clang diagnostic pop
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
