//
//  payScheduleEntry.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 23/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"

@interface payScheduleEntry : baseSearchForm <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    int refreshTag;
    int editRecordNo;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    UITextField *txtPayDate, *txtAmount;
    int _planScheduleId;
    UIColor *bgcolor;
    NSMutableDictionary *barButtonInfo;
    NSDictionary *_initDict;
    UIColor *lblTextColor;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    METHODCALLBACK _returnMethod, _naviButtonsCallback, _fireOptionsMethod;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback;
- (UITableViewCell*) getFirstRowCell;
- (UITableViewCell*) getSecondRowCell;
- (BOOL) validateData;
- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) editPayScheduleData:(NSDictionary*) p_scheData forRowNo:(int) p_rowNo;
- (void) setValueforText:(UITextField*) p_passField andField:(NSString*) p_fieldName;
- (void) displayDictDataForMode:(NSString*) p_dispmode;
- (void) fireOptionsPayScheduleEntry:(NSDictionary*) executionInfo;

@end
