//
//  memberProfile.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberBaseController.h"
#import "memberView.h"

@interface memberProfile : memberBaseController
{
    memberView *memView;
    UIInterfaceOrientation currOrientation;
    UINavigationItem *_navItem;
    METHODCALLBACK _photoNotifyMethod;
}

- (void) setPhotoNotifyMethod:(METHODCALLBACK) p_photoNotifyMethod;
- (void) newPhotoTaken:(NSDictionary*) photoInfo;

@end
