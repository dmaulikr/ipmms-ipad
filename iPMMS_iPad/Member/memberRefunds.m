//
//  memberRefunds.m
//  iPMMS_iPad
//
//  Created by Macintosh User on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "memberRefunds.h"

@implementation memberRefunds

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)viewDidLoad
{
    [self setActuallyIam:@"Notes"];
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)==YES) 
        currOrientation = UIInterfaceOrientationPortrait;
    else
        currOrientation = UIInterfaceOrientationLandscapeLeft;
    myFrame = self.view.frame;
    myFrame.origin.y = 0;
    myFrame.origin.x = 0;
    memRefList = [[memberRefundsList alloc] initWithFrame:myFrame forOrientation:currOrientation andDictionary:nil andControllerCallBack:_controllerCallBack andNaviButtonsCallback:_navigatorButtonsCallBack];
    [self.view addSubview:memRefList];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [memRefList releaseViewObjects];
    [memRefList removeFromSuperview];
    memRefList = nil;
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
    if (memRefList) [memRefList setForOrientation:currOrientation];
    //[self setViewResizedForOrientation:toInterfaceOrientation];
}

- (void) setInsertMode
{
    if (memRefList) [memRefList setInsertMode];
}

- (void) setEmptyMode
{
    //NSLog(@"frame origin x %f origin y %f width %f and height %f", myframe.origin.x, myframe.origin.y, myframe.size.width, myframe.size.height);
    /*memNotesList = [[memberNotesList alloc] initWithDictionary:nil andFrame:myFrame andOrientation:currOrientation forMode:@"E"];
     [memNotesList setEmptyMode];
     [self.view addSubview:memNotesList];*/
}

- (void) setListMode:(NSDictionary*) p_dictData
{
    currDict = [NSDictionary dictionaryWithDictionary:p_dictData];
    //NSLog(@"the current dictionary set is %@", currDict);
    [memRefList setListMode:p_dictData];
}

- (void) setEditMode
{
    /*if (memView)
     [memView setEditMode];*/
    [memRefList setEditMode];
}

- (void) executeSave
{
    if (memRefList) 
        [memRefList executeSave];
}

- (void) performAfterSave:(NSDictionary *)p_savedInfo
{
    if (memRefList) 
        [memRefList performAfterSave:p_savedInfo];
}

- (void) executeCancel
{
    [memRefList executeCancel];
    /*if (memView) 
     [memView executeCancel];*/
}


@end
