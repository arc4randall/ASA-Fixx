//
//  AddNewIncomeViewController.m
//  Fixx2.0
//
//  Created by vivek soni on 21/05/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import "AddNewIncomeViewController.h"
#import "OnboardIncomeViewController.h"
#import "DBManager.h"

@interface AddNewIncomeViewController () <UITextFieldDelegate>{
    
}
@end

@implementation AddNewIncomeViewController
@synthesize incomeBoardController, popover;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.incomeObjectArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //LAYOUT ARRANGEMENT
    self.timeFrameSegmentedControl.frame = CGRectMake(self.view.frame.size.width / 12, self.view.frame.size.height / 12, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    self.timeFrameSegmentedControl.tintColor = [UIColor blackColor];
    
    self.earningAmountTextField.frame = CGRectMake(self.view.frame.size.width / 12,(self.view.frame.size.height /12) * 3, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    [self.earningAmountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.nameOfFixxTextField.frame = CGRectMake(self.view.frame.size.width / 12,(self.view.frame.size.height / 12) * 4, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    
    self.saveButton.frame = CGRectMake(self.view.frame.size.width / 12,(self.view.frame.size.height / 12) * 6, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    
    NSLog(@"The income popover is about to load...");
    // Do any additional setup after loading the view from its nib.
}

#pragma mark IBAction Method
- (IBAction)segmentedControlValueChanged:(id)sender {
    if(self.timeFrameSegmentedControl.selectedSegmentIndex == 0){
        NSLog(@"Weekly Selected");
        //Weekly cashflow formula
    } else if(self.timeFrameSegmentedControl.selectedSegmentIndex == 1){
        NSLog(@"Monthly Selected");
        //Monthly cashflow formula
    } else if (self.timeFrameSegmentedControl.selectedSegmentIndex == 2){
        NSLog(@"Yearly Selected");
        //Yearly cashflow formula
    }

}
- (IBAction)saveButtonPressed:(id)sender {

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
    NSLog(@"Saving income named: %@ with value %@ and duration %ld",self.nameOfFixxTextField.text,self.earningAmountTextField.text,(long)self.timeFrameSegmentedControl.selectedSegmentIndex);
    Income *savedIncome = [[Income alloc] init];
    savedIncome.name = self.nameOfFixxTextField.text;
    
    double amount = [self.earningAmountTextField.text doubleValue];
    if (self.incomeBoardController.isExpenseController) {
        amount = fabs(amount) * -1.0;
    } else {
        amount = fabs(amount);
    }
    savedIncome.amount = amount;
    savedIncome.duration = durationString;
    
    if ([[DBManager getSharedInstance]saveDataWithName:savedIncome.name Amount:savedIncome.amount Duration:savedIncome.duration]) {
        [self.incomeBoardController.incomeObjectArray addObject:savedIncome];
        [self.popover dismissPopoverAnimated:YES];
        [self.incomeBoardController viewWillAppear:YES];
    } else {
        NSLog(@"adding is not successful.");
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.earningAmountTextField resignFirstResponder];
    [self.nameOfFixxTextField resignFirstResponder];
}
@end
