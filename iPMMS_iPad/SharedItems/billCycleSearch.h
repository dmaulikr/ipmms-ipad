//
//  billCycleSearch.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 21/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface billCycleSearch :  baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    UIColor *bgcolor;
    METHODCALLBACK _returnMethod;
    METHODCALLBACK _naviButtonsMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsMethod:(METHODCALLBACK) p_naviButtonsMethod;
- (void) fireCancelNotification:(NSDictionary*) cancelInfo;
- (void) billCycleDataGenerated:(NSDictionary *)generatedInfo;

@end
