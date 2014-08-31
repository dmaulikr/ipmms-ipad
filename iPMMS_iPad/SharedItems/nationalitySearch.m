//
//  nationalitySearch.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "nationalitySearch.h"

@implementation nationalitySearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"NATIONSLIST"];
        //_proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLNATIONS"];
        //_gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
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
        NSDictionary *buttonData = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",_fireCancelMethod,@"btnnotification" ,  nil];
        NSDictionary *naviInfo = [[NSDictionary alloc] initWithObjectsAndKeys:buttonData,[NSString stringWithFormat:@"%d",101] , @"Select a Nationality",@"navititle" ,nil];
        _naviButtonsCallback(naviInfo);
        NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
        if ([stdDefaults valueForKey:@"LOCATIONSERVER"]) 
            MAIN_URL = [[NSString alloc] initWithFormat:@"http://%@/", [stdDefaults valueForKey:@"LOCATIONSERVER"]];
        else
            MAIN_URL = [[NSString alloc] initWithFormat:@"%@", HO_URL];
        [self generateData];
    }
    return self;
}

- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        METHODCALLBACK l_nationListGenerated = ^(NSDictionary *p_dictInfo)
        {
            [self nationListDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:nil andReturnMethod:l_nationListGenerated];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [super setForOrientation:p_forOrientation]; 
}

- (void) nationListDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] initWithArray:[generatedInfo valueForKey:@"data"] copyItems:YES];
    [self setForOrientation:intOrientation];
    //_returnMethod(nil);
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
    return  60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:[NSString stringWithString:@"NationSelected"] forKey:@"notify"];
    [returnInfo setValue:[dataForDisplay objectAtIndex:indexPath.row] forKey:@"data"];
    _returnMethod(returnInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    NSDictionary *tmpDict = [dataForDisplay objectAtIndex:indexPath.row];
    UILabel *lblCountryName;
    UIImageView *mbrPhoto;
    NSString *countryName;
    NSURL *urlPath ;
    
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        mbrPhoto = [[UIImageView alloc] init];
        [mbrPhoto setFrame:CGRectMake(1, 1, 58, 58)];
        mbrPhoto.tag = 1;
        [cell.contentView addSubview:mbrPhoto];
        
        
        lblCountryName = [[UILabel alloc] initWithFrame:CGRectMake(61, 1, 565, 58)];
        lblCountryName.font = [UIFont boldSystemFontOfSize:24.0f];
        [lblCountryName setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblCountryName.tag = 2;
        [cell.contentView addSubview:lblCountryName];
        
    }
    
    countryName = [[[NSString alloc] initWithFormat:@" %@",[tmpDict valueForKey:@"NATNAME"]] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
    urlPath = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@//Images//%@.JPG",MAIN_URL, WS_ENV, [tmpDict valueForKey:@"NATNAME"]]];
    mbrPhoto= (UIImageView*) [cell.contentView viewWithTag:1];
    lblCountryName = (UILabel*) [cell.contentView viewWithTag:2];
    mbrPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlPath]];
    lblCountryName.text = countryName;
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
    [returnInfo setValue:[NSString stringWithString:@"NationSelectCancel"] forKey:@"notify"];
    [returnInfo setValue:nil forKey:@"data"];
    _returnMethod(returnInfo);
}


@end
