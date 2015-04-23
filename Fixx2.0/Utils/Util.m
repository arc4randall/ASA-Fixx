//
//  Util.m
//  LiquidOxigen
//
//  Created by Anoop Kumar Jain on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "Util.h"
//#import "Constant.h"
#import <QuartzCore/QuartzCore.h>
@implementation Util


+(void) setShadowOnLabel:(UILabel *)label{
    label.layer.shadowColor = [UIColor blackColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(0,2);
    label.layer.shadowOpacity = 0.5;
    label.layer.shadowRadius = 1.0; 
}

+(UIImage *) getUIImageForName:(NSString *) imgName{
    NSString * imageFilePath = nil;
        imageFilePath = [[NSBundle mainBundle] pathForResource:[[NSString alloc] initWithFormat:@"%@.png",   imgName] ofType:nil];
    if (imageFilePath == nil) {
        printf("WARNING! Image resource path is Nil\n");
    }
    
    return [[UIImage alloc] initWithContentsOfFile:imageFilePath];
}

+(float)getHeightForLabel:(UILabel *)label{
    CGSize maximumLabelSize = CGSizeMake(225,9999);
    
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    

    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
    
    int lines = label.frame.size.height / label.font.pointSize;
    [label setNumberOfLines:lines];
    
    return label.frame.size.height;
}

+(float)getHeightForLabelWithLine:(UILabel *)label withLine:(int)setLines{
    CGSize maximumLabelSize = CGSizeMake(225,9999);
    
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    label.frame = newFrame;
        
    int lines = label.frame.size.height / label.font.pointSize;
    
    if (lines <= setLines) {
        [label setNumberOfLines:lines];
        //NSLog(@"Lines = %d, labelHeight = %f", lines, label.frame.size.height);
    }
    else {
        
        CGRect anotherFrame = label.frame;
        anotherFrame.size.height = (setLines + 1) * label.font.pointSize + 12.0/*defected font padding */;
        label.frame = anotherFrame;
        [label setNumberOfLines:setLines];
        //NSLog(@"Lines = %d, labelHeight = %f", lines, label.frame.size.height);
    }
    return label.frame.size.height;
}

+(void)setLabelWithMaxWidth:(UILabel *) label maxWidth:(CGFloat)maxWidth{
    CGSize maximumLabelSize = CGSizeMake(maxWidth,9999);
    
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
    
    //adjust the label the the new height.
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    newFrame.size.width = expectedLabelSize.width;
    label.frame = newFrame;
    
    int lines = label.frame.size.height / label.font.pointSize;
    //float wi = label.frame.size.width;
    //NSLog(@"line = %d, width = %f",lines, wi);
    [label setNumberOfLines:lines];
}

+(void)setShakingAnimationOnView:(UIView *)view{
    CABasicAnimation *animation = 
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.1];
    [animation setRepeatCount:2
     ];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([view center].x - 6.0f, [view center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([view center].x + 6.0f, [view center].y)]];
    [[view layer] addAnimation:animation forKey:@"position"];

}
+(void)bounceAnimationOnView:(UIView *)view //BounceAnimation
{
    CATransform3D start=view.layer.transform;
    CATransform3D end=CATransform3DMakeScale(1.2f, 1.2f, 1.0f);

    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform"];
    [animation setDuration:0.1f];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:1];
    [animation setFromValue:[NSValue valueWithCATransform3D:start]];
    [animation setToValue:[NSValue valueWithCATransform3D:end]];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:YES];
    
    [view.layer addAnimation:animation forKey:@"Bounce"];
    
    
    
}
+(void)showViewWithAnimation:(UIView *)view{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:0.4];
    view.alpha = 1;
    [UIView commitAnimations];
}

+(NSString *)getDateStrInFormat:(NSString *)str{
    NSString *stringWithoutDash = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString * tillSpaceStr = [stringWithoutDash substringToIndex:8];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormat dateFromString:tillSpaceStr];  
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"dd MMM YYYY"];
    tillSpaceStr = [dateFormat stringFromDate:date];  

    return tillSpaceStr;
}

+(NSString *)getTimeInFormatWithStr:(NSString *) str{
    NSString *stringWithoutDash = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *stringWithoutcolon = [stringWithoutDash stringByReplacingOccurrencesOfString:@":" withString:@""];
    NSString * removeSpace = [stringWithoutcolon stringByReplacingOccurrencesOfString:@" " withString:@""];

    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormat dateFromString:removeSpace];  
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"HH:mm a"];
    stringWithoutDash = [dateFormat stringFromDate:date];  
    
    return stringWithoutDash;

}

+(void) setWebViewWithPath:(UIWebView *)webView withPath:(NSString*)path{
    NSString * prefix = [NSString stringWithFormat:@"http://192.168.0.42/%@",path];
  //  NSLog(@"prefix = %@",prefix);
    NSURL *url = [NSURL fileURLWithPath:prefix];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];            
    [webView loadRequest:urlRequest];
}

+(void)setImageOnButtonWithPath:(UIButton *)btn withPath:(NSString*)path{
    NSString * prefix = [NSString stringWithFormat:@"http://192.168.0.42/%@",path];
    NSURL *url = [NSURL fileURLWithPath:prefix];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    [btn setImage:image forState:UIControlStateNormal];
}

+(float) getStringHeightWithFont:(UIFont *)font withMaxWidth:(CGFloat)width string:(NSString *)str{
    
    CGSize maximumSize = CGSizeMake(width,9999);    
    CGSize expectedSize = [str sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
    
    float height = expectedSize.height;
    int lines = height / font.pointSize;
    //NSLog(@"lines = %d",lines);
    if (lines >6) {
        height = (6+1) * font.pointSize +10.0;
    }
    return height;
}

+(float) getStringHeightWithFontWithOutLineLimit:(UIFont *)font withMaxWidth:(CGFloat)width string:(NSString *)str{
    CGSize maximumSize = CGSizeMake(width,9999);    
    CGSize expectedSize = [str sizeWithFont:font constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
    
    float height = expectedSize.height;
    
    return height;
}
/*
+(NSString *)handleTextWithString:(NSString *)str{
    NSString * textStr = nil;
    textStr =[str stringByReplacingOccurrencesOfString:@"@$@" withString:@"\""] ;
    textStr = [textStr stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    textStr = [[[[[[textStr stringByDecodingHTMLEntities] stringByReplacingOccurrencesOfString:@"@#@" withString:@"\\"] stringByReplacingOccurrencesOfString:@"$$" withString:@" "] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"<i>" withString:@""] stringByReplacingOccurrencesOfString:@"<u>" withString:@""];

    return textStr;
}*/

+ (NSString *)extractYoutubeID:(NSString *)youtubeURL
{
    //Now not using
    NSError *error = NULL;  
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"?.*v=([^&]+)" options:NSRegularExpressionCaseInsensitive error:&error];
    NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:youtubeURL options:0 range:NSMakeRange(0, [youtubeURL length])];
    if(!NSEqualRanges(rangeOfFirstMatch, NSMakeRange(NSNotFound, 0)))
    {
        NSString *substringForFirstMatch = [youtubeURL substringWithRange:rangeOfFirstMatch];
        
        return substringForFirstMatch;
    }
    return nil;
}

+(NSString *) getYouTubeVideoFrameURL:(NSString *)urlStr{
    NSArray * videoURLSplit = nil;
    //if ([urlStr rangeOfString:@"v="].location!= NSNotFound)
    if ([urlStr rangeOfString:@"embed/"].location!= NSNotFound)
    {
        videoURLSplit = [urlStr componentsSeparatedByString:@"embed/"];
    }else {
       // NSLog(@"check youtube frame image");
    }
//    else if ([urlStr rangeOfString:@"be/"].location!= NSNotFound){
//        videoURLSplit = [urlStr componentsSeparatedByString:@"be/"];
//    }
    NSString *videoID = [videoURLSplit[1] substringToIndex:11];
    
    NSString * youTubeVideoFrameUrl = [NSString stringWithFormat:@"http://i.ytimg.com/vi/%@/1.jpg",videoID];
    return youTubeVideoFrameUrl;
}

+ (UIImage*) getSmallImage:(UIImage*) img
{
    CGRect rect = CGRectMake(0.0, 0.0, 320.0, 480.0);
    
    UIGraphicsBeginImageContext(rect.size);
    [img drawInRect:rect];
    
    return UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
