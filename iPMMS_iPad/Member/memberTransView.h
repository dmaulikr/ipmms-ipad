//
//  memberTransView.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 26/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberFunctions.h"
#import "gymWSProxy.h"
#import "memTransObjects.h"
#import "bankSearch.h"

@interface memberTransView : UIView<memberFunctions>
{
    memTransObjects *memTransDataObjects;
    bankSearch *bankSelect;
    UIView *newview;
    IBOutlet UIScrollView *parentScroll;
    CGRect prevFrame;
    NSString *currMode;
    UIInterfaceOrientation currOrientation;
    NSMutableDictionary *barButtonInfo;
    //gymWSProxy *mdProxy;
    IBOutlet UIActivityIndicatorView *actIndicator;
    UIColor *bgcolor;
    NSDictionary *btnCancel,*btnSave, *btnEdit ;
    NSDictionary *_initDict;
    NSString *titleName;
    METHODCALLBACK _transDataGenerated;
    METHODCALLBACK _controllerCallBack;
    METHODCALLBACK _naviButtonsCallBack;
    METHODCALLBACK _bankCallbacks;
}

- (id) initWithDictionary:(NSDictionary*) p_dict andFrame:(CGRect) p_frame andOrientation:(UIInterfaceOrientation) p_intOrientation forMode:(NSString*) p_forMode andControllerCallback:(METHODCALLBACK) p_controllerCallback andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback;
- (void) memberTransDataGenerated:(NSDictionary*) memberTransData;
- (void) memberTransDataSaved:(NSDictionary*) savedInfo;
- (void) bankNotification:(NSDictionary*) notifyInfo;
@end
