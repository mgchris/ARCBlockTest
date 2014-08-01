//
//  MGDBaseTableViewController.h
//  BlockMemoryChecker
//
//  Created by Christopher Evans on 8/1/14.
//  Copyright (c) 2014 Morphosis Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGDHelper.h"


@interface MGDBaseTableViewController : UITableViewController

/*!
 *  The cell content needs to be structured using the BaseHelper category
 */
@property (nonatomic, strong) NSMutableArray* cellContent;

/*!
 *  Called when the cellContent needs to be populated.
 *  This instance will setup the cellContent, subclasses should call super first.
 */
- (void)buildTableViewContent;

@end

#pragma mark -
@interface NSMutableArray (BaseHelper)

- (NSString*)cellTitleForIndex:(NSInteger)index;
- (NSString*)cellDetailTextForIndex:(NSInteger)index;
- (SEL)selectorForCellForIndex:(NSInteger)index;

/*!
 *  The selector should not accept a parameter or return anything
 */
- (void)addCellItemWithTitle:(NSString*)title
              withDetailText:(NSString*)detailText
                withSelector:(SEL)selector;

@end