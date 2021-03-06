//
//  memberRefunds.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberBaseController.h"
#import "memberRefundsList.h"


@interface memberRefunds : memberBaseController <UISplitViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    memberRefundsList *memRefList;
    UIInterfaceOrientation currOrientation;
    UINavigationItem *_navItem;
    CGRect myFrame;
    NSDictionary *planDict;
}

@end
