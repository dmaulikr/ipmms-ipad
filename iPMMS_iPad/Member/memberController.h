//
//  memberController.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberSearch.h"
#import "memberBaseController.h"

@class memberTransController;

@interface memberController : memberBaseController <UIAlertViewDelegate>
{
    memberSearch *memSearch;
    UIInterfaceOrientation currOrientation;
    NSString *currMode;
    //NSDictionary *currDict;
    BOOL firstLoad ;
    UIAlertView *dAlert;
    METHODCALLBACK _reloginMethod;
}

@property (strong, nonatomic) memberTransController *memTransaction;

- (id) initWithReloginMethod:(METHODCALLBACK) p_reloginMethod;
- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) generateMembersList;
- (void) initialize;
- (void) searchMemberReturn:(NSDictionary *)memberInfo;
- (void) controllerNotification:(NSDictionary*) notifyInfo;

@end
