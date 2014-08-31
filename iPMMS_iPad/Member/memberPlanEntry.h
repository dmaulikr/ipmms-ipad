//
//  membrPlanEntry.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 26/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberFunctions.h"
#import "gymWSProxy.h"
#import "memberPlanObjects.h"
#import "planSearch.h"
#import "billCycleSearch.h"
#import "feesDataEntry.h"
#import "feesSearch.h"
#import "payScheduleEntry.h"

@interface memberPlanEntry : UIView<memberFunctions, UIAlertViewDelegate>
{
    UIAlertView *dAlert;
    UIView *newview;
    memberPlanObjects *memPlanDataObjects;
    planSearch *planSelect;
    billCycleSearch *billCycleSelect;
    feesDataEntry *feesDE;
    feesSearch *feeSelect;
    payScheduleEntry *paySE;
    IBOutlet UIScrollView *parentScroll;
    CGRect prevFrame;
    NSString *currMode;
    UIInterfaceOrientation currOrientation;
    NSMutableDictionary *barButtonInfo;
    //gymWSProxy *mdProxy;
    IBOutlet UIActivityIndicatorView *actIndicator;
    UIColor *bgcolor;
    NSDictionary *btnCancel,*btnSave, *btnEdit, *btnTerminate ;
    //NSDictionary *_initDict;
    NSDictionary *_dispDict;
    NSString *titleName;
    METHODCALLBACK _memPlanDataSavedMethod,_controllerCallBack,_naviButtonsCallback,_billcycleCallbacks, _planTypeCallbacks, _feeDataCallbacks,_feeSearchCallbacks, _terminateCallback, _payDataCallback;
}
- (id) initWithFrame:(CGRect)p_frame andOrientation:(UIInterfaceOrientation)p_intOrientation andControllerCallBack:(METHODCALLBACK)p_controllerCallBack andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonscallback;
- (void) memberPlanDataSaved:(NSDictionary*) savedInfo;
- (void) memberPlanDataGenerated:(NSDictionary*) memberPlanData;
- (void) billCycleNotification:(NSDictionary*) notifyInfo;
- (void) planTypeNotification:(NSDictionary*) notifyInfo;
- (void) terminateNotification:(NSDictionary*) notifyInfo;
- (void) feesDataNotification:(NSDictionary*) notifyInfo;
- (void) feesNotification:(NSDictionary*) notifyInfo;
- (void) payDataNotification:(NSDictionary*) notifyInfo;

@end
