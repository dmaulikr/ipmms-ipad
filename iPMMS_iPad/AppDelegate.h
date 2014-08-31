//
//  AppDelegate.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "signIn.h"

@class signIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *nav;
    memberController *memBrowse;
    memberTransController *memTransaction;
    UINavigationController *masterNavigationController;
    UINavigationController *detailNavigationController;
    BOOL _initialized;
    METHODCALLBACK _reLoginMethod;
    METHODCALLBACK _loginSucceeded;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UISplitViewController *splitViewController;
//@property (strong, nonatomic) signIn *viewController;
- (void) loginSucceeded : (NSDictionary*) loginInfo;
- (void) makeReLogin : (NSDictionary*) relogInfo;

@end
