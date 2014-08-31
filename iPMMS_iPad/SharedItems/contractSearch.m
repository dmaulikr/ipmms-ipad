//
//  contractSearch.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "contractSearch.h"

@implementation contractSearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andDictionary:(NSDictionary*) p_initDict andReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsMethod:(METHODCALLBACK) p_naviButtonsCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:bgcolor];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"TERMINATEDCONTRACTSLIST"];
        //_proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLCONTRACTSTERMINATED"];
        //_gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        _initDict = [NSDictionary dictionaryWithDictionary:p_initDict];
        _returnMethod = p_returnMethod;
        _naviButtonsCallback = p_naviButtonsCallback;
        __block id myself = self;
        _fireCancelMethod = ^(NSDictionary *p_dictInfo)
        {
            [myself fireCancelNotification:p_dictInfo];
        };
        
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = YES;
        navBar.hidden = YES;
        frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];
        NSDictionary *buttonData = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",_fireCancelMethod,@"btnnotification" ,  nil];
        NSDictionary *naviInfo = [[NSDictionary alloc] initWithObjectsAndKeys:buttonData,[NSString stringWithFormat:@"%d",101] , @"Select a Terminated Contract",@"navititle" ,nil];
        _naviButtonsCallback(naviInfo);
        [self generateData];
    }
    return self;
}


- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        METHODCALLBACK l_contractListReturn = ^(NSDictionary *p_dictInfo)
        {
            [self contractDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:_initDict andReturnMethod:l_contractListReturn];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [super setForOrientation:p_forOrientation]; 
}


- (void) contractDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    //NSLog(@"The contract data %@", [recdData valueForKey:@"data"]);
    [self setForOrientation:intOrientation];
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
    //return;
    if (dispTV) 
        [dispTV removeFromSuperview];
    
    CGRect tvrect;
    if (sBar.hidden==YES) 
        ystartPoint = 45;
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
    
    /*[dispTV setDelegate:self];
     [dispTV setDataSource:self];
     [dispTV reloadData];*/
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
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"contractSelected"] forKey:@"notify"];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    _returnMethod(returnInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    //UILabel *lblFN, *lblLN, *lblGender, *lblNation, *lblAge;
    UILabel *lblPlanDesc, *lblPeriod, *lblTermDate, *lblRecdAmount, *lbltotAmount;
    NSString *planDesc, *period, *termDate,  *totAmount, *recdAmount;
    int labelHeight = 43;
    int lblShortWidth, lblLongWidth, xPosition, xWidth;
    lblShortWidth = 111; lblLongWidth = 167;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        
        xPosition = 0; xWidth = lblLongWidth+40-1;
        lblPlanDesc = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblPlanDesc.font = [UIFont systemFontOfSize:14.0f];
        [lblPlanDesc setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblPlanDesc.tag = 1;
        lblPlanDesc.numberOfLines = 2;
        [cell.contentView addSubview:lblPlanDesc];
        
        xPosition += xWidth; xWidth = lblShortWidth-1;
        lblPeriod = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblPeriod.font = [UIFont systemFontOfSize:12.0f];
        [lblPeriod setBackgroundColor:[UIColor colorWithRed:190.0/255.0f green:148.0f/255.0f blue:78.0f/255.0f alpha:1.0]];
        lblPeriod.textAlignment = UITextAlignmentCenter;
        lblPeriod.tag = 2;
        lblPeriod.numberOfLines = 2;
        [cell.contentView addSubview:lblPeriod];
        
        xPosition += xWidth; xWidth = lblShortWidth-1;
        lblTermDate = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblTermDate.font = [UIFont systemFontOfSize:12.0f];
        [lblTermDate setBackgroundColor:[UIColor colorWithRed:175.0f/255.0f green:163.0f/255.0f blue:93.0f/255.0f alpha:1.0]];
        lblTermDate.textAlignment = UITextAlignmentCenter;
        lblTermDate.tag = 3;
        lblTermDate.numberOfLines = 2;
        [cell.contentView addSubview:lblTermDate];
        
        xPosition += xWidth; xWidth = lblShortWidth-20-1;
        lbltotAmount = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lbltotAmount.font = [UIFont systemFontOfSize:12.0f];
        [lbltotAmount setBackgroundColor:[UIColor colorWithRed:160.0f/255.0f green:178.0f/255.0f blue:113.0f/255.0f alpha:1.0]];
        lbltotAmount.tag = 4;
        lbltotAmount.numberOfLines = 2;
        [lbltotAmount setTextAlignment:UITextAlignmentRight];
        [cell.contentView addSubview:lbltotAmount];
        
        xPosition += xWidth; xWidth = lblShortWidth-20-1;
        lblRecdAmount = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblRecdAmount.font = [UIFont systemFontOfSize:12.0f];
        [lblRecdAmount setBackgroundColor:[UIColor colorWithRed:145.0f/255.0f green:193.0f/255.0f blue:128.0f/255.0f alpha:0.4]];
        lblRecdAmount.tag = 5;
        [lblRecdAmount setTextAlignment:UITextAlignmentRight];
        [cell.contentView addSubview:lblRecdAmount];
        
    }
    
    planDesc = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"PLANDESC"]];
    period = [[NSString alloc] initWithFormat:@"%@\n%@", [tmpDict valueForKey:@"STARTDATE"],[tmpDict valueForKey:@"ENDDATE"]];
    termDate = [[NSString alloc] initWithFormat:@"%@", [tmpDict valueForKey:@"TERMINATIONDATE"]];
    
    recdAmount = [[[NSString alloc] initWithFormat:@" %@ ",[frm stringFromNumber:[NSNumber numberWithDouble:[[tmpDict valueForKey:@"RECEIVEDAMOUNT"] doubleValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    totAmount = [[[NSString alloc] initWithFormat:@" %@ ",[frm stringFromNumber:[NSNumber numberWithDouble:[[tmpDict valueForKey:@"TOTALAMOUNT"] doubleValue]]]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    
    lblPlanDesc = (UILabel*) [cell.contentView viewWithTag:1];
    lblPlanDesc.text = planDesc;
    
    lblPeriod = (UILabel*) [cell.contentView viewWithTag:2];
    lblPeriod.text = period;
    
    lblTermDate = (UILabel*) [cell.contentView viewWithTag:3];
    lblTermDate.text = termDate;
    
    lbltotAmount = (UILabel*) [cell.contentView viewWithTag:4];
    lbltotAmount.text = totAmount;
    
    lblRecdAmount = (UILabel*) [cell.contentView viewWithTag:5];
    lblRecdAmount.text = recdAmount;
    
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
    [self fireCancelNotification:nil];
}

- (void) fireCancelNotification:(NSDictionary*) cancelInfo
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"ContractSelectCancel"] forKey:@"notify"];
    [returnInfo setValue:nil forKey:@"data"];
    _returnMethod(returnInfo);
}

@end
