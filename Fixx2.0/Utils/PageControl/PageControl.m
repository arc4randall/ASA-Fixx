//
//  PageControl.m
//  UFree
//
//  Created by Vivek Soni on 22/07/13.
//
//

#import "PageControl.h"
#import "AppDelegate.h"

#define kDotDiameter 20.0
#define kDotSpacer 35.0

float flSpacer = 45.0;
@implementation PageControl

@synthesize dotColorCurrentPage;
@synthesize dotColorOtherPage;
@synthesize pagedelegate;


- (NSInteger)currentPage
{
    return _currentPage;
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = MIN(MAX(0, page), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (NSInteger)numberOfPages
{
    return _numberOfPages;
}

- (void)setNumberOfPages:(NSInteger)pages
{
    _numberOfPages = MAX(0, pages);
    _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
    [self setNeedsDisplay];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // Default colors.
        self.backgroundColor = [UIColor clearColor];
        
        self.dotColorCurrentPage = [UIColor  colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f];
        self.dotColorOtherPage = [UIColor  colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.50f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetAllowsAntialiasing(context, true);
//    
//    CGRect currentBounds = self.bounds;
//    CGFloat dotsWidth = self.numberOfPages*kDotDiameter + MAX(0, self.numberOfPages-1)*flSpacer;
//    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
//    CGFloat y = CGRectGetMidY(currentBounds)-kDotDiameter/2;
//    for (int i=0; i<_numberOfPages; i++)
//    {
//        CGRect circleRect = CGRectMake(x, y, kDotDiameter, kDotDiameter);
//        if (i == _currentPage)
//        {
//            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
//        }
//        else
//        {
//            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
//        }
//        CGContextFillEllipseInRect(context, circleRect);
//        x += kDotDiameter + flSpacer;
//    }
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    
    CGRect currentBounds = self.bounds;
    CGFloat dotsWidth = self.numberOfPages*kDotDiameter + MAX(0, self.numberOfPages-1)*flSpacer;
    CGFloat x = CGRectGetMidX(currentBounds)-dotsWidth/2;
    CGFloat y = CGRectGetMidY(currentBounds)-kDotDiameter/2;
    for (int i=0; i<_numberOfPages; i++)
    {
        CGRect circleRect = CGRectMake(x, y, 60, 1.5);
        if (i == _currentPage)
        {
            CGContextSetFillColorWithColor(context, self.dotColorCurrentPage.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(context, self.dotColorOtherPage.CGColor);
        }
       // CGContextFillEllipseInRect(context, circleRect);
       CGContextFillRect (context, circleRect);
        x += kDotDiameter + flSpacer;
    }
    
    
//    CGRect rectangle = CGRectMake(0, 100, 320, 100);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
//    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
//    CGContextFillRect(context, rectangle);
    
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.pagedelegate) return;
    
    CGPoint touchPoint = [[[event touchesForView:self] anyObject] locationInView:self];
    
    CGFloat dotSpanX = self.numberOfPages*(kDotDiameter + flSpacer);
    CGFloat dotSpanY = kDotDiameter + flSpacer;
    
    CGRect currentBounds = self.bounds;
    CGFloat x = touchPoint.x + dotSpanX/2 - CGRectGetMidX(currentBounds);
    CGFloat y = touchPoint.y + dotSpanY/2 - CGRectGetMidY(currentBounds);
    
    if ((x<0) || (x>dotSpanX) || (y<0) || (y>dotSpanY)) return;
    
    self.currentPage = floor(x/(kDotDiameter+flSpacer));
    if ([self.pagedelegate respondsToSelector:@selector(pageControlPageDidChange:)])
    {
        [self.pagedelegate pageControlPageDidChange:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
