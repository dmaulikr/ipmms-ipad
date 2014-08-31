//
//  membrPlanEntry.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 26/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberPlanEntry.h"

@implementation memberPlanEntry

- (id) initWithFrame:(CGRect)p_frame andOrientation:(UIInterfaceOrientation)p_intOrientation andControllerCallBack:(METHODCALLBACK)p_controllerCallBack andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonscallback
{
    self = [self initWithFrame:p_frame]; //   [self initWithFrame:p_frame];
    bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
    //currMode = [[NSString alloc] initWithFormat:@"%@", p_forMode];
    [self addNIBView:@"memberBaseView" forFrame:p_frame];
    [parentScroll setFrame:CGRectMake(0, 0, 703, 650)];
    prevFrame = p_frame;
    currOrientation = p_intOrientation;
    _controllerCallBack = p_controllerCallBack;
    _naviButtonsCallback = p_naviButtonscallback;
    //_initDict = p_dict;
    __block id myself = self;
    _memPlanDataSavedMethod = ^(NSDictionary *p_dictInfo)
    {
        [myself memberPlanDataSaved:p_dictInfo];
    };
    _billcycleCallbacks = ^(NSDictionary *p_dictInfo)
    {
        [myself billCycleNotification:p_dictInfo];
    };
    _planTypeCallbacks = ^(NSDictionary *p_dictInfo)
    {
        [myself planTypeNotification:p_dictInfo];
    };
    _feeDataCallbacks = ^(NSDictionary *p_dictInfo)
    {
        [myself feesDataNotification:p_dictInfo];
    };
    _terminateCallback = ^(NSDictionary *p_dictInfo)
    {
        [myself terminateNotification:p_dictInfo];
    };
    _feeSearchCallbacks = ^(NSDictionary *p_dictInfo)
    {
        [myself feesNotification:p_dictInfo];
    };
    _payDataCallback = ^(NSDictionary *p_dictInfo)
    {
        [myself payDataNotification:p_dictInfo];
    };
    
    memPlanDataObjects = [[memberPlanObjects alloc] initWithFrame:prevFrame forOrientation:currOrientation andScrollview:parentScroll andDictdata:nil andMode:currMode withMbrKeyDict:nil andBillcycleCallbacks:_billcycleCallbacks andPlantypeCallbacks:_planTypeCallbacks andFeesDataCallback:_feeDataCallbacks andPayDataCallback:_payDataCallback];
    actIndicator.transform = CGAffineTransformMakeScale(5.00, 5.00);  
    //[self setForOrientation:currOrientation];
    return self;    
}

- (void) releaseViewObjects
{
    memPlanDataObjects = nil;
}


- (void) memberPlanDataSaved:(NSDictionary*) savedInfo
{
    NSDictionary *returnedDict =  [[savedInfo valueForKey:@"data"] objectAtIndex:0];
    //NSLog(@"the received dictionary %@",returnedDict);
    NSString *respCode = [returnedDict valueForKey:@"RESPONSECODE"];
    NSString *respMsg = [returnedDict valueForKey:@"RESPONSEMESSAGE"];
    if ([respCode isEqualToString:@"0"]) 
    {
        NSDictionary *afterSaveInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"AfterSave",@"data", nil, @"savedData", nil];
        _controllerCallBack(afterSaveInfo);
    }
    else
        [memPlanDataObjects showAlertMessage:respMsg];
    [actIndicator stopAnimating];
}

- (void) terminateNotification:(NSDictionary*) notifyInfo
{
    dAlert = [[UIAlertView alloc] initWithTitle:@"Terminate" message:@"Sure to Proceed?\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Terminate", nil];
    dAlert.cancelButtonIndex = 0;
    dAlert.delegate = self;
    //dAlert.tag = 100+[btnClicked.titleLabel.text intValue] ;
    //[dAlert addSubview:dobPicker];
    [dAlert show];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex!=0) 
    {
        [actIndicator startAnimating];
        [[gymWSProxy alloc] initWithReportType:@"TERMINATEMEMBERPLAN" andInputParams:_dispDict andReturnMethod:_memPlanDataSavedMethod];
    }
}

- (void) feesNotification:(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectFee"]) 
    {
        feeSelect = [[feesSearch alloc] initWithFrame:prevFrame forOrientation:currOrientation andReturnMethod:_feeSearchCallbacks andNaviCallbacks:_naviButtonsCallback];
        [self addSubview:feeSelect];
        return;
    }
    if ([notifyType isEqualToString:@"FeesSelected"]) 
    {
        [feesDE setFeesValues:notifyInfo];
    }
    [feeSelect removeFromSuperview];
    feeSelect = nil;
    
}


- (void) memberPlanDataGenerated:(NSDictionary*) memberPlanData
{
    /*memPlanDataObjects = [[memberPlanObjects alloc] initWithFrame:prevFrame forOrientation:currOrientation andScrollview:parentScroll andDictdata:nil andMode:currMode withMbrKeyDict:nil];*/
    [memPlanDataObjects setListMode:memberPlanData];
    //[memPlanDataObjects setInsertMode];
    [actIndicator stopAnimating];
}

- (void) payDataNotification:(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    /*if ([notifyType isEqualToString:@"SelectFeesServices"]) 
     {
     if (!feesDE) 
     feesDE = [[feesDataEntry alloc] initWithFrame:prevFrame forOrientation:currOrientation andNotification:@"feesDataNotification"];
     [feesDE addNewFeesData];
     [self addSubview:feesDE];
     return;
     }*/
    if ([notifyType isEqualToString:@"EditPaySchedule"]) 
    {
        if (!paySE) 
            paySE = [[payScheduleEntry alloc] initWithFrame:prevFrame forOrientation:currOrientation andReturnMethod:_payDataCallback andNaviButtonsCallback:_naviButtonsCallback];
        [paySE editPayScheduleData:[notifyInfo valueForKey:@"data"] forRowNo:[[notifyInfo valueForKey:@"recordNo"] intValue]];
        //[paySE editPayScheduleData:<#(NSDictionary *)#> forRowNo:<#(int)#>
        [self addSubview:paySE];
        return;
    }
    if ([notifyType isEqualToString:@"PayScheduleDone"]) 
    {
        [memPlanDataObjects addUpdatePayScheduleData:notifyInfo];
    }
    [paySE removeFromSuperview];
    paySE = nil;
    _naviButtonsCallback(barButtonInfo);
}

- (void) feesDataNotification:(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectFeesServices"]) 
    {
        if (!feesDE) 
            feesDE = [[feesDataEntry alloc] initWithFrame:prevFrame forOrientation:currOrientation returnMethod:_feeDataCallbacks andNaviButtonsCallback:_naviButtonsCallback andFeesCallback:_feeSearchCallbacks];
        [feesDE addNewFeesData];
        [self addSubview:feesDE];
        return;
    }
    if ([notifyType isEqualToString:@"EditFeesServices"]) 
    {
        if (!feesDE) 
            feesDE = [[feesDataEntry alloc] initWithFrame:prevFrame forOrientation:currOrientation returnMethod:_feeDataCallbacks andNaviButtonsCallback:_naviButtonsCallback andFeesCallback:_feeSearchCallbacks];
        [feesDE editFeesData:[notifyInfo valueForKey:@"data"] forRowNo:[[notifyInfo valueForKey:@"recordNo"] intValue]];
        [self addSubview:feesDE];
        return;
    }
    if ([notifyType isEqualToString:@"FeesDone"]) 
    {
        [memPlanDataObjects addUpdateFeesData:notifyInfo];
    }
    [feesDE removeFromSuperview];
    feesDE = nil;
    _naviButtonsCallback(barButtonInfo);
}


- (void) billCycleNotification:(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectBillCycle"]) 
    {
        billCycleSelect = [[billCycleSearch alloc] initWithFrame:prevFrame forOrientation:currOrientation andReturnMethod:_billcycleCallbacks andNaviButtonsMethod:_naviButtonsCallback];
        [self addSubview:billCycleSelect];
        return;
    }
    if ([notifyType isEqualToString:@"BillCycleSelected"]) 
    {
        [memPlanDataObjects setBillCycle:notifyInfo];
    }
    [billCycleSelect removeFromSuperview];
    billCycleSelect = nil;
    _naviButtonsCallback(barButtonInfo);
    
}

- (void) planTypeNotification:(NSDictionary*) notifyInfo
{
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [notifyInfo valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectPlan"]) 
    {
        planSelect = [[planSearch alloc] initWithFrame:prevFrame forOrientation:currOrientation andReturnMethod:_planTypeCallbacks andNaviButtonsCallback:_naviButtonsCallback];
        [self addSubview:planSelect];
        return;
    }
    if ([notifyType isEqualToString:@"PlanSelected"]) 
    {
        [memPlanDataObjects setMemberPlan:notifyInfo];
    }
    [planSelect removeFromSuperview];
    planSelect = nil;
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
    if (memPlanDataObjects) [memPlanDataObjects setForOrientation:currOrientation];
    if (UIInterfaceOrientationIsPortrait(currOrientation)) 
        [actIndicator setFrame:CGRectMake(365, 484, 37, 37)];
    else
        [actIndicator setFrame:CGRectMake(330, 365, 37, 37)];    
}

- (void) refreshData
{
    
}

-(void) setKeyDictionary:(NSDictionary *)p_keyDict
{
    [memPlanDataObjects setKeyDictionary:p_keyDict];
}

- (void) setInsertMode
{
    currMode = @"I";
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    //NSString *titleName = [[NSString alloc] initWithFormat:@"CONTRACT OF %@ %@", [_initDict valueForKey:@"FIRSTNAME"] , [_initDict valueForKey:@"LASTNAME"]] ;
    titleName = [[NSString alloc] initWithFormat:@"CONTRACT"] ;

    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    //if (!memPlanDataObjects) 
    //[memPlanDataObjects setKeyDictionary:
    [memPlanDataObjects setInsertMode];
    _naviButtonsCallback(barButtonInfo);
}

- (void) setListMode:(NSDictionary *)p_dictData
{
    int l_planStatus = 0;
    currMode = @"L";
    //NSLog(@"the receixved dict info %@", p_dictData);
    //NSString *titleName = [[NSString alloc] initWithFormat:@"CONTRACT ENTRY %@ %@", [_initDict valueForKey:@"FIRSTNAME"] , [_initDict valueForKey:@"LASTNAME"]] ;
    _dispDict = [NSDictionary dictionaryWithDictionary:p_dictData];
    titleName = [[NSString alloc] initWithFormat:@"CONTRACT"] ;
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Back", @"btntitle",  nil];
    //btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    btnEdit = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit",@"btntitle", nil];
    btnTerminate = [[NSDictionary alloc] initWithObjectsAndKeys:@"Terminate", @"btntitle",_terminateCallback,@"btnnotification" ,  nil];
    if (p_dictData) 
    {
        [actIndicator startAnimating];
        METHODCALLBACK l_memDataGenMethod = ^(NSDictionary *p_dictInfo)
        {
            [self memberPlanDataGenerated:p_dictInfo];
        };
        [[gymWSProxy alloc] initWithReportType:@"GETMEMBERPLANDATA" andInputParams:p_dictData andReturnMethod:l_memDataGenMethod];
        l_planStatus = [[p_dictData valueForKey:@"CURRSTATUS"] intValue];
    }
    if (l_planStatus==1) 
    {
        NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
        [nsdf setDateFormat:@"dd-MMM-yyyy"];
        NSDate *ctrctDate = [nsdf dateFromString:[p_dictData valueForKey:@"ENDDATE"]];
        NSTimeInterval timeInterval = [ctrctDate timeIntervalSinceDate:[NSDate date]];
        if (timeInterval<0) 
        {
            titleName = [[NSString alloc] initWithFormat:@"CONTRACT - EXPIRED"] ;
            barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];    
        }
        else
        {
            barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnTerminate,[NSString stringWithFormat:@"%d",101],    btnEdit,[NSString stringWithFormat:@"%d",2] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
        }
    }
    else
    {
        titleName = [[NSString alloc] initWithFormat:@"CONTRACT - TERMINATED"] ;
        barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    }
    _naviButtonsCallback(barButtonInfo);
    
}


- (void) setEditMode
{
    currMode = @"U";
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    titleName = [[NSString alloc] initWithFormat:@"CONTRACTS"] ;
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    [memPlanDataObjects setEditMode];
    _naviButtonsCallback(barButtonInfo);
}


- (void) executeSave
{
    NSString *dataXML;
    //NSString *imageStr;
    if (memPlanDataObjects) {
        [actIndicator startAnimating];
        if ([memPlanDataObjects validateEntries]) 
        {
            dataXML = [[NSString alloc] initWithFormat:@"%@", [memPlanDataObjects getXMLDataForSave]];
            NSDictionary *inputDict = [[NSDictionary alloc] initWithObjectsAndKeys:dataXML, @"p_memberplandata" , nil];
            [[gymWSProxy alloc] initWithReportType:@"ADDUPDATEMEMBERPLAN" andInputParams:inputDict andReturnMethod:_memPlanDataSavedMethod];
        }
        else
            [actIndicator stopAnimating];
    }    
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    
}

@end
