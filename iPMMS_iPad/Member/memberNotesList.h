//
//  memberNotesList.h
//  iPMMS_iPad
//
//  Created by Macintosh User on 1/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseSearchForm.h"
#import "memberFunctions.h"
#import "memberNotesEntry.h"

@interface memberNotesList : baseSearchForm <UITableViewDataSource, UITableViewDelegate, memberFunctions>
{
    int refreshTag;
    NSString /**_notificationName, *_proxynotification,*/ *_webdataName, *_cacheName /*,*_gobacknotifyName*/;
    NSString *currMode;
    NSInteger viewItemNo;
    NSIndexPath *curIndPath;
    NSDictionary *_initDict;
    NSMutableDictionary *barButtonInfo;
    UIColor *bgcolor;
    NSDictionary *btnInsert /*, *btnMember, *btnContract , *btnTrans, *btnRefunds*/;
    NSNumberFormatter *frm;
    NSDateFormatter *nsdf;
    memberNotesEntry *memNotesEntry;
    METHODCALLBACK _controllerCallBack, _naviButtonsCallback;
}

- (id)initWithFrame:(CGRect)frame forOrientation:(UIInterfaceOrientation) p_intOrientation andDictionary:(NSDictionary*) p_initDict andControllerCallBack:(METHODCALLBACK) p_controllerCallBack andNaviButtonsCallback:(METHODCALLBACK) p_naviButtonsCallback;
- (UITableViewCell*) getDisplayCellforRow:(int) p_RowNo;
- (IBAction)viewSelectedItem:(id)sender;
- (void) memberNotesListDataGenerated:(NSDictionary *)generatedInfo;
@end
