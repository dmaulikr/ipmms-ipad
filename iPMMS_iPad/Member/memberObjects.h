//
//  memberObjects.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "memberFunctions.h"
#import "gymWSProxy.h"
#import "Base64.h"

@interface memberObjects : NSObject <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIAlertViewDelegate, memberFunctions>
{
    NSDictionary *_initDict;
    UITextField *txtBarcode, *txtAgreement, *txtSurname, *txtFirstname, *txtAddress1, *txtAddress2, *txtTown, *txtCounty, *txtPostcode, *txtHomePh, *txtWorkPh, *txtExtn, *txtMobile, *txtEmerContact, *txtEmerPh, *txtEmail, *txtMbrLogin, *txtDOB, *txtPWd, *txtCarRegnNo, *txtOccupation, *txtEmployer, *txtBillName, *txtNation,*txtLocation;
    NSString *currMode;
    UIButton *btnTakePhoto;
    int _nationid, _locationid;
    UISegmentedControl *scGender;
    CGPoint scrollOffset;
    UIInterfaceOrientation currOrientation;
    UITableView *entryTV;
    UIScrollView *_parentScroll;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    UIColor *lblTextColor;
    UIImageView *memberPhoto;
    NSData *dataObj;
    int lblPosition;
    NSUserDefaults *stdDefaults;
    NSString *MAIN_URL;
    METHODCALLBACK _photoNotifyMethod, _locationNotifyMethod, _emirateNotifyMethod, _nationNotifyMethod;
}

- (UITableViewCell*) getCellForFirstRowWithPicture;
- (UITableViewCell*) getCellFor3L2TforSection:(int) p_section andRow:(int) p_rowno;
- (UITableViewCell*) getCellFor2L2T1BRforSection:(int) p_section andRow:(int) p_rowno;
- (UITableViewCell*) getCellFor3L3TforSection:(int) p_section andRow:(int) p_rowno;
- (UITableViewCell*) getCellFor2L2TforSection:(int) p_section andRow:(int) p_rowno;
- (UITableViewCell*) getCellFor2L1T1SforSection:(int) p_section andRow:(int) p_rowno;
- (UITableViewCell*) getCellFor2L2T1BLforSection:(int) p_section andRow:(int) p_rowno;
- (UITableViewCell*) getCellFor3L3T1BforSection:(int) p_section andRow:(int) p_rowno;

- (id) initWithDictionary:(NSDictionary*) p_dict andFrame:(CGRect) p_frame andOrientation:(UIInterfaceOrientation) p_intOrientation forMode:(NSString*) p_forMode withScroll:(UIScrollView*) p_scrollView andPhotoNotifyMethod:(METHODCALLBACK) p_photoNotify andLocNotifyMethod:(METHODCALLBACK) p_locationNotify andEmirateCallback:(METHODCALLBACK) p_emirateCallback andNationNotify:(METHODCALLBACK) p_nationNotify;
- (IBAction)generateNewBarCode:(id)sender;
- (void) setCaseProper:(UITextField*) p_passField;
- (IBAction)getEmirates:(id)sender;
- (void) setEmirates:(NSDictionary*) p_passedDict;
- (IBAction)getNationality:(id)sender;
- (void) setNationality:(NSDictionary*) p_passedDict;
- (IBAction)grabPhoto:(id)sender;
- (NSString*) getImageString;
- (NSString *)htmlEntitycode:(NSString *)string;
- (void) setBarCode:(NSString*) p_barCode;
- (void) saveImagetoCache:(NSString*) p_newMemberId;
- (IBAction)getLocation:(id)sender;
- (void) setLocation:(NSDictionary*) p_passedDict;
- (void) newPhotoTaken:(NSDictionary*) photoInfo;

@end
