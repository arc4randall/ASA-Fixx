//
//  YBAppLoader.m
//  YeahBuddy
//
//  Created by Vivek Soni on 30/10/13.
//  Copyright (c) 2013 vInfotech. All rights reserved.
//

#import "AppLoader.h"
#import "AppDelegate.h"
#import "UIImage+animatedGIF.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppLoader

+ (AppLoader *)initLoaderView
{
    static AppLoader *objAppLoader;
    @synchronized([AppLoader class]) {
        if (!objAppLoader) {
            objAppLoader = [[AppLoader alloc] init];
        }
        
        return objAppLoader;
    }
    
	return nil;
}

- (void)startActivityLoader:(UIView *)view :(NSString *)text {
    //Remove Indicator is Exists
    if (_bgImageView) {
        [_bgImageView removeFromSuperview];
    }
    
    _viewBgLoader = [[UIView alloc] init];
    _viewBgLoader.frame =  CGRectMake(0, appDelegate.window.frame.size.height, appDelegate.window.frame.size.width, 60);
    _viewBgLoader.backgroundColor = [UIColor blackColor];
    
    _bgImageView = [[UIImageView alloc] init];
    _bgImageView.frame = CGRectMake(0, 0, appDelegate.window.frame.size.width, appDelegate.window.frame.size.height);
    _bgImageView.image = [UIImage imageNamed:@"bg_cover.png"];
    
//    _loaderBGImageView = [[UIImageView alloc] init];
//    
//    _loaderBGImageView.frame = CGRectMake(0,appDelegate.window.frame.size.height, appDelegate.window.frame.size.width, 60);
    
   // _loaderBGImageView.image = [UIImage imageNamed:@"erroe_bg.png"];
   // _loaderBGImageView.tag = 401;
    
//    _loaderImageView = [[UIImageView alloc] init];
//
//    _loaderImageView.frame = CGRectMake(50,8, 44, 44);
//    
//    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ajax-loader" withExtension:@"gif"];
//    _loaderImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
//    _loaderImageView.tag = 501;
//    [_viewBgLoader addSubview:_loaderImageView];

    
    //Add Loader Indicator
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(70,30);
    spinner.hidesWhenStopped = YES;
    [_viewBgLoader addSubview:spinner];
    [spinner startAnimating];
    

    _lblText = [[UILabel alloc] init];
    [_lblText setBackgroundColor:[UIColor clearColor]];
    [_lblText setTextAlignment:NSTextAlignmentLeft];

    [_lblText setFrame:CGRectMake(100, 20,  200, 20)];
    [_lblText setFont:[UIFont fontWithName:ProximaNovaSemibold size:16]];
    [_lblText setTextColor:[UIColor whiteColor]];
    [_lblText setText:text];
    [_viewBgLoader addSubview:_lblText];
    
    
    [_bgImageView addSubview:_viewBgLoader];

    [_viewBgLoader setAlpha:0.7f];
    [appDelegate.window addSubview:_bgImageView];
    
    [self performSelector:@selector(animateBottomlabel) withObject:nil afterDelay:0.2];
}

#pragma mark - Bottom Label

- (void)animateBottomlabel {
    NSValue * from = [NSNumber numberWithFloat:_viewBgLoader.layer.position.y];
    int YAxis = 0;
    
    YAxis = 60;
    
    NSValue * to =  [NSNumber numberWithFloat:_viewBgLoader.layer.position.y-YAxis];
    NSString * keypath = @"position.y";
    [_viewBgLoader.layer addAnimation:[self bounceAnimationFrom:from to:to forKeyPath:keypath withDuration:.6] forKey:@"bounce"];
    [_viewBgLoader.layer setValue:to forKeyPath:keypath];
}

#pragma mark - CAAnimations

- (CABasicAnimation *)bounceAnimationFrom:(NSValue *)from
                                       to:(NSValue *)to
                               forKeyPath:(NSString *)keypath
                             withDuration:(CFTimeInterval)duration {
    CABasicAnimation * result = [CABasicAnimation animationWithKeyPath:keypath];
    [result setFromValue:from];
    [result setToValue:to];
    [result setDuration:duration];
    [result setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:.5 :1.8 :.8 :0.8]];

    return  result;
}

- (void)stopActivityLoader {
    
    [UIView beginAnimations:@"ShowTable" context:nil];
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeOverlay)];
    [_viewBgLoader setFrame:CGRectMake(_viewBgLoader.frame.origin.x, _viewBgLoader.frame.origin.y+_viewBgLoader.frame.size.height,_viewBgLoader.frame.size.width , _viewBgLoader.frame.size.height)];
    [UIView commitAnimations];
    
    [self performSelector:@selector(removeOverlay) withObject:nil afterDelay:0.5];
}

- (void)changeTextLoader:(NSString *)strText {
    _lblText.text = strText;
}

- (void)showTextOnly:(NSString *)strText {
    [_lblText setTextAlignment:NSTextAlignmentCenter];
    [_lblText setFrame:CGRectMake(10, 20,  300, 20)];
    
    _lblText.text = strText;
    [_loaderImageView setHidden:YES];
}

- (void)removeOverlay {
    [_bgImageView removeFromSuperview];
}

@end
