//
//  memTransObjects.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 26/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memTransObjects.h"

@implementation memTransObjects


- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode withMbrKeyDict:(NSDictionary*) p_keyDict andBankCallbacks:(METHODCALLBACK) p_bankCallbacks
{
    self = [super init];
    if (p_dictData) 
        _initDict = [[NSDictionary alloc] initWithDictionary:p_dictData copyItems:YES];
    else
        _initDict = nil;
    currOrientation = p_intOrientation;
    _bankCallbacks = p_bankCallbacks;
    _mbrDict = [NSDictionary dictionaryWithDictionary:p_keyDict];
    _parentScroll = p_scrollview;
    currMode = [[NSString alloc] initWithFormat:@"%@", p_dictData];
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
    woAdjDetail = [[NSMutableArray alloc] init];
    woPendDetail =[[NSMutableArray alloc] init];
    lblTextColor = [UIColor whiteColor];
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
    //_initDict = nil;
    if (txtEntryNo) 
        txtEntryNo.text = @"";
    
    if (txtEntryDate)
        txtEntryDate.text = [nsdf stringFromDate:[NSDate date]];
    
    if (scPaymode) 
        scPaymode.selectedSegmentIndex = 0;
    
    [self calculateTotalsWithFlag:0];
    if (txtAmountPaid) 
        txtAmountPaid.text = [NSString stringWithFormat:@"%d", _totBalanceAmt];
    [self generateAdjustmentsEntry:nil];
    //[entryTV reloadData];
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currMode = @"L";
    if (p_dictData) 
    {
        NSArray *mdpArray = [[NSArray alloc] initWithArray:[p_dictData valueForKey:@"data"] copyItems:YES];
        //_initDict = [[NSDictionary alloc] initWithDictionary:[mdpArray objectAtIndex:0] copyItems:YES];
        [woAdjDetail removeAllObjects];
        [woPendDetail removeAllObjects];
        _initDict = nil;
        for (NSDictionary *tmpDict in mdpArray) 
        {
            int mdpDatatype = [[tmpDict valueForKey:@"DATATYPE"] intValue];
            switch (mdpDatatype) 
            {
                case 1:
                    _initDict = [NSDictionary dictionaryWithDictionary:tmpDict];
                    break;
                case 2:
                    [woAdjDetail addObject:tmpDict];
                    break;
                case 3:
                    [woPendDetail addObject:tmpDict];
                    break;
                default:
                    break;
            }
        }
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
    
    if ([p_fieldName isEqualToString:@"BANKNAME"]) 
        _bankId = [[_initDict valueForKey:@"BANKID"] intValue];
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
    [self setValueforText:txtEntryNo andField:@"ENTRYNO"];
    [self setValueforText:txtEntryDate andField:@"ENTRYDATE"];
    //[self setValueforText:txtTotPending andField:@"TOTPENDING"];
    [self setValueforText:txtAmountPaid andField:@"PAIDAMOUNT"];
    [self setValueforText:txtNotes andField:@"NOTES"];
    [self setValueforText:txtChequeNo andField:@"CHEQUENO"];
    [self setValueforText:txtChequeDate andField:@"CHEQUEDATE"];
    [self setValueforText:txtBankName andField:@"BANKNAME"];
    if (scPaymode) 
        scPaymode.selectedSegmentIndex = [[_initDict valueForKey:@"PAYMODE"] intValue];
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
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int noofRows =1;
    switch (section) 
    {
        case 0:
            noofRows = 6;
            break;
        case 1:
            noofRows = [woAdjDetail count] +2;
            break;
        default:
            break;
    }
    return noofRows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int l_rowheight =0;
    switch (indexPath.section) 
    {
        case 0:
            if (indexPath.row==5) 
                l_rowheight = 20;
            else
                l_rowheight = 45;
            break;
        case 1:
            l_rowheight = 45;
            /*if (indexPath.row==[woAdjDetail count]+1) 
                l_rowheight = 30;*/
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
    switch (indexPath.section) 
    {
        case 0:
            switch (indexPath.row) 
            {
                case 0:
                    return [self getFirstRowCell];
                    break;
                case 1:
                    return [self getCellPaymode];
                    break;
                case 2:
                    return [self getChequeDataCell];
                    break;
                case 3:
                    return [self getBankNameCell];
                    break;
                case 4:
                    return [self getNotesCell];
                    break;
                /*case 5:
                    return [self getAmountCell];
                    break;*/
                case 5:
                    return [self getEmptyCell];
                    break;
                default:
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
                    if (indexPath.row==[woAdjDetail count]+1) 
                        return [self getTotalValuesCell];
                    else
                        return [self getAdjustmentCellforRow:indexPath.row];
                    break;
            }
            break;
        default:
            return [self getEmptyCell];
            break;
    }
    return nil;
}

- (UITableViewCell*) getTotalValuesCell
{
    static NSString *cellid=@"cellAdjValuesTotal";
    //UIButton *btnedit, *btndelete;
    UILabel /**lbl1,*/ *lbl2, *lbl3, *lbl4, *lbl5; //, *lbl6;
    int   lblSlWidth, lblOtherWidth, cellHeight, xPosition, xWidth ;
    lblSlWidth = 58; lblOtherWidth = 131; cellHeight = 45;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    [self calculateTotalsWithFlag:1];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont boldSystemFontOfSize:14.0f];
        cell.backgroundColor = [UIColor clearColor];
        
        xPosition = lblSlWidth; xWidth = lblSlWidth-1;
        /*lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentCenter;
        lbl1.tag = 1;
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl1];*/
        
        xPosition += xWidth+1;xWidth = lblOtherWidth;
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentRight;
        lbl2.tag = 2;
        /*lbl2.backgroundColor = [UIColor whiteColor];
        lbl2.textColor = [UIColor blackColor];*/
        lbl2.backgroundColor = [entryTV backgroundColor];
        lbl2.textColor = lblTextColor;
        [cell.contentView addSubview:lbl2];
        
        xPosition += xWidth+1; 
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentRight;
        lbl3.tag = 3;
        lbl3.backgroundColor = [UIColor whiteColor];
        lbl3.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl3];
        
        xPosition += xWidth+1; 
        lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl4.font = txtfont;
        lbl4.tag = 4;
        lbl4.textAlignment = UITextAlignmentRight;
        lbl4.backgroundColor = [UIColor whiteColor];
        lbl4.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl4];
        
        xPosition += xWidth+1; 
        lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl5.font = txtfont;
        lbl5.tag = 5;
        lbl5.textAlignment = UITextAlignmentRight;
        lbl5.backgroundColor = [UIColor whiteColor];
        lbl5.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl5];
        
    }
    /*lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl1.text = [NSString stringWithFormat:@"%d", p_rowNo];*/
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:2];
    lbl2.text = [[NSString stringWithFormat:@"%@   ", @"Total :"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    lbl3 = (UILabel*) [cell.contentView viewWithTag:3];
    lbl3.text = [[[NSString alloc] initWithFormat:@"%@ ", [frm stringFromNumber:[NSNumber numberWithDouble:_totActualAmt]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    lbl4 = (UILabel*) [cell.contentView viewWithTag:4];
    lbl4.text = [[[NSString alloc] initWithFormat:@"%@ ", [frm stringFromNumber:[NSNumber numberWithDouble:_totBalanceAmt]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    lbl5 = (UILabel*) [cell.contentView viewWithTag:5];
    lbl5.text = [[[NSString alloc] initWithFormat:@"%@ ", [frm stringFromNumber:[NSNumber numberWithDouble:_totAdjustedAmt]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    /*btnedit = (UIButton*) [cell.contentView viewWithTag:6];
    btnedit.titleLabel.text = [NSString stringWithFormat:@"%d", p_rowNo];
    
    btndelete = (UIButton*) [cell.contentView viewWithTag:7];
    btndelete = [NSString stringWithFormat:@"%d", p_rowNo];*/
    
    return cell;
}


- (UITableViewCell*) getAdjustmentCellforRow:(int) p_rowNo
{
    static NSString *cellid=@"cellAdjValues";
    NSDictionary *tmpDict = [woAdjDetail objectAtIndex:p_rowNo-1];
    //UIButton *btnedit, *btndelete;
    UILabel *lbl1, *lbl2, *lbl3, *lbl4, *lbl5;
    int   lblSlWidth, lblOtherWidth, cellHeight, xPosition, xWidth ;
    lblSlWidth = 58; lblOtherWidth = 131; cellHeight = 45;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor = [UIColor clearColor];

        xPosition = lblSlWidth; xWidth = lblSlWidth-1;
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentCenter;
        lbl1.tag = 1;
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl1];
        
        xPosition += xWidth+1;xWidth = lblOtherWidth;
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentCenter;
        lbl2.tag = 2;
        lbl2.backgroundColor = [UIColor whiteColor];
        lbl2.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl2];
        
        xPosition += xWidth+1; 
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentRight;
        lbl3.tag = 3;
        lbl3.backgroundColor = [UIColor whiteColor];
        lbl3.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl3];
        
        xPosition += xWidth+1; 
        lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl4.font = txtfont;
        lbl4.tag = 4;
        lbl4.textAlignment = UITextAlignmentRight;
        lbl4.backgroundColor = [UIColor whiteColor];
        lbl4.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl4];
        
        xPosition += xWidth+1; 
        lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl5.font = txtfont;
        lbl5.tag = 5;
        lbl5.textAlignment = UITextAlignmentRight;
        lbl5.backgroundColor = [UIColor whiteColor];
        lbl5.textColor = [UIColor blackColor];
        [cell.contentView addSubview:lbl5];
        
        xPosition += xWidth; xWidth = 45;
        /*btnedit = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, 45)];
        btnedit.titleLabel.text=@"";
        btnedit.titleLabel.textColor = btnedit.titleLabel.backgroundColor;
        btnedit.tag = 6;
        [btnedit setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnedit addTarget:self action:@selector(editAdjDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnedit];
        
        xPosition += xWidth;
        btndelete = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, 45)];
        btndelete.titleLabel.text=@"";
        btndelete.titleLabel.textColor = btndelete.titleLabel.backgroundColor;
        btndelete.tag = 7;
        [btndelete setImage:[UIImage imageNamed:@"deleteicon.JPG"] forState:UIControlStateNormal];
        [btndelete addTarget:self action:@selector(deleteAdjDetailsButtonClicked:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btndelete];
        [cell.contentView addSubview:btnedit];*/
        
    }
    lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
    lbl1.text = [NSString stringWithFormat:@"%d", p_rowNo];
    
    lbl2 = (UILabel*) [cell.contentView viewWithTag:2];
    lbl2.text = [tmpDict valueForKey:@"ONDATE"];
    
    lbl3 = (UILabel*) [cell.contentView viewWithTag:3];
    lbl3.text = [[[NSString alloc] initWithFormat:@"%@  ", [frm stringFromNumber:[NSNumber numberWithDouble:[[tmpDict valueForKey:@"ACTUALAMT"] doubleValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
                
    lbl4 = (UILabel*) [cell.contentView viewWithTag:4];
    lbl4.text = [[[NSString alloc] initWithFormat:@"%@  ", [frm stringFromNumber:[NSNumber numberWithDouble:[[tmpDict valueForKey:@"PENDINGAMT"] doubleValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    lbl5 = (UILabel*) [cell.contentView viewWithTag:5];
    lbl5.text = [[[NSString alloc] initWithFormat:@"%@  ", [frm stringFromNumber:[NSNumber numberWithDouble:[[tmpDict valueForKey:@"ADJUSTEDAMT"] doubleValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    /*btnedit = (UIButton*) [cell.contentView viewWithTag:6];
    btnedit.titleLabel.text = [NSString stringWithFormat:@"%d", p_rowNo];

    btndelete = (UIButton*) [cell.contentView viewWithTag:7];
    btndelete = [NSString stringWithFormat:@"%d", p_rowNo];*/
    
    return cell;
}

- (UITableViewCell*) getHeaderCellForSection:(int) p_sectionNo
{
    static NSString *cellid=@"cellHeader";
    UIButton *btnAdd;
    UILabel *lbl1, *lbl2, *lbl3, *lbl4, *lbl5; //, *lbl6;
    int   lblSlWidth, lblOtherWidth, cellHeight, xPosition, xWidth ;
    lblSlWidth = 58; lblOtherWidth = 131; cellHeight = 45;
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont boldSystemFontOfSize:16.0f];
        cell.backgroundColor = [UIColor clearColor];
        xPosition = lblSlWidth; xWidth = lblSlWidth-1;
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentCenter;
        lbl1.tag = 1;
        lbl1.backgroundColor = [UIColor whiteColor];
        lbl1.textColor = [UIColor blackColor];
        lbl1.text = @"Sl#";
        [cell.contentView addSubview:lbl1];
        
        xPosition += xWidth+1;xWidth = lblOtherWidth;
        lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl2.font = txtfont;
        lbl2.textAlignment = UITextAlignmentCenter;
        lbl2.tag = 2;
        lbl2.backgroundColor = [UIColor whiteColor];
        lbl2.textColor = [UIColor blackColor];
        lbl2.text = @"Due Date";
        [cell.contentView addSubview:lbl2];
        
        xPosition += xWidth+1; 
        lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl3.font = txtfont;
        lbl3.textAlignment = UITextAlignmentCenter;
        lbl3.tag = 3;
        lbl3.backgroundColor = [UIColor whiteColor];
        lbl3.textColor = [UIColor blackColor];
        lbl3.text = @"Pending";
        [cell.contentView addSubview:lbl3];
        
        xPosition += xWidth+1; 
        lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl4.font = txtfont;
        lbl4.tag = 4;
        lbl4.textAlignment = UITextAlignmentCenter;
        lbl4.backgroundColor = [UIColor whiteColor];
        lbl4.textColor = [UIColor blackColor];
        lbl4.text = @"Balance";
        [cell.contentView addSubview:lbl4];
        
        xPosition += xWidth+1; 
        lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, xWidth, cellHeight-1)];
        lbl5.font = txtfont;
        lbl5.tag = 5;
        lbl5.textAlignment = UITextAlignmentCenter;
        lbl5.backgroundColor = [UIColor whiteColor];
        lbl5.textColor = [UIColor blackColor];
        lbl5.text = [[NSString stringWithFormat:@"%@", @"Adjusted"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        [cell.contentView addSubview:lbl5];

        /*xPosition += xWidth+1; 
        lbl6 = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 0, 45, cellHeight-1)];
        lbl6.font = txtfont;
        lbl6.tag = 6;
        lbl6.textAlignment = UITextAlignmentCenter;
        lbl6.backgroundColor = [UIColor whiteColor];
        lbl6.textColor = [UIColor blackColor];
        lbl6.text = @"";
        [cell.contentView addSubview:lbl6];*/

        btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(645, 0, 45, 45)];
        btnAdd.titleLabel.text=@"";
        [btnAdd addTarget:self action:@selector(generateAdjustmentsEntry:) forControlEvents:UIControlEventTouchDown];
        btnAdd.tag = 7;
        [btnAdd setImage:[UIImage imageNamed:@"regen.png"] forState:UIControlStateNormal];
        
        [cell.contentView addSubview:btnAdd];
    }
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
    txtChequeDate.enabled = NO;
    if (assignValues) 
        [self setValueforText:txtNotes andField:@"NOTES"];
    return cell;
}

- (UITableViewCell*) getBankNameCell
{
    BOOL assignValues = NO;
    UIButton *btnBankSelect;
    UILabel *lbl1;
    UITextField *txt1;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =232; cellHeight = 40;
    static NSString *cellid=@"cellBank";
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
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Bank Name"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtBankName)
    {
        txtBankName = (UITextField*) [cell.contentView viewWithTag:2];
        txtBankName.delegate = self;
    }
    btnBankSelect =(UIButton*) [cell.contentView viewWithTag:6];
    if (!btnBankSelect) 
    {
        btnBankSelect = [[UIButton alloc] initWithFrame:CGRectMake(txtBankName.frame.origin.x+txtBankName.frame.size.width-25, 5, 25, txtBankName.frame.size.height)];
        btnBankSelect.titleLabel.text=@"";
        [btnBankSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnBankSelect addTarget:self action:@selector(getBankValues:) forControlEvents:UIControlEventTouchDown];
        btnBankSelect.tag = 6;
        [cell.contentView addSubview:btnBankSelect]; 
        [txtBankName setFrame:CGRectMake(txtBankName.frame.origin.x, txtBankName.frame.origin.y, txtBankName.frame.size.width -25, txtBankName.frame.size.height)];
    }
    btnBankSelect.hidden = NO;
    txtBankName.enabled = NO;
    if (assignValues) 
        [self setValueforText:txtBankName andField:@"BANKNAME"];
    return cell;
}


- (UITableViewCell*) getChequeDataCell
{
    static NSString *cellid=@"cellChequeData";
    BOOL assignValues = NO;
    UIButton *btnSelChqDate;
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
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Cheque No"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Cheque Date"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtChequeNo)
    {
        txtChequeNo = (UITextField*) [cell.contentView viewWithTag:2];
        txtChequeNo.delegate = self;
        [txtChequeNo setKeyboardType:UIKeyboardTypeNumberPad];
    }
    if (!txtChequeDate)
    {
        txtChequeDate = (UITextField*) [cell.contentView viewWithTag:4];
        txtChequeDate.delegate = self;
    }
    btnSelChqDate =(UIButton*) [cell.contentView viewWithTag:7];
    if (!btnSelChqDate) 
    {
        btnSelChqDate = [[UIButton alloc] initWithFrame:CGRectMake(txtChequeDate.frame.origin.x+txtChequeDate.frame.size.width-25, 5, 25, txtChequeDate.frame.size.height)];
        btnSelChqDate.titleLabel.text=@"";
        [btnSelChqDate setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnSelChqDate addTarget:self action:@selector(displayCalendar:) forControlEvents:UIControlEventTouchDown];
        btnSelChqDate.tag = 7;
        [cell.contentView addSubview:btnSelChqDate]; 
        [txtChequeDate setFrame:CGRectMake(txtChequeDate.frame.origin.x, txtChequeDate.frame.origin.y, txtChequeDate.frame.size.width -25, txtChequeDate.frame.size.height)];
    }
    if (assignValues) 
    {
        [self setValueforText:txtChequeNo andField:@"CHEQUENO"];
        [self setValueforText:txtChequeDate andField:@"CHEQUEDATE"];
    }
    if ([currMode isEqualToString:@"L"])
        txtChequeNo.enabled = NO;
    else
    {
        if (scPaymode.selectedSegmentIndex>0) 
            txtChequeNo.enabled = YES;
        else
            txtChequeNo.enabled = NO;
    }
    txtChequeDate.enabled = NO;
    return cell;
}

/*
- (UITableViewCell*) getAmountCell
{
    static NSString *cellid=@"cellPendPayAmt";
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
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Pending Due"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Paid Amount"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtTotPending)
    {
        txtTotPending = (UITextField*) [cell.contentView viewWithTag:4];
        txtTotPending.delegate = self;
    }
    if (!txtAmountPaid)
    {
        txtAmountPaid = (UITextField*) [cell.contentView viewWithTag:2];
        txtAmountPaid.delegate = self;
        [txtAmountPaid setKeyboardType:UIKeyboardTypeNumberPad];
        if ([currMode isEqualToString:@"L"]==NO) 
            txtAmountPaid.enabled = YES;
        else
            txtAmountPaid.enabled = NO;
    }
    if (assignValues) 
    {
        [self setValueforText:txtTotPending andField:@"TOTPENDING"];
        [self setValueforText:txtAmountPaid andField:@"PAIDAMOUNT"];
    }
    txtTotPending.enabled = NO;
    return cell;
}

 */

- (UITableViewCell*) getCellPaymode
{
    BOOL assignValues = NO;
    static NSString *cellid=@"cellPaymode";
    UITableViewCell  *cell = [entryTV dequeueReusableCellWithIdentifier:cellid];
    UISegmentedControl *sc1;
    UILabel *lbl1, *lbl2;
    UITextField *txt2;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth = 232; cellHeight = 40;
    UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[entryTV backgroundColor];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lblWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [entryTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        NSArray *scData = [NSArray arrayWithObjects:@"Cash",@"Chq.", @"PDC", nil];  //, @"Other",
        sc1  = [[UISegmentedControl alloc] initWithItems:scData];
        NSDictionary *colorAttrib = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor];
        NSDictionary *bcAttrib = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextShadowColor];
        [sc1 setTitleTextAttributes:colorAttrib 
                           forState:UIControlStateNormal];
        [sc1 setTitleTextAttributes:bcAttrib 
                           forState:UIControlStateNormal];
        [sc1 setFrame:CGRectMake(lblWidth, 5, txtWidth, cellHeight-5)];
        [sc1 addTarget:self action:@selector(payModeSelected:) forControlEvents:UIControlEventValueChanged];
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
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Payment Mode"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Paid Amount"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!scPaymode)
        scPaymode = (UISegmentedControl*) [cell.contentView viewWithTag:2];
    
    if (!txtAmountPaid)
    {
        txtAmountPaid = (UITextField*) [cell.contentView viewWithTag:4];
        txtAmountPaid.delegate = self;
        [txtAmountPaid setKeyboardType:UIKeyboardTypeNumberPad];
    }

    if (assignValues) 
    {
        if ([currMode isEqualToString:@"L"]) 
            [self setValueforText:txtAmountPaid andField:@"PAIDAMOUNT"];
        
        if (_initDict)
            if ([_initDict valueForKey:@"PAYMODE"]) 
            {
                scPaymode.selectedSegmentIndex = [[_initDict valueForKey:@"PAYMODE"] intValue];
                if (scPaymode.selectedSegmentIndex>0) 
                    txtChequeNo.enabled = YES;
                else
                    txtChequeNo.enabled = NO;
            }
        if ([currMode isEqualToString:@"I"]) 
        {
            scPaymode.selectedSegmentIndex = 0;
            txtChequeNo.enabled = NO;
        }
        else
        {
            scPaymode.selectedSegmentIndex = [[_initDict valueForKey:@"PAYMODE"] intValue];
            if (scPaymode.selectedSegmentIndex>0) 
                txtChequeNo.enabled = YES;
            else
                txtChequeNo.enabled = NO;
        }
        if ([currMode isEqualToString:@"L"]==NO) 
            txtAmountPaid.enabled = YES;
        else
            txtAmountPaid.enabled = NO;
        
        if ([currMode isEqualToString:@"I"]) 
            txtAmountPaid.text = [NSString stringWithFormat:@"%d", _totBalanceAmt];
    }
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
    UIButton *btnSelected = (UIButton*) sender;
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        if (scPaymode.selectedSegmentIndex>0) 
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
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex!=0) 
    {
        NSDate *date = [dobPicker date];
        switch (alertView.tag) {
            case 7:
                txtChequeDate.text = [nsdf stringFromDate:date];
                break;
            case 8:
                //[self generatePaymentSchedule];
                break;
            default:
                break;
        }
        
        /*if (alertView.tag>=100 & alertView.tag<200) 
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
        }*/
    }
}


- (void) setFieldsEntryStatus:(BOOL) p_Status
{
    if (txtAmountPaid) txtAmountPaid.enabled = p_Status;
    if (txtNotes) txtNotes.enabled = p_Status;
    if (txtChequeNo) txtChequeNo.enabled = p_Status;
}

- (void) clearScreen
{
    txtEntryNo.text = @"";
    txtEntryDate.text = @"";
    scPaymode.selectedSegmentIndex = 0;
    //txtTotPending.text = @"";
    txtAmountPaid.text = @"";
    txtChequeNo.text = @"";
    txtChequeDate.text = @"";
    txtBankName.text = @"";
    _bankId =0;
    txtNotes.text = @"";
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:txtAmountPaid]) 
    {
        if (scPaymode.selectedSegmentIndex>0) 
            [txtChequeNo becomeFirstResponder];
        else
            [txtAmountPaid resignFirstResponder];
    }
    else if ([textField isEqual:txtChequeNo])
        [txtChequeNo resignFirstResponder];
    else if ([textField isEqual:txtNotes])
        [txtNotes resignFirstResponder];
    else
        [textField resignFirstResponder];
    return NO;
}

- (void) getBankValues : (id) sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        if (scPaymode.selectedSegmentIndex > 0)
        {
            NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
            [returnInfo setValue:[NSString stringWithString:@"SelectBank"] forKey:@"notify"];
            _bankCallbacks(returnInfo);
        }
    }    
}

- (void) setBank:(NSDictionary*) p_bankInfo
{
    NSDictionary *recdData = [p_bankInfo valueForKey:@"data"];
    if (txtBankName) 
    {
        txtBankName.text = [recdData valueForKey:@"BANKNAME"];
        _bankId = [[recdData valueForKey:@"BANKID"] intValue];
    }    
}

- (BOOL) validateEntries
{
    BOOL l_resultVal;
    
    l_resultVal = [self emptyCheckResult:txtAmountPaid andMessage:@"Paid Amount should be entered"];
    
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        if ([txtAmountPaid.text intValue]==0) 
        {
            l_resultVal = NO;
            [self showAlertMessage:@"Amount should be a valid value"];
            return l_resultVal;
        }
    

    if (scPaymode.selectedSegmentIndex>0) 
    {
        l_resultVal = [self emptyCheckResult:txtChequeNo andMessage:@"Cheque No should be entered"];

        if (l_resultVal==NO) 
            return l_resultVal;
        else
            l_resultVal = [self emptyCheckResult:txtChequeDate andMessage:@"Cheque date should be entered"];
        
        if (l_resultVal==NO) 
            return l_resultVal;
        else
            l_resultVal = [self emptyCheckResult:txtBankName andMessage:@"Bank name should be entered"];
    }
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
    {
        if ([txtAmountPaid.text doubleValue]!=_totAdjustedAmt) 
        {
            l_resultVal = NO;
            [self showAlertMessage:@"Paid and Adjusted amount mismatches"];
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
     
     #define MEMBERTRANSMAS_XML @"<MASTER><ENTRYID>%d</ENTRYID><ENTRYNO>%@</ENTRYNO><ENTRYDATE>%@</ENTRYDATE><MEMBERID>%d</MEMBERID><PAIDAMOUNT>%@</PAIDAMOUNT><NOTES>%@</NOTES><TRANSTYPE>%@</TRANSTYPE><PAYMODE>%d</PAYMODE><CHEQUENO>%@</CHEQUENO><CHEQUEDATE>%@</CHEQUEDATE><BANKID>%d</BANKID></MASTER>"
     
     #define MEMBERTRANSDET_XML @"<DETAIL><ENTRYDETID>%d</ENTRYDETID><MBRPLANSCHEID>%d</MBRPLANSCHEID><ACTUALAMT>%@</ACTUALAMT><PENDINGAMT>%@</PENDINGAMT><ADJUSTEDAMT>%@</ADJUSTEDAMT></DETAIL>"
     */
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    NSMutableString *l_DetailXML = [[NSMutableString alloc] init ];
    if ([currMode isEqualToString:@"I"]) 
    {
        l_retXML = [NSString stringWithFormat:MEMBERTRANSMAS_XML, 0, @"0", txtEntryDate.text,[[_mbrDict valueForKey:@"MEMBERID"] intValue], txtAmountPaid.text,  txtNotes.text, @"C", scPaymode.selectedSegmentIndex , txtChequeNo.text , txtChequeDate.text , _bankId];
        for (NSDictionary *tmpDict in woAdjDetail) 
        {
            l_DetailXML = [NSString stringWithFormat:MEMBERTRANSDET_XML, 0, [[tmpDict valueForKey:@"MBRPLANSCHEID"] intValue], [tmpDict valueForKey:@"ACTUALAMT"], [tmpDict valueForKey:@"PENDINGAMT"], [tmpDict valueForKey:@"ADJUSTEDAMT"]];
            l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_DetailXML];
        }
    }
    if ([currMode isEqualToString:@"U"]) 
    {
        l_retXML = [NSString stringWithFormat:MEMBERTRANSMAS_XML, [[_initDict valueForKey:@"ENTRYID"] intValue] , [_initDict valueForKey:@"ENTRYNO"] , txtEntryDate.text,[[_mbrDict valueForKey:@"MEMBERID"] intValue], txtAmountPaid.text,  txtNotes.text, @"C", scPaymode.selectedSegmentIndex , txtChequeNo.text , txtChequeDate.text , _bankId];
        for (NSDictionary *tmpDict in woAdjDetail) 
        {
            l_DetailXML = [NSString stringWithFormat:MEMBERTRANSDET_XML, [[tmpDict valueForKey:@"ENTRYDETID"] intValue], [[tmpDict valueForKey:@"MBRPLANSCHEID"] intValue], [tmpDict valueForKey:@"ACTUALAMT"], [tmpDict valueForKey:@"PENDINGAMT"], [tmpDict valueForKey:@"ADJUSTEDAMT"]];
            l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_DetailXML];
        }
    }
    l_retXML = [NSString stringWithFormat:@"%@%@%@",@"<TRANSDATA>",l_retXML, @"</TRANSDATA>"];
    //NSLog(@"edit saving info %@",l_retXML);
    l_retXML = (NSMutableString*) [self htmlEntitycode:l_retXML];
    return l_retXML;
}


- (void) generateAdjustmentsEntry : (id) sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        double currPending, adjustedAmt, indBalAmount, indAdjusted, balAfterAdjustement;
        double paidAmt = 0;
        if (txtAmountPaid) 
            paidAmt =[txtAmountPaid.text doubleValue];
        else
            paidAmt = _totBalanceAmt;
        
        currPending = 0; adjustedAmt = 0;indBalAmount = 0; indAdjusted =0;
        balAfterAdjustement = paidAmt;
        /*if (paidAmt==0) 
        {
            //[self showAlertMessage:@"Paid amount is not valid"];
            return;
            
        }*/
        [woAdjDetail removeAllObjects];
        for (int l_loopcounter=0; l_loopcounter<[woPendDetail count]; l_loopcounter++) 
        {
            NSMutableDictionary *tmpDict =  [NSMutableDictionary dictionaryWithDictionary:[[woPendDetail objectAtIndex:l_loopcounter] copy]];
            indBalAmount = [[tmpDict valueForKey:@"PENDINGAMT"] doubleValue];
            if (balAfterAdjustement>0) 
            {
                if (indBalAmount > balAfterAdjustement) 
                    indAdjusted = balAfterAdjustement;
                else
                    indAdjusted = indBalAmount;
                balAfterAdjustement -= indAdjusted;
                if (indAdjusted>0)
                {
                    [tmpDict setValue:[NSString stringWithFormat:@"%f", indAdjusted] forKey:@"ADJUSTEDAMT"];
                    [woAdjDetail addObject:tmpDict];
                }
            }
        }
        //_curPending = currPending;
        //txtTotPending.text = [frm stringFromNumber:[NSNumber numberWithDouble:_curPending]];
        [entryTV reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        //[entryTV reloadData];
    }
    //NSLog(@"the result array is %@", woAdjDetail);
}

- (IBAction) payModeSelected:(id)sender
{
    UISegmentedControl *tmpscntrl = (UISegmentedControl*) sender;
    int selPayMode = [tmpscntrl selectedSegmentIndex];
    if (selPayMode==0) 
        txtChequeNo.enabled = NO;
    else
        txtChequeNo.enabled = YES;
}

- (void) calculateTotalsWithFlag:(int) p_flag
{
    // 0 means only due date passed items 1 is for all 
    NSDate *curDate = [NSDate date];
    NSDate *balDate;
    _totActualAmt = 0;
    _totBalanceAmt = 0;
    _totAdjustedAmt = 0;
    if (p_flag==1) 
    {
        for (NSDictionary *tmpDict in woAdjDetail) 
        {
            _totActualAmt += [[tmpDict valueForKey:@"ACTUALAMT"] intValue];
            _totBalanceAmt += [[tmpDict valueForKey:@"PENDINGAMT"] intValue];
            _totAdjustedAmt += [[tmpDict valueForKey:@"ADJUSTEDAMT"] intValue];
        }
    }
    else
    {
        for (NSDictionary *tmpDict in woPendDetail) 
        {
            balDate = [nsdf dateFromString:[tmpDict valueForKey:@"ONDATE"]];
            NSTimeInterval interval = [balDate timeIntervalSinceDate:curDate];
            if (interval <= 0) 
            {
                _totActualAmt += [[tmpDict valueForKey:@"ACTUALAMT"] intValue];
                _totBalanceAmt += [[tmpDict valueForKey:@"PENDINGAMT"] intValue];
                _totAdjustedAmt += [[tmpDict valueForKey:@"ADJUSTEDAMT"] intValue];
            }
        }
    }
}

@end
