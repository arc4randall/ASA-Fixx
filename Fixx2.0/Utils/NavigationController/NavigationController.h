//
//  NavigationController.h
//  UFree
//
//  Created by Shelesh Rawat on 10/11/12.
//
//

#import <UIKit/UIKit.h>

@interface NavigationController : UINavigationController
@property (nonatomic,strong) UIView *customBottomView;

#pragma mark - Other methods
-(void)showCustomBottomView:(BOOL) show;
@end
