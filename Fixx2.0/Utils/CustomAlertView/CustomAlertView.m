//
//  YBMessageAlertView.m
//  YeahBuddy
//
//  Created by Vivek Soni on 18/10/13.
//  Copyright (c) 2013 vInfotech. All rights reserved.
//

#import "CustomAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "HomeDashboardViewController.h"

@implementation CustomAlertView

//Initialize custom alert view
+ (CustomAlertView *)initAlertView
{
    static CustomAlertView *objAlertView;
    
    @synchronized([CustomAlertView class]) {
        if (!objAlertView) {
            objAlertView = [[CustomAlertView alloc] init];
        }
        
        return objAlertView;
    }
    
	return nil;
}
/*
   //Display Custom Alert view 
    Option 1: Display Only text without button, just send button title nil.
    option 2: Display Only Ok Button then send title=OK text only.
    option 3: Displa Ok and Cancel button then send title=ok and otherTitle=cancel.
 */
- (void) displayAlertViewWithView:(UIView *)view withTitle:(NSString *)strTitle withMessage:(NSString *)message withButtonTitle:(NSString *)title withOtherButtonTitle:(NSString *) otherTitle
{
    CGFloat titleLength = 0;
    CGFloat messageLength = 0;
    
    // Calculate Title text
    strTitle = [strTitle stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    CGSize constraintTitle = CGSizeMake(240 , 20000.0f);
    CGSize sizeTitle = [strTitle sizeWithFont:[UIFont fontWithName:ProximaNovaSemibold size:14.0f] constrainedToSize:constraintTitle lineBreakMode:NSLineBreakByWordWrapping];
    titleLength = MAX(sizeTitle.height, 20.0f);
    
    // Calculate Message text
    message = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    CGSize constraint = CGSizeMake(240 , 20000.0f);
    CGSize size = [message sizeWithFont:[UIFont fontWithName:ProximaNovaRegular size:14.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    messageLength = MAX(size.height, 20.0f);
    
    
    //Set Frame of transparent view and alert view.
    
    [_alertView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.90]];

    //Add Title to AlertView
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, 15,230, titleLength);
    lblTitle.font = [UIFont fontWithName:ProximaNovaSemibold size:20.0f];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = strTitle;
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    [_alertView addSubview:lblTitle];

    //Add Message to AlertView
    UILabel *lblMessage = [[UILabel alloc] init];
    lblMessage.frame = CGRectMake(10, titleLength +25, 230, messageLength+20);
    lblMessage.font = [UIFont fontWithName:ProximaNovaRegular size:14];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.text = message;
    lblMessage.numberOfLines = 0;
    lblMessage.textColor = [UIColor whiteColor];
    [_alertView addSubview:lblMessage];
    
    //Check for OK button
    if ([title length] !=0 && [otherTitle length] ==0) {
        UIButton *btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTitle setFrame:CGRectMake(0, lblMessage.frame.origin.y +lblMessage.frame.size.height+20, _alertView.frame.size.width, 50)];
        [btnTitle setBackgroundColor:[UIColor colorWithRed:42.0/255.0 green:202.0/255 blue:178.0/255 alpha:1.0]];
        [btnTitle setTitle:title forState:UIControlStateNormal];
        [btnTitle setTitle:title forState:UIControlStateHighlighted];
        [btnTitle addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
        [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height+50);
        
        [_alertView addSubview:btnTitle];
    } else if ([title length] !=0 && [otherTitle length] !=0){ //Check for OK and Cancel button
        
        UIButton *btnOtherTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    
        [btnOtherTitle setFrame:CGRectMake(0, lblMessage.frame.origin.y +lblMessage.frame.size.height+20, _alertView.frame.size.width/2, 50)];
        
        [btnOtherTitle.titleLabel setFont:[UIFont fontWithName:ProximaNovaSemibold size:16]];
        [btnOtherTitle setBackgroundColor:[UIColor colorWithRed:223.0/255.0 green:46.0/255 blue:136.0/255 alpha:1.0]];
        [btnOtherTitle setTitle:otherTitle forState:UIControlStateNormal];
        [btnOtherTitle addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
        
        [btnOtherTitle setTitle:otherTitle forState:UIControlStateHighlighted];
        [btnOtherTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        UIButton *btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTitle setFrame:CGRectMake(btnOtherTitle.frame.size.width, lblMessage.frame.origin.y +lblMessage.frame.size.height+20, _alertView.frame.size.width/2, 50)];
        [btnTitle.titleLabel setFont:[UIFont fontWithName:ProximaNovaSemibold size:16]];
        [btnTitle setBackgroundColor:[UIColor colorWithRed:42.0/255.0 green:202.0/255 blue:178.0/255 alpha:1.0]];
        [btnOtherTitle addTarget:self action:@selector(btnOKButton) forControlEvents:UIControlEventTouchUpInside];
        [btnTitle setTitle:title forState:UIControlStateNormal];
        [btnTitle setTitle:title forState:UIControlStateHighlighted];
        [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height+55);
        
        [_alertView addSubview:btnOtherTitle];
        [_alertView addSubview:btnTitle];
    }
    
    //Button Text Proxima Nova, Semibold, 36px, Color RGB (255, 255, 255)
    //Button BG Color RGB (240, 128, 000)
    
    // ImageView for Transuclent Screen
    [_imageViewTransparent setImage:[UIImage imageNamed:@"bg_cover.png"]];
    [_imageViewTransparent setUserInteractionEnabled:YES];
    [_imageViewTransparent setAlpha:0.30];

    // Add Tap Gesture on ImageView Transparent
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertView)];
    [tapSingle setNumberOfTouchesRequired:1];
    [tapSingle setNumberOfTapsRequired:1];
    [tapSingle setDelegate:self];
    _imageViewTransparent.alpha = 0.0f;
    [_imageViewTransparent addGestureRecognizer:tapSingle];
    [view addSubview:_imageViewTransparent];
    
    // Add Image FadeOut
    [UIView beginAnimations:@"fadeInBgView" context:NULL];
    [UIView setAnimationDuration:.5];
    _imageViewTransparent.alpha = 1.0f;
    [UIView commitAnimations];
    
    CGAffineTransform trans = CGAffineTransformScale(_alertView.transform, 0.01, 0.01);
    _alertView.transform = trans;	// do it instantly, no animation
    
    
    // Now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                                    _alertView.transform = CGAffineTransformScale(_alertView.transform, 100.0, 100.0);
                                }
                     completion:^(BOOL finished) {
                                    if (finished) {
                                        [self performSelector:@selector(shakeAlertView) withObject:nil afterDelay:0.3];
                                    }
                                }];
    [_alertView setHidden:NO];
    
        // Add AlertView BackGround Image
    [view addSubview:_alertView];
    
    //[self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:5.0];
}

- (void) displayCongratulationsAlertViewWithView:(UIView *)view withTitle:(NSString *)strTitle withSubtitle:(NSString *)strSubTitle withMessage:(NSString *)message withButtonTitle:(NSString *)title withOtherButtonTitle:(NSString *) otherTitle
{
    CGFloat titleLength = 0;
    CGFloat subTitleLength = 0;
    CGFloat messageLength = 0;
    
   
    
    // Calculate Title text
    strTitle = [strTitle stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    CGSize constraintTitle = CGSizeMake(240 , 20000.0f);
    CGSize sizeTitle = [strTitle sizeWithFont:[UIFont fontWithName:ProximaNovaSemibold size:14.0f] constrainedToSize:constraintTitle lineBreakMode:NSLineBreakByWordWrapping];
    titleLength = MAX(sizeTitle.height, 20.0f);
    
    
    // Calculate Sub Title text
    strSubTitle = [strSubTitle stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    CGSize constraintSubTitle = CGSizeMake(240 , 20000.0f);
    CGSize sizeSubTitle = [strSubTitle sizeWithFont:[UIFont fontWithName:ProximaNovaSemibold size:14.0f] constrainedToSize:constraintSubTitle lineBreakMode:NSLineBreakByWordWrapping];
    subTitleLength = MAX(sizeSubTitle.height, 20.0f);
    
    
    // Calculate Message text
    message = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    CGSize constraint = CGSizeMake(240 , 20000.0f);
    CGSize size = [message sizeWithFont:[UIFont fontWithName:ProximaNovaRegular size:14.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    messageLength = MAX(size.height, 20.0f);
    
    //Set Frame of transparent view and alert view.
    
     [_alertView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.90]];
    
    //Add Title to AlertView
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, 25,230, titleLength);
    lblTitle.font = [UIFont fontWithName:ProximaNovaSemibold size:17];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = strTitle;
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    [_alertView addSubview:lblTitle];
    
    
    //Add SubTitle to AlertView
    UILabel *lblSubTitle = [[UILabel alloc] init];
    lblSubTitle.frame = CGRectMake(10, lblTitle.frame.origin.y+lblTitle.frame.size.height+5,230, titleLength);
    lblSubTitle.font = [UIFont fontWithName:ProximaNovaRegular size:17];
    lblSubTitle.backgroundColor = [UIColor clearColor];
    lblSubTitle.textAlignment = NSTextAlignmentCenter;
    lblSubTitle.text = strSubTitle;
    lblSubTitle.numberOfLines = 0;
    lblSubTitle.textColor = [UIColor whiteColor];
    [_alertView addSubview:lblSubTitle];
    
    //Add Message to AlertView
    UILabel *lblMessage = [[UILabel alloc] init];
    lblMessage.frame = CGRectMake(10, titleLength + subTitleLength+45, 230, messageLength+50);
    lblMessage.font = [UIFont fontWithName:ProximaNovaRegular size:14];
    lblMessage.backgroundColor = [UIColor clearColor];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:3];
    
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : paragrahStyle,};
    
    lblMessage.attributedText = [[NSAttributedString alloc] initWithString:message                                                     attributes:attributtes];
    //lblMessage.text = message;
    lblMessage.numberOfLines = 0;
    lblMessage.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    [_alertView addSubview:lblMessage];
    
    //Shipping button
    UIButton *btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnTitle setFrame:CGRectMake(0, lblMessage.frame.origin.y +lblMessage.frame.size.height+15, _alertView.frame.size.width, 50)];
    [btnTitle setBackgroundColor:[UIColor colorWithRed:240.0/255.0 green:128.0/255 blue:0.0/255 alpha:1.0]];
    [btnTitle setTitle:title forState:UIControlStateNormal];
    [btnTitle setTitle:title forState:UIControlStateHighlighted];
    [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height+50);
    
    [_alertView addSubview:btnTitle];
    
    
    // ImageView for Transuclent Screen
    [_imageViewTransparent setImage:[UIImage imageNamed:@"bg_cover.png"]];
    [_imageViewTransparent setUserInteractionEnabled:YES];
    
    // Add Tap Gesture on ImageView Transparent
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertView)];
    [tapSingle setNumberOfTouchesRequired:1];
    [tapSingle setNumberOfTapsRequired:1];
    [tapSingle setDelegate:self];
    _imageViewTransparent.alpha = 0.0f;
    [_imageViewTransparent addGestureRecognizer:tapSingle];
    [view addSubview:_imageViewTransparent];
    
    // Add Image FadeOut
    [UIView beginAnimations:@"fadeInBgView" context:NULL];
    [UIView setAnimationDuration:.5];
    _imageViewTransparent.alpha = 1.0f;
    [UIView commitAnimations];
    
    //Set property on alertview.
    _alertView.layer.cornerRadius = 2.0;
    
    
    CGAffineTransform trans = CGAffineTransformScale(_alertView.transform, 0.01, 0.01);
    _alertView.transform = trans;	// do it instantly, no animation
    
    
    // Now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _alertView.transform = CGAffineTransformScale(_alertView.transform, 100.0, 100.0);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // [self performSelector:@selector(shakeAlertView) withObject:nil afterDelay:0.3];
                         }
                     }];
    [_alertView setHidden:NO];
    _isShippingAlertOn = TRUE;
    // Add AlertView BackGround Image
    [view addSubview:_alertView];
    [appDelegate.window bringSubviewToFront:_imageViewTransparent];
    [appDelegate.window bringSubviewToFront:_alertView];
    
   // [self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:5.0];
}

- (void) displayTakeAnTourAlertViewWithView:(UIView *)view withTitle:(NSString *)strTitle withMessage:(NSString *)message withButtonTitle:(NSString *)title withOtherButtonTitle:(NSString *) otherTitle
{
    CGFloat titleLength = 0;
    CGFloat messageLength = 0;
    
    
    // Calculate Title text
    strTitle = [strTitle stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    CGSize constraintTitle = CGSizeMake(240 , 20000.0f);
    CGSize sizeTitle = [strTitle sizeWithFont:[UIFont fontWithName:ProximaNovaSemibold size:14.0f] constrainedToSize:constraintTitle lineBreakMode:NSLineBreakByWordWrapping];
    titleLength = MAX(sizeTitle.height, 20.0f);
    
    // Calculate Message text
    message = [message stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    CGSize constraint = CGSizeMake(240 , 20000.0f);
    CGSize size = [message sizeWithFont:[UIFont fontWithName:ProximaNovaRegular size:14.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    messageLength = MAX(size.height, 20.0f);
    
    //Set Frame of transparent view and alert view.
    
     [_alertView setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.90]];
    
    //Add Title to AlertView
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.frame = CGRectMake(10, 20,230, titleLength);
    lblTitle.font = [UIFont fontWithName:ProximaNovaSemibold size:17];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.text = strTitle;
    lblTitle.numberOfLines = 0;
    lblTitle.textColor = [UIColor whiteColor];
    [_alertView addSubview:lblTitle];
    
    //Add Message to AlertView
    UILabel *lblMessage = [[UILabel alloc] init];
    lblMessage.frame = CGRectMake(10, titleLength +32, 230, messageLength+30);
    lblMessage.font = [UIFont fontWithName:ProximaNovaRegular size:14];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:5];
    [style setAlignment:NSTextAlignmentCenter];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [message length])];
   
    lblMessage.attributedText = attrString;
    //lblMessage.text = message;
    lblMessage.numberOfLines = 0;
    lblMessage.textColor = [UIColor whiteColor];
    [_alertView addSubview:lblMessage];
    
    //Check for OK button
    if ([title length] !=0 && [otherTitle length] ==0) {
        UIButton *btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTitle setFrame:CGRectMake(0, lblMessage.frame.origin.y +lblMessage.frame.size.height+20, _alertView.frame.size.width, 50)];
        [btnTitle setBackgroundColor:[UIColor colorWithRed:42.0/255.0 green:202.0/255 blue:178.0/255 alpha:1.0]];
        [btnTitle setTitle:title forState:UIControlStateNormal];
        [btnTitle setTitle:title forState:UIControlStateHighlighted];
        [btnTitle addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
        [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height+50);
        
        [_alertView addSubview:btnTitle];
    } else if ([title length] !=0 && [otherTitle length] !=0){ //Check for OK and Cancel button
        
        _btnSignIn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSignIn setFrame:CGRectMake(_btnSkipforNow.frame.size.width, lblMessage.frame.origin.y +lblMessage.frame.size.height+20, _alertView.frame.size.width/2, 50)];
        [_btnSignIn.titleLabel setFont:[UIFont fontWithName:ProximaNovaSemibold size:16]];
        [_btnSignIn setBackgroundColor:[UIColor colorWithRed:42.0/255.0 green:202.0/255 blue:178.0/255 alpha:1.0]];
        [_btnSignIn addTarget:self action:@selector(btnSignIn_ButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSignIn setTitle:title forState:UIControlStateNormal];
        [_btnSignIn setTitle:title forState:UIControlStateHighlighted];
        [_btnSignIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        _alertView.frame = CGRectMake(_alertView.frame.origin.x, _alertView.frame.origin.y, _alertView.frame.size.width, _alertView.frame.size.height+55);
        
        [_alertView addSubview:_btnSkipforNow];
        [_alertView addSubview:_btnSignIn];
    }
    
    //Button Text Proxima Nova, Semibold, 36px, Color RGB (255, 255, 255)
    //Button BG Color RGB (240, 128, 000)
    
    // ImageView for Transuclent Screen
    [_imageViewTransparent setImage:[UIImage imageNamed:@"bg_cover.png"]];
    [_imageViewTransparent setUserInteractionEnabled:YES];
    
    // Add Tap Gesture on ImageView Transparent
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertView)];
    [tapSingle setNumberOfTouchesRequired:1];
    [tapSingle setNumberOfTapsRequired:1];
    [tapSingle setDelegate:self];
    _imageViewTransparent.alpha = 0.0f;
    [_imageViewTransparent addGestureRecognizer:tapSingle];
    [view addSubview:_imageViewTransparent];
    
    // Add Image FadeOut
    [UIView beginAnimations:@"fadeInBgView" context:NULL];
    [UIView setAnimationDuration:.5];
    _imageViewTransparent.alpha = 1.0f;
    [UIView commitAnimations];

    
    CGAffineTransform trans = CGAffineTransformScale(_alertView.transform, 0.01, 0.01);
    _alertView.transform = trans;	// do it instantly, no animation
    
    
    // Now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _alertView.transform = CGAffineTransformScale(_alertView.transform, 100.0, 100.0);
                     }
                     completion:^(BOOL finished) {
                         /*if (finished) {
                             [self performSelector:@selector(shakeAlertView) withObject:nil afterDelay:0.3];
                         }*/
                     }];
    [_alertView setHidden:NO];
    
    // Add AlertView BackGround Image
    [view addSubview:_alertView];
    
    //[self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:5.0];
}


- (void)shakeAlertView
{
        // SHAKE ANIMATION ON CENTER BUTTON
    CGFloat t = 3.0;
    CGAffineTransform translateRight = CGAffineTransformTranslate(CGAffineTransformIdentity, t, 0.0);
    CGAffineTransform translateLeft = CGAffineTransformTranslate(CGAffineTransformIdentity, -t, 0.0);
    
    _alertView.transform = translateLeft;
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat
                     animations:^{
                                    [UIView setAnimationRepeatCount:2.0];
                                    _alertView.transform = translateRight;
                                }
                     completion:nil];
}

- (void)dismissAlertView
{
    
    [UIView beginAnimations:@"fadeInBgView" context:NULL];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationDidStopSelector:@selector(removeTransparent)];
    _imageViewTransparent.alpha = 0.0f;
    [UIView commitAnimations];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                                    _alertView.transform = CGAffineTransformScale(_alertView.transform, 0.01, 0.01);
                                }
                     completion:^(BOOL finished) {
                            _isShippingAlertOn = FALSE;
                                    [_alertView removeFromSuperview];
                                }];
}

#pragma mark IBAction
- (IBAction)btnSignIn_ButtonClicked:(id)sender {
    objSharedData.strTakeTheTourOn = @"No";
    [self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:0.0f];
    [appDelegate performSelector:@selector(SignUpLoginScreen) withObject:nil afterDelay:0.3];
 //   [appDelegate SignUpLoginScreen];
}


- (void)removeTransparent
{
    [_imageViewTransparent removeFromSuperview];
}

- (void) btnOKButton {

}

@end
