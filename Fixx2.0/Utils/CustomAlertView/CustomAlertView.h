//
//  YBMessageAlertView.h
//  YeahBuddy
//
//  Created by Vivek Soni on 18/10/13.
//  Copyright (c) 2013 vInfotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomAlertView : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIImageView *imageViewTransparent;
@property (nonatomic) BOOL isShippingAlertOn;
@property (nonatomic, strong) UIButton *btnSkipforNow;
@property (nonatomic, strong) UIButton *btnSignIn;


+ (CustomAlertView *) initAlertView;

//Method for display custom alert view 
- (void) displayAlertViewWithView:(UIView *)view withTitle:(NSString *)strTitle withMessage:(NSString *)message withButtonTitle:(NSString *)title withOtherButtonTitle:(NSString *) otherTitle;


- (void) displayCongratulationsAlertViewWithView:(UIView *)view withTitle:(NSString *)strTitle withSubtitle:(NSString *)strSubTitle withMessage:(NSString *)message withButtonTitle:(NSString *)title withOtherButtonTitle:(NSString *) otherTitle;


- (void) displayTakeAnTourAlertViewWithView:(UIView *)view withTitle:(NSString *)strTitle withMessage:(NSString *)message withButtonTitle:(NSString *)title withOtherButtonTitle:(NSString *) otherTitle;
- (void)dismissAlertView;
@end
