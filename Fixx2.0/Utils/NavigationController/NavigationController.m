//
//  NavigationController.m
//  UFree
//
//  Created by Shelesh Rawat on 10/11/12.
//
//

#import "NavigationController.h"
#import <QuartzCore/QuartzCore.h>

@interface UINavigationBar (test)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@implementation UINavigationBar (test)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.superview endEditing:YES];
}
@end

@interface NavigationController ()

@end

@implementation NavigationController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([ver[0] intValue] >= 7) {
        self.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
        self.navigationBar.translucent = NO;
        [self.navigationBar setFrame:CGRectMake(0, 0, 320, 50)];
    } else {
        self.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
    }
    
   // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
     NSLog(@"NavigationController");

    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
-(NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - Other methods
-(void)showCustomBottomView:(BOOL) show
{
    if(self.customBottomView)
    {
        if(self.customBottomView.superview)
        {
            if(show)
            {//Show bottom view.
                self.customBottomView.hidden=NO;
                [self.view bringSubviewToFront:self.customBottomView];
            }
            else
            {//Hide bottom view.
                self.customBottomView.hidden=YES;
                [self.view sendSubviewToBack:self.customBottomView];
                
            }
        }
        else
        {
            CGRect frm=self.customBottomView.frame;
            
            CGRect ParentFrm=self.view.frame;
            frm.origin.x=0;
            frm.origin.y=ParentFrm.size.height-frm.size.height;
            frm.size.width=ParentFrm.size.width;
            //frm.size.height//Do not change.
            self.customBottomView.frame=frm;
            [self.view addSubview:self.customBottomView];
            [self showCustomBottomView:show];
        }
    }
    else
    {
      //Do nothing...
    }
}
@end
