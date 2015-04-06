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
-(id)initAsExpenseController:(BOOL)expenseController;

@property (nonatomic,retain) IBOutlet UILabel *lblUpperText,*lblLowerText;
@property (nonatomic, retain) IBOutlet UITableView *incomeTableView;
@property (nonatomic,strong) NSMutableArray* incomeObjectArray;
@property  BOOL isExpenseController;

@end
