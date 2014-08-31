//
//  locationSearch.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 18/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "defaults.h"

@interface locationSearch : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    BOOL isSplitMode;
    METHODCALLBACK _naviButtonsCallBack;
    METHODCALLBACK _returnMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation withReturnMethod:(METHODCALLBACK) p_returnMethod andIsSplit:(BOOL) p_isSplit withNaviButtonsMethod:(METHODCALLBACK) p_naviButtonsCallBack;
- (void) fireCancelNotification:(NSDictionary*) cancelInfo;
- (void) locationListDataGenerated:(NSDictionary *)generatedInfo;

@end
