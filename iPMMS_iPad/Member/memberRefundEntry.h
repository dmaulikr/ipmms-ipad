//
//  memberRefundEntry.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberFunctions.h"
#import "gymWSProxy.h"
#import "memberRefundObjects.h"
#import "contractSearch.h"

@interface memberRefundEntry : UIView<memberFunctions>
{
    memberRefundObjects *memRefundDataObjects;
    contractSearch *contSelect;
    UIView *newview;
    IBOutlet UIScrollView *parentScroll;
    CGRect prevFrame;
    NSString *currMode;
    UIInterfaceOrientation currOrientation;
    NSMutableDictionary *barButtonInfo;
    gymWSProxy *mdProxy;
    IBOutlet UIActivityIndicatorView *actIndicator;
    UIColor *bgcolor;
    NSDictionary *btnCancel,*btnSave, *btnEdit ;
    NSDictionary *_initDict;
    NSString *titleName;
    METHODCALLBACK _controllerCallBack, _contractCallback, _naviButtonsCallback;
}

- (id) initWithDictionary:(NSDictionary *)p_dict andFrame:(CGRect)p_frame andOrientation:(UIInterfaceOrientation)p_intOrientation forMode:(NSString *)p_forMode andControllerCallback:(METHODCALLBACK)p_controllerCallback andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback;
- (void) memberRefundDataGenerated:(NSDictionary*) memberNotesData;
- (void) memberRefundDataSaved:(NSDictionary*) savedInfo;
- (void) contractNotificaiton:(NSDictionary*) notifyInfo;

@end
