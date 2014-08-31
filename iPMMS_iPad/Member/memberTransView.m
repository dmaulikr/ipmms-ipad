//
//  memberTransView.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 26/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberTransView.h"

@implementation memberTransView

- (id) initWithDictionary:(NSDictionary*) p_dict andFrame:(CGRect) p_frame andOrientation:(UIInterfaceOrientation) p_intOrientation forMode:(NSString*) p_forMode andControllerCallback:(METHODCALLBACK) p_controllerCallback andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback
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
    _naviButtonsCallBack = p_naviButtonsCallback;
    __block id myself = self;
    _transDataGenerated = ^(NSDictionary *p_dictInfo)
    {
        [myself memberTransDataGenerated:p_dictInfo];
    };
    _bankCallbacks = ^(NSDictionary *p_dictInfo)
    {
        [myself bankNotification:p_dictInfo];
        
    };
    memTransDataObjects = [[memTransObjects alloc] initWithFrame:prevFrame forOrientation:currOrientation andScrollview:parentScroll andDictdata:nil andMode:currMode withMbrKeyDict:_initDict andBankCallbacks:_bankCallbacks];
    
    actIndicator.transform = CGAffineTransformMakeScale(5.00, 5.00);  
    [self setForOrientation:currOrientation];
    return self;    
}

- (void) releaseViewObjects
{
    [memTransDataObjects releaseViewObjects];
    memTransDataObjects = nil;
}

- (void) bankNotification:(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectBank"]) 
    {
        bankSelect = [[bankSearch alloc] initWithFrame:prevFrame forOrientation:currOrientation andReturnMethod:_bankCallbacks andNavigateButtonsMethod:_naviButtonsCallBack];
        [self addSubview:bankSelect];
        return;
    }
    if ([notifyType isEqualToString:@"BankSelected"]) 
    {
        [memTransDataObjects setBank:notifyInfo];
    }
    [bankSelect removeFromSuperview];
    bankSelect = nil;
    _naviButtonsCallBack(barButtonInfo);
}


- (void) memberTransDataSaved:(NSDictionary*) savedInfo
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
        [memTransDataObjects showAlertMessage:respMsg];
    [actIndicator stopAnimating];
}


- (void) memberTransDataGenerated:(NSDictionary*) memberTransData
{
    [memTransDataObjects setListMode:memberTransData];
    if ([currMode isEqualToString:@"I"]) 
        [memTransDataObjects setInsertMode];
    
    if ([currMode isEqualToString:@"U"]) 
        [memTransDataObjects setEditMode];
    
    [actIndicator stopAnimating];
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
    if (memTransDataObjects) [memTransDataObjects setForOrientation:currOrientation];
    if (UIInterfaceOrientationIsPortrait(currOrientation)) 
        [actIndicator setFrame:CGRectMake(365, 484, 37, 37)];
    else
        [actIndicator setFrame:CGRectMake(330, 365, 37, 37)];    
}

- (void) refreshData
{
    
}

- (void) setKeyDictionary:(NSDictionary *)p_keyDict
{
    _initDict = [NSDictionary dictionaryWithDictionary:p_keyDict];
    [memTransDataObjects setKeyDictionary:_initDict];
}

- (void) setInsertMode
{
    //NSLog(@"RECEIVED DICTONARY IS %@", _initDict);
    currMode = @"I";
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    titleName = [[NSString alloc] initWithFormat:@"COLLECTIONS"] ;
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    [actIndicator startAnimating];
    NSDictionary *wsInput = [NSDictionary dictionaryWithObjectsAndKeys:[_initDict valueForKey:@"MEMBERID"],@"MEMBERID", [NSString stringWithString:@"0"], @"ENTRYID" , nil];
    [[gymWSProxy alloc] initWithReportType:@"GETMEMBERTRANSDATA" andInputParams:wsInput andReturnMethod:_transDataGenerated];
    _naviButtonsCallBack(barButtonInfo);
}

- (void) setListMode:(NSDictionary *)p_dictData
{
    currMode = @"L";
    titleName = [[NSString alloc] initWithFormat:@"COLLECTION ENTRY"] ;
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Back", @"btntitle",  nil];
    //btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    btnEdit = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit",@"btntitle", nil];
    if (p_dictData) 
    {
        [actIndicator startAnimating];
        NSDictionary *wsInput = [NSDictionary dictionaryWithObjectsAndKeys:[_initDict valueForKey:@"MEMBERID"],@"MEMBERID",[p_dictData valueForKey:@"ENTRYID"], @"ENTRYID" , nil];
        [[gymWSProxy alloc] initWithReportType:@"GETMEMBERTRANSDATA" andInputParams:wsInput andReturnMethod:_transDataGenerated];
    }
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnEdit,[NSString stringWithFormat:@"%d",2] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    _naviButtonsCallBack(barButtonInfo);
}

- (void) setEditMode
{
    currMode = @"U";
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    titleName = [[NSString alloc] initWithFormat:@"COLLECTION ENTRY"] ;
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    [memTransDataObjects setEditMode];
    _naviButtonsCallBack(barButtonInfo);
}


- (void) executeSave
{
    NSString *dataXML;
    //NSString *imageStr;
    if (memTransDataObjects) {
        [actIndicator startAnimating];
        if ([memTransDataObjects validateEntries]) 
        {
            dataXML = [[NSString alloc] initWithFormat:@"%@", [memTransDataObjects getXMLDataForSave]];
            //NSLog(@"THE RESULT XML IS %@", dataXML);
            METHODCALLBACK l_memTransDataSave = ^(NSDictionary *p_dictInfo)
            {
                [self memberTransDataSaved:p_dictInfo];
            };
            NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:dataXML, @"p_membertransdata" , nil];
            [[gymWSProxy alloc] initWithReportType:@"ADDUPDATEMEMBERTRANS" andInputParams:inputDict andReturnMethod:l_memTransDataSave];
        }
        else
            [actIndicator stopAnimating];
    }    
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    
}

@end
