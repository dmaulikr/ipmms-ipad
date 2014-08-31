//
//  memberPlans.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberPlans.h"

@implementation memberPlans


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
    myFrame = self.view.frame;
    myFrame.origin.y = 0;
    myFrame.origin.x = 0;
    [super viewDidLoad];
    memPlansList = [[memberPlansList alloc] initWithFrame:myFrame forOrientation:currOrientation andControllerCallBack:_controllerCallBack andNaviButtonsCallback:_navigatorButtonsCallBack];
    [self.view addSubview:memPlansList];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    [memPlansList releaseViewObjects];
    [memPlansList removeFromSuperview];
    memPlansList = nil;
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
    if (memPlansList) [memPlansList setForOrientation:currOrientation];
    //[self setViewResizedForOrientation:toInterfaceOrientation];
}


- (void) setInsertMode
{
    /*memPlanView = [[memberPlanEntry alloc] initWithDictionary:currDict andFrame:myFrame andOrientation:currOrientation forMode:@"I"];
    [memPlanView setInsertMode];
    [self.view addSubview:memPlanView];*/
    [memPlansList setKeyDictionary:currDict];
    [memPlansList setInsertMode];
}

- (void) setEmptyMode
{
    
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currDict = [NSDictionary dictionaryWithDictionary:p_dictData];
    //NSLog(@"the current dictionary set is %@", currDict);
    [memPlansList setListMode:p_dictData];
}

- (void) setEditMode
{
    /*if (!memPlanView) 
    {
        memPlanView = [[memberPlanView alloc] initWithDictionary:currDict andFrame:myFrame andOrientation:currOrientation forMode:@"U"];
        [self.view addSubview:memPlanView];
    }
    [memPlanView setUpdateMode:planDict];*/
    //[memPlanView setEditMode];
    [memPlansList setEditMode];
}

- (void) executeSave
{
    //[memPlanView executeSave];
    [memPlansList executeSave];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    [self.view addSubview:memPlansList];
    [memPlansList setListMode:currDict];
}

- (void) executeCancel
{
    ///this really will not executed
    [memPlansList executeCancel];
}


@end
