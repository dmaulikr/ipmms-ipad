//
//  memberTransList.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 25/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "memberFunctions.h"
#import "memberTransView.h"

@interface memberTransList : baseSearchForm <UITableViewDataSource, UITableViewDelegate, memberFunctions>
{
    memberTransView *memTransView;
    int refreshTag;
    NSString *_notificationName, *_proxynotification, *_webdataName, *_cacheName,*_gobacknotifyName;
    NSString *currMode;
    NSInteger viewItemNo;
    NSIndexPath *curIndPath;
    NSDictionary *_initDict;
    NSMutableDictionary *barButtonInfo;
    UIColor *bgcolor;
    NSDictionary *btnInsert /*, *btnMember, *btnContract, *btnNotes, *btnRefunds*/;
    NSNumberFormatter *frm;
    METHODCALLBACK _controllerCallback;
    METHODCALLBACK _naviButtonsCallback;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification withNewDataNotification:(NSString*)  p_proxynotificationname andDictionary:(NSDictionary*) p_initDict andControllerCallback:(METHODCALLBACK) p_controllerCallback andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback;
- (IBAction)viewSelectedItem:(id)sender;
- (void) memberTransListDataGenerated:(NSDictionary *)generatedInfo;

@end
