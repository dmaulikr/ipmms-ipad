//
//  feesDataEntry.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface feesDataEntry :  baseSearchForm <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    int refreshTag;
    int editRecordNo;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName/*,*_gobacknotifyName*/;
    NSString *currMode;
    UITextField *txtFeesName, *txtAmount;
    int _feesId, _planFeesId;
    UIColor *bgcolor;
    NSMutableDictionary *barButtonInfo;
    NSDictionary *_initDict;
    UIColor *lblTextColor;
    METHODCALLBACK _returnMethod;
    METHODCALLBACK _naviButtonsCallback;
    METHODCALLBACK _feesCallbacks;
    METHODCALLBACK _fireCancelCallback;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation returnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback andFeesCallback:(METHODCALLBACK) p_feesCallback;
- (UITableViewCell*) getFirstRowCell;
- (UITableViewCell*) getSecondRowCell;
- (void) setFeesValues:(NSDictionary*) p_feesInfo;
- (BOOL) validateData;
- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) addNewFeesData;
- (void) editFeesData:(NSDictionary*) p_feeData forRowNo:(int) p_rowNo;
- (void) setValueforText:(UITextField*) p_passField andField:(NSString*) p_fieldName;
- (void) displayDictDataForMode:(NSString*) p_dispmode;
- (void) fireOptionsFeesServicesEntry:(NSDictionary*) executionInfo;

@end
