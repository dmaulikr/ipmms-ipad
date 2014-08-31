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

@interface membrPlanEntry : UIView<memberFunctions>
{
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
    gymWSProxy *mdProxy;
    IBOutlet UIActivityIndicatorView *actIndicator;
    UIColor *bgcolor;
    NSDictionary *btnCancel,*btnSave, *btnEdit ;
    NSDictionary *_initDict;
}
- (void) setUpdateMode:(NSDictionary*) p_dictData;

@end
