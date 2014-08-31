//
//  membrPlanEntry.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 26/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "membrPlanEntry.h"

@implementation membrPlanEntry

- (id) initWithDictionary:(NSDictionary *)p_dict andFrame:(CGRect)p_frame andOrientation:(UIInterfaceOrientation)p_intOrientation forMode:(NSString *)p_forMode
{
    self = [self initWithFrame:p_frame]; //   [self initWithFrame:p_frame];
    bgcolor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:89.0f/255.0f alpha:1.0];
    currMode = [[NSString alloc] initWithFormat:@"%@", p_forMode];
    [self addNIBView:@"memberBaseView" forFrame:p_frame];
    [parentScroll setFrame:CGRectMake(0, 0, 703, 650)];
    prevFrame = p_frame;
    currOrientation = p_intOrientation;
    _initDict = p_dict;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberPlanDataSaved:)  name:@"memberPlanDataSaved" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memberPlanDataGenerated:)  name:@"memberPlanDataGenerated" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(billCycleNotification:)  name:@"billCycleNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(planTypeNotification:)  name:@"planTypeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feesNotification:)  name:@"feesNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotificaiton:) name:@"locationNotify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(feesNotificaiton:) name:@"feesNotify" object:nil];
    actIndicator.transform = CGAffineTransformMakeScale(5.00, 5.00);  
    [self setForOrientation:currOrientation];
    return self;    
}

- (void) memberPlanDataSaved:(NSNotification*) savedInfo
{
    
}

- (void) memberPlanDataGenerated:(NSNotification*) memberPlanData
{
    NSDictionary *recdData = [memberPlanData userInfo];
    memPlanDataObjects = [[memberPlanObjects alloc] initWithDictionary:_initDict andFrame:prevFrame andOrientation:currOrientation forMode:currMode];
    [memPlanDataObjects setListMode:recdData];
    [actIndicator stopAnimating];
}

- (void) billCycleNotification:(NSNotification*) notifyInfo
{
    NSDictionary *recdData = [notifyInfo userInfo];
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [recdData valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectBillCycle"]) 
    {
        billCycleSelect = [[billCycleSearch alloc] initWithFrame:prevFrame forOrientation:currOrientation andNotification:@"billCycleNotification" withNewDataNotification:@"billCycleDataGen_MPV"];
        [self addSubview:billCycleSelect];
        return;
    }
    if ([notifyType isEqualToString:@"BillCycleSelected"]) 
    {
        [memPlanDataObjects setBillCycle:recdData];
    }
    [billCycleSelect removeFromSuperview];
    billCycleSelect = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationNotify" object:self userInfo:barButtonInfo];
}

- (void) planTypeNotification:(NSNotification*) notifyInfo
{
    NSDictionary *recdData = [notifyInfo userInfo];
    NSString *notifyType = [[NSString alloc] initWithFormat:@"%@", [recdData valueForKey:@"notify"]];
    if ([notifyType isEqualToString:@"SelectPlan"]) 
    {
        planSelect = [[planSearch alloc] initWithFrame:prevFrame forOrientation:currOrientation andNotification:@"planTypeNotification" withNewDataNotification:@"planTypeDataGen_MPV"];
        [self addSubview:planSelect];
        return;
    }
    if ([notifyType isEqualToString:@"PlanSelected"]) 
    {
        [memPlanDataObjects setMemberPlan:recdData];
    }
    [planSelect removeFromSuperview];
    planSelect = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationNotify" object:self userInfo:barButtonInfo];   
}

- (void) feesNotification:(NSNotification*) notifyInfo
{
    
    
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

- (void) setInsertMode
{
    currMode = @"I";
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    NSString *titleName = [[NSString alloc] initWithFormat:@"CONTRACT OF %@ %@", [_initDict valueForKey:@"FIRSTNAME"] , [_initDict valueForKey:@"LASTNAME"]] ;
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    memPlanDataObjects = [[memberPlanObjects alloc] initWithDictionary:_initDict andFrame:prevFrame andOrientation:currOrientation forMode:currMode];
    if (memPlanDataObjects) [memPlanDataObjects setInsertMode];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationNotify" object:self userInfo:barButtonInfo];
}

- (void) setListMode:(NSDictionary *)p_dictData
{
    currMode = @"L";
    NSString *titleName = [[NSString alloc] initWithFormat:@"CONTRACT ENTRY %@ %@", [_initDict valueForKey:@"FIRSTNAME"] , [_initDict valueForKey:@"LASTNAME"]] ;
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Back", @"btntitle",  nil];
    //btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    btnEdit = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit",@"btntitle", nil];
    if (p_dictData) 
    {
        [actIndicator startAnimating];
        mdProxy = [[gymWSProxy alloc] initWithReportType:@"GETMEMBERPLANDATA" andInputParams:p_dictData andNotificatioName:@"memberPlanDataGenerated"];
    }
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnEdit,[NSString stringWithFormat:@"%d",2] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationNotify" object:self userInfo:barButtonInfo];
}

- (void) setEditMode
{
    currMode = @"U";
    btnCancel = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel", @"btntitle",  nil];
    btnSave = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save", @"btntitle",  nil];
    NSString *titleName = [[NSString alloc] initWithFormat:@"CONTRACT OF %@ %@", [_initDict valueForKey:@"FIRSTNAME"] , [_initDict valueForKey:@"LASTNAME"]] ;
    barButtonInfo = [[NSMutableDictionary alloc] initWithObjectsAndKeys:btnSave,[NSString stringWithFormat:@"%d",4] ,btnCancel,[NSString stringWithFormat:@"%d",3], titleName ,@"navititle" ,bgcolor, @"bgcolor",nil];
    [memPlanDataObjects setEditMode];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"navigationNotify" object:self userInfo:barButtonInfo];
}

- (void) setUpdateMode:(NSDictionary *)p_dictData
{
    
}

- (void) executeSave
{
    
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    
}

@end
