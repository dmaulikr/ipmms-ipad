//
//  memberSearch.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "defaults.h"
#import "memberFunctions.h"

@interface memberSearch :  baseSearchForm <UITableViewDataSource, UITableViewDelegate, memberFunctions>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    NSInteger viewItemNo;
    NSIndexPath *curIndPath;
    int _currControllerIndex;
    NSString *MAIN_URL;
    METHODCALLBACK _returnMethod;
}
- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) memberListDataGenerated:(NSDictionary *)generatedInfo;
- (void) memberControllerInfoUpdate:(NSDictionary*) controllerInfo;

@end
