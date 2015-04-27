//
//  YBAppLoader.h
//  YeahBuddy
//
//  Created by Vivek Soni on 30/10/13.
//  Copyright (c) 2013 vInfotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppLoader : NSObject

+ (AppLoader *) initLoaderView;

@property (strong, nonatomic) UIView *viewBgLoader;
@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *loaderImageView;
@property (strong, nonatomic) UIImageView *loaderBGImageView;
@property (strong, nonatomic) UILabel *lblText;

- (void)startActivityLoader:(UIView *)view :(NSString *)text;
- (void)stopActivityLoader;
- (void)changeTextLoader:(NSString *)strText;
- (void)showTextOnly:(NSString *)strText;

@end
