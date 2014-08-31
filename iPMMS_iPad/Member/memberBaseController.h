//
//  memberBaseController.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberFunctions.h"
#import "defaults.h"

@interface memberBaseController : UIViewController <memberFunctions>
{
    NSString *whoAmI;
    NSDictionary *currDict;
    METHODCALLBACK _controllerCallBack;
    METHODCALLBACK _navigateControllerCallBack;
    METHODCALLBACK _navigatorButtonsCallBack;
}

@property (readwrite, nonatomic, copy) NSString *actuallyIam;
/*- (void) setActuallyIam:(NSString *)actuallyIam;
- (NSString*) actuallyIam;*/
- (void) setControllerCallBack:(METHODCALLBACK) p_controllerCallBack;
- (void) setNavigatorControllerCallBack:(METHODCALLBACK) p_navigatorCallBack;
- (void) setNavigatorButtonsCallBack:(METHODCALLBACK) p_naviButtonsCallBack;
@end
