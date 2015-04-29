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
#import "GlobalManager.h"

@interface AddNewIncomeViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {

}
@property(nonatomic, strong) UIToolbar *pickerToolBar;
@end
@implementation AddNewIncomeViewController
@synthesize incomeBoardController, popover;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.incomeObjectArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
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
    self.timeFrameSegmentedControl.frame = CGRectMake(-5,0,self.view.frame.size.width * 0.81, self.view.frame.size.height * 0.10);
    self.timeFrameSegmentedControl.tintColor = [UIColor blackColor];
    
    self.earningAmountTextField.frame = CGRectMake(self.view.frame.size.width / 12 + 15,(self.view.frame.size.height /12 - 10) * 3, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    [self.earningAmountTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.nameOfFixxTextField.frame = CGRectMake(self.view.frame.size.width / 12 + 15,(self.view.frame.size.height / 12) * 4, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    
    self.saveButton.frame = CGRectMake(self.view.frame.size.width / 12 + 15,(self.view.frame.size.height / 12) * 6, self.view.frame.size.width / 2, self.view.frame.size.height / 15);
    self.saveButton.tintColor = [UIColor blackColor];
    
    if (self.incomeBoardController.isExpenseController) {
        self.nameOfFixxTextField.placeholder = @"Expense Source";
    }
    
    self.categoryTextField.frame = CGRectMake(self.view.frame.size.width / 12 + 15,70,self.view.frame.size.width / 2, self.view.frame.size.height / 15);

    //initialize pickerview
    [self createPickerView];
    NSLog(@"The income popover is about to load...");
    // Do any additional setup after loading the view from its nib.
}
-(void) createPickerView {
    _categoryPicker = [[UIPickerView alloc] init];
    _categoryPicker.delegate = self;
    _categoryPicker.dataSource = self;
    
    _pickerToolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [_pickerToolBar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(changeFromLabel)];
    UIBarButtonItem *flexiblePlaceHolder = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    barButtonDone.tintColor=[UIColor blackColor];
    [_pickerToolBar setItems:[NSArray arrayWithObjects:flexiblePlaceHolder, barButtonDone, nil]];
    self.categoryTextField.inputAccessoryView = _pickerToolBar;
    
}
-(void)changeFromLabel{
    // do dismiss here.
    NSLog(@"done clicked");
    [self.categoryTextField resignFirstResponder];
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
    savedIncome.category = self.categoryTextField.text;
    if ([[DBManager getSharedInstance]saveDataWithName:savedIncome.name Amount:savedIncome.amount Duration:savedIncome.duration Category:savedIncome.category]) {
        [self.popover dismissPopoverAnimated:YES];
        if (self.incomeBoardController.isExpenseController) {
            self.incomeBoardController.incomeExpenseDictionary = [[DBManager getSharedInstance] returnAllByType:@"expense"];
        }else {
            self.incomeBoardController.incomeExpenseDictionary = [[DBManager getSharedInstance] returnAllByType:@"income"];
        }
        [self.incomeBoardController viewWillAppear:YES];
    } else {
        NSLog(@"adding is not successful.");
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.earningAmountTextField resignFirstResponder];
    [self.nameOfFixxTextField resignFirstResponder];
}

#pragma mark UITextField Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.categoryTextField){
        self.categoryTextField.inputView = _categoryPicker;
        self.categoryTextField.text = nil;
        
    }
    textField.placeholder = nil;
}


#pragma mark Pickerview Methods
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.incomeBoardController.isExpenseController) {
        return [[[GlobalManager sharedManager]expenseCategoryArray] count];
    } else {
        return [[[GlobalManager sharedManager]incomeCategoryArray] count];    }
    }

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.incomeBoardController.isExpenseController) {
        return [[[GlobalManager sharedManager]expenseCategoryArray] objectAtIndex:row];
    } else {
        return [[[GlobalManager sharedManager]incomeCategoryArray] objectAtIndex:row];
    }
}

//-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
//{
//    return 100;
//}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.incomeBoardController.isExpenseController){
        self.categoryTextField.text = [[GlobalManager sharedManager] expenseCategoryArray][row];
    } else {
        self.categoryTextField.text = [[GlobalManager sharedManager]incomeCategoryArray][row];
    }
}
@end
