//
//  login.h
//  dssapi
//
//  Created by Raja T S Sekhar on 1/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "defaults.h"
#import "gymWSProxy.h"

@interface login : UIView 
{
    IBOutlet UITextField *Email,*Password;
    CGPoint scrollOffset;
	NSMutableString *parseElement,*value;
    NSMutableData *webData;
    NSXMLParser *xmlParser;
    NSMutableString *respcode, *respmessage;
    IBOutlet UIActivityIndicatorView *actview;
    IBOutlet UIView *loginControl;
    IBOutlet UIImageView *mainImage;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *btnLogin;
    UIInterfaceOrientation intOrientationType;
    //NSString *_notificationName;
    //gymWSProxy *_wsProxy;
    METHODCALLBACK _returnMethod;
}
- (IBAction)Login;
- (BOOL) validate;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) setForOrientation:(UIInterfaceOrientation) orientationType;
- (id) initWithFrame:(CGRect)frame andReturnMethod:(METHODCALLBACK) p_returnMethod withOrientation:(UIInterfaceOrientation) p_intOrientation;
- (void) resetValues;
@end
