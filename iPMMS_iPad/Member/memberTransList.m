//
//  memberTransList.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 25/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberTransList.h"

@implementation memberTransList

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andNotification:(NSString*) p_notification withNewDataNotification:(NSString*)  p_proxynotificationname andDictionary:(NSDictionary*) p_initDict andControllerCallback:(METHODCALLBACK) p_controllerCallback andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback
{
    self = [super initWithFrame:frame];
    if (self) {
        bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
        [super addNIBView:@"getSearch" forFrame:frame];
        [super setViewBackGroundColor:bgcolor];
        intOrientation = p_intOrientation;
        _controllerCallback = p_controllerCallback;
        _naviButtonsCallback = p_naviButtonsCallback;
        _webdataName= [[NSString alloc] initWithFormat:@"%@",@"GETMEMBERTRANSLIST"];
        _proxynotification = [[NSString alloc] initWithFormat:@"%@",p_proxynotificationname];
        _cacheName = [[NSString alloc] initWithString:@"ALLMEMBERTRANS"];
        _gobacknotifyName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        _initDict = [NSDictionary dictionaryWithDictionary:p_initDict];
        _notificationName = [[NSString alloc] initWithFormat:@"%@",p_notification];
        currMode = [[NSString alloc] initWithFormat:@"%@", @"L"];
        [actIndicator startAnimating];
        sBar.hidden = YES;
        navBar.hidden = YES;
        frm = [[NSNumberFormatter alloc] init];
        [frm setNumberStyle:NSNumberFormatterCurrencyStyle];
        [frm setCurrencySymbol:@""];
        [frm setMaximumFractionDigits:2];
        memTransView = [[memberTransView alloc] initWithDictionary:_initDict andFrame:self.frame andOrientation:intOrientation forMode:@"L" andControllerCallback:_controllerCallback andNaviButtonsCallback:_naviButtonsCallback];
        btnInsert = [[NSDictionary alloc] initWithObjectsAndKeys:@"Insert", @"btntitle",  nil];
        /*btnMember = [[NSDictionary alloc] initWithObjectsAndKeys:@"Member", @"btntitle",@"navigateMexmberController",@"btnnotification" ,  nil];
        btnContract = [[NSDictionary alloc] initWithObjectsAndKeys:@"Contract", @"btntitle",@"navigatxeMemberController",@"btnnotification" ,  nil];
        btnNotes = [[NSDictionary alloc] initWithObjectsAndKeys:@"Notes", @"btntitle",@"navigateMxemberController",@"btnnotification" ,  nil];
        btnRefunds = [[NSDictionary alloc] initWithObjectsAndKeys:@"Refunds", @"btntitle",@"navigatexMemberController",@"btnnotification" ,  nil];*/
    }
    return self;
}


- (void) releaseViewObjects
{
    [memTransView releaseViewObjects];
    memTransView = nil;
}

- (void) generateData
{
    if (populationOnProgress==NO)
    {
        populationOnProgress = YES;
        NSMutableDictionary *inputDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[_initDict valueForKey:@"MEMBERID"], @"p_memberid" , nil];
        METHODCALLBACK l_generateReturn = ^(NSDictionary *p_dictInfo)
        {
            [self memberTransListDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:_webdataName andInputParams:inputDict andReturnMethod:l_generateReturn];
        refreshTag = 0;
    }    
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    //[super setForOrientation:p_forOrientation]; 
    [self generateTableView];
}


- (void) memberTransListDataGenerated:(NSDictionary *)generatedInfo
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
    return  [[NSString stringWithString:@"    Entry No           Entry Date                 Notes                   Paid Amt."] stringByReplacingOccurrencesOfString:@" " withString:@"\u00A0"];
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
    UILabel *lblEntryno, *lblEntryDate, *lblNotes, *lblPaidAmount;
    NSString *entryNo, *entryDate, *notes, *PaidAmount;
    int labelHeight = 43;
    int lblShortWidth, lblLongWidth, xPosition, xWidth;
    lblShortWidth = 130; lblLongWidth = 220;
    if(cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:cellid];
        cell.backgroundColor=[UIColor clearColor];
        
        xPosition = 0; xWidth = lblShortWidth-8;
        lblEntryno = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblEntryno.font = [UIFont systemFontOfSize:14.0f];
        [lblEntryno setBackgroundColor:[UIColor colorWithRed:205.0f/255.0f green:133.0f/255.0f blue:63.0f/255.0f alpha:1.0]];
        lblEntryno.tag = 1;
        [cell.contentView addSubview:lblEntryno];
        
        xPosition += xWidth; xWidth = lblShortWidth-8;
        lblEntryDate = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblEntryDate.font = [UIFont systemFontOfSize:12.0f];
        [lblEntryDate setBackgroundColor:[UIColor colorWithRed:190.0/255.0f green:148.0f/255.0f blue:78.0f/255.0f alpha:1.0]];
        lblEntryDate.textAlignment = UITextAlignmentLeft;
        lblEntryDate.tag = 2;
        [cell.contentView addSubview:lblEntryDate];
        
        xPosition += xWidth; xWidth = lblLongWidth-20;
        lblNotes = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblNotes.font = [UIFont systemFontOfSize:12.0f];
        [lblNotes setBackgroundColor:[UIColor colorWithRed:160.0f/255.0f green:178.0f/255.0f blue:113.0f/255.0f alpha:1.0]];
        lblNotes.tag = 3;
        lblNotes.numberOfLines = 2;
        [lblNotes setTextAlignment:UITextAlignmentLeft];
        [cell.contentView addSubview:lblNotes];
        
        xPosition += xWidth; xWidth = lblShortWidth-9;
        lblPaidAmount = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, 1, xWidth, labelHeight)];
        lblPaidAmount.font = [UIFont systemFontOfSize:12.0f];
        [lblPaidAmount setBackgroundColor:[UIColor colorWithRed:145.0f/255.0f green:193.0f/255.0f blue:128.0f/255.0f alpha:0.4]];
        lblPaidAmount.tag = 4;
        [lblPaidAmount setTextAlignment:UITextAlignmentRight];
        [cell.contentView addSubview:lblPaidAmount];
        
        xPosition += xWidth;
        btnView = [[UIButton alloc] initWithFrame:CGRectMake(xPosition, 0, 45, 45)];
        btnView.titleLabel.textColor = btnView.titleLabel.backgroundColor;
        btnView.tag = 6;
        [btnView setImage:[UIImage imageNamed:@"editicon.jpg"] forState:UIControlStateNormal];
        [btnView addTarget:self action:@selector(viewSelectedItem:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:btnView];
    }
    
    entryNo = [[NSString alloc] initWithFormat:@"%@",[tmpDict valueForKey:@"ENTRYNO"]];
    entryDate =  [[NSString alloc] initWithFormat:@" %@", [tmpDict valueForKey:@"ENTRYDATE"]];
    notes = [[NSString alloc] initWithFormat:@" %@", [tmpDict valueForKey:@"NOTES"]];
    PaidAmount =  [[NSString alloc] initWithFormat:@"%@ ", [frm stringFromNumber:[NSNumber numberWithDouble:[[tmpDict valueForKey:@"PAIDAMOUNT"] doubleValue]]]];
    
    lblEntryno = (UILabel*) [cell.contentView viewWithTag:1];
    lblEntryno.text = entryNo;
    
    lblEntryDate = (UILabel*) [cell.contentView viewWithTag:2];
    lblEntryDate.text = entryDate;
    
    lblNotes = (UILabel*) [cell.contentView viewWithTag:3];
    lblNotes.text = notes;
    
    lblPaidAmount = (UILabel*) [cell.contentView viewWithTag:4];
    lblPaidAmount.text = PaidAmount;
    
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
     [memTransView setInsertMode];
     [self addSubview:memTransView];
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    NSString *titleName = [[NSString alloc] initWithFormat:@"TRANSACTIONS"] ;
    currMode = @"L";
    _initDict = [NSDictionary dictionaryWithDictionary:p_dictData];
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnInsert,[NSString stringWithFormat:@"%d",1] , titleName ,@"navititle" , bgcolor, @"bgcolor",  nil];
    _naviButtonsCallback(barButtonInfo);
    [memTransView setKeyDictionary:_initDict];
    [memTransView removeFromSuperview];
    [self generateData];
}

- (void) setEditMode
{
    currMode = @"U";
    [memTransView setEditMode];
}

- (void) executeCancel
{
    currMode = @"L";
    [memTransView removeFromSuperview];
    _naviButtonsCallback(barButtonInfo);
}

- (void) executeSave
{
    [memTransView executeSave];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    currMode = @"L";
    [self setListMode:_initDict];
}

- (IBAction)viewSelectedItem:(id)sender
{
    UIButton *btnclicked = (UIButton*) sender;
    int selIndex = [btnclicked.titleLabel.text intValue];
    if ([currMode isEqualToString:@"L"]) 
    {
         [self addSubview:memTransView];
         [memTransView setListMode:[dataForDisplay objectAtIndex:selIndex]];
    }
}

@end
