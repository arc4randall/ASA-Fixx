//
//  DeleteIncomeViewController.m
//  Fixx2.0
//
//  Created by Randall Spence on 3/30/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "DeleteIncomeViewController.h"
#import "Income.h"
#import "DBManager.h"

@interface DeleteIncomeViewController ()

@end

@implementation DeleteIncomeViewController
@synthesize incomeBoardController, incomeObj, popover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.incomeObjectArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithIncomeSource:(NSString*)source value:(double)value duration:(NSString*)duration
{
    self = [super init];
    if (self) {
        [self viewDidLoad];
        self.incomeSourceTextField.text = source;
        self.incomeValueTextField.text = [NSString stringWithFormat:@"%.2f",fabs(value)];
        
        if ([duration  isEqual: @"Weekly"]) {
            self.timeFrameSegmentedControl.selectedSegmentIndex = 0;
        } else if ([duration isEqualToString:@"Monthly"]){
            self.timeFrameSegmentedControl.selectedSegmentIndex = 1;
        } else if ([duration isEqualToString:@"Yearly"]){
            self.timeFrameSegmentedControl.selectedSegmentIndex = 2;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.timeFrameSegmentedControl.frame = CGRectMake(self.view.frame.size.width / 12, self.view.frame.size.height / 12, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    self.timeFrameSegmentedControl.tintColor = [UIColor blackColor];
    
    self.incomeValueTextField.frame = CGRectMake(self.view.frame.size.width / 12,(self.view.frame.size.height /12) * 3, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    [self.incomeValueTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.incomeSourceTextField.frame = CGRectMake(self.view.frame.size.width / 12,(self.view.frame.size.height / 12) * 4, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    
    self.saveButton.frame = CGRectMake(self.view.frame.size.width * 0.3333333,(self.view.frame.size.height / 12) * 6, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    
    self.deleteButton.frame = CGRectMake(self.view.frame.size.width * -0.1,(self.view.frame.size.height / 12) * 6, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    NSLog(@"X: %f Y: %f Width: %f Height: %f ",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    
    NSLog(@"save x: %f del x: %f",self.saveButton.frame.origin.x,self.deleteButton.frame.origin.x);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteButtonPressed:(id)sender {
    if ([[DBManager getSharedInstance] deleteByID:self.incomeObj]) {
        NSLog(@"DELETE INCOMEOBJ: %@",self.incomeObj);
        NSLog(@"DELETE UPDATE SHOULD HAVE WORKED");
        [self reloadTableDismissCurrent];
    }
}

- (IBAction)saveButtonPressed:(id)sender {
    self.incomeObj.name = self.incomeSourceTextField.text;
    if (self.incomeBoardController.isExpenseController) {
        self.incomeObj.amount = fabs([self.incomeValueTextField.text doubleValue]) * -1.0;
    } else {
        self.incomeObj.amount = fabs([self.incomeValueTextField.text doubleValue]);
    }
    
    NSString* durationString = [[NSString alloc] init];
    switch (self.timeFrameSegmentedControl.selectedSegmentIndex) {
        case 0:
            durationString = @"Weekly";
            break;
        case 1:
            durationString = @"Monthly";
            break;
        case 2:
            durationString = @"Yearly";
            break;
    }
    self.incomeObj.duration = durationString;
    if ([[DBManager getSharedInstance]updateByID:self.incomeObj]) {
        [self reloadTableDismissCurrent];
    }
}
-(void) reloadTableDismissCurrent {
    if (self.incomeBoardController.isExpenseController) {
        self.incomeBoardController.incomeObjectArray = [[DBManager getSharedInstance] getAllExpense];
    } else {
        self.incomeBoardController.incomeObjectArray = [[DBManager getSharedInstance]getAllIncome];
    }
    [self.incomeBoardController viewWillAppear:YES];
    //[self.view.superview removeFromSuperview];
    [self.popover dismissPopoverAnimated:YES];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.incomeValueTextField resignFirstResponder];
    [self.incomeSourceTextField resignFirstResponder];
}
@end
