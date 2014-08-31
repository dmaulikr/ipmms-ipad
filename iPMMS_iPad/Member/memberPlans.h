//
//  memberPlans.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberBaseController.h"
#import "memberPlansList.h"

@interface memberPlans : memberBaseController
{
    memberPlansList *memPlansList;
    UIInterfaceOrientation currOrientation;
    UINavigationItem *_navItem;
    CGRect myFrame;
    NSDictionary *planDict;
}

@end
