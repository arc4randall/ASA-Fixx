//
//  OnboardIncomeViewController.h
//  Fixx2.0
//
//  Created by vivek soni on 21/05/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebserviceHandler.h"
#import "FPPopoverKeyboardResponsiveController.h"

@interface OnboardIncomeViewController : UIViewController <UIGestureRecognizerDelegate> {
    FPPopoverKeyboardResponsiveController *popover;
    CGFloat _keyboardHeight;
}
-(instancetype)initAsExpenseController:(BOOL)expenseController NS_DESIGNATED_INITIALIZER;

@property (nonatomic, retain) IBOutlet UITableView *incomeTableView;
@property (nonatomic,strong) NSMutableDictionary* incomeExpenseDictionary;
@property  BOOL isExpenseController;

@end
