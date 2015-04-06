//
//  LeftTabController.h
//  MedlinxPatient
//
//  Created by Vandana Singh on 08/5/14.
//  Copyright (c) 2013 Vandana Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftTabController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tblMainMenuOption;
@property (strong, nonatomic) IBOutlet UILabel *lbl_header;
@property (strong, nonatomic) IBOutlet UIImageView *image_header;
@property (strong, nonatomic) IBOutlet UIButton *btn_header;

-(IBAction)btn_sliderClickedAction:(id)sender;
@end
