//
//  memberRefundObjects.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "memberFunctions.h"
#import "defaults.h"

@interface memberRefundObjects : NSObject <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIAlertViewDelegate, memberFunctions>
{
    NSDictionary *_mbrDict;
    NSDictionary *_initDict;
    NSString *currMode;
    CGPoint scrollOffset;
    UITextField *txtRefundNo, *txtRefundDate, *txtMemberPlan, *txtStartDate, *txtEndDate, *txtTerminationDate, *txtNotes, *txtContractAmt, *txtRecdAmount, *txtRefundAmount;
    int _memberPlanId;
    UIInterfaceOrientation currOrientation;
    UITableView *entryTV;
    UIScrollView *_parentScroll;
    UIAlertView *dAlert;
    UIColor *lblTextColor;
    NSUserDefaults *stdDefaults;
    NSMutableArray *transData;
    NSNumberFormatter *frm;
    NSDateFormatter *nsdf;
    METHODCALLBACK _contractCallback;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode withMbrKeyDict:(NSDictionary*) p_keyDict andContractCallback:(METHODCALLBACK) p_contractCallback;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) generateTableView;
- (UITableViewCell*) getEmptyCell;
- (IBAction) displayCalendar:(id) sender;
- (void) getCellFor2L2TforCell:(UITableViewCell*) p_passCell;
- (UITableViewCell*) getFirstRowCell;
- (UITableViewCell*) getStDateEndDateCell;
- (UITableViewCell*) getNotesCell;
- (UITableViewCell*) getContractCell;
- (UITableViewCell*) getTermDateAndContAmtCell;
- (UITableViewCell*) getRecdAmountRefAmountCell;
- (void) setContractInfo:(NSDictionary*) contInfo;

@end
