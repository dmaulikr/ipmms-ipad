//
//  gymWSProxy.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
 
#import "gymWSProxy.h"

@implementation gymWSProxy

- (void) initWithReportType:(NSString*) resultType andInputParams:(NSDictionary*) prmDict andReturnMethod:(METHODCALLBACK) p_returnMethod
{
    _resultType = [[NSString alloc] initWithFormat:@"%@", resultType];
    //_notificationName = [[NSString alloc] initWithFormat:@"%@", notificationName];
    _proxyReturnMethod = p_returnMethod;
    if (prmDict) 
        inputParms = [[NSDictionary alloc] initWithDictionary:prmDict];
    dictData = [[NSMutableArray alloc] init];
    NSUserDefaults *stdDefaults = [NSUserDefaults standardUserDefaults];
    if ([stdDefaults valueForKey:@"LOCATIONSERVER"]) 
        MAIN_URL = [[NSString alloc] initWithFormat:@"http://%@/", [stdDefaults valueForKey:@"LOCATIONSERVER"]];
    else
        MAIN_URL = [[NSString alloc] initWithFormat:@"%@", HO_URL];
    
    [self generateData];
}

- (void) generateData
{
    NSString *soapMessage,*msgLength,*soapAction;
    NSURL *url;
    NSMutableURLRequest *theRequest;
    NSURLConnection *theConnection;
    
    if ([_resultType isEqualToString:@"GETMEMBERREFUNDSDATA"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getGymMemberRefundData xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_refundid>%@</p_refundid>\n"
                       "</getGymMemberRefundData>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"REFUNDID"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERREFUNDDATA_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/getGymMemberRefundData"];        
    }
    
    if ([_resultType isEqualToString:@"ADDUPDATEMEMBERREFUNDS"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdateMemberRefund xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberrefunddata>%@</p_memberrefunddata>\n"
                       "</addUpdateMemberRefund>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberrefunddata"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV, MEMBERREFUNDADDUPDATE_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/addUpdateMemberRefund"];
    }
    
    if ([_resultType isEqualToString:@"TERMINATEDCONTRACTSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<GymMbTerminatedPlan xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "</GymMbTerminatedPlan>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"MEMBERID"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,TERMINATEDCONTRACTSLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/GymMbTerminatedPlan"];        
    }
    
    if ([_resultType isEqualToString:@"GETMEMBERREFUNDSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<GymMemberRefunds xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "</GymMemberRefunds>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberid"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERREFUNDSLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/GymMemberRefunds"];
    }
    
    if ([_resultType isEqualToString:@"TERMINATEMEMBERPLAN"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<terminateMemberPlan xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberplanid>%@</p_memberplanid>\n"
                       "</terminateMemberPlan>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"MEMBERPLANID"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV, TERMINATEMEMBERPLAN_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/terminateMemberPlan"];
    }
    
    if ([_resultType isEqualToString:@"ADDUPDATEMEMBERNOTES"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdateMemberNotesData xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_membernotesdata>%@</p_membernotesdata>\n"
                       "</addUpdateMemberNotesData>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_membernotesdata"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV, MEMBERNOTESADDUPDATE_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/addUpdateMemberNotesData"];
    }
    
    if ([_resultType isEqualToString:@"NOTESTYPESLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getGenConstantsList xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_datanature>%@</p_datanature>\n"
                       "</getGenConstantsList>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_datanature"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,GETGENCONSTANTSLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/getGenConstantsList"];
    }

    if ([_resultType isEqualToString:@"GETMEMBERNOTESLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<GymMemberNotes xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "</GymMemberNotes>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberid"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERNOTESLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/GymMemberNotes"];
    }
    
    if ([_resultType isEqualToString:@"ADDUPDATEMEMBERTRANS"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdateMemberTransData xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_membertransdata>%@</p_membertransdata>\n"
                       "</addUpdateMemberTransData>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_membertransdata"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV, MEMBERTRANSADDUPDATE_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/addUpdateMemberTransData"];
    }

    if ([_resultType isEqualToString:@"BANKNAMESLIST"]==YES) 
    {
        soapMessage = [NSString stringWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getBankNamesList xmlns=\"http://com.aahg.gymws/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,GETBANKNAMESLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/getBankNamesList"];
    }
    
    if ([_resultType isEqualToString:@"GETMEMBERTRANSDATA"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getCollectioandPendingItems xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "<p_membertransid>%@</p_membertransid>\n"
                       "</getCollectioandPendingItems>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"MEMBERID"],[inputParms valueForKey:@"ENTRYID"] ];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV, GETMEMBERTRANSDATA_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/getCollectioandPendingItems"];
    }
    
    if ([_resultType isEqualToString:@"GETMEMBERTRANSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getMemberTransactionsList xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "</getMemberTransactionsList>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberid"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,GETMEMBERTRANSLIST_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/getMemberTransactionsList"];
    }
    
    if ([_resultType isEqualToString:@"GETMEMBERPLANDATA"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getMemberPlanData xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberplanid>%@</p_memberplanid>\n"
                       "</getMemberPlanData>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"MEMBERPLANID"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV, GETMEMBERPLANDATA_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/getMemberPlanData"];
    }
    
    if ([_resultType isEqualToString:@"ADDUPDATEMEMBERPLAN"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdateMemberPlanData xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberplandata>%@</p_memberplandata>\n"
                       "</addUpdateMemberPlanData>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberplandata"]];
        //NSLog(@"the soap message is %@", soapMessage);
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV, MEMBERPLANADDUPDATE_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/addUpdateMemberPlanData"];
    }
    
    if ([_resultType isEqualToString:@"BILLCYCLESLIST"]==YES) 
    {
        soapMessage = [NSString stringWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<getBillCyclesList xmlns=\"http://com.aahg.gymws/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,BILLCYCLES_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/getBillCyclesList"];
    }
    
    if ([_resultType isEqualToString:@"LOCATIONSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<LocationsData xmlns=\"http://com.aahg.gymws/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HO_URL,WS_ENV,LOCATIONS_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/LocationsData"];
    }

    
    if ([_resultType isEqualToString:@"MEMBERPLANSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<GymMemberPlan xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "</GymMemberPlan>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberid"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERPLANDATA_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/GymMemberPlan"];
    }

    if ([_resultType isEqualToString:@"FEESLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<FeesData xmlns=\"http://com.aahg.gymws/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,FEESDATA_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/FeesData"];
    }

    
    if ([_resultType isEqualToString:@"ADDUPDATEMEMBER"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<addUpdateMemberData xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberdata>%@</p_memberdata>\n"
                       "<p_memberImage>%@</p_memberImage>\n"
                       "</addUpdateMemberData>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_memberdata"], [inputParms valueForKey:@"p_memberImage"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV, MEMBERADDUPDATE_URL]];
        NSLog(@"the soap message is %@", soapMessage);
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/addUpdateMemberData"];
    }
    
    if ([_resultType isEqualToString:@"MEMBERDATA"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<MemberData xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_memberid>%@</p_memberid>\n"
                       "</MemberData>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"MEMBERID"]];
        //NSLog(@"member data soap msg %@", soapMessage);
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERDATA_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/MemberData"];
    }

    
    if ([_resultType isEqualToString:@"NATIONSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<NationalitiesList xmlns=\"http://com.aahg.gymws/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,NATIONALITIES_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/NationalitiesList"];
    }

    
    if ([_resultType isEqualToString:@"PLANSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<PlansList xmlns=\"http://com.aahg.gymws/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,PLANS_URL]];
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/PlansList"];
    }

    
    if ([_resultType isEqualToString:@"EMIRATESLIST"]) 
    {
        NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
        [returnInfo setValue:nil forKey:@"data"];
        _proxyReturnMethod(returnInfo);
        return;
    }
    
    if ([_resultType isEqualToString:@"NEWBARCODE"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<NewBarcodeToMember xmlns=\"http://com.aahg.gymws/\" />\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>"];     
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL, WS_ENV, NEWBARCODE_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/NewBarcodeToMember"];
    }
    
    if ([_resultType isEqualToString:@"USERLOGIN"]) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<userLogin xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_usercode>%@</p_usercode>\n"
                       "<p_passWord>%@</p_passWord>\n"
                       "</userLogin>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>", [inputParms valueForKey:@"p_eMail"],[inputParms valueForKey:@"p_passWord"]];     
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HO_URL, WS_ENV, LOGIN_URL]];
        
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/userLogin"];
    }

    if ([_resultType isEqualToString:@"MEMBERSLIST"]==YES) 
    {
        soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                       "<soap:Body>\n"
                       "<MembersList xmlns=\"http://com.aahg.gymws/\">\n"
                       "<p_searchtext>%@</p_searchtext>\n"
                       "</MembersList>\n"
                       "</soap:Body>\n"
                       "</soap:Envelope>",[inputParms valueForKey:@"p_searchtext"]];
        
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",MAIN_URL,WS_ENV,MEMBERSLIST_URL]];
        //NSLog(@"the url link is %@",url);
        soapAction = [NSString stringWithFormat:@"%@",@"http://com.aahg.gymws/MembersList"];
    }
    
    theRequest = [NSMutableURLRequest requestWithURL:url];
    msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if(theConnection)
        webData = [[NSMutableData alloc] init];
    else 
        NSLog(@"theConnection is NULL");
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self processAndReturnXMLMessage];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *errmsg = [error description];
    [self showAlertMessage:errmsg];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict   
{
    [parseElement setString:elementName];
    if ([elementName isEqualToString:@"Table"]) {
        resultDataStruct = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([parseElement isEqualToString:@""]==NO) 
        [resultDataStruct setValue:string forKey:parseElement];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [parseElement setString:@""];
    if ([elementName isEqualToString:@"Table"]) 
    {
        if (resultDataStruct) 
            [dictData addObject:resultDataStruct];
        
    }
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) processAndReturnXMLMessage
{
    parseElement = [[NSMutableString alloc] initWithString:@""];	
	NSString *theXML = [self htmlEntityDecode:[[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding]];
    //NSLog(@"the data received %@",theXML);
    if (theXML) {
        if ([theXML isEqualToString:@""]==YES) 
            [self showAlertMessage:@"Web service failure"];
    }
    else
    {
        [self showAlertMessage:@"Web service failure"];
        return;
    }
    /*xmlParser = [[NSXMLParser alloc] initWithData:webData];*/
    @try 
    {
        xmlParser = [[NSXMLParser alloc] initWithData:[theXML dataUsingEncoding:NSUTF8StringEncoding]];
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        [xmlParser parse];
    }
    @catch (NSException *exception) {
        [self showAlertMessage:[exception description]];
        return;
    }
    
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    [returnInfo setValue:dictData forKey:@"data"];
    //NSLog(@"the returned notification is %@ and input params %@", _notificationName, inputParms);
    /*if ([_notificationName isEqualToString:@"memberDataNotify_MV"]) 
    {
        NSLog(@"the return info is %@", returnInfo);
    }*/
    _proxyReturnMethod(returnInfo);
}

-(NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    return string;
}

-(NSString *)htmlEntitycode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"];
    string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
    string = [string stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    string = [string stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
    string = [string stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    return string;
}

@end
