//
// MBProgressHUD.m
// Version 0.5
// Created by Matej Bukovinski on 2.4.09.
//

#import "AlertDialogProgressView.h"


#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp) exp
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#endif

//#define DEGREES_TO_RADIANS(x) (3.14159265358979323846 * x / 180.0)
// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) ((angle / 180.0) * M_PI)


static const CGFloat kPadding = 4.f;
static const CGFloat kLabelFontSize = 16.f;
static const CGFloat kDetailsLabelFontSize = 12.f;


@interface AlertDialogProgressView ()

- (void)setupLabels;
- (void)registerForKVO;
- (void)unregisterFromKVO;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *observableKeypaths;
- (void)registerForNotifications;
- (void)unregisterFromNotifications;
- (void)updateUIForKeypath:(NSString *)keyPath;
- (void)hideUsingAnimation:(BOOL)animated;
- (void)showUsingAnimation:(BOOL)animated;
- (void)done;
- (void)updateIndicators;
- (void)handleGraceTimer:(NSTimer *)theTimer;
- (void)handleMinShowTimer:(NSTimer *)theTimer;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (void)cleanUp;
- (void)launchExecution;
- (void)deviceOrientationDidChange:(NSNotification *)notification;
- (void)hideDelayed:(NSNumber *)animated;

- (void)startLoadingAnimation;
-(void) startLoadingTimer;
-(void) stopLoadingTimer;

@property (atomic, AD_STRONG) UIView *indicator;
@property (atomic, AD_STRONG) NSTimer *graceTimer;
@property (atomic, AD_STRONG) NSTimer *minShowTimer;
@property (atomic, AD_STRONG) NSDate *showStarted;
@property (atomic, assign) CGSize size;

@property (nonatomic, retain) UIImageView *indicatorImageView;
@property (nonatomic, retain) UIImageView *indicatorRotationImageView;

@end


@implementation AlertDialogProgressView {
	BOOL useAnimation;
	SEL methodForExecution;
	id targetForExecution;
	id objectForExecution;
	UILabel *label;
	UILabel *detailsLabel;
	BOOL isFinished;
	CGAffineTransform rotationTransform;
    bool _isAnimationStart;
    CGFloat _rotationAngle;
    NSTimer *_niddleTimer;
    CGRect _indicator;
    bool _isLoaderPositionSet;
}

#pragma mark - Properties

@synthesize animationType;
@synthesize delegate;
@synthesize opacity;
@synthesize color;
@synthesize labelFont;
@synthesize detailsLabelFont;
@synthesize indicator;
@synthesize xOffset;
@synthesize yOffset;
@synthesize minSize;
@synthesize square;
@synthesize margin;
@synthesize dimBackground;
@synthesize graceTime;
@synthesize minShowTime;
@synthesize graceTimer;
@synthesize minShowTimer;
@synthesize taskInProgress;
@synthesize removeFromSuperViewOnHide;
@synthesize customView;
@synthesize showStarted;
@synthesize mode;
@synthesize labelText;
@synthesize detailsLabelText;
@synthesize progress;
@synthesize size;
@synthesize indicatorImageName;
@synthesize indicatorAnimatedImage;
@synthesize indicatorImageView;
@synthesize indicatorRotationImageView;

#if NS_BLOCKS_AVAILABLE
@synthesize completionBlock;
#endif

#pragma mark - Class methods

+ (AlertDialogProgressView *)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
	AlertDialogProgressView *hud = [[AlertDialogProgressView alloc] initWithView:view];
	[view addSubview:hud];
	[hud show:animated];
	return MB_AUTORELEASE(hud);
}

+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
	AlertDialogProgressView *hud = [AlertDialogProgressView HUDForView:view];
	if (hud != nil) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
		return YES;
	}
	return NO;
}

+ (NSUInteger)hideAllHUDsForView:(UIView *)view animated:(BOOL)animated {
	NSArray *huds = [self allHUDsForView:view];
	for (AlertDialogProgressView *hud in huds) {
		hud.removeFromSuperViewOnHide = YES;
		[hud hide:animated];
	}
	return [huds count];
}

+ (AlertDialogProgressView *)HUDForView:(UIView *)view {
	AlertDialogProgressView *hud = nil;
	NSArray *subviews = view.subviews;
	Class hudClass = [AlertDialogProgressView class];
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:hudClass]) {
			hud = (AlertDialogProgressView *)aView;
		}
	}
	return hud;
}

+ (NSArray *)allHUDsForView:(UIView *)view {
	NSMutableArray *huds = [NSMutableArray array];
	NSArray *subviews = view.subviews;
	Class hudClass = [AlertDialogProgressView class];
	for (UIView *aView in subviews) {
		if ([aView isKindOfClass:hudClass]) {
			[huds addObject:aView];
		}
	}
	return [NSArray arrayWithArray:huds];
}

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    
	if (self) {
		// Set default values for properties
		self.animationType = ADProgressHUDAnimationFade;
		self.mode = ADProgressHUDModeIndeterminate;
		self.labelText = nil;
		self.detailsLabelText = nil;
		self.opacity = 0.8f;
        self.color = nil;
		self.labelFont = [UIFont systemFontOfSize:kLabelFontSize];
		self.detailsLabelFont = [UIFont systemFontOfSize:kDetailsLabelFontSize];
		self.xOffset = 0.0f;
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        if (screenBounds.size.height == 568) {
		self.yOffset = 0.0f;
        }else
        {
        self.yOffset = -25.0f;
        }
		self.dimBackground = YES;
		self.margin = 20.0f;
		self.graceTime = 0.0f;
		self.minShowTime = 0.0f;
		self.removeFromSuperViewOnHide = NO;
		self.minSize = CGSizeZero;
		self.square = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
		// Transparent background
		self.opaque = NO;
		self.backgroundColor = [UIColor clearColor];
		// Make it invisible for now
		self.alpha = 0.0f;
		
		taskInProgress = NO;
		rotationTransform = CGAffineTransformIdentity;
		
		[self setupLabels];
		[self updateIndicators];
        //[self loadingImageAnimation];
		[self registerForKVO];
		[self registerForNotifications];
        
        _isAnimationStart = true;
        //[self startLoadingAnimation];
	}
	return self;
}

- (instancetype)initWithView:(UIView *)view {
	NSAssert(view, @"View must not be nil.");
	id me = [self initWithFrame:view.bounds];
	// We need to take care of rotation ourselfs if we're adding the HUD to a window
	if ([view isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:NO];
	}
    
    _isLoaderPositionSet = false;
	return me;
}

- (instancetype)initWithWindow:(UIWindow *)window {
	return [self initWithView:window];
}

- (void)dealloc {
	[self unregisterFromNotifications];
	[self unregisterFromKVO];
#if !__has_feature(objc_arc)
	[color release];
	[indicator release];
	[label release];
	[detailsLabel release];
	[labelText release];
	[detailsLabelText release];
	[graceTimer release];
	[minShowTimer release];
	[showStarted release];
	[customView release];
#if NS_BLOCKS_AVAILABLE
	[completionBlock release];
#endif
	[super dealloc];
#endif
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //removeAlertDialogProgressView
    if(self.delegate && [(id)self.delegate respondsToSelector:@selector(removeAlertDialogProgressView)]){
        [self.delegate removeAlertDialogProgressView];
    }
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated {
	useAnimation = animated;
	// If the grace time is set postpone the HUD display
	if (self.graceTime > 0.0) {
		self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime target:self
                                                         selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
	}
	// ... otherwise show the HUD imediately
	else {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)hide:(BOOL)animated {
	useAnimation = animated;
    
    // [self stopLoadingTimer];//Stop niddle image animation..
    [self stopBubbleProgress];
    
	// If the minShow time is set, calculate how long the hud was shown,
	// and pospone the hiding operation if necessary
	if (self.minShowTime > 0.0 && showStarted) {
		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
		if (interv < self.minShowTime) {
			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self
                                                               selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
			return;
		}
	}
	// ... otherwise hide the HUD immediately
	[self hideUsingAnimation:useAnimation];
}

- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay {
	[self performSelector:@selector(hideDelayed:) withObject:@(animated) afterDelay:delay];
}

- (void)hideDelayed:(NSNumber *)animated {
	[self hide:[animated boolValue]];
}
#pragma mark - **** PROGRESS-1 *****
#pragma mark Custom Progress methods like watch niddles...
- (void)loadingImageAnimation{
    _rotationAngle = 0.0;
    if(self.indicatorImageView == nil && self.indicatorImageName){
        self.indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.indicatorImageName]];
        [self addSubview:self.indicatorImageView];
    }
    
    if(self.indicatorRotationImageView == nil && self.indicatorAnimatedImage){
        self.indicatorRotationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.indicatorAnimatedImage]];
        [self addSubview:self.indicatorRotationImageView];
    }
    
    //[self startLoadingAnimation];
    // start timer
    [self startLoadingTimer];
}
-(void) startLoadingTimer{
    _niddleTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(startLoadingAnimation) userInfo:nil repeats:YES];
}
-(void) stopLoadingTimer{
    if(_niddleTimer){
        [_niddleTimer invalidate];
        _niddleTimer = nil;
    }
}
- (void)resetAnimatorImageView{
    
    // Reset animation frames
    CGRect imageRect = CGRectZero;
    
    if(!_isLoaderPositionSet){
        _isLoaderPositionSet = true;
        if(self.indicatorImageView){
            //imageRect.origin = indicator.frame.origin;
            imageRect.origin = _indicator.origin;
            imageRect.size = self.indicatorImageView.frame.size;
            imageRect = _indicator;
            
            self.indicatorImageView.frame = imageRect;
        }
        if(self.indicatorRotationImageView){
            //imageRect.origin = indicator.frame.origin;
            //imageRect.origin = _indicator.origin;
            imageRect.origin.x += 2.5;
            imageRect.origin.y += 2.5;
            imageRect.size = self.indicatorRotationImageView.frame.size;
            //imageRect = _indicator;
            self.indicatorRotationImageView.frame = imageRect;
        }
    }
    
    
    
    if(self.indicatorImageView == nil){
        self.indicatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"step-1.png"]];
        
        [self.indicatorImageView setAnimationDuration:1.8f];
        [self.indicatorImageView setAnimationRepeatCount:NSIntegerMax];
        [self.indicatorImageView setAnimationImages:@[[UIImage imageNamed:@"step-1.png"],
                                                     [UIImage imageNamed:@"step-2.png"],
                                                     [UIImage imageNamed:@"step-3.png"],
                                                     [UIImage imageNamed:@"step-4.png"]]];
        [self addSubview:self.indicatorImageView];
        
        CGRect frm=self.indicator.frame;
        float x=frm.origin.x+(frm.size.width/2);
        float y=frm.origin.y;
        x-=(self.indicatorImageView.frame.size.width/2);
        frm.origin.x=x;
        frm.origin.y=y;
        frm.size=self.indicatorImageView.frame.size;
        self.indicatorImageView.frame=frm;
        
        
        
    }
    
    [self startBubbleProgress];
    
}

- (void)startLoadingAnimation{
    
    if(_isAnimationStart){
        if(_rotationAngle >= 360.0){
            _rotationAngle = 0.0;
        }
        //_rotationAngle++;
        _rotationAngle += 0.1;
        
        /* [UIView beginAnimations:@"LoaderAnimation" context:NULL];
         [UIView setAnimationDuration:0.1];
         [UIView setAnimationDelegate:self];
         [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
         */
        if(self.indicatorRotationImageView){
            //CGAffineTransform transform = CGAffineTransformRotate(self.indicatorRotationImageView.transform, DEGREES_TO_RADIANS(rotationAngle));
            //self.indicatorRotationImageView.transform = transform;
            CGAffineTransform transform = CGAffineTransformMakeRotation(_rotationAngle);
            self.indicatorRotationImageView.transform = transform;
        }
        
        //[UIView commitAnimations];
    }
}
#pragma mark - **** PROGRESS-2 *****
#pragma mark Custom Progress methods like bubble motion...
-(void)startBubbleProgress
{
    
    [self.indicatorImageView startAnimating];
}
-(void)stopBubbleProgress
{
    [self.indicatorImageView stopAnimating];
}
#pragma mark - Timer callbacks

- (void)handleGraceTimer:(NSTimer *)theTimer {
	// Show the HUD only if the task is still running
	if (taskInProgress) {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
	[self hideUsingAnimation:useAnimation];
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
	
    self.alpha = 0.0f;
	if (animated && animationType == ADProgressHUDAnimationZoomIn) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
	} else if (animated && animationType == ADProgressHUDAnimationZoomOut) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
	}
	self.showStarted = [NSDate date];
	// Fade in
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		self.alpha = 1.0f;
		if (animationType == ADProgressHUDAnimationZoomIn || animationType == ADProgressHUDAnimationZoomOut) {
			self.transform = rotationTransform;
		}
		[UIView commitAnimations];
	}
	else {
		self.alpha = 1.0f;
	}
}

- (void)hideUsingAnimation:(BOOL)animated {
	// Fade out
	if (animated && showStarted) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
		// 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
		// in the done method
		if (animationType == ADProgressHUDAnimationZoomIn) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
		} else if (animationType == ADProgressHUDAnimationZoomOut) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
		}
        
		self.alpha = 0.02f;
		[UIView commitAnimations];
	}
	else {
		self.alpha = 0.0f;
		[self done];
	}
	self.showStarted = nil;
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
    
    /*if([animationID isEqualToString:@"LoaderAnimation"]){
     [self startLoadingAnimation];
     
     }
     else{*/
    [self done];
    //}
}

- (void)done {
	isFinished = YES;
	self.alpha = 0.0f;
	if ([delegate respondsToSelector:@selector(hudWasHidden:)]) {
		[delegate performSelector:@selector(hudWasHidden:) withObject:self];
	}
#if NS_BLOCKS_AVAILABLE
	if (self.completionBlock) {
		self.completionBlock();
		self.completionBlock = NULL;
	}
#endif
	if (removeFromSuperViewOnHide) {
		[self removeFromSuperview];
	}
}

#pragma mark - Threading

- (void)showWhileExecuting:(SEL)method onTarget:(id)target withObject:(id)object animated:(BOOL)animated {
	methodForExecution = method;
	targetForExecution = MB_RETAIN(target);
	objectForExecution = MB_RETAIN(object);
	// Launch execution in new thread
	self.taskInProgress = YES;
	[NSThread detachNewThreadSelector:@selector(launchExecution) toTarget:self withObject:nil];
	// Show HUD view
	[self show:animated];
}

#if NS_BLOCKS_AVAILABLE

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block completionBlock:(void (^)())completion {
	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue completionBlock:completion];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue {
	[self showAnimated:animated whileExecutingBlock:block onQueue:queue	completionBlock:NULL];
}

- (void)showAnimated:(BOOL)animated whileExecutingBlock:(dispatch_block_t)block onQueue:(dispatch_queue_t)queue
	 completionBlock:(ADProgressHUDCompletionBlock)completion {
	self.taskInProgress = YES;
	self.completionBlock = completion;
	dispatch_async(queue, ^(void) {
        block();
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [self cleanUp];
        });
    });
    [self show:animated];
}

#endif

- (void)launchExecution {
	@autoreleasepool {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		// Start executing the requested task
		[targetForExecution performSelector:methodForExecution withObject:objectForExecution];
#pragma clang diagnostic pop
		// Task completed, update view in main thread (note: view operations should
		// be done only in the main thread)
		[self performSelectorOnMainThread:@selector(cleanUp) withObject:nil waitUntilDone:NO];
	}
}

- (void)cleanUp {
	taskInProgress = NO;
	self.indicator = nil;
#if !__has_feature(objc_arc)
	[targetForExecution release];
	[objectForExecution release];
#endif
	[self hide:useAnimation];
}

#pragma mark - UI

- (void)setupLabels {
    
	label = [[UILabel alloc] initWithFrame:self.bounds];
	label.adjustsFontSizeToFitWidth = NO;
	label.textAlignment = NSTextAlignmentCenter;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor blackColor];
	label.font = self.labelFont;
	label.text = self.labelText;
	[self addSubview:label];
    
	detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.adjustsFontSizeToFitWidth = NO;
	detailsLabel.textAlignment = NSTextAlignmentCenter;
	detailsLabel.opaque = NO;
	detailsLabel.backgroundColor = [UIColor clearColor];
	detailsLabel.textColor = [UIColor whiteColor];
	detailsLabel.numberOfLines = 0;
	detailsLabel.font = self.detailsLabelFont;
	detailsLabel.text = self.detailsLabelText;
	[self addSubview:detailsLabel];
}

- (void)updateIndicators {
	
	BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
	BOOL isRoundIndicator = [indicator isKindOfClass:[AlertDialogRoundProgressView class]];
	
	if (mode == ADProgressHUDModeIndeterminate &&  !isActivityIndicator) {
		// Update to indeterminate indicator
		[indicator removeFromSuperview];
		//self.indicator = AD_AUTORELEASE([[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]);
        
        self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
		//[(UIActivityIndicatorView *)indicator startAnimating];
        self.indicator.alpha = 0.0;
		[self addSubview:indicator];
	}
	else if (mode == ADProgressHUDModeDeterminate || mode == ADProgressHUDModeAnnularDeterminate) {
		if (!isRoundIndicator) {
			// Update to determinante indicator
			[indicator removeFromSuperview];
			//self.indicator = AD_AUTORELEASE([[AlertDialogRoundProgressView alloc] init]);
            self.indicator = [[AlertDialogRoundProgressView alloc] init];
			[self addSubview:indicator];
		}
		if (mode == ADProgressHUDModeAnnularDeterminate) {
			[(AlertDialogRoundProgressView *)indicator setAnnular:YES];
		}
	}
	else if (mode == ADProgressHUDModeCustomView && customView != indicator) {
		// Update custom view indicator
		[indicator removeFromSuperview];
		self.indicator = customView;
		[self addSubview:indicator];
	} else if (mode == ADProgressHUDModeText) {
		[indicator removeFromSuperview];
		self.indicator = nil;
	}
}

#pragma mark - Layout

- (void)layoutSubviews {
	
    //[self loadingImageAnimation];
	// Entirely cover the parent view
	UIView *parent = self.superview;
	if (parent) {
		self.frame = parent.bounds;
	}
	CGRect bounds = self.bounds;
	
	// Determine the total widt and height needed
	//CGFloat maxWidth = bounds.size.width - 4 * margin;
    CGFloat maxWidth = bounds.size.width - margin;
	CGSize totalSize = CGSizeZero;
	
	CGRect indicatorF = indicator.bounds;
	indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
	totalSize.width = MAX(totalSize.width, indicatorF.size.width);
	totalSize.height += indicatorF.size.height;
	
	CGSize labelSize = [label.text sizeWithFont:label.font];
	labelSize.width = MIN(labelSize.width, maxWidth);
	totalSize.width = MAX(totalSize.width, labelSize.width);
	totalSize.height += labelSize.height;
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		totalSize.height += kPadding;
	}
    
	//CGFloat remainingHeight = bounds.size.height - totalSize.height - kPadding - 4 * margin;
    CGFloat remainingHeight = bounds.size.height - totalSize.height - kPadding - 2 * margin;
	CGSize maxSize = CGSizeMake(maxWidth, remainingHeight);
	CGSize detailsLabelSize = [detailsLabel.text sizeWithFont:detailsLabel.font
                                            constrainedToSize:maxSize lineBreakMode:detailsLabel.lineBreakMode];
	totalSize.width = MAX(totalSize.width, detailsLabelSize.width);
	totalSize.height += detailsLabelSize.height;
	if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
		totalSize.height += kPadding;
	}
	
	totalSize.width += 2 * margin;
    //totalSize.width = 290;
	totalSize.height += 2 * margin;
    //totalSize.height = 165;
	
	// Position elements
	CGFloat yPos = roundf(((bounds.size.height - totalSize.height) / 2)) + margin + yOffset;
   // CGFloat yPos = roundf(((bounds.size.height - totalSize.height) / 2)) + 50 + yOffset;
	CGFloat xPos = xOffset;
	indicatorF.origin.y = yPos;
	indicatorF.origin.x = roundf((bounds.size.width - indicatorF.size.width) / 2) + xPos;
	indicator.frame = indicatorF;
	yPos += indicatorF.size.height;
	
	if (labelSize.height > 0.f && indicatorF.size.height > 0.f) {
		yPos += kPadding;
	}
	CGRect labelF;
	labelF.origin.y = yPos;
	labelF.origin.x = roundf((bounds.size.width - labelSize.width) / 2) + xPos;
	labelF.size = labelSize;
	label.frame = labelF;
	yPos += labelF.size.height;
	
	if (detailsLabelSize.height > 0.f && (indicatorF.size.height > 0.f || labelSize.height > 0.f)) {
		yPos += kPadding;
	}
	CGRect detailsLabelF;
	detailsLabelF.origin.y = yPos;
	detailsLabelF.origin.x = roundf((bounds.size.width - detailsLabelSize.width) / 2) + xPos;
	detailsLabelF.size = detailsLabelSize;
	detailsLabel.frame = detailsLabelF;
	
	// Enforce minsize and quare rules
	if (square) {
		CGFloat max = MAX(totalSize.width, totalSize.height);
		if (max <= bounds.size.width - 2 * margin) {
			totalSize.width = max;
		}
		if (max <= bounds.size.height - 2 * margin) {
			totalSize.height = max;
		}
	}
	if (totalSize.width < minSize.width) {
		totalSize.width = minSize.width;
	}
	if (totalSize.height < minSize.height) {
		totalSize.height = minSize.height;
	}
    
    _indicator = indicatorF;
	
	self.size = totalSize;
    
    [self resetAnimatorImageView];
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    
	if (self.dimBackground) {
		//Gradient colours
		size_t gradLocationsNum = 2;
		CGFloat gradLocations[2] = {0.0f, 1.0f};
		CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
		CGColorSpaceRelease(colorSpace);
		//Gradient center
		CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		//Gradient radius
		float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
		//Gradient draw
		CGContextDrawRadialGradient (context, gradient, gradCenter,
									 0, gradCenter, gradRadius,
									 kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}
    
    // Set background rect color
    if (self.color) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
    } else {
        CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    }
    ///////////Add changes by Shelesh..////////
	size.width=260;
    size.height=133;
	float radius = 4.0f;
    self.color=[UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
    CGContextSetFillColorWithColor(context, self.color.CGColor);
    //CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 4.0f, [UIColor blackColor].CGColor);
    
    ///////////////////////////////////////////
    
    
	// Center HUD
	CGRect allRect = self.bounds;
	// Draw rounded HUD backgroud rect
	CGRect boxRect = CGRectMake(roundf((allRect.size.width - size.width) / 2) + self.xOffset,
								roundf((allRect.size.height - size.height) / 2) + self.yOffset, size.width, size.height);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect));
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMinY(boxRect) + radius, radius, 3 * (float)M_PI / 2, 0, 0);
	CGContextAddArc(context, CGRectGetMaxX(boxRect) - radius, CGRectGetMaxY(boxRect) - radius, radius, 0, (float)M_PI / 2, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMaxY(boxRect) - radius, radius, (float)M_PI / 2, (float)M_PI, 0);
	CGContextAddArc(context, CGRectGetMinX(boxRect) + radius, CGRectGetMinY(boxRect) + radius, radius, (float)M_PI, 3 * (float)M_PI / 2, 0);
	CGContextClosePath(context);
	CGContextFillPath(context);
    
	UIGraphicsPopContext();
}

#pragma mark - KVO

- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (NSArray *)observableKeypaths {
	return @[@"mode", @"customView", @"labelText", @"labelFont",
			@"detailsLabelText", @"detailsLabelFont", @"progress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateUIForKeypath:keyPath];
	}
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"mode"] || [keyPath isEqualToString:@"customView"]) {
		[self updateIndicators];
	} else if ([keyPath isEqualToString:@"labelText"]) {
		label.text = self.labelText;
	} else if ([keyPath isEqualToString:@"labelFont"]) {
		label.font = self.labelFont;
	} else if ([keyPath isEqualToString:@"detailsLabelText"]) {
		detailsLabel.text = self.detailsLabelText;
	} else if ([keyPath isEqualToString:@"detailsLabelFont"]) {
		detailsLabel.font = self.detailsLabelFont;
	} else if ([keyPath isEqualToString:@"progress"]) {
		if ([indicator respondsToSelector:@selector(setProgress:)]) {
			[(id)indicator setProgress:progress];
		}
		return;
	}
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

#pragma mark - Notifications

- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else if ([superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	CGFloat radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -(CGFloat)M_PI_2; }
		else { radians = (CGFloat)M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = (CGFloat)M_PI; }
		else { radians = 0; }
	}
	rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}

@end


@implementation AlertDialogRoundProgressView {
	float _progress;
	BOOL _annular;
}

#pragma mark - Accessors

- (float)progress {
	return _progress;
}

- (void)setProgress:(float)progress {
	_progress = progress;
	[self setNeedsDisplay];
}

- (BOOL)isAnnular {
	return _annular;
}

- (void)setAnnular:(BOOL)annular {
	_annular = annular;
	[self setNeedsDisplay];
}

#pragma mark - Lifecycle

- (instancetype)init {
	//return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
    return [self initWithFrame:CGRectMake(0.f, 0.f, 37.f, 37.f)];
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		_progress = 0.f;
		_annular = NO;
	}
	return self;
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
	
	CGRect allRect = self.bounds;
    
#ifdef DEBUG
#endif
	CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	if (_annular) {
		// Draw background
		CGFloat lineWidth = 5.f;
		UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
		processBackgroundPath.lineWidth = lineWidth;
		processBackgroundPath.lineCapStyle = kCGLineCapRound;
		CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		CGFloat radius = (self.bounds.size.width - lineWidth)/2;
		CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
		CGFloat endAngle = (2 * (float)M_PI) + startAngle;
		[processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1f] set];
		[processBackgroundPath stroke];
		// Draw progress
		UIBezierPath *processPath = [UIBezierPath bezierPath];
		processPath.lineCapStyle = kCGLineCapRound;
		processPath.lineWidth = lineWidth;
		endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
		[processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
		[[UIColor whiteColor] set];
		[processPath stroke];
	} else {
		// Draw background
		CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
		CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.1f); // translucent white
		CGContextSetLineWidth(context, 2.0f);
		CGContextFillEllipseInRect(context, circleRect);
		CGContextStrokeEllipseInRect(context, circleRect);
		// Draw progress
		CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
		CGFloat radius = (allRect.size.width - 4) / 2;
		CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
		CGFloat endAngle = (self.progress * 2 * (float)M_PI) + startAngle;
		CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
		CGContextMoveToPoint(context, center.x, center.y);
		CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
		CGContextClosePath(context);
		CGContextFillPath(context);
	}
}

@end
