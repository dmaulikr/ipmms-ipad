//
//  planSearch.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "planSearch.h"

@implementation planSearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:bgcolor];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"PLANSLIST"];
        _returnMethod = p_returnMethod;
        _naviButtonsCallback = p_naviButtonsCallback;
        //_proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLPLANS"];
        //_gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        planDetail = [[NSMutableDictionary alloc] init];
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = YES;
        navBar.hidden = YES;
        METHODCALLBACK l_cancelMethod = ^(NSDictionary *p_dictInfo)
        {
            [self fireCancelNotification:p_dictInfo];
        };
        NSDictionary *buttonData = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",l_cancelMethod ,@"btnnotification" ,  nil];
        NSDictionary *naviInfo = [[NSDictionary alloc] initWithObjectsAndKeys:buttonData,[NSString stringWithFormat:@"%d",101] , @"Select a Plan",@"navititle" ,nil];
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
        METHODCALLBACK l_planListGenerated=^(NSDictionary *p_dictInfo)
        {
            [self planListDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:nil andReturnMethod:l_planListGenerated];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [super setForOrientation:p_forOrientation]; 
}


- (void) planListDataGenerated:(NSDictionary *)generatedInfo
{
    int l_dataType = 0;
    int l_prevplanid = 0;
    int l_currplanid = 0;
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] init];
    [planDetail removeAllObjects];
    for (NSDictionary *tmpDict in [generatedInfo valueForKey:@"data"]) 
    {
        l_dataType = [[tmpDict valueForKey:@"DATATYPE"] intValue];
        l_currplanid = [[tmpDict valueForKey:@"PLANID"] intValue];
        switch (l_dataType) {
            case 1:
                [dataForDisplay addObject:tmpDict];
                if (l_prevplanid!=0) 
                {
                    [planDetail setValue:tmpArray forKey:[NSString stringWithFormat:@"%d",l_prevplanid]];
                    tmpArray = nil;
                    tmpArray =[[NSMutableArray alloc] init];
                }
                break;
            case 2:
                [tmpArray addObject:tmpDict];
                break;
            default:
                break;
        }
        l_prevplanid = l_currplanid;
    }
    if (l_prevplanid!=0) 
    {
        [planDetail setValue:tmpArray forKey:[NSString stringWithFormat:@"%d",l_prevplanid]];
        tmpArray = nil;
        //tmpArray =[[NSMutableArray alloc] init];
    }
    //dataForDisplay = [[NSMutableArray alloc] initWithArray:[recdData valueForKey:@"data"] copyItems:YES];
    [self setForOrientation:intOrientation];
    //NSLog(@"the values in main plans %@", dataForDisplay);
    //NSLog(@"the values in the detail plans %@", planDetail);
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
    return  35.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"PlanSelected"] forKey:@"notify"];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    [returnInfo setValue:[planDetail valueForKey:[tmpDict valueForKey:@"PLANID"]] forKey:@"feeinfo"];
    _returnMethod(returnInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblPlanName, *lblNoOfMonths;
    NSString *planName, *noofMonths;
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        
        lblPlanName = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, 375, 34)];
        lblPlanName.font = [UIFont boldSystemFontOfSize:18.0f];
        [lblPlanName setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblPlanName.tag = 1;
        [cell.contentView addSubview:lblPlanName];

        lblNoOfMonths = [[UILabel alloc] initWithFrame:CGRectMake(376, 1, 248, 34)];
        lblNoOfMonths.font = [UIFont boldSystemFontOfSize:18.0f];
        [lblNoOfMonths setBackgroundColor:[UIColor colorWithRed:150.0f/255.0f green:170.0f/255.0f blue:25.0f/255.0f alpha:0.4]];
        lblNoOfMonths.tag = 2;
        [cell.contentView addSubview:lblNoOfMonths];
    }
    
    planName = [[NSString alloc] initWithFormat:@"  %@",[tmpDict valueForKey:@"PLANDESC"]];
    noofMonths = [[NSString alloc] initWithFormat:@"  %d Months", [[tmpDict valueForKey:@"NOOFMONTHS"] intValue]];
    lblPlanName = (UILabel*) [cell.contentView viewWithTag:1];
    lblNoOfMonths = (UILabel*) [cell.contentView viewWithTag:2];
    lblPlanName.text = planName;
    lblNoOfMonths.text = noofMonths;
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

- (void) fireCancelNotification:(NSNotification*) cancelInfo
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"PlanSelectCancel"] forKey:@"notify"];
    [returnInfo setValue:nil forKey:@"data"];
    _returnMethod(returnInfo);
}

@end
