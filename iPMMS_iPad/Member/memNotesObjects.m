//
//  memNotesObjects.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memNotesObjects.h"

@implementation memNotesObjects

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andScrollview:(UIScrollView*) p_scrollview andDictdata:(NSDictionary*) p_dictData andMode:(NSString*) p_dispmode withMbrKeyDict:(NSDictionary*) p_keyDict andNotesTypeCallback:(METHODCALLBACK) p_notesTypeCallback
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
    _notesTypeNotificaiton = p_notesTypeCallback;
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
    
    if (txtEntryDate)
        txtEntryDate.text = [nsdf stringFromDate:[NSDate date]];
    
    if (scSendToAll) 
        scSendToAll.selectedSegmentIndex = 0;
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
    [self setValueforText:txtNotesType andField:@"NOTESTYPE"];
    [self setValueforText:txtEntryDate andField:@"ENTRYDATE"];
    [self setValueforText:txtNotes andField:@"NOTES"];
    [self setValueforText:txtStartDate andField:@"STARTDATE"];
    [self setValueforText:txtEndDate andField:@"ENDDATE"];
    [self setValueforText:txtNotesRefCode andField:@"NOTESCODE"];
    if (scSendToAll) 
        scSendToAll.selectedSegmentIndex = [[_initDict valueForKey:@"SENDTOALL"] intValue];
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
    int noofRows =1;
    noofRows = 4;
    return noofRows;
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
                    return [self getNotesCell];
                    break;
                case 2:
                    return [self getStDateEndDateCell];
                    break;
                case 3:
                    return [self getCellSendAllNotesCode];
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


- (UITableViewCell*) getCellSendAllNotesCode
{
    BOOL assignValues = NO;
    static NSString *cellid=@"cellSendNotesCode";
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
        
        NSArray *scData = [NSArray arrayWithObjects:@"No",@"Yes", nil];  //, @"Other",
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
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Send to All"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Notes Code"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!scSendToAll)
        scSendToAll = (UISegmentedControl*) [cell.contentView viewWithTag:2];
    
    if (!txtNotesRefCode)
    {
        txtNotesRefCode = (UITextField*) [cell.contentView viewWithTag:4];
        txtNotesRefCode.delegate = self;
        [txtNotesRefCode setKeyboardType:UIKeyboardTypeNumberPad];
    }
    
    if (assignValues) 
    {
        if ([currMode isEqualToString:@"L"]) 
            [self setValueforText:txtNotesRefCode andField:@"NOTESCODE"];
        
        if (_initDict)
            if ([_initDict valueForKey:@"SENDTOALL"]) 
            {
                scSendToAll.selectedSegmentIndex = [[_initDict valueForKey:@"SENDTOALL"] intValue];
                if (scSendToAll.selectedSegmentIndex>0) 
                    txtNotesRefCode.enabled = YES;
                else
                    txtNotesRefCode.enabled = NO;
            }
        if ([currMode isEqualToString:@"I"]) 
        {
            scSendToAll.selectedSegmentIndex = 0;
            txtNotesRefCode.enabled = NO;
        }
        else
        {
            scSendToAll.selectedSegmentIndex = [[_initDict valueForKey:@"SENDTOALL"] intValue];
            if (scSendToAll.selectedSegmentIndex>0) 
                txtNotesRefCode.enabled = YES;
            else
                txtNotesRefCode.enabled = NO;
        }
        if ([currMode isEqualToString:@"L"]==NO) 
            txtNotesRefCode.enabled = YES;
        else
            txtNotesRefCode.enabled = NO;
        
    }
    return cell;
}


- (UITableViewCell*) getFirstRowCell
{
    BOOL assignValues = NO;
    UIButton *btnSelNotesType;
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
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Notes Type"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        lbl2.text = [[NSString stringWithFormat:@"%@ ",@"Entry Date"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtNotesType)
    {
        txtNotesType = (UITextField*) [cell.contentView viewWithTag:2];
        txtNotesType.delegate = self;
    }
    if (!txtEntryDate)
    {
        txtEntryDate = (UITextField*) [cell.contentView viewWithTag:4];
        txtEntryDate.delegate = self;
        if ([currMode isEqualToString:@"I"]) 
            txtEntryDate.text = [nsdf stringFromDate:[NSDate date]];
    }
    btnSelNotesType =(UIButton*) [cell.contentView viewWithTag:5];
    if (!btnSelNotesType) 
    {
        btnSelNotesType = [[UIButton alloc] initWithFrame:CGRectMake(txtNotesType.frame.origin.x+txtNotesType.frame.size.width-25, 5, 25, txtNotesType.frame.size.height)];
        btnSelNotesType.titleLabel.text=@"";
        [btnSelNotesType setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
        [btnSelNotesType addTarget:self action:@selector(getNotesType:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnSelNotesType]; 
        [txtNotesType setFrame:CGRectMake(txtNotesType.frame.origin.x, txtNotesType.frame.origin.y, txtNotesType.frame.size.width -25, txtNotesType.frame.size.height)];
    }        
    if (assignValues) 
    {
        [self setValueforText:txtNotesType andField:@"NOTESTYPE"];
        if ([currMode isEqualToString:@"I"]) 
            txtEntryDate.text = [nsdf stringFromDate:[NSDate date]];
        else
            [self setValueforText:txtEntryDate andField:@"ENTRYDATE"];
    }
    txtNotesType.enabled = NO;
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
        switch (alertView.tag) {
            case 5:
                txtStartDate.text = [nsdf stringFromDate:date];
                break;
            case 6:
                txtEndDate.text = [nsdf stringFromDate:date];
                break;
            default:
                break;
        }
    }
}


- (void) setFieldsEntryStatus:(BOOL) p_Status
{
    if (txtNotes) txtNotes.enabled = p_Status;
    if (txtNotesRefCode) txtNotesRefCode.enabled = p_Status;
    if (scSendToAll) scSendToAll.enabled = p_Status;
}

- (void) clearScreen
{
    txtNotesType.text = @"";
    txtEntryDate.text = @"";
    txtNotes.text = @"";
    scSendToAll.selectedSegmentIndex = 0;
    txtStartDate.text = @"";
    txtEndDate.text = @"";
    txtNotesRefCode.text = @"";
    _notesType = 0;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:txtNotes])
        [txtNotes resignFirstResponder];
    else if ([textField isEqual:txtNotesRefCode])
        [txtNotesRefCode resignFirstResponder];
    else
        [textField resignFirstResponder];
    return NO;
}

- (void) getNotesType : (id) sender
{
    if ([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"SelectNotesType"] forKey:@"notify"];
        _notesTypeNotificaiton(returnInfo);
    }    
}

- (void) setNotesType:(NSDictionary*) p_noteTypeInfo
{
    NSDictionary *recdData = [p_noteTypeInfo valueForKey:@"data"];
    if (txtNotesType) 
    {
        txtNotesType.text = [recdData valueForKey:@"DISPTEXT"];
        _notesType = [[recdData valueForKey:@"RESULTVALUE"] intValue];
    }    
}

- (BOOL) validateEntries
{
    BOOL l_resultVal;
    
    l_resultVal = [self emptyCheckResult:txtNotesType andMessage:@"Notes type should be selected"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtNotes andMessage:@"Notes should be entered"];
    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtStartDate andMessage:@"Startdate should be selected"];

    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtEndDate andMessage:@"End date should be selected"];

    
    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtNotesRefCode andMessage:@"Notes Code should be entered"];

    
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
     
     
     #define MEMBERNOTES_XML @"<NOTESDATA><MEMBERNOTESID>%d</MEMBERNOTESID><MEMBERID>%d</MEMBERID><NOTES>%@</NOTES><USERCODE>%@</USERCODE><STARTDATE>%@</STARTDATE><ENDDATE>%@</ENDDATE><NOTESCODE>%@</NOTESCODE><NOTESTYPE>%d</NOTESTYPE><SENDTOALL>%d</SENDTOALL><ENTRYDATE>%@</ENTRYDATE></NOTESDATA>"
     */
    NSUserDefaults *stdUserDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableString *l_retXML = [[NSMutableString alloc] init];
    if ([currMode isEqualToString:@"I"]) 
    {
        l_retXML = [NSString stringWithFormat:MEMBERNOTES_XML, 0, [[_mbrDict valueForKey:@"MEMBERID"] intValue], txtNotes.text, [stdUserDefaults valueForKey:@"USERCODE"],txtStartDate.text, txtEndDate.text, txtNotesRefCode.text, _notesType, scSendToAll.selectedSegmentIndex, txtEntryDate.text];
    }
    if ([currMode isEqualToString:@"U"]) 
    {
        /*l_retXML = [NSString stringWithFormat:MEMBERTRANSMAS_XML, [[_initDict valueForKey:@"ENTRYID"] intValue] , [_initDict valueForKey:@"ENTRYNO"] , txtEntryDate.text,[[_mbrDict valueForKey:@"MEMBERID"] intValue], txtAmountPaid.text,  txtNotes.text, @"C", scPaymode.selectedSegmentIndex , txtChequeNo.text , txtChequeDate.text , _bankId];
        for (NSDictionary *tmpDict in woAdjDetail) 
        {
            l_DetailXML = [NSString stringWithFormat:MEMBERTRANSDET_XML, [[tmpDict valueForKey:@"ENTRYDETID"] intValue], [[tmpDict valueForKey:@"MBRPLANSCHEID"] intValue], [tmpDict valueForKey:@"ACTUALAMT"], [tmpDict valueForKey:@"PENDINGAMT"], [tmpDict valueForKey:@"ADJUSTEDAMT"]];
            l_retXML = [NSString stringWithFormat:@"%@%@",l_retXML,l_DetailXML];
        }*/
    }
    //l_retXML = [NSString stringWithFormat:@"%@",l_retXML, @"</TRANSDATA>"];
    //NSLog(@"edit saving info %@",l_retXML);
    l_retXML = (NSMutableString*) [self htmlEntitycode:l_retXML];
    return l_retXML;
}


@end
