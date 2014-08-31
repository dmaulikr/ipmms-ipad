//
//  memberPlansList.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 17/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberPlansList.h"

@implementation memberPlansList

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation  andControllerCallBack:(METHODCALLBACK) p_controllerCallBack andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        myFrame = frame;
        bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:bgcolor];
        intOrientation = p_intOrientation;
        _controllerCallBack = p_controllerCallBack;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"MEMBERPLANSLIST"];
        _naviButtonsCallback = p_naviButtonsCallback;
        //_proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLMEMBERPLANS"];
        //_gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        currMode = [[NSString alloc] initWithFormat:@"%@", @"L"];
        [actIndicator startAnimating];
        sBar.hidden = YES;
        navBar.hidden = YES;
        frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];
        btnInsert = [[NSDictionary alloc] initWithObjectsAndKeys:@"Insert", @"btntitle",  nil];
        //btnView = [[NSDictionary alloc] initWithObjectsAndKeys:@"View", @"btntitle",@"navigateMemberController",@"btnnotification" ,  nil];
        //btnView = [[NSDictionary alloc] initWithObjectsAndKeys:@"View", @"btntitle",  nil];
        /*btnMember = [[NSDictionary alloc] initWithObjectsAndKeys:@"Member", @"btntitle",@"navigateMexmberController",@"btnnotification" ,  nil];
        btnTrans = [[NSDictionary alloc] initWithObjectsAndKeys:@"Payments", @"btntitle",@"navigateMxemberController",@"btnnotification" ,  nil];
        btnNotes = [[NSDictionary alloc] initWithObjectsAndKeys:@"Notes", @"btntitle",@"navigateMembxerController",@"btnnotification" ,  nil];
        btnRefunds = [[NSDictionary alloc] initWithObjectsAndKeys:@"Refunds", @"btntitle",@"navigatexMemberController",@"btnnotification" ,  nil];*/
        //[self generateData];
        memPlanView = [[memberPlanEntry alloc] initWithFrame:myFrame andOrientation:intOrientation andControllerCallBack:_controllerCallBack andNaviButtonsCallback:_naviButtonsCallback];
        memPlanView.tag = 5001;
    }
    return self;
}

- (void) releaseViewObjects
{
    [memPlanView releaseViewObjects];
    memPlanView = nil;
}


- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_initDict valueForKey:@"MEMBERID"], @"p_memberid" , nil];
        METHODCALLBACK l_memListReturn = ^(NSDictionary *p_dictInfo)
        {
            [self memberListDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andReturnMethod:l_memListReturn];
        refreshTag = 0;
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    //[super setForOrientation:p_forOrientation]; 
    [self generateTableView];
}


- (void) memberListDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    viewItemNo = 0;
    curIndPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[returnInfo setValue:[dataForDisplay objectAtIndex:0] forKey:@"data"];
    [self setForOrientation:intOrientation];
    if ([dataForDisplay count]==0) 
        barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnInsert,[NSString stringWithFormat:@"%d",1], titleName ,@"navititle" , bgcolor, @"bgcolor",  nil];
    else
    {
        NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
        [nsdf setDateFormat:@"dd-MMM-yyyy"];
        NSDictionary *tmpDict = [dataForDisplay objectAtIndex:0];
        //NSLog(@"tmp dict info %@ and date is %@", tmpDict,[nsdf dateFromString:[tmpDict valueForKey:@"ENDDATE"]]);
        NSDate *ctrctDate = [nsdf dateFromString:[tmpDict valueForKey:@"ENDDATE"]];
        NSTimeInterval timeInterval = [ctrctDate timeIntervalSinceDate:[NSDate date]];
        if (timeInterval<0) 
            barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnInsert,[NSString stringWithFormat:@"%d",1] , titleName ,@"navititle" , bgcolor, @"bgcolor",  nil];
        else
            barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys: titleName ,@"navititle" , bgcolor, @"bgcolor",  nil];
    }
    _naviButtonsCallback(barButtonInfo);
    populationOnProgress = NO;
}

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

-(void) setKeyDictionary:(NSDictionary *)p_keyDict
{
    //[memPlanView setKeyDictionary:p_keyDict];
    _initDict = p_keyDict;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return  [[NSString stringWithString:@"    Plan Name             Period        Status         Bill Cycle         Amt."] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
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
    return  45.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[self removeFromSuperview];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UIButton *btnView;
    //UILabel *lblFN, *lblLN, *lblGender, *lblNation, *lblAge;
    UILabel *lblPlanDesc, *lblPeriod, *lblStatus, *lblcycleName, *lbltotAmount;
    NSString *planDesc, *period, *currStatus, *cycleName, *totAmount;
    int activeStatus = 1;
    int labelHeight = 43;
    int lblShortWidth, lblLongWidth, xPosition, xWidth;
    lblShortWidth = 93; lblLongWidth = 167;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        
        xPosition = 0; xWidth = lblLongWidth;
        lblPlanDesc = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblPlanDesc.font = [UIFont systemFontOfSize:14.0f];
        [lblPlanDesc setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblPlanDesc.tag = 1;
        lblPlanDesc.numberOfLines = 2;
        [cell.contentView addSubview:lblPlanDesc];
        
        xPosition += xWidth; xWidth = lblShortWidth-8;
        lblPeriod = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblPeriod.font = [UIFont systemFontOfSize:12.0f];
        [lblPeriod setBackgroundColor:[UIColor colorWithRed:190.0/255.0f green:148.0f/255.0f blue:78.0f/255.0f alpha:1.0]];
        lblPeriod.textAlignment = UITextAlignmentCenter;
        lblPeriod.tag = 2;
        lblPeriod.numberOfLines = 2;
        [cell.contentView addSubview:lblPeriod];
        
        xPosition += xWidth; xWidth = lblShortWidth-8;
        lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblStatus.font = [UIFont systemFontOfSize:12.0f];
        [lblStatus setBackgroundColor:[UIColor colorWithRed:175.0f/255.0f green:163.0f/255.0f blue:93.0f/255.0f alpha:1.0]];
        lblStatus.textAlignment = UITextAlignmentCenter;
        lblStatus.tag = 3;
        lblStatus.numberOfLines = 2;
        [cell.contentView addSubview:lblStatus];
        
        xPosition += xWidth; xWidth = lblLongWidth-20;
        lblcycleName = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblcycleName.font = [UIFont systemFontOfSize:12.0f];
        [lblcycleName setBackgroundColor:[UIColor colorWithRed:160.0f/255.0f green:178.0f/255.0f blue:113.0f/255.0f alpha:1.0]];
        lblcycleName.tag = 4;
        lblcycleName.numberOfLines = 2;
        [lblcycleName setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:lblcycleName];
        
        xPosition += xWidth; xWidth = lblShortWidth-9;
        lbltotAmount = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lbltotAmount.font = [UIFont systemFontOfSize:12.0f];
        [lbltotAmount setBackgroundColor:[UIColor colorWithRed:145.0f/255.0f green:193.0f/255.0f blue:128.0f/255.0f alpha:0.4]];
        lbltotAmount.tag = 5;
        [lbltotAmount setTextAlignment:UITextAlignmentRight];
        [cell.contentView addSubview:lbltotAmount];
        
        xPosition += xWidth;
        btnView = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, 0, 45, 45)];
        btnView.titleLabel.textColor = btnView.titleLabel.backgroundColor;
        btnView.tag = 6;
        [btnView setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnView addTarget:self action:@selector(viewSelectedItem:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnView];
    }
    
    planDesc = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"PLANDESC"]];
    period = [[NSString alloc] initWithFormat:@"%@\n%@", [tmpDict valueForKey:@"STARTDATE"],[tmpDict valueForKey:@"ENDDATE"]];
    activeStatus = [[tmpDict valueForKey:@"CURRSTATUS"] intValue];
    if (activeStatus==0) 
        currStatus = [[NSString alloc] initWithFormat:@"Terminated\n(%@)", [tmpDict valueForKey:@"TERMINATIONDATE"]];
    else
        currStatus = [[NSString alloc] initWithString:@"Active"];
    
    cycleName = [[NSString alloc] initWithFormat:@" %@", [tmpDict valueForKey:@"CYCLENAME"]];
    totAmount = [[NSString alloc] initWithFormat:@"%@ ", [frm stringFromNumber:[NSNumber numberWithDouble:[[tmpDict valueForKey:@"TOTALAMOUNT"] doubleValue]]]];
    
    lblPlanDesc = (UILabel*) [cell.contentView viewWithTag:1];
    lblPlanDesc.text = planDesc;
    
    lblPeriod = (UILabel*) [cell.contentView viewWithTag:2];
    lblPeriod.text = period;
    
    lblStatus = (UILabel*) [cell.contentView viewWithTag:3];
    lblStatus.text = currStatus;
    
    lblcycleName = (UILabel*) [cell.contentView viewWithTag:4];
    lblcycleName.text = cycleName;
    
    lbltotAmount = (UILabel*) [cell.contentView viewWithTag:5];
    lbltotAmount.text = totAmount;
    
    btnView = (UIButton*) [cell.contentView viewWithTag:6];
    btnView.titleLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    
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

- (void) setInsertMode
{
    currMode = @"I";
    //memPlanView = [[memberPlanEntry alloc] initWithDictionary:_initDict andFrame:myFrame andOrientation:intOrientation forMode:@"I"];
    [memPlanView setKeyDictionary:_initDict];
    [memPlanView setInsertMode];
    [self addSubview:memPlanView];
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    titleName = [[NSString alloc] initWithFormat:@"CONTRACTS"] ;
    currMode = @"L";
    _initDict = [NSDictionary dictionaryWithDictionary:p_dictData];
    [[self viewWithTag:5001] removeFromSuperview];
    [self generateData];
}

- (void) setEditMode
{
    currMode = @"U";
    [memPlanView setEditMode];
}

- (void) executeCancel
{
    currMode = @"L";
    [memPlanView releaseViewObjects];
    [memPlanView removeFromSuperview];
    _naviButtonsCallback(barButtonInfo);
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    /*if ([currMode isEqualToString:@"I"]) 
     {
     [dataForDisplay insertObject:p_savedInfo atIndex:0];
     curIndPath = [NSIndexPath indexPathForRow:0 inSection:0];
     NSArray *updateInfo = [[NSArray alloc] initWithObjects:curIndPath, nil];
     [dispTV reloadData];
     [dispTV reloadRowsAtIndexPaths:updateInfo withRowAnimation:UITableViewRowAnimationNone];
     [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionTop];
     }
     if ([currMode isEqualToString:@"U"]) 
     {
     NSArray *updateInfo = [[NSArray alloc] initWithObjects:curIndPath, nil];
     [dataForDisplay replaceObjectAtIndex:viewItemNo withObject:p_savedInfo];
     [dispTV reloadRowsAtIndexPaths:updateInfo withRowAnimation:UITableViewRowAnimationNone];
     [dispTV selectRowAtIndexPath:curIndPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
     }*/
    //[memPlanView removeFromSuperview];
    //memPlanView = nil;
    [self setListMode:_initDict];
    currMode = @"L";
}

- (IBAction)viewSelectedItem:(id)sender
{
    UIButton *btnclicked = (UIButton*) sender;
    int selIndex = [btnclicked.titleLabel.text intValue];
    if ([currMode isEqualToString:@"L"]) 
    {
        [memPlanView setKeyDictionary:_initDict];
        [self addSubview:memPlanView];
        [memPlanView setListMode:[dataForDisplay objectAtIndex:selIndex]];
    }
}

- (void) executeSave
{
    [memPlanView executeSave];    
}

@end
