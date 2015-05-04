//
//  ReminderViewController.m
//  Fixx2.0
//
//  Created by Randall Spence on 5/4/15.
//  Copyright (c) 2015 Tech. All rights reserved.
//

#import "ReminderViewController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "AddReminderViewController.h"

@interface ReminderViewController () <UITableViewDelegate,UITableViewDataSource, FPPopoverControllerDelegate>
{
    UIButton *btnSliderLeft;
    AddReminderViewController *objAddReminderViewController;
}

@end

@implementation ReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *addReminderButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                          target:self
                                          action:@selector(addReminder:)];
    
    self.navigationItem.rightBarButtonItem = addReminderButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc]initWithCustomView:btnSliderLeft];
    [self.navigationItem setLeftBarButtonItem:leftBarButton];
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
        [self performSelector:@selector(nowHide) withObject:Nil afterDelay:0.1f];
    }
}

-(IBAction)addReminder:(id)sender
{
    NSLog(@"Show reminder popup view");
    
    SAFE_ARC_RELEASE(popover); popover = nil;
    
    //the controller we want to present as a popover
    objAddReminderViewController = [[AddReminderViewController alloc] init];
    objAddReminderViewController.title = nil;
    popover = [[FPPopoverKeyboardResponsiveController alloc] initWithViewController:objAddReminderViewController];
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
    objAddReminderViewController.incomeBoardController = self;
    objAddReminderViewController.popover = popover;
    
    NSLog(@"Popover should appear here...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)nowHide
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
}

#pragma mark UITableView Delegate Methods

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc] init];
    return cell;
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
