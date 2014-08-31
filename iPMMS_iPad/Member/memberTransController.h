//
//  memberTransController.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberController.h"
#import "memberProfile.h"
#import "memberPlans.h"
#import "memberTransaction.h"
#import "memberNotes.h"
#import "memberRefunds.h"
#import "memberTransactionPopover.h"

@interface memberTransController : memberBaseController <UISplitViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UITabBarController *tab;
    IBOutlet UIView *containerView;
    UIBarButtonItem *btnTransactions;
    UIInterfaceOrientation currOrientation;
    int currTabIndex;
    NSDictionary *custNotifyInfo;
    UIImagePickerController *imgPicker;
    memberPlans *memPlans;
    memberProfile *memProfile;
    memberTransaction *memTrans;
    memberNotes *memNotes;
    memberRefunds *memRefunds;
    memberBaseController *memCtrl;
    METHODCALLBACK _photoCallBack;
    METHODCALLBACK _memberInfoUpdate;
}

@property (strong, nonatomic) UIPopoverController *memberMasterPop;
@property (nonatomic, retain) UITabBarController *tab;

- (id) initWithMemberDictionary:(NSDictionary*) p_memDict;
- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation;
- (id) getButtonForNavigation:(NSString*) p_btnTask;
- (void)grabPhoto:(NSDictionary*) photoInfo;
- (void) navigateMemberController:(NSDictionary*) naviInfo;
- (void) navigationNotification :(NSDictionary*) p_navigateInfo;
- (void) setMemberInfoUpdateMethod:(METHODCALLBACK) p_memberInfoUpdate;

@end
