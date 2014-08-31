//
//  memberTransactionPopover.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 29/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"

@interface memberTransactionPopover :UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_headertv;
    METHODCALLBACK _navigatorCallBack;
}

- (void) setNavigatorCallBack:(METHODCALLBACK) p_navigatorCallBack;
@end
