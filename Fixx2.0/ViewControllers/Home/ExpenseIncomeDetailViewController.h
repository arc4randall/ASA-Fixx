//
//  ExpenseIncomeDetailViewController.h
//  Fixx2.0
//
//  Created by vivek soni on 04/07/14.
//  Copyright (c) 2014 Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EColumnChart.h"
#import "ELineChart.h"
#import "ELineChartDataModel.h"
#import "WebserviceHandler.h"
#import "XYPieChart.h"
#import "EPieChart.h"

@interface ExpenseIncomeDetailViewController : UIViewController <WebServiceHandlerDelegate,EPieChartDelegate, EPieChartDataSource,XYPieChartDelegate, XYPieChartDataSource>

@property (strong, nonatomic) EColumnChart *eColumnChart;
@property (strong, nonatomic) EColumnChart *eColumnBiggerChart;

@property (strong, nonatomic) IBOutlet UIView *graphContainer;
@property (strong, nonatomic) IBOutlet UIView *dataContainer;
@property (strong, nonatomic) WebserviceHandler *requestOnWeb;

@property (strong, nonatomic) IBOutlet UILabel *numberTaped;
@property (strong, nonatomic) IBOutlet UIButton *btnYearMonthSelection;
@property (strong, nonatomic) IBOutlet UIButton *btnCashFlow;
@property (strong, nonatomic) IBOutlet UIButton *btnAddEdit;
@property (strong, nonatomic) IBOutlet UIButton *btnBiPicture;
@property (strong, nonatomic) IBOutlet UILabel *lblAmountValue;

@property (strong, nonatomic) EPieChart *ePieChart;

@property (strong, nonatomic) IBOutlet XYPieChart *pieChartLeft;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray *sliceColors;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong,nonatomic) IBOutlet UIImageView *imgExpenseIcon;

@property (strong, nonatomic) IBOutlet UIScrollView *objScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *objBiggerScrollView;

@property (strong, nonatomic) NSString *strFilterValue;
@property (strong,nonatomic) NSString *strTypeValue;

@property (strong,nonatomic) IBOutlet UILabel *lblType;
@property (nonatomic,strong) IBOutlet UILabel *lblYAxisLabel;
@property (nonatomic,strong) IBOutlet UILabel *lblXAxisDollerLabel;



@end
