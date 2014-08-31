//
//  feesDataEntry.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 22/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "feesDataEntry.h"

@implementation feesDataEntry

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation returnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback andFeesCallback:(METHODCALLBACK) p_feesCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [super addNIBView:@"getSearch" forFrame:frame];
        bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
        [super setViewBackGroundColor:bgcolor];
        intOrientation = p_intOrientation;
        //_gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        _returnMethod = p_returnMethod;
        _feesCallbacks = p_feesCallback;
        __block id myself = self;
        _fireCancelCallback = ^(NSDictionary *p_dictInfo)
        {
            [myself fireOptionsFeesServicesEntry:p_dictInfo];
        };
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        _naviButtonsCallback = p_naviButtonsCallback;
        currMode = [NSString stringWithString:@"E"];
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = YES;
        navBar.hidden = YES;
        lblTextColor = [UIColor whiteColor];
        [self generateTableView];
    }
    return self;
}

- (void) addNewFeesData
{
    _initDict = [NSDictionary dictionary];
    currMode = @"I";
    NSDictionary *buttonData = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",@"fireOptionsFeesServicesEntry",@"btnnotification" ,  nil];
    NSDictionary *buttonDone = [[NSDictionary alloc] initWithObjectsAndKeys:@"Done", @"btntitle",@"fireOptionsFeesServicesEntry",@"btnnotification" ,  nil];
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:buttonData,[NSString stringWithFormat:@"%d",101] , buttonDone, [NSString stringWithFormat:@"%d",102],  @"Fees / Services",@"navititle" ,bgcolor, @"bgcolor", nil];
    _naviButtonsCallback(barButtonInfo);
    if (txtFeesName) 
        txtFeesName.text = @"";
    if (txtAmount) 
        txtAmount.text = @"";
    _feesId = 0;
}

/*
- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        gymWSCorecall = [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:nil andNotificatioName:_proxynotification];
    }    
}
 */

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [super setForOrientation:p_forOrientation]; 
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) generateTableView
{
    int ystartPoint;
    int sBarwidth;
    //return;
    if (dispTV) 
        [dispTV removeFromSuperview];
    
    CGRect tvrect;
    if (sBar.hidden==YES) 
        ystartPoint = 35;
    else
        ystartPoint = 45;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        sBarwidth = 320;
        tvrect = CGRectMake(0, ystartPoint, 703, 1024);
        [actIndicator setFrame:CGRectMake(340, 490, 37, 37)];
    }
    else
    {
        sBarwidth = 320;
        tvrect = CGRectMake(0, ystartPoint, 703, 768);
        [actIndicator setFrame:CGRectMake(310, 361, 37, 37)];
    }
    //[sBar setFrame:CGRectMake(0, 0, sBarwidth, sBar.bounds.size.height)];
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStylePlain];
    [dispTV setBounces:NO];
    [self addSubview:dispTV];
    dispTV.separatorColor = [UIColor clearColor];
    [dispTV setBackgroundView:nil];
    [dispTV setBackgroundView:[[UIView alloc] init]];
    [dispTV setBackgroundColor:UIColor.clearColor];
    [actIndicator stopAnimating];
    
    [dispTV setDelegate:self];
    [dispTV setDataSource:self];
    [dispTV reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) 
    {
        case 0:
            return [self getFirstRowCell];
            break;
        case 1:
            return [self getSecondRowCell];
            break;
        default:
            break;
    }
    return nil;
}

- (UITableViewCell*) getSecondRowCell
{
    static NSString *cellid=@"cell2";
    BOOL assignValues = NO;
    UILabel *lbl1;
    UITextField *txt1;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =200; cellHeight = 40;
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        
        UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor=[dispTV backgroundColor];
        
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lblWidth, cellHeight)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [dispTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, 2*txtWidth+lblWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        //txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Amount"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtAmount)
    {
        txtAmount = (UITextField*) [cell.contentView viewWithTag:2];
        txtAmount.delegate = self;
        [txtAmount setKeyboardType:UIKeyboardTypeNumberPad];
        //txtAmount.enabled = NO;
    }
    if (assignValues) 
        [self setValueforText:txtAmount andField:@"FEEAMOUNT"];
    return cell;
}

- (UITableViewCell*) getFirstRowCell
{
    static NSString *cellid=@"cell1";
    BOOL assignValues = NO;
    UIButton *btnFeesSelect;
    UILabel *lbl1;
    UITextField *txt1;
    int   lblWidth, txtWidth, cellHeight ;
    lblWidth = 116; txtWidth =200; cellHeight = 40;
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        
        UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
        cell.backgroundColor=[dispTV backgroundColor];
        
        lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lblWidth, cellHeight-1)];
        lbl1.font = txtfont;
        lbl1.textAlignment = UITextAlignmentRight;
        lbl1.tag = 1;
        lbl1.backgroundColor = [dispTV backgroundColor];
        lbl1.textColor = lblTextColor;
        [cell.contentView addSubview:lbl1];
        
        txt1 = [[UITextField alloc] initWithFrame:CGRectMake(lblWidth, 5, 2*txtWidth+lblWidth, cellHeight-5)];
        txt1.font = txtfont;
        txt1.textAlignment = UITextAlignmentLeft;
        txt1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        txt1.tag = 2;
        //txt1.backgroundColor = lblTextColor;
        txt1.borderStyle = UITextBorderStyleRoundedRect;
        [cell.contentView addSubview:txt1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl1 = (UILabel*) [cell.contentView viewWithTag:1];
        lbl1.text = [[NSString stringWithFormat:@"%@ ",@"Fees / Services"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
        assignValues = YES;
    }
    if (!txtFeesName)
    {
        txtFeesName = (UITextField*) [cell.contentView viewWithTag:2];
        txtFeesName.delegate = self;
        btnFeesSelect =(UIButton*) [cell.contentView viewWithTag:3];
        if (!btnFeesSelect) 
        {
            btnFeesSelect = [[UIButton alloc] initWithFrame:CGRectMake(txtFeesName.frame.origin.x+txtFeesName.frame.size.width-25, 5, 25, txtFeesName.frame.size.height)];
            btnFeesSelect.titleLabel.text=@"";
            [btnFeesSelect setImage:[UIImage imageNamed:@"s.png"] forState:UIControlStateNormal];
            [btnFeesSelect addTarget:self action:@selector(getFeesValues:) forControlEvents:UIControlEventTouchDown];
            btnFeesSelect.tag = 6;
            [cell.contentView addSubview:btnFeesSelect]; 
        }
        [txtFeesName setFrame:CGRectMake(txtFeesName.frame.origin.x, txtFeesName.frame.origin.y, txtFeesName.frame.size.width -25, txtFeesName.frame.size.height)];
        btnFeesSelect.hidden = NO;
        txtFeesName.enabled = NO;
    }
    if (assignValues) 
        [self setValueforText:txtFeesName andField:@"FEENAME"];

    return cell;
}


- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    [dispTV removeFromSuperview];
    refreshTag = 1;
    [self generateData];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [super searchBarTextDidBeginEditing:searchBar];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [super searchBarTextDidEndEditing:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [super searchBarCancelButtonClicked:searchBar];
}

// called when Search (in our case “Done”) button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([currMode isEqualToString:@"L"]) 
    {
        [super searchBarSearchButtonClicked:searchBar];
        [self generateData];
    }
    else
        sBar.text = @"";
}

- (IBAction) goBack:(id) sender
{
    
}

- (void) getFeesValues:(id) sender
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"SelectFee"] forKey:@"notify"];
    _feesCallbacks(returnInfo);
}

- (void) setFeesValues:(NSDictionary*) p_feesInfo
{
    NSDictionary *recdData = [p_feesInfo valueForKey:@"data"];
    //NSLog(@"received fee info %@", recdData);
    if (txtFeesName) 
    {
        txtFeesName.text = [recdData valueForKey:@"FEENAME"];
        _feesId = [[recdData valueForKey:@"FEESID"] intValue];
    }
    _naviButtonsCallback(barButtonInfo);
}

- (void) fireOptionsFeesServicesEntry:(NSDictionary*) executionInfo
{
    int pressedButton = [[executionInfo valueForKey:@"data"] intValue];
    if (pressedButton==101) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:[NSString stringWithString:@"FeesCancel"] forKey:@"notify"];
        [returnInfo setValue:nil forKey:@"data"];
        _returnMethod(returnInfo);
    }
    if (pressedButton==102) 
    {
        if ([self validateData]) 
        {
            NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithDictionary:_initDict];
            [retDict setValue:[NSString stringWithFormat:@"%d", _feesId] forKey:@"FEESID"];
            [retDict setValue:txtFeesName.text forKey:@"FEENAME"];
            [retDict setValue:txtAmount.text forKey:@"FEEAMOUNT"];
            //NSDictionary *retDict = [NSDictionary dictionaryWithObjectsAndKeys:txtFeesName.text, @"FEENAME", , @"FEESID", txtAmount.text, @"FEEAMOUNT"  , nil];
            NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
            [returnInfo setValue:[NSString stringWithString:@"FeesDone"] forKey:@"notify"];
            [returnInfo setValue:retDict forKey:@"data"];
            [returnInfo setValue:currMode forKey:@"opmode"];
            if ([currMode isEqualToString:@"U"]) 
                [returnInfo setValue:[NSString stringWithFormat:@"%d", editRecordNo]   forKey:@"recordno"];
                
            _returnMethod(returnInfo);
        }
    }
}

- (BOOL) validateData
{
    BOOL l_resultVal;
    
    l_resultVal = [self emptyCheckResult:txtFeesName andMessage:@"Fees should be selected"];

    if (l_resultVal==NO) 
        return l_resultVal;
    else
        l_resultVal = [self emptyCheckResult:txtAmount andMessage:@"Amount should be entered"];
    
    if (l_resultVal==NO) return l_resultVal;
    
    if (_feesId==0) 
    {
        [self emptyCheckResult:txtFeesName andMessage:@"Fees should be selected"];
        l_resultVal = NO;
    }
    
    if (l_resultVal==NO) return l_resultVal;
    
    

    if ([txtAmount.text intValue]==0) 
    {
        NSLog(@"the txt amount value is %d", [txtAmount.text intValue]);
        [self showAlertMessage:@"Amount should be a valid numeric value"];
        //[self emptyCheckResult:txtAmount andMessage:@"Amount should be a valid numeric value"];
        l_resultVal = NO;
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

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([textField isEqual:txtAmount])
         [txtAmount resignFirstResponder];

    return NO;
}

- (void) editFeesData:(NSDictionary*) p_feeData forRowNo:(int) p_rowNo
{
    currMode = @"U";
    //NSLog(@"the received dictionary is %@", p_feeData);
    _initDict = [NSDictionary dictionaryWithDictionary:p_feeData];
    editRecordNo = p_rowNo;
    NSDictionary *buttonData = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle", _fireCancelCallback,@"btnnotification" ,  nil];
    NSDictionary *buttonDone = [[NSDictionary alloc] initWithObjectsAndKeys:@"Done", @"btntitle",_fireCancelCallback,@"btnnotification" ,  nil];
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:buttonData,[NSString stringWithFormat:@"%d",101] , buttonDone, [NSString stringWithFormat:@"%d",102],  @"Fees / Services",@"navititle" ,bgcolor, @"bgcolor", nil];
    _naviButtonsCallback(barButtonInfo);
    [self displayDictDataForMode:nil];
}

- (void) setValueforText:(UITextField*) p_passField andField:(NSString*) p_fieldName
{
    if (p_passField) 
        if ([_initDict valueForKey:p_fieldName]) 
            p_passField.text = [_initDict valueForKey:p_fieldName];
        else
            p_passField.text = @"";
    
    if ([p_fieldName isEqualToString:@"FEENAME"]) 
    {
        _feesId = [[_initDict valueForKey:@"FEESID"] intValue];
    }
    
    if ([p_fieldName isEqualToString:@"FEEAMOUNT"]) 
    {
        /*NSNumberFormatter *frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];*/
        //double totamount  = [[_initDict valueForKey:@"FEEAMOUNT"] doubleValue];
        //p_passField.text = [[[NSString alloc]initWithFormat:@" %@   ",[_initDict valueForKey:@"FEEAMOUNT"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    }
}

- (void) displayDictDataForMode:(NSString*) p_dispmode
{
    [self setValueforText:txtFeesName andField:@"FEENAME"];
    [self setValueforText:txtAmount andField:@"FEEAMOUNT"];
}

@end
