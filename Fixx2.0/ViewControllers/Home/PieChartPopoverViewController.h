//
//  PieChartPopoverViewController.h
//  Fixx2.0
//
//  Created by Randall Spence on 4/6/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeDashboardViewController;
@class XYPieChart;

@interface PieChartPopoverViewController : UIViewController
{
    NSArray *sliceColors;
}
@property (strong, nonatomic) HomeDashboardViewController *incomeBoardController;
@property (strong, nonatomic) FPPopoverKeyboardResponsiveController *popover;
@property (strong, nonatomic) IBOutlet UITableView *legendTableView;
@property (strong, nonatomic) NSArray *sliceColors;

- (instancetype)initWithType:(NSString*)viewType;
@end
