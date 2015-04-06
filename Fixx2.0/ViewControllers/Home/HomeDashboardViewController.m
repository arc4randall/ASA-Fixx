//
//  HomeDashboardViewController.m
//  Fixx2.0
//
//  Created by vivek soni on 24/05/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import "HomeDashboardViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "CustomAlertView.h"
#import "AppLoader.h"
#import "XYPieChart.h"
#import "DBManager.h"
#import "Income.h"

@interface HomeDashboardViewController () {
    CustomAlertView *alertView;
    AppLoader *appLoader;
    UIButton *btnSliderLeft;
    NSMutableArray* incomeObjectArray;
    NSMutableArray* expenseObjectArray;
}

@end

@implementation HomeDashboardViewController
@synthesize incomeObjectArray;
@synthesize expenseObjectArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareLayout];
    [self trackEvent:[WTEvent eventForScreenView:@"Home Dashboard" eventDescr:@"Landing On screen" eventType:@"" contentGroup:@""]];
    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.slices = [[NSMutableArray alloc] init];
    self.timeFrameSegmentedControl.tintColor = [UIColor blackColor];
    
    // XYPieChart Setup
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor redColor],
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor blueColor],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor greenColor],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor purpleColor],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor orangeColor],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    
    if (!_incomePieChart)
    {
        //Alloc + Init XYPieChart
        self.incomePieChart = [[XYPieChart alloc] initWithFrame:self.incomePieChartView.frame Center:CGPointMake(screenWidth / 4, screenHeight - screenWidth/4) Radius:screenWidth/5];
        [self.incomePieChart setDelegate:self];
        [self.incomePieChart setDataSource:self];
        [self.incomePieChart setStartPieAngle:M_PI_2];
        [self.incomePieChart setAnimationSpeed:1.0];
        
        self.incomeObjectArray = [[DBManager getSharedInstance] getAllIncome];
        self.slices = [[NSMutableArray alloc] init];
        
        for(Income* income in self.incomeObjectArray)
        {
            NSNumber *one = [NSNumber numberWithInt:income.amount];
            [_slices addObject:one];
        }
        [self.incomePieChart reloadData];
    }
    if (!_expensePieChart)
    {
        //Alloc + Init XYPieChart
        self.expensePieChart = [[XYPieChart alloc] initWithFrame:self.expensePieChartView.frame Center:CGPointMake((screenWidth / 4) * 3, screenHeight - screenWidth/4) Radius:screenWidth/5];
        [self.expensePieChart setDelegate:self];
        [self.expensePieChart setDataSource:self];
        [self.expensePieChart setStartPieAngle:M_PI_2];
        [self.expensePieChart setAnimationSpeed:1.0];
        
        self.expenseObjectArray = [[DBManager getSharedInstance] getAllExpense];
        self.slices = [[NSMutableArray alloc] init];
        
        for(Income* income in self.expenseObjectArray)
        {
            NSNumber *one = [NSNumber numberWithInt:income.amount];
            [_slices addObject:one];
        }
        [self.expensePieChart reloadData];
    }
    [self.navigationController.view addSubview:_incomePieChart];
    [self.navigationController.view addSubview:_expensePieChart];
    
    self.incomePieChart.userInteractionEnabled = YES;
    self.expensePieChart.userInteractionEnabled = YES;
    self.incomePieChartView.userInteractionEnabled = YES;
    self.expensePieChartView.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *genericGraphTap = [[UITapGestureRecognizer alloc]
//                                               initWithTarget:self action:@selector(handleGesture:)];
//    [self.navigationController.view addGestureRecognizer:genericGraphTap];
    
    appDelegate.sectionSelect = 0;
    
}

-(void)viewWillAppear:(BOOL)animated{
    animated = NO;
    
    double totalIncome = 0.0;
    for (Income* income in self.incomeObjectArray) {
        float multiplier = 1;
        if ([income.duration isEqualToString:@"Weekly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 1) {
            multiplier = 4;
        } else if ([income.duration isEqualToString:@"Weekly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 2) {
            multiplier = 52;
        } else if ([income.duration isEqualToString:@"Monthly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 0) {
            multiplier = 0.25;
        } else if ([income.duration isEqualToString:@"Monthly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 2) {
            multiplier = 12;
        } else if ([income.duration isEqualToString:@"Yearly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 0) {
            multiplier = (1.0/52.0);
        } else if ([income.duration isEqualToString:@"Yearly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 1) {
            multiplier = (1.0 / 12.0);
        }
        totalIncome += income.amount * multiplier;
    }
    self.lblEarnValue.text = [NSString stringWithFormat:@"$%.2f",totalIncome];
    
    double totalExpense = 0.0;
    for (Income* expense in self.expenseObjectArray) {
        float multiplier = 1;
        if ([expense.duration isEqualToString:@"Weekly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 1) {
            multiplier = 4;
        } else if ([expense.duration isEqualToString:@"Weekly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 2) {
            multiplier = 52;
        } else if ([expense.duration isEqualToString:@"Monthly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 0) {
            multiplier = 0.25;
        } else if ([expense.duration isEqualToString:@"Monthly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 2) {
            multiplier = 12;
        } else if ([expense.duration isEqualToString:@"Yearly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 0) {
            multiplier = (1.0/52.0);
        } else if ([expense.duration isEqualToString:@"Yearly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 1) {
            multiplier = (1.0 / 12.0);
        }
        totalExpense += expense.amount * multiplier;
    }
    double avgBalance = totalIncome + totalExpense;
    self.lblSpendValue.text = [NSString stringWithFormat:@"$%.2f",fabs(totalExpense)];
    
    self.lblAvgBalance.text = [NSString stringWithFormat:@"$%.2f",avgBalance];
}

- (void) prepareLayout {
    [appDelegate.objNavController setNavigationBarHidden:NO animated:YES];
    
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
    
    alertView = [CustomAlertView initAlertView];
    
    appLoader = [AppLoader initLoaderView];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    animated = NO;
    [_slices removeAllObjects];
    [self.incomePieChart reloadData];
    [self.expensePieChart reloadData];
    [self.incomePieChartView removeFromSuperview];
    [self.expensePieChartView removeFromSuperview];
}

-(void)leftDrawerButtonPress:(id)sender{
    if(btnSliderLeft.selected)
    {
        [btnSliderLeft setSelected:NO];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-hover.png"] forState:UIControlStateHighlighted];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
    }else
    {
        [btnSliderLeft setSelected:YES];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-hover.png"] forState:UIControlStateHighlighted];
        [btnSliderLeft setImage:[UIImage imageNamed:@"icon-list-normal.png"] forState:UIControlStateNormal];
    }
    
    NSLog(@"drawer left: %@",self.mm_drawerController);
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)nowHide
{
    NSLog(@"Now Hide...");
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
}

#pragma mark - Webservice
- (void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    //NSLog(@"login reponse %@",dicResponse);
    [appLoader stopActivityLoader];
    
    if ([dicResponse objectForKey:@"Error"]) {
        [alertView displayAlertViewWithView:self.view withTitle:@"Failed!" withMessage:[ [dicResponse objectForKey:@"Error" ] objectForKey:@"message"]withButtonTitle:@"OK" withOtherButtonTitle:Nil];
    } else if ([[dicResponse objectForKey:@"status"] integerValue] == 200 && [dicResponse objectForKey:@"Informational"]) {
        NSMutableArray *arrAllTipsNotifications = [[NSMutableArray alloc] init];
        NSMutableArray *arrActionable = [dicResponse objectForKey:@"Actionable"];
        NSMutableArray *arrInformational = [dicResponse objectForKey:@"Informational"];
        //Add all Actionable and Informational
        for (int i=0; i<[arrActionable count]; i++) {
            NSMutableDictionary *tmp = [arrActionable objectAtIndex:i];
            [tmp setValue:@"Actionable" forKey:@"type"];
            [arrActionable replaceObjectAtIndex:i withObject:tmp];
            [arrAllTipsNotifications addObject:[arrActionable objectAtIndex:i]];
        }
        for (int i=0; i<[arrInformational count]; i++) {
            NSMutableDictionary *tmp = [arrInformational objectAtIndex:i];
            [tmp setValue:@"Informational" forKey:@"type"];
            [arrInformational replaceObjectAtIndex:i withObject:tmp];
            [arrAllTipsNotifications addObject:[arrInformational objectAtIndex:i]];
        }
        
        if ([arrAllTipsNotifications count]!=0) {
            //Display Highest Tips
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority"
                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *sortedArray;
            sortedArray = [arrAllTipsNotifications sortedArrayUsingDescriptors:sortDescriptors];
            arrAllTipsNotifications = [NSMutableArray arrayWithArray:sortedArray];
        }
            if ([[dicResponse objectForKey:@"status"] integerValue] == 200 && [dicResponse objectForKey:@"summary"]) {
          [self performSelector:@selector(callWebService_GetHighestPriorityTip) withObject:nil afterDelay:0.0];
            }
        if (![[dicResponse objectForKey:@"summary"] isEqual:[NSNull null]] && [[dicResponse objectForKey:@"summary"] count]!=0) {
    
            
        } else {
            [alertView displayAlertViewWithView:self.view withTitle:@"Fixx" withMessage:@"Summary not available for this period" withButtonTitle:@"OK" withOtherButtonTitle:@""];
           //ShowAlert(@"Fixx", @"Summary not available for this period")
        }
    }
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    //self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];

}

#pragma mark - UIGestureRecognizers

- (void)handleGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.navigationController.view];
    NSLog(@"Selected point at: %@",NSStringFromCGPoint(p));
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //CGRect incomeRect = CGRectMake(0, screenHeight - (screenWidth / 2), screenWidth / 2, screenWidth/2);
    CGRect incomeRect = CGRectMake(0, screenHeight - (screenWidth / 2), screenWidth / 2, screenWidth/2);
    CGRect expenseRect = CGRectMake(screenWidth / 2,screenHeight - (screenWidth / 2), screenWidth / 2, screenWidth/2);
   
    if (CGRectContainsPoint(incomeRect, p)) {
        NSLog(@"Did select Income Pie Chart");
    } else if (CGRectContainsPoint(expenseRect, p)) {
        NSLog(@"Did select Expense Pie Chart");
    }
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlValueChanged:(id)sender {
        double totalIncome = 0.0;
        for (Income* income in self.incomeObjectArray) {
            float multiplier = 1;
            if ([income.duration isEqualToString:@"Weekly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 1) {
                multiplier = 4;
            } else if ([income.duration isEqualToString:@"Weekly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 2) {
                multiplier = 52;
            } else if ([income.duration isEqualToString:@"Monthly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 0) {
                multiplier = 0.25;
            } else if ([income.duration isEqualToString:@"Monthly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 2) {
                multiplier = 12;
            } else if ([income.duration isEqualToString:@"Yearly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 0) {
                multiplier = (1.0/52.0);
            } else if ([income.duration isEqualToString:@"Yearly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 1) {
                multiplier = (1.0 / 12.0);
            }
            totalIncome += income.amount * multiplier;
        }
        self.lblEarnValue.text = [NSString stringWithFormat:@"$%.2f",totalIncome];
    
    self.expenseObjectArray = [[DBManager getSharedInstance] getAllExpense];
    double totalExpense = 0.0;
    for (Income* expense in self.expenseObjectArray) {
        float multiplier = 1;
        if ([expense.duration isEqualToString:@"Weekly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 1) {
            multiplier = 4;
        } else if ([expense.duration isEqualToString:@"Weekly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 2) {
            multiplier = 52;
        } else if ([expense.duration isEqualToString:@"Monthly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 0) {
            multiplier = 0.25;
        } else if ([expense.duration isEqualToString:@"Monthly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 2) {
            multiplier = 12;
        } else if ([expense.duration isEqualToString:@"Yearly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 0) {
            multiplier = (1.0/52.0);
        } else if ([expense.duration isEqualToString:@"Yearly"] && self.timeFrameSegmentedControl.selectedSegmentIndex == 1) {
            multiplier = (1.0 / 12.0);
        }
        totalExpense += expense.amount * multiplier;
    }
    double avgBalance = totalIncome + totalExpense;
    self.lblSpendValue.text = [NSString stringWithFormat:@"$%.2f",fabs(totalExpense)];
    
    self.lblAvgBalance.text = [NSString stringWithFormat:@"$%.2f",avgBalance];
}
@end

