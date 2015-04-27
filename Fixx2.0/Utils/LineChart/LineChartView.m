//
//  LineChartView.m
//  DrawDemo
//
//  Created by 东子 Adam on 12-5-31.
//  Copyright (c) 2012年 热频科技. All rights reserved.
//

#import "LineChartView.h"

@interface LineChartView()
{
    CALayer *linesLayer;
    
    
    UIView *popView;
    UILabel *disLabel;
}

@end

@implementation LineChartView

@synthesize array;

@synthesize hInterval,vInterval;

@synthesize hDesc,vDesc;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        hInterval = 10;
        vInterval = 50;
        
        linesLayer = [[CALayer alloc] init];
        linesLayer.masksToBounds = YES;
        linesLayer.contentsGravity = kCAGravityLeft;
        linesLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        
        [self.layer addSublayer:linesLayer];
        
        
        //PopView
        popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [popView setBackgroundColor:[UIColor blackColor]];
        [popView setAlpha:0.0f];
        
        disLabel = [[UILabel alloc]initWithFrame:popView.frame];
        [disLabel setTextAlignment:NSTextAlignmentCenter];
        [disLabel setTextColor:[UIColor whiteColor]];
        [disLabel setFont:[UIFont fontWithName:@"Arial" size:14.0f]];
        [popView addSubview:disLabel];
        [self addSubview:popView];
    }
    return self;
}

#define ZeroPoint CGPointMake(30,260)

- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画背景线条------------------
    CGColorRef backColorRef = [UIColor clearColor].CGColor;
    CGFloat backLineWidth = 2.f;
    CGFloat backMiterLimit = 0.f;
    
    CGContextSetLineWidth(context, backLineWidth);//主线宽度
    CGContextSetMiterLimit(context, backMiterLimit);//投影角度  
    
    CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, backColorRef);//设置双条线 
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineCapRound );
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.50].CGColor);
    

    
    int x = 320 ;
    int y = 500 ;

    UILabel *lblVerticalLine = [[UILabel alloc] initWithFrame:CGRectMake(29, 70, 2,400)];
    [lblVerticalLine setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.50]];
    [self addSubview:lblVerticalLine];
    
    
    for (int i=0; i<vDesc.count; i++) {
        
        CGPoint bPoint = CGPointMake(30, y);
        CGPoint ePoint = CGPointMake(x, y);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setCenter:CGPointMake(bPoint.x-15, bPoint.y)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        if ([vDesc count]/4==i) {
            [label setText:@"wk"];
        }
        
        [self addSubview:label];
        
        CGContextMoveToPoint(context, bPoint.x, bPoint.y-30);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y-30);
        
        y -= 20;
        
    }
    
    //for (int i=0; i<array.count-1; i++) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(260, 470, 40, 30)];
        [label setTextAlignment:NSTextAlignmentRight];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor whiteColor]];
        label.numberOfLines = 1;
        label.adjustsFontSizeToFitWidth = YES;
        //label.minimumFontSize = 1.0f;
       // [label setText:[hDesc objectAtIndex:i]];
        [label setText:@"$$"];
        
        [self addSubview:label];
    //}
    
    
//    //画点线条------------------
    CGColorRef pointColorRef = [UIColor colorWithRed:24.0f/255.0f green:116.0f/255.0f blue:205.0f/255.0f alpha:1.0].CGColor;
    CGFloat pointLineWidth = 1.5f;
    CGFloat pointMiterLimit = 5.0f;
    
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    CGContextSetMiterLimit(context, pointMiterLimit);//投影角度  
    
    
    CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, pointColorRef);//设置双条线 
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGContextSetLineCap(context, kCGLineCapRound );
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    //Line Color
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.50].CGColor);

	//绘图
	CGPoint p1 = [[array objectAtIndex:0] CGPointValue];
	int i = 1;
	CGContextMoveToPoint(context, p1.x+30, 470-p1.y);
	for (; i<[array count]; i++)
	{
		p1 = [[array objectAtIndex:i] CGPointValue];
        CGPoint goPoint = CGPointMake(p1.x, 500-p1.y*vInterval/500);
		CGContextAddLineToPoint(context, goPoint.x, goPoint.y);
        //添加触摸点
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [bt setBackgroundColor:[UIColor colorWithRed:42.0/255.0 green:202.0/255 blue:178.0/255 alpha:1.0]];
        
        [bt setFrame:CGRectMake(0, 0, 8, 8)];
        bt.layer.cornerRadius = bt.frame.size.width/2.0;
         bt.layer.masksToBounds = YES;
        [bt setCenter:goPoint];
        [bt setTag:p1.y];
        [bt addTarget:self
               action:@selector(btAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bt];
	}
	CGContextStrokePath(context);
}

- (void)btAction:(id)sender {
    UIButton *bt = (UIButton*)sender;
    [disLabel setText:[NSString stringWithFormat:@"$%d",bt.tag]];
    popView.center = CGPointMake(bt.center.x, bt.center.y - popView.frame.size.height/2);
    [popView setAlpha:1.0f];
}

@end
