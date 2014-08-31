//
//  memberRefundObjects.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberRefundObjects.h"

@implementation memberRefundObjects

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode withMbrKeyDict:(NSDictionary*) p_keyDict andContractCallback:(METHODCALLBACK) p_contractCallback
{
    self = [super init];
    if (p_dictData) 
        _initDict = [[NSDictionary alloc] initWithDictionary:p_dictData copyItems:YES];
    else
        _initDict = nil;
    currOrientation = p_intOrientation;
    _mbrDict = [NSDictionary dictionaryWithDictionary:p_keyDict];
    _parentScroll = p_scrollview;
    currMode = [[NSString alloc] initWithFormat:@"%@", p_dictData];
    _contractCallback = p_contractCallback;
    [self initializeVariables];
    [self generateTableView];
    return  self;
}

- (void) releaseViewObjects
{
    [entryTV removeFromSuperview];
    entryTV = nil;
}

- (void) initializeVariables
{
    stdDefaults = [NSUserDefaults standardUserDefaults];
    frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
    [frm setCurrencySymbol:@""];
    [frm setMaximumFractionDigits:2];
    nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"dd-MMM-yyyy"];
    lblTextColor = [UIColor whiteColor];
}

- (void) setInsertMode
{
    currMode = [[NSString alloc] initWithFormat:@"%@",@"I"];
    [self clearScreen];
    [self setFieldsEntryStatus:YES];
    
    if (txtRefundDate)
        txtRefundDate.text = [nsdf stringFromDate:[NSDate date]];
    
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currMode = @"L";
    if (p_dictData) 
    {
        NSArray *mdpArray = [[NSArray alloc] initWithArray:[p_dictData valueForKey:@"data"] copyItems:YES];
        _initDict = [[NSDictionary alloc] initWithDictionary:[mdpArray objectAtIndex:0] copyItems:YES];
        [entryTV reloadData];
        [self displayDictDataForMode:currMode];
    }
    else
        _initDict = nil;
    [self setFieldsEntryStatus:NO];
}

- (void) setEditMode
{
    currMode = @"U";
    //[self generateTableView];
    [entryTV reloadData];
    [self setFieldsEntryStatus:YES];
}

- (void) setKeyDictionary:(NSDictionary *)p_keyDict
{
    _mbrDict = [NSDictionary dictionaryWithDictionary:p_keyDict];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    currMode = @"L";
    [self setFieldsEntryStatus:YES];
}

- (void) setValueforText:(UITextField*) p_passField andField:(NSString*) p_fieldName
{
    if (p_passField) 
        if ([_initDict valueForKey:p_fieldName]) 
            p_passField.text = [_initDict valueForKey:p_fieldName];
        else
            p_passField.text = @"";
    
    if ([p_fieldName isEqualToString:@"PLANDESC"]) 
        _memberPlanId = [[_initDict valueForKey:@"MEMBERPLANID"] intValue];
    
}

-(NSString *)htmlEntitycode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return string;
}

- (void) displayDictDataForMode:(NSString*) p_dispmode
{
    //NSLog(@"the received dict info %@", _initDict);
    [self setValueforText:txtRefundNo andField:@"REFUNDNO"];
    [self setValueforText:txtRefundDate andField:@"REFUNDDATE"];
    [self setValueforText:txtMemberPlan andField:@"PLANDESC"];
    [self setValueforText:txtStartDate andField:@"EFFECTIVEDATE"];
    [self setValueforText:txtEndDate andField:@"ENDDATE"];
    [self setValueforText:txtNotes andField:@"NOTES"];
    [self setValueforText:txtTerminationDate andField:@"TERMINATIONDATE"];
    [self setValueforText:txtContractAmt andField:@"CONTRACTAMOUNT"];
    [self setValueforText:txtRecdAmount andField:@"RECEIVEDAMOUNT"];
    [self setValueforText:txtRefundAmount andField:@"REFUNDAMOUNT"];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    currOrientation = p_forOrientation;
    if (UIInterfaceOrientationIsPortrait(currOrientation)) 
    {
        [entryTV setFrame:CGRectMake(0, 50, 703, 930)];
    }
    else
    {
        [entryTV setFrame:CGRectMake(0, 20, 703, 630)];
    }
}

- (void) generateTableView
{
    if (!entryTV) 
    {
        CGRect tvrect;
        if (UIInterfaceOrientationIsPortrait(currOrientation)) 
            tvrect = CGRectMake(0, 50, 703, 930);
        else
            tvrect = CGRectMake(0, 20, 703, 630);
        entryTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStylePlain];
        [entryTV setDelegate:self];
        [entryTV setDataSource:self];
        [entryTV setBackgroundView:nil];
        [entryTV setBackgroundView:[[UIView alloc] init]] ;
        [entryTV setBackgroundColor:[_parentScroll backgroundColor]];
        [entryTV setSeparatorColor:[entryTV backgroundColor]];
        [_parentScroll addSubview:entryTV];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int l_rowheight =0;
    l_rowheight = 45;
    return  l_rowheight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) 
    {
        case 0:
            switch (indexPath.row) 
        {
            case 0:
                return [self getFirstRowCell];
                break;
            case 1:
                return [self getContractCell];
                break;
            case 2:
                return [self getStDateEndDateCell];
                break;
            case 3:
                return [self getTermDateAndContAmtCell];
                break;
            case 4:
                return [self getNotesCell];
                break;
            case 5:
                return [self getRecdAmountRefAmountCell];
                break;
            default:
                break;
        }
            break;
        default:
            return [self getEmptyCell];
            break;
    }
    return nil;
}

- (UITableViewCell*) getContractCell
{
    BOOL assignValues = NO;
    UIButton *btnPlanSelect; //, *btnBillCycleSelect;
    UILabel *lbl1;
    UITextField *txt1;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    static NSString *cellid=@"cellSecond";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        
        UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor=[entryTV backgroundColor];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lblWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, 2*txtWidth+lblWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Plan"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtMemberPlan)
    {
        txtMemberPlan = (UITextField*) [cell.contentView viewWithTag:2];
        txtMemberPlan.delegate = self;
    }
    btnPlanSelect =(UIButton*) [cell.contentView viewWithTag:5];
    if (!btnPlanSelect) 
    {
        btnPlanSelect = [[UIButton alloc] initWithFrame:CGRectMake(txtMemberPlan.frame.origin.x+txtMemberPlan.frame.size.width-25, 5, 25, txtMemberPlan.frame.size.height)];
        btnPlanSelect.titleLabel.text=@"";
        [btnPlanSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnPlanSelect addTarget:self action:@selector(getMemberContractInfo:) forControlEvents:UIControlEventTouchDown];
        btnPlanSelect.tag = 5;
        [cell.contentView addSubview:btnPlanSelect]; 
        [txtMemberPlan setFrame:CGRectMake(txtMemberPlan.frame.origin.x, txtMemberPlan.frame.origin.y, txtMemberPlan.frame.size.width -25, txtMemberPlan.frame.size.height)];
        btnPlanSelect.hidden = NO;
    }
    txtMemberPlan.enabled = NO;
    if (assignValues) 
        [self setValueforText:txtMemberPlan andField:@"PLANDESC"];
    return cell;
}

- (void) getMemberContractInfo:(id) sender
{
    //NSLog(@"the currne tmode is %@", currMode);
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"SelectContract"] forKey:@"notify"];
        _contractCallback(returnInfo);
    }    
}


- (UITableViewCell*) getRecdAmountRefAmountCell
{
    static NSString *cellid=@"cellRecdRefAmt";
    BOOL assignValues = NO;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        [self getCellFor2L2TforCell:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        UILabel *lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Recd. Amount"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Ref. amount"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtRecdAmount)
    {
        txtRecdAmount = (UITextField*) [cell.contentView viewWithTag:2];
        txtRecdAmount.delegate = self;
    }
    if (!txtRefundAmount)
    {
        txtRefundAmount = (UITextField*) [cell.contentView viewWithTag:4];
        txtRefundAmount.delegate = self;
        [txtRefundAmount setKeyboardType:UIKeyboardTypeNumberPad];
    }
    if (assignValues) 
    {
        [self setValueforText:txtRecdAmount andField:@"RECEIVEDAMOUNT"];
        [self setValueforText:txtRefundAmount andField:@"REFUNDAMOUNT"];
    }
    txtRecdAmount.enabled = NO;
    if ([currMode isEqualToString:@"L"])
        txtRefundAmount.enabled = NO;
    else
        txtRefundAmount.enabled = YES;
    //txtRefundAmount.enabled = NO;
    return cell;
}


- (UITableViewCell*) getTermDateAndContAmtCell
{
    static NSString *cellid=@"cellTermDateAmt";
    BOOL assignValues = NO;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        [self getCellFor2L2TforCell:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        UILabel *lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Termination Date"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Contract Amount"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtTerminationDate)
    {
        txtTerminationDate = (UITextField*) [cell.contentView viewWithTag:2];
        txtTerminationDate.delegate = self;
    }
    if (!txtContractAmt)
    {
        txtContractAmt = (UITextField*) [cell.contentView viewWithTag:4];
        txtContractAmt.delegate = self;
    }
    if (assignValues) 
    {
        [self setValueforText:txtTerminationDate andField:@"TERMINATIONDATE"];
        [self setValueforText:txtContractAmt andField:@"TOTALAMOUNT"];
    }
    txtTerminationDate.enabled = NO;
    txtContractAmt.enabled = NO;
    return cell;
}

- (UITableViewCell*) getStDateEndDateCell
{
    static NSString *cellid=@"cellStEndDate";
    BOOL assignValues = NO;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        [self getCellFor2L2TforCell:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        UILabel *lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Start Date"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"End Date"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtStartDate)
    {
        txtStartDate = (UITextField*) [cell.contentView viewWithTag:2];
        txtStartDate.delegate = self;
    }
    if (!txtEndDate)
    {
        txtEndDate = (UITextField*) [cell.contentView viewWithTag:4];
        txtEndDate.delegate = self;
    }
    if (assignValues) 
    {
        [self setValueforText:txtStartDate andField:@"EFFECTIVEDATE"];
        [self setValueforText:txtEndDate andField:@"ENDDATE"];
    }
    txtStartDate.enabled = NO;
    txtEndDate.enabled = NO;
    return cell;
}


- (UITableViewCell*) getNotesCell
{
    BOOL assignValues = NO;
    UILabel *lbl1;
    UITextField *txt1;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    static NSString *cellid=@"cellNotes";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        
        UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor=[entryTV backgroundColor];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lblWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, 2*txtWidth+lblWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Notes"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtNotes)
    {
        txtNotes = (UITextField*) [cell.contentView viewWithTag:2];
        txtNotes.delegate = self;
    }
    if ([currMode isEqualToString:@"L"])
        txtNotes.enabled = NO;
    else
        txtNotes.enabled = YES;
    if (assignValues) 
        [self setValueforText:txtNotes andField:@"NOTES"];
    return cell;
}


- (UITableViewCell*) getFirstRowCell
{
    BOOL assignValues = NO;
    static NSString *cellid=@"cellFirst";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        [self getCellFor2L2TforCell:cell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        UILabel *lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Entry No"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Entry Date"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtRefundNo)
    {
        txtRefundNo = (UITextField*) [cell.contentView viewWithTag:2];
        txtRefundNo.placeholder = @"(Auto)";
        txtRefundNo.delegate = self;
    }
    if (!txtRefundDate)
    {
        txtRefundDate = (UITextField*) [cell.contentView viewWithTag:4];
        txtRefundDate.delegate = self;
        if ([currMode isEqualToString:@"I"]) 
            txtRefundDate.text = [nsdf stringFromDate:[NSDate date]];
    }
    if (assignValues) 
    {
        [self setValueforText:txtRefundNo andField:@"ENTRYNO"];
        if ([currMode isEqualToString:@"I"]) 
            txtRefundDate.text = [nsdf stringFromDate:[NSDate date]];
        else
            [self setValueforText:txtRefundDate andField:@"ENTRYDATE"];
    }
    txtRefundNo.enabled = NO;
    txtRefundDate.enabled = NO;
    return cell;
}


- (void) getCellFor2L2TforCell:(UITableViewCell*) p_passCell
{
    UILabel *lbl1, *lbl2;
    UITextField *txt1, *txt2;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    p_passCell.backgroundColor=[entryTV backgroundColor];
    
    lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lblWidth, cellHeight-1)];
    lbl1.font = txtfont;
    lbl1.textAlignment = UITextAlignmentRight;
    lbl1.tag = 1;
    lbl1.backgroundColor = [entryTV backgroundColor];
    lbl1.textColor = lblTextColor;
    [p_passCell.contentView addSubview:lbl1];
    
    txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, txtWidth, cellHeight-5)];
    txt1.font = txtfont;
    txt1.textAlignment = UITextAlignmentLeft;
    txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt1.tag = 2;
    txt1.backgroundColor = lblTextColor;
    txt1.borderStyle = UITextBorderStyleRoundedRect;
    [p_passCell.contentView addSubview:txt1];
    
    lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+txtWidth, 0,lblWidth , cellHeight-1)];
    lbl2.font = txtfont;
    lbl2.tag = 3;
    lbl2.textAlignment = UITextAlignmentRight;
    lbl2.backgroundColor = [entryTV backgroundColor];
    lbl2.textColor = lblTextColor;
    [p_passCell.contentView addSubview:lbl2];
    
    
    txt2 = [[UITextField alloc] initWithFrame:CGRectMake(2*lblWidth+txtWidth, 5, txtWidth, cellHeight-5)];
    txt2.font = txtfont;
    txt2.tag = 4;
    txt2.textAlignment = UITextAlignmentLeft;
    txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    txt2.backgroundColor = lblTextColor;
    txt2.borderStyle = UITextBorderStyleRoundedRect;
    [p_passCell.contentView addSubview:txt2];
    //return p_passCell;
}

- (UITableViewCell*) getEmptyCell
{
    static NSString *cellid=@"cellEmpty";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (IBAction) displayCalendar:(id) sender
{
    //UIButton *btnSelected = (UIButton*) sender;
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        /*dobPicker = [[UIDatePicker alloc] init];
        dobPicker.frame=CGRectMake(20, 25.0, 240.0, 150.0);
        dobPicker.datePickerMode = UIDatePickerModeDate;
        
        [dobPicker setDate:[NSDate date]];
        
        dAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select", nil];
        dAlert.cancelButtonIndex = 0;
        dAlert.delegate = self;
        dAlert.tag = btnSelected.tag;
        [dAlert addSubview:dobPicker];*/
        [dAlert show];
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex!=0) 
    {
        /*NSDate *date = [dobPicker date];
        switch (alertView.tag) {
            case 5:
                txtStartDate.text = [nsdf stringFromDate:date];
                break;
            case 6:
                txtEndDate.text = [nsdf stringFromDate:date];
                break;
            default:
                break;
        }*/
    }
}


- (void) setFieldsEntryStatus:(BOOL) p_Status
{
    if (txtNotes) txtNotes.enabled = p_Status;
    if (txtRefundAmount) txtRefundAmount.enabled = p_Status;
}

- (void) clearScreen
{
    txtRefundNo.text = @"";
    txtRefundDate.text = @"";
    txtMemberPlan.text = @"";
    txtStartDate.text = @"";
    txtEndDate.text = @"";
    txtNotes.text = @"";
    txtTerminationDate.text = @"";
    txtContractAmt.text = @"";
    txtRecdAmount.text = @"";
    txtRefundAmount.text = @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:txtNotes])
        [txtNotes resignFirstResponder];
    else if ([textField isEqual:txtRefundAmount])
        [txtRefundAmount resignFirstResponder];
    else
        [textField resignFirstResponder];
    return NO;
}

- (BOOL) validateEntries
{
    BOOL l_resultVal;
    
    l_resultVal = [self emptyCheckResult:txtMemberPlan andMessage:@"Valid terminated plan should be selected"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtNotes andMessage:@"Notes should be entered"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtRefundAmount andMessage:@"Refund amount is not valid"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        if ([txtRefundAmount.text doubleValue]<=0) 
        {
            l_resultVal = NO;
            [self showAlertMessage:@"Refund amount is not valid"];
        }
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
    {
        if ([txtRefundAmount.text doubleValue]>[txtRecdAmount.text doubleValue]) 
        {
            l_resultVal = NO;
            [self showAlertMessage:@"Refund exceeds Received amount"];
        }
    }
    
    return l_resultVal;
    
}

- (BOOL) emptyCheckResult:(UITextField*) p_passField andMessage:(NSString*) p_errMsg
{
    if (p_passField) 
    {
        if ([p_passField.text isEqualToString:@""]) 
        {
            [self showAlertMessage:p_errMsg];
            return  NO;
        }
    }
    else
    {
        [self showAlertMessage:p_errMsg];
        return  NO;
    }
    return YES;
}

- (NSString*) getXMLDataForSave
{
    /*
     
     
#define MEMBERREFUND_XML @"<REFUNDDATA><REFUNDID>%@</REFUNDID><REFUNDNO>%@</REFUNDNO><REFUNDDATE>%@</REFUNDDATE><MEMBERPLANID>%d</MEMBERPLANID><NOTES>%@</NOTES><CONTRACTAMOUNT>%@</CONTRACTAMOUNT><RECEIVEDAMOUNT>%@</RECEIVEDAMOUNT><REFUNDAMOUNT>%@</REFUNDAMOUNT></REFUNDDATA>"
     */
    //NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    if ([currMode isEqualToString:@"I"]) 
    {
        l_retXML = [NSString stringWithFormat:MEMBERREFUND_XML, @"0", txtRefundNo.text , txtRefundDate.text, _memberPlanId,txtNotes.text, txtContractAmt.text, txtRecdAmount.text, txtRefundAmount.text];
    }
    if ([currMode isEqualToString:@"U"]) 
    {
        l_retXML = [NSString stringWithFormat:MEMBERREFUND_XML, [_initDict valueForKey:@"REFUNDID"] , txtRefundNo.text , txtRefundDate.text, _memberPlanId,txtNotes.text, txtContractAmt.text, txtRecdAmount.text, txtRefundAmount.text];
    }
    //l_retXML = [NSString stringWithFormat:@"%@",l_retXML, @"</TRANSDATA>"];
    //NSLog(@"edit saving info %@",l_retXML);
    l_retXML = (NSMutableString*) [self htmlEntitycode:l_retXML];
    return l_retXML;
}

- (void) setContractInfo:(NSDictionary*) contInfo
{
    NSDictionary *recdData = [contInfo valueForKey:@"data"];
    if (txtMemberPlan) 
    {
        txtMemberPlan.text = [recdData valueForKey:@"PLANDESC"];
        _memberPlanId = [[recdData valueForKey:@"MEMBERPLANID"] intValue];
    }        
    
    if (txtStartDate) 
        txtStartDate.text = [recdData valueForKey:@"STARTDATE"];
    
    if (txtEndDate) 
        txtEndDate.text = [recdData valueForKey:@"ENDDATE"];

    if (txtTerminationDate) 
        txtTerminationDate.text = [recdData valueForKey:@"TERMINATIONDATE"];

    if (txtContractAmt) 
        txtContractAmt.text = [recdData valueForKey:@"TOTALAMOUNT"];
    
    if (txtRecdAmount) 
        txtRecdAmount.text = [recdData valueForKey:@"RECEIVEDAMOUNT"];

    /*planDesc = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"PLANDESC"]];
    period = [[NSString alloc] initWithFormat:@"%@\n%@", [tmpDict valueForKey:@"STARTDATE"],[tmpDict valueForKey:@"ENDDATE"]];
    termDate = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"TERMINATIONDATE"]];
    
    recdAmount = [[NSString alloc] initWithFormat:@" %@", [tmpDict valueForKey:@"RECEIVEDAMOUNT"]];
    totAmount = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"TOTALAMOUNT"]];
     */
}


@end
