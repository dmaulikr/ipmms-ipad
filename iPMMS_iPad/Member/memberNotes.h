//
//  memberNotes.h
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "memberBaseController.h"
#import "memberNotesList.h"

@interface memberNotes : memberBaseController <UISplitViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    memberNotesList *memNotesList;
    UIInterfaceOrientation currOrientation;
    UINavigationItem *_navItem;
    CGRect myFrame;
    NSDictionary *planDict;
}

@end
