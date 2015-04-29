//
//  OnboardIncomeViewController.m
//  Fixx2.0
//
//  Created by vivek soni on 21/05/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import "OnboardIncomeViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "AddNewIncomeViewController.h"
#import "DeleteIncomeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "FPPopoverView.h"
#import "FPPopoverController.h"
#import "Income.h"
#import "IETableViewCell.h"

@interface OnboardIncomeViewController () <UITableViewDelegate, UITableViewDataSource, FPPopoverControllerDelegate> {
    NSMutableArray *arrIncome;
    UIButton *btnSliderLeft;
    AddNewIncomeViewController *objAddNewIncomeViewController;
    DeleteIncomeViewController *objDeleteIncomeViewController;
}

@end

@implementation OnboardIncomeViewController

//- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//        
//    }
//    return self;
//}

-(instancetype)initAsExpenseController:(BOOL)expenseController
{
    self = [super init];
    if (self) {
        _isExpenseController = expenseController;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.incomeTableView.layer.borderWidth = 2.0;
    
    [self prepareLayout];
    [self trackEvent:[WTEvent eventForScreenView:@"Income Onboarding" eventDescr:@"List Of Incomes." eventType:@"" contentGroup:@""]];
    // Do any additional setup after loading the view from its nib.
    
    
    self.incomeTableView.delegate = self;
    self.incomeTableView.dataSource = self;
    
}

- (void)presentedNewPopoverController:(FPPopoverController *)newPopoverController
          shouldDismissVisiblePopover:(FPPopoverController*)visiblePopoverController
{
    [visiblePopoverController dismissPopoverAnimated:YES];
}

-(IBAction)addIncome:(id)sender
{
    NSLog(@"Add Income Pressed");
    
    SAFE_ARC_RELEASE(popover); popover = nil;
    
    //the controller we want to present as a popover
    objAddNewIncomeViewController = [[AddNewIncomeViewController alloc] init];
    objAddNewIncomeViewController.title = nil;
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:objAddNewIncomeViewController];
    popover.tint = FPPopoverDefaultTint;
    popover.keyboardHeight = _keyboardHeight;
    
    popover.border = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.80);
    }
    else {
        popover.contentSize = CGSizeMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.80);
    }
        popover.arrowDirection = FPPopoverNoArrow;
    
        [popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.center.y - popover.contentSize.height * 0.9)];
        objAddNewIncomeViewController.incomeBoardController = self;
    objAddNewIncomeViewController.popover = popover;
    NSLog(@"Popover should appear here...");
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UIBarButtonItem *addIncomeButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                        target:self
                                        action:@selector(addIncome:)];
    
    self.navigationItem.rightBarButtonItem = addIncomeButton;

    
    [self.incomeTableView reloadData];
    NSLog(@"Tableview should have loaded");
}

- (void) prepareLayout {
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    btnSliderLeft=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnSliderLeft setFrame:CGRectMake(0, 5, 28, 28)];
    [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-hover.png"] forState:UIControlStateHighlighted];
    [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
    [btnSliderLeft addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [btnSliderLeft setSelected:NO];
    [btnSliderLeft setBackgroundColor:[UIColor clearColor]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [btnSliderLeft setHidden:NO];
    }else
    {
        [btnSliderLeft setHidden:YES];
    }
    
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnSliderLeft];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
            [self performSelector:@selector(nowHide) withObject:Nil afterDelay:0.1f];
        
    }
    
    // Add custom label to show title on navigation bar
    UIImageView *titleLogo=[[UIImageView alloc]init];
    [titleLogo setFrame:CGRectMake(0, 10, 58, 24)];
    [titleLogo setBackgroundColor:[UIColor clearColor]];
    titleLogo.contentMode = UIViewContentModeScaleAspectFit;
    [titleLogo setImage:[UIImage imageNamed:@"top_logo.png"]];
    [self.navigationItem setTitleView:titleLogo];

}

-(void)leftDrawerButtonPress:(id)sender{
    if(btnSliderLeft.selected)
    {
        [btnSliderLeft setSelected:NO];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-hover.png"] forState:UIControlStateHighlighted];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
    }else{
        [btnSliderLeft setSelected:YES];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-hover.png"] forState:UIControlStateHighlighted];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
    }
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)nowHide
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableDictionary *)sortDictionary:(NSMutableDictionary *)originalDictionary{
    NSMutableDictionary *sortedDictionary = [[NSMutableDictionary alloc]init];
    NSArray* sortedKeys = [[originalDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (NSString* currentKey in sortedKeys) {
        NSMutableArray *currentArray = (NSMutableArray *)[originalDictionary objectForKey:currentKey];
        [sortedDictionary setObject: [currentArray sortedArrayUsingSelector:@selector(compare:)] forKey:currentKey];
    }
    return sortedDictionary;
}
#pragma mark UITableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getCurrentItemsArrayFromIndexPath:section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (int)[[self.incomeExpenseDictionary allKeys] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IETableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"IECell"];
    if (cell == nil) {
        cell = [[IETableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"IECell"];
    }
    
    Income *income = (Income *)[self getCurrentItemsArrayFromIndexPath:indexPath.section][indexPath.row];
    cell.nameLabel.text = income.name;
    cell.valueLabel.text = [NSString stringWithFormat:@"%.2f", fabs(income.amount)];
    cell.durationLabel.text = income.duration;
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSArray* sectionArray = [self.incomeExpenseDictionary allKeys];
    return [sectionArray objectAtIndex:section];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected cell at position %ld",(long)indexPath.row);
    
    SAFE_ARC_RELEASE(popover); popover = nil;
    
    //the controller we want to present as a popover
    
    Income* selectedIncome = [self getCurrentItemsArrayFromIndexPath:indexPath.section][indexPath.row];
    objDeleteIncomeViewController = [[DeleteIncomeViewController alloc] initWithIncomeSource:selectedIncome.name value:selectedIncome.amount duration:selectedIncome.duration category:selectedIncome.category];
    objDeleteIncomeViewController.title = nil;
    
    NSLog(@"%@ has value of %f for time period %@",selectedIncome.name,selectedIncome.amount,selectedIncome.duration);

    objDeleteIncomeViewController.incomeSourceTextField.text = selectedIncome.name;
    objDeleteIncomeViewController.incomeValueTextField.text = [NSString stringWithFormat:(@"%.2f"),fabs(selectedIncome.amount)];
    objDeleteIncomeViewController.incomeObj = selectedIncome;
    
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:objDeleteIncomeViewController];
    popover.tint = FPPopoverDefaultTint;
    popover.keyboardHeight = _keyboardHeight;
    
    popover.border = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        popover.contentSize = CGSizeMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.80);
    }
    else {
        popover.contentSize = CGSizeMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.80);
    }
    popover.arrowDirection = FPPopoverNoArrow;
    
    [popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.center.y - popover.contentSize.height * 0.9)];
    objDeleteIncomeViewController.incomeBoardController = self;
    objDeleteIncomeViewController.popover = popover;
    
    NSLog(@"Popover should appear here...");
    
}
-(NSMutableArray *)getCurrentItemsArrayFromIndexPath:(NSInteger)section {
    NSString *currentKey = [[self.incomeExpenseDictionary allKeys] objectAtIndex:section];
    NSMutableArray *itemsArray = [self.incomeExpenseDictionary objectForKey:currentKey];
    return itemsArray;
}

@end
