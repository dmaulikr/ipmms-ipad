//
//  memberPlanObjects.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 17/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "memberFunctions.h"
#import "defaults.h"

@interface memberPlanObjects : NSObject<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIAlertViewDelegate, memberFunctions>
{
    NSDictionary *_mbrDict;
    NSDictionary *_initDict;
    NSString *currMode;
    CGPoint scrollOffset;
    UITextField *txtEntryNo, *txtEntryDate, *txtStartDate, *txtEndDate, *txtTotAmt, *txtPlan, *txtBillCycle, *txtFirstDue, *txtNoOfInst;
    int _planId, _billCycleId, _noOfPlanMonths;
    double _totFeeAmt, _totPayAmt;
    UISegmentedControl *scIsRenewal;
    UIInterfaceOrientation currOrientation;
    UITableView *entryTV;
    UIScrollView *_parentScroll;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    UIColor *lblTextColor;
    NSUserDefaults *stdDefaults;
    NSMutableArray *planData;
    NSMutableArray *woFeeDetail;
    NSMutableArray *woPayDetail;
    NSNumberFormatter *frm;
    NSDateFormatter *nsdf;
    METHODCALLBACK _billcycleCallbacks, _planTypeCallbacks, _feeDataCallbacks, _payDataCallbacks;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode withMbrKeyDict:(NSDictionary*) p_keyDict andBillcycleCallbacks:(METHODCALLBACK) p_billcycleCallbacks andPlantypeCallbacks:(METHODCALLBACK) p_planTypeCallback andFeesDataCallback:(METHODCALLBACK) p_feeDataCallback andPayDataCallback:(METHODCALLBACK) p_payDataCallback;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) generateTableView;
- (void) displayDictDataForMode:(NSString*) p_dispmode;
- (void) getCellFor2L2TforCell:(UITableViewCell*) p_passCell;
- (UITableViewCell*) getFirstRowCell;
- (UITableViewCell*) getPlanCell;
- (UITableViewCell*) getBillCycleCell;
- (UITableViewCell*) getStDateEndDateCell;
- (UITableViewCell*) getRenewalAmtCell;
- (UITableViewCell*) getEmptyCell;
- (UITableViewCell*) getFeesDataCellforSection:(int) p_section andRow:(int) p_rowNo;
- (UITableViewCell*) getPayScheduleCellforSection:(int) p_section andRow:(int) p_rowNo;
- (UITableViewCell*) getPayScheduleCell;
- (void) setMemberPlan:(NSDictionary*) p_mbrPlanDict;
- (void) setBillCycle:(NSDictionary*) p_mbrBillCycle;
- (IBAction) displayCalendar:(id) sender;
- (UITableViewCell*) getHeaderCellForSection:(int) p_sectionNo;
- (void) addFeesDetail:(id) sender;
- (void) addUpdateFeesData:(NSDictionary*) p_feesInfo;
- (void) addUpdatePayScheduleData:(NSDictionary*) p_paySheduleInfo;
- (IBAction)editFeeDetailsButtonClicked:(id)sender;
- (IBAction)deleteFeeDetailsButtonClicked:(id)sender;
- (IBAction)editPayScheduleButtonClicked:(id)sender;
- (IBAction)deletePayScheduleButtonClicked:(id)sender;
- (void) setTotalFeesAmount;
- (void) generatePaymentSchedule : (id) sender;
- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg;
@end
