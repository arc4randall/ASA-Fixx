//
//  UIImage+scale_resize.h
//  Zaptaview
//
//  Created by Shelesh Rawat on 07/02/13.
//  Copyright (c) 2013 Shelesh Rawat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (scale_resize)


-(UIImage*)scaleToSize:(CGSize)size;
UIImage* resizedImage(UIImage *inImage, CGRect thumbRect);

//** Generate image with target size specified. Extra space would be white background. AscpectFit image for given constarint size**//
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;

//** Generate AscpectFit image for given constarint size**//
- (UIImage *)imageByScalingProportionallyForConstraintSize:(CGSize)targetSize;

//** Generate from given rect**//
-(UIImage *)imageFromTargetRect:(CGRect)targetRect;

//** Generate Top & Centered image for given constarint size**//
- (UIImage *)imageByTopCenteredToThumbnailSize:(CGSize)thumbSize;

//+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

//** Generate image with UIImageOrientationUp **////
-(UIImage *)imageWithUIImageOrientationUp:(NSInteger)alAssetOrientation;

//** Generate profile image with target size **////
-(UIImage *) userProfileImageForSize:(CGSize)targetSize;


@end
