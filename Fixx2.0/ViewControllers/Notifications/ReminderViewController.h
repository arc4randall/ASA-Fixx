//
//  ReminderViewController.h
//  Fixx2.0
//
//  Created by Randall Spence on 5/4/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController {
    FPPopoverKeyboardResponsiveController *popover;
    CGFloat _keyboardHeight;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
