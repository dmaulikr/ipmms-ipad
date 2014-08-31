//
//  memTransObjects.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 26/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "memberFunctions.h"
#import "defaults.h"

@interface memTransObjects : NSObject<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIAlertViewDelegate, memberFunctions>
{
    NSDictionary *_mbrDict;
    NSDictionary *_initDict;
    NSString *currMode;
    CGPoint scrollOffset;
    UITextField *txtEntryNo, *txtEntryDate, /**txtTotPending,*/ *txtAmountPaid, *txtNotes, *txtChequeNo, *txtChequeDate, *txtBankName;
    int _bankId;
    UISegmentedControl *scPaymode;
    //double _totPendAmt, _totPaidAmt;
    int _totActualAmt, _totBalanceAmt, _totAdjustedAmt;
    UIInterfaceOrientation currOrientation;
    UITableView *entryTV;
    UIScrollView *_parentScroll;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    UIColor *lblTextColor;
    NSUserDefaults *stdDefaults;
    NSMutableArray *transData;
    NSMutableArray *woAdjDetail;
    NSMutableArray *woPendDetail;
    NSNumberFormatter *frm;
    NSDateFormatter *nsdf;
    METHODCALLBACK _bankCallbacks;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode withMbrKeyDict:(NSDictionary*) p_keyDict andBankCallbacks:(METHODCALLBACK) p_bankCallbacks;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) generateTableView;
- (UITableViewCell*) getEmptyCell;
- (IBAction) displayCalendar:(id) sender;
- (void) getCellFor2L2TforCell:(UITableViewCell*) p_passCell;
- (UITableViewCell*) getFirstRowCell;
- (UITableViewCell*) getCellPaymode;
- (UITableViewCell*) getTotalValuesCell;
//- (UITableViewCell*) getAmountCell;
- (UITableViewCell*) getChequeDataCell;
- (UITableViewCell*) getBankNameCell;
- (UITableViewCell*) getNotesCell;
- (UITableViewCell*) getHeaderCellForSection:(int) p_sectionNo;
- (UITableViewCell*) getAdjustmentCellforRow:(int) p_rowNo;

- (void) setBank:(NSDictionary*) p_bankInfo;
- (void) generateAdjustmentsEntry : (id) sender;
- (void) calculateTotalsWithFlag:(int) p_flag;

@end
