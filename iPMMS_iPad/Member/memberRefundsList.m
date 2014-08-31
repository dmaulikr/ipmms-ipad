//
//  memberRefundsList.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 4/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberRefundsList.h"

@implementation memberRefundsList

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andDictionary:(NSDictionary*) p_initDict andControllerCallBack:(METHODCALLBACK) p_controllerCallBack andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:bgcolor];
        intOrientation = p_intOrientation;
        _controllerCallBack = p_controllerCallBack;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"GETMEMBERREFUNDSLIST"];
        //_proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLMEMBERREFUNDS"];
        //_gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        _initDict = [NSDictionary dictionaryWithDictionary:p_initDict];
        _naviButtonsCallback = p_naviButtonsCallback;
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        currMode = [[NSString alloc] initWithFormat:@"%@", @"L"];
        [actIndicator startAnimating];
        sBar.hidden = YES;
        navBar.hidden = YES;
        nsdf = [[NSDateFormatter alloc] init];
        [nsdf setDateFormat:@"dd-MMM-yyyy HH:mm:ss"];
        frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];
        memRefEntry = [[memberRefundEntry alloc] initWithDictionary:_initDict andFrame:self.frame andOrientation:intOrientation forMode:@"L" andControllerCallback:_controllerCallBack andNaviButtonsCallback:_naviButtonsCallback];
        btnInsert = [[NSDictionary alloc] initWithObjectsAndKeys:@"Insert", @"btntitle",  nil];
        /*btnMember = [[NSDictionary alloc] initWithObjectsAndKeys:@"Member", @"btntitle",@"navigateMexmberController",@"btnnotification" ,  nil];
        btnContract = [[NSDictionary alloc] initWithObjectsAndKeys:@"Contract", @"btntitle",@"navigatexMemberController",@"btnnotification" ,  nil];
        btnTrans = [[NSDictionary alloc] initWithObjectsAndKeys:@"Payments", @"btntitle",@"navigatexMemberController",@"btnnotification" ,  nil];
        btnNotes = [[NSDictionary alloc] initWithObjectsAndKeys:@"Notes", @"btntitle",@"navigateMexmberController",@"btnnotification" ,  nil];*/
    }
    return self;
}

- (void) releaseViewObjects
{
    [memRefEntry releaseViewObjects];
    memRefEntry = nil;
}

- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_initDict valueForKey:@"MEMBERID"], @"p_memberid" , nil];
        METHODCALLBACK l_refundListReturn = ^(NSDictionary *p_dictInfo)
        {
            [self memberRefundsListDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andReturnMethod:l_refundListReturn];
        refreshTag = 0;
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    //[super setForOrientation:p_forOrientation]; 
    [self generateTableView];
}


- (void) memberRefundsListDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    //NSLog(@"received array list %@", dataForDisplay);
    /*if ([sBar.text isEqualToString:@""]) 
     {
     NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
     if ([dataForDisplay count]==0) 
     [stdDefaults setValue:nil forKey:_cacheName];
     else
     [stdDefaults setValue:dataForDisplay forKey:_cacheName];
     }*/
    //NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    viewItemNo = 0;
    curIndPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[returnInfo setValue:[dataForDisplay objectAtIndex:0] forKey:@"data"];
    [self setForOrientation:intOrientation];
    populationOnProgress = NO;
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
    //[super generateTableView];
    int ystartPoint;
    int sBarwidth;
    int reqdHeight;
    //return;
    if (dispTV) 
    {
        //[dispTV removeFromSuperview];
        if (UIInterfaceOrientationIsPortrait(intOrientation)) 
            [actIndicator setFrame:CGRectMake(330, 281, 37, 37)];
        else
            [actIndicator setFrame:CGRectMake(330, 361, 37, 37)];
        [dispTV reloadData];
        [actIndicator stopAnimating];
        return;
    }
    CGRect tvrect;
    ystartPoint = 1;
    reqdHeight =  (768-45-1)/45;
    reqdHeight = reqdHeight*45;
    if (UIInterfaceOrientationIsPortrait(intOrientation)) 
    {
        sBarwidth = 320;
        tvrect = CGRectMake(0, ystartPoint, 703, 600);
        [actIndicator setFrame:CGRectMake(330, 281, 37, 37)];
    }
    else
    {
        sBarwidth = 320;
        tvrect = CGRectMake(0, ystartPoint, 703,reqdHeight);
        [actIndicator setFrame:CGRectMake(330, 361, 37, 37)];
    }
    [sBar setFrame:CGRectMake(0, 0, sBarwidth, sBar.bounds.size.height)];
    dispTV = [[UITableView alloc] initWithFrame:tvrect style:UITableViewStyleGrouped];
    [self addSubview:dispTV];
    [dispTV setBackgroundView:nil];
    [dispTV setBackgroundView:[[UIView alloc] init]];
    [dispTV setBackgroundColor:UIColor.clearColor];
    [actIndicator stopAnimating];
    
    [dispTV setDelegate:self];
    [dispTV setDataSource:self];
    [dispTV reloadData];
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
 {
 NSString *key;
 if (UIInterfaceOrientationIsPortrait(intOrientation))
 key =  [[NSString alloc] initWithString:@"     Cust Code                       Customer Name"];
 else
 key =  [[NSString alloc] initWithString:@"     Cust Code                                              Customer Name"];
 key = [key stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
 return key;
 }
 */

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  [[NSString stringWithString:@" No & Dt.       Period                      Notes                                Ref. Amt"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataForDisplay count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  50.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self removeFromSuperview];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*switch (indexPath.row) {
     case 0:
     break;
     default:
     break;
     }
     return nil;*/
    return [self getDisplayCellforRow:indexPath.row];
}

- (UITableViewCell*) getDisplayCellforRow:(int) p_RowNo
{
    static NSString *cellid=@"cellDisplay";
    UIButton *btnView;
    UITableViewCell  *cell = [dispTV dequeueReusableCellWithIdentifier:cellid];
    UILabel *lblRefundData, *lblPeriod, *lblNotes,*lblRefundAmt;
    NSString *refdata, *period, *notes, *refamt;
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:p_RowNo];
    int labelHeight = 49;
    int lblShortWidth, lblLongWidth, xPosition, xWidth;
    lblShortWidth = 100; lblLongWidth = 265;
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        UIFont *txtfont = [UIFont systemFontOfSize:14.0f];
        
        cell.backgroundColor = [UIColor clearColor];
        xPosition = 0; xWidth = lblShortWidth-1;
        lblRefundData = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblRefundData.font = txtfont;
        [lblRefundData setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        //[lblEntryDate setBackgroundColor:[UIColor whiteColor]];
        lblRefundData.tag = 1;
        lblRefundData.numberOfLines = 2;
        [lblRefundData setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:lblRefundData];
        
        xPosition += xWidth; xWidth = lblShortWidth-1;
        lblPeriod = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblPeriod.font = txtfont;
        [lblPeriod setBackgroundColor:[UIColor colorWithRed:190.0f/255.0f green:148.0f/255.0f blue:78.0f/255.0f alpha:1.0]];
        //[lblNotes setBackgroundColor:[UIColor whiteColor]];
        lblPeriod.tag = 2;
        lblPeriod.numberOfLines = 2;
        [lblPeriod setTextAlignment:UITextAlignmentCenter];
        [cell.contentView addSubview:lblPeriod];
        
        xPosition += xWidth; xWidth = lblLongWidth-1;
        lblNotes = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblNotes.font = txtfont;
        [lblNotes setBackgroundColor:[UIColor colorWithRed:160.0f/255.0f green:178.0f/255.0f blue:113.0f/255.0f alpha:1.0]];
        //[lblStartDate setBackgroundColor:[UIColor whiteColor]];
        lblNotes.tag = 3;
        lblNotes.numberOfLines = 2;
        [lblNotes setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:lblNotes];
        
        xPosition += xWidth; xWidth = lblShortWidth-1;
        lblRefundAmt = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblRefundAmt.font = txtfont;
        [lblRefundAmt setBackgroundColor:[UIColor colorWithRed:145.0f/255.0f green:193.0f/255.0f blue:128.0f/255.0f alpha:0.4]];
        //[lblEndDate setBackgroundColor:[UIColor whiteColor]];
        lblRefundAmt.tag = 4;
        lblRefundAmt.numberOfLines= 1;
        [lblRefundAmt setTextAlignment:UITextAlignmentRight];
        [cell.contentView addSubview:lblRefundAmt];

        xPosition += xWidth;
        btnView = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, 0, 45, 45)];
        btnView.titleLabel.textColor = btnView.titleLabel.backgroundColor;
        btnView.tag = 6;
        [btnView setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnView addTarget:self action:@selector(viewSelectedItem:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnView];
    }
    
    refdata = [[NSString alloc] initWithFormat:@"%@\n%@",[tmpDict valueForKey:@"REFUNDNO"], [tmpDict valueForKey:@"REFUNDDATE"]];
    period = [[NSString alloc] initWithFormat:@"%@\n%@", [tmpDict valueForKey:@"EFFECTIVEDATE"],[tmpDict valueForKey:@"TERMINATIONDATE"]];
    notes = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"NOTES"]];
    refamt = [[NSString alloc] initWithFormat:@"%@ ", [frm stringFromNumber:[NSNumber numberWithDouble:[[tmpDict valueForKey:@"REFUNDAMOUNT"] doubleValue]]]];
    
    lblRefundData = (UILabel*) [cell.contentView viewWithTag:1];
    lblRefundData.text = refdata;
    
    lblPeriod = (UILabel*) [cell.contentView viewWithTag:2];
    lblPeriod.text = period;
    
    lblNotes = (UILabel*) [cell.contentView viewWithTag:3];
    lblNotes.text = notes;
    
    lblRefundAmt = (UILabel*) [cell.contentView viewWithTag:4];
    lblRefundAmt.text = refamt;
    
    btnView = (UIButton*) [cell.contentView viewWithTag:6];
    btnView.titleLabel.text = [NSString stringWithFormat:@"%d", p_RowNo];

    return cell;
}

- (IBAction) refreshData:(id) sender
{
    [actIndicator setHidden:NO];
    [actIndicator startAnimating];
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    for (NSDictionary *tmpDict in dataForDisplay) 
    {
        NSString *imgName = [[NSString alloc] initWithFormat:@"Image%d",[tmpDict valueForKey:@"MEMBERID"]];
        [stdDefaults setValue:nil forKey:imgName];
    }
    //[dispTV removeFromSuperview];
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

- (void) setKeyDictionary:(NSDictionary *)p_keyDict
{
    _initDict = [NSDictionary dictionaryWithDictionary:p_keyDict];
}

- (void) setInsertMode
{
    currMode = @"I";
    [memRefEntry setInsertMode];
    [self addSubview:memRefEntry];
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    NSString *titleName = [[NSString alloc] initWithFormat:@"REFUNDS"] ;
    currMode = @"L";
    _initDict = [NSDictionary dictionaryWithDictionary:p_dictData];
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnInsert,[NSString stringWithFormat:@"%d",1] ,titleName ,@"navititle" , bgcolor, @"bgcolor",  nil];
    
    [memRefEntry setKeyDictionary:_initDict];
    [self generateData];
}

- (void) setEditMode
{
    currMode = @"U";
    [memRefEntry setEditMode];
}

- (void) executeCancel
{
    currMode = @"L";
    [memRefEntry removeFromSuperview];
    _naviButtonsCallback(barButtonInfo);
}

- (void) executeSave
{
    [memRefEntry executeSave];    
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    [memRefEntry removeFromSuperview];
    [self setListMode:_initDict];
}

- (IBAction)viewSelectedItem:(id)sender
{
    UIButton *btnclicked = (UIButton*) sender;
     int selIndex = [btnclicked.titleLabel.text intValue];
     if ([currMode isEqualToString:@"L"]) 
     {
         [memRefEntry setKeyDictionary:_initDict];
         [self addSubview:memRefEntry];
         [memRefEntry setListMode:[dataForDisplay objectAtIndex:selIndex]];
     }
}

@end
