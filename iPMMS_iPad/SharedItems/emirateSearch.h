//
//  emirateSearch.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "defaults.h"


@interface emirateSearch :  baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    METHODCALLBACK _returnMethod, _naviButtonsCallback, _fireCancelCallback;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation withReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback;
- (void) fireCancelNotification:(NSDictionary*) cancelInfo;
- (void) emirateListDataGenerated:(NSDictionary *)generatedInfo;

@end
