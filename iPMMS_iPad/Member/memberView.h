//
//  memberView.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberObjects.h"
#import "emirateSearch.h"
#import "nationalitySearch.h"
#import "locationSearch.h"

@interface memberView : UIView<memberFunctions>
{
    UIView *newview;
    memberObjects *memDataObjects;
    emirateSearch *emirateSelect;
    locationSearch *locSelect;
    nationalitySearch *nationSelect;
    IBOutlet UIScrollView *parentScroll;
    CGRect prevFrame;
    NSString *currMode;
    UIInterfaceOrientation currOrientation;
    NSMutableDictionary *barButtonInfo;
    gymWSProxy *mdProxy;
    IBOutlet UIActivityIndicatorView *actIndicator;
    UISegmentedControl *scMemberOptions;
    UIColor *bgcolor;
    BOOL populationOnProgress;
    METHODCALLBACK _controllerCallBack, _photoCallBack, _navigatorCallBack, _naviButtonsCallBack, _locReturn, _emirateCallback, _nationalityCallback;
}

//- (void) setMemberOptionsProperly;
- (IBAction)memberAction:(id)sender;
- (void) memberDataSaved:(NSDictionary*) savedInfo;
- (id) initWithDictionary:(NSDictionary*) p_dict andFrame:(CGRect) p_frame andOrientation:(UIInterfaceOrientation) p_intOrientation forMode:(NSString*) p_forMode andControllerCallback:(METHODCALLBACK)p_controllerCallback andPhotoCallBack:(METHODCALLBACK) p_photoMethod andNavigatorCallBack:(METHODCALLBACK) p_navigatorCallBack andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallBack;
- (void) locationNotificaiton :(NSDictionary*) notifyInfo;
- (void) emirateNotification :(NSDictionary*) notifyInfo;
- (void) nationalityNotification :(NSDictionary*) notifyInfo;
- (void) newPhotoTaken:(NSDictionary*) photoInfo;
@end
