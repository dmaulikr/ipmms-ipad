//
//  contractSearch.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface contractSearch : baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    UIColor *bgcolor; 
    NSDictionary *_initDict;
    NSNumberFormatter *frm;
    METHODCALLBACK _returnMethod, _naviButtonsCallback, _fireCancelMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andDictionary:(NSDictionary*) p_initDict andReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsMethod:(METHODCALLBACK) p_naviButtonsCallback;
- (void) fireCancelNotification:(NSDictionary*) cancelInfo;
- (void) contractDataGenerated:(NSDictionary *)generatedInfo;

@end
