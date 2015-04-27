//
//  WebtrendsClientLibrary.h
//  Version: 1.4.9
//  
//
//  Copyright 2009-2013 Webtrends. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#pragma mark -
#pragma mark WTAppDelegate

/*
 
 If you would like automatic event generation for application start, stop and notification methods, 
 change the base class of your app delegate from NSObject to WTAppDelegate. If you override any of 
 these methods and still want automatic behavior, be sure to call super. These methods will automatically
 send events to Webtrends for data collection. 
 
*/

@interface WTAppDelegate: NSObject<UIApplicationDelegate> {
	
}

/*
 
 Sends an application/start event to Webtrends automatically. The parameters
 will indicate that the app was launched from the device's home screen.
 
*/
- (void)applicationDidFinishLaunching:(UIApplication *)application;

/*
 
 Sends an application/start event to Webtrends automatically. The parameters
 will indicate that the app was launched either from a notification or from
 a registered URL  (whichever applies).
*/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/*

 Sends an application/notification event to Webtrends automatically.
 
*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

/*

 Sends an application/exit event to Webtrends automatically. In most cases the event will
 be queued and sent to Webtrends the next time the application starts, as there
 may not be time to send it before the app terminates.
 
*/
- (void)applicationWillTerminate:(UIApplication *)application;


/*

 Sends an application/background event to Webtrends automatically. In most cases the event will
 be queued and sent to Webtrends the next time the application foregrounds, as there
 may not be time to send it before the app backgrounds.
 */
- (void)applicationDidEnterBackground:(UIApplication *)application;

/*
 
 Sends an application/foreground event to Webtrends automatically. 
 
*/
- (void)applicationWillEnterForeground:(UIApplication *)application;

/*
 
 Set VisitorID/LastVisitTime if the app is launched or actived by another app.
 
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end

/*
 
 If you would like automatic event generation for screen view, use WTUIViewController instead of UIViewController. If you override viewDidAppear and still want automatic behavior, be sure to call super. These methods will automatically send events to Webtrends for data collection. 
 
*/

@interface WTUIViewController : UIViewController {
    
}

@end

/*
 
 Set this as a delegate for any UIWebViews that use webtrendsMobileLib.js.
 
 */

@interface WTUIWebViewDelegate : NSObject<UIWebViewDelegate> {
}
@end

#pragma mark -
#pragma mark WTDC

/*

 The WTDC category is added to NSObject. You can call these methods from any subclass 
 of NSObject to send data collection events to Webtrends. Typically this would be done
 from your view controllers. You can create the WTEvent object using the convenience methods
 (see class methods for WTEvent), set your own parameter values or implement the 
 WTDCEventSource protocol and populate the event parameters in that method.
 
*/

@class WTEvent;

@interface NSObject (WTDC) 

-(NSURL*) addSessionInfo:(NSURL* )url;
-(void) setCustomVisitorId:(NSString *)visitorId;
-(void) trackEvent:(WTEvent*) event;
-(void) disableEventTracking;
-(void) enableEventTracking;
-(void) shutdownEventTracking;
-(void) clearEventQueue;
-(void) suspendWebtrendsNotifications;
-(void) resumeWebtrendsNotifications;

@property BOOL DCSVerbose;
@property BOOL DCSDebug;
@property (readonly) NSNumber *queuedEventCount;

//Programmatic config
- (BOOL) set_WT_DC_DCSID: (NSString*) dcsid andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *WT_DC_DCSID;

- (BOOL) set_WT_DC_URL: (NSString*) dcurl andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *WT_DC_URL;

- (BOOL) set_WT_DC_QUEUE_PAUSED_ONSTARTUP:(BOOL) paused andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL WT_DC_QUEUE_PAUSED_ONSTARTUP;

- (BOOL) set_WT_DC_USE_UNCAUGHT_EXCEPTION_HANDLER:(BOOL) useHandler andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL WT_DC_USE_UNCAUGHT_EXCEPTION_HANDLER;

- (BOOL) set_WT_DC_SESSION_TIMEOUT:(int) timeout andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL WT_DC_SESSION_TIMEOUT;

- (BOOL) set_WT_DC_SESSION_MAXIMUM:(int) max andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) int WT_DC_SESSION_MAXIMUM;

- (BOOL) set_WT_DC_TIMEZONE:(int) tz andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) int WT_DC_TIMEZONE;

- (BOOL) set_WT_DC_APP_CATEGORY: (NSString*) appCat andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *WT_DC_APP_CATEGORY;

- (BOOL) set_WT_DC_APP_NAME: (NSString*) appName andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *WT_DC_APP_NAME;

- (BOOL) set_WT_DC_APP_PUBLISHER: (NSString*) appPub andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *WT_DC_APP_PUBLISHER;

- (BOOL) set_WT_DC_APP_VERSION: (NSString*) appVersion andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *WT_DC_APP_VERSION;

- (BOOL) set_WT_DC_EVENT_TABLE_SIZE_MAXIMUM:(int) size andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) int WT_DC_EVENT_TABLE_SIZE_MAXIMUM;

- (BOOL) set_WT_DC_EVENT_RETRY_MAXIMUM:(int) count andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) int WT_DC_EVENT_RETRY_MAXIMUM;

- (BOOL) set_WT_DC_CHARGE_THRESHOLD_MINIMUM:(int) threshold andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) int WT_DC_CHARGE_THRESHOLD_MINIMUM;

- (BOOL) set_WT_DC_ENABLE_BACKGROUND_SEND:(BOOL) bgsend andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL WT_DC_ENABLE_BACKGROUND_SEND;

- (BOOL) set_WT_DC_DEBUG:(BOOL) debug andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL WT_DC_DEBUG;

- (BOOL) set_WT_DC_ENABLED:(BOOL) enable andPersist: (BOOL) persist;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL WT_DC_ENABLED;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *WT_DC_ID_METHOD;

@end // WTEvent

#pragma mark -
#pragma mark WTDCEventSource

/*

 trackEvent will invoke this callback if it's present in the sending class. 
 This method may return additional parameters that should be sent along with the 
 event to Webtrends by returning a dictionary with those values. 
 This is a convenient way to manage (most) of your tracking logic from one place.
 
*/

@protocol WTDCEventSource

- (NSDictionary*) parametersForEvent:(WTEvent*) event;

@end // WTEvent


#pragma mark -
#pragma mark WTParameter

/*

 The WTParameter enumeration contains all supported
 parameter types (typically used in calls to WTEvent's setValue:forParameter: method). 
 These will automatically map to the underlying Webtrends parameter. If the
 parameter is not available here you may use a custom parameter using
 WTEvent's setValue:forCustomParameter: method.
 
*/
typedef NS_ENUM(NSInteger, WTParameter) {
	WTParameterApplicationVersion = 0,
	WTParameterApplicationCategory,
	WTParameterApplicationName,	
	WTParameterApplicationPublisher,
	WTParameterContentGroup,
	WTParameterMediaEvent,
	WTParameterMediaName,
	WTParameterMediaType,
	WTParameterConversionName,
	WTParameterConversionStep,
	WTParameterEventTimestamp,
	WTParameterCustomEvent,
	WTParameterTitle,
	WTParameterPageOfInterest,
	WTParameterProductId,
	WTParameterProductSku,
	WTParameterSpecialEvent,
	WTParameterScreenResolution,
	WTParameterConnectionType,
	WTParameterErrorMessage,
	WTParameterUnknown,
	WTParameterAdClick,
	WTParameterAdName,
	WTParameterAdImpression,
	WTParameterSearchPhrase,
	WTParameterSearchResult
} ;

/*
 
 WTLaunchStyle may be used when calling WTEvent's eventForAppLaunch
 method. 
 
*/
typedef NS_ENUM(NSInteger, WTLaunchStyle) {
	WTLaunchStyleFromURL,
	WTLaunchStyleFromNotification,
	WTLaunchStyleFromHomeScreen
} ;


typedef NS_ENUM(NSInteger, WTVisitorType) {
	WTUseCustomId,
	WTUseWebtrendsId,
	WTUseSystemId
} ;


extern NSString *WTDCEventSentNotification; 

@interface WTEvent : NSObject {
	
	NSString *eventPath; 
	NSString *eventDescription; 
	NSMutableDictionary *_p;
	NSMutableString *_descriptionStorage;
}

#pragma mark -
#pragma mark WTEvent - Initialization Methods

/*

 Initializes a WTEvent with a path and description. Both are required or a
 NSInternalInconsistencyException will be thrown. The event type is optional.
 
*/
- (instancetype) initWithEventPath:(NSString*) eventPath eventDescr:(NSString*) eventDescr;
- (instancetype) initWithEventPath:(NSString*) eventPath eventDescr:(NSString*) eventDescr eventType: (NSString*) eventType;

#pragma mark -
#pragma mark WTEvent - Parameter Methods

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Helper method to repeat a string and join it 
// for example:
//
//    NSArray *pathArray = [NSArray arrayWithObjects:@"here", @"be", @"dragons", nil];
//
//    NSLog(@"%@",    [self RepeatAndJoin:@"1" Seperator:@";" Count: [pathArray count]]  );
//
//  would prints 1,1,1
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ (NSMutableString*) RepeatAndJoin: (NSString*) join  Seperator:(NSString*) sep Count:(int) count;

/*
 
 Sets the value for a built-in Webtrends parameter. 
 If the parameter is invalid the value will not be set.
 
*/
- (void) setValue:(NSString*) value forParameter:(WTParameter) parameter;

/*
 
 Sets the value for a custom parameter. 
 If parameter is nil the value will not be set.

*/
- (void) setValue:(NSString*) value forCustomParameter:(NSString*) parameter;

/*
 Used to test if a key has been set or not.  
 for example: 
	[evt isKeySet: @"WT.co_f"]
 */
- (BOOL) isKeySet:(NSString *) key;

#pragma mark -
#pragma mark WTEvent - Convenience Methods


/*
 
 Creates a new WTEvent initialized with the event path, description and type. The former two parameters
 are requried or an NSInternalInconsistencyException will be thrown.

*/
+ (WTEvent*) eventWithPath:(NSString*) eventPath eventDescr:(NSString*) eventDescr eventType: (NSString*) eventType;

/*
 
 Returns a new WTEvent that indicates an error has occured in the application. An optional message may
 be specified that will display in reports. 
 
*/
+ (WTEvent*) eventForError:(NSString*) message;
+ (WTEvent*) eventForError:(NSString*) message applicationName:(NSString*) applicationName;

/*

 Returns a new WTEvent that indicates the application was launched. The WTLaunchStyle indicates how
 the application was started--either from the home screen, from a push notification or a registered URL.
 
*/
+ (WTEvent*) eventForAppLaunch:(WTLaunchStyle) launchStyle; 
+ (WTEvent*) eventForAppLaunch:(WTLaunchStyle) launchStyle applicationName:(NSString*) applicationName;

/*
 
 Returns a new WTEvent that indicates the application has exited (normally). 
 
*/
+ (WTEvent*) eventForAppExit;
+ (WTEvent*) eventForAppExit: (NSString*) applicationName;

/*
 
 Returns a new WTEvent that indicates the application has backgrounded. 
 
*/
+ (WTEvent*) eventForAppBackground;
+ (WTEvent*) eventForAppBackground: (NSString*) applicationName;
/*
 
 Returns a new WTEvent that indicates the application has foregrounded. 
 
*/
+ (WTEvent*) eventForAppForeground;
+ (WTEvent*) eventForAppForeground: (NSString*) applicationName;

/*
 
 Returns a new WTEvent that indicates a notification was recieved.
 
*/
+ (WTEvent*) eventForNotification;
+ (WTEvent*) eventForNotification: (NSString*) applicationName;

/*
 
 Returns a new WTEvent that indicates a product was viewed. The path,
 description and product sku are requried or an NSInternalInconsistencyException will be thrown.

*/
+ (WTEvent*) eventForProductView:(NSString*) eventPath eventDescr:(NSString*) eventDescr eventType: (NSString*) eventType contentGroup:(NSString*) contentGroup productId:(NSString*) productId productSku:(NSString*) productSku;

/*

 Returns a new WTEvent that indicates a product was viewed. The path and
 description are requried or an NSInternalInconsistencyException will be thrown.
 
*/
+ (WTEvent*) eventForMediaView:(NSString*) eventPath eventDescr:(NSString*) eventDescr eventType: (NSString*) eventType contentGroup:(NSString*) contentGroup mediaName:(NSString*) mediaName mediaType:(NSString*) mediaType mediaEvent:(NSString*) mediaEvent;

/*
 
 Returns a new WTEvent that indicates a conversion event occured. The path,
 description and conversion name are requried or an NSInternalInconsistencyException will be thrown.

*/
+ (WTEvent*) eventForConversion:(NSString*) eventPath eventDescr:(NSString*) eventDescr eventType: (NSString*) eventType contentGroup:(NSString*) contentGroup conversionName:(NSString*) conversionName;


/*
 
 Returns a new WTEvent that indicates a content view event occured. The path and
 description are requried or an NSInternalInconsistencyException will be thrown.

DEPRECATED: use eventForScreenView instead 
*/
+ (WTEvent*) eventForContentView:(NSString*) eventPath eventDescr:(NSString*) eventDescr eventType: (NSString*) eventType contentGroup:(NSString*) contentGroup;


/*
 
 Returns a new WTEvent that indicates a screen view event occured. The path and
 description are requried or an NSInternalInconsistencyException will be thrown.
 
*/
+ (WTEvent*) eventForScreenView:(NSString*) eventPath eventDescr:(NSString*) eventDescr eventType: (NSString*) eventType contentGroup:(NSString*) contentGroup;


/*
 
 Returns a new WTEvent that indicates an "action" event occured. These events are not counted
 as page views and typically indicate than some user activity occured (as opposed to a "view").
 The path and description are requried or an NSInternalInconsistencyException will be thrown.
 
*/
+ (WTEvent*) eventForAction:(NSString*) eventPath eventDescr:(NSString*) eventDescr eventType: (NSString*) eventType;

/*
 
 Returns a new WTEvent that indicates an "AdClick" event occured. Use to track instances of when
 a user clicks an Ad. The path and description are requried or an 
 NSInternalInconsistencyException will be thrown.
 
 */
+ (WTEvent*) eventForAdClick:(NSString*) eventPath 
				  eventDescr:(NSString*) eventDescr 
				   eventType:(NSString*) eventType 
					  adName:(NSString*) adName;

/*
 
 Returns a new WTEvent that indicates an "eventForAdImpression" event occured. Use to track instances of when
 a user sees a set of Ads. The path and description are requried or an 
 NSInternalInconsistencyException will be thrown.
 
 The elements of NSArray should be NSStrings.
 
 */
+ (WTEvent*) eventForAdImpression:(NSString*) eventPath 
					   eventDescr:(NSString*) eventDescr 
						eventType:(NSString*) eventType 
						  adNames:(NSArray*)  adNames;

/*
  Returns a new WTEvent that indicates a user did a search.  
 The path and description are requried or an NSInternalInconsistencyException will be thrown.
 */
+ (WTEvent*) eventForSearchEvent:(NSString*) eventPath 
					  eventDescr:(NSString*) eventDescr 
					   eventType:(NSString*) eventType 
					searchPhrase:(NSString*) searchPhrase
					searchResult:(NSString*) searchResult;

/*
 */
@property (NS_NONATOMIC_IOSONLY, readonly) int descriptionLength;


#pragma mark -
#pragma mark WTEvent - Properties

@property(nonatomic, retain) NSString *eventPath;
@property(nonatomic, retain) NSString *eventDescription;

#pragma mark -
@end // WTEvent
