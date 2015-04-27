//
//  CustomLabel.m
//  M2WP
//
//  Created by Akshay Jain on 07/02/12.
//  Copyright (c) 2012 Viscus Infotech Ltd. All rights reserved.


#import "CustomLabel.h"

@implementation CustomLabel

- (id)init
{
    self=[super init];
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    return self;
}

- (void)setLabelFont:(NSString *)name fsize:(CGFloat )FontSize
{
    self.customFontName=name;
    [self setLabelFont:FontSize];
}

- (void)setLabelFont:(CGFloat )FontSize
{
    if(self.customFontName)
        [self setFont:[UIFont fontWithName:self.customFontName size:FontSize]];
    else
        [self setFont:[UIFont fontWithName:@"Bariol-Thin" size:FontSize]];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setLabelFont: self.font.pointSize];
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if([key isEqualToString:@"customFontName"])
        self.customFontName = (NSString *)value;
    
}

- (id)valueForKey:(NSString *)key
{
    if([key isEqualToString:@"customFontName"])
        return self.customFontName;
    else
        return [super valueForKey:key];
}

@end

