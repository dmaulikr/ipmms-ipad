//
//  memberBaseController.m
//  iPMMS_iPad
//
//  Created by Imac DOM on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberBaseController.h"

@implementation memberBaseController

- (void) setActuallyIam:(NSString *)actuallyIam
{
    whoAmI = [NSString stringWithString:actuallyIam];
}

- (NSString*) actuallyIam
{
    return whoAmI;
    
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
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

- (void) setControllerCallBack:(METHODCALLBACK) p_controllerCallBack
{
    _controllerCallBack = p_controllerCallBack;
}

- (void) setNavigatorControllerCallBack:(METHODCALLBACK) p_navigatorCallBack
{
    _navigateControllerCallBack = p_navigatorCallBack;
}

- (void) setNavigatorButtonsCallBack:(METHODCALLBACK) p_naviButtonsCallBack
{
    _navigatorButtonsCallBack = p_naviButtonsCallBack;
}


@end
