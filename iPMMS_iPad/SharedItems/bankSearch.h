//
//  bankSearch.h
//  salesapi
//
//  Created by Imac on 4/25/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface bankSearch :  baseSearchForm <UITableViewDataSource, UITableViewDelegate>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    UIColor *bgcolor;  
    METHODCALLBACK _returnMethod;
    METHODCALLBACK _naviButtonsMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andNavigateButtonsMethod:(METHODCALLBACK) p_naviButtonsMethod;
- (void) fireCancelNotification:(NSDictionary*) cancelInfo;
- (void) bankListDataGenerated:(NSDictionary *)generatedInfo;

@end
