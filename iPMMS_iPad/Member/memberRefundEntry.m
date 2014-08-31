//
//  memberRefundEntry.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 2/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberRefundEntry.h"

@implementation memberRefundEntry

- (id) initWithDictionary:(NSDictionary *)p_dict andFrame:(CGRect)p_frame andOrientation:(UIInterfaceOrientation)p_intOrientation forMode:(NSString *)p_forMode andControllerCallback:(METHODCALLBACK)p_controllerCallback andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback
{
    self = [self initWithFrame:p_frame]; //   [self initWithFrame:p_frame];
    bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
    currMode = [[NSString alloc] initWithFormat:@"%@", p_forMode];
    [self addNIBView:@"memberBaseView" forFrame:p_frame];
    [parentScroll setFrame:CGRectMake(0, 0, 703, 650)];
    prevFrame = p_frame;
    currOrientation = p_intOrientation;
    _initDict = p_dict;
    _controllerCallBack = p_controllerCallback;
    _naviButtonsCallback = p_naviButtonsCallback;
    __block id myself = self;
    _contractCallback = ^(NSDictionary *p_dictInfo)
    {
        [myself contractNotificaiton:p_dictInfo];
    };
    memRefundDataObjects = [[memberRefundObjects alloc] initWithFrame:prevFrame forOrientation:currOrientation andScrollview:parentScroll andDictdata:nil andMode:currMode withMbrKeyDict:_initDict andContractCallback:_contractCallback];
    
    actIndicator.transform = CGAffineTransformMakeScale(5.00, 5.00);  
    [self setForOrientation:currOrientation];
    return self;    
}

- (void) releaseViewObjects
{
    [memRefundDataObjects releaseViewObjects];
    memRefundDataObjects = nil;
}

- (void) setKeyDictionary:(NSDictionary *)p_keyDict
{
    _initDict = p_keyDict;
}

- (void) memberRefundDataSaved:(NSDictionary*) savedInfo
{
    NSDictionary *returnedDict =  [[savedInfo valueForKey:@"data"] objectAtIndex:0];
    //NSLog(@"the received dictionary %@",returnedDict);
    NSString *respCode = [returnedDict valueForKey:@"RESPONSECODE"];
    NSString *respMsg = [returnedDict valueForKey:@"RESPONSEMESSAGE"];
    if ([respCode isEqualToString:@"0"]) 
    {
        NSDictionary *afterSaveInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"AfterSave",@"data", nil, @"savedData", nil];
        _controllerCallBack(afterSaveInfo);
        //[self setListMode:nil];
        //[memDataObjects setListMode:nil];
    }
    else
        [memRefundDataObjects showAlertMessage:respMsg];
    [actIndicator stopAnimating];
}

- (void) memberRefundDataGenerated:(NSDictionary*) memberNotesData
{
    [memRefundDataObjects setListMode:memberNotesData];
    [actIndicator stopAnimating];
}


- (void) contractNotificaiton:(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectContract"]) 
    {
        contSelect = [[contractSearch alloc] initWithFrame:prevFrame forOrientation:currOrientation andDictionary:_initDict andReturnMethod:_contractCallback andNaviButtonsMethod:_naviButtonsCallback];
        [self addSubview:contSelect];
        return;
    }
    if ([notifyType isEqualToString:@"contractSelected"]) 
    {
        [memRefundDataObjects setContractInfo:notifyInfo];
    }
    [contSelect removeFromSuperview];
    contSelect = nil;
    _naviButtonsCallback(barButtonInfo);
}


- (void) addNIBView:(NSString *)nibName forFrame:(CGRect)forframe
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

- (void) setForOrientation:(UIInterfaceOrientation)p_forOrientation
{
    currOrientation = p_forOrientation;
    if (memRefundDataObjects) [memRefundDataObjects setForOrientation:currOrientation];
    if (UIInterfaceOrientationIsPortrait(currOrientation)) 
        [actIndicator setFrame:CGRectMake(365, 484, 37, 37)];
    else
        [actIndicator setFrame:CGRectMake(330, 365, 37, 37)];    
}

- (void) refreshData
{
    
}

- (void) setInsertMode
{
    currMode = @"I";
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    //NSString *titleName = [[NSString alloc] initWithFormat:@"CONTRACT OF %@ %@", [_initDict valueForKey:@"FIRSTNAME"] , [_initDict valueForKey:@"LASTNAME"]] ;
    titleName = [[NSString alloc] initWithFormat:@"REFUNDS"] ;
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    /*if (!memObjects) 
     memObjects = [[memNotesObjects alloc] initWithFrame:prevFrame forOrientation:currOrientation andScrollview:parentScroll andDictdata:nil andMode:currMode withMbrKeyDict:_initDict];*/
    [memRefundDataObjects setKeyDictionary:_initDict];
    [memRefundDataObjects setInsertMode];
    _naviButtonsCallback(barButtonInfo);
}

- (void) setListMode:(NSDictionary *)p_dictData
{
    currMode = @"L";
    //NSString *titleName = [[NSString alloc] initWithFormat:@"CONTRACT ENTRY %@ %@", [_initDict valueForKey:@"FIRSTNAME"] , [_initDict valueForKey:@"LASTNAME"]] ;
    titleName = [[NSString alloc] initWithFormat:@"REFUND ENTRY"] ;
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Back", @"btntitle",  nil];
    //btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    btnEdit = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit",@"btntitle", nil];
    if (p_dictData) 
    {
        [actIndicator startAnimating];
        METHODCALLBACK l_generateReturn = ^(NSDictionary *p_dictInfo)
        {
            [self memberRefundDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:@"GETMEMBERREFUNDSDATA" andInputParams:p_dictData andReturnMethod:l_generateReturn];
    }
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnEdit,[NSString stringWithFormat:@"%d",2] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    _naviButtonsCallback(barButtonInfo);
}

- (void) setEditMode
{
    currMode = @"U";
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    titleName = [[NSString alloc] initWithFormat:@"REFUNDS"] ;
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    [memRefundDataObjects setEditMode];
    _naviButtonsCallback(barButtonInfo);
}


- (void) executeSave
{
    NSString *dataXML;
    //NSString *imageStr;
    if (memRefundDataObjects) {
        [actIndicator startAnimating];
        if ([memRefundDataObjects validateEntries]) 
        {
            dataXML = [[NSString alloc] initWithFormat:@"%@", [memRefundDataObjects getXMLDataForSave]];
            NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:dataXML, @"p_memberrefunddata" , nil];
            METHODCALLBACK l_saveReturn = ^(NSDictionary *p_dictInfo)
            {
                [self memberRefundDataSaved:p_dictInfo];
            };
            [[gymWSProxy alloc] initWithReportType:@"ADDUPDATEMEMBERREFUNDS" andInputParams:inputDict andReturnMethod:l_saveReturn];
        }
        else
            [actIndicator stopAnimating];
    }    
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    
}

@end
