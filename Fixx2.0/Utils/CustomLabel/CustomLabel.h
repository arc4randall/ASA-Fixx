//
//  CustomLabel.h
//  M2WP
//
//  Created by Akshay Jain on 07/02/12.
//  Copyright (c) 2012 Viscus Infotech Ltd. All rights reserved.


//This class is made to customize the UILabel as throughout the app. The same font is followed.
#import <Foundation/Foundation.h>

@interface CustomLabel : UILabel
@property (nonatomic,strong) NSString *customFontName;

-(void)setLabelFont:(NSString *)name fsize:(CGFloat )FontSize;
@end