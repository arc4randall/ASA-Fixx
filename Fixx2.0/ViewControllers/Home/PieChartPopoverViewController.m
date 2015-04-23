//
//  PieChartPopoverViewController.m
//  Fixx2.0
//
//  Created by Randall Spence on 4/6/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "PieChartPopoverViewController.h"
#import "XYPieChart.h"
#import "DBManager.h"
#import "LegendTableViewCell.h"

@interface PieChartPopoverViewController () <UITableViewDelegate,UITableViewDataSource> {
    NSString* type;
}

@end

@implementation PieChartPopoverViewController
@synthesize sliceColors;
- (instancetype)initWithType:(NSString*)viewType
{
    self = [super init];
    if (self) {
        type = viewType;
        NSLog(@"Is this even loading???");
        self.legendTableView = [[UITableView alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    //self.legendTableView.layer.borderWidth = 2.0;
    //self.legendTableView.layer.borderColor = [UIColor blackColor].CGColor;
    //self.legendTableView.frame = CGRectMake(-5,0,self.view.frame.size.width * 0.85,(self.view.frame.size.height * 0.80));
    
    [self.view addSubview:self.legendTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Delegate Cells
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LegendTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LegendCell"];
    if (cell == nil) {
        cell = [[LegendTableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LegendCell"];
    }
    if ([type isEqualToString:@"Income"]){
        Income *income = (Income *)self.incomeBoardController.incomeObjectArray[indexPath.row];
        cell.incomeNameLabel.text = income.name;
    } else {
        Income *income = (Income *)self.incomeBoardController.expenseObjectArray[indexPath.row];
        cell.incomeNameLabel.text = income.name;
    }
    cell.userInteractionEnabled = NO;

    cell.colorView.backgroundColor = [self.sliceColors objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([type isEqualToString:@"Income"]) {
        return self.incomeBoardController.incomeObjectArray.count;
    } else {
        return self.incomeBoardController.expenseObjectArray.count;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
