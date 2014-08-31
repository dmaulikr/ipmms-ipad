//
//  memNotesObjects.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "memberFunctions.h"
#import "defaults.h"

@interface memNotesObjects :NSObject <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UIAlertViewDelegate, memberFunctions>
{
    NSDictionary *_mbrDict;
    NSDictionary *_initDict;
    NSString *currMode;
    CGPoint scrollOffset;
    UITextField *txtNotesType, *txtEntryDate,*txtNotes, *txtStartDate, *txtEndDate, *txtNotesRefCode;
    int _notesType;
    UISegmentedControl *scSendToAll;
    UIInterfaceOrientation currOrientation;
    UITableView *entryTV;
    UIScrollView *_parentScroll;
    UIDatePicker *dobPicker;
    UIAlertView *dAlert;
    UIColor *lblTextColor;
    NSUserDefaults *stdDefaults;
    NSMutableArray *transData;
    NSNumberFormatter *frm;
    NSDateFormatter *nsdf;
    METHODCALLBACK _notesTypeNotificaiton;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode withMbrKeyDict:(NSDictionary*) p_keyDict andNotesTypeCallback:(METHODCALLBACK) p_notesTypeCallback;
- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation;
- (void) generateTableView;
- (UITableViewCell*) getEmptyCell;
- (IBAction) displayCalendar:(id) sender;
- (void) getCellFor2L2TforCell:(UITableViewCell*) p_passCell;
- (UITableViewCell*) getFirstRowCell;
- (UITableViewCell*) getCellSendAllNotesCode;
- (UITableViewCell*) getNotesCell;
- (UITableViewCell*) getStDateEndDateCell;
- (void) setNotesType:(NSDictionary*) p_bankInfo;

@end
