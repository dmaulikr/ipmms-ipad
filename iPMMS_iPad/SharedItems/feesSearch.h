//
//  feesSearch.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface feesSearch : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    UIColor *bgcolor;
    METHODCALLBACK _returnMethod, _naviButtonsCallbacks, _fireCancelMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andNaviCallbacks:(METHODCALLBACK) p_naviButtonCallbacks;
- (void) fireCancelNotification:(NSDictionary*) cancelInfo;
- (void) feesDataGenerated:(NSDictionary *)generatedInfo;

@end
