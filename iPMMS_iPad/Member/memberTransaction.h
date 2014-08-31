//
//  memberTransaction.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 25/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberBaseController.h"
#import "memberTransList.h"

@interface memberTransaction : memberBaseController
{
    memberTransList *memTransList;
    UIInterfaceOrientation currOrientation;
    UINavigationItem *_navItem;
    CGRect myFrame;
    NSDictionary *tranDict;
    NSString *currMode;
}

@end
