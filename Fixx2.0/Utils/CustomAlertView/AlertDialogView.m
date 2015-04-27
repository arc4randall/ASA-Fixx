//
//  CODialog.m
//  CODialog
//
//  Created by Erik Aigner on 10.04.12.
//  Copyright (c) 2012 chocomoko.com. All rights reserved.
//

#import "AlertDialogView.h"
#import <QuartzCore/QuartzCore.h>


@interface UFDialogWindowOverlay : UIWindow
@property (nonatomic, strong) AlertDialogView *dialog;

@end

@interface AlertDialogView ()
@property (nonatomic, strong) UFDialogWindowOverlay *overlay;
@property (nonatomic, strong) UIView *hostView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *subtitleFont;
@property (nonatomic, strong) UIFont *otherMsgtitleFont;
@property (nonatomic, assign) NSInteger highlightedIndex;

@end

#define UFDialogSynth(x) @synthesize x = x##_;
#define UFDialogAssertMQ() NSAssert(dispatch_get_current_queue() == dispatch_get_main_queue(), @"%@ must be called on main queue", NSStringFromSelector(_cmd));

#define kUFDialogAnimationDuration 0.15
#define kUFDialogPopScale 0.5
#define kUFDialogPadding 10.0
#define kUFDialogFrameInset 10.0
#define kUFDialogButtonHeight 37.0
#define kUFDialogTextFieldHeight 47.0

@implementation AlertDialogView {
@private
    struct {
        CGRect titleRect;
        CGRect subtitleRect;
        CGRect otherMsgRect;
        CGRect accessoryRect;
        CGRect textFieldsRect;
        CGRect buttonRect;
    } layout;
}
UFDialogSynth(customView)
UFDialogSynth(dialogStyle)
UFDialogSynth(title)
UFDialogSynth(subtitle)
UFDialogSynth(otherMsgtitle)
UFDialogSynth(batchDelay)
UFDialogSynth(overlay)
UFDialogSynth(hostView)
UFDialogSynth(contentView)
UFDialogSynth(accessoryView)
UFDialogSynth(textFields)
UFDialogSynth(buttons)
UFDialogSynth(titleFont)
UFDialogSynth(subtitleFont)
UFDialogSynth(otherMsgtitleFont)
UFDialogSynth(highlightedIndex)


+ (instancetype)dialogWithView:(UIView *)hostView {
    return [[self alloc] initWithView:hostView];
}

- (instancetype)initWithView:(UIView *)hostView {
    self = [super initWithFrame:[self defaultDialogFrame]];
    if (self) {
        self.batchDelay = 0;
        self.highlightedIndex = -1;
        self.titleFont = TITLE_FONT;
        self.subtitleFont = SUBTITLE_FONT;
        self.otherMsgtitleFont = MESSAGETITLE_FONT;
        
        self.hostView = hostView;
        self.opaque = NO;
        self.alpha = 1.0;
        self.buttons = [NSMutableArray new];
        self.textFields = [NSMutableArray new];
        
        // Register for keyboard notifications
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [nc addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)adjustToKeyboardBounds:(CGRect)bounds {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat height = CGRectGetHeight(screenBounds) - CGRectGetHeight(bounds);
    
    CGRect frame = self.frame;
    frame.origin.y = (height - CGRectGetHeight(self.bounds)) / 2.0;
    
    if (CGRectGetMinY(frame) < 0) {
    }
    
    [UIView animateWithDuration:kUFDialogAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        // stub
    }];
}

- (void)keyboardWillShow:(NSNotification *)note {
    NSValue *value = [note userInfo][UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [value CGRectValue];
    
    [self adjustToKeyboardBounds:frame];
}

- (void)keyboardWillHide:(NSNotification *)note {
    [self adjustToKeyboardBounds:CGRectZero];
}

- (CGRect)defaultDialogFrame {
	CGRect insetFrame;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
		CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
		insetFrame = CGRectIntegral(CGRectInset(appFrame, 20.0, 20.0));
		insetFrame.size.height = 180.0;
		

	}
	else
	{
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
  
	insetFrame = CGRectIntegral(CGRectInset(appFrame, 247.5,427.0)     );
		insetFrame.size.height = 180.0;
		

	}
        
        
    return insetFrame;
}

- (void)setProgress:(CGFloat)progress {
    UIProgressView *view = (id)self.accessoryView;
    if ([view isKindOfClass:[UIProgressView class]]) {
        // Check for selector for iOS 4 compatibility
        if ([view respondsToSelector:@selector(setProgress:animated:)]) {
            [view setProgress:progress animated:YES];
        } else {
            [view setProgress:progress];
        }
    }
}

- (CGFloat)progress {
    UIProgressView *view = (id)self.accessoryView;
    if ([view isKindOfClass:[UIProgressView class]]) {
        return view.progress;
    }
    return 0;
}

- (UIView *)makeAccessoryView {
    if (self.dialogStyle == UFDialogStyleIndeterminate) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView startAnimating];
        
        return activityView;
    } else if (self.dialogStyle == UFDialogStyleDeterminate) {
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        progressView.frame = CGRectMake(0, 0, 200.0, 88.0);
        
        return progressView;
    } else if (self.dialogStyle == UFDialogStyleSuccess ||
               self.dialogStyle == UFDialogStyleError) {
        CGSize iconSize = CGSizeMake(64, 64);
        UIGraphicsBeginImageContextWithOptions(iconSize, NO, 0);
        
        [self drawSymbolInRect:(CGRect){CGPointZero, iconSize}];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
        
        return imageView;
    } else if (self.dialogStyle == UFDialogStyleCustomView) {
        return self.customView;
    }
    return nil;
}

- (void)layoutComponents {
    [self setNeedsDisplay];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    
    } else {
        self.frame = CGRectMake(self.frame.origin.x+50, self.frame.origin.y, self.frame.size.width+200, self.frame.size.height+100);
    }
    
    // Compute frames of components
    CGFloat layoutFrameInset = kUFDialogFrameInset + kUFDialogPadding;
	
    CGRect layoutFrame = CGRectInset(self.bounds, layoutFrameInset, layoutFrameInset);
    CGFloat layoutWidth = CGRectGetWidth(layoutFrame);
    layoutWidth = layoutWidth-20;
    
    // Title frame
    CGFloat titleHeight = 0;
    CGFloat minY = CGRectGetMinY(layoutFrame);
    if (self.title.length > 0) {
        titleHeight = [self.title sizeWithFont:self.titleFont
                             constrainedToSize:CGSizeMake(layoutWidth, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByWordWrapping].height;
        minY += kUFDialogPadding;
        
        // New Change Title Height //
		//            titleHeight+=layoutFrameInset;
        //////////////////////////
    }
    layout.titleRect = CGRectMake(CGRectGetMinX(layoutFrame), minY, layoutWidth, titleHeight);
    
    // Subtitle frame
    CGFloat subtitleHeight = 0;
    CGFloat minYY = CGRectGetMaxY(layout.titleRect);
    if (self.subtitle.length > 0) {
        subtitleHeight = [self.subtitle sizeWithFont:self.subtitleFont
                                   constrainedToSize:CGSizeMake(layoutWidth, MAXFLOAT)
                                       lineBreakMode:NSLineBreakByWordWrapping].height;
        minYY += 2*kUFDialogPadding;
    }
    if(subtitleHeight >30)
    {
        minYY = minYY-10;
    }
    else
    {
        minY = minY +5;
        minYY = minYY-5;
        subtitleHeight = 30;
    }
    layout.titleRect = CGRectMake(layoutFrame.origin.x+10, minY, layoutWidth, titleHeight);
    layout.subtitleRect = CGRectMake(layoutFrame.origin.x+10, minYY, layoutWidth, subtitleHeight);
    
    // otherMsgTitle frame
    CGFloat otherMsgTitleHeight = 0;
    minY = CGRectGetMaxY(layout.subtitleRect);
    if(self.otherMsgtitle.length > 0){
        otherMsgTitleHeight = [self.otherMsgtitle sizeWithFont:self.otherMsgtitleFont
                                             constrainedToSize:CGSizeMake(layoutWidth, MAXFLOAT)
                                                 lineBreakMode:NSLineBreakByWordWrapping].height;
        minY += kUFDialogPadding;
    }
    layout.otherMsgRect = CGRectMake(CGRectGetMinX(layoutFrame), minY+10, layoutWidth, otherMsgTitleHeight);
    
    // Accessory frame (note that views are in the content view coordinate system)
    self.accessoryView = [self makeAccessoryView];
    self.accessoryView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    
    CGFloat accessoryHeight = 0;
    CGFloat accessoryWidth = CGRectGetWidth(layoutFrame);
    CGFloat accessoryLeft = 0;
    
    minY = CGRectGetMaxY(layout.otherMsgRect) - layoutFrameInset;
    
    if (self.accessoryView != nil) {
        accessoryHeight = CGRectGetHeight(self.accessoryView.frame);
        accessoryWidth = CGRectGetWidth(self.accessoryView.frame);
        accessoryLeft = (CGRectGetWidth(layoutFrame) - accessoryWidth) / 2.0;
        minY += kUFDialogPadding;
    }
    layout.accessoryRect = CGRectMake(accessoryLeft, minY, accessoryWidth, accessoryHeight);
    
    // Text fields frame (note that views are in the content view coordinate system)
    CGFloat textFieldsHeight = 0;
    NSUInteger numTextFields = self.textFields.count;
    
    minY = CGRectGetMaxY(layout.accessoryRect);
    if (numTextFields > 0) {
        textFieldsHeight = kUFDialogTextFieldHeight * (CGFloat)numTextFields + kUFDialogPadding * ((CGFloat)numTextFields - 1.0);
        minY += kUFDialogPadding;
    }
    layout.textFieldsRect = CGRectMake(CGRectGetMinX(layoutFrame), minY, layoutWidth, textFieldsHeight);
    
    // Buttons frame (note that views are in the content view coordinate system)
    CGFloat buttonsHeight = 0;
    minY = CGRectGetMaxY(layout.textFieldsRect);
    if (self.buttons.count > 0) {
        buttonsHeight = kUFDialogButtonHeight;
        minY += kUFDialogPadding;
    }
    //layout.buttonRect = CGRectMake(CGRectGetMinX(layoutFrame), minY, layoutWidth, buttonsHeight);
	//CGRectInset(self.bounds, kUFDialogFrameInset, kUFDialogFrameInset);
	
    layout.buttonRect=CGRectInset(CGRectIntegral(self.bounds), kUFDialogFrameInset+kUFDialogPadding, kUFDialogFrameInset+kUFDialogPadding);
    layout.buttonRect.origin.y=minY;
    layout.buttonRect.size.height=buttonsHeight;
    
    // Adjust layout frame
    layoutFrame.size.height = CGRectGetMaxY(layout.buttonRect);
    
    // Create new content view
    UIView *newContentView = [[UIView alloc] initWithFrame:layoutFrame];
    // newContentView.backgroundColor=[UIColor whiteColor];
    newContentView.contentMode = UIViewContentModeRedraw;
    
    // Layout accessory view
    self.accessoryView.frame = layout.accessoryRect;
    
    [newContentView addSubview:self.accessoryView];
    
    // Layout text fields
    if (numTextFields > 0) {
        for (int i=0; i<numTextFields; i++) {
            CGFloat offsetY = (kUFDialogTextFieldHeight + kUFDialogPadding) * (CGFloat)i;
            CGRect fieldFrame = CGRectMake(0,
                                           CGRectGetMinY(layout.textFieldsRect) + offsetY,
                                           layoutWidth,
                                           kUFDialogTextFieldHeight-7);
            
            UITextField *field = (self.textFields)[i];
            field.frame = fieldFrame;
            field.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
            field.layer.shadowColor=[UIColor blackColor].CGColor;
            field.layer.shadowOffset=CGSizeMake(1, 2);
            field.layer.shadowRadius=2.0f;
            [newContentView addSubview:field];
        }
    }
    
    //Add Bottom Background image
    UIImageView *bg_Bottom = [[UIImageView alloc] init];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        bg_Bottom.frame = CGRectMake(0, 60, 240, 44);
    } else {
        bg_Bottom.frame = CGRectMake(0, 60, 433, 44);
    }
    if([_str_comming isEqualToString:@"0"])
    {
    bg_Bottom.image = [UIImage imageNamed:@"black-button.png"];
    }else
    {
    bg_Bottom.image = [UIImage imageNamed:@"b1.png"];
    }
    [newContentView addSubview:bg_Bottom];
    
    // Layout buttons
    NSUInteger count = self.buttons.count;
    if (count > 0) {
		//        CGFloat buttonWidth = (CGRectGetWidth(layout.buttonRect) - kUFDialogPadding * ((CGFloat)count - 1.0)) / (CGFloat)count;
        CGFloat buttonWidth = CGRectGetWidth(layout.buttonRect) / (CGFloat)count;
        
        for (int i=0; i<count; i++) {
			//            CGFloat left = (kUFDialogPadding + buttonWidth) * (CGFloat)i;
            CGFloat left = buttonWidth * (CGFloat)i;
            
            UIButton *button = (self.buttons)[i];
            CGRect buttonFrame = CGRectIntegral(CGRectMake(left, CGRectGetMinY(layout.buttonRect), buttonWidth, CGRectGetHeight(layout.buttonRect)));
            button.frame = buttonFrame;
            button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
            
			
            BOOL highlighted = (self.highlightedIndex == i);
            NSString *title = [button titleForState:UIControlStateNormal];
            
            // Set default image
            UIGraphicsBeginImageContextWithOptions(buttonFrame.size, NO, 0);
            
            [self drawButtonInRect:(CGRect){CGPointZero, buttonFrame.size} title:title highlighted:highlighted down:NO];
            UIGraphicsEndImageContext();
            
            // Set alternate image
            UIGraphicsBeginImageContextWithOptions(buttonFrame.size, NO, 0);
            
            [self drawButtonInRect:(CGRect){CGPointZero, buttonFrame.size} title:title highlighted:NO down:YES];
            UIGraphicsEndImageContext();
            [button setBackgroundColor:[UIColor clearColor]];
            button.layer.borderWidth = 0.0f;
            //newContentView.backgroundColor=[UIColor colorWithRed:1 green:0 blue:0 alpha:0.45f];
            [newContentView addSubview:button];
            
//            CAShapeLayer *shapLayer=[CAShapeLayer layer];
//            if(count==1)
//                shapLayer.path=[UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0f, 5.0f)].CGPath;
//            else if(count==2 && i==0)
//                shapLayer.path=[UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerBottomLeft) cornerRadii:CGSizeMake(5.0f, 5.0f)].CGPath;
//            else if(count==2 && i==1)
//                shapLayer.path=[UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:(UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0f, 5.0f)].CGPath;
//            
//            shapLayer.backgroundColor=[UIColor yellowColor].CGColor;
//            button.layer.mask=shapLayer;
            
			
        }
    }
    
    
    
    
    CGFloat animationDuration = kUFDialogAnimationDuration;
    if (self.contentView.superview != nil) {
        [UIView transitionFromView:self.contentView
                            toView:newContentView
                          duration:animationDuration
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        completion:^(BOOL finished) {
                            self.contentView = newContentView;
                        }];
    } else {
        self.contentView = newContentView;
        [self addSubview:newContentView];
        
        // Don't animate frame adjust if there was no content before
        animationDuration = 0;
    }
    
    // Adjust frame size
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        CGRect dialogFrame = CGRectInset(layoutFrame, -kUFDialogFrameInset - kUFDialogPadding, -kUFDialogFrameInset - kUFDialogPadding);
        dialogFrame.origin.x = (CGRectGetWidth(self.hostView.bounds) - CGRectGetWidth(dialogFrame)) / 2.0;
        dialogFrame.origin.y = (CGRectGetHeight(self.hostView.bounds) - CGRectGetHeight(dialogFrame)) / 2.0;
        
        self.frame = CGRectIntegral(dialogFrame);
    } completion:^(BOOL finished) {
        [self setNeedsDisplay];
    }];
}

- (void)resetLayout {
    self.title = nil;
    self.subtitle = nil;
    self.otherMsgtitle = nil;
    self.dialogStyle = UFDialogStyleDefault;
    self.progress = 0;
    self.customView = nil;
    
    [self removeAllControls];
}

- (void)removeAllControls {
    [self removeAllTextFields];
    [self removeAllButtons];
}

- (void)removeAllTextFields {
    [self.textFields removeAllObjects];
}

- (void)removeAllButtons {
    for (UIButton *btn in self.buttons) {
        [btn removeFromSuperview];
    }
    [self.buttons removeAllObjects];
    self.highlightedIndex = -1;
}
- (void)addTextFieldWithPlaceholder:(NSString *)placeholder secure:(BOOL)secure textStr:(NSString *)textStr{
    for (UITextField *field in self.textFields) {
        field.returnKeyType = UIReturnKeyNext;
    }
    
    UFDialogTextField *field = [[UFDialogTextField alloc] initWithFrame:CGRectMake(0, 0, 200, kUFDialogTextFieldHeight)];
    field.dialog = self;
    field.returnKeyType = UIReturnKeyDone;
    field.placeholder = placeholder;
    field.secureTextEntry = secure;
    field.text=textStr;
    [field setClearButtonMode:UITextFieldViewModeWhileEditing];
    field.font = [UIFont fontWithName:@"Lato-Regular" size:16.0f];
    field.font=TITLE_FONT;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.textColor = [UIColor blackColor];
    if([placeholder isEqualToString:@"Email"])
        field.keyboardType=UIKeyboardTypeEmailAddress;
    field.keyboardAppearance = UIKeyboardAppearanceAlert;
    field.autocapitalizationType = UITextAutocapitalizationTypeNone;
    field.delegate = (id)self;
    field.layer.shadowColor=[UIColor blackColor].CGColor;
    field.layer.shadowOffset=CGSizeMake(1, 2);
    field.layer.shadowRadius=2.0f;
    
    [self.textFields addObject:field];
}

- (void)addButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)sel {
    [self addButtonWithTitle:title target:target selector:sel highlighted:NO withNormatStateImage:nil withhighLightedStateImage:nil];
}

- (void)addButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)sel highlighted:(BOOL)flag withNormatStateImage:(UIImage *)normalImg withhighLightedStateImage:(UIImage *)highlightedImg{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:normalImg forState:UIControlStateNormal];
    [button setImage:highlightedImg forState:UIControlStateHighlighted];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self.buttons addObject:button];
}
- (void)addButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)sel highlighted:(BOOL)flag{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.layer.cornerRadius=3.0f;
    button.layer.masksToBounds=YES;
    
    [button setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@""]]];
    [button.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14.0f]];
    [button setTitleColor:[UIColor colorWithRed:(51.0f/255.0f) green:(51.0f/255.0f) blue:(51.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self action:@selector(touchDownWhite:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(touchOutWhite:) forControlEvents:UIControlEventTouchUpOutside];
    [self.buttons addObject:button];
}
- (void)addButtonWithTitle:(NSString *)title target:(id)target selector:(SEL)sel highlighted:(BOOL)flag buttonType:(AlertDialogButtonStyle) alertDialogButtonStyle{
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
   //NSLog(@"superview:-%@",[button superview]);
    //button.layer.cornerRadius=3.0f;
    button.layer.masksToBounds=YES;
    [button.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:18.0f]];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    //button.layer.shadowColor=[UIColor blackColor].CGColor;
    //button.layer.shadowOffset=CGSizeMake(0,0 );
    //button.layer.shadowRadius=1.0f;
    //button.layer.shadowOpacity=5.0f;
    //button.layer.cornerRadius=5.0f;
    button.layer.borderWidth=0.4f;
    if(alertDialogButtonStyle==AlertDialogButtonStyleWhite)
    {
        //button.layer.borderColor=[UIColor colorWithRed:153.0f/255.0 green:153.0f/255.0 blue:153.0f/255.0 alpha:1.0].CGColor;
        
       // button.backgroundColor=[UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        //[button setBackgroundImage:[UIImage imageNamed:@"b1.png"] forState:UIControlStateNormal];
		//        [button setTitleColor:[UIColor colorWithRed:(51.0f/255.0f) green:(51.0f/255.0f) blue:(51.0f/255.0f) alpha:1.0f] forState:UIControlStateNormal];
		//        [button setTitleColor:[UIColor colorWithRed:(51.0f/255.0f) green:(51.0f/255.0f) blue:(51.0f/255.0f) alpha:1.0f] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(touchDownWhite:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(touchOutWhite:) forControlEvents:UIControlEventTouchUpOutside];
       
    }
    else if(alertDialogButtonStyle==AlertDialogButtonStylePurple)
    {
        button.layer.borderColor=[UIColor colorWithRed:153.0f/255.0 green:153.0f/255.0 blue:153.0f/255.0 alpha:1.0].CGColor;
        button.backgroundColor=[UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
        
		//        CAShapeLayer *shapLayer=[CAShapeLayer layer];
		//        shapLayer.path=[UIBezierPath bezierPathWithRoundedRect:button.frame byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0f, 5.0f)].CGPath;
		//        shapLayer.backgroundColor=[UIColor yellowColor].CGColor;
		//        button.layer.mask=shapLayer;
        //[ button.layer insertSublayer:shapLayer above:button.layer];
		
        
        
         //[button setBackgroundImage:[UIImage imageNamed:@"black-button.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(touchDownPurple:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(touchOutPurple:) forControlEvents:UIControlEventTouchUpOutside];
    }
    else
    {
        [button setBackgroundColor:[UIColor yellowColor]];
    }
    [self.buttons addObject:button];
}
- (NSString *)textForTextFieldAtIndex:(NSUInteger)index {
    UITextField *field = (self.textFields)[index];
    return [field text];
}

- (void)showOrUpdateAnimatedInternal:(BOOL)flag {
    //UFDialogAssertMQ();
    
    UFDialogWindowOverlay *overlay = self.overlay;
    BOOL show = (overlay == nil);
    
    // Create overlay
    if (show) {
        self.overlay = overlay = [UFDialogWindowOverlay new];
        overlay.opaque = NO;
        overlay.windowLevel = UIWindowLevelStatusBar + 1;
        overlay.dialog = self;
        
        //For showing background overlay view according to screen size, By ashish
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat width = CGRectGetWidth(screen);
        CGFloat height = CGRectGetHeight(screen);
        CGRect frm=self.hostView.bounds;
        frm.size=CGSizeMake(width, height);
        overlay.frame =frm;
        overlay.alpha = 0.0;
        
        
        UITapGestureRecognizer *tapgr=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDetectOnBackground:)];
        tapgr.numberOfTapsRequired=1;
        tapgr.delegate=self;
        [self.overlay addGestureRecognizer:tapgr];
        
    }
    [self layoutComponents];
    
    if (show) {
        // Scale down ourselves for pop animation
        self.transform = CGAffineTransformMakeScale(kUFDialogPopScale, kUFDialogPopScale);
        
        // Animate
        NSTimeInterval animationDuration = (flag ? kUFDialogAnimationDuration : 0.0);
        [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            overlay.alpha = 1.0;
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            // stub
        }];
        
        [overlay addSubview:self];
        [overlay makeKeyAndVisible];
    }
}

- (void)showOrUpdateAnimated:(BOOL)flag {
    //UFDialogAssertMQ();
    SEL selector = @selector(showOrUpdateAnimatedInternal:);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:@(flag) afterDelay:self.batchDelay];
}
- (void)showOrUpdateAnimated:(BOOL)flag autoHide:(BOOL)autoHidden {
    //UFDialogAssertMQ();
    SEL selector = @selector(showOrUpdateAnimatedInternal:);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:@(flag) afterDelay:self.batchDelay];
    
    [self hideAnimated:YES afterDelay:TIME_INTERVAL_AUTO_HIDE];
}

- (void)hideAnimated:(BOOL)flag {
   // UFDialogAssertMQ();
    
    UFDialogWindowOverlay *overlay = self.overlay;
    
    // Nothing to hide if it is not key window
    if (overlay == nil) {
        return;
    }
    
    NSTimeInterval animationDuration = (flag ? kUFDialogAnimationDuration : 0.0);
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        overlay.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(kUFDialogPopScale, kUFDialogPopScale);
    } completion:^(BOOL finished) {
        overlay.hidden = YES;
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        self.overlay = nil;
        
    }];
}

- (void)hideAnimated:(BOOL)flag afterDelay:(NSTimeInterval)delay {
   // UFDialogAssertMQ();
    
    SEL selector = @selector(hideAnimated:);
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:selector object:nil];
    [self performSelector:selector withObject:@(flag) afterDelay:delay];
}
- (void)drawDialogBackgroundInRect:(CGRect)rect {
    CGRect boxRect = CGRectInset(CGRectIntegral(self.bounds), kUFDialogFrameInset+kUFDialogPadding, kUFDialogFrameInset+kUFDialogPadding);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set alpha
    CGContextSaveGState(context);
    CGContextSetAlpha(context, 1.0f);
    
    // Abstracted Graphic Attributes
    CGFloat cornerRadius = 5.0;
    UIColor *color=[UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIBezierPath *roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect:boxRect cornerRadius:cornerRadius];
    
    CGContextSaveGState(context);
    [roundedRectanglePath addClip];
    [roundedRectanglePath fill];
    
    // Set clip path
    [roundedRectanglePath addClip];
    CGContextRestoreGState(context);
}
- (void)drawButtonInRect:(CGRect)rect title:(NSString *)title highlighted:(BOOL)highlighted down:(BOOL)down {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGFloat radius = 4.0;
    CGFloat strokeWidth = 1.0;
    
    CGRect frame = CGRectIntegral(rect);
    CGRect buttonFrame = CGRectInset(frame, 0, 1);
    
    // Color declarations
    UIColor* whiteTop = [UIColor colorWithWhite:1.0 alpha:0.35];
    UIColor* whiteMiddle = [UIColor colorWithWhite:1.0 alpha:0.10];
    UIColor* whiteBottom = [UIColor colorWithWhite:1.0 alpha:0.0];
    
    // Gradient declarations
    NSArray* gradientColors = @[(id)whiteTop.CGColor,
                               (id)whiteMiddle.CGColor,
                               (id)whiteBottom.CGColor,
                               (id)whiteBottom.CGColor];
    CGFloat gradientLocations[] = {0, 0.5, 0.5, 1};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    CGColorSpaceRelease(colorSpace);
    
    // Bottom shadow
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithRoundedRect:buttonFrame cornerRadius:radius];
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:frame];
    [clipPath appendPath:fillPath];
    [clipPath setUsesEvenOddFillRule:YES];
    
    CGContextSaveGState(ctx);
    
    [clipPath addClip];
    [[UIColor blackColor] setFill];
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0, [UIColor colorWithWhite:1.0 alpha:0.25].CGColor);
    
    [fillPath fill];
    
    CGContextRestoreGState(ctx);
    
    // Top shadow
    CGContextSaveGState(ctx);
    
    [fillPath addClip];
    [[UIColor blackColor] setFill];
    
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 2), 0, [UIColor colorWithWhite:1.0 alpha:0.25].CGColor);
    
    [clipPath fill];
    
    CGContextRestoreGState(ctx);
    
    // Button gradient
    CGContextSaveGState(ctx);
    [fillPath addClip];
    
    CGContextDrawLinearGradient(ctx,
                                gradient,
                                CGPointMake(CGRectGetMidX(buttonFrame), CGRectGetMinY(buttonFrame)),
                                CGPointMake(CGRectGetMidX(buttonFrame), CGRectGetMaxY(buttonFrame)), 0);
    CGContextRestoreGState(ctx);
    
    // Draw highlight or down state
    if (highlighted) {
        CGContextSaveGState(ctx);
        
        [[UIColor colorWithWhite:1.0 alpha:0.25] setFill];
        [fillPath fill];
        
        CGContextRestoreGState(ctx);
    } else if (down) {
        CGContextSaveGState(ctx);
        
        [[UIColor colorWithWhite:0.0 alpha:0.25] setFill];
        [fillPath fill];
        
        CGContextRestoreGState(ctx);
    }
    
    // Button stroke
    UIBezierPath *strokePath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(buttonFrame, strokeWidth / 2.0, strokeWidth / 2.0)
                                                          cornerRadius:radius - strokeWidth / 2.0];
    
    [[UIColor colorWithWhite:0.0 alpha:0.8] setStroke];
    [strokePath stroke];
    
    // Draw title
    CGFloat fontSize = 18.0;
    CGRect textFrame = CGRectIntegral(CGRectMake(0, (CGRectGetHeight(rect) - fontSize) / 2.0 - 1.0, CGRectGetWidth(rect), fontSize));
    
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0.0, -1.0), 0.0, [UIColor blackColor].CGColor);
    
    [[UIColor whiteColor] set];
    [title drawInRect:textFrame withFont:self.titleFont lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    
    CGContextRestoreGState(ctx);
    
    // Restore
    CGContextRestoreGState(ctx);
}

- (void)drawTitleInRect:(CGRect)rect isSubtitle:(BOOL)isSubtitle isOtherMsgTitle:(BOOL) isOtherMsgTitle{
    if(self.otherMsgtitle && isOtherMsgTitle){
        NSString *otherMsgTitle = self.otherMsgtitle;
        if (otherMsgTitle.length > 0) {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            
            //CGContextSetShadowWithColor(ctx, CGSizeMake(0.0, -1.0), 0.0, TITLE_COLOR.CGColor);
            UIFont *font = self.otherMsgtitleFont;
            
            [[UIColor whiteColor] set];
            
            [otherMsgTitle drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
            
            CGContextRestoreGState(ctx);
        }
    }
    else{
        NSString *title = (isSubtitle ? self.subtitle : self.title);
        if (title.length > 0) {
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextSaveGState(ctx);
            UIFont *font = (isSubtitle ? self.subtitleFont : self.titleFont);
            
            if(isSubtitle)
                [SUBTITLE_COLOR set];
            else
                [TITLE_COLOR set];
            
            
            [title drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
            
            CGContextRestoreGState(ctx);
        }
    }
}

- (void)drawSymbolInRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    // General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Color Declarations
    UIColor *grey = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
    UIColor *black50 = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    // Gradient Declarations
    NSArray *gradientColors = @[(id)[UIColor whiteColor].CGColor,
                               (id)grey.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    // Shadow Declarations
    CGColorRef shadow = black50.CGColor;
    CGSize shadowOffset = CGSizeMake(0, 3);
    CGFloat shadowBlurRadius = 3;
    
    // Bezier Drawing
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    if (self.dialogStyle == UFDialogStyleSuccess) {
        [bezierPath moveToPoint:CGPointMake(16, 23)];
        [bezierPath addLineToPoint:CGPointMake(27, 34)];
        [bezierPath addLineToPoint:CGPointMake(56, 5)];
        [bezierPath addLineToPoint:CGPointMake(63, 12)];
        [bezierPath addLineToPoint:CGPointMake(27, 48)];
        [bezierPath addLineToPoint:CGPointMake(9, 30)];
        [bezierPath addLineToPoint:CGPointMake(16, 23)];
    } else {
        [bezierPath moveToPoint: CGPointMake(11, 17)];
        [bezierPath addLineToPoint: CGPointMake(19, 9)];
        [bezierPath addLineToPoint: CGPointMake(33, 23)];
        [bezierPath addLineToPoint: CGPointMake(47, 9)];
        [bezierPath addLineToPoint: CGPointMake(55, 17)];
        [bezierPath addLineToPoint: CGPointMake(41, 31)];
        [bezierPath addLineToPoint: CGPointMake(55, 45)];
        [bezierPath addLineToPoint: CGPointMake(47, 53)];
        [bezierPath addLineToPoint: CGPointMake(33, 39)];
        [bezierPath addLineToPoint: CGPointMake(19, 53)];
        [bezierPath addLineToPoint: CGPointMake(11, 45)];
        [bezierPath addLineToPoint: CGPointMake(25, 31)];
        [bezierPath addLineToPoint: CGPointMake(11, 17)];
    }
    
    [bezierPath closePath];
    
    // Determine scale (the default side is 64)
    CGPoint offset = CGPointMake((CGRectGetWidth(rect) - 64.0) / 2.0, (CGRectGetHeight(rect) - 64.0) / 2.0);
    
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(offset.x, offset.y)];
    
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow);
    CGContextSetFillColorWithColor(context, shadow);
    
    [bezierPath fill];
    [bezierPath addClip];
    
    CGRect bounds = bezierPath.bounds;
    
    CGContextDrawLinearGradient(context,
                                gradient,
                                CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds)),
                                CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds)),
                                0);
    CGContextRestoreGState(context);
    
    // Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(ctx);
}

- (void)drawTextFieldInRect:(CGRect)rect {
    // General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Shadow Declarations
    CGColorRef innerShadow = [UIColor clearColor].CGColor;//grey40.CGColor;
    CGSize innerShadowOffset = CGSizeMake(0, 2);
    CGFloat innerShadowBlurRadius = 2;
    CGColorRef outerShadow = [UIColor blackColor].CGColor;//white10.CGColor;
    CGSize outerShadowOffset = CGSizeMake(0, 0);
    CGFloat outerShadowBlurRadius = 3;
    
    // Rectangle Drawing
    UIBezierPath *rectanglePath = [UIBezierPath bezierPathWithRect: CGRectIntegral(rect)];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, outerShadowOffset, outerShadowBlurRadius, outerShadow);
    [[UIColor whiteColor] setFill];
    [rectanglePath fill];
    
    // Rectangle Inner Shadow
    CGRect rectangleBorderRect = CGRectInset([rectanglePath bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
    rectangleBorderRect = CGRectOffset(rectangleBorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
    rectangleBorderRect = CGRectInset(CGRectUnion(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
    
    UIBezierPath* rectangleNegativePath = [UIBezierPath bezierPathWithRect: rectangleBorderRect];
    [rectangleNegativePath appendPath: rectanglePath];
    rectangleNegativePath.usesEvenOddFillRule = YES;
    
    CGContextSaveGState(context);
    {
        CGFloat xOffset = innerShadowOffset.width + round(rectangleBorderRect.size.width);
        CGFloat yOffset = innerShadowOffset.height;
        CGContextSetShadowWithColor(context,
                                    CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                    innerShadowBlurRadius,
                                    innerShadow);
        
        [rectanglePath addClip];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleBorderRect.size.width), 0);
        [rectangleNegativePath applyTransform: transform];
        [[UIColor grayColor] setFill];
        [rectangleNegativePath fill];
    }
    
    CGContextRestoreGState(context);
    CGContextRestoreGState(context);
    
    [[UIColor lightGrayColor] setStroke];
    rectanglePath.lineWidth = 1;
    [rectanglePath stroke];
    
    CGContextRestoreGState(context);
}

- (void)drawDimmedBackgroundInRect:(CGRect)rect {
    // General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Color Declarations
    UIColor *greyInner = [UIColor colorWithWhite:0.0 alpha:0.75f];
    //    UIColor *greyOuter = [UIColor colorWithWhite:0.0 alpha:0.2];
    
    // Gradient Declarations
    NSArray* gradientColors = @[(id)greyInner.CGColor];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    // Rectangle Drawing
    CGPoint mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect:rect];
    CGContextSaveGState(context);
    [rectanglePath addClip];
    CGContextDrawRadialGradient(context,
                                gradient,
                                mid, 10,
                                mid, CGRectGetMidY(rect),
                                kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    
    CGContextRestoreGState(context);
    
    // Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

//- (void)drawDimmedBackgroundInRect:(CGRect)rect {
//    // General Declarations
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    // Set alpha
//    CGContextSaveGState(context);
//    CGContextSetAlpha(context, 1.0f);
//
//	UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRect:rect];
//
//    CGContextSaveGState(context);
//
//    if([UIScreen mainScreen].scale == 2.0)
//        [[UIColor colorWithPatternImage:[UIImage imageNamed:@"black-transparent-box.png"]] setFill];
//    else
//        [[UIColor colorWithPatternImage:[UIImage imageNamed:@"black-transparent-box.png"]] setFill];
//
//    [roundedRectanglePath fill];
//
//    // Set clip path
//    [roundedRectanglePath addClip];
//    CGContextRestoreGState(context);
//    CGColorSpaceRelease(colorSpace);
//}
- (void)drawRect:(CGRect)rect {
    
    
    [self drawDialogBackgroundInRect:rect];
    [self drawTitleInRect:layout.titleRect isSubtitle:NO isOtherMsgTitle:false];
    [self drawTitleInRect:layout.subtitleRect isSubtitle:YES isOtherMsgTitle:false];
    
    // add other msg title
    if(self.otherMsgtitle.length > 0){
        [self drawTitleInRect:layout.otherMsgRect isSubtitle:YES isOtherMsgTitle:true];
    }
    
    int count=[self.textFields count];
    if(count>0 && [self.title isEqualToString:@"Forgot Password"])
    {
        UITextField *field=(self.textFields)[0];
        [field becomeFirstResponder];
    }
    
}
#pragma mark -

-(IBAction)touchDownWhite:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [btn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btnBg_pattern_white_hover1.png"]]];
    
}
-(IBAction)touchOutWhite:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [btn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btnBg_pattern_white_normal1.png"]]];
    
}
-(IBAction)touchDownPurple:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [btn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btnBg_pattern_purple_hover1.png"]]];
    
}
-(IBAction)touchOutPurple:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    [btn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btnBg_pattern_purple_normal1.png"]]];
    
}
#pragma mark - UIGestureRecognizer methods
-(void)touchDetectOnBackground:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state==UIGestureRecognizerStateEnded)
    {
        [self hideAnimated:YES];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    // Cylce through text fields
    NSUInteger index = [self.textFields indexOfObject:textField];
    NSUInteger count = self.textFields.count;
    
    if (index < (count - 1)) {
        UITextField *nextField = (self.textFields)[index + 1];
        [nextField becomeFirstResponder];
    } else {
		// [textField resignFirstResponder];
    }
    
    
    int c1=[self.textFields count];
    if(c1>0 && [self.title isEqualToString:@"Forgot Password"])
    {
        UITextField *field=(self.textFields)[0];
        if([_delegate respondsToSelector:@selector(alertDialogTextFieldShouldReturn:)])
            [_delegate performSelector:@selector(alertDialogTextFieldShouldReturn:) withObject:field];
    }
    
    return YES;
}

@end

@implementation UFDialogTextField
UFDialogSynth(dialog)

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 4.0, 4.0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

- (void)drawRect:(CGRect)rect {
    [self.dialog drawTextFieldInRect:rect];
}

@end

@implementation UFDialogWindowOverlay
UFDialogSynth(dialog)

- (void)drawRect:(CGRect)rect {
    [self.dialog drawDimmedBackgroundInRect:rect];
}

@end
