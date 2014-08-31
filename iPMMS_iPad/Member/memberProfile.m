//
//  memberProfile.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberProfile.h"

@implementation memberProfile


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"memberBaseController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //NSLog(@"member profile init is fired");
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
    //self setactuallyIam = [[NSString alloc] initWithString:@"Profile"];
    [self setActuallyIam:@"Profile"];
    /*self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"View" style:UIBarButtonItemStylePlain target:self action:@selector(ButtonPressed:)];*/
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    //NSLog(@"memprofile view didload fired");
    [memView releaseViewObjects];
    [memView removeFromSuperview];
    memView = nil;
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
    if (memView) [memView setForOrientation:currOrientation];
    //[self setViewResizedForOrientation:toInterfaceOrientation];
}


- (void) setInsertMode
{
    if (memView) [memView setInsertMode];
}

- (void) setEmptyMode
{
    //NSLog(@"frame origin x %f origin y %f width %f and height %f", myframe.origin.x, myframe.origin.y, myframe.size.width, myframe.size.height);
    CGRect myframe = self.view.frame;
    myframe.origin.y=0;
    myframe.origin.x = 0;
    if (!memView)
    {
        NSLog(@"set empty mode is fired");
        memView = [[memberView alloc] initWithDictionary:nil andFrame:myframe andOrientation:currOrientation forMode:@"E" andControllerCallback:_controllerCallBack andPhotoCallBack:_photoNotifyMethod andNavigatorCallBack:_navigateControllerCallBack andNaviButtonsCallback:_navigatorButtonsCallBack];
        [self.view addSubview:memView];
    }
    [memView setEmptyMode];
    //[self.view addSubview:memView];
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    if (memView)
        [memView setListMode:p_dictData];
}

- (void) setEditMode
{
    if (memView)
        [memView setEditMode];
}

- (void) executeSave
{
    if (memView) 
        [memView executeSave];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    if (memView) 
        [memView performAfterSave:p_savedInfo];
}

- (void) executeCancel
{
    if (memView) 
        [memView executeCancel];
}

- (void) setPhotoNotifyMethod:(METHODCALLBACK) p_photoNotifyMethod
{
    _photoNotifyMethod = p_photoNotifyMethod;
}

- (void) newPhotoTaken:(NSDictionary*) photoInfo
{
    [memView newPhotoTaken:photoInfo];
}

@end
