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
    
    Income *income = (Income *)[self getCurrentItemsArrayFromIndexPath:indexPath.section][indexPath.row];
    cell.incomeNameLabel.text = income.name;
    cell.userInteractionEnabled = NO;

    cell.colorView.backgroundColor = [self.sliceColors objectAtIndex:indexPath.section];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"SECTION %ld has %lu items",(long)section,(unsigned long)[[self getCurrentItemsArrayFromIndexPath:section] count]);
    return [[self getCurrentItemsArrayFromIndexPath:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([type isEqualToString:@"Income"]) {
        return [self.incomeBoardController.incomeDictionary.allKeys count];
    } else {
        return [self.incomeBoardController.expenseDictionary.allKeys count];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if ([type isEqualToString:@"Income"]) {
        return [[[self.incomeBoardController.incomeDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    } else {
        return [[[self.incomeBoardController.expenseDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }
    
}

-(NSMutableArray *)getCurrentItemsArrayFromIndexPath:(NSInteger)section {
    NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
    NSString *currentKey;
    if ([type isEqualToString:@"Income"]) {
        currentKey = [[[self.incomeBoardController.incomeDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
        itemsArray = [self.incomeBoardController.incomeDictionary objectForKey:currentKey];
    } else {
        currentKey = [[[self.incomeBoardController.expenseDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
        itemsArray = [self.incomeBoardController.expenseDictionary objectForKey:currentKey];
    }
    return itemsArray;
}

//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    UILabel* labelView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    labelView.text = [self tableView:tableView titleForHeaderInSection:section];
//    [headerView addSubview:labelView];
//    [headerView setBackgroundColor:[self.sliceColors objectAtIndex:section]];
//    return headerView;
//}

@end
