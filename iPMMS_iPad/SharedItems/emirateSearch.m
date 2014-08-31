//
//  emirateSearch.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "emirateSearch.h"

@implementation emirateSearch

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation withReturnMethod:(METHODCALLBACK) p_returnMethod andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
        intOrientation = p_intOrientation;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"EMIRATESLIST"];
        //_proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _returnMethod = p_returnMethod;
        _cacheName = [[NSString alloc] initWithString:@"ALLEMIRATES"];
        _naviButtonsCallback = p_naviButtonsCallback;
        //_gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        //_notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        __block id myself = self;
        _fireCancelCallback = ^(NSDictionary *p_dictInfo)
        {
            [myself fireCancelNotification:p_dictInfo];
        };
        [actIndicator startAnimating];
        sBar.text = @"";
        sBar.hidden = YES;
        navBar.hidden = YES;
        NSDictionary *buttonData = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",_fireCancelCallback,@"btnnotification" ,  nil];
        NSDictionary *naviInfo = [[NSDictionary alloc] initWithObjectsAndKeys:buttonData,[NSString stringWithFormat:@"%d",101] , @"Select Emirate",@"navititle" ,nil];
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
        METHODCALLBACK l_emiratesListReturn = ^(NSDictionary *p_dictInfo)
        {
            [self emirateListDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:nil andReturnMethod:l_emiratesListReturn];
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    [super setForOrientation:p_forOrientation]; 
}


- (void) emirateListDataGenerated:(NSDictionary *)generatedInfo
{
    if (dataForDisplay) 
        [dataForDisplay removeAllObjects];
    dataForDisplay = [[NSMutableArray alloc] init];
    //NSLog(@"received array list %@", dataForDisplay);
    populationOnProgress = NO;
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
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    NSString *returnEmirate;
    switch (indexPath.row) {
        case 0:
            returnEmirate = [[NSString alloc] initWithFormat:@"%@", @"ADB"];
            break;
        case 1:
            returnEmirate = [[NSString alloc] initWithFormat:@"%@", @"AJM"];
            break;
        case 2:
            returnEmirate = [[NSString alloc] initWithFormat:@"%@", @"DXB"];
            break;
        case 3:
            returnEmirate = [[NSString alloc] initWithFormat:@"%@", @"FUJ"];
            break;
        case 4:
            returnEmirate = [[NSString alloc] initWithFormat:@"%@", @"RAK"];
            break;
        case 5:
            returnEmirate = [[NSString alloc] initWithFormat:@"%@", @"SHJ"];
            break;
        case 6:
            returnEmirate = [[NSString alloc] initWithFormat:@"%@", @"UAQ"];
            break;
        default:
            break;
    }
    [returnInfo setValue:[NSString stringWithString:@"EmirateSelected"] forKey:@"notify"];
    [returnInfo setValue:returnEmirate forKey:@"data"];
    _returnMethod(returnInfo);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid=@"Cell";
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    UILabel *lblEmirateName;
    UIImageView *mbrPhoto;
    NSString *emirateName, *imageName;
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
        
        
        lblEmirateName = [[UILabel alloc] initWithFrame:CGRectMake(61, 1, 565, 58)];
        lblEmirateName.font = [UIFont boldSystemFontOfSize:24.0f];
        [lblEmirateName setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblEmirateName.tag = 2;
        [cell.contentView addSubview:lblEmirateName];
        
    }
    
    mbrPhoto= (UIImageView*) [cell.contentView viewWithTag:1];
    lblEmirateName = (UILabel*) [cell.contentView viewWithTag:2];
    imageName = [[NSString alloc] init];
    switch (indexPath.row) {
        case 0:
            emirateName = [[[NSString alloc] initWithFormat:@"   %@", @"Abu Dhabi"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            imageName = @"adb.JPG";
            break;
        case 1:
            emirateName = [[[NSString alloc] initWithFormat:@"   %@", @"Ajman"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            imageName = @"ajm.jpg";
            break;
        case 2:
            emirateName = [[[NSString alloc] initWithFormat:@"   %@", @"Dubai"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            imageName = @"dxb.JPG";
            break;
        case 3:
            emirateName = [[[NSString alloc] initWithFormat:@"   %@", @"Fujairah"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            imageName = @"fuj.JPG";
            break;
        case 4:
            emirateName = [[[NSString alloc] initWithFormat:@"   %@", @"Ras Al Khaimah"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            imageName = @"rak.JPG";
            break;
        case 5:
            emirateName = [[[NSString alloc] initWithFormat:@"   %@", @"Sharjah"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            imageName = @"shj.JPG";
            break;
        case 6:
            emirateName = [[[NSString alloc] initWithFormat:@"   %@", @"Umm Al Quwain"] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
            imageName = @"uaq.JPG";
            break;
        default:
            break;
    }
    mbrPhoto.image = [UIImage imageNamed:imageName];
    lblEmirateName.text = emirateName;
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
    [returnInfo setValue:[NSString stringWithString:@"EmirateSelectCancel"] forKey:@"notify"];
    [returnInfo setValue:nil forKey:@"data"];
    _returnMethod(returnInfo);
}

@end

