//
//  memberView.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberView.h"

@implementation memberView

- (id) initWithDictionary:(NSDictionary*) p_dict andFrame:(CGRect) p_frame andOrientation:(UIInterfaceOrientation) p_intOrientation forMode:(NSString*) p_forMode andControllerCallback:(METHODCALLBACK)p_controllerCallback andPhotoCallBack:(METHODCALLBACK) p_photoMethod andNavigatorCallBack:(METHODCALLBACK) p_navigatorCallBack andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallBack
{
    self = [self initWithFrame:p_frame]; //   [self initWithFrame:p_frame];
    __block id myself = self;
    bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
    currMode = [[NSString alloc] initWithFormat:@"%@", p_forMode];
    [self addNIBView:@"memberBaseView" forFrame:p_frame];
    [parentScroll setFrame:CGRectMake(0, 0, 703, 650)];
    prevFrame = p_frame;
    currOrientation = p_intOrientation;
    _controllerCallBack = p_controllerCallback;
    _photoCallBack = p_photoMethod;
    _navigatorCallBack = p_navigatorCallBack;
    _naviButtonsCallBack = p_naviButtonsCallBack;
    _locReturn = ^(NSDictionary *p_dictInfo)
    {
        [myself locationNotificaiton:p_dictInfo];
    };
    _emirateCallback = ^(NSDictionary *p_dictInfo)
    {
        [myself emirateNotification:p_dictInfo];
    };
    _nationalityCallback = ^(NSDictionary *p_dictInfo)
    {
        [myself nationalityNotification:p_dictInfo];
    };

    actIndicator.transform = CGAffineTransformMakeScale(5.00, 5.00);        
    return self;
}

- (void) releaseViewObjects
{
    [memDataObjects releaseViewObjects];
    memDataObjects =nil;
}

- (void) memberDataSaved:(NSDictionary*) savedInfo
{
    NSDictionary *returnedDict =  [[savedInfo valueForKey:@"data"] objectAtIndex:0];
    //NSLog(@"the received dictionary %@",returnedDict);
    NSString *respCode = [returnedDict valueForKey:@"RESPONSECODE"];
    NSString *respMsg = [returnedDict valueForKey:@"RESPONSEMESSAGE"];
    if ([respCode isEqualToString:@"0"]) 
    {
        [memDataObjects setBarCode:[returnedDict valueForKey:@"BARCODE"]];
        [memDataObjects saveImagetoCache:[returnedDict valueForKey:@"MEMBERID"]];
        NSDictionary *afterSaveInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"AfterSave",@"data", returnedDict, @"savedData", nil];
        _controllerCallBack(afterSaveInfo);
        [self setListMode:nil];
        [memDataObjects setListMode:nil];
    }
    else
        [memDataObjects showAlertMessage:respMsg];
    [actIndicator stopAnimating];

}

- (void) memberDataGenerated:(NSDictionary*) memberData
{
    //NSDictionary *recdData = [memberData userInfo];
    NSArray *mdArray = [[NSArray alloc] initWithArray:[memberData valueForKey:@"data"] copyItems:YES];
    //NSLog(@"The current mode is %@", currMode);
    if ([currMode isEqualToString:@"L"]) 
    {
        if (memDataObjects)
            [memDataObjects setListMode:[mdArray objectAtIndex:0]];
        [actIndicator stopAnimating];
    }
    //NSLog(@"the data is received");
    populationOnProgress = NO;
}

- (void) locationNotificaiton :(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectLocation"]) 
    {
        locSelect = [[locationSearch alloc] initWithFrame:self.frame forOrientation:currOrientation withReturnMethod:_locReturn andIsSplit:YES withNaviButtonsMethod:_naviButtonsCallBack];
        [self addSubview:locSelect];
        return;
    }
    if ([notifyType isEqualToString:@"LocationSelected"]) 
    {
        [memDataObjects setLocation:notifyInfo];
    }
    [locSelect removeFromSuperview];
    locSelect = nil;
    _naviButtonsCallBack(barButtonInfo);
}


- (void) nationalityNotification :(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectNation"]) 
    {
        nationSelect = [[nationalitySearch alloc] initWithFrame:self.frame forOrientation:currOrientation andReturnMethod:_nationalityCallback andNaviButtonsCallback:_naviButtonsCallBack];
        [self addSubview:nationSelect];
        return;
    }
    if ([notifyType isEqualToString:@"NationSelected"]) 
    {
        [memDataObjects setNationality:notifyInfo];
    }
    [nationSelect removeFromSuperview];
    nationSelect = nil;
    _naviButtonsCallBack(barButtonInfo);
}

- (void) emirateNotification :(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectEmirate"]) 
    {
        emirateSelect = [[emirateSearch alloc] initWithFrame:self.frame forOrientation:currOrientation withReturnMethod:_emirateCallback andNaviButtonsCallback:_naviButtonsCallBack];
        [self addSubview:emirateSelect];
        return;
    }
    if ([notifyType isEqualToString:@"EmirateSelected"]) 
    {
        [memDataObjects setEmirates:notifyInfo];
    }
    [emirateSelect removeFromSuperview];
    emirateSelect = nil;
    _naviButtonsCallBack(barButtonInfo);
}

- (void) addNIBView:(NSString*) nibName  forFrame:(CGRect) forframe
{
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:nibName
                                                      owner:self
                                                    options:nil];
    newview = [nibViews objectAtIndex:0];
    [newview setFrame:forframe];
    newview.tag = 30001;
    [self addSubview:newview];        // Initialization code
    [parentScroll setBackgroundColor:[newview backgroundColor]];
}

- (void) setForOrientation: (UIInterfaceOrientation) p_forOrientation
{
    currOrientation = p_forOrientation;
    if (memDataObjects) [memDataObjects setForOrientation:currOrientation];
    if (UIInterfaceOrientationIsPortrait(currOrientation)) 
        [actIndicator setFrame:CGRectMake(365, 484, 37, 37)];
    else
        [actIndicator setFrame:CGRectMake(330, 365, 37, 37)];
        
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) refreshData
{
    
    memDataObjects = [[memberObjects alloc] initWithDictionary:nil andFrame:prevFrame andOrientation:currOrientation forMode:currMode withScroll:parentScroll andPhotoNotifyMethod:_photoCallBack andLocNotifyMethod:_locReturn andEmirateCallback:_emirateCallback andNationNotify:_nationalityCallback];
}

- (void) setEmptyMode
{
    NSDictionary *btnInsert = [[NSDictionary alloc] initWithObjectsAndKeys:@"Insert", @"btntitle",  nil];
    NSDictionary *btnEdit = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit", @"btntitle",  nil];
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnInsert,[NSString stringWithFormat:@"%d",1] ,btnEdit,[NSString stringWithFormat:@"%d",2], @"Member Information",@"navititle" ,bgcolor, @"bgcolor",nil];
    if (!memDataObjects)
        memDataObjects = [[memberObjects alloc] initWithDictionary:nil andFrame:prevFrame andOrientation:currOrientation forMode:@"E" withScroll:parentScroll andPhotoNotifyMethod:_photoCallBack andLocNotifyMethod:_locReturn andEmirateCallback:_emirateCallback andNationNotify:_nationalityCallback];
    [memDataObjects setEmptyMode];
    _naviButtonsCallBack(barButtonInfo);
}

- (void) setInsertMode
{
    currMode = @"I";
    NSDictionary *btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    NSDictionary *btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], @"Member Entry",@"navititle" ,bgcolor, @"bgcolor",nil];
    if (memDataObjects) [memDataObjects setInsertMode];
    _naviButtonsCallBack(barButtonInfo);
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currMode = @"L";
    if (p_dictData) 
    {
        if (populationOnProgress==NO) 
        {
            populationOnProgress = YES;
            //NSLog(@"population info received %@", p_dictData);
            METHODCALLBACK l_memDataGenMethod = ^(NSDictionary *p_dictInfo)
            {
                [self memberDataGenerated:p_dictInfo];
            };
            [actIndicator startAnimating];
            [[gymWSProxy alloc] initWithReportType:@"MEMBERDATA" andInputParams:p_dictData andReturnMethod:l_memDataGenMethod];
        }
    }
    NSDictionary *btnInsert = [[NSDictionary alloc] initWithObjectsAndKeys:@"Insert", @"btntitle",  nil];
    NSDictionary *btnEdit = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit", @"btntitle",  nil];
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnInsert,[NSString stringWithFormat:@"%d",1] ,btnEdit,[NSString stringWithFormat:@"%d",2],  @"Member data",@"navititle" , bgcolor, @"bgcolor", nil];
    _naviButtonsCallBack(barButtonInfo);
    //[self setMemberOptionsProperly];
}

- (void) setEditMode
{
    currMode = @"U";
    NSDictionary *btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    NSDictionary *btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], @"Member Entry",@"navititle" ,bgcolor, @"bgcolor",nil];
    if (memDataObjects) [memDataObjects setEditMode];
    _naviButtonsCallBack(barButtonInfo);
}

- (void) executeSave
{
    NSString *dataXML;
    NSString *imageStr;
    if (memDataObjects) {
        [actIndicator startAnimating];
        if ([memDataObjects validateEntries]) 
        {
            dataXML = [[NSString alloc] initWithFormat:@"%@", [memDataObjects getXMLDataForSave]];
            imageStr = [[NSString alloc] initWithFormat:@"%@", [memDataObjects getImageString]];
            NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:dataXML, @"p_memberdata", imageStr, @"p_memberImage" , nil];
            METHODCALLBACK l_memDataSaveMethod = ^(NSDictionary *p_dictInfo)
            {
                [self memberDataSaved:p_dictInfo];
            };
            [[gymWSProxy alloc] initWithReportType:@"ADDUPDATEMEMBER" andInputParams:inputDict andReturnMethod:l_memDataSaveMethod];
        }
        else
            [actIndicator stopAnimating];
    }
}

- (void) executeCancel
{
    currMode = @"L";

}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    currMode = @"L";
    if (memDataObjects) 
        [memDataObjects performAfterSave:p_savedInfo];
}

- (IBAction)memberAction:(id)sender
{
    int selectedIndex = scMemberOptions.selectedSegmentIndex;
    //navigateMemberController
    NSDictionary *naviInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d", selectedIndex] ,@"data" , nil];
    _navigatorCallBack(naviInfo);
    [scMemberOptions setSelectedSegmentIndex:UISegmentedControlNoSegment];
}

- (void) newPhotoTaken:(NSDictionary*) photoInfo
{
    [memDataObjects newPhotoTaken:photoInfo];
}
@end
