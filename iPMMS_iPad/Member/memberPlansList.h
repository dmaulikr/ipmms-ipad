//
//  memberPlansList.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 17/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "defaults.h"
#import "memberFunctions.h"
#import "memberPlanEntry.h"


@interface memberPlansList : baseSearchForm <UITableViewDataSource, UITableViewDelegate, memberFunctions>
{
    memberPlanEntry *memPlanView;
    int refreshTag;
    CGRect myFrame;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    NSInteger viewItemNo;
    NSIndexPath *curIndPath;
    NSDictionary *_initDict;
    NSMutableDictionary *barButtonInfo;
    UIColor *bgcolor;
    NSDictionary *btnInsert /*, *btnMember, *btnTrans, *btnNotes, *btnRefunds*/;
    NSNumberFormatter *frm;
    NSString *titleName;
    METHODCALLBACK _controllerCallBack;
    METHODCALLBACK _naviButtonsCallback;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation  andControllerCallBack:(METHODCALLBACK) p_controllerCallBack andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback;
- (IBAction)viewSelectedItem:(id)sender;
- (void) memberListDataGenerated:(NSDictionary *)generatedInfo;
@end