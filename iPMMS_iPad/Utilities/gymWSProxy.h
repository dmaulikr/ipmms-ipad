//
//  gymWSProxy.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "defaults.h"

@interface gymWSProxy : NSObject <NSXMLParserDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSString *_resultType;
	NSMutableData *webData;
    NSXMLParser *xmlParser; 
	NSMutableString *parseElement,*value;
    NSMutableString *respcode, *respmessage;
    NSMutableDictionary *resultDataStruct;
    NSMutableArray *dictData;
    //NSString *_notificationName;
    NSDictionary *inputParms;
    NSString *MAIN_URL;
    METHODCALLBACK _proxyReturnMethod;
}

- (void) initWithReportType:(NSString*) resultType andInputParams:(NSDictionary*) prmDict andReturnMethod:(METHODCALLBACK) p_returnMethod;
- (void) generateData;
- (void) showAlertMessage:(NSString *) dispMessage;
- (void) processAndReturnXMLMessage;
- (NSString *)htmlEntityDecode:(NSString *)string;
- (NSString *)htmlEntitycode:(NSString *)string;

@end
