//
//  notesTypeSearch.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "defaults.h"

@interface notesTypeSearch : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    UIColor *bgcolor;
    METHODCALLBACK _returnMethod, _naviButtonsCallback, _fireCancelMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation withReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsMethod:(METHODCALLBACK) p_naviButtonsCallback;
- (void) fireCancelNotification:(NSDictionary*) cancelInfo;
- (void) notesTypeListDataGenerated:(NSDictionary *)generatedInfo;
@end
