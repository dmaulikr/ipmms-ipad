//
//  memberController.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberController.h"
#import "memberTransController.h"

@implementation memberController

@synthesize memTransaction = _memTransController;

- (id) initWithReloginMethod:(METHODCALLBACK) p_reloginMethod
{
    self = [super initWithNibName:@"memberController" bundle:nil];
    if (self) {
        _reloginMethod = p_reloginMethod;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Members", @"Members");
        //self.clearsSelectionOnViewWillAppear = NO;
        //self.view.frame = CGRectMake(0, 0, 320, 768);
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
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
    [self initialize];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(ButtonPressed:)];
    btnRefresh.tag = 0;
    UIBarButtonItem *btnExit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(ButtonPressed:)];
    btnExit.tag = 9;
    self.navigationItem.leftBarButtonItem = btnRefresh;
    self.navigationItem.rightBarButtonItem = btnExit;
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4]];
    [self generateMembersList];
    [super viewDidLoad];
    [self setViewResizedForOrientation:currOrientation];
    METHODCALLBACK l_controllerMethod = ^(NSDictionary *p_dictInfo)
    {
        [self controllerNotification:p_dictInfo];
    };
    [_memTransController setControllerCallBack:l_controllerMethod];
    METHODCALLBACK l_memberInfoUpdate = ^(NSDictionary *p_dictInfo)
    {
        [memSearch memberControllerInfoUpdate:p_dictInfo];
    };
    [_memTransController setMemberInfoUpdateMethod:l_memberInfoUpdate];
    // Do any additional setup after loading the view from its nib.
}


- (void) initialize
{
    currMode = [[NSString alloc] init];
}


- (void)viewDidUnload
{
    [memSearch releaseViewObjects];
    [memSearch removeFromSuperview];
    memSearch = nil;
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


-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currOrientation = toInterfaceOrientation;
    [self setViewResizedForOrientation:toInterfaceOrientation];
}

- (void) setViewResizedForOrientation:(UIInterfaceOrientation) p_intOrientation
{
    if (memSearch) 
        [memSearch setForOrientation:p_intOrientation];
    /*if (UIInterfaceOrientationIsLandscape(currOrientation)) 
        [self addAddButton];*/
}

- (void) generateMembersList
{
    CGRect myFrame = self.view.frame;
    myFrame.origin.y = 0;
    myFrame.origin.x = 0;
    METHODCALLBACK l_memSearchReturn = ^(NSDictionary* p_dictInfo)
    {
        [self searchMemberReturn:p_dictInfo];
    };
    memSearch = [[memberSearch alloc] initWithFrame:myFrame forOrientation:currOrientation  andReturnMethod:l_memSearchReturn];
    [self.view addSubview:memSearch];
}

- (void) searchMemberReturn:(NSDictionary *)memberInfo
{
    currDict =[[NSDictionary alloc] initWithDictionary:[memberInfo valueForKey:@"data"]];
    //NSLog(@"curr mode is %@ and data is %@", currMode, currDict);
    if (!([currMode isEqualToString:@"I"] | [currMode isEqualToString:@"U"])) 
    {
        if (memberInfo) 
            [self setListMode:[memberInfo valueForKey:@"data"]];
    }
    [self setViewResizedForOrientation:currOrientation];
}

- (void) setEmptyMode
{
    //[_memTransController viewDidLoad];
    //NSLog(@"set empty mode from controller fired");
    currMode = @"E";
    [_memTransController setEmptyMode];
}

- (void) setEditMode
{
    currMode =@"U";
    if (memSearch) [memSearch setEditMode];
    [_memTransController setEditMode];
}

- (void) setInsertMode
{
    //self.navigationItem.leftBarButtonItems = nil;
    //self.navigationItem.rightBarButtonItems = nil;
    currMode = @"I";
    if (memSearch) [memSearch setInsertMode];
    [_memTransController setInsertMode];
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currMode = @"L";
    [_memTransController setListMode:p_dictData];
    if (memSearch) [memSearch setListMode:nil];
}

- (void) executeSave
{
    [_memTransController executeSave];
}

- (void) executeCancel
{
    currMode = @"L";
    [memSearch executeCancel];
    //if (currDict) 
      //  [self setListMode:currDict];
    [_memTransController executeCancel];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    currMode = @"L";
    if (memSearch) [memSearch performAfterSave:p_savedInfo];
    [_memTransController performAfterSave:p_savedInfo];
}

- (void) controllerNotification:(NSDictionary*) notifyInfo
{
    NSString *recdMode = [notifyInfo valueForKey:@"data"];
    //NSLog(@"controller notification %@", recdMode);
    
    if ([recdMode isEqualToString:@"Empty"]) 
    {
        [self setEmptyMode];
        if (currDict) 
            [self setListMode:currDict];
    }

    if ([recdMode isEqualToString:@"Insert"]) 
        [self setInsertMode];
    
    if ([recdMode isEqualToString:@"Edit"]) 
        [self setEditMode];

    if ([recdMode isEqualToString:@"List"]) 
    {
        //currMode = @"L";
        if (currDict) 
            [self setListMode:currDict];
        /*else
            [memSearch refreshData:nil];*/
    }

    if ([recdMode isEqualToString:@"Save"]) 
    {
        [self executeSave];
    }
    
    if ([recdMode isEqualToString:@"AfterSave"]) {
        NSDictionary *recdInfo = [notifyInfo valueForKey:@"savedData"];
        //NSLog(@"the after save data received %@", recdInfo);
        [self performAfterSave:recdInfo];
    }
    
    if ([recdMode isEqualToString:@"Cancel"]) 
        [self executeCancel];
    
}


- (IBAction) ButtonPressed:(id)sender
{
    UIBarButtonItem *recdBtn = (UIBarButtonItem*) sender;
    switch (recdBtn.tag) {
        case 0: //refresh button pressed
            //notifyInfo = [[NSDictionary alloc] initWithObjectsAndKeys:@"List",@"data", nil];
             [memSearch refreshData:nil];
            break;
        case 9:
            dAlert = [[UIAlertView alloc] initWithTitle:@" " message:@"Are you sure\nto Logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            dAlert.cancelButtonIndex = 0;
            dAlert.delegate = self;
            dAlert.tag = 100;
            [dAlert show];
            break;
        default:
            break;
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=0) 
    {
        switch (alertView.tag) 
        {
            case 100:
                _reloginMethod(nil);
                break;
            default:
                break;
        }
    }
}

@end
