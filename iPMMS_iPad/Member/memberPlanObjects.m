//
//  memberPlanObjects.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 17/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberPlanObjects.h"

@implementation memberPlanObjects

static bool shouldScroll = true;

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode withMbrKeyDict:(NSDictionary*) p_keyDict andBillcycleCallbacks:(METHODCALLBACK) p_billcycleCallbacks andPlantypeCallbacks:(METHODCALLBACK) p_planTypeCallback andFeesDataCallback:(METHODCALLBACK) p_feeDataCallback andPayDataCallback:(METHODCALLBACK) p_payDataCallback
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
    _billcycleCallbacks = p_billcycleCallbacks;
    _planTypeCallbacks = p_planTypeCallback;
    _feeDataCallbacks = p_feeDataCallback;
    _payDataCallbacks = p_payDataCallback;
    woFeeDetail = [[NSMutableArray alloc] init];
    woPayDetail = [[NSMutableArray alloc] init];
    lblTextColor = [UIColor whiteColor];
    [self initializeVariables];
    stdDefaults = [NSUserDefaults standardUserDefaults];
    frm = [[NSNumberFormatter alloc] init];
    [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
    [frm setCurrencySymbol:@""];
    [frm setMaximumFractionDigits:2];
    _totFeeAmt = 0;_totPayAmt =0;
    nsdf = [[NSDateFormatter alloc] init];
    [nsdf setDateFormat:@"dd-MMM-yyyy"];
    [self generateTableView];
    return  self;
}

- (void) releaseViewObjects
{
    [entryTV removeFromSuperview];
    entryTV = nil;
}

- (void) setKeyDictionary:(NSDictionary *)p_keyDict
{
    _mbrDict = [NSDictionary dictionaryWithDictionary:p_keyDict];
}

- (void) setInsertMode
{
    currMode = [[NSString alloc] initWithFormat:@"%@",@"I"];
    [self clearScreen];
    [self setFieldsEntryStatus:YES];
    _initDict = nil;
    [woFeeDetail removeAllObjects];
    [woPayDetail removeAllObjects];
    if (txtEntryNo) 
        txtEntryNo.text = @"";

    if (txtEntryDate)
        txtEntryDate.text = [nsdf stringFromDate:[NSDate date]];
    [entryTV reloadData];
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currMode = @"L";
    //NSLog(@"received dict info %@", p_dictData);
    if (p_dictData) 
    {
        NSArray *mdpArray = [[NSArray alloc] initWithArray:[p_dictData valueForKey:@"data"] copyItems:YES];
        _initDict = [[NSDictionary alloc] initWithDictionary:[mdpArray objectAtIndex:0] copyItems:YES];
        [woFeeDetail removeAllObjects];
        [woPayDetail removeAllObjects];
        for (NSDictionary *tmpDict in mdpArray) 
        {
            int mdpDatatype = [[tmpDict valueForKey:@"DATATYPE"] intValue];
            switch (mdpDatatype) 
            {
                case 2:
                    [woFeeDetail addObject:tmpDict];
                    break;
                case 3:
                    [woPayDetail addObject:tmpDict];
                    break;
                default:
                    break;
            }
        }
        [self displayDictDataForMode:currMode];
        [entryTV reloadData];
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
    
    if ([p_fieldName isEqualToString:@"CYCLENAME"]) 
        _billCycleId = [[_initDict valueForKey:@"BILLCYCLEID"] intValue];
    
    if ([p_fieldName isEqualToString:@"PLANDESC"]) 
    {
        _planId = [[_initDict valueForKey:@"PLANID"] intValue];
        _noOfPlanMonths = [[_initDict valueForKey:@"NOOFMONTHS"] intValue];
    }
    
    if ([p_fieldName isEqualToString:@"TOTALAMOUNT"]) 
    {
        _totFeeAmt = [[_initDict valueForKey:@"TOTALAMOUNT"] doubleValue];
        _totPayAmt = [[_initDict valueForKey:@"TOTALAMOUNT"] doubleValue];
    }
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
    [self setValueforText:txtEntryNo andField:@"ENTRYNO"];
    [self setValueforText:txtEntryDate andField:@"ENTRYDATE"];
    [self setValueforText:txtBillCycle andField:@"CYCLENAME"];
    [self setValueforText:txtFirstDue andField:@"FIRSTDUEDATE"];
    [self setValueforText:txtNoOfInst andField:@"INSTALLMENTS"];
    if (_initDict)
        if ([_initDict valueForKey:@"ISRENEWAL"]) 
            scIsRenewal.selectedSegmentIndex = [[_initDict valueForKey:@"ISRENEWAL"] intValue];
    [self setValueforText:txtTotAmt andField:@"TOTALAMOUNT"];
    [self setValueforText:txtStartDate andField:@"EFFECTIVEDATE"];
    [self setValueforText:txtEndDate andField:@"ENDDATE"];
    [self setValueforText:txtPlan andField:@"PLANDESC"];

}

- (void) initializeVariables
{
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
    //[self generateTableView];
}

- (void) generateTableView
{
    //return;
    /*if (entryTV) {
        //[self storeDispValues];
        [entryTV removeFromSuperview];
    }*/
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
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noofRows =1;
    switch (section) {
        case 0:
            noofRows = 7;
            break;
        case 1:
            noofRows = [woFeeDetail count] +2;
            break;
        case 2:
            noofRows = [woPayDetail count] +2;
            break;
        default:
            break;
    }
    return noofRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int l_rowheight =0;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) 
            {
                case 6:
                    l_rowheight = 20;
                    break;
                default:
                    l_rowheight = 45;
                    break;
            }
            break;
        case 1:
            l_rowheight = 45;
            if (indexPath.row==[woFeeDetail count]+1) 
                l_rowheight = 30;
            break;
        case 2:
            l_rowheight = 45;
            if (indexPath.row==[woPayDetail count]+1) 
                l_rowheight = 30;
            break;
        default:
            break;
    }
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
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) 
            {
                case 0:
                    return [self getFirstRowCell];
                    break;
                case 1:
                    return [self getPlanCell];
                    break;
                case 2: 
                    return [self getBillCycleCell];
                    break;
                case 3:
                    return [self getStDateEndDateCell];
                    break;
                case 4:
                    return [self getRenewalAmtCell];
                    break;
                case 5:
                    return [self getPayScheduleCell];
                    break;
                default:
                    return [self getEmptyCell];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) 
            {
                case 0:
                    return [self getHeaderCellForSection:1];
                    break;
                default:
                    if (indexPath.row==[woFeeDetail count]+1) 
                        return [self getEmptyCell];
                    else
                        return [self getFeesDataCellforSection:indexPath.section andRow:indexPath.row];
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) 
            {
                case 0:
                    return [self getHeaderCellForSection:2];
                    break;
                default:
                    if (indexPath.row==[woPayDetail count]+1) 
                        return [self getEmptyCell];
                    else
                        return [self getPayScheduleCellforSection:indexPath.section andRow:indexPath.row];
                    break;
            }
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell*) getPayScheduleCellforSection:(int) p_section andRow:(int) p_rowNo
{
    static NSString *cellid=@"CellforPay";
    UIButton *btnedit, *btndelete;
    UILabel *lbl1, *lbl2, *lbl3;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth = 232; cellHeight = 45;
    NSDictionary *tmpDict;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    tmpDict = [woPayDetail objectAtIndex:p_rowNo-1];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor = [UIColor clearColor];
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth/2, 0, lblWidth/2-1, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl1];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth, 0, 2*txtWidth-90-1, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentLeft;
        lbl2.tag = 2;
        lbl2.backgroundColor = [UIColor whiteColor];
        lbl2.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl2];
        
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+2*txtWidth-90, 0, lblWidth-1-45+40, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentRight;
        lbl3.tag = 3;
        lbl3.backgroundColor = [UIColor whiteColor];
        lbl3.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl3];
        
        btnedit = [[UIButton alloc] initWithFrame:CGRectMake(lblWidth+2*txtWidth-90+lblWidth-1-45+40, 0, 45, 45)];
        btnedit.titleLabel.text=@"";
        btnedit.titleLabel.textColor = btnedit.titleLabel.backgroundColor;
        btnedit.tag = 4;
        [btnedit setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnedit addTarget:self action:@selector(editPayScheduleButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnedit];
        
        btndelete = [[UIButton alloc] initWithFrame:CGRectMake(lblWidth+2*txtWidth-90+lblWidth-1-45+40+45, 0, 45, 45)];
        btndelete.titleLabel.text=@"";
        btndelete.titleLabel.textColor = btndelete.titleLabel.backgroundColor;
        btndelete.tag = 5;
        [btndelete setImage:[UIImage imageNamed:@"deleteicon.JPG"] forState:UIControlStateNormal];
        [btndelete addTarget:self action:@selector(deletePayScheduleButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btndelete];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl2 = (UILabel*) [cell.contentView viewWithTag:2];
    lbl3 = (UILabel*) [cell.contentView viewWithTag:3];
    btnedit = (UIButton*) [cell.contentView viewWithTag:4];
    btndelete = (UIButton*) [cell.contentView viewWithTag:5];
    lbl1.text = [[NSString stringWithFormat:@"%d ", p_rowNo] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lbl2.text = [[NSString stringWithFormat:@"  %@", [tmpDict valueForKey:@"ONDATE"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    double totamount  =[[tmpDict valueForKey:@"PAYAMOUNT"] doubleValue];
    lbl3.text = [[[NSString alloc]initWithFormat:@" %@   ",[frm stringFromNumber:[NSNumber numberWithDouble:totamount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    btnedit.titleLabel.text = [NSString stringWithFormat:@"%d", p_rowNo-1];
    btndelete.titleLabel.text = [NSString stringWithFormat:@"%d", p_rowNo-1];
    return cell;
}


- (UITableViewCell*) getFeesDataCellforSection:(int) p_section andRow:(int) p_rowNo
{
    static NSString *cellid=@"CellforFee";
    UIButton *btnedit, *btndelete;
    UILabel *lbl1, *lbl2, *lbl3;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth = 232; cellHeight = 45;
    NSDictionary *tmpDict;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    tmpDict = [woFeeDetail objectAtIndex:p_rowNo-1];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor = [UIColor clearColor];
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth/2, 0, lblWidth/2-1, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl1];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth, 0, 2*txtWidth-90-1, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentLeft;
        lbl2.tag = 2;
        lbl2.backgroundColor = [UIColor whiteColor];
        lbl2.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl2];
        
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+2*txtWidth-90, 0, lblWidth-1-45+40, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentRight;
        lbl3.tag = 3;
        lbl3.backgroundColor = [UIColor whiteColor];
        lbl3.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl3];
        
        btnedit = [[UIButton alloc] initWithFrame:CGRectMake(lblWidth+2*txtWidth-90+lblWidth-1-45+40, 0, 45, 45)];
        btnedit.titleLabel.text=@"";
        btnedit.titleLabel.textColor = btnedit.titleLabel.backgroundColor;
        btnedit.tag = 4;
        [btnedit setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnedit addTarget:self action:@selector(editFeeDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnedit];
        
        btndelete = [[UIButton alloc] initWithFrame:CGRectMake(lblWidth+2*txtWidth-90+lblWidth-1-45+40+45, 0, 45, 45)];
        btndelete.titleLabel.text=@"";
        btndelete.titleLabel.textColor = btndelete.titleLabel.backgroundColor;
        btndelete.tag = 5;
        [btndelete setImage:[UIImage imageNamed:@"deleteicon.JPG"] forState:UIControlStateNormal];
        [btndelete addTarget:self action:@selector(deleteFeeDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btndelete];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl2 = (UILabel*) [cell.contentView viewWithTag:2];
    lbl3 = (UILabel*) [cell.contentView viewWithTag:3];
    btnedit = (UIButton*) [cell.contentView viewWithTag:4];
    btndelete = (UIButton*) [cell.contentView viewWithTag:5];
    lbl1.text = [[NSString stringWithFormat:@"%d ", p_rowNo] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    lbl2.text = [[NSString stringWithFormat:@"  %@", [tmpDict valueForKey:@"FEENAME"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    double totamount  =[[tmpDict valueForKey:@"FEEAMOUNT"] doubleValue];
    lbl3.text = [[[NSString alloc]initWithFormat:@" %@   ",[frm stringFromNumber:[NSNumber numberWithDouble:totamount]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    btnedit.titleLabel.text = [NSString stringWithFormat:@"%d", p_rowNo-1];
    btndelete.titleLabel.text = [NSString stringWithFormat:@"%d", p_rowNo-1];
    return cell;
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

- (UITableViewCell*) getPayScheduleCell
{
    static NSString *cellid=@"cellPaySchedule";
    BOOL assignValues = NO;
    UIButton *btnSelFDDate;
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
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"First Due"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Installment Nos."] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtFirstDue)
    {
        txtFirstDue = (UITextField*) [cell.contentView viewWithTag:2];
        txtFirstDue.delegate = self;
    }
    if (!txtNoOfInst)
    {
        txtNoOfInst = (UITextField*) [cell.contentView viewWithTag:4];
        txtNoOfInst.delegate = self;
        [txtNoOfInst setKeyboardType:UIKeyboardTypeNumberPad];
        txtNoOfInst.enabled = NO;
    }
    btnSelFDDate =(UIButton*) [cell.contentView viewWithTag:7];
    if (!btnSelFDDate) 
    {
        btnSelFDDate = [[UIButton alloc] initWithFrame:CGRectMake(txtFirstDue.frame.origin.x+txtFirstDue.frame.size.width-25, 5, 25, txtFirstDue.frame.size.height)];
        btnSelFDDate.titleLabel.text=@"";
        [btnSelFDDate setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnSelFDDate addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        btnSelFDDate.tag = 7;
        [cell.contentView addSubview:btnSelFDDate]; 
        [txtFirstDue setFrame:CGRectMake(txtFirstDue.frame.origin.x, txtFirstDue.frame.origin.y, txtFirstDue.frame.size.width -25, txtFirstDue.frame.size.height)];
    }
    if (assignValues) 
    {
        [self setValueforText:txtFirstDue andField:@"FIRSTDUEDATE"];
        [self setValueforText:txtNoOfInst andField:@"INSTALLMENTS"];
    }
    if ([currMode isEqualToString:@"L"]==NO) 
        txtNoOfInst.enabled = YES;
    
    txtFirstDue.enabled = NO;
    return cell;
}

- (UITableViewCell*) getHeaderCellForSection:(int) p_sectionNo
{
    static NSString *cellid=@"cellHeader";
    UIButton *btnAdd;
    UILabel *lbl1, *lbl2, *lbl3, *lbl4;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth = 232; cellHeight = 45;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont boldSystemFontOfSize:16.0f];
        //cell.backgroundColor=[entryTV backgroundColor];
        cell.backgroundColor = [UIColor clearColor];
        /*cell.textLabel.text = [NSString stringWithFormat:@"  %@",@"        Sl#                          Fees / Services Name                                        Amount "];
        cell.textLabel.font = txtfont;*/
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth/2, 0, lblWidth/2-1, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentCenter;
        lbl1.tag = 1;
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.textColor = [UIColor blackColor];
        lbl1.text = @"Sl#";
        [cell.contentView addSubview:lbl1];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth, 0, 2*txtWidth-90-1, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentCenter;
        lbl2.tag = 2;
        lbl2.backgroundColor = [UIColor whiteColor];
        lbl2.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl2];

        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+2*txtWidth-90, 0, lblWidth-1-45+40, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentCenter;
        lbl3.tag = 3;
        lbl3.backgroundColor = [UIColor whiteColor];
        lbl3.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl3];
        
        lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+2*txtWidth-90+lblWidth-1-45+40+1, 0, 45, cellHeight-1)];
        lbl4.font = txtfont;
        lbl4.textAlignment = UITextAlignmentCenter;
        lbl4.backgroundColor = [UIColor whiteColor];
        lbl4.textColor = [UIColor blackColor];
        lbl4.text = @"";
        [cell.contentView addSubview:lbl4];

        btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(646, 0, 45, 45)];
        btnAdd.titleLabel.text=@"";
        btnAdd.tag = 5;
            
        [cell.contentView addSubview:btnAdd];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    lbl2 = (UILabel*) [cell.contentView viewWithTag:2];
    lbl3 = (UILabel*) [cell.contentView viewWithTag:3];
    btnAdd = (UIButton*) [cell.contentView viewWithTag:5];
    if (btnAdd) 
    {
        [btnAdd removeTarget:self action:@selector(addFeesDetail:) forControlEvents:UIControlEventTouchDown];
        [btnAdd removeTarget:self action:@selector(generatePaymentSchedule:) forControlEvents:UIControlEventTouchDown];
    }
    
    if (p_sectionNo==1) 
        lbl2.text = @"Fees / services Name";
    else
        lbl2.text = @"Payment Date";

    if (p_sectionNo==1) 
        lbl3.text = @"Amount";
    else
        lbl3.text = @"Pay Amount";

    if (p_sectionNo==1) 
        [btnAdd setImage:[UIImage imageNamed:@"addiconnew1.PNG"] forState:UIControlStateNormal];
    else
        [btnAdd setImage:[UIImage imageNamed:@"regen.png"] forState:UIControlStateNormal];

    if (p_sectionNo==1) 
        [btnAdd addTarget:self action:@selector(addFeesDetail:) forControlEvents:UIControlEventTouchDown];
    else
        [btnAdd addTarget:self action:@selector(generatePaymentSchedule:) forControlEvents:UIControlEventTouchDown];
    
    if (p_sectionNo!=1) 
        if ([currMode isEqualToString:@"U"]) 
            btnAdd.enabled = NO;

    return cell;
}


- (UITableViewCell*) getRenewalAmtCell
{
    static NSString *cellid=@"cellRenewalAmt";
    BOOL assignValues = NO;
    UILabel *lbl1, *lbl2;
    UITextField *txt2;
    UISegmentedControl *sc1;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
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
        
        NSArray *scData = [NSArray arrayWithObjects:@"No",@"Yes", nil];
        sc1  = [[UISegmentedControl alloc] initWithItems:scData];
        NSDictionary *colorAttrib = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        NSDictionary *bcAttrib = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextShadowColor];
        /*NSDictionary *colorAttribDisabled = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
        NSDictionary *bcAttribDisabled = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextShadowColor];*/
        
        [sc1 setTitleTextAttributes:colorAttrib 
                           forState:UIControlStateNormal];
        [sc1 setTitleTextAttributes:bcAttrib 
                           forState:UIControlStateNormal];
        /*[sc1 setTitleTextAttributes:colorAttribDisabled 
                           forState:UIControlStateDisabled];
        [sc1 setTitleTextAttributes:bcAttribDisabled 
                           forState:UIControlStateDisabled];*/
        [sc1 setFrame:CGRectMake(lblWidth, 5, txtWidth, cellHeight-5)];
        sc1.tag = 2;
        [cell.contentView addSubview:sc1];
        
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(lblWidth+txtWidth, 0,lblWidth , cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.tag = 3;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        txt2 = [[UITextField alloc] initWithFrame:CGRectMake(2*lblWidth+txtWidth, 5, txtWidth, cellHeight-5)];
        txt2.font = txtfont;
        txt2.tag = 4;
        txt2.textAlignment = UITextAlignmentLeft;
        txt2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt2.backgroundColor = lblTextColor;
        txt2.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt2];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        UILabel *lbl2 = (UILabel*) [cell.contentView viewWithTag:3];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Is Renewal"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Total Amount"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!scIsRenewal)
        scIsRenewal = (UISegmentedControl*) [cell.contentView viewWithTag:2];
    
    if (!txtTotAmt)
    {
        txtTotAmt = (UITextField*) [cell.contentView viewWithTag:4];
        txtTotAmt.delegate = self;
    }
    
    txtTotAmt.enabled = NO;
    if (assignValues) 
    {
        if (_initDict)
            if ([_initDict valueForKey:@"ISRENEWAL"]) 
                scIsRenewal.selectedSegmentIndex = [[_initDict valueForKey:@"ISRENEWAL"] intValue];
        
        if ([currMode isEqualToString:@"L"]) 
            scIsRenewal.enabled = NO;
        
        if ([currMode isEqualToString:@"I"]) 
            scIsRenewal.selectedSegmentIndex = 0;

        [self setValueforText:txtTotAmt andField:@"TOTALAMOUNT"];
    }
    return cell;
}

- (UITableViewCell*) getStDateEndDateCell
{
    static NSString *cellid=@"cellStEndDate";
    UIButton *btnSelStDate, *btnSelEndDate;
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
    btnSelStDate =(UIButton*) [cell.contentView viewWithTag:5];
    if (!btnSelStDate) 
    {
        btnSelStDate = [[UIButton alloc] initWithFrame:CGRectMake(txtStartDate.frame.origin.x+txtStartDate.frame.size.width-25, 5, 25, txtStartDate.frame.size.height)];
        btnSelStDate.titleLabel.text=@"";
        [btnSelStDate setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnSelStDate addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        btnSelStDate.tag = 5;
        [cell.contentView addSubview:btnSelStDate]; 
        [txtStartDate setFrame:CGRectMake(txtStartDate.frame.origin.x, txtStartDate.frame.origin.y, txtStartDate.frame.size.width -25, txtStartDate.frame.size.height)];
    }
    btnSelEndDate =(UIButton*) [cell.contentView viewWithTag:6];
    if (!btnSelEndDate) 
    {
        btnSelEndDate = [[UIButton alloc] initWithFrame:CGRectMake(txtEndDate.frame.origin.x+txtEndDate.frame.size.width-25, 5, 25, txtEndDate.frame.size.height)];
        btnSelEndDate.titleLabel.text=@"";
        [btnSelEndDate setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnSelEndDate addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        btnSelEndDate.tag = 6;
        [cell.contentView addSubview:btnSelEndDate]; 
        [txtEndDate setFrame:CGRectMake(txtEndDate.frame.origin.x, txtEndDate.frame.origin.y, txtEndDate.frame.size.width -25, txtEndDate.frame.size.height)];
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

- (IBAction) displayCalendar:(id) sender
{
    UIButton *btnSelected = (UIButton*) sender;
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        
        dobPicker = [[UIDatePicker alloc] init];
        dobPicker.frame=CGRectMake(20, 25.0, 240.0, 150.0);
        dobPicker.datePickerMode = UIDatePickerModeDate;
        
        [dobPicker setDate:[NSDate date]];
        
        dAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"\n\n\n\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Select", nil];
        dAlert.cancelButtonIndex = 0;
        dAlert.delegate = self;
        dAlert.tag = btnSelected.tag;
        [dAlert addSubview:dobPicker];
        [dAlert show];
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex!=0) 
    {
        NSDate *date = [dobPicker date];
        /*NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:(NSString*) @"dd/MM/yyyy"];*/
        switch (alertView.tag) {
            case 5:
                txtStartDate.text = [nsdf stringFromDate:date];
                if (_noOfPlanMonths>0) 
                {
                    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
                    [dateComponents setMonth:_noOfPlanMonths];
                    NSCalendar* calendar = [NSCalendar currentCalendar];
                    NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
                    txtEndDate.text = [nsdf stringFromDate:newDate];
                }
                break;
            case 6:
                txtEndDate.text = [nsdf stringFromDate:date];
                break;
            case 7:
                txtFirstDue.text = [nsdf stringFromDate:date];
                break;
            case 8:
                //[self generatePaymentSchedule];
                break;
            default:
                break;
        }
        
        if (alertView.tag>=100 & alertView.tag<200) 
        {
            int recordNo = alertView.tag-100;
            [woFeeDetail removeObjectAtIndex:recordNo];
            [entryTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            [self setTotalFeesAmount];
        }
        if (alertView.tag>=200 & alertView.tag<300) 
        {
            int recordNo = alertView.tag-200;
            [woPayDetail removeObjectAtIndex:recordNo];
            [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


- (UITableViewCell*) getBillCycleCell
{
    BOOL assignValues = NO;
    UIButton *btnBillCycleSelect;
    UILabel *lbl1;
    UITextField *txt1;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    static NSString *cellid=@"cellBillCycle";
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
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Billing Cycle"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtBillCycle)
    {
        txtBillCycle = (UITextField*) [cell.contentView viewWithTag:2];
        txtBillCycle.delegate = self;
    }
    btnBillCycleSelect =(UIButton*) [cell.contentView viewWithTag:6];
    if (!btnBillCycleSelect) 
    {
        btnBillCycleSelect = [[UIButton alloc] initWithFrame:CGRectMake(txtBillCycle.frame.origin.x+txtBillCycle.frame.size.width-25, 5, 25, txtBillCycle.frame.size.height)];
        btnBillCycleSelect.titleLabel.text=@"";
        [btnBillCycleSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnBillCycleSelect addTarget:self action:@selector(getBillCycleValues:) forControlEvents:UIControlEventTouchDown];
        btnBillCycleSelect.tag = 6;
        [cell.contentView addSubview:btnBillCycleSelect]; 
        [txtBillCycle setFrame:CGRectMake(txtBillCycle.frame.origin.x, txtBillCycle.frame.origin.y, txtBillCycle.frame.size.width -25, txtBillCycle.frame.size.height)];
    }
    btnBillCycleSelect.hidden = NO;
    txtBillCycle.enabled = NO;
    if (assignValues) 
        [self setValueforText:txtBillCycle andField:@"CYCLENAME"];
    return cell;
}

- (UITableViewCell*) getPlanCell
{
    BOOL assignValues = NO;
    UIButton *btnPlanSelect; //, *btnBillCycleSelect;
    UILabel *lbl1;
    UITextField *txt1;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    static NSString *cellid=@"cellPlan";
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
    if (!txtPlan)
    {
        txtPlan = (UITextField*) [cell.contentView viewWithTag:2];
        txtPlan.delegate = self;
    }
    btnPlanSelect =(UIButton*) [cell.contentView viewWithTag:5];
    if (!btnPlanSelect) 
    {
        btnPlanSelect = [[UIButton alloc] initWithFrame:CGRectMake(txtPlan.frame.origin.x+txtPlan.frame.size.width-25, 5, 25, txtPlan.frame.size.height)];
        btnPlanSelect.titleLabel.text=@"";
        [btnPlanSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnPlanSelect addTarget:self action:@selector(getMemberPlan:) forControlEvents:UIControlEventTouchDown];
        btnPlanSelect.tag = 5;
        [cell.contentView addSubview:btnPlanSelect]; 
        [txtPlan setFrame:CGRectMake(txtPlan.frame.origin.x, txtPlan.frame.origin.y, txtPlan.frame.size.width -25, txtPlan.frame.size.height)];
        btnPlanSelect.hidden = NO;
    }
    txtPlan.enabled = NO;
    if (assignValues) 
        [self setValueforText:txtPlan andField:@"PLANDESC"];
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
    if (!txtEntryNo)
    {
        txtEntryNo = (UITextField*) [cell.contentView viewWithTag:2];
        txtEntryNo.placeholder = @"(Auto)";
        txtEntryNo.delegate = self;
    }
    if (!txtEntryDate)
    {
        txtEntryDate = (UITextField*) [cell.contentView viewWithTag:4];
        txtEntryDate.delegate = self;
        if ([currMode isEqualToString:@"I"]) 
            txtEntryDate.text = [nsdf stringFromDate:[NSDate date]];
    }
    if (assignValues) 
    {
        [self setValueforText:txtEntryNo andField:@"ENTRYNO"];
        if ([currMode isEqualToString:@"I"]) 
            txtEntryDate.text = [nsdf stringFromDate:[NSDate date]];
        else
            [self setValueforText:txtEntryDate andField:@"ENTRYDATE"];
    }
    txtEntryNo.enabled = NO;
    txtEntryDate.enabled = NO;
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

            
- (void) keyboardDidHide:(NSNotification*) keyboardInfo
{
    //NSLog(@"received keyboard info %@", keyboardInfo);
    //if (shouldScroll) {
    scrollOffset = _parentScroll.contentOffset;
    CGPoint scrollPoint;
    scrollPoint =  _parentScroll.bounds.origin; 
    scrollPoint.x = 0;
    scrollPoint.y=0;
    [_parentScroll setContentOffset:scrollPoint animated:NO];  
    shouldScroll = true;
    //}
}

- (void) setFieldsEntryStatus:(BOOL) p_Status
{
    if (scIsRenewal) scIsRenewal.enabled = p_Status;
    if (txtNoOfInst) txtNoOfInst.enabled = p_Status;
}

- (void) clearScreen
{
    if (txtBillCycle) txtBillCycle.text = @"";
    _billCycleId = 0;
    if (txtPlan) txtPlan.text = @"";
    _planId = 0;
    if (txtStartDate) txtStartDate.text = @"";
    if (txtEndDate) txtEndDate.text = @"";
    if (txtTotAmt) txtTotAmt.text = @"";
    if (txtFirstDue) txtFirstDue.text = @"";
    if (txtNoOfInst) txtNoOfInst.text = @"";
    //if (scGender) scGender.selectedSegmentIndex = 0;
}


- (void) getMemberPlan:(id) sender
{
    //NSLog(@"the currne tmode is %@", currMode);
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"SelectPlan"] forKey:@"notify"];
        _planTypeCallbacks(returnInfo);
    }    
}

- (void) setMemberPlan:(NSDictionary*) p_mbrPlanDict
{
    NSDictionary *recdData = [p_mbrPlanDict valueForKey:@"data"];
    if (txtPlan) 
    {
        txtPlan.text = [recdData valueForKey:@"PLANDESC"];
        _planId = [[recdData valueForKey:@"PLANID"] intValue];
        _noOfPlanMonths = [[recdData valueForKey:@"NOOFMONTHS"] intValue];
    }
    woFeeDetail = [[NSMutableArray alloc] initWithArray:[p_mbrPlanDict valueForKey:@"feeinfo"] copyItems:YES];
    [entryTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [self setTotalFeesAmount];
}

- (void) getBillCycleValues : (id) sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"SelectBillCycle"] forKey:@"notify"];
        _billcycleCallbacks(returnInfo);
    }    
}

- (void) setBillCycle:(NSDictionary*) p_mbrBillCycle
{
    NSDictionary *recdData = [p_mbrBillCycle valueForKey:@"data"];
    if (txtBillCycle) 
    {
        txtBillCycle.text = [recdData valueForKey:@"CYCLENAME"];
        _billCycleId = [[recdData valueForKey:@"BILLCYCLEID"] intValue];
    }
}

- (void) addFeesDetail:(id) sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"SelectFeesServices"] forKey:@"notify"];
        _feeDataCallbacks(returnInfo);
    }
}

- (void) addUpdateFeesData:(NSDictionary*) p_feesInfo
{
    NSDictionary *recdData = [p_feesInfo valueForKey:@"data"];
    int editRecNo=0;
    NSString *opMode = [NSString stringWithFormat:@"%@",[p_feesInfo valueForKey:@"opmode"]];
    if ([opMode isEqualToString:@"I"]) 
    {
        [woFeeDetail addObject:recdData];
        [entryTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }

    if ([opMode isEqualToString:@"U"]) 
    {
        editRecNo = [[p_feesInfo valueForKey:@"recordno"] intValue];
        [woFeeDetail replaceObjectAtIndex:editRecNo withObject:recdData];
        NSIndexPath *curIndPath = [NSIndexPath indexPathForRow:editRecNo+1 inSection:1];
        NSArray *updateInfo = [[NSArray alloc] initWithObjects:curIndPath, nil];
        [entryTV reloadRowsAtIndexPaths:updateInfo withRowAnimation:UITableViewRowAnimationNone];
    }
    [self setTotalFeesAmount];
}

- (void) addUpdatePayScheduleData:(NSDictionary*) p_paySheduleInfo
{
    NSDictionary *recdData = [p_paySheduleInfo valueForKey:@"data"];
    int editRecNo=0;
    NSString *opMode = [NSString stringWithFormat:@"%@",[p_paySheduleInfo valueForKey:@"opmode"]];
    if ([opMode isEqualToString:@"I"]) 
    {
        [woPayDetail addObject:recdData];
        [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    if ([opMode isEqualToString:@"U"]) 
    {
        editRecNo = [[p_paySheduleInfo valueForKey:@"recordno"] intValue];
        [woPayDetail replaceObjectAtIndex:editRecNo withObject:recdData];
        NSIndexPath *curIndPath = [NSIndexPath indexPathForRow:editRecNo+1 inSection:2];
        NSArray *updateInfo = [[NSArray alloc] initWithObjects:curIndPath, nil];
        [entryTV reloadRowsAtIndexPaths:updateInfo withRowAnimation:UITableViewRowAnimationNone];
    }
    double totAmt = 0;
    for (int l_loopcounter=0; l_loopcounter<[woPayDetail count]; l_loopcounter++) 
    {
        NSDictionary *tmpDict = [woPayDetail objectAtIndex:l_loopcounter];
        totAmt = totAmt + [[tmpDict valueForKey:@"PAYAMOUNT"] doubleValue];
    }
    _totPayAmt = totAmt;
    //[self setTotalFeesAmount];
}

- (IBAction)editFeeDetailsButtonClicked:(id)sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        UIButton *editBtn = (UIButton*) sender;
        int recordNo = [editBtn.titleLabel.text intValue];
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"EditFeesServices"] forKey:@"notify"];
        [returnInfo setValue:[woFeeDetail objectAtIndex:recordNo] forKey:@"data"];
        [returnInfo setValue:[NSString stringWithFormat:@"%d",recordNo] forKey:@"recordNo"];
        _feeDataCallbacks(returnInfo);
    }
}

- (IBAction)deleteFeeDetailsButtonClicked:(id)sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        UIButton *btnClicked = (UIButton*) sender;
        dAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure to delete this record?" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        dAlert.cancelButtonIndex = 0;
        dAlert.delegate = self;
        dAlert.tag = 100+[btnClicked.titleLabel.text intValue] ;
        //[dAlert addSubview:dobPicker];
        [dAlert show];
    }
    
}

- (IBAction)editPayScheduleButtonClicked:(id)sender;
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        UIButton *editBtn = (UIButton*) sender;
        int recordNo = [editBtn.titleLabel.text intValue];
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"EditPaySchedule"] forKey:@"notify"];
        [returnInfo setValue:[woPayDetail objectAtIndex:recordNo] forKey:@"data"];
        [returnInfo setValue:[NSString stringWithFormat:@"%d",recordNo] forKey:@"recordNo"];
        _payDataCallbacks(returnInfo);
    }
}

- (IBAction)deletePayScheduleButtonClicked:(id)sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        UIButton *btnClicked = (UIButton*) sender;
        NSDictionary *tmpDict = [woPayDetail objectAtIndex:[btnClicked.titleLabel.text intValue]];
        int l_prevPaidAmount = 0;
        if ([tmpDict valueForKey:@"PAIDAMOUNT"]) 
            l_prevPaidAmount = [[tmpDict valueForKey:@"PAIDAMOUNT"] intValue];
        
        if (l_prevPaidAmount>0) {
            [self showAlertMessage:@"Record cannot be deleted"];
            return;
        }
        
        dAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure to delete this record?" message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        dAlert.cancelButtonIndex = 0;
        dAlert.delegate = self;
        dAlert.tag = 200+[btnClicked.titleLabel.text intValue] ;
        //[dAlert addSubview:dobPicker];
        [dAlert show];
    }
}

- (void) setTotalFeesAmount
{
    double totAmt = 0;
    for (int l_loopcounter=0; l_loopcounter<[woFeeDetail count]; l_loopcounter++) 
    {
        NSDictionary *tmpDict = [woFeeDetail objectAtIndex:l_loopcounter];
        totAmt = totAmt + [[tmpDict valueForKey:@"FEEAMOUNT"] doubleValue];
    }
    _totFeeAmt = totAmt;
    txtTotAmt.text = [[[NSString alloc]initWithFormat:@" %@   ",[frm stringFromNumber:[NSNumber numberWithDouble:totAmt]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void) generatePaymentSchedule : (id) sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        double totAmt = [[frm numberFromString:txtTotAmt.text] doubleValue];
        int insts = [txtNoOfInst.text intValue];
        int oneInstallment = 0;
        int instAmount =0;
        if (totAmt==0) 
        {
            [self showAlertMessage:@"Total amount is not valid"];
            return;
        }
        if (insts==0) 
        {
            [self showAlertMessage:@"No of Installments is not valid"];
            return;
        }
        
        [woPayDetail removeAllObjects];
        _totPayAmt = 0;
        if (insts>0) 
        {
            oneInstallment = totAmt/insts;
            NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDate *firstDue = [nsdf dateFromString:txtFirstDue.text];
            for (int l_loopcounter=0; l_loopcounter<insts; l_loopcounter++) 
            {
                [dateComponents setMonth:l_loopcounter];
                NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:firstDue options:0];
                if (l_loopcounter==0) 
                    instAmount =oneInstallment +(totAmt - oneInstallment*insts);
                else
                    instAmount = oneInstallment;
                NSDictionary *payDict = [NSDictionary dictionaryWithObjectsAndKeys:[nsdf stringFromDate:newDate], @"ONDATE",[NSString stringWithFormat:@"%d",instAmount], @"PAYAMOUNT" , nil];
                [woPayDetail addObject:payDict];
                _totPayAmt = _totPayAmt + instAmount;
            }
        }
        [entryTV reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (BOOL) validateEntries
{
    BOOL l_resultVal;
    
    l_resultVal = [self emptyCheckResult:txtBillCycle andMessage:@"Billcycle should be selected"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtPlan andMessage:@"Plan should be selected"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtStartDate andMessage:@"Start date should be entered"];

    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtEndDate andMessage:@"End date should be entered"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtFirstDue andMessage:@"First due date should be entered"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtNoOfInst andMessage:@"No of Instalments should be entered"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
    {
        if (_totFeeAmt==0) 
        {
            [self showAlertMessage:@"Total fee amount cannot be 0"];
            l_resultVal = NO;
        }
    }

    if (l_resultVal==NO) 
        return l_resultVal;
    else
    {
        if (_totPayAmt==0) 
        {
            [self showAlertMessage:@"Pay schedule should be valid values"];
            l_resultVal = NO;
        }
    }
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
    {
        if (_totPayAmt!=_totFeeAmt) 
        {
            [self showAlertMessage:@"Total fee does not match with total pay"];
            l_resultVal = NO;
        }
    }

    if (l_resultVal==NO) 
        return l_resultVal;
    else
    {
        if ([woFeeDetail count]==0) 
        {
            [self showAlertMessage:@"Fees should have valid values"];
            l_resultVal = NO;
        }
    }
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
    {
        if ([woPayDetail count]==0) 
        {
            [self showAlertMessage:@"Pay schedule should have valid values"];
            l_resultVal = NO;
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
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    NSMutableString *l_feeXML = [[NSMutableString alloc] init ];
    NSMutableString *l_payXML = [[NSMutableString alloc] init];
    if ([currMode isEqualToString:@"I"]) 
    {
        l_retXML = [NSString stringWithFormat:MEMBERPLAN_XML, @"0",[_mbrDict valueForKey:@"MEMBERID"], @"0", txtEntryDate.text, scIsRenewal.selectedSegmentIndex , _billCycleId, txtStartDate.text, txtEndDate.text, _totFeeAmt, _planId, [txtNoOfInst.text intValue], txtFirstDue.text];
        for (NSDictionary *tmpDict in woFeeDetail) 
        {
            l_feeXML = [NSString stringWithFormat:MEMBERPLANFEE_XML, @"0", [tmpDict valueForKey:@"FEESID"], [tmpDict valueForKey:@"FEEAMOUNT"]];
            l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_feeXML];
        }
        for (NSDictionary *tmpDict in woPayDetail) 
        {
            l_payXML = [NSString stringWithFormat:MEMBERPLANPAY_XML, @"0", [tmpDict valueForKey:@"ONDATE"], [tmpDict valueForKey:@"PAYAMOUNT"]];
            l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_payXML];
        }
    }
    if ([currMode isEqualToString:@"U"]) 
    {
        l_retXML = [NSString stringWithFormat:MEMBERPLAN_XML,[_initDict valueForKey:@"MEMBERPLANID"] ,[_mbrDict valueForKey:@"MEMBERID"], @"0", txtEntryDate.text, scIsRenewal.selectedSegmentIndex , _billCycleId, txtStartDate.text, txtEndDate.text, _totFeeAmt, _planId, [txtNoOfInst.text intValue], txtFirstDue.text];
        for (NSDictionary *tmpDict in woFeeDetail) 
        {
            l_feeXML = [NSString stringWithFormat:MEMBERPLANFEE_XML, [tmpDict valueForKey:@"MBRPLANFEESID"], [tmpDict valueForKey:@"FEESID"], [tmpDict valueForKey:@"FEEAMOUNT"]];
            l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_feeXML];
        }
        for (NSDictionary *tmpDict in woPayDetail) 
        {
            l_payXML = [NSString stringWithFormat:MEMBERPLANPAY_XML, [tmpDict valueForKey:@"MBRPLANSCHEID"] , [tmpDict valueForKey:@"ONDATE"], [tmpDict valueForKey:@"PAYAMOUNT"]];
            l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_payXML];
        }
    }
    
    l_retXML = [NSString stringWithFormat:@"%@%@%@",@"<MPDATA>",l_retXML, @"</MPDATA>"];
    //NSLog(@"edit saving info %@",l_retXML);
    l_retXML = (NSMutableString*) [self htmlEntitycode:l_retXML];
    return l_retXML;
}


@end
