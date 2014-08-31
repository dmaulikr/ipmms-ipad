//
//  memberTransController.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberTransController.h"

@implementation memberTransController

@synthesize memberMasterPop;
@synthesize tab;

- (id) initWithMemberDictionary:(NSDictionary*) p_memDict
{
    self = [super initWithNibName:@"memberTransController" bundle:nil];
    if (self) {
        /*if (p_memDict) 
            _memInitialdata = [[NSDictionary alloc] initWithDictionary:p_memDict];
        else
            _memInitialdata = nil;*/
    }
    //imgPicker.delegate = self;
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    __block id myself = self;
    _photoCallBack = ^(NSDictionary *p_dictInfo)
    {
        [myself grabPhoto:p_dictInfo];
    };
    _navigateControllerCallBack = ^(NSDictionary *p_dictInfo)
    {
        [myself navigateMemberController:p_dictInfo];
    };
    _navigatorButtonsCallBack = ^(NSDictionary *p_dictInfo)
    {
        [myself navigationNotification:p_dictInfo];
    };
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    memProfile = [self.tab.viewControllers objectAtIndex:0];
    [memProfile setControllerCallBack:_controllerCallBack];
    [memProfile setPhotoNotifyMethod:_photoCallBack];
    [memProfile setNavigatorControllerCallBack:_navigateControllerCallBack];
    [memProfile setNavigatorButtonsCallBack:_navigatorButtonsCallBack];
    memPlans = [self.tab.viewControllers objectAtIndex:1];
    [memPlans setControllerCallBack:_controllerCallBack];
    [memPlans setNavigatorControllerCallBack:_navigateControllerCallBack];
    [memPlans setNavigatorButtonsCallBack:_navigatorButtonsCallBack];
    memTrans = [self.tab.viewControllers objectAtIndex:2];
    [memTrans setControllerCallBack:_controllerCallBack];
    [memTrans setNavigatorControllerCallBack:_navigateControllerCallBack];
    [memTrans setNavigatorButtonsCallBack:_navigatorButtonsCallBack];
    memNotes = [self.tab.viewControllers objectAtIndex:3];
    [memNotes setControllerCallBack:_controllerCallBack];
    [memNotes setNavigatorControllerCallBack:_navigateControllerCallBack];
    [memNotes setNavigatorButtonsCallBack:_navigatorButtonsCallBack];
    memRefunds = [self.tab.viewControllers objectAtIndex:4];
    [memRefunds setControllerCallBack:_controllerCallBack];
    [memRefunds setNavigatorControllerCallBack:_navigateControllerCallBack];
    [memRefunds setNavigatorButtonsCallBack:_navigatorButtonsCallBack];
    memCtrl = memProfile;
    [self.view addSubview:self.tab.view];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:89.0/255.0 alpha:1.0]];
    [super viewDidLoad];
    NSDictionary *startInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Empty",@"data", nil];
    _controllerCallBack(startInfo);
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    btnTransactions = [self getButtonForNavigation:@"Main"];
    self.navigationItem.leftBarButtonItem = btnTransactions;
    
    memberTransactionPopover *mtp = [[memberTransactionPopover alloc] initWithNibName:@"memberController" bundle:nil];
    [mtp setNavigatorCallBack:_navigateControllerCallBack];
    self.memberMasterPop = [[UIPopoverController alloc] initWithContentViewController:mtp];
    [self.memberMasterPop setPopoverContentSize:CGSizeMake(125, 225)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [memProfile viewDidUnload];
    [memPlans viewDidUnload];
    [memTrans viewDidUnload];
    [memNotes viewDidUnload];
    [memRefunds viewDidUnload];
    [self.tab viewDidUnload];
    [self.tab.view removeFromSuperview];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	//return YES;
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation
{
    //[memCtrl setForOrientation:p_intOrientation];
    //if (memView) [memView setForOrientation:currOrientation];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currOrientation = toInterfaceOrientation;
    //[self setViewResizedForOrientation:toInterfaceOrientation];
    return [memCtrl willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Member", @"Member");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.memberMasterPop = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.memberMasterPop = nil;
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currDict = [NSDictionary dictionaryWithDictionary:p_dictData];
    [memCtrl setListMode:p_dictData];
}

- (void) setInsertMode
{
    [memCtrl setInsertMode];
}

- (void) executeSave
{
    [memCtrl executeSave];
}

- (void) executeCancel
{
    [memCtrl executeCancel];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    [memCtrl performAfterSave:p_savedInfo];
}

- (void) setEmptyMode
{
    [memCtrl setEmptyMode];
}

- (id) getButtonForNavigation:(NSString*) p_btnTask
{
    UIBarButtonItem *retBtn;
    
    if ([p_btnTask isEqualToString:@"Insert"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 1;
    }
    else if ([p_btnTask isEqualToString:@"Edit"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 2;
    }
    else if ([p_btnTask isEqualToString:@"List"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 0;
    }
    else if ([p_btnTask isEqualToString:@"Cancel"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 3;
    }
    else if ([p_btnTask isEqualToString:@"Save"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 4;
    }
    else if ([p_btnTask isEqualToString:@"Main"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithTitle:p_btnTask style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        retBtn.tag = 5;
    }
    else
    //if ([p_btnTask isEqualToString:@"Plan"]) 
    {
        retBtn = [[UIBarButtonItem alloc] initWithTitle:p_btnTask style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
        //retBtn.tag = 4;
    }
    
    return retBtn;
}

- (void) setEditMode
{
    [memCtrl setEditMode];
}

- (IBAction) ButtonPressed:(id)sender
{
    NSDictionary *notifyInfo;
    NSDictionary *customNotifyData;
    BOOL isCustomNotification = NO;
    UIBarButtonItem *recdBtn = (UIBarButtonItem*) sender;
    switch (recdBtn.tag) {
        case 0: //refresh button pressed
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"List",@"data", nil];
            break;
        case 1: // Add button clicked
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Insert",@"data", nil];
            //[self setInsertMode];
            break;
        case 2:  // edit button clicked
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Edit",@"data", nil];
            break;
        case 3:
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Cancel",@"data", nil];
            break;
        case 4:
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"Save",@"data", nil];
            break;
        case 5:
            if ([self.memberMasterPop isPopoverVisible]) 
                [self.memberMasterPop dismissPopoverAnimated:YES];
            else
                [self.memberMasterPop presentPopoverFromBarButtonItem:btnTransactions permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            break;
        default:
            notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",recdBtn.tag],@"data", nil];
            isCustomNotification = YES;
            customNotifyData = [custNotifyInfo objectForKey:[NSString stringWithFormat:@"%d",recdBtn.tag]];
            break;
    }
    if (isCustomNotification) 
    {
        METHODCALLBACK l_notifyMethod = [customNotifyData valueForKey:@"btnnotification"];
        l_notifyMethod(notifyInfo);
    }
    else
        _controllerCallBack(notifyInfo);
}

- (void) navigationNotification :(NSDictionary*) p_navigateInfo
{
    NSMutableArray *rightButtonItems = [[NSMutableArray alloc] init];
    NSMutableArray *leftButtonItems = [[NSMutableArray alloc] init];
    custNotifyInfo =[[NSDictionary alloc] initWithDictionary:p_navigateInfo];
    //NSLog(@"received information %@", custNotifyInfo);
    for (id key in custNotifyInfo) 
    {
        if ([key intValue] > 0) 
        {
            NSDictionary *noteData = [custNotifyInfo objectForKey:key];
            //NSLog(@"key data is %@", noteData);
            UIBarButtonItem *newBtn = [self getButtonForNavigation:[noteData valueForKey:@"btntitle"]];
            newBtn.tag = [key intValue];
            /*if ([key intValue]>4) 
                [leftButtonItems addObject:newBtn];
            else*/
                [rightButtonItems addObject:newBtn];
        }
    }
    if (([leftButtonItems count]+[rightButtonItems count])>0)
    {
        self.navigationItem.title = [custNotifyInfo valueForKey:@"navititle"];
        if ([custNotifyInfo valueForKey:@"bgcolor"]) 
            [self.view setBackgroundColor:[custNotifyInfo valueForKey:@"bgcolor"]];
    }
    self.navigationItem.rightBarButtonItems = rightButtonItems;
    //self.navigationItem.leftBarButtonItems = leftButtonItems;
}


- (void)grabPhoto:(NSDictionary*) photoInfo
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imgPicker animated:YES];
    }
    else
        [self showAlertMessage:@"Camera is not available"];
}

- (void) showAlertMessage:(NSString *) dispMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:dispMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSMutableDictionary *returnInfo = [[NSMutableDictionary alloc] init];
    UIImage *image;
    image = (UIImage *) [info valueForKey:UIImagePickerControllerEditedImage];
    if (image == nil) 
    {
        image = (UIImage *)[info valueForKey:UIImagePickerControllerOriginalImage];
        [returnInfo setValue:image forKey:@"photo"];
    }
    else
    {
        [returnInfo setValue:image forKey:@"photo"];
    }
    [memProfile newPhotoTaken:returnInfo];
    [self dismissModalViewControllerAnimated:YES];
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) navigateMemberController:(NSDictionary*) naviInfo
{
    [self.memberMasterPop dismissPopoverAnimated:YES];
    NSString *selIndex = [naviInfo  valueForKey:@"data"];
    int intSelIndex = [selIndex intValue];
    if (intSelIndex==tab.selectedIndex) 
        return;
    switch (intSelIndex) 
    {
        case 200:
            tab.selectedViewController = [tab.viewControllers objectAtIndex:0];
            tab.selectedIndex = 0;
            memCtrl = memProfile;
            break;
        case 201:
            tab.selectedViewController = [tab.viewControllers objectAtIndex:1];
            tab.selectedIndex = 1;
            memCtrl = memPlans;
            break;
        case 202:
            tab.selectedViewController = [tab.viewControllers objectAtIndex:2];
            tab.selectedIndex = 2;
            memCtrl = memTrans;
            break;
        case 203:
            tab.selectedViewController = [tab.viewControllers objectAtIndex:3];
            tab.selectedIndex = 3;
            memCtrl = memNotes ;
            break;
        case 204:
            tab.selectedViewController = [tab.viewControllers objectAtIndex:4];
            tab.selectedIndex = 4;
            memCtrl = memRefunds;
            break;
        default:
            break;
    }
    NSDictionary *returnInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",tab.selectedIndex], @"data", nil];
    if (_memberInfoUpdate)
        _memberInfoUpdate(returnInfo);
    [memCtrl setListMode:currDict];
}

- (void) setMemberInfoUpdateMethod:(METHODCALLBACK) p_memberInfoUpdate
{
    _memberInfoUpdate = p_memberInfoUpdate;
}

- (void) setControllerCallBack:(METHODCALLBACK) p_controllerCallBack
{
    [super setControllerCallBack:p_controllerCallBack];
    
    if (memProfile) 
        [memProfile setControllerCallBack:_controllerCallBack];
    
    if (memPlans)
        [memPlans setControllerCallBack:_controllerCallBack];
    
    if (memTrans) 
        [memTrans setControllerCallBack:_controllerCallBack];
    
    if (memNotes) 
        [memNotes setControllerCallBack:_controllerCallBack];
    
    if (memRefunds) 
        [memRefunds setControllerCallBack:_controllerCallBack];
}

@end
