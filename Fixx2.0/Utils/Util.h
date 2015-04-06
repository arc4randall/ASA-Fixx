//
//  Util.h
//  LiquidOxigen
//
//  Created by Anoop Kumar Jain on 04/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Util : NSObject {
    
}

+(void) setShadowOnLabel:(UILabel *)label;
+(UIImage *) getUIImageForName:(NSString *) imgName;
+(float)getHeightForLabel:(UILabel *)label;
+(float)getHeightForLabelWithLine:(UILabel *)label withLine:(int)setLines;
+(void)setLabelWithMaxWidth:(UILabel *) label maxWidth:(CGFloat)maxWidth;
+(void)setShakingAnimationOnView:(UIView *)view;//ShakingAnimation
+(void)bounceAnimationOnView:(UIView *)view;//BounceAnimation
+(void)showViewWithAnimation:(UIView *)view;
+(NSString *)getDateStrInFormat:(NSString *)str;
+(NSString *)getTimeInFormatWithStr:(NSString *) str;

+(void) setWebViewWithPath:(UIWebView *)webView withPath:(NSString*)path;
+(void)setImageOnButtonWithPath:(UIButton *)btn withPath:(NSString*)path;
+(float) getStringHeightWithFont:(UIFont *)font withMaxWidth:(CGFloat)width string:(NSString *)str;
+(float) getStringHeightWithFontWithOutLineLimit:(UIFont *)font withMaxWidth:(CGFloat)width string:(NSString *)str;
//+(NSString *)handleTextWithString:(NSString *)str;

+ (NSString *)extractYoutubeID:(NSString *)youtubeURL;
+(NSString *) getYouTubeVideoFrameURL:(NSString *)urlStr;
+ (UIImage*) getSmallImage:(UIImage*) img;
@end
