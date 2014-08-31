//
//  signIn.h
//  dssapi
//
//  Created by Raja T S Sekhar on 2/21/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "login.h"
#import "memberTransController.h"
#import "locationSearch.h"

@interface signIn : UIViewController {
    login *signLogin;
    locationSearch *locSearch;
    UIInterfaceOrientation currOrientation;
    NSUserDefaults *standardUserDefaults;
    METHODCALLBACK _returnMethod;
}

- (id) initWithReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) loginSuccessful : (NSDictionary*) signInfo;
- (void) locationNotifyLogin : (NSDictionary*) locInfo;
@end
