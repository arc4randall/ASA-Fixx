//
//  ExpenseIncomeDetailViewController.m
//  Fixx2.0
//
//  Created by vivek soni on 04/07/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import "ExpenseIncomeDetailViewController.h"

#import "EFloatBox.h"
#import "EColor.h"
#import "CustomAlertView.h"
#import "AppLoader.h"
#import "UIImageView+AFNetworking.h"

@interface ExpenseIncomeDetailViewController () {
    NSMutableArray *arrMonthYearSelection;
    NSMutableArray *arrFixxSummary;
   
    NSMutableArray *arrSummary;
    NSMutableArray *arrExpenses;
    NSMutableArray *arrExpensesChange;
    NSMutableArray *arrIncome;
    NSMutableArray *arrIncomeChange;
    NSMutableArray *arrBalance;
    NSMutableArray *arrBalanceChange;
    
    NSString *strSelectedValues;

    UILabel *lblChartBottom;
    UILabel *lblBiggerChartBottom;
    
    UIButton *btnClose;
    UIButton *btnExpense;
    UIButton *btnIncome;
    
    CustomAlertView *alertView;
    AppLoader *appLoader;
    
    EPieChartDataModel *ePieChartDataModel;
    
    // #SMALL GRAPH
    UILabel *lblChartBottomIncomeHeader;
    UILabel *lblChartBottomIncomeValue;
    UILabel *lblExchangeIncomeValue;
    UIImageView *imgExchangeIncomeRate;
    
    UILabel *lblChartBottomExpenseHeader;
    UILabel *lblChartBottomExpenseValue;
    UILabel *lblExchangeExpenseValue;
    UIImageView *imgExchangeExpenseRate;
    
    UILabel *lblChartBottomBalanceHeader;
    UILabel *lblChartBottomBalanceValue;
    UILabel *lblExchangeBalanceValue;
    UIImageView *imgExchangeBalanceRate;
    
    
    //#BIGGER GRAPH
    UILabel *lblBiggerChartBottomIncomeHeader;
    UILabel *lblBiggerChartBottomIncomeValue;
    UILabel *lblBiggerExchangeIncomeValue;
    UIImageView *imgBiggerExchangeIncomeRate;
    
    UILabel *lblBiggerChartBottomExpenseHeader;
    UILabel *lblBiggerChartBottomExpenseValue;
    UILabel *lblBiggerExchangeExpenseValue;
    UIImageView *imgBiggerExchangeExpenseRate;
    
    UILabel *lblBiggerChartBottomBalanceHeader;
    UILabel *lblBiggerChartBottomBalanceValue;
    UILabel *lblBiggerExchangeBalanceValue;
    UIImageView *imgBiggerExchangeBalanceRate;
    
}

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *dataIncome;
@property (nonatomic, strong) EFloatBox *eFloatBox;
@property (nonatomic, strong) UIColor *tempColor;


@end

@implementation ExpenseIncomeDetailViewController

@synthesize tempColor = _tempColor;
@synthesize eFloatBox = _eFloatBox;

@synthesize data = _data;
@synthesize dataIncome = _dataIncome;
@synthesize numberTaped = _numberTaped;
@synthesize pieChartLeft = _pieChartCopy;
@synthesize percentageLabel = _percentageLabel;
@synthesize slices = _slices;
@synthesize sliceColors = _sliceColors;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self prepareLayout];
    [self trackEvent:[WTEvent eventForScreenView:@"Donut Chart" eventDescr:@"" eventType:@"" contentGroup:@""]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPieChartLeft:nil];
    [self setPercentageLabel:nil];
    [self setSelectedSliceLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pieChartLeft reloadData];
}

#pragma mark Graph Layout
- (void) prepareLayout {
    //set back button color
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    //set back button arrow color
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    // Add custom label to show title on navigation bar
    UIImageView *titleLogo=[[UIImageView alloc]init];
    [titleLogo setFrame:CGRectMake(0, 10, 58, 24)];
    [titleLogo setBackgroundColor:[UIColor clearColor]];
    titleLogo.contentMode = UIViewContentModeScaleAspectFit;
    [titleLogo setImage:[UIImage imageNamed:@"top_logo.png"]];
    [self.navigationItem setTitleView:titleLogo];
    
    alertView = [CustomAlertView initAlertView];
    _requestOnWeb = [[WebserviceHandler alloc] init];
    _requestOnWeb.delegate = self;
    //appLoader = [AppLoader initLoaderView];
    arrFixxSummary = [[NSMutableArray alloc] init];
    arrExpenses = [[NSMutableArray alloc] init];
    arrIncome = [[NSMutableArray alloc] init];
    arrSummary = [[NSMutableArray alloc] init];
    arrExpensesChange = [[NSMutableArray alloc] init];
    arrIncomeChange = [[NSMutableArray alloc] init];
    arrBalanceChange = [[NSMutableArray alloc] init];
    
    [_btnYearMonthSelection setTitle:_strFilterValue forState:UIControlStateNormal];
    
    if ([_strTypeValue isEqualToString:@"Income"]) {
        [_lblType setText:@"My Income"];
    } else {
        [_lblType setText:@"My Expense"];
    }
    
    
    [self callWebService_GetCashFlow];
}

- (void) prepareXYPieChart {
    if ([self.slices count]!=0) {
        [self.slices removeAllObjects];
        self.slices = [[NSMutableArray alloc] init];
    }
    self.slices = [NSMutableArray arrayWithCapacity:[arrFixxSummary count]];
    
    for(int i = 0; i < [arrFixxSummary count]; i ++)
    {
        NSNumber *one = [NSNumber numberWithInt:[[[arrFixxSummary objectAtIndex:i] objectForKey:@"amount"] intValue]];
        [_slices addObject:one];
    }
    
    [self.pieChartLeft setDataSource:self];
    [self.pieChartLeft setDelegate:self];
    [self.pieChartLeft setStartPieAngle:M_PI_2];
    [self.pieChartLeft setAnimationSpeed:1.0];
    [self.pieChartLeft setLabelFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24]];
    [self.pieChartLeft setLabelRadius:100];
    [self.pieChartLeft setShowPercentage:NO];
    [self.pieChartLeft setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];
    [self.pieChartLeft setPieCenter:CGPointMake(100, 100)];
    [self.pieChartLeft setUserInteractionEnabled:YES];
    [self.pieChartLeft setLabelShadowColor:[UIColor blackColor]];
    [self.pieChartLeft setBackgroundColor:[UIColor clearColor]];
    [self.percentageLabel.layer setCornerRadius:75];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
    [self.pieChartLeft reloadData];
    if ([_slices count]!=0) {
        [self pieChart:self.pieChartLeft didSelectSliceAtIndex:0];
        //[self.pieChartLeft performSelector:@selector(setSliceSelectedAtIndex:) withObject:0 afterDelay:0.3];
       // self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:0]];
     
    }
   
  
}

- (void) preparePieChart  {
    if (!_ePieChart)
    {
        //EPieChart *ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(100, 150, 150, 150)];
        _ePieChart = [[EPieChart alloc] initWithFrame:CGRectMake(60, 80, 200, 200)
                                   ePieChartDataModel:ePieChartDataModel];
    }
    
    //_ePieChart.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    //    [ePieChart.frontPie setLineWidth:1];
    [_ePieChart.frontPie setRadius:100];
    // _ePieChart.frontPie.currentColor = [UIColor redColor];
    // _ePieChart.frontPie.budgetColor = [UIColor grayColor];
    // _ePieChart.frontPie.estimateColor = [UIColor blueColor];
    [_ePieChart setDelegate:self];
    [_ePieChart setDataSource:self];
   // [_ePieChart setMotionEffectOn:YES];
    
    [self.view addSubview:_ePieChart];
}

- (void) prepareExpenseIncomeFlowLayout {
    //arrExpenses = [[NSMutableArray alloc] initWithObjects:@"50",@"80",@"122",@"333",@"111",@"123", nil];
    
    //arrIncome = [[NSMutableArray alloc] initWithObjects:@"40",@"60",@"182",@"233",@"181",@"223", nil];
    
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *tempAnother = [NSMutableArray array];
    
    for (int i = 0; i < [arrExpenses count]; i++)
    {
        //Value is Bar Value
        //int value = arc4random() % 100;
        int value = [[arrExpenses objectAtIndex:i] intValue];
        
        
        int valueAnother = [[arrIncome objectAtIndex:i] intValue];
      
    }
    _data = [NSArray arrayWithArray:temp];
    
    [[_objScrollView viewWithTag:506] removeFromSuperview];
    

    _dataIncome = [NSArray arrayWithArray:tempAnother];
    NSInteger intWidth = [arrExpenses count] *15;

    [_objScrollView setContentSize:CGSizeMake(intWidth, 80)];

    
    [_objScrollView setFrame:CGRectMake(86, 30, 222, 109)];
    
    //Prepare Bottom Graph Values:
    // #Time Label
    [_lblYAxisLabel setFrame:CGRectMake(50, 128, 40, 20)];
    
    
    // #INCOME
    if (lblChartBottomIncomeHeader)
        [lblChartBottomIncomeHeader removeFromSuperview];
    
    lblChartBottomIncomeHeader = [[UILabel alloc] init];
    [lblChartBottomIncomeHeader setBackgroundColor:[UIColor clearColor]];
    [lblChartBottomIncomeHeader setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    [lblChartBottomIncomeHeader setText:@"INCOME"];
    [lblChartBottomIncomeHeader setFrame:CGRectMake(95, 128, 70, 20)];
    [lblChartBottomIncomeHeader setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblChartBottomIncomeHeader];
    
    if (lblChartBottomIncomeValue)
        [lblChartBottomIncomeValue removeFromSuperview];
    
    lblChartBottomIncomeValue = [[UILabel alloc] init];
    [lblChartBottomIncomeValue setBackgroundColor:[UIColor clearColor]];
    [lblChartBottomIncomeValue setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    if ([arrIncome count]!=0) {
        [lblChartBottomIncomeValue setText:[NSString stringWithFormat:@"%.1f", [[arrIncome objectAtIndex:0] floatValue]]];
    }
    [lblChartBottomIncomeValue setFrame:CGRectMake(95, 142, 70, 20)];
    //[lblChartBottomIncomeValue setTextAlignment:NSTextAlignmentCenter];
    [lblChartBottomIncomeValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblChartBottomIncomeValue];
    
    
    if (lblExchangeIncomeValue)
        [lblExchangeIncomeValue removeFromSuperview];
    
    lblExchangeIncomeValue = [[UILabel alloc] init];
    [lblExchangeIncomeValue setBackgroundColor:[UIColor clearColor]];
    [lblExchangeIncomeValue setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    [lblExchangeIncomeValue setFrame:CGRectMake(95, 157, 70, 20)];
    NSInteger intValues =0 ;
    if ([arrIncomeChange count]!=0) {
        if (![[arrIncomeChange objectAtIndex:0] isEqual:[NSNull null]]) {
            [lblExchangeIncomeValue setText:[NSString stringWithFormat:@"%.1f%%", [[arrIncomeChange objectAtIndex:0] floatValue]]];
            intValues = [[arrIncomeChange objectAtIndex:0] integerValue];
        } else {
            intValues = [@"0" integerValue];
            [lblExchangeIncomeValue setText:@"0.0%"];
        }
        
    }
    
    [lblExchangeIncomeValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblExchangeIncomeValue];
    
    
    if (imgExchangeIncomeRate)
        [imgExchangeIncomeRate removeFromSuperview];
    
    imgExchangeIncomeRate = [[UIImageView alloc] init];
    [imgExchangeIncomeRate setFrame:CGRectMake(128, 161, 15, 10)];
    [_graphContainer addSubview:imgExchangeIncomeRate];
    
    if (intValues>=0.0) {
        imgExchangeIncomeRate.image = [UIImage imageNamed:@"up-arrow.png"];
    } else {
        imgExchangeIncomeRate.image = [UIImage imageNamed:@"down-arrow.png"];
    }
    
    
    // #EXPENSE
    if (lblChartBottomExpenseHeader)
        [lblChartBottomExpenseHeader removeFromSuperview];
    
    lblChartBottomExpenseHeader = [[UILabel alloc] init];
    [lblChartBottomExpenseHeader setBackgroundColor:[UIColor clearColor]];
    [lblChartBottomExpenseHeader setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    [lblChartBottomExpenseHeader setText:@"EXPENSE"];
    [lblChartBottomExpenseHeader setFrame:CGRectMake(170, 128, 80, 20)];
    [lblChartBottomExpenseHeader setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblChartBottomExpenseHeader];
    
    if (lblChartBottomExpenseValue)
        [lblChartBottomExpenseValue removeFromSuperview];
    lblChartBottomExpenseValue = [[UILabel alloc] init];
    [lblChartBottomExpenseValue setBackgroundColor:[UIColor clearColor]];
    [lblChartBottomExpenseValue setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    if ([arrExpenses count]!=0) {
        [lblChartBottomExpenseValue setText:[NSString stringWithFormat:@"%.1f", [[arrExpenses objectAtIndex:0] floatValue]]];
    }
    
    
    
    [lblChartBottomExpenseValue setFrame:CGRectMake(170, 142, 70, 20)];
    //[lblChartBottomIncomeValue setTextAlignment:NSTextAlignmentCenter];
    [lblChartBottomExpenseValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblChartBottomExpenseValue];
    
    if (lblExchangeExpenseValue)
        [lblExchangeExpenseValue removeFromSuperview];
    lblExchangeExpenseValue = [[UILabel alloc] init];
    [lblExchangeExpenseValue setBackgroundColor:[UIColor clearColor]];
    [lblExchangeExpenseValue setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    [lblExchangeExpenseValue setFrame:CGRectMake(170, 157, 70, 20)];
    NSInteger intExchangeValues =0;
    if ([arrExpensesChange count]!=0) {
        if (![[arrExpensesChange objectAtIndex:0] isEqual:[NSNull null]]) {
            [lblExchangeExpenseValue setText:[NSString stringWithFormat:@"%.1f%%", [[arrExpensesChange objectAtIndex:0] floatValue]]];
            
            intExchangeValues = [[arrExpensesChange objectAtIndex:0] integerValue];
        } else {
            [lblExchangeExpenseValue setText:@"0.0%"];
            intExchangeValues = [@"0.0" integerValue];
        }
    }
    
    [lblExchangeExpenseValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblExchangeExpenseValue];
    
    if (imgExchangeExpenseRate)
        [imgExchangeExpenseRate removeFromSuperview];
    
    imgExchangeExpenseRate = [[UIImageView alloc] init];
    [imgExchangeExpenseRate setFrame:CGRectMake(203, 161, 15, 10)];
    [_graphContainer addSubview:imgExchangeExpenseRate];
    
    // #EXPENSE
    if (intExchangeValues>=0.0) {
        imgExchangeExpenseRate.image = [UIImage imageNamed:@"up-arrow.png"];
    } else {
        imgExchangeExpenseRate.image = [UIImage imageNamed:@"down-arrow.png"];
    }
    
    
    // #BALANCE
    if (lblChartBottomBalanceHeader)
        [lblChartBottomBalanceHeader removeFromSuperview];
    lblChartBottomBalanceHeader = [[UILabel alloc] init];
    [lblChartBottomBalanceHeader setBackgroundColor:[UIColor clearColor]];
    [lblChartBottomBalanceHeader setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    [lblChartBottomBalanceHeader setText:@"BALANCE"];
    [lblChartBottomBalanceHeader setFrame:CGRectMake(245, 128, 80, 20)];
    [lblChartBottomBalanceHeader setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblChartBottomBalanceHeader];
    
    
    if (lblChartBottomBalanceValue)
        [lblChartBottomBalanceValue removeFromSuperview];
    
    lblChartBottomBalanceValue = [[UILabel alloc] init];
    [lblChartBottomBalanceValue setBackgroundColor:[UIColor clearColor]];
    [lblChartBottomBalanceValue setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    if ([arrBalance count]!=0) {
        [lblChartBottomBalanceValue setText:[NSString stringWithFormat:@"%.1f", [[arrBalance objectAtIndex:0] floatValue]]];
    }
    
    [lblChartBottomBalanceValue setFrame:CGRectMake(245, 142, 70, 20)];
    //[lblChartBottomIncomeValue setTextAlignment:NSTextAlignmentCenter];
    [lblChartBottomBalanceValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblChartBottomBalanceValue];
    
    if (lblExchangeBalanceValue)
        [lblExchangeBalanceValue removeFromSuperview];
    
    lblExchangeBalanceValue = [[UILabel alloc] init];
    [lblExchangeBalanceValue setBackgroundColor:[UIColor clearColor]];
    [lblExchangeBalanceValue setFont:[UIFont fontWithName:ProximaNovaRegular size:11]];
    [lblExchangeBalanceValue setFrame:CGRectMake(245, 157, 70, 20)];
    NSInteger intBalanceValues=0;
    if ([arrBalanceChange count]!=0) {
        if (![[arrBalanceChange objectAtIndex:0] isEqual:[NSNull null]]) {
            [lblExchangeBalanceValue setText:[NSString stringWithFormat:@"%.1f%%", [[arrBalanceChange objectAtIndex:0] floatValue]]];
            intBalanceValues = [[arrBalanceChange objectAtIndex:0] integerValue];
        } else {
            intBalanceValues = 0;
            [lblExchangeBalanceValue setText:@"0.0%"];
        }
    }
    
    [lblExchangeBalanceValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblExchangeBalanceValue];
    
    if (imgExchangeBalanceRate)
        [imgExchangeBalanceRate removeFromSuperview];
    
    
    imgExchangeBalanceRate = [[UIImageView alloc] init];
    [imgExchangeBalanceRate setFrame:CGRectMake(280, 161, 15, 10)];
    [_graphContainer addSubview:imgExchangeBalanceRate];
    
    // #BALANCE
    if (intBalanceValues>=0.0) {
        imgExchangeBalanceRate.image = [UIImage imageNamed:@"up-arrow.png"];
    } else {
        imgExchangeBalanceRate.image = [UIImage imageNamed:@"down-arrow.png"];
    }
    
}

- (void) hideBottomChartLabels {
    [_lblYAxisLabel setHidden:YES];
    [_lblXAxisDollerLabel setHidden:YES];
    [lblChartBottomBalanceHeader setHidden:YES];
    [lblChartBottomExpenseHeader setHidden:YES];
    [lblChartBottomIncomeHeader setHidden:YES];
    
    [lblChartBottomIncomeValue setHidden:YES];
    [lblExchangeIncomeValue setHidden:YES];
    [imgExchangeIncomeRate setHidden:YES];
    [lblChartBottomExpenseValue setHidden:YES];
    [lblExchangeExpenseValue setHidden:YES];
    [imgExchangeExpenseRate setHidden:YES];
    [lblChartBottomBalanceValue setHidden:YES];
    [lblExchangeBalanceValue setHidden:YES];
    [imgExchangeBalanceRate setHidden:YES];
}

- (void) showBottomChartLabels {
    [_lblYAxisLabel setHidden:NO];
    [_lblXAxisDollerLabel setHidden:NO];
    [lblChartBottomBalanceHeader setHidden:NO];
    [lblChartBottomExpenseHeader setHidden:NO];
    [lblChartBottomIncomeHeader setHidden:NO];
    
    [lblChartBottomIncomeValue setHidden:NO];
    [lblExchangeIncomeValue setHidden:NO];
    [imgExchangeIncomeRate setHidden:NO];
    [lblChartBottomExpenseValue setHidden:NO];
    [lblExchangeExpenseValue setHidden:NO];
    [imgExchangeExpenseRate setHidden:NO];
    [lblChartBottomBalanceValue setHidden:NO];
    [lblExchangeBalanceValue setHidden:NO];
    [imgExchangeBalanceRate setHidden:NO];
}


- (void) prepareExpenseIncomeBiggerFlowLayout {
    //arrExpenses = [[NSMutableArray alloc] initWithObjects:@"50",@"80",@"122",@"333",@"111",@"123", nil];
    
    //arrIncome = [[NSMutableArray alloc] initWithObjects:@"40",@"60",@"182",@"233",@"181",@"223", nil];
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *tempAnother = [NSMutableArray array];
    
    for (int i = 0; i < [arrExpenses count]; i++)
    {
        //Value is Bar Value
        //int value = arc4random() % 100;
        int value = [[arrExpenses objectAtIndex:i] intValue];
        
        
        
        int valueAnother = [[arrIncome objectAtIndex:i] intValue];
        
    }
    _data = [NSArray arrayWithArray:temp];
    
    [[_objBiggerScrollView viewWithTag:707] removeFromSuperview];
    
    _dataIncome = [NSArray arrayWithArray:tempAnother];
    NSInteger intBigWidth = [arrExpenses count] *50;
    NSInteger intBigIncomeWidth = [arrIncome count] *50;
    intBigWidth = intBigWidth + intBigIncomeWidth;
    
    [_objBiggerScrollView addSubview:_eColumnBiggerChart];
    [_objBiggerScrollView setContentSize:CGSizeMake(intBigWidth, 240)];
    
    
    
    //Prepare Bottom Graph Values:
    // #Time Label
    [_lblYAxisLabel setFrame:CGRectMake(290, 340, 40, 20)];
    
    if (lblBiggerChartBottomIncomeHeader) {
        [lblBiggerChartBottomIncomeHeader removeFromSuperview];
    }
    // #INCOME
    lblBiggerChartBottomIncomeHeader = [[UILabel alloc] init];
    [lblBiggerChartBottomIncomeHeader setBackgroundColor:[UIColor clearColor]];
    [lblBiggerChartBottomIncomeHeader setFont:[UIFont fontWithName:ProximaNovaRegular size:16]];
    [lblBiggerChartBottomIncomeHeader setText:@"INCOME"];
    [lblBiggerChartBottomIncomeHeader setFrame:CGRectMake(40, 360, 70, 20)];
    [lblBiggerChartBottomIncomeHeader setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerChartBottomIncomeHeader];
    
    if (lblBiggerChartBottomIncomeValue) {
        [lblBiggerChartBottomIncomeValue removeFromSuperview];
    }
    
    lblBiggerChartBottomIncomeValue = [[UILabel alloc] init];
    [lblBiggerChartBottomIncomeValue setBackgroundColor:[UIColor clearColor]];
    [lblBiggerChartBottomIncomeValue setFont:[UIFont fontWithName:ProximaNovaRegular size:15]];
    [lblBiggerChartBottomIncomeValue setFrame:CGRectMake(40, 380, 70, 20)];
    [lblBiggerChartBottomIncomeValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerChartBottomIncomeValue];
    
    if (lblBiggerExchangeIncomeValue) {
        [lblBiggerExchangeIncomeValue removeFromSuperview];
    }
    lblBiggerExchangeIncomeValue = [[UILabel alloc] init];
    [lblBiggerExchangeIncomeValue setBackgroundColor:[UIColor clearColor]];
    [lblBiggerExchangeIncomeValue setFont:[UIFont fontWithName:ProximaNovaRegular size:15]];
    [lblBiggerExchangeIncomeValue setFrame:CGRectMake(40, 400, 70, 20)];
    [lblBiggerExchangeIncomeValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerExchangeIncomeValue];
    
    if (imgBiggerExchangeIncomeRate) {
        [imgBiggerExchangeIncomeRate removeFromSuperview];
    }
    imgBiggerExchangeIncomeRate = [[UIImageView alloc] init];
    [imgBiggerExchangeIncomeRate setFrame:CGRectMake(86, 403, 15, 10)];
    [_graphContainer addSubview:imgBiggerExchangeIncomeRate];
    
    
    
    // #EXPENSE
    if (lblBiggerChartBottomExpenseHeader) {
        [lblBiggerChartBottomExpenseHeader removeFromSuperview];
    }
    lblBiggerChartBottomExpenseHeader = [[UILabel alloc] init];
    [lblBiggerChartBottomExpenseHeader setBackgroundColor:[UIColor clearColor]];
    [lblBiggerChartBottomExpenseHeader setFont:[UIFont fontWithName:ProximaNovaRegular size:16]];
    [lblBiggerChartBottomExpenseHeader setText:@"EXPENSE"];
    [lblBiggerChartBottomExpenseHeader setFrame:CGRectMake(125, 360, 80, 20)];
    [lblBiggerChartBottomExpenseHeader setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerChartBottomExpenseHeader];
    
    if (lblBiggerChartBottomExpenseValue) {
        [lblBiggerChartBottomExpenseValue removeFromSuperview];
    }
    lblBiggerChartBottomExpenseValue = [[UILabel alloc] init];
    [lblBiggerChartBottomExpenseValue setBackgroundColor:[UIColor clearColor]];
    [lblBiggerChartBottomExpenseValue setFont:[UIFont fontWithName:ProximaNovaRegular size:15]];
    //[lblChartBottomExpenseValue setText:@"$100"];
    [lblBiggerChartBottomExpenseValue setFrame:CGRectMake(125, 380, 70, 20)];
    //[lblChartBottomIncomeValue setTextAlignment:NSTextAlignmentCenter];
    [lblBiggerChartBottomExpenseValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerChartBottomExpenseValue];
    
    if (lblBiggerExchangeExpenseValue) {
        [lblBiggerExchangeExpenseValue removeFromSuperview];
    }
    lblBiggerExchangeExpenseValue = [[UILabel alloc] init];
    [lblBiggerExchangeExpenseValue setBackgroundColor:[UIColor clearColor]];
    [lblBiggerExchangeExpenseValue setFont:[UIFont fontWithName:ProximaNovaRegular size:15]];
    [lblBiggerExchangeExpenseValue setFrame:CGRectMake(125, 400, 70, 20)];
    [lblBiggerExchangeExpenseValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerExchangeExpenseValue];
    
    if (imgBiggerExchangeExpenseRate) {
        [imgBiggerExchangeExpenseRate removeFromSuperview];
    }
    imgBiggerExchangeExpenseRate = [[UIImageView alloc] init];
    [imgBiggerExchangeExpenseRate setFrame:CGRectMake(170, 403, 15, 10)];
    [_graphContainer addSubview:imgBiggerExchangeExpenseRate];
    
    // #BALANCE
    if (lblBiggerChartBottomBalanceHeader) {
        [lblBiggerChartBottomBalanceHeader removeFromSuperview];
    }
    lblBiggerChartBottomBalanceHeader = [[UILabel alloc] init];
    [lblBiggerChartBottomBalanceHeader setBackgroundColor:[UIColor clearColor]];
    [lblBiggerChartBottomBalanceHeader setFont:[UIFont fontWithName:ProximaNovaRegular size:16]];
    [lblBiggerChartBottomBalanceHeader setText:@"BALANCE"];
    [lblBiggerChartBottomBalanceHeader setFrame:CGRectMake(225, 360, 80, 20)];
    [lblBiggerChartBottomBalanceHeader setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerChartBottomBalanceHeader];
    
    
    if (lblBiggerChartBottomBalanceValue) {
        [lblBiggerChartBottomBalanceValue removeFromSuperview];
    }
    lblBiggerChartBottomBalanceValue = [[UILabel alloc] init];
    [lblBiggerChartBottomBalanceValue setBackgroundColor:[UIColor clearColor]];
    [lblBiggerChartBottomBalanceValue setFont:[UIFont fontWithName:ProximaNovaRegular size:15]];
    //[lblChartBottomBalanceValue setText:@"$100"];
    [lblBiggerChartBottomBalanceValue setFrame:CGRectMake(225, 380, 70, 20)];
    //[lblChartBottomIncomeValue setTextAlignment:NSTextAlignmentCenter];
    [lblBiggerChartBottomBalanceValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerChartBottomBalanceValue];
    
    if (lblBiggerExchangeBalanceValue) {
        [lblBiggerExchangeBalanceValue removeFromSuperview];
    }
    lblBiggerExchangeBalanceValue = [[UILabel alloc] init];
    [lblBiggerExchangeBalanceValue setBackgroundColor:[UIColor clearColor]];
    [lblBiggerExchangeBalanceValue setFont:[UIFont fontWithName:ProximaNovaRegular size:15]];
    [lblBiggerExchangeBalanceValue setFrame:CGRectMake(225, 400, 70, 20)];
    [lblBiggerExchangeBalanceValue setTextColor:[UIColor whiteColor]];
    [_graphContainer addSubview:lblBiggerExchangeBalanceValue];
    
    if (imgBiggerExchangeBalanceRate) {
        [imgBiggerExchangeBalanceRate removeFromSuperview];
    }
    imgBiggerExchangeBalanceRate = [[UIImageView alloc] init];
    [imgBiggerExchangeBalanceRate setFrame:CGRectMake(270, 402, 15, 10)];
    [_graphContainer addSubview:imgBiggerExchangeBalanceRate];
    
    
    //#SET INCOME VALUE
    if ([arrIncome count]!=0) {
        [lblBiggerChartBottomIncomeValue setText:[NSString stringWithFormat:@"%.1f", [[arrIncome objectAtIndex:0] floatValue]]];
    }
    NSInteger intValues =0 ;
    if ([arrIncomeChange count]!=0) {
        if (![[arrIncomeChange objectAtIndex:0] isEqual:[NSNull null]]) {
            [lblBiggerExchangeIncomeValue setText:[NSString stringWithFormat:@"%.1f%%", [[arrIncomeChange objectAtIndex:0] floatValue]]];
            intValues = [[arrIncomeChange objectAtIndex:0] integerValue];
        } else {
            intValues = [@"0" integerValue];
            [lblBiggerExchangeIncomeValue setText:@"0.0%"];
        }
        
    }
    if (intValues>=0.0) {
        imgBiggerExchangeIncomeRate.image = [UIImage imageNamed:@"up-arrow.png"];
    } else {
        imgBiggerExchangeIncomeRate.image = [UIImage imageNamed:@"down-arrow.png"];
    }
    
    
    //#SET EXCHANGE VALUE
    if ([arrExpenses count]!=0) {
        [lblBiggerChartBottomExpenseValue setText:[NSString stringWithFormat:@"%.1f", [[arrExpenses objectAtIndex:0] floatValue]]];
    }
    NSInteger intExchangeValues =0;
    if ([arrExpensesChange count]!=0) {
        if (![[arrExpensesChange objectAtIndex:0] isEqual:[NSNull null]]) {
            [lblBiggerExchangeExpenseValue setText:[NSString stringWithFormat:@"%.1f%%", [[arrExpensesChange objectAtIndex:0] floatValue]]];
            
            intExchangeValues = [[arrExpensesChange objectAtIndex:0] integerValue];
        } else {
            [lblBiggerExchangeExpenseValue setText:@"0.0%"];
            intExchangeValues = [@"0.0" integerValue];
        }
    }
    if (intExchangeValues>=0.0) {
        imgBiggerExchangeExpenseRate.image = [UIImage imageNamed:@"up-arrow.png"];
    } else {
        imgBiggerExchangeExpenseRate.image = [UIImage imageNamed:@"down-arrow.png"];
    }
    
    //#BALANCE BIGGER VALuE
    if ([arrBalance count]!=0) {
        [lblBiggerChartBottomBalanceValue setText:[NSString stringWithFormat:@"%.1f", [[arrBalance objectAtIndex:0] floatValue]]];
    }
    NSInteger intBalanceValues=0;
    if ([arrBalanceChange count]!=0) {
        if (![[arrBalanceChange objectAtIndex:0] isEqual:[NSNull null]]) {
            [lblBiggerExchangeBalanceValue setText:[NSString stringWithFormat:@"%.1f %%", [[arrBalanceChange objectAtIndex:0] floatValue]]];
            intBalanceValues = [[arrBalanceChange objectAtIndex:0] integerValue];
        } else {
            intBalanceValues = 0;
            [lblBiggerExchangeBalanceValue setText:@"0.0%"];
        }
    }
    if (intBalanceValues>=0.0) {
        imgBiggerExchangeBalanceRate.image = [UIImage imageNamed:@"up-arrow.png"];
    } else {
        imgBiggerExchangeBalanceRate.image = [UIImage imageNamed:@"down-arrow.png"];
    }
    
}

- (void) hideLargerGraphBottomLabels {
    [_lblYAxisLabel setHidden:YES];
    //[_lblXAxisDollerLabel setHidden:YES];
    [lblBiggerChartBottomBalanceHeader setHidden:YES];
    [lblBiggerChartBottomExpenseHeader setHidden:YES];
    [lblBiggerChartBottomIncomeHeader setHidden:YES];
    
    [lblBiggerChartBottomIncomeValue setHidden:YES];
    [lblBiggerExchangeIncomeValue setHidden:YES];
    [imgBiggerExchangeIncomeRate setHidden:YES];
    [lblBiggerChartBottomExpenseValue setHidden:YES];
    [lblBiggerExchangeExpenseValue setHidden:YES];
    [imgBiggerExchangeExpenseRate setHidden:YES];
    [lblBiggerChartBottomBalanceValue setHidden:YES];
    [lblBiggerExchangeBalanceValue setHidden:YES];
    [imgBiggerExchangeBalanceRate setHidden:YES];
}

- (void) showLargerGraphBottomLabels {
    [_lblYAxisLabel setHidden:NO];
    [_lblXAxisDollerLabel setHidden:NO];
    [lblBiggerChartBottomBalanceHeader setHidden:NO];
    [lblBiggerChartBottomExpenseHeader setHidden:NO];
    [lblBiggerChartBottomIncomeHeader setHidden:NO];
    
    [lblBiggerChartBottomIncomeValue setHidden:NO];
    [lblBiggerExchangeIncomeValue setHidden:NO];
    [imgBiggerExchangeIncomeRate setHidden:NO];
    [lblBiggerChartBottomExpenseValue setHidden:NO];
    [lblBiggerExchangeExpenseValue setHidden:NO];
    [imgBiggerExchangeExpenseRate setHidden:NO];
    [lblBiggerChartBottomBalanceValue setHidden:NO];
    [lblBiggerExchangeBalanceValue setHidden:NO];
    [imgBiggerExchangeBalanceRate setHidden:NO];
}

#pragma mark Web Service Calling 
- (void) callWebService_GetCashFlow {
   
    NSString *strType = @"";
    if ([_strTypeValue isEqualToString:@"Income"]) {
        strType = @"true";
    } else {
       strType = @"false";
    }
    //[appLoader startActivityLoader:self.view:Progressing];
    NSString *strURL = [HOST_URL stringByAppendingString:[NSString stringWithFormat:GetCashFlow,API_KEY, objSharedData.str_AccessToken,_btnYearMonthSelection.titleLabel.text,strType]];
    NSLog(@"Request URL %@",strURL);
    [_requestOnWeb callThePassedURLASynchronouslyWithRequest:strURL RequestString:nil];
}

#pragma mark - Webservice
- (void)webServiceHandler:(WebserviceHandler *)webHandler recievedResponse:(NSDictionary *)dicResponse
{
    
    NSLog(@"login reponse %@",dicResponse);
    [appLoader stopActivityLoader];
    
    if ([dicResponse objectForKey:@"Error"]) {
        [alertView displayAlertViewWithView:self.view withTitle:@"Failed!" withMessage:[ [dicResponse objectForKey:@"Error" ] objectForKey:@"message"]withButtonTitle:@"OK" withOtherButtonTitle:Nil];
    } else if ([[dicResponse objectForKey:@"status"] integerValue] == 200 && [dicResponse objectForKey:@"fixxsummary"]) {
        
         if (![[dicResponse objectForKey:@"fixxsummary"] isEqual:[NSNull null]]) {
             
            NSInteger intAmount = [[dicResponse objectForKey:@"TotalAmount"] integerValue];
            intAmount = roundf(intAmount);
            _lblAmountValue.text = [NSString stringWithFormat:@"$%ld",(long)intAmount];
            arrFixxSummary = [dicResponse objectForKey:@"fixxsummary"];
            [self prepareXYPieChart];
            
            
            arrSummary = [dicResponse objectForKey:@"summary"];
            arrExpenses = [[[dicResponse objectForKey:@"graph"] objectAtIndex:0] objectForKey:@"expense"];
            arrIncome = [[[dicResponse objectForKey:@"graph"] objectAtIndex:0] objectForKey:@"income"];
            arrBalance = [[[dicResponse objectForKey:@"graph"] objectAtIndex:0] objectForKey:@"balance"];
            
            arrExpensesChange = [[[dicResponse objectForKey:@"graph"] objectAtIndex:0] objectForKey:@"expense_change"];
            arrIncomeChange = [[[dicResponse objectForKey:@"graph"] objectAtIndex:0] objectForKey:@"income_change"];
            arrBalanceChange = [[[dicResponse objectForKey:@"graph"] objectAtIndex:0] objectForKey:@"balance_change"];
            
            [self prepareExpenseIncomeFlowLayout];
            
            
            [self prepareExpenseIncomeBiggerFlowLayout];

         } else {
             [alertView displayAlertViewWithView:self.view withTitle:@"Fixx" withMessage:@"Summary not available for this period" withButtonTitle:@"OK" withOtherButtonTitle:@""];
         }
    }
}


- (void)webServiceHandler:(WebserviceHandler *)webHandler requestFailedWithError:(NSError *)error
{
    [appLoader stopActivityLoader];
    if (!networkStatus) {
        ShowAlert(NetworkReachabilityTitle, NetworkReachabilityAlert)
    }
    // remove it after WS call
}


#pragma mark IBAction Button





- (IBAction)btnCashFlow_ButtonClick:(id)sender {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        if ([_btnCashFlow isSelected]) {
            //Down View Animation
            [self closeCashFlowScreen];
        } else {
             [self hideBottomChartLabels];
            //Up View Animation
            [_btnCashFlow setSelected:YES];
            [UIView animateWithDuration:0.5 animations:^{
                [_btnAddEdit setHidden:YES];
                _dataContainer.frame = CGRectMake(0, -310, screenWidth, screenHeight);
                _graphContainer.frame =  CGRectMake(0, 0, screenWidth, screenHeight);
                
                [lblChartBottom setHidden:YES];
                [_objScrollView setHidden:YES];
            } completion:^(BOOL finished) {
                [_btnCashFlow setImage:[UIImage imageNamed:@"small-arrow-down.png"] forState:UIControlStateNormal];
                
                [self largeGraphView];
            }];
        }
    }

- (IBAction)btnPickerDone_ButtonClick:(id)sender {
    [lblChartBottom removeFromSuperview];
    [lblBiggerChartBottom removeFromSuperview];
    
    [_eColumnChart removeFromSuperview];
    [_eColumnBiggerChart removeFromSuperview];
    
    if ([strSelectedValues length]==0) {
        strSelectedValues = @"M";
    }
    [self callWebService_GetCashFlow];
}

- (IBAction)btnBack_SummaryButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Graph Position Animation

- (void) largeGraphView {
    
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"subview %@",[_graphContainer subviews]);
        [_objBiggerScrollView setHidden:NO];
        [lblBiggerChartBottom setHidden:NO];
        
        
        // _eColumnChart.frame = CGRectMake(5, 100, intWidth, 300);
        // _objScrollView.frame = CGRectMake(20, 50, 280, 300);
    } completion:^(BOOL finished) {
        // [_eColumnChart reloadData];
        //[self addBottomOptionButton];
    }];
}

- (void) shiftToRightGraphLayout {
    [UIView animateWithDuration:0.5 animations:^{
        // _objScrollView.frame = CGRectMake(100, 380, 220, 80);
    } completion:^(BOOL finished) {
        [_eColumnChart setHidden:NO];
        [_btnAddEdit setHidden:NO];
        [lblChartBottom setHidden:NO];
        
    }];
}

- (void) closeCashFlowScreen {
    if (_eColumnChart.hidden) {
        [btnClose removeFromSuperview];
        [btnExpense removeFromSuperview];
        [btnIncome removeFromSuperview];
        
        
        
        _eColumnChart.hidden = NO;
        [_btnAddEdit setHidden:NO];
        [_objScrollView setHidden:NO];
        [lblChartBottom setHidden:NO];
        [_objBiggerScrollView setHidden:YES];
        [lblBiggerChartBottom setHidden:YES];
       
        [self showBottomChartLabels];
    } else {
        [btnClose removeFromSuperview];
        [btnExpense removeFromSuperview];
        [btnIncome removeFromSuperview];
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.height;
        CGFloat screenHeight = screenRect.size.height;
        
        [_btnCashFlow setSelected:NO];
        [UIView animateWithDuration:0.5 animations:^{
            _graphContainer.frame =  CGRectMake(0, 320, screenWidth, screenHeight);
            _dataContainer.frame = CGRectMake(0, 0, screenWidth, screenHeight);
            
            [_objBiggerScrollView setHidden:YES];
            [lblBiggerChartBottom setHidden:YES];
            
            [lblChartBottom setHidden:NO];
            [_eColumnChart setHidden:NO];
            [_objScrollView setHidden:NO];
            
            [self showBottomChartLabels];
            
            [_eColumnChart reloadData];
            [_objScrollView setFrame:CGRectMake(86, 30, 222, 109)];
            
            
        } completion:^(BOOL finished) {
            [_btnCashFlow setImage:[UIImage imageNamed:@"small-arrow-up.png"] forState:UIControlStateNormal];
            [self shiftToRightGraphLayout];
            
        }];
    }
}

- (void) isHideCashFlow : (BOOL) show {
    if (show) {
        [_eColumnChart setHidden:show];
        [_objScrollView setHidden:show];
        [lblChartBottom setHidden:show];
        [_btnAddEdit setHidden:show];
    } else {
        [_eColumnChart setHidden:show];
        [_objScrollView setHidden:show];
        [lblChartBottom setHidden:show];
        [_btnAddEdit setHidden:show];
    }
}

- (void) addBottomOptionButton {
     [self hideBottomChartLabels];
    
    btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnClose setBackgroundImage:[UIImage imageNamed:@"graph_close.png"] forState:UIControlStateNormal];
    [btnClose setFrame:CGRectMake(20, 400 , 30, 30)];
    [btnClose addTarget:self action:@selector(closeCashFlowScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClose];
    
    btnExpense = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnExpense setImage:[UIImage imageNamed:@"expenses-button.png"] forState:UIControlStateNormal];
    [btnExpense setFrame:CGRectMake(85, 385 , 58, 58)];
    [btnExpense addTarget:self action:@selector(btnAddExpense_ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnExpense];
    
    btnIncome = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnIncome setImage:[UIImage imageNamed:@"income-button.png"] forState:UIControlStateNormal];
    [btnIncome setFrame:CGRectMake(155, 385 ,  58, 58)];
    [btnIncome addTarget:self action:@selector(btnAddIncome_ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnIncome];
    
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
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
    [_imgExpenseIcon setImageWithURL:[NSURL fileURLWithPath:[[arrFixxSummary objectAtIndex:index] objectForKey:@"icon_file"]] placeholderImage:[UIImage imageNamed:@"star_icon.png"]];
}

#pragma -mark- EPieChartDelegate

- (void)            ePieChart:(EPieChart *)ePieChart
didTurnToBackViewWithBackView:(UIView *)backView
{
    //    UILabel *label = [[UILabel alloc] initWithFrame:backView.bounds];
    //    label.text = @"hello";
    //    [label setTextAlignment:NSTextAlignmentCenter];
    //    label.center = CGPointMake(CGRectGetMidX(backView.bounds), CGRectGetMidY(backView.bounds));
    //    [backView addSubview:label];
}

- (void)              ePieChart:(EPieChart *)ePieChart
didTurnToFrontViewWithFrontView:(UIView *)frontView
{
    
}

#pragma -mark- EPieChartDataSource
- (UIView *)backViewForEPieChart:(EPieChart *)ePieChart
{
    UIView *customizedView = [[UIView alloc] initWithFrame:ePieChart.backPie.bounds];
    customizedView.layer.cornerRadius = CGRectGetWidth(customizedView.bounds) / 2;
    
    UILabel *label = [[UILabel alloc] initWithFrame:customizedView.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 3;
    label.font = [UIFont fontWithName:@"Menlo" size:15];
    label.text = @"This is Customized view";
    [customizedView addSubview:label];
    
    return customizedView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
