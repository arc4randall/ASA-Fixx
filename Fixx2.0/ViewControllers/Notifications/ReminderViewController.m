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
#import "EditEventViewController.h"
#import "AppDelegate.h"

@interface ReminderViewController () <UITableViewDelegate,UITableViewDataSource, FPPopoverControllerDelegate>
{
    UIButton *btnSliderLeft;
    EditEventViewController *objEditEventViewController;
}
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) NSArray *arrEvents;
@end

@implementation ReminderViewController
@synthesize tblEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *addReminderButton = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                          target:self
                                          action:@selector(addReminder:)];
    
    self.navigationItem.rightBarButtonItem = addReminderButton;
    
    self.tblEvents.delegate = self;
    self.tblEvents.dataSource = self;
    objEditEventViewController = [[EditEventViewController alloc] init];
    // Instantiate the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Request access to events.
    [self performSelector:@selector(requestAccessToEvents) withObject:nil afterDelay:0.4];
    
    // Load the events with a small delay, so the store event gets ready.
    [self performSelector:@selector(loadEvents) withObject:nil afterDelay:0.5];
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

-(void)addReminder:(id)sender
{
    if (appDelegate.eventManager.eventsAccessGranted) {
        [self.navigationController pushViewController:objEditEventViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)nowHide
{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:NO completion:nil];
}

#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrEvents.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellEvent"];
    
    // Get each single event.
    EKEvent *event = [self.arrEvents objectAtIndex:indexPath.row];
    
    // Set its title to the cell's text label.
    cell.textLabel.text = event.title;
    
    // Get the event start date as a string value.
    NSString *startDateString = [self.appDelegate.eventManager getStringFromDate:event.startDate];
    
    // Get the event end date as a string value.
    NSString *endDateString = [self.appDelegate.eventManager getStringFromDate:event.endDate];
    
    // Add the start and end date strings to the detail text label.
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", startDateString, endDateString];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    // Keep the identifier of the event that's about to be edited.
    self.appDelegate.eventManager.selectedEventIdentifier = [[self.arrEvents objectAtIndex:indexPath.row] eventIdentifier];
    
    // Perform the segue.
    [self performSegueWithIdentifier:@"idSegueEvent" sender:self];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected event.
        [self.appDelegate.eventManager deleteEventWithIdentifier:[[self.arrEvents objectAtIndex:indexPath.row] eventIdentifier]];
        
        // Reload all events and the table view.
        [self loadEvents];
    }
}


#pragma mark - EditEventViewControllerDelegate method implementation

-(void)eventWasSuccessfullySaved{
    // Reload all events.
    [self loadEvents];
}


#pragma mark - Private method implementation

-(void)requestAccessToEvents{
    [self.appDelegate.eventManager.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (error == nil) {
            // Store the returned granted value.
            self.appDelegate.eventManager.eventsAccessGranted = granted;
        }
        else{
            // In case of error, just log its description to the debugger.
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
}


-(void)loadEvents{
    if (self.appDelegate.eventManager.eventsAccessGranted) {
        self.arrEvents = [self.appDelegate.eventManager getEventsOfSelectedCalendar];
        
        [self.tblEvents reloadData];
    }
}

@end
