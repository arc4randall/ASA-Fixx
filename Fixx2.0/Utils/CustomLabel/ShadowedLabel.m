//
//  ShadowedLabel.m
//
//  Created by Tyler Neylon on 4/19/10.
//  Copyleft 2010 Bynomial.
//

#import "ShadowedLabel.h"


@implementation ShadowedLabel

- (id)initWithFrame:(CGRect)frame {
  if (![super initWithFrame:frame]) return nil;
  self.clipsToBounds = NO;
  return self;
}

- (void)drawTextInRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);

  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  float colorValues[] = {0, 0, 0, 1};
  CGColorRef shadowColor = CGColorCreate(colorSpace, colorValues);
  CGSize shadowOffset = CGSizeMake(5, 5);
  CGContextSetShadowWithColor (context, shadowOffset, 4 /* blur */, shadowColor);
  [super drawTextInRect:rect];

  CGColorRelease(shadowColor);
  CGColorSpaceRelease(colorSpace);
  CGContextRestoreGState(context);
}

@end
