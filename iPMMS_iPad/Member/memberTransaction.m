//
//  memberTransaction.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 25/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberTransaction.h"

@implementation memberTransaction


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"memberBaseController" bundle:nibBundleOrNil];
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
    [self setActuallyIam:@"Plan"];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    currMode =[[NSString alloc] init];
    myFrame = self.view.frame;
    myFrame.origin.y = 0;
    myFrame.origin.x = 0;
    [super viewDidLoad];
    memTransList = [[memberTransList alloc] initWithFrame:myFrame forOrientation:currOrientation  andNotification:@"" withNewDataNotification:@"memTransListGenerated_Main" andDictionary:nil andControllerCallback:_controllerCallBack andNaviButtonsCallback:_navigatorButtonsCallBack];
    [self.view addSubview:memTransList];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [memTransList releaseViewObjects];
    [memTransList removeFromSuperview];
    memTransList = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    currOrientation = toInterfaceOrientation;
    if (memTransList) [memTransList setForOrientation:currOrientation];
    //[self setViewResizedForOrientation:toInterfaceOrientation];
}


- (void) setInsertMode
{

    currMode = @"I";
    [memTransList setInsertMode];
}

- (void) setEmptyMode
{
    
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currDict = [NSDictionary dictionaryWithDictionary:p_dictData];
    //NSLog(@"the current dictionary set is %@", currDict);
    [memTransList setListMode:p_dictData];
}

- (void) setEditMode
{
   /* if (!memPlanView) 
    {
        memPlanView = [[memberPlanView alloc] initWithDictionary:currDict andFrame:myFrame andOrientation:currOrientation forMode:@"U"];
        [self.view addSubview:memPlanView];
    }
    [memPlanView setUpdateMode:planDict];   */ 
    //[memTransView setEditMode];
    [memTransList setEditMode];
    currMode = @"U";
}

- (void) executeSave
{
    //[memTransView executeSave];
    [memTransList executeSave];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    //[self.view addSubview:memTransList];
    [memTransList performAfterSave:p_savedInfo];
}

- (void) executeCancel
{
    ///this really will not executed
    [memTransList executeCancel];
    
}


@end
