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
#import "AppLoader.h"
#import "XYPieChart.h"
#import "DBManager.h"
#import "Income.h"
#import "PieChartPopoverViewController.h"
#import "FPPopoverKeyboardResponsiveController.h"

@interface HomeDashboardViewController () {
    PieChartPopoverViewController *objPieChartPopoverViewController;
    AppLoader *appLoader;
    UIButton *btnSliderLeft;
    NSMutableArray* incomeObjectArray;
    NSMutableArray* expenseObjectArray;
    
}
@property (nonatomic, strong) AppDelegate *appDelegate;
@end

@implementation HomeDashboardViewController
@synthesize incomeObjectArray;
@synthesize expenseObjectArray;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    [self createCalenderForApp];
    [self trackEvent:[WTEvent eventForScreenView:@"Home Dashboard" eventDescr:@"Landing On screen" eventType:@"" contentGroup:@""]];
    if (!self.incomeDictionary) {
        self.incomeDictionary = [[DBManager getSharedInstance]returnAllByType:@"income"];
    }
    if (!self.expenseDictionary) {
        self.expenseDictionary = [[DBManager getSharedInstance]returnAllByType:@"expense"];
    }
    NSLog(@"INCOME DICTIONARY: %@",self.incomeDictionary);
    NSLog(@"EXPENSE DICTIONARY: %@",self.expenseDictionary);
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setUsesGroupingSeparator:YES];
    [self.numberFormatter setGroupingSeparator:@","];
    [self.numberFormatter setGroupingSize:3];
    [self.numberFormatter setMinimumFractionDigits:2];
    [self.numberFormatter setMaximumFractionDigits:2];
    [self.numberFormatter setMinimumIntegerDigits:1];
    
    UIFont* futuraMedium = [UIFont boldSystemFontOfSize:18.0];
    
    NSDictionary* attributes = [NSDictionary dictionaryWithObject:futuraMedium forKey:NSFontAttributeName];
    [self.timeFrameSegmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.slices = [[NSMutableArray alloc] init];
    self.timeFrameSegmentedControl.tintColor = [UIColor blackColor];
    self.timeFrameSegmentedControl.frame = CGRectMake(0, 0, screenWidth, screenHeight / 10);
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    switch ([defaults integerForKey:@"homeSelectedSegment"]) {
        case 0:
            self.timeFrameSegmentedControl.selectedSegmentIndex = 0;
            break;
        case 1:
            self.timeFrameSegmentedControl.selectedSegmentIndex = 1;
            break;
        case 2:
            self.timeFrameSegmentedControl.selectedSegmentIndex = 2;
            break;
        default:
            break;
    }
    
    // XYPieChart Setup
    
    self.sliceColors =@[[UIColor redColor],
                        [UIColor orangeColor],
                        [UIColor yellowColor],
                        [UIColor greenColor],
                        [UIColor blueColor],
                        [UIColor colorWithRed:0.365 green:0.463 blue:0.796 alpha:1],
                        [UIColor purpleColor],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor grayColor],
                       [UIColor magentaColor],
                       [UIColor brownColor]];
    
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
        NSArray *allIncomeKeys =  [[self.incomeDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for(NSString* categoryKey in allIncomeKeys)
        {
            int categoryAmount = 0;
            for (Income *income in [self.incomeDictionary objectForKey:categoryKey]) {
                float multiplier = 1;
                if ([income.duration isEqualToString:@"Weekly"]) {
                    multiplier = 52.0;
                } else if ([income.duration isEqualToString:@"Monthly"]) {
                    multiplier = 12;
                }
                categoryAmount += fabs(income.amount) * multiplier;
            }
            NSNumber* categoryNumber = [NSNumber numberWithInt:categoryAmount];
            [_slices addObject:categoryNumber];
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
        NSArray *allIncomeKeys =  [[self.expenseDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for(NSString* categoryKey in allIncomeKeys)
        {
            int categoryAmount = 0;
            for (Income *income in [self.expenseDictionary objectForKey:categoryKey]) {
                float multiplier = 1;
                if ([income.duration isEqualToString:@"Weekly"]) {
                    multiplier = 52.0;
                } else if ([income.duration isEqualToString:@"Monthly"]) {
                    multiplier = 12;
                }
                categoryAmount += fabs(income.amount) * multiplier;
            }
            NSNumber *categoryNumber = [NSNumber numberWithInt:categoryAmount];
            [_slices addObject:categoryNumber];
        }

        [self.expensePieChart reloadData];
    }
    [self.navigationController.view addSubview:_incomePieChart];
    [self.navigationController.view addSubview:_expensePieChart];
    
    self.incomePieChart.userInteractionEnabled = YES;
    self.expensePieChart.userInteractionEnabled = YES;
    self.incomePieChartView.userInteractionEnabled = YES;
    self.expensePieChartView.userInteractionEnabled = YES;

    
    self.appDelegate.sectionSelect = 0;
    
}

-(void)createCalenderForApp {
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSArray *localCalendars = [self.appDelegate.eventManager getLocalEventCalendars];
    bool __block isFixxCalendarExisted = NO;
    [localCalendars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        EKCalendar *calendar = (EKCalendar *)obj;
        if ([calendar.title isEqual:@"Fixx"]) {
            self.appDelegate.eventManager.selectedCalendarIdentifier = calendar.calendarIdentifier;
            *stop = YES;
             isFixxCalendarExisted = YES;
        }
    }];
    if (!isFixxCalendarExisted) {
        // Create a new calendar.
        EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent
                                                      eventStore:self.appDelegate.eventManager.eventStore];
        
        // Set the calendar title.
        calendar.title = @"Fixx";
        
        NSLog(@"calender ID is: %@",calendar.calendarIdentifier);
        // Find the proper source type value.
        for (int i=0; i<self.appDelegate.eventManager.eventStore.sources.count; i++) {
            EKSource *source = (EKSource *)[self.appDelegate.eventManager.eventStore.sources objectAtIndex:i];
            EKSourceType currentSourceType = source.sourceType;
            
            if (currentSourceType == EKSourceTypeLocal) {
                calendar.source = source;
                break;
            }
        }
        // Save and commit the calendar.
        NSError *error;
        [self.appDelegate.eventManager.eventStore saveCalendar:calendar commit:YES error:&error];
        
        // If no error occurs then turn the editing mode off, store the new calendar identifier and reload the calendars.
        if (error == nil) {
            // Store the calendar identifier.
            [self.appDelegate.eventManager saveCustomCalendarIdentifier:calendar.calendarIdentifier];
            self.appDelegate.eventManager.selectedCalendarIdentifier = calendar.calendarIdentifier;
        }
        else{
            // Display the error description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
        }
    }

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
    NSNumber* incomeNumber = [NSNumber numberWithDouble:totalIncome];
    
    self.lblEarnValue.text = [NSString stringWithFormat:@"$%@",[self.numberFormatter stringFromNumber:incomeNumber]];

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
    NSNumber* expenseNumber = [NSNumber numberWithDouble:fabs(totalExpense)];
    double avgBalance = totalIncome + totalExpense;
    
    self.lblSpendValue.text = [NSString stringWithFormat:@"$%@",[self.numberFormatter stringFromNumber:expenseNumber]];
    NSNumber *avgNumber = [NSNumber numberWithDouble:avgBalance];
    self.lblAvgBalance.text = [NSString stringWithFormat:@"$%@",[self.numberFormatter stringFromNumber:avgNumber]];
}

- (void) prepareLayout {
    [self.appDelegate.objNavController setNavigationBarHidden:NO animated:YES];
    
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
    
    appLoader = [AppLoader initLoaderView];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    animated = NO;
    [_slices removeAllObjects];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    switch (self.timeFrameSegmentedControl.selectedSegmentIndex) {
        case 0:
            [defaults setInteger:0 forKey:@"homeSelectedSegment"];
            NSLog(@"0");
            break;
        case 1:
            [defaults setInteger:1 forKey:@"homeSelectedSegment"];
            NSLog(@"1");
            break;
        case 2:
            [defaults setInteger:2 forKey:@"homeSelectedSegment"];
            NSLog(@"2");
            break;
        default:
            break;
    }
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

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [(self.slices)[index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return (self.sliceColors)[(index % self.sliceColors.count)];
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

}

-(void)didSelectPieChart:(NSString*)pieChartType
{
    NSLog(@"Did select Expense Pie Chart");
    SAFE_ARC_RELEASE(popover); popover = nil;

    //the controller we want to present as a popover
    if ([pieChartType isEqualToString:@"Expense"]) {
        objPieChartPopoverViewController = [[PieChartPopoverViewController alloc] initWithType:@"Expense"];
        objPieChartPopoverViewController.title = @"Expense Summary";
        
            } else {
        objPieChartPopoverViewController = [[PieChartPopoverViewController alloc] initWithType:@"Income"];
        objPieChartPopoverViewController.title = @"Income Summary";
    
    }
    
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:objPieChartPopoverViewController];
    popover.tint = FPPopoverDefaultTint;
    popover.keyboardHeight = _keyboardHeight;

    popover.border = NO;

    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
    popover.contentSize = CGSizeMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.80);
    } else {
    popover.contentSize = CGSizeMake(self.view.frame.size.width * 0.85, self.view.frame.size.height * 0.80);
    }
    popover.arrowDirection = FPPopoverNoArrow;

    [popover presentPopoverFromPoint: CGPointMake(self.view.center.x, self.view.center.y - popover.contentSize.height * 0.9)];
    objPieChartPopoverViewController.incomeBoardController = self;
    objPieChartPopoverViewController.popover = popover;
    objPieChartPopoverViewController.sliceColors = self.sliceColors;
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
    NSNumber* totalNumber = [NSNumber numberWithDouble:totalIncome];
    self.lblEarnValue.text = [NSString stringWithFormat:@"$%@",[self.numberFormatter stringFromNumber:totalNumber]];
    
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
    NSNumber *expenseNumber = [NSNumber numberWithDouble:fabs(totalExpense)];
    self.lblSpendValue.text = [NSString stringWithFormat:@"$%@",[self.numberFormatter stringFromNumber:expenseNumber]];
    NSNumber *avgNumber = [NSNumber numberWithDouble:avgBalance];
    self.lblAvgBalance.text = [NSString stringWithFormat:@"$%@",[self.numberFormatter stringFromNumber:avgNumber]];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"TOUCHES BEGAN!");
    UITouch* touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.graphContainer];
    NSLog(@"point: (%f,%f)",point.x,point.y);

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if (point.x > 0 && point.x < (screenWidth / 2) && point.y > 0 && point.y < screenHeight - (screenWidth / 2)) {
        if (self.incomeObjectArray.count > 0) {
            [self didSelectPieChart:@"Income"];
        }
    } else if (point.x > screenWidth / 2 && point.x < screenWidth && point.y > 0 && point.y < screenHeight - (screenWidth / 2)) {
        if (self.expenseObjectArray.count > 0) {
            [self didSelectPieChart:@"Expense"];
        }
    }
}

@end

